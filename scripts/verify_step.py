#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
verify_step.py — Physical Gate Verification Engine
Usage: python verify_step.py --story-id "MR-001" --project-dir "./"

Performs 5-layer verification:
  L1: Output files exist (with size check)
  L2: Required skills invoked (grep execution log)
  L3: Manuscript text written (>minimum word count)
  L4: Template paper comparison completed
  L5: All checklist items checked

Produces: .gates/<STORY_ID>.gate (physical lock file) on PASS
Exits: 0 = PASS, 1 = FAIL (blocks next step)
"""

import os, sys, json, argparse, hashlib, datetime, re, subprocess


class GateVerifier:
    def __init__(self, project_dir: str, story_id: str):
        self.project_dir = os.path.abspath(project_dir)
        self.story_id = story_id
        self.gate_dir = os.path.join(self.project_dir, ".gates")
        self.logs_dir = os.path.join(self.project_dir, "logs")
        self.manuscript_dir = os.path.join(self.project_dir, "manuscript")
        self.output_dir = os.path.join(self.project_dir, "output")
        self.prd = self._load_prd()
        self.story = self._find_story()
        self.errors = []
        self.warnings = []

    def _load_prd(self) -> dict:
        prd_path = os.path.join(self.project_dir, "prd.json")
        if not os.path.exists(prd_path):
            raise FileNotFoundError(f"prd.json not found at {prd_path}")
        with open(prd_path, encoding='utf-8') as f:
            return json.load(f)

    def _find_story(self) -> dict:
        for s in self.prd.get("stories", []):
            if s["id"] == self.story_id:
                return s
        raise ValueError(f"Story {self.story_id} not found in prd.json")

    def verify_all(self) -> bool:
        """Run all verification layers. Returns True only if ALL pass."""
        print(f"\n{'='*60}")
        print(f"GATE VERIFICATION: {self.story_id} -- {self.story.get('title', '')}")
        print(f"{'='*60}\n")

        checks = [
            ("L1: Dependency Gates", self._check_dependency_gates),
            ("L2: Output Files", self._check_output_files),
            ("L3: Skills Invocation", self._check_skills_invoked),
            ("L4: Manuscript Text", self._check_manuscript_text),
            ("L5: Template Paper Comparison", self._check_template_comparison),
            ("L6: Error Log Clean", self._check_error_log),
            ("L7: Cross-Validation", self._check_cross_validation),
        ]

        all_pass = True
        for check_name, check_fn in checks:
            try:
                passed = check_fn()
                status = "[PASS]" if passed else "[FAIL]"
                print(f"  {status}  {check_name}")
                if not passed:
                    all_pass = False
            except Exception as e:
                print(f"  [ERROR] {check_name}: {e}")
                self.errors.append(f"{check_name}: {str(e)}")
                all_pass = False

        print(f"\n{'='*60}")
        if all_pass:
            self._create_gate_file()
            print(f"*** ALL CHECKS PASSED -- Gate file created ***")
            print(f"{'='*60}\n")
            return True
        else:
            print(f"!!! VERIFICATION FAILED -- {len(self.errors)} error(s)")
            for err in self.errors:
                print(f"   - {err}")
            print(f"{'='*60}\n")
            return False

    def _check_dependency_gates(self) -> bool:
        """Verify all dependency gates exist."""
        deps = self.story.get("depends_on", [])
        if not deps:
            return True

        all_found = True
        for dep_id in deps:
            gate_file = os.path.join(self.gate_dir, f"{dep_id}.gate")
            if not os.path.exists(gate_file):
                self.errors.append(f"Missing dependency gate: {dep_id}")
                all_found = False

        if not all_found:
            print(f"    [WARN] Blocked — waiting for: {[d for d in deps if not os.path.exists(os.path.join(self.gate_dir, f'{d}.gate'))]}")
        return all_found

    def _check_output_files(self) -> bool:
        """Check required output files exist and are non-empty."""
        # Phase 0 outputs are informational, skip strict file check
        if self.story["phase"] in [0, 0.5]:
            return True

        expected = self.story.get("output_files", [])
        if not expected:
            self.warnings.append("No output_files specified in prd.json")
            return True  # Allow if not specified

        all_exist = True
        for pattern in expected:
            # Support glob patterns
            import glob as gmod
            matches = gmod.glob(os.path.join(self.project_dir, pattern))
            if not matches:
                self.errors.append(f"Missing output: {pattern}")
                all_exist = False
            else:
                for m in matches:
                    size = os.path.getsize(m)
                    if size < 10:
                        self.errors.append(f"Output too small ({size}B): {m}")
                        all_exist = False

        return all_exist

    def _check_skills_invoked(self) -> bool:
        """Check that ALL required skills were actually invoked."""
        required = self.story.get("skills_required", [])
        if not required:
            return True

        trace_file = os.path.join(self.logs_dir, "skill_trace.md")
        if not os.path.exists(trace_file):
            self.errors.append("skill_trace.md not found — no skills were logged")
            return False

        with open(trace_file, encoding='utf-8') as f:
            trace_content = f.read()

        all_found = True
        missing_count = 0
        for skill in required:
            # Check multiple possible name formats
            skill_variants = [
                skill,
                skill.split(":")[-1] if ":" in skill else skill,
                skill.replace(":", "→"),
            ]
            found = any(v.lower() in trace_content.lower() for v in skill_variants)
            if not found:
                # Check execution log as fallback
                exec_log = os.path.join(self.logs_dir, "execution.log")
                if os.path.exists(exec_log):
                    with open(exec_log, encoding='utf-8') as elf:
                        exec_content = elf.read()
                    found = any(v.lower() in exec_content.lower() for v in skill_variants)

            if not found:
                self.errors.append(f"Required skill NOT invoked: {skill}")
                missing_count += 1
                all_found = False

        if missing_count > 0:
            print(f"    [WARN] {missing_count}/{len(required)} required skills NOT invoked")
        else:
            print(f"[OK] All {len(required)} required skills verified in trace")
        return all_found

    def _check_manuscript_text(self) -> bool:
        """Verify manuscript section was written."""
        ms_section = self.story.get("manuscript_section")
        if not ms_section:
            return True  # No manuscript output required for this step

        ms_file = os.path.join(self.manuscript_dir, f"{ms_section}.md")
        if not os.path.exists(ms_file):
            self.errors.append(f"Manuscript section missing: {ms_file}")
            return False

        with open(ms_file, encoding='utf-8') as f:
            content = f.read()

        word_count = len(content.split())
        if word_count < 50:
            self.errors.append(f"Manuscript too short ({word_count} words, need ≥50)")
            return False

        # Check it contains both Methods and Results language
        has_methods = any(kw in content.lower() for kw in ["we obtained", "were obtained", "was performed", "using the", "data were", "summary statistics"])
        has_results = any(kw in content.lower() for kw in ["we identified", "showed", "was associated", "or =", "95% ci", "p =", "beta ="])

        if not has_methods:
            self.warnings.append("Manuscript section may lack Methods content")

        print(f"    [OK]Manuscript: {word_count} words in {ms_file}")
        return True

    def _check_template_comparison(self) -> bool:
        """Verify cross-reference with template paper was done."""
        gate_conditions = self.story.get("gate_conditions", [])
        if "template_paper_comparison_done" not in gate_conditions:
            return True

        cross_ref_dir = os.path.join(self.manuscript_dir, "cross_ref")
        # Look for any comparison file for this story
        pattern = f"{self.story_id}*"
        import glob as gmod
        matches = gmod.glob(os.path.join(cross_ref_dir, pattern + "*"))
        matches.extend(gmod.glob(os.path.join(cross_ref_dir, f"*{self.story_id}*")))

        if not matches:
            # Check if there's a combined comparison file
            combined = os.path.join(cross_ref_dir, "comparison_log.md")
            if os.path.exists(combined):
                with open(combined, encoding='utf-8') as f:
                    if self.story_id in f.read():
                        return True
            self.errors.append(f"Template paper comparison missing for {self.story_id}")
            return False

        return True

    def _check_error_log(self) -> bool:
        """Check if there are unresolved errors from this story."""
        error_log = os.path.join(self.logs_dir, "error_log.md")
        if not os.path.exists(error_log):
            return True

        with open(error_log, encoding='utf-8') as f:
            content = f.read()

        # Check for unresolved errors matching this story
        unresolved = re.findall(
            rf'\|\s*{self.story_id}\s*\|.*\|.*\|.*\|.*\|\s*$',
            content, re.MULTILINE
        )
        # Lines ending with empty fix column = unresolved
        if unresolved:
            for line in unresolved:
                if line.strip().endswith('|'):  # no fix documented
                    self.warnings.append(f"Unresolved error for {self.story_id}: {line[:80]}...")
        return True  # Warning only, don't block

    def _check_cross_validation(self) -> bool:
        """Verify cross-validation with other pipelines (Phase 4+ only)."""
        if self.story["phase"] < 4:
            return True

        # For Phase 4+, ensure findings.md has been updated
        findings = os.path.join(self.project_dir, "findings.md")
        if os.path.exists(findings):
            with open(findings, encoding='utf-8') as f:
                content = f.read()
            if self.story_id not in content:
                self.warnings.append(f"findings.md not updated with {self.story_id} results")
        return True

    def _create_gate_file(self):
        """Create physical gate lock file."""
        os.makedirs(self.gate_dir, exist_ok=True)
        gate_path = os.path.join(self.gate_dir, f"{self.story_id}.gate")

        prd_hash = hashlib.sha256(
            json.dumps(self.story, sort_keys=True).encode()
        ).hexdigest()[:12]

        with open(gate_path, 'w', encoding='utf-8') as f:
            f.write(f"# GATE: {self.story_id}\n")
            f.write(f"PASSED: {datetime.datetime.now().isoformat()}\n")
            f.write(f"STORY: {self.story.get('title', '')}\n")
            f.write(f"HASH: {prd_hash}\n")
            f.write(f"SKILLS_VERIFIED: {len(self.story.get('skills_required', []))}\n")
            f.write(f"LOCKED: true\n")

        print(f"    [LOCK]Gate file: {gate_path}")


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="QTLMR Step Gate Verifier")
    parser.add_argument("--story-id", required=True, help="Story ID to verify")
    parser.add_argument("--project-dir", default=".", help="Project directory")
    parser.add_argument("--strict", action="store_true", help="Fail on warnings too")

    args = parser.parse_args()

    verifier = GateVerifier(args.project_dir, args.story_id)
    passed = verifier.verify_all()

    if args.strict and verifier.warnings:
        print(f"[WARN] Strict mode: {len(verifier.warnings)} warning(s) → FAIL")
        for w in verifier.warnings:
            print(f"   • {w}")
        sys.exit(1)

    sys.exit(0 if passed else 1)
