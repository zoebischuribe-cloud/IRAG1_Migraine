# JASPAR + TF Motif + motifbreakR 知识卡片 — 从 0 到 1 完全指南

**构建日期**: 2026-06-02 | **对标**: Yoshiji 2025 Nat Genet Fig.6c (MEF2B motif disruption)
**适用对象**: 零基础——不知道什么是 TF motif、什么是 PWM、不知道如何预测 SNP 对 TF 结合的影响

---

## 0. 阅读前检查

```
你是一个从零开始的人吗? → 读 §1-2 (概念 + 原理)
你已经知道概念, 需要实操? → 直接跳到 §4 (实操)
你已经跑了分析, 需要解读结果? → 跳到 §5 (结果解读)
你需要把这部分内容写进论文? → 跳到 §6 (论文位置)
```

---

## 1. 这些概念是什么?

### 1.1 TF (Transcription Factor, 转录因子)

**一句话**: TF = 能"读懂" DNA 上特定序列的蛋白质, 读完后决定基因开还是关。

**类比**: 基因组是 30 亿字的巨著。TF 是"编辑"——它能找到书中的特定关键字（如"ATGCTA"），然后决定这一页要不要被翻译成蛋白质。

**为什么重要**: 如果 SNP 改变了"关键字"的拼写（C→G），TF 就读不懂了→基因开关失常→疾病风险改变。

### 1.2 TF Motif (TF 结合基序)

**一句话**: TF motif = TF 喜欢结合的 DNA 序列的"模糊肖像"。

**不是精确序列, 而是概率模型**:

```
TF "MEF2B" 喜欢的序列模式:
位置1: A(90%) G(10%)
位置2: T(85%) C(15%)
位置3: G(70%) A(30%)
...
位置10: C(95%) T(5%)

→ 这个概率分布 = motif = PWM (Position Weight Matrix)
```

**类比**: 不是"密码必须是 1234"（精确匹配），而是"密码大概是 1XX4"（概率匹配）。序列越接近 TF 的偏好，结合越强。

### 1.3 JASPAR 数据库

**一句话**: JASPAR = **TF motif 的"图书馆"**——收录了 1000+ 个 TF 的 motif，免费公开。

**网址**: https://jaspar.elixir.no/

**收录了什么**:
- 每个 TF 的 motif logo（可视化：字母越高 = 该碱基越被偏好）
- PWM 矩阵（定量：每个位置的 A/C/G/T 概率）
- TF 分类（bZIP, bHLH, MEF2, GATA 等家族）
- 物种信息（脊椎动物/植物/昆虫）

**类比**: JASPAR = TF 的"指纹数据库"。就像警察比对指纹可以识别罪犯，motifbreakR 比对 JASPAR 可以识别"哪个 TF 被 SNP 破坏了"。

### 1.4 motifbreakR R 包

**一句话**: motifbreakR = **自动计算"SNP 的 C→G 变化破坏了哪个 TF 的结合"**。

**工作原理**:
```
输入: SNP rs4910165, C→G, ±10bp 侧翼序列
  ↓
1. 从 JASPAR 下载所有 1000+ TF motif
2. 用 C 等位基因算每个 TF 的结合分数
3. 用 G 等位基因算每个 TF 的结合分数
4. 计算: Δscore = score(G) - score(C)
  ↓
输出: 
  - 哪些 TF 的 motif 被显著破坏 (Δscore < -0.4)
  - P 值 (P < 4e-4 为显著)
  - 可视化: motif logo + SNP 位置标注
```

**类比**: 自动搜索引擎——输入一个 SNP → 搜索 1000+ TF → 告诉你哪些 TF 被这个变异影响。

---

## 2. 为什么在 GWAS-MR 研究中需要做 TF motif 分析?

### 2.1 它在 Yoshiji 2025 中的位置

Yoshiji 2025 的论文逻辑链:
```
rs11677932 是 COL6A3 的 lead cis-pQTL
  → coloc 证实共享因果变异
  → RegulomeDB 评分 1b（高功能证据）
  → ENCODE 显示该位点在多个组织中是活性增强子
  → motifbreakR 显示 rs11677932 破坏了 MEF2B TF 结合 motif ← 这一节!
  → 结论: 该 SNP 通过破坏 MEF2B 结合 → 降低 COL6A3 表达 → 增加 CAD 风险
```

**motif analysis 是逻辑链的"最后一环"** — 它把"这个 SNP 有功能"推进到"这个 SNP 通过 TF X 影响基因 Y"。

### 2.2 在论文中的作用

| 论文部分 | TF motif 分析的位置 |
|---------|------------------|
| **Results** | Fig. 6c (motif logo + SNP 位置) |
| **Results** | "rs4910165 disrupted the binding motif of TF X (Δscore=-X.XX, P=Y.Ye-Z)" |
| **Discussion** | "TF X is a known regulator of vascular smooth muscle gene expression, providing a mechanistic link between rs4910165 and IRAG1 expression" |

---

## 3. 原理详解

### 3.1 PWM 是如何计算结合分数的?

```
给定 motif "MEF2B" (长度为 10bp):
位置: 1   2   3   4   5   6   7   8   9   10
A:   0.9 0.1 0.05 0.8 0.1 0.05 0.9 0.1 0.2 0.1
C:   0.05 0.1 0.0 0.1 0.8 0.1 0.05 0.0 0.1 0.05
G:   0.05 0.8 0.0 0.05 0.05 0.8 0.0 0.1 0.6 0.8
T:   0.0 0.0 0.95 0.05 0.05 0.05 0.05 0.8 0.1 0.05

查询序列 (C 等位基因): C T A T G C A T C G
  得分: 0.05×0.0×0.05×0.05×0.05×0.1×0.9×0.8×0.2×0.8 = 很小

查询序列 (G 等位基因): C T A T G C A T G G  (位置9: C→G)
  得分: 0.05×0.0×0.05×0.05×0.05×0.1×0.9×0.8×0.6×0.8 = 更大

→ G 等位基因比 C 更强地结合 MEF2B
→ 如果 G 是保护性等位基因 → 更强的 MEF2B 结合 → 更高的 IRAG1 表达 → Migraine↓
```

### 3.2 motifbreakR 的显著性判断

```
Δscore = score(替代等位基因) - score(参考等位基因)
P 值 = 基于背景分布 (随机序列的 score 分布)

显著标准:
  |Δscore| > 0.4  → 结合分数有实质性变化
  P < 4e-4       → 统计学显著（默认阈值）

输出优先级:
  ✅ Strong effect: |Δscore| > 0.7 + P < 1e-5
  ✅ Moderate:      |Δscore| > 0.4 + P < 4e-4
  ⚠️ Weak:          |Δscore| > 0.2 + P < 0.01
  ❌ No effect:     不满足上述任何条件
```

---

## 4. 实操：以 rs4910165 (C→G, IRAG1) 为例

### 4.1 无需安装的方式: JASPAR Web

```
1. 打开 https://jaspar.elixir.no/
2. 搜索 "MEF2B" (或 SRF, GATA4, GATA6, ELK1...)
3. 点击 TF → 查看 motif logo (可视化 PWM)
4. 手动比对: rs4910165 ±5bp 的序列 vs motif 的偏好序列
5. 判断: C→G 在 motif 的第几个位置? 该位置偏好 G 还是 C?
```

**局限**: 手动, 无法一次扫描所有 TF。

### 4.2 R 包 motifbreakR 方式 (自动化, 推荐)

```r
# 安装 (首次)
if (!require("BiocManager")) install.packages("BiocManager")
BiocManager::install("motifbreakR")
BiocManager::install("SNPlocs.Hsapiens.dbSNP155.GRCh38")

library(motifbreakR)

# Step 1: 定义 SNP
snps <- "rs4910165"  # IRAG1 intron, C→G

# Step 2: 从 dbSNP 获取侧翼序列 (±10bp)
snps.gr <- snps.from.rsid(
  rsid = snps,
  dbSNP = SNPlocs.Hsapiens.dbSNP155.GRCh38,
  search.genome = BSgenome.Hsapiens.UCSC.hg38
)

# Step 3: 扫描 JASPAR 2024 所有 TF motif
results <- motifbreakR(
  snpList = snps.gr,
  filterp = TRUE,
  pwmList = getMatrixSet(JASPAR2024, list(tax_group="vertebrates")),
  threshold = 4e-4,    # 显著性阈值
  method = "ic",        # information content 方法
  BPPARAM = BiocParallel::SerialParam()
)

# Step 4: 查看最显著的 TF motif 破坏
head(results)

# Step 5: 导出为表格
write.csv(as.data.frame(results), "rs4910165_motifbreakR_results.csv")

# Step 6: 绘制 motif logo
pdf("rs4910165_motif_logo.pdf", width=10, height=6)
plotMB(results, ncol=3)
dev.off()
```

### 4.3 输出解读

```
预期输出 (示例):

TF_name    Δscore    P_value      alleleDiff     effect
MEF2B      -0.62     1.2e-6       C→G           STRONG  ← 同 Yoshiji!
SRF        -0.45     8.5e-5       C→G           MODERATE
GATA4      +0.38     3.2e-4       C→G           WEAK
ELK1       -0.12     0.03         C→G           NO EFFECT

解读:
  MEF2B: G等位基因使MEF2B结合显著减弱(Δ=-0.62) → 可能降低IRAG1表达 → Migraine↑
  SRF:   G等位基因使SRF结合显著减弱(Δ=-0.45) → VSMC主调控因子受影响
  GATA4: G等位基因使GATA4结合增强(Δ=+0.38) → 心血管发育TF
  ELK1:  无显著变化
```

---

## 5. 结果如何写入论文?

### 5.1 Results 段落模板

> "We next assessed whether rs4910165, the lead causal variant in the SuSiE fine-mapping (PIP=0.999), could affect transcription factor binding. Using motifbreakR to scan the JASPAR 2024 database of vertebrate TF binding motifs, we identified that the C→G substitution at rs4910165 significantly disrupted the binding motif of **[TF_NAME]** (Δscore = [X.XX], P = [Y.Ye-Z]). Notably, **[TF_NAME]** is a known regulator of **[RELEVANT_PATHWAY]** in **[RELEVANT_TISSUE]** (ref), providing a mechanistic link between the causal variant and IRAG1 expression."

### 5.2 Figure 6c 组件

```
Fig. 6c 包含:
  - 上: motif logo (JASPAR 生成的视觉化 PWM)
  - 中: rs4910165 位置标注 (箭头指向变异位置)
  - 下: 参考 vs 替代等位基因的结合分数条
```

### 5.3 Supplementary Table

| SNP | TF | Motif ID | Δscore | P | Reference score | Alternate score |
|-----|-----|---------|--------|-----|----------------|----------------|
| rs4910165 | MEF2B | MA0664.2 | -0.62 | 1.2e-6 | 8.3 | 7.7 |

---

## 6. 常见失败与处理

| 场景 | 可能原因 | 处理 |
|------|---------|------|
| motifbreakR 安装失败 | Bioconductor 版本不匹配 | `BiocManager::install(version="3.18")` 然后重试 |
| 无显著 TF motif 被破坏 | (a) SNP 确实无 TF 功能 (b) JASPAR 缺少该 TF | 报告"no significant motif disruption found" — 这也是有效结果 |
| 返回大量显著结果 (>50) | SNP 在低复杂度区域 (如 poly-A) | 过滤: 只保留 |Δscore| > 0.7 + 相关组织中表达的 TF |
| 结果与文献不一致 | 不同工具/数据库版本 | 标注所用版本号, 讨论中解释 |

---

## 7. 快速参考卡片

```
┌─────────────────────────────────────────────────────────┐
│          JASPAR / TF Motif / motifbreakR 快速参考        │
├─────────────────────────────────────────────────────────┤
│ JASPAR:       https://jaspar.elixir.no/                 │
│ motifbreakR:  BiocManager::install("motifbreakR")       │
│ 输入:         rsID + 等位基因 (C→G) + genome build       │
│ 输出:         TF名 + Δscore + P值 + motif logo          │
│ 显著阈值:     |Δscore|>0.4 + P<4e-4                    │
│ 论文位置:     Results §Regulatory role, Fig. 6c         │
│ 对标论文:     Yoshiji 2025 (MEF2B motif disruption)     │
│ 局限:         仅in silico预测, 需实验验证                │
│ 对策:         多证据线交叉验证 (eQTL + TF ChIP + motif)  │
└─────────────────────────────────────────────────────────┘
```

---

*知识卡片 v1.0 · 2026-06-02 · 可单独分发使用*
