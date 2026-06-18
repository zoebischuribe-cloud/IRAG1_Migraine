# Fig 1: Study Design Overview — IRAG1_Migraine
# Nature Genetics style schematic
library(ggplot2); library(grid); library(data.table)

OUTDIR <- "/mnt/d/01_Projects/IRAG1_Migraine/results/figures"
dir.create(OUTDIR, showWarnings=FALSE, recursive=TRUE)

# ---- Build the study design as a layered diagram using grid ----

pdf(file.path(OUTDIR, "Fig1_study_design.pdf"), width=10, height=7.5)
png(file.path(OUTDIR, "Fig1_study_design.png"), width=10, height=7.5, units="in", res=300)

# Layout: 4 rows (Phases), each with multiple boxes
grid.newpage()

# ---- Color palette ----
col_phase  <- "#2166AC"   # dark blue for phase labels
col_data   <- "#F4A582"   # warm orange for data sources
col_method <- "#92C5DE"   # light blue for methods
col_result <- "#0571B0"   # deep blue for results
col_arrow  <- "#B2182B"   # red for key arrow
col_bg     <- "#F7F7F7"   # light grey bg
col_text   <- "#333333"
col_border <- "#999999"

# ---- Helper: draw a rounded box with text ----
draw_box <- function(x, y, w, h, label, fill=col_bg, border=col_border,
                     text_col=col_text, fontsize=10, bold=FALSE, just="center") {
  fontface <- if(bold) "bold" else "plain"
  grid.roundrect(x=x, y=y, width=w, height=h, r=unit(3,"pt"),
                 gp=gpar(fill=fill, col=border, lwd=1))
  grid.text(label, x=x, y=y, gp=gpar(fontsize=fontsize, col=text_col,
                                      fontface=fontface), just=just)
}

draw_arrow <- function(x0, y0, x1, y1, col="#666666", lwd=1.5) {
  grid.segments(x0=x0, y0=y0, x1=x1, y1=y1,
                arrow=arrow(length=unit(3,"pt"), type="closed"),
                gp=gpar(col=col, lwd=lwd, fill=col))
}

draw_label <- function(x, y, label, col=col_text, fontsize=10, bold=FALSE, just="left") {
  fontface <- if(bold) "bold" else "plain"
  grid.text(label, x=x, y=y, gp=gpar(fontsize=fontsize, col=col, fontface=fontface), just=just)
}

# ---- Phase labels (left margin) ----
phases <- c("Phase 1\nMR Step 1", "Phase 2\nMR Step 2", "Phase 3\nFunctional\nCharacterization", "Phase 4\nTranslational\nAssessment")
phase_y <- c(0.90, 0.65, 0.38, 0.14)
for(i in seq_along(phases)) {
  draw_box(0.08, phase_y[i], 0.12, 0.10, phases[i],
           fill=col_phase, border=col_phase, text_col="white", fontsize=8, bold=TRUE)
}

# ---- Title ----
draw_label(0.50, 0.98, "Two-Stage Proteome-Wide Mendelian Randomization for Migraine Drug Target Discovery",
           col=col_text, fontsize=14, bold=TRUE, just="center")

# ============================================================
# PHASE 1: CRP → Plasma Proteome
# ============================================================
y1 <- 0.90

# Exposure box
draw_box(0.25, y1, 0.14, 0.07, "CRP\n(575,531)", fill=col_data, border=col_data, text_col="white", fontsize=7, bold=TRUE)
# Arrow
draw_arrow(0.33, y1, 0.40, y1, col=col_arrow, lwd=2)
# Methods
draw_box(0.48, y1, 0.16, 0.07, "IVW MR\n+ 4 sensitivity tests", fill=col_method, fontsize=7)
draw_arrow(0.57, y1, 0.64, y1)
# Outcome
draw_box(0.73, y1, 0.16, 0.07, "4,907 plasma proteins\n(deCODE, N=35,559)", fill=col_data, border=col_data, text_col="white", fontsize=7, bold=TRUE)
# Result
draw_box(0.48, y1-0.07, 0.40, 0.04, "1,213 BMI-driven proteins → IRAG1 elevated by CRP (P=0.037)", fill=col_result, border=col_result, text_col="white", fontsize=7)
# Arrow down
draw_arrow(0.48, y1-0.09, 0.48, y1-0.11, col=col_arrow, lwd=1.5)

# ============================================================
# PHASE 2: IRAG1 → Migraine
# ============================================================
y2 <- 0.65

# Key: cis-only strategy
draw_label(0.25, y2+0.06, "cis-pQTLs only (±1Mb TSS, single-protein)", fontsize=7, bold=TRUE, col=col_arrow)
# Exposure
draw_box(0.25, y2, 0.14, 0.07, "IRAG1 pQTL\n(deCODE)", fill=col_data, border=col_data, text_col="white", fontsize=7, bold=TRUE)
draw_arrow(0.33, y2, 0.40, y2, col=col_arrow, lwd=2)
# Methods
draw_box(0.48, y2, 0.16, 0.07, "IVW MR\ncis-only instruments", fill=col_method, fontsize=7)
draw_arrow(0.57, y2, 0.64, y2)
# Outcome
draw_box(0.73, y2, 0.16, 0.07, "Migraine\n(FinnGen R12, N=401,499)", fill=col_data, border=col_data, text_col="white", fontsize=7, bold=TRUE)
# Result
draw_box(0.48, y2-0.07, 0.40, 0.04, "β=-0.558, P=5.84×10⁻¹¹ (protective)", fill=col_result, border=col_result, text_col="white", fontsize=7)
draw_arrow(0.48, y2-0.09, 0.48, y2-0.11, col=col_arrow, lwd=1.5)

# Coloc + Fine-mapping result
draw_box(0.48, y2-0.13, 0.40, 0.04, "Colocalization PP.H4=0.993 · SuSiE rs4910165 PIP=0.999", fill=col_result, border=col_result, text_col="white", fontsize=7)

# ============================================================
# PHASE 3: Functional Characterization (3 sub-panels)
# ============================================================
y3 <- 0.38

# Sub-panel A: Epigenomics
draw_box(0.22, y3+0.06, 0.18, 0.11,
         "Epigenomics\nrs4910165: DNase I HS\nH3K27ac⁺ vascular SMC\nIRAG1: 9 isoforms, 4 promoters\nPRKG1 + ITPR1 domains",
         fill=col_method, fontsize=6)
# Sub-panel B: scRNA-seq
draw_box(0.42, y3+0.06, 0.18, 0.11,
         "Single-Cell Expression\nVSMC: ⭐⭐⭐⭐⭐\nPlatelets: ⭐⭐⭐⭐⭐\nBrain: vascular > neuronal\ncGMP-PKG-IP₃R-Ca²⁺ axis",
         fill=col_method, fontsize=6)
# Sub-panel C: Validation
draw_box(0.62, y3+0.06, 0.18, 0.11,
         "Domain-Aware MR\nFull-length IRAG1 protective\nPRKG1 + ITPR1 domains retained\nMonogenic: MRVI1→achalasia\nLou 2024: independent replication",
         fill=col_method, fontsize=6)

# Bottom result
draw_box(0.42, y3-0.10, 0.38, 0.04, "Convergent evidence: IRAG1 regulates vascular Ca²⁺ homeostasis via cGMP-PKG-IP₃R axis", fill=col_result, border=col_result, text_col="white", fontsize=7)

# ============================================================
# PHASE 4: Translational Assessment
# ============================================================
y4 <- 0.14

draw_box(0.22, y4+0.06, 0.18, 0.11,
         "Safety (PheWAS)\nrs4910165: no adverse traits\nLipid effects: non-significant\nGWAS Catalog: 21 associations\nall P > 1×10⁻⁵ for harm",
         fill=col_method, fontsize=6)
draw_box(0.42, y4+0.06, 0.18, 0.11,
         "Druggability\nIRAG1: FIRST-IN-CLASS\ncGMP-PKG pathway: drugged\nPDE5i + sGC stim: approved\nNeed: IRAG1-ITPR1 stabilizer",
         fill=col_method, fontsize=6)
draw_box(0.62, y4+0.06, 0.18, 0.11,
         "Clinical Feasibility\n~30% migraine patients\ninadequately served by CGRP\nMechanistically distinct\nLarge unmet need",
         fill=col_method, fontsize=6)
draw_box(0.42, y4-0.05, 0.38, 0.05, "IRAG1 = Genetically Validated First-in-Class Migraine Drug Target ★★★★★",
         fill="#B2182B", border="#B2182B", text_col="white", fontsize=8, bold=TRUE)

# ---- Arrows between phases ----
draw_arrow(0.48, y1-0.12, 0.48, y2+0.09, col=col_arrow, lwd=2)
draw_arrow(0.48, y2-0.15, 0.48, y3+0.09, col=col_arrow, lwd=2)
draw_arrow(0.48, y3-0.12, 0.48, y4+0.09, col=col_arrow, lwd=2)

# ---- Connecting lines for Phase 3 sub-panels ----
draw_arrow(0.31, y3+0.02, 0.36, y3+0.02, col="#666", lwd=0.8)
draw_arrow(0.51, y3+0.02, 0.56, y3+0.02, col="#666", lwd=0.8)

# ---- Legend (bottom-left) ----
draw_box(0.08, 0.03, 0.10, 0.025, "", fill=col_data, border=col_data)
draw_label(0.135, 0.03, "Data source", fontsize=6)
draw_box(0.24, 0.03, 0.10, 0.025, "", fill=col_method)
draw_label(0.305, 0.03, "Method / Analysis", fontsize=6)
draw_box(0.42, 0.03, 0.10, 0.025, "", fill=col_result, border=col_result)
draw_label(0.485, 0.03, "Key result", fontsize=6)

# ---- Citation line ----
draw_label(0.98, 0.01, "Template: Yoshiji et al. 2025, Nat Genet 57:345-357  |  Win_CC 2026",
           fontsize=5, col="#999999", just="right")

dev.off()
dev.off()

cat("Fig 1 saved to:", OUTDIR, "\n")
cat("  Fig1_study_design.pdf\n")
cat("  Fig1_study_design.png\n")
