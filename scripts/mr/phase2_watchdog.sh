#!/bin/bash
# Restart-safe Phase 2: skips completed proteins, resumes partial outcomes
export OUTCOME_DIR="/home/zhu/Projects/0531/data/causeway/outcomes_ralph"
export RESULT_DIR="/home/zhu/Projects/0531/results/ralph"
export EXP_DIR="/home/zhu/Projects/0531/data/causeway/exposures"
export WORK="/home/zhu/Projects/0531/work_ralph"
mkdir -p "$WORK" "$RESULT_DIR"

OUTCOMES=(
    "AD_LO_FinnGenR12_N500348"
    "ALS_G6-ALS_FinnGenR12_N217427"
    "CAD_GCST90132314_AragamKG2022_N1165690"
    "CarpalTunnel_G6-CARPTU_FinnGenR12_N466552"
    "CerebralAneurysm_I9-ANEURYSM_FinnGenR12_N457138"
    "Epilepsy_G6-EPLEPSY_FinnGenR12_N390250"
    "LDL_GCST90239658_Graham2021_N1320016"
    "MS_G6-MS_FinnGenR12_N498857"
    "PD_G6-PARKINSON_FinnGenR12_N500348"
    "Sleep_SLEEP_FinnGenR12_N495270"
)

# Build protein list once
ls "$EXP_DIR"/*_decode_cojo.txt.gz 2>/dev/null | while read f; do basename "$f" _decode_cojo.txt.gz; done > /tmp/proteins_full.txt
TOTAL_PROTS=$(wc -l < /tmp/proteins_full.txt)
echo "Watchdog started: $(date) | ${#OUTCOMES[@]} outcomes × $TOTAL_PROTS proteins"

for outcome in "${OUTCOMES[@]}"; do
    filtered="${OUTCOME_DIR}/${outcome}_Causeway_filtered.tsv.gz"
    if [ ! -f "$filtered" ]; then
        echo "  ⚠️ ${outcome}: no filtered file, skipping"
        continue
    fi

    rf="${RESULT_DIR}/${outcome}_all_metrics_or.txt"

    # Determine completed proteins
    if [ -f "$rf" ] && [ "$(wc -l < "$rf")" -gt 1 ]; then
        # Extract already-done proteins
        cut -f1 "$rf" | tail -n +2 | sort -u > /tmp/done_prots.txt
        comm -23 <(sort /tmp/proteins_full.txt) /tmp/done_prots.txt > /tmp/todo_prots.txt
        done_n=$(wc -l < /tmp/done_prots.txt)
        todo_n=$(wc -l < /tmp/todo_prots.txt)
        echo "--- ${outcome}: ${done_n} done, ${todo_n} remaining ---"
    else
        # Fresh start
        echo -e "exposure\toutcome\tmethod\tnsnp\tb\tse\tp\tOR\tOR_CI95_low\tOR_CI95_high" > "$rf"
        cp /tmp/proteins_full.txt /tmp/todo_prots.txt
        echo "--- ${outcome}: fresh start ($TOTAL_PROTS proteins) ---"
    fi

    if [ "$todo_n" -eq 0 ] 2>/dev/null; then
        echo "  ✅ ${outcome}: already complete, skipping"
        continue
    fi

    # Run remaining proteins
    cat /tmp/todo_prots.txt | xargs -P 8 -I {} bash /tmp/phase2_task.sh {} "$filtered" "$rf" "$outcome"

    final_rows=$(wc -l < "$rf")
    echo "  ✅ ${outcome}: $final_rows rows done"
done

echo "ALL DONE: $(date)"
touch /tmp/phase2_complete.flag
