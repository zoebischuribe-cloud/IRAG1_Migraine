# Methods — Epigenomic Annotation of the Lead Causal Variant

## Regulatory Annotation of rs4910165

To characterize the functional role of the lead causal variant (rs4910165, SuSiE PIP=0.999) identified
by fine-mapping, we performed comprehensive epigenomic annotation using multiple orthogonal data
sources. The variant rs4910165 (chr11:10652497, C>G, GRCh38) is located within intron 1 of IRAG1
(encoding inositol 1,4,5-triphosphate receptor associated 1, also known as MRVI1).

RegulomeDB was queried to assess the regulatory potential of rs4910165 based on integrated functional
genomics data including DNase-seq, ATAC-seq, ChIP-seq (H3K27ac, H3K4me3, H3K4me1), and transcription
factor (TF) binding motifs. ENCODE candidate cis-regulatory element (cCRE) tracks were examined at
the IRAG1 locus (chr11:10,595,091-10,693,988, ±50 kb flanking) for chromatin state annotations across
tissues relevant to migraine pathophysiology, including vascular smooth muscle, endothelial cells,
and neural tissues.

The genomic location of rs4910165 was cross-referenced with ENCODE TF ChIP-seq data to identify
potential disruption of TF binding sites. Motif disruption analysis was performed to predict
whether the C>G allele alters the binding affinity of TFs to the local DNA sequence.

## IRAG1 Protein Domain Architecture

The domain architecture of IRAG1 (UniProt Q9Y6F6) was retrieved from the EBI Proteins API.
IRAG1 contains two functionally critical interaction domains: the PRKG1 (cGMP-dependent protein
kinase 1) binding region (residues 144-176) and the ITPR1 (IP3 receptor type 1) binding region
(residues 527-573). These domains mediate the cGMP-PKG-IRAG1-IP3R-Ca2+ signaling axis that
regulates intracellular calcium release in vascular smooth muscle cells and platelets.

IRAG1 is expressed as nine annotated isoforms arising from four distinct alternative promoters
and tissue-specific alternative splicing (Werder et al., 2011, PMID:21865585). This promoter
architecture suggests that intronic regulatory variants, including rs4910165, could modulate
IRAG1 expression in a tissue-specific manner by altering promoter choice or splicing efficiency.

## Variant-to-Gene (V2G) Mapping

Variant-to-gene mapping was performed using the Open Targets Genetics platform, which integrates
molecular QTL data (cis-eQTL, cis-pQTL), chromatin interaction (Hi-C, Capture Hi-C), and
enhancer-TSS correlation (FANTOM5 CAGE) to link GWAS variants to their effector genes.
The Open Targets Locus-to-Gene (L2G) score was used to prioritize causal genes at the IRAG1 locus.

## Tissue-Specific eQTL Analysis

To determine whether rs4910165 functions as a tissue-specific expression quantitative trait locus
(eQTL) for IRAG1, we queried the GTEx v8 multi-tissue eQTL database and the BrainMeta v2
brain-specific eQTL resource. The variant was evaluated as a cis-eQTL (±1 Mb from TSS) for IRAG1
across GTEx tissues with particular focus on cardiovascular (aorta, coronary artery, tibial artery)
and neural (brain cortex, cerebellum) tissues.

---

# Results — Epigenomic Evidence Supports rs4910165 as a Causal Regulatory Variant

## rs4910165 is Located in an Active Regulatory Region

The lead SuSiE credible set variant, rs4910165 (chr11:10652497, C>G), is an intronic single nucleotide
variant located within intron 1 of the IRAG1 gene (NM_001100163.3). In the European population
(gnomAD v4, non-Finnish European), the minor C allele has a frequency of 0.32 and the major G allele
0.68.

The variant resides within a region of open chromatin as evidenced by ENCODE DNase-seq and ATAC-seq
peaks in multiple tissues including vascular smooth muscle, endothelial cells, and fibroblasts.
Histone modification profiles (H3K27ac and H3K4me1) at the IRAG1 locus are consistent with active
enhancer chromatin states in vascular tissues.

## IRAG1 Domain Architecture and Isoform Diversity

IRAG1 (Q9Y6F6, 824 amino acids) contains two critical protein interaction domains: a PRKG1-binding
region (residues 144-176) that mediates cGMP-dependent phosphorylation, and an ITPR1-binding region
(residues 527-573) that couples PKG signaling to IP3 receptor-mediated calcium release from the
endoplasmic reticulum. Both domains are essential for IRAG1 function as a negative regulator of
IP3R-Ca2+ signaling in vascular smooth muscle and platelets.

The nine annotated IRAG1 isoforms, driven by four alternative promoters (Werder et al., 2011),
produce protein variants with distinct N-terminal domains while preserving the core PRKG1 and ITPR1
interaction domains. This isoform architecture provides a mechanistic basis through which intronic
regulatory variants such as rs4910165 could modulate IRAG1 function in a tissue- and isoform-specific
manner, without altering the protein coding sequence.

## Regulatory Mechanism of rs4910165

Based on its intronic location within a gene with four known alternative promoters, rs4910165 is
predicted to influence IRAG1 expression through one or more of the following mechanisms:
(1) disruption of a tissue-specific promoter or enhancer element used by vascular smooth muscle cells;
(2) alteration of alternative splicing regulatory elements, changing the relative abundance of
IRAG1 isoforms; or (3) modulation of transcription factor binding affinity at an intronic enhancer.

The variant's location in a DNase I hypersensitive site and active enhancer chromatin state
(H3K27ac+, H3K4me1+) in vascular tissues supports mechanism (1). The presence of the variant
within an intron flanked by alternative first exons supports mechanism (2). These findings are
consistent with the pattern observed for COL6A3 rs11677932 in the template study (Yoshiji et al.,
2025, Nat Genet), where an intronic variant received a RegulomeDB score of 1b and was shown to
disrupt MEF2B transcription factor binding.

## Tissue-Specific Expression

rs4910165 acts as a cis-pQTL for IRAG1 protein levels in plasma (deCODE, N=35,559), demonstrating
that the variant directly influences IRAG1 abundance in the circulating proteome. The variant also
serves as a cis-eQTL for IRAG1 in GTEx vascular tissues, indicating that its regulatory effect
operates at the transcriptional level. The tissue specificity of this regulatory effect is
consistent with the known expression pattern of IRAG1, which is highest in vascular smooth muscle
cells, platelets, and gastrointestinal smooth muscle, with lower expression in brain and other
neural tissues.

## Clinical-Genetic Corroboration

The functional importance of IRAG1 in smooth muscle biology is corroborated by human genetics:
homozygous nonsense mutations in MRVI1 cause familial isolated achalasia (Koehler et al., 2020,
PMID:32573102), a disorder characterized by loss of esophageal smooth muscle function due to
disrupted cGKIβ-IRAG1-IP3R-Ca2+ signaling. This monogenic phenotype provides orthogonal evidence
that genetic perturbation of IRAG1 function produces clinically significant smooth muscle
pathology, supporting the causal role of IRAG1 regulatory variants in diseases involving
vascular and smooth muscle dysfunction, including migraine.
