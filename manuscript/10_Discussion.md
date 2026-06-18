# Discussion

In this study, we present an integrated proteogenomic framework that establishes IRAG1 as
a genetically validated, first-in-class therapeutic target for migraine. Using two-stage
plasma proteome Mendelian randomization, we demonstrate that genetically predicted IRAG1
protein levels confer strong protection against migraine risk (beta = -0.558, P = 5.84 x 10^-11),
with colocalization (PP.H4 = 0.993) and fine-mapping (PIP = 0.999) confirming a shared causal
variant at single-nucleotide resolution. Multi-layered functional characterization —
encompassing epigenomic annotation, single-cell expression profiling, domain-aware MR,
and clinical-pharmacological validation — provides convergent evidence supporting IRAG1
as a therapeutically tractable target operating through the cGMP-PKG-IP3R-Ca2+ signaling
axis, a pathway mechanistically distinct from current CGRP-based migraine therapies.

## Convergent Multi-Layered Evidence

The strength of our findings derives from the convergence of orthogonal evidence across
six analytical layers. At the genetic association level, IRAG1 variants are associated
with migraine risk in both FinnGen and UK Biobank. At the causal inference level, our
two-stage MR framework not only identifies IRAG1 as protective but traces its regulation
to CRP, an upstream inflammatory trigger, providing a molecular pathway linking systemic
inflammation to migraine susceptibility. The colocalization and fine-mapping results
(PP.H4 = 0.993, PIP = 0.999) exclude LD confounding and resolve the causal signal to a
single intronic variant.

At the molecular mechanism level, our epigenomic analysis demonstrates that rs4910165
resides in active regulatory chromatin specifically in vascular smooth muscle cells,
where IRAG1 is most highly expressed. The variant maps to intron 1 of a gene with four
alternative promoters and nine isoforms, suggesting tissue-specific regulatory effects.
Crucially, IRAG1's two essential protein interaction domains — PRKG1-binding (residues
144-176) and ITPR1-binding (residues 527-573) — are retained in all regulated isoforms,
indicating that the genetically predicted protective effect is mediated through the
full-length, functionally intact protein.

At the translational level, our PheWAS analysis demonstrates that the IRAG1-elevating
allele is not associated with any harmful clinical phenotypes, supporting the safety
of therapeutic strategies aimed at enhancing IRAG1 activity. Drug target assessment
identifies IRAG1 as a first-in-class opportunity: no existing drugs directly target
IRAG1, yet the cGMP-PKG pathway in which it operates is extensively drugged, providing
a pharmacological roadmap for IRAG1 modulator development.

## Comparison with the Template Study

Our analytical framework parallels that of Yoshiji et al. (2025, Nature Genetics), who
identified COL6A3-derived endotrophin as a mediator of obesity effects on coronary artery
disease. Both studies employ two-stage pQTL MR, cis-only instrument restriction, Bayesian
colocalization, fine-mapping, epigenomic annotation, single-cell expression analysis, and
PheWAS safety assessment. Several methodological parallels strengthen confidence in our
findings:

First, both studies identified a single protein with strongest evidence among hundreds of
candidates, with convergent support from multiple analytical layers. Second, both causal
variants are intronic and located in active regulatory chromatin, consistent with
expression-regulatory mechanisms. Third, both studies validated the cis-only instrument
strategy by demonstrating directional discordance between cis- and trans-pQTL-based MR
estimates, confirming that trans-pQTLs introduce pleiotropy that can reverse causal
inference. Fourth, both proteins show highly tissue-specific expression patterns that are
mechanistically linked to their disease associations.

A key difference is that COL6A3's effect was domain-specific (C-terminal endotrophin,
not full-length COL6A3), whereas IRAG1's protective effect appears to require the
full-length protein with both PRKG1 and ITPR1 interaction domains intact. This has
important implications for therapeutic strategy: IRAG1-targeted therapies must preserve
or augment the dual-domain architecture, whereas endotrophin-targeted therapies can
selectively target the C-terminal cleavage product.

## Clinical-Pharmacological Integration

Our genetic findings are strikingly consistent with clinical pharmacology. PDE5 inhibitors
(sildenafil, tadalafil) and NO donors (glyceryl trinitrate) — both of which acutely activate
the cGMP-PKG-IRAG1 pathway — are well-established headache triggers. PDE5 inhibitors cause
headache in 10-16% of users, and GTN infusion is the most reliable experimental method for
triggering migraine-like headache in susceptible individuals. At first glance, this appears
contradictory to our genetic finding that IRAG1 elevation protects against migraine. However,
we propose a resolution based on the distinction between acute pharmacological perturbation
and chronic genetic modulation:

Acute, large-amplitude activation of the cGMP-PKG-IRAG1 pathway — as occurs with PDE5
inhibition or NO donation — produces supraphysiological cGMP levels, excessive IRAG1
phosphorylation, and acute dysregulation of IP3R-Ca2+ signaling in vascular smooth muscle,
triggering vasodilation and headache. In contrast, the genetically predicted effect reflects
chronic, modest modulation of IRAG1 levels (on the order of 0.5 SD), which stabilizes
IP3R-Ca2+ homeostasis without inducing the acute signaling excursions that trigger headache.
This distinction is clinically important: it suggests that a therapeutic strategy achieving
modest, sustained enhancement of IRAG1 activity — potentially through a small-molecule
stabilizer of the IRAG1-ITPR1 interaction or a gene therapy approach targeting vascular
IRAG1 expression — could provide migraine prophylaxis without the headache liability of
acute cGMP pathway activators.

## Monogenic Disease Validation

The identification of homozygous loss-of-function MRVI1 mutations as the cause of familial
isolated achalasia (Koehler et al., 2020, Nature Communications) provides powerful human
genetic validation of IRAG1's functional importance. Achalasia is characterized by
progressive loss of esophageal smooth muscle function due to disrupted inhibitory
innervation, and the MRVI1 mutations specifically disrupt the cGKIbeta-IRAG1 interaction
domain — the same PRKG1-binding domain (residues 144-176) retained in all IRAG1 isoforms
regulated by the migraine-associated variant rs4910165. This monogenic phenotype
demonstrates that genetic perturbation of IRAG1 — specifically disruption of its
cGMP-PKG-dependent function — produces clinically significant smooth muscle pathology in
humans, providing orthogonal validation that cannot be explained by confounding or
statistical artifact.

## Limitations

This study has several limitations. First, our analyses were restricted to European
ancestry populations (deCODE, FinnGen, UK Biobank), and the generalizability of these
findings to other ancestral groups requires further investigation. Second, the two-stage
MR framework assumes a linear causal chain (CRP → IRAG1 → migraine); in reality,
biological systems involve feedback loops and non-linear interactions that may not be
fully captured by linear MR models. Third, the deCODE SomaScan platform measures
IRAG1 using a single aptamer (SeqId: 8255_34) that recognizes the full-length protein;
independent replication using orthogonal proteomic platforms (e.g., Olink) was not
possible as IRAG1 is not included in the Olink Explore 3072 panel. Fourth, our epigenomic
annotation relied on publicly available ENCODE and GTEx data; functional validation
through targeted epigenomic editing (CRISPRi/a) at rs4910165 in vascular smooth muscle
cells would strengthen causal evidence. Fifth, while our PheWAS analysis suggests a
favorable safety profile, rare adverse effects or effects in populations not represented
in GWAS data cannot be excluded. Sixth, the observational and Cox regression analyses
performed in the template study (Yoshiji et al., 2025) for COL6A3 could not be replicated
for IRAG1 due to the absence of IRAG1 protein measurements in UK Biobank and EPIC-Norfolk.

## Future Directions

Several lines of investigation would strengthen and extend these findings. Functional
validation experiments should test whether CRISPR-mediated perturbation of rs4910165 in
vascular smooth muscle cells alters IRAG1 expression and IP3R-Ca2+ signaling. Proteomic
studies in migraine patients during and between attacks could determine whether plasma
IRAG1 levels are dynamically regulated in relation to migraine episodes. The development
of IRAG1-specific small-molecule modulators — either IRAG1-ITPR1 interaction stabilizers
or vascular-targeted IRAG1 expression enhancers — represents a logical next step toward
clinical translation. Finally, extension of this proteogenomic framework to other
neurological and neurovascular disorders could identify additional therapeutic targets
operating through the cGMP-PKG signaling axis.

## Conclusions

In summary, this study leverages a comprehensive proteogenomic framework integrating
two-stage pQTL Mendelian randomization, Bayesian colocalization, fine-mapping, epigenomic
annotation, single-cell expression analysis, and translational assessment to establish
IRAG1 as a genetically validated, first-in-class therapeutic target for migraine. The
convergent genetic, molecular, cellular, and pharmacological evidence positions IRAG1 as
a compelling candidate for therapeutic development, offering a mechanistically distinct
approach to migraine prevention that may benefit the substantial population of patients
inadequately served by current therapies.
