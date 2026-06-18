library(TwoSampleMR); library(data.table)
PLINK <- "/home/zhu/bin/plink"; REF <- "/mnt/d/00_Ref_data/1kg.v3/EUR"

cat("=== Vitamin D → IRAG1 MR ===\n\n")

# ---- 1. VD Exposure ----
cat("--- 1. Vitamin D ---\n")
vd <- fread(cmd="zcat < /mnt/d/01_Projects/GWAS_rawdata/VitaminD_GCST90000618_Revez2020_N496946.h.tsv.gz")
# Use standard columns: beta, standard_error, p_value, effect_allele, etc.
vd <- vd[grepl("^[ACGT]$", effect_allele) & grepl("^[ACGT]$", other_allele) & grepl("^rs[0-9]", hm_rsid)]
vd[, `:=`(CHR=as.integer(chromosome), POS=as.integer(base_pair_location),
          P=as.numeric(p_value), BETA=as.numeric(beta), SE=as.numeric(standard_error),
          EAF=as.numeric(effect_allele_frequency))]
vd <- vd[CHR %in% 1:22 & !is.na(BETA) & P>0 & P<1]
cat("VD SNPs:", nrow(vd), "\n")

vd_exp <- data.frame(
  SNP=vd$hm_rsid, beta.exposure=vd$BETA, se.exposure=vd$SE,
  effect_allele.exposure=vd$effect_allele, other_allele.exposure=vd$other_allele,
  pval.exposure=vd$P, eaf.exposure=vd$EAF, chr.exposure=vd$CHR,
  pos.exposure=vd$POS, samplesize.exposure=496946L, exposure="VitaminD")
rm(vd); gc()

vd_fmt <- format_data(vd_exp, type="exposure",
  snp_col="SNP", beta_col="beta.exposure", se_col="se.exposure",
  effect_allele_col="effect_allele.exposure", other_allele_col="other_allele.exposure",
  pval_col="pval.exposure", eaf_col="eaf.exposure",
  chr_col="chr.exposure", pos_col="pos.exposure",
  samplesize_col="samplesize.exposure", phenotype_col="VitaminD")

vd_fmt <- vd_fmt[vd_fmt$pval.exposure < 5e-8, ]
vd_fmt$chr_name <- vd_fmt$chr.exposure
vd_fmt$chrom_start <- vd_fmt$pos.exposure
cat("Sig SNPs:", nrow(vd_fmt), "→ ")

vd_inst <- clump_data(vd_fmt, bfile=REF, plink_bin=PLINK,
  clump_kb=10000, clump_r2=0.001, clump_p1=5e-8, pop="EUR")
cat(nrow(vd_inst), "instruments\n")

# ---- 2. IRAG1 ----
cat("\n--- 2. IRAG1 Outcome ---\n")
inst_rsids <- unique(vd_inst$SNP)
pattern <- paste(head(inst_rsids, 200), collapse="|")
irig1 <- fread(cmd=paste0("zcat < /mnt/d/01_Projects/GWAS_rawdata/decode/8255_34_MRVI1_MRVI1.txt.gz | grep -E '", pattern, "' || true"))
setnames(irig1, c("Chrom","Pos","Name","rsids","effectAllele","otherAllele","Beta","Pval","minus_log10_pval","SE","N","ImpMAF"))
irig1[, SNP := rsids]
irig1[SNP=="NA"|SNP==""|is.na(SNP), SNP:=Name]
irig1 <- irig1[SNP %in% inst_rsids & grepl("^[ACGT]$", effectAllele) & grepl("^[ACGT]$", otherAllele)]
cat("Matched:", nrow(irig1), "/", length(inst_rsids), "\n")

irig1_out <- format_data(data.frame(
  SNP=irig1$SNP, beta.outcome=as.numeric(irig1$Beta),
  se.outcome=as.numeric(irig1$SE), effect_allele.outcome=irig1$effectAllele,
  other_allele.outcome=irig1$otherAllele, pval.outcome=as.numeric(irig1$Pval),
  eaf.outcome=as.numeric(irig1$ImpMAF), chr.outcome=as.integer(gsub("[^0-9]","",irig1$Chrom)),
  pos.outcome=as.integer(irig1$Pos), samplesize.outcome=35559L, outcome="IRAG1"),
  type="outcome", snp_col="SNP", beta_col="beta.outcome", se_col="se.outcome",
  effect_allele_col="effect_allele.outcome", other_allele_col="other_allele.outcome",
  pval_col="pval.outcome", eaf_col="eaf.outcome", chr_col="chr.outcome",
  pos_col="pos.outcome", samplesize_col="samplesize.outcome")

# ---- 3. MR ----
cat("\n--- 3. MR ---\n")
dat <- harmonise_data(vd_inst, irig1_out, action=2)
cat("Harmonised:", nrow(dat), "\n")

mr_res <- mr(dat, method_list=c("mr_ivw_fe","mr_ivw_mre","mr_weighted_median","mr_egger_regression"))

cat("\n┌──────────────────────────────────────────┐\n")
cat("│ Vitamin D (Revez 2020, N=497K) → IRAG1\n├──────────────────────────────────────────┤\n")
for(i in 1:nrow(mr_res))
  cat(sprintf("│ %-23s b=%+.5f P=%.2e n=%d\n", mr_res$method[i], mr_res$b[i], mr_res$pval[i], mr_res$nsnp[i]))
cat("└──────────────────────────────────────────┘\n")
if(mr_res$pval[1] < 0.05) cat("\n✅ SIGNIFICANT\n") else cat("\n❌ NS\n")
