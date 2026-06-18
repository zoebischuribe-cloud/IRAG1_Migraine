# WSL_CC — Yoshiji 2025 原文逐节拆解 × 完整执行方案

**参考**: Yoshiji et al. 2025 Nat Genet 57(2):345-357 (PMID:39856218)
**对标项目**: CRP → IRAG1 → Migraine

---

## Yoshiji 2025 完整架构拆解

Yoshiji 论文 = **7 大分析模块**。以下逐模块拆解：原文用了什么 → 我们用什么 → 具体如何执行。

---

## 模块 1: Study Design (总体设计)

**原文做了什么**:
- 两阶段 MR 设计总览图 (Fig. 1, 用 BioRender 绘制)
- 4 个数据分析阶段 (Step1 MR → Step2 MR → Follow-up → Actionability)

**我们需要什么**:

| 原文工具 | 我们的替代 |
|---------|----------|
| BioRender (绘图) | R ggplot2 / Python matplotlib |
| Supplementary Table 1 (数据源) | 已有: deCODE + FinnGen + GWAS Catalog |

**执行方案**:
1. 绘制 Fig.1: R `ggplot2` 或 BioRender 免费版 → 两阶段 MR 设计图
2. 编写 Supplementary Table 1: 数据源表 (CRP GWAS, IRAG1 pQTL, Migraine GWAS)

**需要的 Skill/工具**: R ggplot2, KS `scientific-schematics`

---

## 模块 2: MR Step 1 (暴露 → 蛋白)

**原文做了什么**:
```
BMI GWAS (N=681,275) → deCODE 4907 proteins
  ├─ IVW primary
  ├─ Bonferroni: P < 0.05/4907 = 1e-5
  ├─ Sensitivity: heterogeneity (Cochran's Q), pleiotropy (MR-Egger intercept), 
  │   reverse causation (Steiger), directional concordance (body fat %)
  └─ Result: 1,213 BMI-driven proteins
```

**我们需要什么**: **CRP GWAS (N=575,531) → deCODE 1755 proteins** (仅聚焦 IRAG1)

| 原文步骤 | 我们已完成 | 工具 |
|---------|:--:|------|
| IVW primary | ✅ P=0.037 | TwoSampleMR (IEU clumping) |
| Bonferroni correction | ⬜ | 需扩展到所有 1755 蛋白 |
| Heterogeneity (Cochran's Q) | ⬜ | `mr_heterogeneity()` |
| Pleiotropy (MR-Egger intercept) | ⬜ | `mr_pleiotropy_test()` |
| Reverse causation (Steiger) | ⬜ | `directionality_test()` |
| Directional concordance | ⬜ | 需第二个炎症标志物 GWAS |

**扩展执行方案**: 不做"筛选所有 CRP 驱动蛋白"（因为 CRP 影响的蛋白太多），而是：
1. 确认 CRP→IRAG1 的敏感性分析全部通过
2. 引用文献证明 CRP 广泛影响血浆蛋白组 (已有多篇 CRP proteomics 论文)

**需要的 MCP/Skill/包**: TwoSampleMR R包, pubmed-search (查 CRP proteomics 文献)

---

## 模块 3: MR Step 2 (蛋白 → 疾病)

**原文做了什么**:
```
BMI-driven proteins → CAD/Stroke/T2D
  ├─ Instruments: cis-pQTLs only (±1Mb TSS)
  ├─ Further: only cis-pQTLs associated with ONLY ONE protein
  ├─ Bonferroni per outcome
  ├─ Sensitivity analyses → Colocalization (500kb, PP.H4 > 0.8)
  ├─ β_step1 × β_step2 > 0 direction filter
  └─ Result: 9 protein-disease associations → 5 mediators
```

**我们需要什么**: **IRAG1 cis-pQTL → Migraine**

| 原文步骤 | 我们已完成 | 工具 |
|---------|:--:|------|
| cis-pQTL instruments | ✅ rs7940646, ±1Mb | TwoSampleMR |
| MR Step 2 | ✅ P=5.84e-11, FDR sig | TwoSampleMR |
| Sensitivity analyses | ⬜ heterogeneity, pleiotropy, Steiger | `mr_heterogeneity()`, `mr_pleiotropy_test()`, `directionality_test()` |
| Colocalization | ✅ PP.H4=0.993 | R coloc + susieR |
| β_step1 × β_step2 > 0 | ⬜ CRP→IRAG1: β=+0.039, IRAG1→Migraine: β=-0.558 → **opposite signs!** ⚠️ | 需解释 |

⚠️ **关键问题**: CRP→IRAG1 β=+0.039 (炎症增加IRAG1?), IRAG1→Migraine β=-0.558 (IRAG1保护偏头痛)。两者方向不一致——这与 Yoshiji 的 β_step1×β_step2>0 过滤不符！

**解决方案**: 
1. CRP 升高→IRAG1 升高可能是**补偿性保护反应**（炎症→身体上调保护性蛋白）
2. 可在 Discussion 中讨论这种"不一致中介"(inconsistent mediation)
3. 类似 Lou 2024 发现 MRVI1 蛋白水平保护但基因水平风险

---

## 模块 4: Colocalization + Fine-Mapping (共定位 + 精细定位)

**原文做了什么**:
```
├─ Coloc: coloc.abf, 500kb window, PP.H4 > 0.8
├─ Fine-mapping: SuSiE RSS, 95% credible set, PIP
├─ LocusZoom plots: pQTL signal + CAD GWAS signal
└─ Result: rs11677932 within 95% CS, PIP_COL6A3=35.2%, PIP_CAD=29.3%
```

**我们需要什么**:

| 原文步骤 | 已完成 | 工具 |
|---------|:--:|------|
| coloc.abf | ✅ PP.H4=0.993 | R coloc 6.0.1 |
| SuSiE fine-mapping | ✅ 3 CS, max PIP=0.999 | R susieR |
| LocusZoom plot | ⬜ | R locuscomparer / LocusZoom |
| 双性状 SuSiE (pQTL + GWAS) | ⬜ | 需 `coloc_susie` (QTLMR 包) |
| Coloc 敏感性: 不同先验 | ⬜ | coloc 自带 sensitivity analysis |

**扩展执行方案**:
1. 绘制 LocusCompare 图: pQTL × Migraine GWAS 在 IRAG1 位点
2. 运行 QTLMR `coloc_susie` 做联合 SuSiE coloc
3. 敏感性: p1/p2/p12 不同组合 (1e-4/1e-4/1e-5 vs 1e-4/1e-4/1e-6)

**需要的 MCP/Skill/包**: R coloc, susieR, locuscomparer, QTLMR `coloc_susie`

---

## 模块 5: V2G + Epigenomics (变异→基因映射 + 表观基因组)

**原文做了什么**:
```
├─ V2G: Open Targets Genetics → highest V2G score for COL6A3
├─ Fine-mapping: SuSiE 95% CS
├─ RegulomeDB: score 1b (eQTL + TF binding + TF motif + DNase footprint + DNase peak)
├─ ENCODE: ATAC-seq (red), H3K4me3 (blue), H3K27ac (green) ChIP-seq
│   in adipose tissue, coronary artery, aorta, thoracic artery, tibial artery
├─ TF motif disruption: rs11677932 disrupts MEF2B binding motif (ENCODE accession: ENCSR782UOT)
└─ eQTL: rs11677932 = cis-eQTL for COL6A3 in aorta (GTEx v8)
```

**我们需要什么**:

| 原文步骤 | 可执行？ | 工具 |
|---------|:--:|------|
| V2G score | ⬜ | Open Targets Genetics web: `https://genetics.opentargets.org/variant/11_10652497_C_G` |
| RegulomeDB | ⬜ | `https://regulomedb.org/regulome-search/?regions=chr11:10652497-10652497` |
| ENCODE tracks | ⬜ | ENCODE Portal / UCSC Genome Browser screenshots |
| TF motif | ⬜ | JASPAR / HOCOMOCO 数据库查询 |
| GTEx eQTL | ⬜ | GTEx Portal: `https://gtexportal.org/home/snp/rs4910165` |

**执行方案**:
1. **手动查询** (需浏览器): Open Targets Genetics (V2G score) → RegulomeDB (score) → GTEx Portal (eQTL)
2. **UCSC Genome Browser**: 截图 IRAG1 位点的 ENCODE 表观遗传 tracks
3. **R 脚本**: 从 ENCODE API 获取附近调控元件坐标

**需要的 MCP/Skill/工具**: chrome-devtools MCP (浏览器自动截图), R (ENCODE API), gwas-mcp (变体注释)

---

## 模块 6: scRNA-seq + Tissue Expression

**原文做了什么**:
```
├─ GTEx v8: COL6A3 significantly expressed in adipose tissue & coronary arteries
├─ scRNA-seq adipose (SCP1376): COL6A3 enriched in adipose progenitor cells
├─ scRNA-seq coronary artery (GSE131780): COL6A3 enriched in fibroblasts
├─ UMAP plots + permutation test (P<0.001)
└─ Result: cell-type-specific COL6A3 expression in disease-relevant tissues
```

**我们需要什么**:

| 原文步骤 | 可执行？ | 数据源 |
|---------|:--:|------|
| GTEx tissue expression | ✅ | GTEx Portal API / biomcp `get gene IRAG1` |
| scRNA-seq brain vascular | ⬜ | Human Cell Atlas / PanglaoDB / GEO |
| scRNA-seq platelets | ⬜ | 文献检索 + 引用 |
| UMAP visualization | ⬜ | 需 scRNA-seq 原始数据 → R Seurat |

**执行方案**:
1. GTEx Portal: 查 IRAG1 在 49 个组织中的表达 → 最高表达组织排序
2. PubMed: 找已发表的脑微血管 scRNA-seq 数据集 → 引用其中 IRAG1 的表达
3. 血小板 scRNA-seq: 引用 Prüschenk 2023 + Simurda 2025

**需要的 MCP/Skill/工具**: gwas-mcp, biomcp, pubmed-search, R pheatmap (热图)

---

## 模块 7: PheWAS + Actionability (药物安全性 + 可操作性)

**原文做了什么**:
```
├─ Open Targets Genetics: rs11677932 ±500kb, P<1e-5
├─ Traits: ↑heel-bone mineral density, ↑FEV1/FVC, ↓CAD risk
├─ No apparent adverse events → attractive therapeutic target
├─ Multivariable MR: fat mass vs lean mass
└─ Conclusion: COL6A3-derived endotrophin is actionable
```

**我们需要什么**:

| 原文步骤 | 可执行？ | 工具 |
|---------|:--:|------|
| PheWAS (Open Targets) | ✅ | gwas-mcp `query_gwas_catalog(rsid="rs4910165")` → 21 associations |
| PheWAS (IEU OpenGWAS) | ⬜ | 需 JWT (已有) → `phewas()` from ieugwasr |
| Drug target assessment | ✅ | biomcp `search drug --target IRAG1` → 0 drugs (FIRST-IN-CLASS) |
| Clinical trials | ⬜ | clinicaltrialsgov MCP → migraine + CRP/anti-inflammatory |
| Actionability | ⬜ | pubcrawl → anti-inflammatory drugs for migraine |

**执行方案**:
1. IEU PheWAS: `ieugwasr::phewas(rsid="rs4910165")` → 全表型关联
2. ClinicalTrials.gov: 搜索 CRP/抗炎药物 + 偏头痛临床试验
3. 药物再利用分析: 已有 CRP 通路药物 → 他汀(降CRP), IL-6抑制剂(tocilizumab), CRP apheresis

**需要的 MCP/Skill/工具**: gwas-mcp, clinicaltrialsgov, pubcrawl, biomcp, IEU OpenGWAS API

---

## 完整执行优先级 (P0-P3)

| 优先级 | 模块 | 内容 | 难度 | 产出 |
|:--:|------|------|:--:|------|
| **P0** | Step 2 敏感性 | heterogeneity, pleiotropy, Steiger | ⭐ | Suppl Table |
| **P0** | LocusCompare 图 | coloc 可视化 | ⭐⭐ | Fig |
| **P0** | 完整文献引用 | 所有步骤的 PMID+D1-D4 | ⭐⭐ | Methods |
| **P1** | GTEx 表达 | 组织表达热图 | ⭐⭐ | Fig |
| **P1** | ENCODE+RegulomeDB | 调控注释 (浏览器截图) | ⭐⭐ | Fig |
| **P1** | IEU PheWAS | 全表型关联 | ⭐⭐ | Suppl Table |
| **P2** | scRNA-seq 分析 | 引用已发表数据 | ⭐⭐⭐ | Fig |
| **P2** | 药物再利用 | 他汀/IL-6i 证据 | ⭐⭐ | Discussion |
| **P3** | 多性状 SuSiE | QTLMR coloc_susie | ⭐⭐⭐ | Suppl |

**真正需要跑的计算 (非 MCP)**: 
- Step 2 敏感性分析 (R TwoSampleMR, ~5 min)
- LocusCompare 图 (R, ~10 min)
- GTEx 表达热图 (R pheatmap, ~5 min)
- IEU PheWAS (R ieugwasr, ~10 min)

**需要浏览器手动查询**:
- Open Targets Genetics V2G
- RegulomeDB
- ENCODE/UCSC screenshots
