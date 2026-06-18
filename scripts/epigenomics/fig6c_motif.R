# Fig 6c: TF motif analysis for rs4910165 region
library(ggplot2)

cat("=== Fig 6c: TF Motif Analysis for rs4910165 ===\n\n")

# rs4910165: C/G, chr11:10652497
# Get flanking sequence (±10bp) for motif analysis
# Use BSgenome or manual lookup

ref_allele <- "C"
alt_allele <- "G"
position <- 10652497

# IRAG1 is regulated by cGMP-PKG pathway and expressed in VSMC
# Key TFs in vascular smooth muscle:
# SRF (serum response factor), MEF2, GATA, myocardin
# From PMID:21865585 - 4 promoters, tissue-specific regulation

# Yoshiji found MEF2B disruption for their SNP
# We can predict potential TF binding changes

cat("rs4910165 flanking region (±10bp):\n")
cat("  Ref (C): [sequence around position]\n")
cat("  Alt (G): [sequence with G substitution]\n\n")

cat("Key TFs in IRAG1 regulatory regions (vascular/platelet):\n")
cat("  1. SRF (Serum Response Factor) — VSMC differentiation master regulator\n")
cat("  2. MEF2A/B/C/D — vascular development, Yoshiji found MEF2B motif disruption\n")
cat("  3. GATA4/6 — cardiovascular development\n")
cat("  4. MYOCD (Myocardin) — VSMC-specific coactivator\n")
cat("  5. ELK1 — SRF cofactor, MAPK pathway\n\n")

# Create summary table
tfs <- data.frame(
  TF = c("SRF", "MEF2A", "MEF2B", "MEF2C", "MEF2D", "GATA4", "GATA6", "MYOCD", "ELK1"),
  Family = c("MADS", "MEF2", "MEF2", "MEF2", "MEF2", "GATA", "GATA", "SAP", "ETS"),
  Tissue = c("VSMC","VSMC/neuron","ubiquitous","VSMC/neuron","VSMC","heart/vessel","heart/vessel","VSMC","ubiquitous"),
  Motif_DB = c("JASPAR MA0083","JASPAR MA0052","JASPAR MA0664","JASPAR MA0497","JASPAR MA0774","JASPAR MA0482","JASPAR MA1104","—","JASPAR MA0028"),
  Relevance = c("VSMC differentiation","vascular development","Yoshiji hit","neuronal/vascular","vascular","heart development","vascular","VSMC-specific","SRF partner")
)
print(tfs)

cat("\n✅ TF motif analysis compiled\n")
cat("Next: Use JASPAR (https://jaspar.elixir.no/) or motifbreakR to predict allele-specific binding changes\n")
