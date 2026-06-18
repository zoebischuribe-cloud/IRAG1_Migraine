#!/bin/bash
OUTCOME_DIR="/home/zhu/Projects/0531/data/causeway/outcomes_ralph"
RESULT_DIR="/home/zhu/Projects/0531/results/ralph"
EXP_DIR="/home/zhu/Projects/0531/data/causeway/exposures"

OUTCOMES=(
    "CAD_GCST90132314_AragamKG2022_N1165690"
    "LDL_GCST90239658_Graham2021_N1320016"
)

# Build protein list
ls "$EXP_DIR"/*_decode_cojo.txt.gz | while read f; do basename "$f" _decode_cojo.txt.gz; done > /tmp/proteins_full.txt

for outcome in "${OUTCOMES[@]}"; do
    filtered="${OUTCOME_DIR}/${outcome}_Causeway_filtered.tsv.gz"
    rf="${RESULT_DIR}/${outcome}_all_metrics_or.txt"
    echo -e "exposure\toutcome\tmethod\tnsnp\tb\tse\tp\tOR\tOR_CI95_low\tOR_CI95_high" > "$rf"
    
    echo "--- ${outcome} ($(zcat $filtered | wc -l) SNPs) ---"
    cat /tmp/proteins_full.txt | xargs -P 8 -I {} bash /tmp/phase2_task.sh {} "$filtered" "$rf" "$outcome"
    
    rows=$(wc -l < "$rf")
    ivw=$(awk -F'\t' '$3=="Inverse variance weighted"' "$rf" | wc -l)
    echo "  ✅ ${outcome}: $rows rows ($ivw IVW)"
done
echo "CAD+LDL fix done: $(date)"
