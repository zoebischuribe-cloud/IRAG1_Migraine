# ============================================================
# motifbreakR for rs4910165 (IRAG1) — Windows R-4.5.3
# Run in: Windows RStudio or Rscript.exe
# Output: D:\01_Projects\IRAG1_Migraine\results\
# ============================================================

# ---- 0. Setup ----
setwd("D:/01_Projects/IRAG1_Migraine")
.libPaths(c(
  "D:/QTLMR/R-4.5.3/library",
  .libPaths()
))

# Install if needed (first run only)
if (!require("BiocManager", quietly=TRUE)) install.packages("BiocManager", repos="https://cloud.r-project.org")

bioc_pkgs <- c("motifbreakR", "SNPlocs.Hsapiens.dbSNP155.GRCh38", 
               "BSgenome.Hsapiens.UCSC.hg38", "JASPAR2024")
for (pkg in bioc_pkgs) {
  if (!require(pkg, character.only=TRUE, quietly=TRUE)) {
    BiocManager::install(pkg, update=FALSE, ask=FALSE)
  }
}

library(motifbreakR)
library(SNPlocs.Hsapiens.dbSNP155.GRCh38)
library(BSgenome.Hsapiens.UCSC.hg38)
library(JASPAR2024)

cat("=== motifbreakR: rs4910165 (IRAG1 intron, C→G) ===\n\n")

# ---- 1. Get SNP flanking sequence ----
snps <- snps.from.rsid(
  rsid = "rs4910165",
  dbSNP = SNPlocs.Hsapiens.dbSNP155.GRCh38,
  search.genome = BSgenome.Hsapiens.UCSC.hg38
)
cat("SNP loaded:", length(snps), "\n")

# ---- 2. Get JASPAR vertebrate motifs ----
jaspar_motifs <- getMatrixSet(
  JASPAR2024, 
  list(tax_group = "vertebrates")
)
cat("JASPAR motifs:", length(jaspar_motifs), "\n")

# ---- 3. Run motifbreakR ----
results <- motifbreakR(
  snpList = snps,
  filterp = TRUE,
  pwmList = jaspar_motifs,
  threshold = 4e-4,
  method = "ic",
  BPPARAM = BiocParallel::SerialParam()
)

cat("\nSignificant TF motif disruptions:", length(results), "\n\n")

# ---- 4. Export results ----
if (length(results) > 0) {
  df <- as.data.frame(results)
  df <- df[order(abs(df$effect), decreasing=TRUE), ]
  
  cat(sprintf("%-15s %-12s %-10s %-10s %s\n", "TF", "Ref", "Alt", "Δscore", "P-value"))
  cat(rep("-",65), "\n")
  for (i in 1:min(nrow(df), 20)) {
    cat(sprintf("%-15s %-12s %-10s %+.4f    %.2e\n",
        df$geneSymbol[i], df$alleleRef[i], df$alleleAlt[i],
        df$effect[i], df$pvalue[i]))
  }
  
  write.csv(df, "results/rs4910165_motifbreakR_full.csv", row.names=FALSE)
  cat("\n✅ Saved:", nrow(df), "motif disruptions\n\n")
  
  # Filter for vascular/platelet TFs
  vascular_tfs <- c("MEF2A","MEF2B","MEF2C","MEF2D","SRF","GATA4","GATA6","ELK1","MYOCD")
  df_vasc <- df[df$geneSymbol %in% vascular_tfs, ]
  if (nrow(df_vasc) > 0) {
    cat("=== Vascular/Platelet TF hits ===\n")
    print(df_vasc[, c("geneSymbol","alleleRef","alleleAlt","effect","pvalue")])
  }
  
  # ---- 5. Generate motif logo plot ----
  if (nrow(df) > 0) {
    top_hits <- head(df, 9)
    pdf("results/rs4910165_motifbreakR_logos.pdf", width=12, height=9)
    plotMB(results[results$geneSymbol %in% top_hits$geneSymbol])
    dev.off()
    cat("✅ Logo plot saved: results/rs4910165_motifbreakR_logos.pdf\n")
  }
} else {
  cat("⚠️ No significant TF motif disruptions found\n")
  cat("This is valid — the SNP may act through chromatin structure, not direct TF binding\n")
  
  # Try relaxed threshold
  results_relaxed <- motifbreakR(
    snpList = snps,
    filterp = TRUE,
    pwmList = jaspar_motifs,
    threshold = 1e-3,   # relaxed
    method = "ic",
    BPPARAM = BiocParallel::SerialParam()
  )
  df_r <- as.data.frame(results_relaxed)
  df_r <- df_r[order(abs(df_r$effect), decreasing=TRUE), ]
  cat("\nRelaxed threshold (P<1e-3):", nrow(df_r), "hits\n")
  write.csv(df_r, "results/rs4910165_motifbreakR_relaxed.csv", row.names=FALSE)
  print(head(df_r[, c("geneSymbol","alleleRef","alleleAlt","effect","pvalue")], 10))
}

cat("\n✅ Done:", format(Sys.time()), "\n")
