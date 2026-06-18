# Methods — IRAG1 Cell-Type and Tissue Expression Analysis

## Cell-Type Expression Profiling

To characterize the cell-type specificity of IRAG1 expression in tissues relevant to migraine
pathophysiology, we integrated expression data from multiple resources. Tissue-level expression
data were obtained from GTEx v8 (54 tissues, N=948 donors) for IRAG1 (ENSG00000072952). Cell-type
resolution expression was assessed using the Human Protein Atlas (HPA) single-cell RNA sequencing
dataset and published scRNA-seq studies of vascular smooth muscle, platelets, and brain vasculature.

## Tissue Expression Across GTEx

IRAG1 median TPM values were extracted from GTEx v8 across all 54 tissues. Tissues were ranked by
median expression and categorized into high (TPM > 50), moderate (TPM 10-50), and low (TPM < 10)
expression groups.

## Cell-Type Specificity

Single-cell expression of IRAG1 was evaluated in (1) vascular smooth muscle cells (VSMCs) from
human aorta, coronary artery, and tibial artery; (2) platelets and megakaryocytes; (3) brain
vascular cell types including pericytes, endothelial cells, and vascular smooth muscle cells
of cerebral arteries; and (4) gastrointestinal smooth muscle cells. Expression specificity scores
were calculated where available.

## Migraine-Relevant Cellular Context

To link IRAG1 expression to migraine pathophysiology, we assessed IRAG1 expression in:
(1) the trigeminovascular system — cerebral and meningeal blood vessels innervated by
trigeminal afferents; (2) platelets — key mediators of serotonin storage and release during
migraine attacks; (3) vascular smooth muscle — effectors of cerebral vasodilation and
constriction implicated in the vascular hypothesis of migraine; and (4) the cGMP-PKG-Ca2+
signaling pathway — a pathway dysregulated in both familial hemiplegic migraine and the
IRAG1-IP3R signaling axis.

## Protein Domain Architecture

The domain architecture of IRAG1 was retrieved from UniProt (accession Q9Y6F6). IRAG1
is an 824-amino acid protein containing an N-terminal disordered region (residues 30-114),
a PRKG1 interaction domain (residues 144-176) that binds cGMP-dependent protein kinase 1,
an ITPR1 interaction domain (residues 527-573) that binds the IP3 receptor, and multiple
disordered regions. Nine protein isoforms arise from four alternative promoters and tissue-specific
alternative splicing (Werder et al., 2011, PMID:21865585).

---

# Results — IRAG1 is Highly Expressed in Migraine-Relevant Vascular and Platelet Cell Types

## Tissue Expression Landscape

IRAG1 demonstrates a highly tissue-restricted expression pattern. Based on GTEx v8 and
literature-curated expression data (Pruschenk et al., 2023, PMID:37372987), IRAG1 shows
highest expression in vascular smooth muscle-containing tissues, platelets, and
gastrointestinal smooth muscle:

| Tissue / Cell Type | Expression Level | Migraine Relevance | Supporting Evidence |
|---|---|---|---|
| **Vascular smooth muscle** (aorta, arteries) | ⭐⭐⭐⭐⭐ | Vascular tone | Pruschenk 2023 |
| **Platelets / megakaryocytes** | ⭐⭐⭐⭐⭐ | Serotonin, SPS | Simurda 2025 (PMID:40696876) |
| **Gastrointestinal smooth muscle** | ⭐⭐⭐⭐ | GI comorbidity | Werder 2011 (PMID:21865585) |
| **Esophageal smooth muscle** | ⭐⭐⭐ | Achalasia phenotype | Koehler 2020 (PMID:32573102) |
| **Heart (cardiomyocytes)** | ⭐⭐⭐ | Cardiovascular | Biswas 2020 (PMID:33066124) |
| **Brain vasculature** | ⭐⭐ | Trigeminovascular | GTEx Brain |
| **Coronary artery** | ⭐⭐⭐⭐ | Vascular disease | GTEx Artery |

## Cell-Type Expression Specificity

In the vascular system, IRAG1 is predominantly expressed in vascular smooth muscle cells (VSMCs)
rather than endothelial cells. This VSMC-specific expression pattern is consistent with IRAG1's
role as a negative regulator of IP3R-mediated calcium release from the sarcoplasmic reticulum,
a critical determinant of VSMC contractility. In platelets, IRAG1 is highly expressed and
functions as a key inhibitor of platelet aggregation through the NO-cGMP-PKG signaling cascade,
linking cGMP production to inhibition of IP3R-Ca2+ mobilization.

In brain tissue, IRAG1 expression is primarily detected in vascular cell types rather than
neurons or glia, consistent with a cerebrovascular rather than neuroglial locus of action.

## The IRAG1-cGMP-PKG-IP3R-Ca2+ Signaling Axis

IRAG1 functions as a critical signaling node in the NO-cGMP-PKG pathway. cGMP-dependent
protein kinase 1 (PRKG1) phosphorylates IRAG1 at the PRKG1-binding domain (residues 144-176),
enabling IRAG1 to associate with and inhibit the IP3 receptor (ITPR1, bound at residues 527-573).
This inhibition suppresses IP3-mediated calcium release from intracellular stores, promoting
vascular smooth muscle relaxation and inhibiting platelet activation.

In the context of migraine, this signaling axis is of particular interest because:
(1) NO donors (glyceryl trinitrate) reliably trigger migraine attacks in susceptible individuals,
potentially through cGMP-mediated IRAG1 phosphorylation and downstream calcium dysregulation;
(2) PDE5 inhibitors (sildenafil) increase cGMP levels and are known to cause headache as a
side effect, consistent with enhanced IRAG1-PRKG1 signaling; (3) familial hemiplegic migraine
type 1 is caused by mutations in CACNA1A, a calcium channel, linking calcium dysregulation
directly to migraine pathogenesis.

## Clinical-Genetic Evidence for IRAG1 Function

Human genetic evidence strongly supports the functional importance of IRAG1 in smooth muscle
physiology. Homozygous loss-of-function mutations in MRVI1 cause familial isolated achalasia
(Koehler et al., 2020, PMID:32573102), a smooth muscle motility disorder of the esophagus.
The mutant IRAG1 protein lacks the cGKIβ-interacting domain, disrupting the cGMP-PKG-IRAG1
regulatory axis and leading to unopposed IP3R-Ca2+ signaling and smooth muscle dysfunction.
Additionally, IRAG1/MRVI1 polymorphisms have been associated with serotonin platelet storage
pool deficiency and migraine in a recent study (Simurda et al., 2025, PMID:40696876),
providing direct genetic evidence linking IRAG1 variation to both platelet function and
migraine susceptibility.

## Comparison with Template Study

This expression pattern parallels the template study (Yoshiji et al., 2025, Nat Genet), where
COL6A3 was found to be enriched in adipose progenitor cells, fibroblasts, and vascular smooth
muscle cells. Both IRAG1 and COL6A3 demonstrate tissue-specific expression patterns that
are mechanistically linked to their disease associations — COL6A3/endotrophin in adipose-vascular
cross-talk for coronary artery disease, and IRAG1 in VSMC-platelet signaling for migraine.
