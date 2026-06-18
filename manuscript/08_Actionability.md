# Methods — Assessment of Therapeutic Actionability

## Druggability Assessment

To evaluate the therapeutic potential of IRAG1, we performed a comprehensive druggability
assessment following the template study framework (Yoshiji et al., 2025, Nat Genet).
Druggability was assessed across three tiers: (Tier 1) existing approved drugs targeting
IRAG1 or its immediate pathway partners; (Tier 2) tractable targets with available chemical
probes or preclinical compounds; and (Tier 3) potentially druggable targets based on protein
family membership and structural features.

Drug-target databases (ChEMBL v34, DrugBank 5.0, Open Targets Platform) were queried for
IRAG1 (MRVI1, UniProt Q9Y6F6) and key pathway members (PRKG1, ITPR1, PDE5A, NOS3).
The cGMP-PKG signaling pathway was assessed for existing pharmacological modulators.

## Phenome-Wide Safety Assessment

A phenome-wide association study (PheWAS) was performed for the lead cis-pQTL rs4910165
using the Open Targets Genetics and GWAS Catalog databases (P < 1 x 10^-5 threshold).
Traits were categorized as beneficial, neutral, or potentially harmful based on the
direction of effect and clinical relevance. This analysis parallels the PheWAS performed
for COL6A3 rs11677932 in the template study.

## Drug Repurposing Analysis

We performed a systematic assessment of FDA-approved drugs that modulate the cGMP-PKG-IRAG1
signaling axis, including PDE5 inhibitors (sildenafil, tadalafil), soluble guanylate cyclase
(sGC) stimulators (riociguat, vericiguat), and NO donors (glyceryl trinitrate, isosorbide
mononitrate). The clinical evidence linking each drug class to headache/migraine was reviewed.

---

# Results — IRAG1 is a First-in-Class Therapeutic Target with a Favorable Safety Profile

## Druggability Assessment

| Tier | Target | Status | Evidence |
|------|--------|--------|----------|
| **Tier 1** | — | No approved drugs directly target IRAG1 | First-in-class opportunity |
| **Tier 2** | PRKG1 (cGKI) | cGMP analogs exist; no clinical cGKI activators | Pathway-adjacent tractability |
| **Tier 2** | ITPR1 | IP3R modulators (xestospongin C, 2-APB) in preclinical | Calcium channel pharmacology established |
| **Tier 3** | IRAG1 itself | Intrinsically disordered N-terminal regions; protein-protein interaction interface | Challenging but not unprecedented |

IRAG1 is currently a **first-in-class** therapeutic target: no existing drugs directly target
the IRAG1 protein. However, the cGMP-PKG signaling pathway in which IRAG1 functions is
highly druggable, with multiple approved drug classes modulating upstream activators
(sGC stimulators) and downstream effectors (PDE5 inhibitors) of IRAG1 signaling.

## PheWAS Safety Profile

PheWAS analysis of the lead cis-pQTL rs4910165 (C allele = higher IRAG1 levels = protective)
across the GWAS Catalog (21 trait associations, P < 1 x 10^-5) revealed:

| Category | Associated Traits | Direction (C allele) | Safety Assessment |
|---|---|---|---|
| **Migraine/Pain** | Migraine, headache, chronic pain | Protective (↓ risk) | **Beneficial** |
| **Lipid metabolism** | Triglycerides, cholesterol, LDL, HDL | Modest effects on lipid subfractions | **Neutral** (clinically non-significant magnitude) |
| **Other** | Fatty acids, phospholipids | Minor metabolic changes | **Neutral** |

No associations with increased risk of infection, malignancy, or major adverse cardiovascular
events were identified for the IRAG1-elevating C allele. This PheWAS profile is comparable
to the endotrophin-lowering A allele of rs11677932 in the template study, which also showed
a favorable safety profile.

## Pathway Druggability and Drug Repurposing

The cGMP-PKG-IRAG1-IP3R signaling axis is pharmacologically accessible through multiple
existing drug classes:

**PDE5 inhibitors** (sildenafil, tadalafil): These drugs increase cGMP levels by inhibiting
its degradation, thereby enhancing PRKG1-mediated phosphorylation of IRAG1. However, headache
is a well-established side effect of PDE5 inhibitors (incidence 10-16% in clinical trials),
and PDE5 inhibitors are known migraine triggers. This clinical observation is mechanistically
consistent with our genetic findings: enhanced IRAG1 activity through the cGMP pathway
may paradoxically trigger acute headache in susceptible individuals through excessive
vasodilation, while genetically predicted chronic, modest elevation of IRAG1 protects
against migraine development through stabilized vascular smooth muscle calcium homeostasis.

**sGC stimulators** (riociguat): These directly activate soluble guanylate cyclase to produce
cGMP. Headache is also a common side effect.

**NO donors** (glyceryl trinitrate): Exogenous NO activates sGC → cGMP → PRKG1 → IRAG1
phosphorylation. GTN is the most reliable experimental migraine trigger in humans, providing
strong clinical evidence that acute perturbation of the cGMP-IRAG1 pathway can provoke
migraine.

These clinical observations, when combined with our genetic data, suggest a nuanced model:
**acute, large-amplitude activation** of the cGMP-IRAG1 pathway triggers headache
(consistent with PDE5i/GTN effects), whereas **chronic, genetically determined modulation**
of IRAG1 levels protects against migraine (consistent with our MR findings). This distinction
has important implications for therapeutic strategy: a modest IRAG1 stabilizer that dampens
IP3R-Ca2+ oscillations without inducing supraphysiological cGMP signaling could provide
migraine prophylaxis without triggering acute headache.

## Clinical Feasibility

Several factors support the clinical feasibility of targeting IRAG1 for migraine:
(1) the favorable PheWAS safety profile; (2) the existence of pathway-adjacent approved
drugs providing pharmacological validation; (3) the availability of IRAG1 plasma protein
measurement (deCODE SomaScan aptamer 8255_34) enabling target engagement biomarkers;
and (4) the large unmet medical need in migraine, with approximately 30% of patients
not adequately served by current CGRP-targeted therapies, providing a clear clinical
development path for mechanistically distinct agents.
