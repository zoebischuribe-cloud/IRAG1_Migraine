library(TwoSampleMR)
args <- commandArgs(trailingOnly=TRUE)
exp_raw <- as.data.frame(read.table(args[1], header=TRUE))
out_raw <- as.data.frame(read.table(args[2], header=TRUE))
p_thresh <- as.numeric(args[3])

# Filter to significant instruments
exp_f <- exp_raw[exp_raw$p < p_thresh, ]
if(nrow(exp_f) == 0) exp_f <- exp_raw

exp <- format_data(exp_f, type="exposure", snp_col="SNP", beta_col="b", se_col="se",
    effect_allele_col="A1", other_allele_col="A2", eaf_col="freq", pval_col="p", samplesize_col="N")
out <- format_data(out_raw, type="outcome", snp_col="SNP", beta_col="b", se_col="se",
    effect_allele_col="A1", other_allele_col="A2", eaf_col="freq", pval_col="p", samplesize_col="N")

dat <- harmonise_data(exp, out, action=2)
if(nrow(dat) == 0) quit(save="no", status=0)

mr_res <- mr(dat)
steiger <- directionality_test(dat)
hetero <- mr_heterogeneity(dat)
pleio <- mr_pleiotropy_test(dat)

# Write metrics
out_cols <- c("exposure","method","nsnp","b","se","pval")
write.table(mr_res[,out_cols], paste0(exp$exposure[1], "_metrics.txt"),
    quote=FALSE, row.names=FALSE, col.names=FALSE, sep="\t")
write.table(steiger, paste0(exp$exposure[1], "_steiger.txt"),
    quote=FALSE, row.names=FALSE, col.names=FALSE, sep="\t")
write.table(hetero, paste0(exp$exposure[1], "_heterogeneity.txt"),
    quote=FALSE, row.names=FALSE, col.names=FALSE, sep="\t")
write.table(pleio, paste0(exp$exposure[1], "_pleiotropy.txt"),
    quote=FALSE, row.names=FALSE, col.names=FALSE, sep="\t")

# MR-PRESSO
mp <- NA
tryCatch({
    presso <- run_mr_presso(dat, NbDistribution=100, SignifThreshold=0.05)
    mp <- presso[[1]][["MR-PRESSO results"]]["Global Test"]$`Global Test`$Pvalue
}, error=function(e){})
write.table(data.frame(presso_p=mp), paste0(exp$exposure[1], "_mrpresso.txt"),
    quote=FALSE, row.names=FALSE, col.names=FALSE, sep="\t")
