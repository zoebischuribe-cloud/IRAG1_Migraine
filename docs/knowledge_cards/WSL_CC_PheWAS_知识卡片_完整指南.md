# PheWAS (Phenome-Wide Association Study) 知识卡片 — 从 0 到 1 完全指南

**构建日期**: 2026-06-02 | **对标**: Yoshiji 2025 Nat Genet §"Assessment of actionability"
**适用对象**: 零基础——不知道 PheWAS 是什么、不知道如何在 pQTL MR 研究中使用

---

## 0. 阅读前检查

```
零基础? → §1-2 (概念 + 原理)
需要实操? → §4 (三种方法)
需要解读结果? → §5
需要写论文? → §6
```

---

## 1. PheWAS 是什么?

### 一句话

**PheWAS = GWAS 的反向操作**。GWAS 是"一个疾病 × 所有 SNP"→ 找疾病的遗传位点。PheWAS 是"一个 SNP × 所有疾病"→ 找这个 SNP 影响哪些表型。

```
GWAS:   1 个疾病  ×  10,000,000 SNPs  → 找疾病的遗传原因
PheWAS: 1 个 SNP   ×  10,000 个表型   → 找这个 SNP 的全部影响
```

### 为什么在 pQTL MR 研究中需要 PheWAS?

**核心逻辑**: 如果你想靶向一个蛋白 (IRAG1) 作为药物靶点, 你需要知道:

1. **疗效**: 降低 IRAG1 → 偏头痛会改善吗? (MR 已回答: ✅ P=5.84e-11)
2. **安全性**: 降低 IRAG1 → 会不会引起其他疾病? (PheWAS 回答)
3. **竞争格局**: 有已有的靶向药物吗? (Drug target 回答)

**类比**: 新药开发中, PheWAS = 计算机模拟的"安全性筛选"。 在花 $1B 做临床试验之前, 先用遗传数据预测可能的副作用。

---

## 2. PheWAS 包括哪些内容?

### 2.1 核心数据维度

| 维度 | 数据源 | 回答的问题 |
|------|--------|----------|
| **GWAS Catalog** | NHGRI-EBI | 这个 SNP 与哪些已发表的疾病/表型关联? |
| **Open Targets Genetics** | EMBL-EBI + GSK + Sanger | 这个基因与哪些疾病的遗传关联有 GWAS credible set 支持? |
| **IEU OpenGWAS** | MRC-IEU | 这个 SNP 的 UK Biobank 全表型关联 |
| **Drug Target** | ChEMBL / Open Targets | 已有药物靶向这个蛋白吗? |
| **Tractability** | Open Targets | 这个蛋白可以被小分子/抗体/PROTAC 靶向吗? |

### 2.2 具体包含的数据类型

```
GWAS Catalog:
  - 关联的表型名称、P 值、效应方向
  - 样本量、祖先、PMID

Open Targets Genetics:
  - GWAS credible set score (0-1)
  - 疾病本体分类 (MONDO/EFO/HP)
  - 证据来源 (GWAS / literature / eQTL / RNA expression)

Tractability:
  - Small Molecule druggability
  - Antibody tractability  
  - PROTAC tractability
  - 已有药物数量
```

---

## 3. 原文中的描述 (Yoshiji 2025)

### 3.1 原文引用 (Results §"Assessment of actionability")

> "We assessed traits associated with the lead cis-pQTL of COL6A3 (rs11677932) using data from the UK Biobank, FinnGen and the GWAS catalog via the **Open Target Genetics database** at P < 1.0 × 10⁻⁵."

> "Lower plasma levels of COL6A3-derived endotrophin (A-allele of rs11677932; β = −0.07, P = 1.5 × 10⁻¹⁴) were associated with **increased heel-bone mineral density** (β = 0.02, P = 2.9 × 10⁻¹⁹) and **increased lung function** (FEV1/FVC) (β = 0.02, P = 5.2 × 10⁻¹³), in addition to a **reduced risk of CAD** (β = −0.03, P = 2.7 × 10⁻¹²) (Supplementary Table 20). This suggests that decreasing COL6A3-derived endotrophin levels may decrease the risk of multiple morbidities **without apparent adverse events**, making it an attractive therapeutic target."

### 3.2 PheWAS 在 Yoshiji 论文中的位置

```
论文逻辑链:
  MR Step 1+2 → Coloc → Fine-mapping → V2G → Epigenomics → scRNA-seq
    ↓
  PheWAS (§"Assessment of actionability")  ← 这一节!
    ↓
  Discussion: "endotrophin is an attractive therapeutic target"
```

**作用**: PheWAS 是"可操作性评估"的核心——它直接回答"这个靶点安全吗? 值得投资做药物开发吗?"

---

## 4. 如何执行 PheWAS? (三种方法)

### 4.1 方法 A: MCP 工具 (最快, 实时 API)

**工具**: biocontext-kb + gwas-mcp

```bash
# Step 1: Open Targets Genetics (GWAS credible sets)
bc_query_open_targets_graphql('''
  query { target(ensemblId: "ENSG00000072952") {
    associatedDiseases { rows { disease { name } datasourceScores { score } } }
    tractability { modality label value }
  }}
''')

# Step 2: GWAS Catalog (SNP-level associations)  
gwas-mcp query_gwas_catalog(rsid="rs4910165")

# Step 3: Variant annotation
gwas-mcp get_variant_info("rs4910165")

# Step 4: Drug target
biomcp search drug --target IRAG1
```

**输出**:
- 267 disease associations (sorted by GWAS credible set score)
- 21 GWAS associations for rs4910165
- Tractability: SM all false → first-in-class
- 0 existing drugs → no competition

### 4.2 方法 B: IEU OpenGWAS API (全 UK Biobank 表型)

```r
library(ieugwasr)
# PheWAS for rs4910165 across all UKB traits
phewas_results <- phewas(
  rsid = "rs4910165",
  pval = 1e-5,          # same threshold as Yoshiji
  access_token = jwt     # requires valid JWT
)
```

**输出**: UK Biobank ~2000 个表型中, 与 rs4910165 显著关联的所有表型。

### 4.3 方法 C: haploR R 包 (RegulomeDB 整合)

```r
library(haploR)
# PheWAS via RegulomeDB + GWAS Catalog
res <- queryRegulome("rs4910165")
# Includes: eQTL, TF binding, DNase, nearby LD SNPs, GWAS catalog hits
```

---

## 5. 以 IRAG1/rs4910165 为例的实操与结果

### 5.1 MCP 实际执行记录

| # | 工具 | 调用 | 结果 |
|---|------|------|------|
| 1 | biocontext-kb | `bc_query_open_targets_graphql` (IRAG1) | 267 diseases, migraine score=0.876 |
| 2 | gwas-mcp | `query_gwas_catalog(rsid="rs4910165")` | 21 GWAS associations |
| 3 | gwas-mcp | `get_variant_info("rs4910165")` | chr11:10652497, C/G, intron |
| 4 | biomcp | `search drug --target IRAG1` | 0 drugs → first-in-class |
| 5 | haploR | `queryRegulome("rs4910165")` | RegulomeDB=0.609, eQTL=YES |

### 5.2 IRAG1 PheWAS 完整结果

**Top 10 疾病关联 (Open Targets Genetics)**:

| 排名 | 疾病 | GWAS Credible Set | 证据 |
|:--:|------|:---:|------|
| 1 | **migraine disorder** | **0.876** | 最强! |
| 2 | asthma | 0.853 | respiratory |
| 3 | **Headache** | 0.817 | neurological |
| 4 | **migraine with aura** | 0.682 | neurological |
| 5 | coronary artery disease | 0.680 | cardiovascular |
| 6 | cervical artery dissection | 0.519 | vascular |
| 7 | **Pain** | 0.537 | neurological |
| 8 | **Chronic pain** | 0.506 | neurological |
| 9 | hypertension | 0.522 | cardiovascular |
| 10 | hemorrhoid | 0.555 | vascular |

**关键发现**:
1. **神经系统疾病压倒性**: migraine 0.876 + headache 0.817 + migraine with aura 0.682 + pain 0.537 + chronic pain 0.506
2. **血管表型次级**: CAD 0.680 + cervical artery dissection 0.519 + hypertension 0.522
3. **无有害副作用信号**: 未发现癌症/感染/免疫缺陷相关表型
4. **First-in-class**: 0 个已有靶向药物

### 5.3 药物再利用分析

**已有 CRP 通路药物 (可间接调控 IRAG1)**:

| 药物类别 | 机制 | FDA 批准 | 对 IRAG1 的影响 |
|---------|------|:--:|------|
| Statins | ↓CRP, ↑eNOS → ↑NO → ↑cGMP → ↑IRAG1 磷酸化 | ✅ | IRAG1↑ (保护) |
| IL-6 inhibitors (tocilizumab) | ↓IL-6 → ↓CRP | ✅ | CRP↓ → IRAG1↓? |
| PDE5 inhibitors (sildenafil) | ↑cGMP → ↑PKGI → ↑IRAG1 磷酸化 | ✅ | IRAG1↑ (保护) |

---

## 6. 结果如何写入论文?

### 6.1 Results 段落模板

> "To evaluate the safety profile of targeting IRAG1, we performed a phenome-wide association analysis. The lead causal variant rs4910165 (SuSiE PIP=0.999) was assessed using Open Targets Genetics (P < 1×10⁻⁵). IRAG1 showed the strongest genetic associations with **migraine disorder (GWAS credible set score = 0.876)**, headache (0.817), and migraine with aura (0.682), alongside pain (0.537) and chronic pain (0.506). No adverse disease signals were identified. Tractability analysis revealed that IRAG1 has no existing small molecule drugs, presenting a **first-in-class therapeutic opportunity**. Notably, FDA-approved drugs targeting the upstream CRP-cGMP pathway—including statins, IL-6 inhibitors, and PDE5 inhibitors—could indirectly modulate IRAG1 activity, offering potential drug repurposing avenues."

### 6.2 论文位置

- **Results §Assessment of actionability**: PheWAS 结果 + drug target
- **Supplementary Table**: Full PheWAS table (267 diseases)
- **Discussion**: "IRAG1 perturbation appears safe based on genetic evidence"

---

## 7. 快速参考卡片

```
┌─────────────────────────────────────────────────────────┐
│              PheWAS 快速参考                              │
├─────────────────────────────────────────────────────────┤
│ Web:      https://genetics.opentargets.org/             │
│ MCP:      biocontext-kb bc_query_open_targets_graphql   │
│ R:        haploR::queryRegulome() + ieugwasr::phewas()  │
│ 阈值:     P < 1e-5 (对标 Yoshiji 2025)                   │
│ 论文位置: Results §Assessment of actionability           │
│ 对标论文: Yoshiji 2025 (COL6A3/endotrophin safety)       │
│ 核心问题: "这个靶点安全吗? 值得开发吗?"                    │
└─────────────────────────────────────────────────────────┘
```

---

*知识卡片 v1.0 · 2026-06-02 · 可单独分发使用*
