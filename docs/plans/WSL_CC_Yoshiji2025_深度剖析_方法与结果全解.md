# WSL_CC — Yoshiji 2025 Nat Genet 深度剖析：方法与结果全解

**论文**: Yoshiji et al. 2025, *Nature Genetics* 57(2):345-357
**PMID**: [39856218](https://pubmed.ncbi.nlm.nih.gov/39856218/)
**DOI**: 10.1038/s41588-024-02052-7
**核心贡献**: 两阶段 pQTL MR + coloc + 表观基因组 + scRNA-seq → 发现 COL6A3/endotrophin 是肥胖→CAD 的中介因子

---

## 0. 作者是怎么想的？（逻辑架构）

```
科学问题: 肥胖为什么会增加心血管代谢疾病风险？
            ↓
        中间的分子机制是什么？（中介因子）
            ↓
   肥胖 → ??? → CAD/Stroke/T2D
            ↓
   假设: 循环蛋白可能是中介因子
         （因为肥胖广泛影响血浆蛋白水平）
            ↓
   两步法:
     Step 1: BMI → 哪些蛋白受影响？（筛选候选中介）
     Step 2: 这些蛋白 → 疾病？（验证中介效应）
            ↓
   深度追踪最显著的蛋白 (COL6A3):
     - 多平台复制 (避免假阳性)
     - 观察性验证 (三角验证)
     - Domain-aware MR (是哪个蛋白结构域在起作用?)
     - 体脂区域 MR (哪个脂肪库驱动这个效应?)
     - 表观基因组 (因果 SNP 如何调控蛋白表达?)
     - 单细胞表达 (哪些细胞产生这个蛋白?)
     - PheWAS (靶向这个蛋白安全吗?)
            ↓
   结论: COL6A3 C-terminal/endotrophin 是可操作的药物靶点
```

---

## 1. 引言 (Introduction) — 他们怎么论证的

**论证链**:
1. 全球 19 亿肥胖人口 → 心血管代谢疾病风险 ↑ (大背景)
2. 大部分中介因子未知 → 研究空白
3. 循环蛋白是可修改的候选中介 (因为肥胖广泛影响蛋白, 蛋白可测量可干预)
4. MR 可用于估计因果效应, 避免混杂和反向因果
5. pQTL + MR 已成功优先化治疗靶点 (引用前人工作)
6. 两阶段 MR 可理解风险因素→疾病的生物通路 (引用前人方法学)
7. 本研究: 两阶段 pQTL MR + coloc + 表观基因组 + scRNA-seq

**关键引用**:
- deCODE pQTL: Ferkingstad 2021 (Nature Genet)
- 两阶段 MR: Relton & Davey Smith 2012, Burgess 2015
- 药物靶点 MR: Zheng 2020 (Nature Genet), Schmidt 2020

---

## 2. 结果 §1: Overall Study Design (总体设计 — Fig.1)

**他们做了什么**:
1. 用 BioRender 画了总览图
2. 4 个分析阶段:
   - **MR Step 1**: BMI → 4907 蛋白
   - **MR Step 2**: BMI驱动蛋白 → 4 个疾病结局
   - **Follow-up**: COL6A3 深度分析
   - **Actionability**: 临床可行性评估

**数据源 (Supplementary Table 1)**:
- BMI GWAS: UK Biobank + GIANT, N=681,275
- 蛋白: deCODE, 4907 aptamers (SomaScan v4), N=35,559
- CAD: CARDIoGRAMplusC4D, 181,522 cases / 1,165,690 controls
- Ischemic stroke: GIGASTROKE, 62,100 / 1,234,808
- Cardioembolic stroke: GIGASTROKE, 10,804 / 1,234,808
- T2D: MAGIC, 80,154 / 853,816

**为什么选这些数据源**:
- 全部欧洲人群 (避免人群分层)
- 最大样本量 (最大化统计力)
- deCODE 是目前最大的 pQTL 数据集

---

## 3. 结果 §2: MR Step 1 — BMI → 4907 血浆蛋白

### 3.1 他们怎么做的

```
Input: BMI GWAS (N=681,275) × deCODE pQTL (N=35,559)
Method: Two-sample MR (IVW primary)
Multiple testing: Bonferroni P < 0.05/4907 = 1 × 10⁻⁵
```

**4 个敏感性分析**:
1. **Heterogeneity**: Cochran's Q test → 排除异质性 SNP
2. **Horizontal pleiotropy**: MR-Egger intercept → 排除方向性多效性
3. **Reverse causation**: Steiger directionality test → 确认 BMI→蛋白 方向
4. **Directional concordance**: BMI vs Body Fat % 的效应方向一致性 (r=0.92)

**弱工具变量检测**: F-statistic (Supplementary Table 2) → 无弱工具变量

### 3.2 他们发现了什么

- **1,213 个蛋白受 BMI 影响** (通过所有敏感性分析)
- 94.7% 与体脂百分比方向一致
- 包含已知关联: leptin (瘦素)
- COL6A3 被 BMI 强烈上调 (β=0.32)
- **N-terminal vs C-terminal COL6A3**: C-terminal 的效应更强

### 3.3 为什么这很重要

> 他们发现了 1,213 个 BMI 驱动蛋白。这些蛋白是 Step 2 的"候选中介池"。不是随机选蛋白——必须先在 Step 1 证明暴露真的影响它。

---

## 4. 结果 §3: MR Step 2 — BMI 驱动蛋白 → 疾病

### 4.1 他们怎么做的

```
Input: 1,213 BMI-driven proteins → 4 outcomes
Key innovation: 用 cis-pQTLs 作为工具变量 (不是 trans-pQTLs!)
```

**为什么用 cis-pQTLs**:
- ±1Mb 从 TSS → 更可能通过蛋白水平影响结局
- 独立通路 → 降低水平多效性
- **进一步限制**: 只保留与"仅一个蛋白"关联的 cis-pQTL

**过滤步骤**:
1. cis-pQTLs only (±1Mb TSS)
2. 仅与 1 个蛋白关联 (排除多效性 cis-pQTL)
3. Bonferroni per outcome
4. **Colocalization** (500kb, PP.H4 > 0.8) ← 这是关键!
5. **β_step1 × β_step2 > 0** ← 方向过滤

**为什么每个过滤都必要**:
- 第 1 步: 降低水平多效性
- 第 2 步: 确保 SNP 效应是通过该蛋白而非邻近基因
- 第 3 步: 统计严谨
- 第 4 步: 确保 SNP 是共享因果变异而非 LD 混杂
- 第 5 步: 确保中介方向合理 (BMI↑→蛋白↑→疾病↑)

### 4.2 他们发现了什么

- 仅 **350 个蛋白**有 cis-pQTL (1,213 个中)
- 9 个蛋白-疾病关联通过所有过滤
- **5 个独特中介因子**: COL6A3, PCSK9, F11, C1R, SPATA20
- COL6A3 的 OR 最高 (OR=1.47, P=4.46×10⁻⁷)
- **PCSK9 作为阳性对照** (已知 CAD 药靶)

### 4.3 为什么只关注 cis-pQTL？

> 这个选择是 Yoshiji 能发 Nat Genet 的关键原因之一。如果他用 trans-pQTL，会被质疑"你的工具变量可能通过其他通路影响结局"。cis-pQTL 是最干净的。

---

## 5. 结果 §4-§8: COL6A3 深度追踪 (7 个子分析)

### §4. Replication MR
- Fenland + ARIC + UKB Olink (不同平台!)
- **多平台复制是 PNAS/NG 级别的标准要求**
- 发现: 所有平台一致支持 COL6A3 → CAD

### §5. Observational Validation
- EPIC-Norfolk (n=872): BMI ↑ → C-COL6A3 ↑ (β=0.06, P=8.5×10⁻¹²)
- C-COL6A3 ↑ → CAD ↑ (OR=1.34, P=1.1×10⁻³)
- **三角验证**: MR + 观察性一致 → 证据更强

### §6. UK Biobank Cox Regression
- n=38,361: C-COL6A3 ↑ → CAD 累计发病率 ↑ (HR=1.40, P<2.2×10⁻¹⁶)
- Kaplan-Meier: Q4 (最高 COL6A3) vs Q1 (最低) → 显著差异

### §7. Domain-Aware MR (COL6A3 结构域分析)
- **这是这个论文最精彩的部分!**
- SomaScan 有两个 aptamer: N-terminal 和 C-terminal 分别结合 COL6A3 的不同结构域
- C-terminal aptamer → CAD (OR=1.47, P=4.5×10⁻⁸)
- N-terminal aptamer → CAD (OR=1.00, P=0.98) — **无效!**
- **结论**: 只有 C-terminal (Kunitz 结构域 = endotrophin) 驱动效应!
- **这在 pQTL MR 领域是前所未有的精细度**

### §8. Body Fat Compartment MR
- MRI GWAS (Agrawal 2022): 皮下/内脏/臀腿脂肪
- 皮下脂肪 → C-COL6A3 最强 (β=0.38)
- 说明皮下脂肪是 endotrophin 的主要来源

---

## 6. 结果 §9-§12: 遗传机制 (3 个子分析)

### §9. Fine-Mapping (SuSiE)
- rs11677932: PIP_COL6A3=35.2%, PIP_CAD=29.3%
- **双性状 fine-mapping**: 同一个 SNP 在蛋白和疾病中都是 top causal!

### §10. V2G Mapping
- Open Targets Genetics: rs11677932 → COL6A3 (highest V2G score)
- 支持: pQTL (独立研究), FANTOM5 CAGE enhancer-TSS 互作, 接近 TSS

### §11. Epigenomics
- RegulomeDB score = **1b** (最高的功能证据等级之一)
- ENCODE: rs11677932 在多个组织的开放染色质区 + 活性增强子中
- **破坏 MEF2B 转录因子结合 motif**!
- GTEx: rs11677932 = COL6A3 cis-eQTL in aorta

### §12. Sex-Stratified MR
- 男性: C-COL6A3 → CAD 更显著 (OR=1.63, P=1.26×10⁻⁶)
- 女性: positive trend (OR=1.18, P=0.13)

---

## 7. 结果 §13-§14: 表达 + 可操作性

### §13. scRNA-seq
- 脂肪组织 (SCP1376): COL6A3 在脂肪祖细胞中富集 (P<0.001)
- 冠状动脉 (GSE131780): COL6A3 在成纤维细胞中富集 (P<0.001)
- UMAP 可视化 + permutation test

### §14. Actionability
- **Multivariable MR**: 脂肪质量独立增加 COL6A3, 瘦质量独立降低 PCSK9/F11
- **PheWAS**: rs11677932 ® Open Targets (P<1e-5):
  - A allele → ↓COL6A3 → ↑heel-bone mineral density, ↑FEV1/FVC, **↓CAD risk**
  - **无有害副作用** → endotrophin 作为治疗靶点的安全性
- **结论**: 减重可降低 endotrophin, 降低 CAD 风险

---

## 8. Discussion — 他们怎么包装的

**核心叙事**:
1. 找到 5 个肥胖→心血管代谢疾病的中介蛋白
2. COL6A3/endotrophin 是最有转化潜力的
3. C-terminal 裂解产物 (非全长蛋白) 是效应器
4. 减重可降低 endotrophin → 可操作
5. 限制: 仅欧洲人群, 中介比例估计困难

**他们没做的 (也是我们的机会)**:
- 未对其他 4 个中介做深度追踪
- 未做药物-基因互作分析 (DGI)
- 未做蛋白质结构 druggability

---

## 9. 我们的 IRAG1 对标

| Yoshiji 分析模块 | 我们已完成 | 差距 |
|:----------------|:--:|------|
| MR Step 1 (CRP→IRAG1) | ✅ P=0.037 | 方向不一致 β=+0.039 |
| MR Step 2 (IRAG1→Migraine) | ✅ P=5.84e-11 | 需敏感性分析 |
| Colocalization | ✅ PP.H4=0.993 | — |
| Fine-mapping (SuSiE) | ✅ 3 CS, max PIP=0.999 | — |
| Replication MR | ⬜ | IRAG1 不在 Olink; Lou 2024 已有 |
| Observational validation | ⬜ | 需独立队列 |
| Domain-aware MR | ⬜ | IRAG1 有 9 isoforms! |
| scRNA-seq | ⚠️ | VSMC+血小板 (已知), 需整合 |
| Epigenomics | ⬜ | 需 RegulomeDB+ENCODE |
| PheWAS | ✅ 21 GWAS hits | 需系统整理 |
| Actionability | ✅ 0 target drugs | 需 CRP 通路药物分析 |

**我们的差异化**:
1. **IRAG1 是比 COL6A3 更干净的靶点**: cis-pQTL 直接调控, 无已有药物
2. **完全独立的通路**: cGMP-Ca²⁺ vs CGRP, 偏头痛领域的新方向
3. **9 isoforms 提供 domain-aware MR 的潜力** (比 Yoshiji 的 2 个 aptamer 更丰富!)
4. **CRP 作为可修改暴露**: 抗炎干预 → CRP↓ → IRAG1 功能恢复 → Migraine↓
