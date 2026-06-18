library(TwoSampleMR); library(data.table)

cat("=== IRAG1→Migraine 敏感性分析 ===\n\n")

# ---- Load IRAG1 instruments ----
irig1 <- fread(cmd="zcat < /mnt/d/01_Projects/GWAS_rawdata/decode/8255_34_MRVI1_MRVI1.txt.gz")
irig1 <- irig1[grepl("^[ACGT]$",effectAllele) & grepl("^[ACGT]$",otherAllele)]
irig1[, `:=`(SNP=rsids, BETA=as.numeric(Beta), SE=as.numeric(SE), P=as.numeric(Pval),
             CHR=as.integer(gsub("[^0-9]","",Chrom)), POS=as.integer(Pos),
             EAF=as.numeric(ImpMAF), N=as.integer(N))]
irig1[SNP=="NA"|SNP==""|is.na(SNP), SNP:=Name]
irig1 <- irig1[CHR %in% 1:22 & P>0 & P<1]

# Clump cis-pQTL
PLINK <- "/home/zhu/bin/plink"; REF <- "/mnt/d/00_Ref_data/1kg.v3/EUR"
irig1_exp <- format_data(data.frame(
  SNP=irig1$SNP, beta.exposure=irig1$BETA, se.exposure=irig1$SE,
  effect_allele.exposure=irig1$effectAllele, other_allele.exposure=irig1$otherAllele,
  pval.exposure=irig1$P, eaf.exposure=irig1$EAF, chr.exposure=irig1$CHR,
  pos.exposure=irig1$POS, samplesize.exposure=35559L, exposure="IRAG1"),
  type="exposure", snp_col="SNP", beta_col="beta.exposure", se_col="se.exposure",
  effect_allele_col="effect_allele.exposure", other_allele_col="other_allele.exposure",
  pval_col="pval.exposure", eaf_col="eaf.exposure", chr_col="chr.exposure",
  pos_col="pos.exposure", samplesize_col="samplesize.exposure")

irig1_exp <- irig1_exp[irig1_exp$pval.exposure < 5e-8, ]
irig1_exp$chr_name <- irig1_exp$chr.exposure
irig1_exp$chrom_start <- irig1_exp$pos.exposure
cat("Sig SNPs:", nrow(irig1_exp), "→ ")

irig1_inst <- clump_data(irig1_exp, bfile=REF, plink_bin=PLINK, clump_kb=10000, clump_r2=0.001, clump_p1=5e-8, pop="EUR")
cat(nrow(irig1_inst), "instruments\n")

# ---- Load Migraine outcome ----
mig <- fread(cmd="zcat < /mnt/d/01_Projects/GWAS_rawdata/Migraine_G6-MIGRAINE_FinnGenR12_N401499.tsv.gz")
colnames(mig)[1] <- "chrom"
mig <- mig[grepl("^[ACGT]$",alt) & grepl("^[ACGT]$",ref)]
mig[, `:=`(SNP=rsids, BETA=as.numeric(beta), SE=as.numeric(sebeta), P=as.numeric(pval),
           CHR=as.integer(chrom), POS=as.integer(pos), EAF=as.numeric(af_alt))]
mig[SNP=="NA"|SNP==""|is.na(SNP), SNP:=paste0("chr",CHR,":",POS,":",ref,":",alt)]

# Match instruments
inst_snps <- unique(irig1_inst$SNP)
mig_match <- mig[SNP %in% inst_snps]
cat("Matched outcome SNPs:", nrow(mig_match), "\n\n")

mig_out <- format_data(data.frame(
  SNP=mig_match$SNP, beta.outcome=mig_match$BETA, se.outcome=mig_match$SE,
  effect_allele.outcome=mig_match$alt, other_allele.outcome=mig_match$ref,
  pval.outcome=mig_match$P, eaf.outcome=mig_match$EAF,
  chr.outcome=mig_match$CHR, pos.outcome=mig_match$POS,
  samplesize.outcome=401499L, outcome="Migraine"),
  type="outcome", snp_col="SNP", beta_col="beta.outcome", se_col="se.outcome",
  effect_allele_col="effect_allele.outcome", other_allele_col="other_allele.outcome",
  pval_col="pval.outcome", eaf_col="eaf.outcome", chr_col="chr.outcome",
  pos_col="pos.outcome")

# ---- Harmonise + MR ----
dat <- harmonise_data(irig1_inst, mig_out, action=2)
cat("Harmonised:", nrow(dat), "SNPs\n\n")

# 1. MR analysis
mr_res <- mr(dat, method_list=c("mr_ivw_fe","mr_ivw_mre","mr_weighted_median","mr_egger_regression"))
cat("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n")
cat(" 1. MR RESULTS\n")
cat("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n")
for(i in 1:nrow(mr_res))
  cat(sprintf(" %-25s b=%+.4f se=%.4f P=%.2e nsnp=%d\n", mr_res$method[i], mr_res$b[i], mr_res$se[i], mr_res$pval[i], mr_res$nsnp[i]))

# 2. Heterogeneity
cat("\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n")
cat(" 2. HETEROGENEITY (Cochran's Q)\n")
cat("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n")
hetero <- mr_heterogeneity(dat)
for(i in 1:nrow(hetero))
  cat(sprintf(" %-25s Q=%.2f df=%d P=%.2e %s\n", hetero$method[i], hetero$Q[i], hetero$Q_df[i], hetero$Q_pval[i],
      if(hetero$Q_pval[i]>0.05) "✅ No heterogeneity" else "⚠️ Significant heterogeneity"))

# 3. Pleiotropy
cat("\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n")
cat(" 3. PLEIOTROPY (MR-Egger intercept)\n")
cat("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n")
pleio <- mr_pleiotropy_test(dat)
cat(sprintf(" Intercept=%.4f SE=%.4f P=%.2e %s\n", pleio$egger_intercept[1], pleio$se[1], pleio$pval[1],
    if(pleio$pval[1]>0.05) "✅ No directional pleiotropy" else "⚠️ Significant pleiotropy"))

# 4. Steiger directionality
cat("\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n")
cat(" 4. STEIGER DIRECTIONALITY\n")
cat("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n")
steiger <- directionality_test(dat)
cat(sprintf(" Correct direction: %s\n", if(steiger$correct_causal_direction[1]) "✅ Protein→Disease" else "⚠️ Disease→Protein"))
cat(sprintf(" Steiger P: %.2e\n", steiger$steiger_pval[1]))

# 5. F-statistic
cat("\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n")
cat(" 5. INSTRUMENT STRENGTH\n")
cat("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n")
dat_keep <- dat[dat$mr_keep==TRUE, ]
f_stats <- (dat_keep$beta.exposure / dat_keep$se.exposure)^2
cat(sprintf(" Mean F-statistic: %.1f\n", mean(f_stats)))
cat(sprintf(" Min F-statistic:  %.1f\n", min(f_stats)))
cat(sprintf(" %s (F>10 = strong instruments)\n", if(mean(f_stats)>10) "✅ Strong instruments" else "⚠️ Weak"))

# 6. Single SNP
cat("\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n")
cat(" 6. SINGLE SNP (leave-one-out)\n")
cat("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n")
singlesnp <- mr_singlesnp(dat)
for(i in 1:min(nrow(singlesnp), 10))
  cat(sprintf(" %-20s b=%+.4f P=%.2e\n", singlesnp$SNP[i], singlesnp$b[i], singlesnp$p[i]))

cat("\n✅ Sensitivity complete:", format(Sys.time()), "\n")
