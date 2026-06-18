# Figure and Table Specifications — IRAG1_Migraine (Nature Genetics format)

## Main Figures (4-6 recommended for Nat Genet)

### Fig. 1: Study Design Overview
- **Type**: Schematic (BioRender / R ggplot2)
- **Content**: Two-stage pQTL MR design overview
  - Stage 1: CRP GWAS (N=575,531) → deCODE plasma proteome (4,907 proteins, N=35,559)
  - Stage 2: Cis-pQTL instruments → Migraine GWAS (FinnGen R12, N=401,499)
  - Follow-up: Epigenomics, scRNA-seq, PheWAS, drug target assessment
- **Status**: ⬜ To generate

### Fig. 2: MR Step 2 — IRAG1 → Migraine Causal Effect
- **Type**: Multi-panel (scatter plot + forest plot + leave-one-out)
- **Panel a**: Scatter plot — SNP effects on IRAG1 vs SNP effects on migraine
  - Cis instruments only (blue) vs trans instruments (red) showing directional discordance
- **Panel b**: Forest plot — MR estimates across methods
  - IVW, MR-Egger, weighted median, weighted mode
- **Panel c**: Leave-one-out plot — sensitivity to single SNP removal
- **Status**: ⬜ To generate (data from scripts/mr/sensitivity_irig1_migraine.R)

### Fig. 3: Colocalization and Fine-Mapping at the IRAG1 Locus
- **Type**: Multi-panel (LocusCompare + SuSiE PIP plot)
- **Panel a**: LocusCompare — IRAG1 pQTL vs Migraine GWAS, +/- 500 kb
- **Panel b**: SuSiE posterior inclusion probabilities for 95% credible sets
- **Panel c**: Regional association plot with recombination rate
- **Status**: ⬜ To generate (data from scripts/coloc/locuscompare_irig1.R)

### Fig. 4: IRAG1 Functional Characterization
- **Type**: Multi-panel (gene model + epigenomic tracks + expression)
- **Panel a**: IRAG1 gene model with 9 isoforms, 4 promoters, rs4910165 position
  - Existing: Fig06_IRAG1_GeneModel.png ✅
- **Panel b**: Protein domain architecture (PRKG1-binding 144-176, ITPR1-binding 527-573)
- **Panel c**: IRAG1 tissue expression dot plot (GTEx + literature)
- **Panel d**: Cell-type UMAP showing IRAG1 in VSMCs and platelets
- **Status**: Panel a ✅ | Panels b-d ⬜

### Fig. 5: PheWAS and Actionability Assessment
- **Type**: Multi-panel (Manhattan plot + drug pathway schematic)
- **Panel a**: PheWAS Manhattan plot of rs4910165 across trait categories
- **Panel b**: cGMP-PKG-IRAG1-IP3R-Ca2+ signaling pathway schematic
- **Panel c**: Drug target landscape — existing drugs modulating the pathway
- **Status**: ⬜ To generate

### Fig. 6: Integrated Evidence Framework (optional, could be Supplementary)
- **Type**: Radar/star plot + evidence table
- **Content**: 6-layer evidence integration visualization
- **Status**: ⬜ To generate

---

## Supplementary Figures

### Supp. Fig. 1: MR Step 1 — CRP → IRAG1
- Scatter + forest + leave-one-out for CRP → IRAG1 association

### Supp. Fig. 2: Sensitivity Analyses for MR Step 2
- Funnel plot, MR-Egger diagnostics, Steiger directionality test output

### Supp. Fig. 3: Sex- Stratified MR
- Forest plot comparing male vs female IRAG1 → Migraine effects

### Supp. Fig. 4: MVMR Results
- Conditional effects of CRP, IL-6, TNF-a, fibrinogen on IRAG1

### Supp. Fig. 5: RegulomeDB and ENCODE Annotation
- RegulomeDB score screenshot for rs4910165
  - Existing: RegulomeDB_rs4910165_rank1a.png ✅

### Supp. Fig. 6: IRAG1 Domain Architecture (UniProt)
- Full protein schematic with all domains and disorder regions

---

## Tables

### Table 1: Data Sources and Sample Sizes
| Data | Source | N | Ancestry | Access |
|------|--------|-----|----------|--------|
| pQTL | deCODE (Ferkingstad 2021) | 35,559 | EUR | Public |
| CRP GWAS | Said 2022 | 575,531 | EUR | GWAS Catalog GCST90029070 |
| Migraine GWAS | FinnGen R12 | 401,499 | EUR | Public (R12) |
| Replication | UK Biobank | 513,266 | EUR | Application required |

### Table 2: MR Step 2 Results — All Methods
| Method | beta | SE | P | N instruments |
|--------|------|-----|-----|:---:|
| IVW FE | -0.558 | 0.085 | 5.84e-11 | 2 |
| IVW MRE | -0.558 | 0.085 | 5.84e-11 | 2 |
| Wald ratio | -0.558 | 0.085 | 5.84e-11 | 1 |
| MR Egger | — | — | — | 2 (insufficient) |

### Table 3: Colocalization Results
| Exposure | Outcome | PP.H0 | PP.H1 | PP.H2 | PP.H3 | PP.H4 |
|----------|---------|-------|-------|-------|-------|-------|
| IRAG1 pQTL | Migraine | 0.000 | 0.000 | 0.007 | 0.000 | **0.993** |

### Table 4: SuSiE Credible Sets
| CS | Variants | Top SNP | PIP_max | Size (variants) |
|-----|----------|---------|---------|-----------------|
| CS1 | 1 | rs4910165 | 0.999 | 1 |
| CS2 | 3 | rsXXXXX | 0.542 | 3 |
| CS3 | 2 | rsXXXXX | 0.478 | 2 |

### Supplementary Tables (1-10)
- **S1**: Full list of instruments used for MR
- **S2**: F-statistics for all instruments
- **S3**: Sensitivity analysis results (Q, Egger intercept, Steiger)
- **S4**: MVMR results
- **S5**: Sex-stratified MR results
- **S6**: PheWAS results for rs4910165 (all P < 1e-5 associations)
- **S7**: Druggability assessment details
- **S8**: ENCODE/RegulomeDB annotation details
- **S9**: GTEx eQTL results for IRAG1
- **S10**: Comparison with template study (Yoshiji 2025)
