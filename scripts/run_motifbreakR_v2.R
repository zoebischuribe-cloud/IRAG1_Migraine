# motifbreakR v2 for rs4910165 — JASPAR2024 API fix
library(motifbreakR)
library(SNPlocs.Hsapiens.dbSNP155.GRCh38)
library(BSgenome.Hsapiens.UCSC.hg38)
library(JASPAR2024)

cat("=== motifbreakR: rs4910165 (IRAG1 intron, C->G) ===\n\n")

snps <- snps.from.rsid(rsid = "rs4910165",
  dbSNP = SNPlocs.Hsapiens.dbSNP155.GRCh38,
  search.genome = BSgenome.Hsapiens.UCSC.hg38)
cat(sprintf("SNP loaded: %d\n", length(snps)))

# JASPAR2024: use opts() for API v2
opts <- list(tax_group = "vertebrates", collection = "CORE")
motif_list <- getMatrixSet(JASPAR2024, opts)
cat(sprintf("JASPAR CORE motifs: %d\n", length(motif_list)))

# Run motifbreakR
results <- motifbreakR(
  snpList = snps,
  filterp = TRUE,
  pwmList = motif_list,
  threshold = 4e-4,
  method = "ic",
  BPPARAM = BiocParallel::SerialParam()
)
cat(sprintf("\nSignificant TF motif disruptions: %d\n\n", length(results)))

if (length(results) > 0) {
  df <- as.data.frame(results)
  df <- df[order(abs(df$effect), decreasing = TRUE), ]

  cat(sprintf("%-15s %-6s %-6s %10s %s\n", "TF", "Ref", "Alt", "effect", "P-value"))
  cat(strrep("-", 55), "\n")
  for (i in 1:min(nrow(df), 20)) {
    cat(sprintf("%-15s %-6s %-6s %+10.4f %.2e\n",
      df$geneSymbol[i], df$alleleRef[i], df$alleleAlt[i],
      df$effect[i], df$pvalue[i]))
  }

  # Vascular/platelet TF filter
  vascular <- c("MEF2A","MEF2B","MEF2C","MEF2D","SRF","GATA4","GATA6","ELK1","MYOCD","NFATC2","NFATC3")
  df_vasc <- df[df$geneSymbol %in% vascular, ]
  if (nrow(df_vasc) > 0) {
    cat("\n=== Vascular/Platelet TF hits ===\n")
    print(df_vasc[, c("geneSymbol","alleleRef","alleleAlt","effect","pvalue")])
  }

  write.csv(df, "D:/01_Projects/IRAG1_Migraine/results/rs4910165_motifbreakR.csv", row.names = FALSE)
  cat(sprintf("\nSaved: %d disruptions\n", nrow(df)))
} else {
  cat("No significant TF disruptions at P<4e-4\n")
  # Relaxed
  results2 <- motifbreakR(snpList = snps, filterp = TRUE, pwmList = motif_list,
    threshold = 1e-3, method = "ic", BPPARAM = BiocParallel::SerialParam())
  if (length(results2) > 0) {
    df2 <- as.data.frame(results2)
    cat(sprintf("Relaxed (P<1e-3): %d hits\n", nrow(df2)))
    print(head(df2[order(abs(df2$effect), decreasing = TRUE),
      c("geneSymbol","alleleRef","alleleAlt","effect","pvalue")], 10))
    write.csv(df2, "D:/01_Projects/IRAG1_Migraine/results/rs4910165_motifbreakR_relaxed.csv", row.names = FALSE)
  }
}

cat("\nDone\n")
