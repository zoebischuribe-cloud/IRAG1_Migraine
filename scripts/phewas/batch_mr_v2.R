library(TwoSampleMR); library(data.table)

cat("=== Batch MR v2: Modifiable Exposures → IRAG1 ===\n\n")

# ---- 1. IRAG1 outcome ----
cat("Loading IRAG1...\n")
irig1 <- fread(cmd="zcat < /mnt/d/01_Projects/GWAS_rawdata/decode/8255_34_MRVI1_MRVI1.txt.gz")
setnames(irig1, c("Chrom","Pos","Name","rsids","effectAllele","otherAllele","Beta","Pval","minus_log10_pval","SE","N","ImpMAF"))
irig1 <- irig1[grepl("^[ACGT]$",effectAllele) & grepl("^[ACGT]$",otherAllele)]
irig1[, `:=`(CHR=as.integer(gsub("[^0-9]","",Chrom)), POS=as.integer(Pos), SNP=rsids)]
irig1[SNP=="NA"|SNP==""|is.na(SNP), SNP:=Name]
irig1 <- irig1[CHR %in% 1:22 & Pval>0 & Pval<1]

irig1_out <- format_data(data.frame(
  SNP=irig1$SNP, beta.outcome=as.numeric(irig1$Beta), se.outcome=as.numeric(irig1$SE),
  effect_allele.outcome=irig1$effectAllele, other_allele.outcome=irig1$otherAllele,
  pval.outcome=as.numeric(irig1$Pval), eaf.outcome=as.numeric(irig1$ImpMAF),
  chr.outcome=irig1$CHR, pos.outcome=irig1$POS, samplesize.outcome=35559L, outcome="IRAG1"),
  type="outcome", snp_col="SNP", beta_col="beta.outcome", se_col="se.outcome",
  effect_allele_col="effect_allele.outcome", other_allele_col="other_allele.outcome",
  pval_col="pval.outcome", eaf_col="eaf.outcome", chr_col="chr.outcome",
  pos_col="pos.outcome", samplesize_col="samplesize.outcome")
cat("IRAG1 ready\n\n")

# ---- 2. Correctly identified exposures ----
exposures <- list(
  BMI = "ebi-a-GCST90095039",
  CRP = "ebi-a-GCST90029070",
  VitaminD = "ebi-a-GCST90025967",
  IGF1 = "ebi-a-GCST90025989",
  Testosterone = "ebi-a-GCST90014013",
  Estradiol = "ebi-a-GCST90020091",
  GripStrength = "ebi-a-GCST90014019",
  HeartRate = "ukb-a-3",
  SleepDuration = "ukb-a-9",
  Insomnia = "ukb-a-13",
  Neuroticism = "ebi-a-GCST90029028",
  Smoking = "ebi-a-GCST90029014",
  Coffee = "ebi-a-GCST90096914",
  WaistHip = "ebi-a-GCST90029009",
  HeelBMD = "ebi-a-GCST90029004",
  HDL = "ebi-a-GCST90092822",
  LDL_trig = "ebi-a-GCST90093051",
  Albumin = "ebi-a-GCST90092807",
  TotalProtein = "ebi-a-GCST90025995",
  DBP = "ebi-a-GCST90029010",
  SBP = "ebi-a-GCST90029011",
  PP = "ebi-a-GCST90018970",
  FastingGlucose = "ieu-b-114",
  FastingInsulin = "ebi-a-GCST90002238",
  HbA1c = "ebi-a-GCST90014006"
)

results <- list()
n_tested <- 0

for (nm in names(exposures)) {
  id <- exposures[[nm]]
  cat(sprintf("%-20s (%s) ... ", nm, id))
  
  exp_inst <- tryCatch({
    extract_instruments(outcomes=id, p1=5e-8, clump=TRUE, r2=0.001, kb=10000)
  }, error=function(e) NULL)
  
  if (is.null(exp_inst) || nrow(exp_inst) < 2) { cat("NO INST\n"); next }
  cat(nrow(exp_inst), "inst ")
  
  dat <- tryCatch(harmonise_data(exp_inst, irig1_out, action=2), error=function(e) NULL)
  if (is.null(dat) || nrow(dat) < 2) { cat("NO HARM\n"); next }
  cat(nrow(dat), "harm ")
  
  mr_res <- tryCatch(mr(dat, method_list=c("mr_ivw_fe","mr_ivw_mre")), error=function(e) NULL)
  if (is.null(mr_res)) { cat("MR FAIL\n"); next }
  
  ivw <- mr_res[mr_res$method == "Inverse variance weighted (fixed effects)", ]
  p <- ivw$pval[1]; b <- ivw$b[1]; nsnp <- ivw$nsnp[1]
  sig <- if(p < 0.05) "✅" else "  "
  cat(sprintf("b=%+.4f P=%.2e %s\n", b, p, sig))
  
  results[[nm]] <- list(id=id, n_inst=nrow(exp_inst), n_harm=nrow(dat), p=p, b=b, nsnp=nsnp)
  n_tested <- n_tested + 1
}

# Summary
cat(sprintf("\n\n═══════════════════════════════════════════\n"))
cat(sprintf("  Batch MR v2 Summary (%d exposures)\n", n_tested))
cat(sprintf("═══════════════════════════════════════════\n\n"))
cat(sprintf("%-20s %8s %6s %10s %12s %s\n", "Exposure","Instr","Harm","IVW beta","IVW P","Sig"))
cat(paste(rep("-",70),collapse=""),"\n")

sig_results <- list()
for (nm in names(results)) {
  r <- results[[nm]]
  s <- if(r$p < 0.05) "✅ SIG" else ""
  cat(sprintf("%-20s %8d %6d %+.5f     %.2e     %s\n", nm, r$n_inst, r$n_harm, r$b, r$p, s))
  if (r$p < 0.05) sig_results[[nm]] <- r
}

if (length(sig_results) > 0) {
  cat("\n\n## SIGNIFICANT (P<0.05):\n")
  for (nm in names(sig_results)) {
    r <- sig_results[[nm]]
    cat(sprintf("  ✅ %s: P=%.2e b=%+.4f instruments=%d\n", nm, r$p, r$b, r$n_inst))
  }
} else {
  cat("\n⚠️ No significant exposures found\n")
}
