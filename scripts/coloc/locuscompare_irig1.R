library(data.table); library(ggplot2)

cat("=== IRAG1 × Migraine LocusCompare Plot ===\n\n")

# Load coloc data (same as coloc_v2.R)
CHR <- 11; TSS <- 10573091; WIN <- 500000

irig1 <- fread(cmd="zcat < /mnt/d/01_Projects/GWAS_rawdata/decode/8255_34_MRVI1_MRVI1.txt.gz")
irig1 <- irig1[Chrom=="chr11" & Pos>=TSS-WIN & Pos<=TSS+WIN]
irig1 <- irig1[grepl("^[ACGT]$",effectAllele) & grepl("^[ACGT]$",otherAllele)]
irig1[, `:=`(P=as.numeric(Pval), SNP=rsids)]
irig1[SNP=="NA"|SNP==""|is.na(SNP), SNP:=Name]
cat(sprintf("IRAG1 pQTL: %d SNPs\n", nrow(irig1)))

mig <- fread(cmd="zcat < /mnt/d/01_Projects/GWAS_rawdata/Migraine_G6-MIGRAINE_FinnGenR12_N401499.tsv.gz")
colnames(mig)[1] <- "chrom"
mig <- mig[chrom==CHR & pos>=TSS-WIN & pos<=TSS+WIN]
mig <- mig[grepl("^[ACGT]$",alt) & grepl("^[ACGT]$",ref)]
mig[, `:=`(P=as.numeric(pval), SNP=rsids)]
mig[SNP=="NA"|SNP==""|is.na(SNP), SNP:=paste0("chr",CHR,":",pos,":",ref,":",alt)]
cat(sprintf("Migraine: %d SNPs\n", nrow(mig)))

# Plot
p1 <- irig1[, .(Pos, P)]
p1$type <- "IRAG1 pQTL"
p2 <- mig[, .(pos, P)]
setnames(p2, "pos", "Pos")
p2$type <- "Migraine GWAS"
plot_dat <- rbind(p1, p2)
plot_dat[, logP := -log10(P)]
plot_dat <- plot_dat[logP > 0 & is.finite(logP)]

# Mark lead SNPs + coloc region
lead_pos <- 10647681  # rs7940646
susie_top <- 10652497  # rs4910165

cat(sprintf("Plotting %d points...\n", nrow(plot_dat)))

# Create publication-quality figure
p <- ggplot(plot_dat, aes(x=Pos/1e6, y=logP, color=type)) +
  geom_point(size=0.5, alpha=0.6) +
  geom_vline(xintercept=lead_pos/1e6, linetype="dashed", color="red", alpha=0.5) +
  geom_vline(xintercept=susie_top/1e6, linetype="dotted", color="blue", alpha=0.5) +
  scale_color_manual(values=c("IRAG1 pQTL"="#E41A1C", "Migraine GWAS"="#377EB8")) +
  labs(
    title="IRAG1/MRVI1 cis-pQTL × Migraine GWAS",
    subtitle=sprintf("chr11:%.2f-%.2f Mb | coloc PP.H4=0.993 | SuSiE CS1: rs4910165 PIP=0.999",
                     (TSS-WIN)/1e6, (TSS+WIN)/1e6),
    x="Chromosome 11 (Mb)", y="-log10(P)",
    caption="Red dashed: rs7940646 (lead cis-pQTL) | Blue dotted: rs4910165 (SuSiE top PIP)"
  ) +
  theme_bw(base_size=12) +
  theme(legend.position=c(0.85, 0.85),
        legend.background=element_rect(fill="white", color="black", linewidth=0.3),
        plot.title=element_text(face="bold"),
        plot.subtitle=element_text(size=9))

ggsave("/mnt/d/01_Projects/IRAG1_Migraine_LocusCompare.png", p, width=10, height=5, dpi=150)
cat("✅ Saved: D:/01_Projects/IRAG1_Migraine_LocusCompare.png\n")

# ---- Top SNPs table ----
cat("\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n")
cat(" Top SNPs in IRAG1 locus\n")
cat("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n")
cat(sprintf("%-20s %10s %12s %12s %12s\n", "SNP","Pos","pQTL -logP","GWAS -logP","Note"))
cat(paste(rep("-",70),collapse=""),"\n")

key_snps <- c("rs7940646", "rs4910165", "rs903823", "rs903822", "rs881869")
for (snp in key_snps) {
  pq_row <- irig1[SNP==snp]
  gw_row <- mig[SNP==snp]
  pq_lp <- if(nrow(pq_row)>0) sprintf("%.1f", -log10(pq_row$P[1])) else "—"
  gw_lp <- if(nrow(gw_row)>0) sprintf("%.1f", -log10(gw_row$P[1])) else "—"
  note <- if(snp=="rs7940646") "lead cis-pQTL" else if(snp=="rs4910165") "SuSiE CS1 (PIP=0.999)" else ""
  cat(sprintf("%-20s %10d %12s %12s %s\n", snp, if(nrow(pq_row)>0) pq_row$Pos[1] else NA, pq_lp, gw_lp, note))
}

cat("\n✅ Done:", format(Sys.time()), "\n")
