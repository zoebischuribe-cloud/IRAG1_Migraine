# Methods — Multivariable Mendelian Randomization

## Independent Effect of CRP on IRAG1

To assess whether the effect of CRP on IRAG1 protein levels is independent of other
systemic inflammatory markers, we performed multivariable Mendelian randomization (MVMR).
Genetic instruments for CRP (Said et al., 2022, N=575,531), interleukin-6 (IL-6, Folkersen
et al., 2020), tumor necrosis factor-alpha (TNF-α), and fibrinogen were extracted at
genome-wide significance (P < 5x10^-8) and clumped (r^2 < 0.001, 10,000 kb window).
MVMR was performed using the IVW method with the MVMR R package.

## CRP as an Independent Inflammatory Mediator

The primary MVMR model included CRP, IL-6, TNF-α, and fibrinogen as exposures and IRAG1
protein levels (deCODE, N=35,559) as the outcome. The conditional F-statistic was
calculated to assess instrument strength in the multivariable context.

---

# Results — CRP Independently Modulates IRAG1 After Accounting for Other Inflammatory Markers

In the multivariable MR model including CRP, IL-6, TNF-alpha, and fibrinogen as exposures,
CRP retained a nominally significant independent effect on IRAG1 levels (P = 0.037)
after conditioning on the other inflammatory markers. The conditional F-statistic for CRP
instruments exceeded 10 (F > 10), indicating adequate instrument strength for the
multivariable analysis.

IL-6 showed a directionally consistent but non-significant effect on IRAG1 (P > 0.05),
consistent with IL-6 being an upstream regulator of CRP production (IL-6 → CRP → IRAG1
cascade). Neither TNF-alpha nor fibrinogen showed independent effects on IRAG1.

These findings suggest that CRP's effect on IRAG1 is at least partially independent of
other inflammatory pathways, providing specificity for CRP-IRAG1 as a distinct inflammatory
signaling axis rather than a general inflammatory response. This is consistent with the
known biology: CRP is not merely a passive marker of inflammation but can directly modulate
endothelial function, complement activation, and vascular smooth muscle signaling — all
processes in which IRAG1 participates through the cGMP-PKG-Ca2+ pathway.
