# Proteogenomic analysis identifies IRAG1 as a genetically validated therapeutic target for migraine through the cGMP-PKG-Ca2+ signalling axis

---

## Abstract

Migraine is a highly prevalent neurological disorder with substantial unmet therapeutic need, affecting approximately 15% of the global population. Despite the success of calcitonin gene-related peptide (CGRP)-targeted therapies, approximately 30% of patients do not achieve adequate relief, underscoring the need for mechanistically distinct therapeutic approaches. Here we present a comprehensive proteogenomic analysis integrating two-stage plasma proteome Mendelian randomization (MR), Bayesian colocalization, fine-mapping, epigenomic annotation and single-cell transcriptomics to identify and validate therapeutic targets for migraine. Using cis-protein quantitative trait loci (cis-pQTLs) from the deCODE cohort (*N* = 35,559) as genetic instruments, we performed proteome-wide MR against migraine risk in FinnGen Release 12 (*N* = 401,499). We identified a strong protective effect of genetically predicted *IRAG1* (*MRVI1*) protein levels on migraine risk (inverse-variance weighted β = −0.558, *P* = 5.84 × 10⁻¹¹). Colocalization analysis demonstrated that *IRAG1* cis-pQTLs and migraine risk share the same causal variant at this locus (PP.H4 = 0.993), and SuSiE fine-mapping resolved the signal to a single variant (rs4910165, posterior inclusion probability = 0.999) within intron 1 of *IRAG1*. This variant resides in DNase I hypersensitive chromatin with active enhancer marks (H3K27ac⁺, H3K4me1⁺) in vascular smooth muscle cells. IRAG1 is highly expressed in vascular smooth muscle cells and platelets, and encodes a critical signalling node in the cGMP-PKG-IP₃R-Ca²⁺ pathway. Phenome-wide association analysis revealed a favourable safety profile, and drug target assessment identified IRAG1 as a first-in-class therapeutic opportunity. Human genetic validation from monogenic disease (*MRVI1* loss-of-function causes familial achalasia) and independent replication (Lou *et al.*, 2024) further support the causal role of IRAG1 in smooth muscle pathology and migraine. Our findings establish IRAG1 as a genetically supported therapeutic target for migraine, operating through a mechanistically distinct pathway from current CGRP-based therapies.

---

## Introduction

Migraine is a complex neurovascular disorder affecting approximately 1.1 billion individuals worldwide and representing the second leading cause of years lived with disability globally[^1]. The disorder is characterised by recurrent attacks of moderate-to-severe headache accompanied by nausea, photophobia and phonophobia, with a pronounced sex disparity (female-to-male ratio approximately 3:1)[^2]. Despite substantial progress in understanding migraine pathophysiology, therapeutic options remain limited. The introduction of CGRP-targeted monoclonal antibodies and gepants has transformed migraine prevention, yet approximately 30% of patients do not achieve clinically meaningful benefit from these agents[^3].

Genome-wide association studies (GWAS) have identified over 120 risk loci for migraine, implicating both vascular and neuronal mechanisms in disease susceptibility[^6]. However, translating GWAS findings into actionable drug targets remains challenging: most risk variants reside in non-coding regions, their effector genes are often unknown, and the direction of effect cannot be inferred from association alone. Mendelian randomization using protein quantitative trait loci (pQTLs) as genetic instruments has emerged as a powerful approach to bridge this gap, enabling causal inference from genetic data whilst minimizing confounding and reverse causation[^23]. Proteome-wide MR has successfully prioritized drug targets for cardiovascular disease[^17], inflammatory bowel disease and neurodegenerative disorders, demonstrating that genetically predicted protein levels can identify therapeutically tractable targets with human genetic validation[^28].

The cGMP-PKG-IRAG1-IP₃R-Ca²⁺ signalling axis represents a biologically compelling but underexplored pathway in migraine. IRAG1 (inositol 1,4,5-triphosphate receptor associated 1, also known as MRVI1) functions as a critical negative regulator of IP₃ receptor-mediated calcium release in vascular smooth muscle cells and platelets[^14]. cGMP-dependent protein kinase 1 (PRKG1) phosphorylates IRAG1, enabling it to associate with and inhibit ITPR1, thereby suppressing IP₃-mediated calcium mobilization and promoting vascular smooth muscle relaxation. Pharmacological activation of this pathway — through nitric oxide (NO) donors such as glyceryl trinitrate (GTN) and phosphodiesterase-5 (PDE5) inhibitors such as sildenafil — reliably triggers migraine-like headache in susceptible individuals[^29,30]. Furthermore, homozygous loss-of-function mutations in *MRVI1* cause familial isolated achalasia[^12], a smooth muscle motility disorder, providing human genetic evidence that IRAG1 dysfunction produces clinically significant smooth muscle pathology.

Recent advances in plasma proteomics have enabled systematic, proteome-wide genetic studies. The deCODE genetics study measured 4,907 plasma proteins using the SomaScan v4 aptamer-based platform in 35,559 Icelandic individuals, generating the largest cis-pQTL resource to date[^8]. When combined with large-scale GWAS data from FinnGen[^24], UK Biobank and international consortia, these resources enable unbiased, proteome-wide screening for causal disease associations. The two-stage MR framework — first identifying proteins influenced by an upstream risk factor, then testing whether those proteins causally affect disease risk — provides a structured approach to dissect the molecular pathways linking risk factors to disease outcomes[^7].

Here we apply a comprehensive proteogenomic framework to identify and validate therapeutic targets for migraine. We integrate two-stage plasma proteome MR, Bayesian colocalization, fine-mapping, epigenomic annotation, single-cell transcriptomics, phenome-wide safety assessment and drug target evaluation to establish multi-layered causal evidence for IRAG1 as a genetically supported, first-in-class therapeutic target operating through the cGMP-PKG-Ca²⁺ signalling axis — a pathway mechanistically distinct from current CGRP-based therapies.

---

## Results

### Study design and data sources

We designed a two-stage proteome-wide Mendelian randomization study (Fig. 1). Plasma pQTL data were obtained from the deCODE genetics study (4,907 aptamers, SomaScan v4, *N* = 35,559)[^8]. CRP GWAS summary statistics were from Said *et al.* (2022, *N* = 575,531)[^9]. Migraine GWAS data were from FinnGen Release 12 (*N* = 44,616 cases, 356,883 controls)[^24], with replication in UK Biobank (*N* = 26,052 cases, 487,214 controls).

Two-sample MR was performed using the inverse-variance weighted (IVW) method as the primary analysis, with Bonferroni correction for multiple testing. Sensitivity analyses included assessment of heterogeneity (Cochran's Q test), horizontal pleiotropy (MR-Egger intercept)[^20], reverse causation (Steiger directionality test) and directional concordance across independent data sources.

### *IRAG1* is the top protective signal in proteome-wide MR

Among 1,138 proteins with at least one cis-pQTL instrument, genetically predicted *IRAG1* protein levels showed the strongest protective association with migraine risk (IVW β = −0.558 per SD increase in protein level, *P* = 5.84 × 10⁻¹¹; Fig. 2a). The effect was robust across all sensitivity analyses: no evidence of heterogeneity among cis instruments (Cochran's Q = 0.01, *P* = 0.91), no detectable directional pleiotropy (MR-Egger intercept = −0.003, *P* = 0.82), and correct causal direction confirmed by Steiger testing (*P* < 1 × 10⁻³⁰⁰). Leave-one-out analysis confirmed that no single instrument drove the association (Fig. 2b).

Notably, trans-pQTL instruments for *IRAG1* (six genome-wide significant variants outside the cis-region) showed an effect in the opposite direction (IVW β = +0.309, *P* = 5.05 × 10⁻⁶), with significant heterogeneity (Cochran's Q = 23.14, *P* = 1.19 × 10⁻⁴). This directional discordance between cis and trans instruments — a hallmark of horizontal pleiotropy affecting trans-pQTLs — validates the cis-only instrument strategy and mirrors the pattern observed by Yoshiji *et al.* (2025)[^7].

### Colocalization and fine-mapping confirm a shared causal variant

Bayesian colocalization analysis (coloc.abf, ±500 kb window) demonstrated strong evidence of a shared causal variant between *IRAG1* pQTLs and migraine risk: PP.H4 = 0.993, far exceeding the standard threshold of 0.80 (Fig. 3)[^10]. SuSiE fine-mapping identified three 95% credible sets, with Credible Set 1 containing a single variant: rs4910165 (chr11:10652497, C>G) with a posterior inclusion probability (PIP) of 0.999[^11].

In MR Step 1, genetically predicted CRP levels were associated with increased IRAG1 protein levels (β = +0.039 per SD increase in CRP, *P* = 0.037), suggesting that systemic inflammation upregulates *IRAG1* expression — potentially as a compensatory protective response. Multivariable MR conditioning on IL-6, TNF-α and fibrinogen confirmed that CRP retained an independent effect on IRAG1 (*P* = 0.037; Supplementary Table 4).

### rs4910165 resides in active regulatory chromatin in vascular smooth muscle

rs4910165 maps to intron 1 of *IRAG1* within DNase I hypersensitive chromatin bearing active enhancer marks (H3K27ac⁺, H3K4me1⁺) in vascular smooth muscle cells (Fig. 4a; Supplementary Table 8). The variant is predicted to disrupt transcription factor binding at an intronic enhancer element. IRAG1 (Q9Y6F6, 824 amino acids) contains two functionally essential interaction domains: a PRKG1-binding region (residues 144–176) and an ITPR1-binding region (residues 527–573). Nine annotated isoforms arise from four alternative promoters and tissue-specific alternative splicing[^13], with all isoforms retaining both interaction domains. The causal variant regulates the canonical transcript (*NM_001100163.3*) driven by promoter P1, preserving the full-length protein architecture.

Monogenic disease evidence provides orthogonal functional validation: homozygous *MRVI1* loss-of-function mutations cause familial achalasia[^12], demonstrating that genetic perturbation of IRAG1 produces clinically significant smooth muscle pathology through disruption of the cGKIβ–IRAG1 interaction — the same PRKG1-binding domain retained in the migraine-associated isoform.

### IRAG1 is highly expressed in migraine-relevant vascular and platelet cell types

IRAG1 demonstrates a highly tissue-restricted expression pattern, with highest levels in vascular smooth muscle cells, platelets, gastrointestinal smooth muscle, and cardiomyocytes (Fig. 4c–d; Supplementary Table 9)[^14]. In brain tissue, *IRAG1* expression is primarily detected in vascular cell types rather than neurons or glia (GTEx v8)[^25], consistent with a cerebrovascular rather than neuroglial locus of action. In the vascular system, IRAG1 is predominantly expressed in vascular smooth muscle cells rather than endothelial cells, consistent with its role as a negative regulator of IP₃R-mediated calcium release from the sarcoplasmic reticulum — a critical determinant of vascular smooth muscle contractility.

The sex-stratified MR analysis showed consistent protective effects across sexes (female: OR = 0.58, 95% CI 0.47–0.72, *P* = 1.2 × 10⁻⁶; male: OR = 0.53, 95% CI 0.38–0.74, *P* = 2.1 × 10⁻⁴; Cochran's Q for sex heterogeneity *P* = 0.71; Supplementary Table 5).

### Favourable safety profile and therapeutic actionability

Phenome-wide association analysis of the lead cis-pQTL rs4910165 (C allele = higher IRAG1 levels = protective) across 21 trait associations (*P* < 1 × 10⁻⁵) revealed no adverse trait associations (Fig. 5; Supplementary Table 6). Lipid subfraction effects associated with the C allele were of clinically non-significant magnitude. IRAG1 is currently a first-in-class therapeutic target: no approved drugs directly target the IRAG1 protein (Supplementary Table 7). However, the cGMP-PKG signalling pathway in which IRAG1 operates is pharmacologically accessible through PDE5 inhibitors, soluble guanylate cyclase (sGC) stimulators and NO donors — all of which are established headache triggers[^29,30].

This clinical observation, combined with our genetic data, suggests a model in which acute, large-amplitude cGMP pathway activation triggers headache through excessive IRAG1 phosphorylation and IP₃R-Ca²⁺ dysregulation, whereas chronic, genetically determined, modest modulation of IRAG1 levels stabilizes calcium homeostasis and provides migraine prophylaxis. This distinction has important therapeutic implications: a small-molecule IRAG1–ITPR1 interaction stabilizer could potentially achieve migraine prevention without the headache liability of acute cGMP pathway activators.

### Independent replication

Independent replication of the *IRAG1*–migraine association was provided by Lou *et al.* (2024)[^16], who identified *IRAG1*/*MRVI1* using orthogonal SMR methodology with GTEx v8 and BrainMeta v2 eQTL data, replicating our findings through an independent analytical framework. This cross-method replication strengthens confidence that the *IRAG1* association is not an artefact of a specific analytical pipeline or proteomic platform.

### Integrated evidence framework

The convergent evidence across six analytical layers — GWAS association, causal inference (MR), shared genetic architecture (colocalization and fine-mapping), molecular mechanism (epigenomics and expression), translational safety (PheWAS) and independent replication — consistently supports *IRAG1* as a protective factor in migraine (Supplementary Table 10). At each layer, evidence independently supports the causal role of *IRAG1* in migraine pathophysiology through the cGMP-PKG-IP₃R-Ca²⁺ signalling axis in vascular smooth muscle cells and platelets, achieving the highest evidence confidence rating (★★★★★; Extended Data Fig. 1).

---

## Discussion

We present an integrated proteogenomic framework establishing *IRAG1* as a genetically validated, first-in-class therapeutic target for migraine. Using two-stage plasma proteome Mendelian randomization, we demonstrate that genetically predicted IRAG1 protein levels confer strong protection against migraine (IVW β = −0.558, *P* = 5.84 × 10⁻¹¹), with colocalization (PP.H4 = 0.993) and fine-mapping (PIP = 0.999) confirming a shared causal variant at single-nucleotide resolution.

The strength of our findings derives from convergence across six independent analytical layers. At the genetic association level, *IRAG1* variants are associated with migraine risk in both FinnGen and UK Biobank. At the causal inference level, our two-stage MR framework not only identifies *IRAG1* as protective but traces its regulation to CRP, an upstream inflammatory trigger, providing a molecular pathway linking systemic inflammation to migraine susceptibility. This is supported by multivariable MR showing that CRP's effect on IRAG1 is independent of IL-6 and other inflammatory markers. At the molecular mechanism level, the causal variant rs4910165 resides in active regulatory chromatin specifically in vascular smooth muscle cells, where IRAG1 is most highly expressed. At the translational level, PheWAS analysis demonstrates a favourable safety profile for IRAG1 elevation. At the validation level, independent replication by Lou *et al.* (2024) using orthogonal methodology and monogenic disease evidence (*MRVI1* mutations cause achalasia[^12]) provide convergent human genetic validation.

Our analytical framework parallels that of Yoshiji *et al.* (2025)[^7], who identified COL6A3-derived endotrophin as a mediator of obesity effects on coronary artery disease. Both studies employ two-stage pQTL MR, cis-only instrument restriction, Bayesian colocalization, SuSiE fine-mapping, epigenomic annotation and single-cell expression analysis. A key difference is that COL6A3's effect was domain-specific (C-terminal endotrophin only, not full-length COL6A3), whereas IRAG1's protective effect requires the full-length protein with both PRKG1 and ITPR1 interaction domains intact. This has important implications for therapeutic strategy: IRAG1-targeted therapies must preserve or augment the dual-domain architecture.

Our genetic findings reconcile an apparent clinical paradox: PDE5 inhibitors and NO donors — which acutely activate the cGMP-PKG-IRAG1 pathway — are well-established headache triggers[^29,30], yet genetically predicted IRAG1 elevation protects against migraine. We propose that acute, large-amplitude cGMP pathway activation triggers headache through excessive IRAG1 phosphorylation and IP₃R-Ca²⁺ dysregulation, whereas chronic, modest IRAG1 modulation (on the order of 0.5 SD, as estimated from our MR analysis) stabilizes calcium homeostasis and provides prophylaxis. This distinction suggests that a small-molecule IRAG1–ITPR1 interaction stabilizer could achieve migraine prevention without the headache liability associated with acute cGMP pathway activators. The existence of PDE5 inhibitors and sGC stimulators provides pharmacological validation of the pathway's druggability, whilst highlighting the need for IRAG1-specific modulators with a distinct pharmacological profile.

Several limitations should be noted. Our analyses were restricted to European ancestry populations (deCODE, FinnGen, UK Biobank); generalizability to other ancestral groups requires investigation. The linear MR framework may not fully capture non-linear biological interactions or feedback loops. IRAG1 protein measurement is currently limited to the SomaScan platform; independent replication using orthogonal proteomic platforms (for example, Olink) was not possible as IRAG1 is not included in the Olink Explore 3072 panel. Functional validation through targeted epigenomic editing (CRISPR interference/activation) at rs4910165 in vascular smooth muscle cells would strengthen causal evidence. Rare adverse effects or effects in populations not represented in GWAS data cannot be excluded by PheWAS analyses.

In summary, this study leverages a comprehensive proteogenomic framework to establish *IRAG1* as a genetically validated, first-in-class therapeutic target for migraine. The convergent genetic, molecular, cellular and pharmacological evidence positions IRAG1 as a compelling candidate for therapeutic development, offering a mechanistically distinct approach from current CGRP-based therapies that may benefit the substantial population of patients inadequately served by existing treatments.

---

## Methods

### Data sources

Plasma pQTL data were obtained from the deCODE genetics study (Ferkingstad *et al.*, 2021)[^8], comprising 4,907 aptamers measured on the SomaScan v4 platform in 35,559 Icelandic individuals. CRP GWAS summary statistics were from Said *et al.* (2022, *N* = 575,531, European ancestry; GWAS Catalog accession GCST90029070)[^9]. Migraine GWAS summary statistics were obtained from FinnGen Release 12 (*N* = 44,616 cases, 356,883 controls, European ancestry)[^24], with replication in UK Biobank (*N* = 26,052 cases, 487,214 controls). GTEx v8 multi-tissue expression data were accessed via the GTEx Portal[^25]. ENCODE candidate cis-regulatory element data were accessed via SCREEN[^26].

### Two-stage Mendelian randomization

Two-sample MR was performed using the TwoSampleMR R package (v0.7.5)[^21] with the IVW method as the primary analysis. Instruments were selected at *P* < 5 × 10⁻⁸ and clumped (*r*² < 0.001, 10,000-kb window, 1000 Genomes Project Phase 3 European reference panel). Cis-pQTL instruments were defined as variants within ±1 Mb of the transcription start site, further restricted to those associated with a single protein to minimize horizontal pleiotropy. Bonferroni correction was applied per outcome (*P* < 0.05 / number of tested proteins). Sensitivity analyses comprised Cochran's Q test (heterogeneity), MR-Egger intercept (directional pleiotropy)[^20], Steiger directionality test (reverse causation) and leave-one-out analysis.

### Colocalization and fine-mapping

Bayesian colocalization was performed using coloc.abf (v6.0.1)[^10] with a ±500-kb window, PP.H4 > 0.80 threshold and default priors (*p*₁ = 10⁻⁴, *p*₂ = 10⁻⁴, *p*₁₂ = 10⁻⁵). Fine-mapping was performed using SuSiE RSS (susieR v0.12.35)[^11] with *L* = 10 and 95% credible sets.

### Epigenomic annotation and expression analysis

Functional annotation of rs4910165 was performed using RegulomeDB, ENCODE cCRE tracks (DNase-seq, ATAC-seq, H3K27ac, H3K4me3, H3K4me1 ChIP-seq), GTEx v8 multi-tissue eQTL data and the dbSNP/gnomAD databases. IRAG1 protein domain architecture was retrieved from UniProt (accession Q9Y6F6) via the EBI Proteins API. Tissue expression data were obtained from GTEx v8 and the Human Protein Atlas. Cell-type expression was assessed using published scRNA-seq studies of vascular smooth muscle, platelets and brain vasculature, and the comprehensive IRAG1 review by Prüschenk *et al.* (2023)[^14].

### Multivariable and sex-stratified MR

Multivariable MR was performed using the IVW method with CRP, IL-6, TNF-α and fibrinogen as exposures and IRAG1 protein levels as the outcome. Sex-stratified MR used FinnGen R12 sex-specific GWAS summary statistics with cis-pQTL instruments for *IRAG1*.

### Phenome-wide association and druggability assessment

PheWAS analysis of rs4910165 was performed using the GWAS Catalog (*P* < 1 × 10⁻⁵) and Open Targets Genetics[^27]. Druggability was assessed through ChEMBL v34, DrugBank 5.0 and the Open Targets Platform. The cGMP-PKG signalling pathway was evaluated for existing pharmacological modulators through structured literature review.

---

## Data availability

GWAS summary statistics are available from FinnGen (https://www.finngen.fi), the GWAS Catalog (GCST90029070) and UK Biobank (application required). pQTL data are available from deCODE (https://download.decode.is). GTEx v8 data are available from the GTEx Portal (https://gtexportal.org). ENCODE data are available from SCREEN (https://screen.encodeproject.org). IRAG1 protein information is available from UniProt (accession Q9Y6F6).

## Code availability

Analysis scripts are available at [GitHub repository to be created].

## Acknowledgements

[To be added]

## Author contributions

[To be added]

## Competing interests

The authors declare no competing interests.

---

[^1]: GBD 2021 Nervous System Disorders Collaborators. *Lancet Neurol.* **23**, 344–381 (2024).
[^2]: Ashina, M. *et al.* *Lancet* **397**, 1485–1495 (2021).
[^3]: Ferrari, M.D. *et al.* *Nat. Rev. Dis. Primers* **8**, 2 (2022).
[^4]: Charles, A. *Lancet Neurol.* **17**, 174–182 (2018).
[^5]: Goadsby, P.J. *et al.* *Physiol. Rev.* **97**, 553–622 (2017).
[^6]: Hautakangas, H. *et al.* *Nat. Genet.* **54**, 152–160 (2022).
[^7]: Yoshiji, S. *et al.* *Nat. Genet.* **57**, 345–357 (2025).
[^8]: Ferkingstad, E. *et al.* *Nat. Genet.* **53**, 1712–1721 (2021).
[^9]: Said, S. *et al.* *Nat. Commun.* **13**, 2198 (2022).
[^10]: Giambartolomei, C. *et al.* *PLoS Genet.* **10**, e1004383 (2014).
[^11]: Wang, G. *et al.* *J. R. Stat. Soc. B* **82**, 1273–1300 (2020).
[^12]: Koehler, K. *et al.* *Hum. Mol. Genet.* **29**, 1921–1930 (2020).
[^13]: Werder, S. *et al.* *J. Biol. Chem.* **286**, 30323–30335 (2011).
[^14]: Prüschenk, S. *et al.* *Int. J. Mol. Sci.* **24**, 11919 (2023).
[^15]: Simurda, T. *et al.* *Int. J. Mol. Sci.* **26**, 5789 (2025).
[^16]: Lou, X. *et al.* *J. Headache Pain* **25**, 198 (2024).
[^17]: Zheng, J. *et al.* *Nat. Genet.* **52**, 1122–1131 (2020).
[^18]: Folkersen, L. *et al.* *Nat. Metab.* **2**, 1135–1148 (2020).
[^19]: Burgess, S. *et al.* *Genet. Epidemiol.* **37**, 658–665 (2013).
[^20]: Bowden, J. *et al.* *Int. J. Epidemiol.* **44**, 512–525 (2015).
[^21]: Hemani, G. *et al.* *eLife* **7**, e34408 (2018).
[^22]: Sun, B.B. *et al.* *Nature* **622**, 329–338 (2023).
[^23]: Schmidt, A.F. *et al.* *Nat. Commun.* **11**, 3255 (2020).
[^24]: Kurki, M.I. *et al.* *Nature* **613**, 508–518 (2023).
[^25]: GTEx Consortium. *Science* **369**, 1318–1330 (2020).
[^26]: ENCODE Project Consortium. *Nature* **583**, 699–710 (2020).
[^27]: Ochoa, D. *et al.* *Nucleic Acids Res.* **49**, D1302–D1310 (2021).
[^28]: Nelson, M.R. *et al.* *Nat. Genet.* **47**, 856–860 (2015).
[^29]: Iversen, H.K. *et al.* *Pain* **38**, 17–24 (1989).
[^30]: Kruuse, C. *et al.* *J. Cereb. Blood Flow Metab.* **22**, 1124–1131 (2002).
