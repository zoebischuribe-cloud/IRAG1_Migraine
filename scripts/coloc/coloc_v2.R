library(data.table); library(coloc); library(susieR)

cat("=== IRAG1 × Migraine — Coloc + SuSiE ===\n\n")
CHR <- 11; TSS <- 10573091; WIN <- 500000

# Load
irig1 <- fread(cmd="zcat < /mnt/d/01_Projects/GWAS_rawdata/decode/8255_34_MRVI1_MRVI1.txt.gz")
irig1 <- irig1[Chrom=="chr11" & Pos>=TSS-WIN & Pos<=TSS+WIN]
irig1 <- irig1[grepl("^[ACGT]$",effectAllele) & grepl("^[ACGT]$",otherAllele)]
irig1[, `:=`(SNP=rsids, BETA=as.numeric(Beta), SE=as.numeric(SE), P=as.numeric(Pval),
             MAF=pmin(as.numeric(ImpMAF),1-as.numeric(ImpMAF)), N=as.integer(N))]
irig1[SNP=="NA"|SNP==""|is.na(SNP), SNP:=Name]
cat(sprintf("IRAG1 pQTL: %d SNPs | Median N=%d\n", nrow(irig1), median(irig1$N,na.rm=TRUE)))

mig <- fread(cmd="zcat < /mnt/d/01_Projects/GWAS_rawdata/Migraine_G6-MIGRAINE_FinnGenR12_N401499.tsv.gz")
colnames(mig)[1] <- "chrom"
mig <- mig[chrom==CHR & pos>=TSS-WIN & pos<=TSS+WIN]
mig <- mig[grepl("^[ACGT]$",alt) & grepl("^[ACGT]$",ref)]
mig[, `:=`(SNP=rsids, BETA=as.numeric(beta), SE=as.numeric(sebeta), P=as.numeric(pval),
           MAF=pmin(as.numeric(af_alt),1-as.numeric(af_alt)))]
mig[SNP=="NA"|SNP==""|is.na(SNP), SNP:=paste0("chr",CHR,":",pos,":",ref,":",alt)]
cat(sprintf("Migraine: %d SNPs\n", nrow(mig)))

# Merge
m <- merge(irig1[, .(Pos, SNP_pqtl=SNP, ea=effectAllele, oa=otherAllele, B1=BETA, SE1=SE, P1=P, MAF1=MAF, N1=N)],
           mig[, .(pos, SNP_gwas=SNP, B2=BETA, SE2=SE, P2=P, MAF2=MAF)],
           by.x="Pos", by.y="pos")
cat(sprintf("Merged: %d SNPs\n", nrow(m)))

# Dedup
m <- m[!duplicated(SNP_pqtl) & !duplicated(SNP_gwas)]
cat(sprintf("After dedup: %d\n", nrow(m)))

# Filter complete
m <- m[!is.na(B1) & !is.na(SE1) & !is.na(B2) & !is.na(SE2) & SE1>0 & SE2>0 & MAF1>0 & MAF1<0.5]
cat(sprintf("Complete: %d\n", nrow(m)))

# Coloc
d1 <- list(pvalues=m$P1, N=median(m$N1,na.rm=TRUE), MAF=m$MAF1, type="quant", snp=m$SNP_pqtl,
           beta=m$B1, varbeta=m$SE1^2)
d2 <- list(pvalues=m$P2, N=401499L, MAF=m$MAF2, type="cc", snp=m$SNP_gwas,
           beta=m$B2, varbeta=m$SE2^2, s=44616/401499)

cr <- coloc.abf(dataset1=d1, dataset2=d2)

cat("\n┌──────────────────────────────────────────┐\n")
cat("│ COLOC: IRAG1 pQTL × Migraine\n├──────────────────────────────────────────┤\n")
for (h in c("PP.H0.abf","PP.H1.abf","PP.H2.abf","PP.H3.abf","PP.H4.abf"))
  cat(sprintf("│ %-30s = %.4f\n", h, cr$summary[h]))
cat(sprintf("│ %-30s %s\n", "VERDICT", if(cr$summary["PP.H4.abf"]>0.8) "✅ COLOCALIZED!" else "❌"))
cat("└──────────────────────────────────────────┘\n")

# SuSiE
pqtl_z <- m$B1 / m$SE1
valid <- !is.na(pqtl_z) & is.finite(pqtl_z)
z <- pqtl_z[valid]
cat(sprintf("\nSuSiE: %d SNPs\n", length(z)))

if (length(z) > 10) {
  sr <- susie_rss(z=z, R=diag(length(z)), n=as.integer(median(m$N1,na.rm=TRUE)),
                  L=min(10, ceiling(length(z)/100)), coverage=0.95, estimate_residual_variance=TRUE)
  if (length(sr$sets$cs) > 0) {
    cat(sprintf("Credible sets: %d\n", length(sr$sets$cs)))
    for (i in seq_along(sr$sets$cs)) {
      idx <- sr$sets$cs[[i]]
      top <- idx[which.max(sr$pip[idx])]
      cat(sprintf("  CS%d: %d SNPs | Top: %s PIP=%.3f Pos=%d\n",
                  i, length(idx), m$SNP_pqtl[valid][top], sr$pip[top], m$Pos[valid][top]))
    }
  }
  # Top PIPs
  ord <- order(sr$pip, decreasing=TRUE)
  cat("\nTop 5 PIPs:\n")
  for (i in ord[1:5]) if(sr$pip[i]>0.01) 
    cat(sprintf("  %s PIP=%.4f Pos=%d\n", m$SNP_pqtl[valid][i], sr$pip[i], m$Pos[valid][i]))
}

cat("\n✅ Done:", format(Sys.time()), "\n")
