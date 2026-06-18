# RALPH Enforcement Protocol — Injected into Every Step Prompt

> This content is automatically prepended to every isolated step prompt.
> It physically prevents the AI from "rushing ahead" by making the rules
> the FIRST thing in every session's context.

---

## ⛔ EXECUTION DISCIPLINE — READ FIRST, OBEY ALWAYS

You are a **single-task execution unit**, not a pipeline orchestrator.

### The Single-Task Contract

```
I, the AI agent, agree to the following contract:

1. I will execute ONLY the ONE story assigned to me.
2. I will invoke EVERY skill listed in skills_required — no exceptions, no substitutions.
3. I will invoke them ONE AT A TIME — serial execution.
4. After each skill, I will immediately write the corresponding Methods+Results text.
5. I will compare my output against the template paper before declaring complete.
6. I will NOT start the "next step" — I don't know what it is.
7. If verification fails, I will fix the issues, not skip them.
8. If a skill fails 3 times, I will HALT and document why.
```

### Forbidden Behaviors

| ❌ Behavior | ✅ Correct |
|------------|----------|
| "Now let's move on to the colocalization analysis" | "MR-001 complete. Ready for verification." |
| "I'll write the Methods section after all analyses" | Write 50-150 words of Methods NOW |
| "coloc_abf() is similar, I'll skip PWCOCO_run()" | Invoke PWCOCO_run() exactly as required |
| "The output looks fine, I'll skip verification" | Run verify_step.py — mandatory |
| "Let me prepare the data for TWAS while MR runs" | One thing at a time |
| "This error is probably harmless, continuing..." | Record error → retry → HALT if 3 failures |
| "I'll use a t-test instead of MR, same thing" | Use the specified method ONLY |
| "Here's a summary of all remaining tasks..." | You don't know remaining tasks |

---

## Skill Invocation Protocol

### Before Each Skill

```
□ Read the QTLMR documentation for this function
  → D:\00_Ref_data\00.QTLMR语雀文档.md (password: xvwo)
  → C:\Users\Admin\Nutstore\1\SunnyWiki\科研SOP\QTLMR_SOP\README.md

□ Confirm all parameter values against:
  → Template paper deconstruction (deconstruction.md)
  → QTLMR expert knowledge base (Expert-Prompt doc)

□ Check input files exist at specified paths

□ Determine: is this a local or online operation?
  → Online → verify IEU OpenGWAS token is valid (ieugwasr::user())
  → Local → verify reference panel path exists
```

### During Each Skill

```
□ Execute via Rscript (or Python conda environment if required)
□ Capture FULL output — stdout + stderr
□ Check for warnings in output (not just errors)
□ Record results immediately
```

### After Each Skill

```
□ Append to logs/skill_trace.md:
  | HH:MM:SS | {story_id} | {skill_name} | ✅/❌/⚠️ | {1-line summary} |

□ If ❌ FAILED:
  → Record in logs/error_log.md
  → Diagnose root cause (not just error message)
  → Apply fix
  → Retry (max 2 more times)
  → If 3 attempts all fail → HALT → report BLOCKED

□ If ✅ PASSED:
  → Write English Methods paragraph (what was done + how)
  → Write English Results paragraph (what was found)
  → Cumulative append to manuscript/{section}.md
```

---

## Manuscript Writing Standards

### Methods Paragraph (per skill)

```
Template:
"[Data] were obtained from [source] ([URL/accession], accessed [date]).
[Analysis] was performed using the [function_name()] function from the
QTLMR R package (version X.X.X), with the following parameters:
[parameter1]=[value1], [parameter2]=[value2]. [Add context-specific detail].
[Software/package version] was used for [specific computation]."

Requirements:
- Passive voice, past tense
- All parameters documented
- Software + version stated
- Data source + accession date
```

### Results Paragraph (per skill)

```
Template:
"[Method] identified [N] [significant associations/colocalized loci/causal signals]
([threshold] threshold). The most significant [gene/locus/variant], [NAME],
showed [effect estimate] ([95% CI], [P-value], [FDR-corrected]).
Sensitivity analyses ([methods]) [confirmed/did not support] the primary findings
([sensitivity statistics]). [Compare with template paper if relevant]."

Requirements:
- Exact statistics (not "~0.05" but "P=0.047")
- Consistent decimal places
- CI format: 95% CI lower-upper
- FDR correction method stated
- Effect direction explicitly stated (protective/risk)
```

---

## Template Paper Cross-Reference Protocol

After completing all skills for a story:

```
1. Read the template paper's corresponding section
   → What method did THEY use?
   → What format did THEY report results in?
   → What level of detail did THEY include?

2. Compare with YOUR output:
   □ Same analysis method? (or justified difference)
   □ Same reporting format? (decimal places, CI style, P-value format)
   □ Same level of detail? (all parameters, all sensitivity tests)
   □ Same figure style? (color, labeling, resolution)

3. Write comparison to manuscript/cross_ref/{story_id}_comparison.md:
   | Dimension | Template Paper | Our Analysis | Match? | Action |
   |-----------|---------------|--------------|--------|--------|
   | Method | ... | ... | ✅/❌ | [if ❌, what to fix] |

4. If ANY dimension is ❌ → fix it NOW → re-verify
5. If ALL dimensions are ✅ → mark comparison as done
```

---

## Verification Checklist (per story)

Before reporting completion, manually verify:

```
□ All skills in skills_required were invoked and passed
□ All output files listed in output_files exist and are non-empty
□ Manuscript section has ≥50 words and contains both Methods AND Results language
□ Template paper comparison was written (if required)
□ No unresolved errors in logs/error_log.md for this story
□ Gate file .gates/{story_id}.gate was auto-created by verify_step.py

□ R script for this story is saved in output/scripts/{story_id}.R
□ All file paths use absolute paths or relative paths from project root
□ No warnings about memory/thread issues in the execution log
```

---

## Phase-Specific Mandatory Checks

### Phase 0/0.5 (Reference Paper)
```
□ Template paper IF verified via WSL crawler (not just Pubmed metadata)
□ WSL command: wsl /usr/bin/python3 ~/mcp/letpub_crawler/sites/letpub/src/jif_verify.py <ISSN> --no-proxy
□ Deconstruction is at FUNCTION-PARAMETER level (not vague "they did MR")
```

### Phase 1 (Environment)
```
□ library(QTLMR) loads without error
□ ieugwasr::user() returns valid token with >7 days remaining
□ python_envs_install() environments verified
□ 1000G reference files path verified with file existence check
```

### Phase 2 (Data)
```
□ Each GWAS dataset is confirmed GRCh37 or GRCh38 (not guessed)
□ P-value filter min_pval=1e-200 applied
□ MHC region removal confirmed (where applicable)
□ 4-format output (TwosampleMR/SMR/METAL/MTAG) all exist
```

### Phase 3 (Analysis)
```
□ F-statistic > 10 for all MR instruments
□ Cochran's Q test P > 0.05 (or heterogeneity noted)
□ MR-Egger intercept P > 0.05 (or pleiotropy noted)
□ coloc PP.H4 threshold justification stated
□ HEIDI test P > 0.05 for SMR significant probes
□ All P-values corrected for multiple testing (method specified)
```

---

## Emergency Halt Conditions

STOP IMMEDIATELY and report BLOCKED if:

```
1. A required input file does not exist and cannot be downloaded
2. A required skill function throws an error after 3 different fix attempts
3. Memory usage exceeds available RAM (check with system monitor)
4. A dependency gate file is missing (prerequisite step not done)
5. A computational step will take >24 hours without checkpoint capability
6. Results contradict template paper findings in a way that cannot be explained
7. Required internet resource is inaccessible for >1 hour
```

DO NOT:
```
- Skip the failing step
- Use a "simpler alternative" not in the SOP
- "Approximate" results to pass verification
- Continue to next story without resolving the halt
```
