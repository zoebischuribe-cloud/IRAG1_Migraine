#!/usr/bin/env python3
"""
build_step_prompt.py — Isolated Prompt Builder
Usage: python build_step_prompt.py --story-id "MR-001" --project-dir "./"

Builds a self-contained prompt for a SINGLE analysis step.
The AI executing this prompt has NO knowledge of other steps.
This prevents "rushing ahead" because the AI literally doesn't know what comes next.
"""

import os, sys, json, argparse, datetime


def build_prompt(project_dir: str, story_id: str) -> str:
    """Build isolated prompt for one story."""

    prd_path = os.path.join(project_dir, "prd.json")
    if not os.path.exists(prd_path):
        raise FileNotFoundError(f"prd.json not found: {prd_path}")

    with open(prd_path, encoding='utf-8') as f:
        prd = json.load(f)

    # Find the story
    story = None
    for s in prd.get("stories", []):
        if s["id"] == story_id:
            story = s
            break
    if not story:
        raise ValueError(f"Story {story_id} not found in prd.json")

    # Check dependency gates
    missing_deps = []
    for dep_id in story.get("depends_on", []):
        gate_file = os.path.join(project_dir, ".gates", f"{dep_id}.gate")
        if not os.path.exists(gate_file):
            missing_deps.append(dep_id)

    if missing_deps:
        return _build_blocked_prompt(story, missing_deps, project_dir)

    # Read relevant context
    sop_context = _read_sop_section(project_dir, story)
    findings_context = _read_findings(project_dir, story)
    template_context = _read_template_deconstruction(project_dir, story)
    progress_context = _read_progress(project_dir)

    # Read enforcement rules
    enforcement_path = os.path.join(
        os.path.dirname(os.path.dirname(os.path.abspath(__file__))),
        "SKILL.enforcement.md"
    )
    enforcement_rules = ""
    if os.path.exists(enforcement_path):
        with open(enforcement_path, encoding='utf-8') as f:
            enforcement_rules = f.read()

    # Build the prompt
    prompt = f"""# ISOLATED TASK — {story_id}

## ⛔ CRITICAL: Single-Task Restriction

You are executing **exactly one task**: `{story_id}`.

You do NOT know what other tasks exist. You do NOT know the full pipeline.
Your ONLY job is to complete `{story_id}` and VERIFY it.

**Forbidden behaviors:**
- ❌ Do NOT start the next analysis step
- ❌ Do NOT write code for future steps
- ❌ Do NOT "prepare" data for future pipelines
- ❌ Do NOT summarize what should happen next
- ❌ Do NOT rush — completeness > speed

**If you finish early:**
- ✅ Re-check the output quality
- ✅ Improve the manuscript text
- ✅ Run additional sensitivity analyses
- ✅ Verify against the template paper
- ✅ Report "READY FOR VERIFICATION" and STOP

---

## Project Context

**Project**: {prd.get('projectName', 'Unknown')}
**Template Paper PMID**: {prd.get('templatePaper', 'Not specified')}
**Target Disease**: {prd.get('targetDisease', 'Not specified')}
**Current Phase**: {story.get('phase', '?')}

{progress_context}

---

## Current Task: {story_id}

**Title**: {story.get('title', '')}
**Phase**: {story.get('phase', '')}

### Required Skills (MUST invoke ALL — non-negotiable)

"""
    for skill in story.get("skills_required", []):
        prompt += f"- [ ] `{skill}`\n"

    prompt += f"""
### Required Output Files
"""
    for fpath in story.get("output_files", []):
        prompt += f"- [ ] `{fpath}`\n"

    if story.get("output_files"):
        pass
    else:
        prompt += "- Output files will be specified in the execution log\n"

    prompt += f"""
### Manuscript Output
"""
    ms_section = story.get("manuscript_section")
    if ms_section:
        prompt += f"- **Must write**: `manuscript/{ms_section}.md` (≥50 words, Methods + Results style)\n"
    else:
        prompt += "- No manuscript output required for this step\n"

    prompt += f"""
### Gate Conditions
"""
    for cond in story.get("gate_conditions", []):
        prompt += f"- [ ] {cond}\n"
    if not story.get("gate_conditions"):
        prompt += "- Standard gate: output files exist + skills invoked\n"

    prompt += f"""

---

{enforcement_rules}

---

{sop_context}

---

{template_context}

---

{findings_context}

---

## EXECUTION INSTRUCTIONS

### Step 1: Read Phase-Specific SOP
Read the relevant section from:
- `C:\\Users\\Admin\\Nutstore\\1\\SunnyWiki\\raw\\inbox\\20260618\\Win_CC_SOP_Universal-Research-Execution_Paper2Paper-BlueOcean_Complete-Workflow.md`
- `C:\\Users\\Admin\\Nutstore\\1\\SunnyWiki\\raw\\inbox\\20260618\\Win_CC_QTLMR_Expert-Prompt_PostGWAS-MultiOmics-Mentor_System-Prompt.md`

### Step 2: Execute Each Skill — ONE AT A TIME
For EACH skill in the Required Skills list:
  1. Invoke the skill (with correct parameters)
  2. Wait for completion
  3. Record result in `logs/skill_trace.md`:
     ```
     | {datetime.datetime.now().strftime('%H:%M:%S')} | {story_id} | [skill_name] | ✅/❌ | [result summary] |
     ```
  4. If failed → record in `logs/error_log.md` → retry (max 3) → if still fail, HALT
  5. If passed → **immediately** write the corresponding Methods+Results paragraph

### Step 3: Manuscript Writing (if required)
Write to `manuscript/{ms_section if ms_section else 'notes'}.md`:
- **Methods paragraph**: What was done, what data, what parameters, what software
- **Results paragraph**: Key findings, statistics (OR/β + 95%CI + P + FDR), interpretation
- Match the language style of the template paper

### Step 4: Template Paper Comparison
Compare your output with the template paper's corresponding section.
Write comparison to `manuscript/cross_ref/{story_id}_comparison.md`:
- Same analysis flow? Y/N — if N, why?
- Same reporting format? Y/N — if N, fix
- Same level of detail? Y/N — if N, add more details

### Step 5: Self-Verify
Run: `python scripts/verify_step.py --story-id {story_id} --project-dir .`

If verification FAILS:
- Read error messages
- Fix issues
- Re-run verification
- Do NOT proceed until ALL checks pass

### Step 6: Create Gate + Report Completion

When verification PASSES, the gate file `.gates/{story_id}.gate` is auto-created.
Then reply:

```
✅ {story_id} COMPLETE
   Skills used: [list with counts]
   Output files: [list]
   Manuscript: manuscript/{ms_section}.md ([N] words)
   Gate: .gates/{story_id}.gate
```

Then **STOP**. Do nothing else.
"""

    return prompt


def _build_blocked_prompt(story: dict, missing_deps: list, project_dir: str) -> str:
    """Build prompt when dependencies are not met."""
    return f"""# BLOCKED — {story['id']}

## Cannot execute `{story['id']}` — dependency gates missing

The following prerequisite steps must pass verification first:

"""
    for dep in missing_deps:
        gate_path = os.path.join(project_dir, ".gates", f"{dep}.gate")
        print(f"  Checking: {gate_path}")

    for dep in missing_deps:
        prompt += f"- **{dep}**: `.gates/{dep}.gate` not found — step not yet completed or verified\n"

    prompt += f"""

## Action Required

Run the missing steps first:
"""
    for dep in missing_deps:
        prompt += f"```bash\npython scripts/build_step_prompt.py --story-id {dep} --project-dir {project_dir}\n```\n"

    prompt += """
Then re-run:
```bash
python scripts/build_step_prompt.py --story-id {story_id} --project-dir {project_dir}
```

**DO NOT attempt to execute this task until all dependencies are resolved.**
"""
    return prompt


def _read_sop_section(project_dir: str, story: dict) -> str:
    """Extract relevant SOP section."""
    # Return pointer to SOP file — too large to include inline
    sop_path = "C:\\Users\\Admin\\Nutstore\\1\\SunnyWiki\\raw\\inbox\\20260618\\Win_CC_SOP_Universal-Research-Execution_Paper2Paper-BlueOcean_Complete-Workflow.md"
    phase = story.get("phase", 0)

    phase_names = {
        0: "Phase 0：参考论文发现与IF验证",
        0.5: "Phase 0.5：深度拆解 + 蓝海发现",
        1: "Phase 1：环境搭建与参考数据准备",
        2: "Phase 2：数据获取与格式转换",
        3: "Phase 3：核心分析管线执行",
        4: "Phase 4：结果整合与交叉验证",
        5: "Phase 5：论文写作",
        6: "Phase 6：审稿模拟与修改",
        7: "Phase 7：投稿准备与投稿",
    }

    return f"""## SOP Reference

**Read before starting**: `{sop_path}`
**Navigate to**: {phase_names.get(phase, f'Phase {phase}')}

**Also reference**:
- Expert Knowledge Base: `C:\\Users\\Admin\\Nutstore\\1\\SunnyWiki\\raw\\inbox\\20260618\\Win_CC_QTLMR_Expert-Prompt_PostGWAS-MultiOmics-Mentor_System-Prompt.md`
- Repo Mapping: `C:\\Users\\Admin\\Nutstore\\1\\SunnyWiki\\raw\\inbox\\20260618\\Win_CC_AI_GitHub-Repos_Full-Analysis_D-AI-Mapping_Reference.md`
- QTLMR Full Docs: `D:\\00_Ref_data\\00.QTLMR语雀文档.md`
"""


def _read_findings(project_dir: str, story: dict) -> str:
    """Read relevant findings from previous steps."""
    findings_path = os.path.join(project_dir, "findings.md")
    if not os.path.exists(findings_path):
        return ""

    with open(findings_path, encoding='utf-8') as f:
        content = f.read()

    # Return only recent findings (last 2000 chars relevant to deps)
    deps = story.get("depends_on", [])
    relevant = []
    for dep in deps:
        if dep in content:
            lines = content.split('\n')
            for i, line in enumerate(lines):
                if dep in line:
                    relevant.extend(lines[i:i+20])
                    relevant.append("---")

    if relevant:
        return "## Previous Findings (from dependency steps)\n\n" + "\n".join(relevant[-50:])
    return ""


def _read_template_deconstruction(project_dir: str, story: dict) -> str:
    """Read template paper deconstruction."""
    dec_path = os.path.join(project_dir, "findings", "deconstruction.md")
    if not os.path.exists(dec_path):
        # Check plans folder
        dec_path = os.path.join(project_dir, "plans", "deconstruction.md")

    if os.path.exists(dec_path):
        with open(dec_path, encoding='utf-8') as f:
            content = f.read()
        # Return relevant section only
        story_method_keywords = {
            "MR-": ["Mendelian randomization", "instrumental variable", "MR analysis", "IVW"],
            "COLOC-": ["colocalization", "coloc", "shared causal", "PP.H4"],
            "SMR-": ["SMR", "summary-based mendelian randomization", "HEIDI"],
            "GENECORR-": ["genetic correlation", "LDSC", "HDL", "LAVA", "HESS"],
            "TWAS-": ["TWAS", "transcriptome-wide", "FUSION", "FOCUS", "PrediXcan"],
            "MAGMA-": ["MAGMA", "gene-based", "gene-set"],
            "FINE-": ["fine-mapping", "FM-summary", "SuSiE", "credible set"],
            "CROSS-": ["cross-trait", "MTAG", "CPASSOC", "PLACO", "pleiotropy"],
        }

        for prefix, keywords in story_method_keywords.items():
            if story["id"].startswith(prefix):
                # Find relevant sections
                lines = content.split('\n')
                relevant = [lines[0], lines[1], ""]  # Title
                for i, line in enumerate(lines):
                    for kw in keywords[:2]:
                        if kw.lower() in line.lower():
                            relevant.extend(lines[max(0,i-2):i+15])
                            relevant.append("---")
                            break
                if len(relevant) > 3:
                    return "## Template Paper — Relevant Methods\n\n" + "\n".join(relevant[:100])

        return f"## Template Paper Reference\n\nFull deconstruction: `{dec_path}`\n\n"
    return ""


def _read_progress(project_dir: str) -> str:
    """Read progress summary."""
    progress_path = os.path.join(project_dir, "progress.txt")
    if not os.path.exists(progress_path):
        return ""

    with open(progress_path, encoding='utf-8') as f:
        content = f.read()

    # Return last 20 lines
    lines = content.split('\n')
    return "## Recent Progress\n\n```\n" + "\n".join(lines[-20:]) + "\n```\n"


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Build isolated single-step prompt")
    parser.add_argument("--story-id", required=True, help="Story ID")
    parser.add_argument("--project-dir", default=".", help="Project directory")
    parser.add_argument("--output", default=None, help="Output file (default: stdout)")

    args = parser.parse_args()
    prompt = build_prompt(args.project_dir, args.story_id)

    if args.output:
        with open(args.output, 'w', encoding='utf-8') as f:
            f.write(prompt)
        print(f"Prompt written to {args.output}")
    else:
        print(prompt)
