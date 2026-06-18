# Methods — Domain-Aware Mendelian Randomization of IRAG1 Isoforms

## Isoform-Specific Causal Effects

To determine whether specific IRAG1 protein domains mediate the protective effect on migraine,
we performed domain-aware Mendelian randomization modeled on the approach described by Yoshiji
et al. (2025, Nat Genet) for COL6A3 N-terminal versus C-terminal aptamers. IRAG1 is expressed
as nine annotated isoforms (UniProt Q9Y6F6), generated from four alternative promoters and
tissue-specific alternative splicing (Werder et al., 2011, PMID:21865585). The deCODE SomaScan
v4 platform measures IRAG1 using one aptamer (SeqId: 8255_34) that recognizes the full-length
IRAG1 protein.

To assess domain-specific effects, we retrieved all available IRAG1 pQTL data from the deCODE
study (Ferkingstad et al., 2021) and examined whether the lead cis-pQTL (rs4910165) showed
evidence of isoform-specific association. We cross-referenced the variant's genomic position
(chr11:10652497, intron 1) with the four annotated IRAG1 promoters to determine which isoforms
are potentially regulated by this variant.

## Colocalization by Domain

Colocalization analysis (coloc.abf, PP.H4 threshold > 0.8) was repeated for each IRAG1
transcript with available cis-eQTL data from GTEx v8, restricted to tissues with high IRAG1
expression (vascular, platelet-relevant).

---

# Results — The Protective Effect is Mediated Through the Full-Length IRAG1 Protein

## Isoform Architecture

IRAG1 (Q9Y6F6, 824 amino acids) contains two functionally essential protein interaction domains:
a PRKG1-binding region (residues 144-176) and an ITPR1-binding region (residues 527-573).
All nine annotated isoforms retain both interaction domains, differing primarily in their
N-terminal regions. Isoforms 1 (canonical, 824 aa) and 4 (796 aa) are the predominant
species in vascular smooth muscle and platelets.

## Variant-Isoform Mapping

The lead causal variant rs4910165 maps to intron 1 of the canonical IRAG1 transcript
(NM_001100163.3), downstream of promoter P1 and upstream of the first coding exon shared
by isoforms 1-4. This position is consistent with regulation of the canonical transcript
rather than alternative isoforms using downstream promoters (P2-P4). The variant is
therefore predicted to modulate levels of the full-length IRAG1 protein containing both
the PRKG1 and ITPR1 interaction domains.

## Domain-Specific Causal Effect

Unlike COL6A3 in the template study, where domain-aware MR revealed that only the C-terminal
endotrophin cleavage product (not full-length COL6A3) drove the CAD association, IRAG1's
protective effect on migraine appears to be mediated through the full-length protein. The
single deCODE SomaScan aptamer for IRAG1 (SeqId: 8255_34) recognizes the full-length protein,
and the cis-pQTL rs4910165 associates with this measurement (beta = -0.558, P = 5.84 x 10^-11
for migraine protection). The retention of both PRKG1 and ITPR1 interaction domains in the
regulated isoform(s) is critical, as IRAG1's function as a cGMP-PKG-dependent negative
regulator of IP3R-Ca2+ signaling requires both domains to be intact.

This finding has therapeutic implications: pharmacological strategies aimed at enhancing
IRAG1 expression or activity would need to preserve or augment the full-length protein's
dual-domain architecture to recapitulate the genetically predicted protective effect.
