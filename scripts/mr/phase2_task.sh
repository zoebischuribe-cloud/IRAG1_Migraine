#!/bin/bash
protein="$1"
outcome_file="$2"
result_file="$3"
outcome_name="$4"

WORK="/home/zhu/Projects/0531/work_ralph"
EXP_DIR="/home/zhu/Projects/0531/data/causeway/exposures"
R_SCRIPT="/tmp/mr_fast.R"

d="${WORK}/${outcome_name}/${protein}"
mkdir -p "$d"
exp_file="${EXP_DIR}/${protein}_decode_cojo.txt.gz"
[ ! -f "$exp_file" ] && exit 0

docker run --rm -v "$d:/work" -w /work \
    -v "$exp_file:/work/exp.gz:ro" -v "$outcome_file:/work/out.gz:ro" \
    -v "$R_SCRIPT:/work/mr_fast.R:ro" \
    docker.io/juliaapolonio/julia_2smr:latest \
    bash -c "zcat exp.gz>exp.txt; zcat out.gz>out.txt; Rscript mr_fast.R exp.txt out.txt 0.99" 2>/dev/null || true

m="$d/exposure_metrics.txt"
if [ -f "$m" ]; then
    while IFS=$'\t' read -r exp method nsnp b se p; do
        [ "$method" = "method" ] && continue
        or=$(Rscript -e "cat(format(exp(as.numeric('$b')),digits=4))" 2>/dev/null || echo "NA")
        cl=$(Rscript -e "cat(format(exp(as.numeric('$b')-1.96*as.numeric('$se')),digits=4))" 2>/dev/null || echo "NA")
        ch=$(Rscript -e "cat(format(exp(as.numeric('$b')+1.96*as.numeric('$se')),digits=4))" 2>/dev/null || echo "NA")
        echo -e "${protein}\t${outcome_name}\t${method}\t${nsnp}\t${b}\t${se}\t${p}\t${or}\t${cl}\t${ch}" >> "$result_file"
    done < "$m"
fi
