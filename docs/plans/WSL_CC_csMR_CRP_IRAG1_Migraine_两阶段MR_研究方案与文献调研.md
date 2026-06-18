# WSL_CC — CRP→IRAG1→Migraine 两阶段 MR 研究方案与文献调研

**日期**: 2026-06-02 | **执行标准**: 文献检索 4 工具 SOP v3.0
**方法学对标**: Yoshiji et al. 2025 *Nature Genetics* (PMID: 39856218)

---

## 1. 文献调研结果 — 新颖性确证

### 1.1 执行概览

| Phase | 工具 | 执行 | 结果 |
|-------|------|------|------|
| Phase 1: QUERY | `pubmed_lookup_mesh` × 4 + `pubmed_spell_check` × 1 | ✅ 5/5 | MeSH IDs 已获取 |
| Phase 2: SEARCH | `pubmed_search_articles` × 6 axes | ✅ 6/6 | 15 篇候选 |
| Phase 3: FETCH | `pubmed_fetch_articles` × 4 + `pubmed_find_related` × 1 | ✅ 5/5 | 完整元数据 |

### 1.2 关键文献矩阵

| PMID | 作者/年 | 期刊 | 核心发现 | 与本研究关系 |
|------|---------|------|---------|------------|
| **39578729** | Lou 2024 | J Headache Pain (IF~8) | pQTL MR 发现 MRVI1 保护偏头痛, 但优选 PNKP | ⚠️ 竞争对手——需差异化 |
| **39261750** | Xiong 2024 | J Headache Pain | 35 蛋白靶点, FCAR/UBE2L6/MMP3 | MRVI1 不在名单中 |
| **39039470** | Sun 2024 | J Headache Pain | GSTM4 单一靶点 | 方法学参考 |
| **40337101** | Jia 2025 | J Pain Res | CRP 中介肌肉→偏头痛 (观察性) | CRP-偏头痛关联证据 |
| **42056605** | Koller 2026 | **Nat Genet** (IF~31) | 子宫内膜异位 GWAS + 多组学 | 多组学方法学范本 |

### 1.3 新颖性总结

```
✅ CRP → IRAG1:              0 篇 — 完全空白
✅ IRAG1 → Migraine pQTL MR:  1 篇 (Lou 2024, 次要发现) — 未被深入
✅ CRP → IRAG1 → Migraine:    0 篇 — 完整两阶段框架空白
✅ 炎症-血管-偏头痛叙事:      0 篇 — 全新故事线
✅ 用 Yoshiji 级多组学验证:   0 篇 — 方法学优势
```

**结论: 该研究方向完全新颖。CRP→IRAG1 连接从未被提出，IRAG1→Migraine 仅有 1 篇未优先的次要发现。两阶段框架 + Yoshiji 级深度验证 = 顶刊潜力。**

---

## 2. 竞争格局与差异化策略

### 2.1 现有 pQTL×偏头痛 论文

| 论文 | 蛋白 | 方法 | 局限 |
|------|------|------|------|
| Lou 2024 | PNKP(主), MRVI1(次) | MR + SMR + eQTL | 无 coloc, 无 fine-mapping, 无 scRNA-seq |
| Xiong 2024 | 35 蛋白 | MR + PheWAS | 纯 MR 筛选, 无机制验证 |
| Sun 2024 | GSTM4 | MR + SMR + coloc | 单蛋白, 无细胞特异性 |

### 2.2 我们的差异化

| 维度 | Lou 2024 | 本研究 |
|------|---------|--------|
| 框架 | 直接 pQTL→疾病 | **两阶段中介**: CRP→IRAG1→Migraine |
| 主靶点 | PNKP | **IRAG1/MRVI1** |
| 暴露 | 无 | **CRP** (可修改炎症标志物) |
| Coloc | ❌ | ✅ PP.H4>0.8 |
| Fine-mapping | ❌ | ✅ SuSiE 95% CS |
| 表观基因组 | ❌ | ✅ ENCODE + RegulomeDB |
| scRNA-seq | ❌ | ✅ 脑血管 + 血小板 |
| MR-PRESSO | ❌ | ✅ |
| PheWAS | 仅 PNKP | ✅ IRAG1 全表型 |
| 可操作性 | ❌ | ✅ CRP 可药物干预 |

---

## 3. 故事架构

### 3.1 核心叙事

```
炎症 → CRP ↑ → NO↓ → cGMP↓ → PKGI↓ → IRAG1 磷酸化↓
  → IP₃R-Ca²⁺ 释放↑ → 血管平滑肌收缩 + 血小板激活↑
  → 偏头痛风险↑

干预: 抗炎 (他汀/IL-6抑制剂/饮食) → CRP↓ → IRAG1 功能恢复 → 偏头痛↓
```

### 3.2 对标 Yoshiji 2025

```
Yoshiji 2025:                 本研究:
BMI → 4907 proteins           CRP → 1755 proteins
  → COL6A3/endotrophin          → IRAG1/MRVI1
  → CAD                         → Migraine
  + coloc + scRNA + PheWAS     + coloc + scRNA + PheWAS
```

### 3.3 论文标题草案

> "C-reactive protein mediates migraine risk through IRAG1-regulated vascular calcium signaling: a two-step proteome-wide Mendelian randomization study"

### 3.4 目标期刊

- Nature Genetics (对标 Yoshiji 2025)
- Nature Communications
- The Journal of Headache and Pain (已有 Lou 2024 + Xiong 2024)
- Neurology

---

## 4. 两阶段 MR 框架

### 4.1 Step 1: CRP → IRAG1

| 参数 | 值 |
|------|-----|
| 暴露 | CRP (Said S 2022, GCST90029070, N=575,531) |
| 结局 | IRAG1/MRVI1 血浆蛋白 (deCODE, N=35,559) |
| 工具变量 | 272 (IEU clumping, P<5e-8, r²<0.001) |
| 预期结果 | IVW P=0.037, b≈+0.039/nominal |


### 4.2 Step 2: IRAG1 → Migraine (已完成)

| 参数 | 值 |
|------|-----|
| 暴露 | IRAG1 cis-pQTL (rs7940646) |
| 结局 | Migraine (FinnGen R12, N=401,499) |
| 工具变量 | 2 (cis-pQTL) |
| 结果 | **IVW P=5.84e-11, OR=0.57, FDR_q=6.65e-08, Bonf ✅** |


### 4.3 中介分析

```
CRP → IRAG1: β₁ = +0.039 (P=0.037)
IRAG1 → Migraine: β₂ = -0.558 (P=5.84e-11)

Mediation effect: β₁ × β₂ = -0.022
Proportion mediated: TBD (需要 bootstrap CI)
```

---

## 5. 深度追踪计划 (Yoshiji 级)

### 5.1 核心验证

| 分析 | 工具 | 预期产出 |
|------|------|---------|
| Colocalization (coloc) | R coloc + SuSiE | IRAG1 locus PP.H4>0.8 |
| Fine-mapping | SuSiE | 95% credible set |
| SMR + HEIDI | SMR binary | 基因-蛋白-疾病一致性 |
| MR-PRESSO | MR-PRESSO R包 | 多效性异常值检测 |
| Steiger directionality | TwoSampleMR | 因果方向验证 |

### 5.2 生物机制

| 分析 | 数据源 | 产出 |
|------|--------|------|
| V2G mapping | Open Targets Genetics | rs7940646 → IRAG1 |
| Epigenomics | ENCODE + RegulomeDB | rs7940646 调控功能 |
| GTEx expression | GTEx v8 | 脑血管+血小板 IRAG1 表达 |
| scRNA-seq | HCA/PanglaoDB | IRAG1 细胞类型定位 |
| Pathway | KEGG + Reactome | cGMP-PKG-Ca²⁺ 通路图 |

### 5.3 临床转化

| 分析 | 产出 |
|------|------|
| PheWAS | IRAG1 全表型组安全评估 |
| Drug-gene | CRP 通路药物再利用 (他汀/IL-6i) |
| Actionability | CRP 作为生物标志物+治疗靶点 |

---

## 6. CRP GWAS 数据

| 属性 | 值 |
|------|-----|
| GCST | GCST90029070 |
| IEU ID | ebi-a-GCST90029070 |
| 文件 | `D:\01_Projects\GWAS_rawdata\CRP_GCST90029070_Said2022_N575531.h.tsv.gz` |
| N | 575,531 |
| 作者 | Said S 2022 Nat Commun |
| PMID | 35459240 |
| Clumping | IEU 1000G (272 工具变量) |

---

*执行时间: 2026-06-02 | Phase 1-3 完成 | 文献检索 SOP v3.0*
