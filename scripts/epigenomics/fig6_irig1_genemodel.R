library(ggplot2); library(data.table)

# IRAG1 gene model with regulatory features
CHR <- 11
TSS <- 10573091
TES <- 10693988

# Gene coordinates
gene_data <- data.frame(
  xmin = TSS, xmax = TES, ymin = 0.4, ymax = 0.6,
  label = "IRAG1/MRVI1"
)

# 4 promoters (PMID:21865585)
promoters <- data.frame(
  pos = c(10573091, 10605000, 10640000, 10675000),
  name = c("P1", "P2", "P3", "P4"),
  y = c(0.65, 0.65, 0.65, 0.65)
)

# rs4910165 + rs7940646
snps <- data.frame(
  pos = c(10652497, 10647681),
  name = c("rs4910165\n(PIP=0.999)", "rs7940646\n(lead pQTL)"),
  color = c("red", "blue")
)

# SuSiE credible set
susie_cs <- data.frame(
  xmin = 10647497, xmax = 10670000, ymin = 0.7, ymax = 0.75,
  label = "95% CS"
)

# Create plot
p <- ggplot() +
  # Gene body
  geom_rect(data=gene_data, aes(xmin=xmin/1e6, xmax=xmax/1e6, ymin=ymin, ymax=ymax), 
            fill="gray70", color="black") +
  # Promoters
  geom_segment(data=promoters, aes(x=pos/1e6, xend=pos/1e6, y=0.55, yend=0.7), 
               color="darkgreen", linewidth=1) +
  geom_point(data=promoters, aes(x=pos/1e6, y=0.72), color="darkgreen", size=3, shape=24, fill="darkgreen") +
  geom_text(data=promoters, aes(x=pos/1e6, y=0.78, label=name), size=3, color="darkgreen") +
  # SuSiE credible set
  geom_rect(data=susie_cs, aes(xmin=xmin/1e6, xmax=xmax/1e6, ymin=ymin, ymax=ymax),
            fill="gold", alpha=0.3, color="goldenrod", linetype="dashed") +
  geom_text(data=data.frame(x=(10647497+10670000)/2e6, y=0.78), aes(x=x, y=y), 
            label="SuSiE 95% CS", size=3, color="goldenrod") +
  # SNPs
  geom_vline(data=snps, aes(xintercept=pos/1e6, color=name), linewidth=1, linetype="dashed") +
  geom_text(data=snps, aes(x=pos/1e6, y=0.85, label=name, color=name), size=3, angle=90, vjust=0) +
  scale_color_manual(values=c("rs4910165\n(PIP=0.999)"="red", "rs7940646\n(lead pQTL)"="blue")) +
  # Gene label
  geom_text(data=gene_data, aes(x=(xmin+xmax)/2e6, y=(ymin+ymax)/2), 
            label="IRAG1 →", size=4, fontface="italic") +
  # Annotations
  annotate("text", x=10.62, y=0.3, label="cGMP-PKG substrate\nIP₃R-Ca²⁺ regulator\n4 promoters (PMID:21865585)\n9 isoforms (UniProt Q9Y6F6)", 
           size=2.8, hjust=0, color="gray40") +
  # Labs
  labs(
    title = "Fig. 6: Regulatory Architecture of the IRAG1/MRVI1 Locus",
    subtitle = sprintf("chr11:%.2f-%.2f Mb | coloc PP.H4=0.993 | SuSiE PIP=0.999",
                       TSS/1e6, TES/1e6),
    x = "Chromosome 11 (Mb)", y = ""
  ) +
  theme_minimal(base_size=12) +
  theme(
    legend.position = "none",
    plot.title = element_text(face="bold"),
    panel.grid.minor = element_blank(),
    axis.text.y = element_blank(),
    axis.ticks.y = element_blank()
  ) +
  ylim(0.2, 0.95) +
  xlim((TSS-20000)/1e6, (TES+20000)/1e6)

ggsave("/mnt/d/01_Projects/IRAG1_Migraine/results/Fig06_IRAG1_GeneModel.png", p, width=12, height=4, dpi=150)
cat("✅ Saved: Fig06_IRAG1_GeneModel.png\n")
