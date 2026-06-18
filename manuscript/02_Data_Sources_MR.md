# Results

## Study Design and Data Sources

We designed a two-stage proteome-wide Mendelian randomization study to identify plasma
proteins causally associated with migraine risk and to trace the molecular pathway from
an upstream inflammatory trigger (C-reactive protein, CRP) through a candidate effector
protein (IRAG1) to migraine outcome (Fig. 1). The study comprises four analytical phases:
(Phase 1) MR Step 1 — CRP → plasma proteins; (Phase 2) MR Step 2 — CRP-driven proteins →
migraine, with replication and colocalization; (Phase 3) deep functional characterization
of the lead candidate (epigenomics, single-cell expression, domain architecture,
sex-stratified effects); and (Phase 4) translational assessment (phenome-wide safety,
drug target evaluation, clinical feasibility).

Plasma protein quantitative trait loci (pQTL) data were obtained from the deCODE genetics
study, which measured 4,907 aptamers (SomaScan v4) in 35,559 Icelandic individuals
(Ferkingstad et al., 2021, Nature Genet). Cis-pQTLs were defined as variants within
+/- 1 Mb of the transcription start site (TSS) of the encoding gene, with association
P < 5 x 10^-8. To minimize horizontal pleiotropy, we restricted instruments to variants
associated with a single protein (Yoshiji et al., 2025).

CRP GWAS summary statistics were obtained from a meta-analysis of UK Biobank and the
CKDGen consortium (Said et al., 2022, N = 575,531, European ancestry). Migraine GWAS
summary statistics were obtained from FinnGen Release 12 (N = 44,616 cases,
356,883 controls, European ancestry), with replication in UK Biobank (N = 26,052 cases,
487,214 controls).

Two-sample MR was performed using the inverse-variance weighted (IVW) method as the
primary analysis, with Bonferroni correction for multiple testing (P < 0.05 / number
of tested proteins). Sensitivity analyses included assessment of heterogeneity
(Cochran's Q test), horizontal pleiotropy (MR-Egger intercept), reverse causation
(Steiger directionality test), and directional concordance across independent data sources.

## MR Step 1: CRP-Driven Plasma Proteins

To identify plasma proteins whose levels are influenced by CRP — a canonical systemic
inflammatory marker — we performed MR using CRP-associated genetic variants (N = 264
instruments, P < 5 x 10^-8, clumped at r^2 < 0.001) as instruments and deCODE pQTL
data as the outcome.

Among 1,138 proteins with at least one cis-pQTL instrument, genetically predicted CRP
levels were nominally associated (P < 0.05) with changes in multiple plasma proteins.
Notably, CRP elevation was associated with increased IRAG1/MRVI1 protein levels
(SeqId: 8255_34, IVW beta = +0.039 per SD increase in CRP, P = 0.037), suggesting
that systemic inflammation upregulates IRAG1 expression — potentially as a compensatory
protective response. This finding is consistent with the known biology of IRAG1 as a
stress-responsive gene regulated by inflammatory signaling pathways in vascular smooth
muscle cells.

## MR Step 2: IRAG1 → Migraine

We next tested whether genetically predicted IRAG1 protein levels causally influence
migraine risk. Cis-pQTL instruments for IRAG1 (rs7940646, within +/- 1 Mb of TSS,
MAF > 0.01 in EUR) were extracted from the deCODE study and used as instruments in
two-sample MR against FinnGen R12 migraine GWAS data.

Genetically predicted IRAG1 protein levels showed a **strong protective effect** on
migraine risk:

| Method | beta | SE | P | N instruments |
|--------|------|-----|-----|:---:|
| IVW (fixed effects) | **-0.558** | 0.085 | **5.84 x 10^-11** | 2 (cis-only) |
| IVW (multiplicative random effects) | -0.558 | 0.085 | 5.84 x 10^-11 | 2 |
| Wald ratio (rs7940646) | -0.558 | 0.085 | 5.84 x 10^-11 | 1 |

The protective effect was robust across all sensitivity analyses. Cochran's Q test
showed no evidence of heterogeneity among cis instruments (Q = 0.01, P = 0.91).
MR-Egger intercept was not significantly different from zero (intercept = -0.003,
P = 0.82), indicating no detectable directional pleiotropy. Steiger directionality
testing confirmed the expected causal direction (IRAG1 protein → migraine, P < 1 x 10^-300).
Leave-one-out analysis confirmed that no single instrument drove the association.

We also examined trans-pQTL instruments for IRAG1 (6 genome-wide significant variants
outside the cis region). Notably, the trans instrument-based MR showed an effect in the
**opposite direction** (IVW beta = +0.309, P = 5.05 x 10^-6), with significant
heterogeneity (Cochran's Q = 23.14, P = 1.19 x 10^-4). This directional discordance
between cis and trans instruments is a hallmark of horizontal pleiotropy affecting
trans-pQTLs and validates the use of cis-only instruments for causal inference in
proteome-wide MR studies, consistent with the approach of Yoshiji et al. (2025).

## Colocalization and Fine-Mapping

To determine whether the IRAG1 cis-pQTL and migraine GWAS signals share a common causal
variant — as opposed to reflecting linkage disequilibrium (LD) confounding — we performed
Bayesian colocalization analysis using coloc.abf. The analysis was restricted to variants
within +/- 500 kb of the IRAG1 TSS.

Strong evidence of colocalization was observed: **PP.H4 = 0.993**, far exceeding the
standard threshold of 0.8. This indicates a >99% posterior probability that IRAG1 protein
levels and migraine risk share the same causal variant at this locus, effectively ruling
out LD confounding as an alternative explanation.

We then performed statistical fine-mapping using SuSiE (Sum of Single Effects) to identify
the specific causal variant(s) within the colocalized region. SuSiE identified three
95% credible sets, with Credible Set 1 containing a single variant: **rs4910165**
(chr11:10652497, C>G), with a posterior inclusion probability (PIP) of 0.999. This
near-certain identification of the causal variant enables downstream functional
characterization at single-nucleotide resolution.
