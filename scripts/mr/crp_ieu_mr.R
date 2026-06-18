library(TwoSampleMR); library(data.table)

cat("=== CRP → IRAG1 (IEU clumping) ===\n\n")

# Step 1: IEU instruments (same as batch MR)
cat("--- 1. IEU instruments ---\n")
crp_inst <- extract_instruments(outcomes="ebi-a-GCST90029070", p1=5e-8, clump=TRUE, r2=0.001, kb=10000)
cat("Instruments:", nrow(crp_inst), "\n")

# Step 2: IRAG1 outcome
cat("\n--- 2. IRAG1 ---\n")
inst_rsids <- unique(crp_inst$SNP)
pattern <- paste(head(inst_rsids, 300), collapse="|")
irig1 <- fread(cmd=paste0("zcat < /mnt/d/01_Projects/GWAS_rawdata/decode/8255_34_MRVI1_MRVI1.txt.gz | grep -E '", pattern, "' || true"))
setnames(irig1, c("Chrom","Pos","Name","rsids","effectAllele","otherAllele","Beta","Pval","minus_log10_pval","SE","N","ImpMAF"))
irig1[, SNP := rsids]; irig1[SNP=="NA"|SNP==""|is.na(SNP), SNP:=Name]
irig1 <- irig1[SNP %in% inst_rsids & grepl("^[ACGT]$",effectAllele) & grepl("^[ACGT]$",otherAllele)]
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

# Step 3: MR
cat("\n--- 3. MR ---\n")
dat <- harmonise_data(crp_inst, irig1_out, action=2)
cat("Harmonised:", nrow(dat), "\n")

mr_res <- mr(dat, method_list=c("mr_ivw_fe","mr_ivw_mre","mr_weighted_median","mr_egger_regression"))

cat("\n┌──────────────────────────────────────────┐\n")
cat("│ CRP (IEU clumping, Said 2022 N=576K) → IRAG1\n├──────────────────────────────────────────┤\n")
for(i in 1:nrow(mr_res))
  cat(sprintf("│ %-23s b=%+.5f P=%.2e n=%d\n", mr_res$method[i], mr_res$b[i], mr_res$pval[i], mr_res$nsnp[i]))
cat("└──────────────────────────────────────────┘\n")
if(mr_res$pval[1] < 0.05) cat("\n✅ CRP → IRAG1 SIGNIFICANT\n") else cat("\n❌ NS\n")
