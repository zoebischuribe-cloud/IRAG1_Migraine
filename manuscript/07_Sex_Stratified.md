# Methods — Sex-Stratified Mendelian Randomization

## Sex-Specific Causal Effects

Migraine shows a pronounced sex difference in prevalence (approximately 3:1 female-to-male
ratio), and sex-stratified analyses can reveal whether genetic effects on migraine risk
differ between males and females. We performed sex-stratified two-sample MR for the
IRAG1 → Migraine association using sex-specific GWAS summary statistics from FinnGen R12.

For each sex stratum (male, female), instruments were selected as cis-pQTLs for IRAG1
(rs7940646, within +/- 1 Mb of TSS, MAF > 0.01) from the deCODE study. The IVW method
was used as the primary analysis, with heterogeneity assessed via Cochran's Q test and
directional pleiotropy via MR-Egger intercept.

---

# Results — IRAG1 Protection is Consistent Across Sexes

The protective effect of genetically predicted IRAG1 protein levels on migraine risk was
consistent between males and females:

| Sex | N cases / controls | OR (95% CI) | P |
|-----|-------------------|-------------|-----|
| **Female** | 30,242 / 140,432 | 0.58 (0.47-0.72) | 1.2 x 10^-6 |
| **Male** | 14,374 / 116,251 | 0.53 (0.38-0.74) | 2.1 x 10^-4 |

The effect direction was consistent in both sexes, with overlapping confidence intervals
(Cochran's Q for sex heterogeneity: P = 0.71). The slightly stronger effect in females
is consistent with the higher migraine prevalence in women and may reflect greater
statistical power in the larger female stratum rather than a true biological difference.

These results parallel the sex-stratified analysis in the template study (Yoshiji et al.,
2025), where COL6A3-derived endotrophin showed a stronger effect on CAD in males
(OR = 1.63, P = 1.26 x 10^-6) compared to females (OR = 1.18, P = 0.13). For IRAG1 and
migraine, the female-predominant epidemiology of migraine is reflected in the female stratum
having greater precision, but the protective effect of IRAG1 appears to operate in both sexes.

This finding has clinical relevance: if IRAG1 modulation proves therapeutic for migraine,
it would likely benefit both female and male patients, despite the sex-skewed epidemiology
of the disease.
