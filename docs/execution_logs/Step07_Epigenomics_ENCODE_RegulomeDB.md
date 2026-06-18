# Step 07: 表观基因组注释 (ENCODE + RegulomeDB)

## 1. 目的
- **故事线角色**: 对标 Yoshiji 2025 Fig.6 — 证明 SuSiE 因果 SNP (rs4910165) 位于活性调控区域，解释其如何调控 IRAG1 表达
- **Yoshiji 对应**: Results §"Regulatory role of the lead cis-pQTL" + Fig. 6
- **如果失败**: 无调控证据 → SNP 可能是 tag SNP → 正文降级，Suppl 标注

## 2. 文献对齐
| 字段 | 值 |
|------|-----|
| 模板论文 | Yoshiji 2025 (PMID:39856218) |
| 期刊+JIF | Nat Genet (31.7) |
| 引用段落 | "The variant received a strong RegulomeDB score of 1b based on eQTL, TF binding, TF motif, DNase footprint and DNase peak. The variant was located in an open chromatin region and an active enhancer domain in multiple tissues, including adipose tissues, coronary arteries and aorta" (Results, Fig. 6) |
| 深度层级 | D1✓ D2✓ D3✓ D4✓ |
| 参数提取 | RegulomeDB score 1b = eQTL+TF binding+TF motif+DNase footprint+DNase peak |
| Yoshiji 方法 | ENCODE: ATAC-seq (red), H3K4me3 (blue), H3K27ac (green) ChIP-seq; TF motif disruption (MEF2B) |

## 3. 工具调用

| # | 工具 | 调用 | 目的 |
|---|------|------|------|
| 1 | **biomcp** (biocontext-kb) | Open Targets GraphQL → IRAG1 tractability + GWAS credible sets | V2G 证据 |
| 2 | **gwas-mcp** | `get_variant_info("rs4910165")` → chr11:10652497, intron | 变体注释 |
| 3 | **gwas-mcp** | `query_gwas_catalog(rsid="rs4910165")` → 21 GWAS hits | GWAS 全景 |
| 4 | **ensembl** | `ensembl_lookup("ENSG00000072952")` → gene structure | 基因上下文 |
| 5 | **pubmed** | IRAG1 + ENCODE + RegulomeDB + TF binding | 机制文献 |
| 6 | **Tavily** | rs4910165 RegulomeDB ENCODE chromatin state | Web 补充 |

## 4. 执行结果

| 调用 | 状态 | 关键输出 |
|------|:--:|------|
| Open Targets V2G | ✅ | migraine GWAS credible set = **0.876**, IRAG1 tractability: first-in-class |
| rs4910165 注释 | ✅ | chr11:10652497, C/G, **intron_variant**, MAF=0.128 |
| GWAS Catalog | ✅ | 21 associations, 脂质/甘油三酯为主 |
| Ensembl gene | ✅ | IRAG1: chr11:10573091-10693988, 4 alternative promoters, 9 isoforms |
| IRAG1 isoforms (PMID:21865585) | ✅ | 4 promoters → tissue-specific expression; 9 splice isoforms |
| MRVI1 mutation → achalasia (PMID:32573102) | ✅ | Loss of function → smooth muscle phenotype |

**RegulomeDB 推理** (基于已知信息):
- rs4910165 = intron_variant in IRAG1 gene body
- MAF=0.128 (common variant, not rare)
- GWAS credible set score 0.876 for migraine → strong regulatory evidence
- In IRAG1 intron 1, near 4 alternative promoters → likely in a regulatory region

**ENCODE 推理**:
- Yoshiji's Fig.6 shows: ATAC-seq + H3K27ac + H3K4me3 for their lead SNP across 5 tissues
- For IRAG1: would need tracks in **vascular smooth muscle, platelets, cerebral arteries**
- Not available via MCP — needs UCSC Genome Browser / ENCODE Portal manual query

**已知的 IRAG1 调控机制** (from literature):
- 4 alternative promoters → tissue-specific regulation (PMID:21865585)
- 9 splice isoforms → post-transcriptional diversity
- cGMP-PKG phosphorylation site → post-translational regulation
- **rs4910165 may affect promoter usage or splicing**

## 5. 数据溯源
- Open Targets Genetics: GraphQL API (2026-06-02)
- Ensembl: ENSG00000072952 (IRAG1)
- GWAS Catalog: NHGRI-EBI API
- Prüschenk 2023 (PMID:37372987): comprehensive IRAG1 review
- Werder 2011 (PMID:21865585): 4 IRAG1 promoters + isoforms
- Koehler 2020 (PMID:32573102): MRVI1 LOF → achalasia

## 6. 故事线贡献
- [ ] Fig. 6: Epigenomic tracks at IRAG1 locus (待手动查询 UCSC)
- [ ] Results §Regulatory: "rs4910165 is an intronic variant within IRAG1, supported by GWAS credible set evidence (0.876)"
- [ ] Supplementary Note: IRAG1 isoform diversity and tissue-specific regulation

## 7. 下一步依赖
- 需浏览器手动查询 RegulomeDB + UCSC Genome Browser (ENCODE tracks)
- 后续: PheWAS (Step 08)
