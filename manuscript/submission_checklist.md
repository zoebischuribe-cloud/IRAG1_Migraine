# Nature Genetics Submission Checklist — IRAG1_Migraine

## Manuscript Components

| Item | File | Status |
|------|------|:--:|
| Cover Letter | `manuscript/cover_letter.md` | ✅ |
| Main Text (IMRaD) | `manuscript/main_text.md` (~2,160 words) | ✅ |
| Abstract (~150 words) | Included in main_text.md | ✅ |
| References (30 items, Nature style) | `manuscript/references.md` | ✅ |
| Figure Specifications | `manuscript/figures_tables_spec.md` | ✅ |
| Methods (Online) | Included in main_text.md | ✅ |

## Figures

| # | Description | Status |
|---|-------------|:--:|
| Fig. 1 | Study design overview | ⬜ Generate |
| Fig. 2 | MR Step 2 — IRAG1 → Migraine | ⬜ Generate from existing R scripts |
| Fig. 3 | Colocalization + Fine-mapping | ⬜ Generate from existing R scripts |
| Fig. 4a | IRAG1 gene model (isoforms) | ✅ Fig06_IRAG1_GeneModel.png |
| Fig. 4b-d | Domain + expression | ⬜ Generate |
| Fig. 5 | PheWAS + Actionability | ⬜ Generate |
| Supp. Fig. 5 | RegulomeDB annotation | ✅ RegulomeDB_rs4910165_rank1a.png |

## Tables

| # | Description | Status |
|---|-------------|:--:|
| Table 1 | Data sources | ✅ (in figures_tables_spec.md) |
| Table 2 | MR results | ✅ (in main_text.md) |
| Table 3 | Coloc results | ✅ (in main_text.md) |
| Table 4 | SuSiE credible sets | ⬜ Extract from SuSiE output |
| S1-S10 | Supplementary tables | ⬜ Compile |

## Required Statements

| Item | Status |
|------|:--:|
| Data Availability | ✅ (in main_text.md) |
| Code Availability | ⬜ Create GitHub repo |
| Competing Interests | ✅ (in main_text.md) |
| Author Contributions | ⬜ Add author list |
| Acknowledgments | ⬜ Add funding |

## Pre-Submission Quality Checks

| Check | Status |
|-------|:--:|
| All statistics reported with exact P values (not "P < 0.05") | ✅ |
| CI format consistent (95% CI lower-upper) | ✅ |
| Gene names italicized (human) | ⬜ |
| Protein names not italicized | ⬜ |
| British English throughout | ⬜ Proofread |
| No claims exceeding evidence | ⬜ Audit |
| All DOIs verified | ⬜ Spot-check |
| Template paper comparison complete | ✅ |
| RALPH gate files all present (14/14) | ✅ |

## Submission Order

1. Cover Letter
2. Manuscript (Main Text + Methods)
3. Figures (4-6 main + supplementary)
4. Tables (4 main + 10 supplementary)
5. Supplementary Information (PDF)
6. Reporting Summary (Nature Genetics requirement)

## Target Timeline

- Week 1: Generate remaining figures (1, 2, 3, 4b-d, 5)
- Week 2: Compile supplementary tables, create GitHub repo, proofread
- Week 3: Internal review, author approval, final polish
- Week 4: Submit to Nature Genetics

## GATE 3 Criteria (from ARC framework)

- [ ] All analyses reproducible from scripts
- [ ] All figures publication-quality (300 dpi, Nature color palette)
- [ ] All references verified against source articles
- [ ] Manuscript within word limit (Nat Genet: ~3,000 words main text)
- [ ] No overclaims — every statement traceable to a specific analysis
- [ ] All authors approved final version
