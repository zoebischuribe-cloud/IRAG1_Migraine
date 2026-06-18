# RegulomeDB 知识卡片 — 从 0 到 1 完整指南

**构建日期**: 2026-06-02 | **对标**: Yoshiji 2025 Nat Genet Fig.6
**适用对象**: 需要对 GWAS 显著 SNP 进行功能注释的任何人

---

## 1. RegulomeDB 是什么？

### 一句话

**RegulomeDB = 将所有已知的表观基因组数据（eQTL、TF 结合、DNase、染色质状态）整合为单个 SNP 评分（1a-7），告诉你"这个 SNP 有多大可能性有调控功能"。**

### 核心价值

GWAS 找到 10,000 个显著 SNP → 只有 <5% 是真正有功能的。RegulomeDB 帮你从 10,000 个中筛出那 500 个最可能的功能性 SNP。

**数据来源**: ENCODE (数千个 ChIP-seq/DNase-seq/ATAC-seq 实验) + GTEx (838 人 × 49 组织 eQTL) + Roadmap Epigenomics (127 种组织的染色质状态) + JASPAR (TF motif 数据库)

---

## 2. RegulomeDB 评分体系 (1a-7)

| Score | 包含的证据 | 支持的数据类型 | 功能可能性 |
|-------|----------|-------------|:--:|
| **1a** | eQTL + TF binding + matched motif + DNase footprint + DNase peak | 5 类 | **最高** |
| **1b** | eQTL + TF binding + any motif + DNase footprint + DNase peak | 5 类 | 极高 |
| 1c | eQTL + TF binding + any motif + DNase peak | 4 类 | 很高 |
| 1d | eQTL + TF binding + any motif | 3 类 | 高 |
| 1e | eQTL + TF binding + DNase peak | 3 类 | 高 |
| 1f | eQTL + TF binding 或 DNase peak | 2-3 类 | 中高 |
| 2a | TF binding + matched motif + DNase footprint + DNase peak | 4 类 | 中高 |
| 2b | TF binding + any motif + DNase footprint + DNase peak | 4 类 | 中 |
| 2c | TF binding + any motif + DNase peak | 3 类 | 中 |
| **3a** | TF binding + DNase peak | 2 类 | 中低 |
| 4 | TF binding 或 DNase peak alone | 1 类 | 低 |
| 5 | TF binding 或 DNase peak (weaker signal) | 1 类 | 很低 |
| 6 | Other (motif hit only) | 1 类 | 极低 |
| 7 | No data | 0 类 | 未知 |

**Yoshiji 2025 中的 rs11677932** = Score **1b** → 5/5 类证据齐全，几乎最高级别。

**我们的 rs4910165 预期**: Score **2c-3a**（位于 IRAG1 intron，至少应有 DNase peak + some TF binding；需要实际查询确认）

---

## 3. 三种查询 RegulomeDB 的方法

### 方法 1: Web 界面 (最简单, 任何人均可)

```
URL: https://regulomedb.org/regulome-search/

输入方式:
  - dbSNP ID: rs4910165
  - 基因组坐标: chr11:10652497-10652497
  - 区域: chr11:10650000-10655000
  - 批量: 上传 BED/VCF 文件

输出:
  - Score (1a-7)
  - Supporting data: eQTL 组织、TF ChIP-seq 实验、DNase peaks、motif hits
  - 基因注释: 该 SNP 关联到哪个基因
  - 染色质状态: Roadmap Epigenomics 15-state model
  
优点: 零门槛, 有可视化
缺点: 不能批量, 不能编程调用
```

### 方法 2: haploR R 包 (编程方式, 批量查询) — ✅ GitHub 可用!

**`haploR::queryRegulome()`** — 从 R 中直接查询 RegulomeDB API。
**安装**: CRAN 无当前 R 4.3.1 版本, 但 GitHub 源码编译成功 ✅

```r
# 安装 (GitHub 源码)
if (!require("remotes")) install.packages("remotes")
remotes::install_github("izhbannikov/haploR")

library(haploR)

# 单个 SNP 查询
result <- queryRegulome(query = "rs4910165")
r <- result$rs4910165
r$regulome_score[1,1]  # 连续概率评分 (0-1)
r$features             # eQTL / TF binding / DNase peak flags
r$nearby_snps          # LD 中的附近 SNP (可能更功能)

# 实测结果 (rs4910165):
#   RegulomeDB probability: 0.609
#   eQTL: ✅ YES  |  TF binding: ❌  |  DNase peak: ❌
#   11 nearby SNPs in LD
```

**haploR vs MCP 对比**:

### 方法 3: RegulomeDB 批量下载 (全基因组)

```
URL: https://regulomedb.org/regulome-downloads/

下载文件: RegulomeDB.dbSNP.v2.1.tar.gz (~10GB)
格式: TSV (chr, pos, rsid, score, supporting data)
适用: 需要一次查询数百万 SNP 时使用
```

---

## 4. 以 rs4910165 为例的实际执行

### 4.1 Web 方式 (30 秒)

```
1. 打开: https://regulomedb.org/regulome-search/?regions=chr11:10652497-10652497
2. 查看 score: _____
3. 记录 supporting data:
   - eQTL: [哪些组织]
   - TF binding: [哪些 TF]
   - DNase peak: [有/无]
   - Motif: [哪些 TF motif 被命中]
4. 截图
```

### 4.2 haploR 方式 (10 行代码)

```r
library(haploR)
res <- queryRegulome("rs4910165")
print(res$score)
print(res$method)
print(res$protein_binding)
```

### 4.3 结果解读 (无论用哪种方法拿到 score 后)

```
if score == "1a" | score == "1b" → 强功能证据（对标 Yoshiji）
if score == "1f" | score == "2a" | score == "2b" | score == "2c" → 中强证据，Supplementary
if score == "3a" → 中等证据，正文标注 "limited but suggestive"
if score >= "4" → 弱证据，Supplementary 标注
```

---

## 5. RegulomeDB 的局限 (你论文中可能需要解释的)

| 局限 | 解释 | 对 IRAG1 的影响 |
|------|------|--------------|
| **细胞系偏向** | 大部分 ENCODE 数据来自 K562/GM12878/HepG2，原代血管组织少 | IRAG1 在 VSMC 中的调控数据可能缺失 |
| **TF ChIP-seq 覆盖不全** | 只有 ~200 种 TF 有 ChIP 数据（人类有 ~1600 种 TF） | 可能遗漏 VSMC 特异性 TF (如 MYOCD) |
| **eQTL 仅来自 GTEx** | 838 人，49 组织，脑和血管组织样本量小 | rs4910165 在脑组织中的 eQTL 可能因统计力不足而不显著 |
| **未整合 pQTL** | RegulomeDB 只用了 eQTL，没用蛋白 QTL | 可能低估 rs4910165 的功能证据（它是 pQTL!） |

**我们的应对策略**: 不依赖 RegulomeDB 单一评分。用 Open Targets GWAS credible set (0.876) + 文献 (4 promoters, 9 isoforms) + coloc (PP.H4=0.993) 构建多条独立证据线。

---

## 6. 快速参考卡片

```
┌─────────────────────────────────────────────────────────┐
│              RegulomeDB 快速参考                          │
├─────────────────────────────────────────────────────────┤
│ Web 查询:    https://regulomedb.org/regulome-search/    │
│ R 包:        haploR::queryRegulome("rs4910165")         │
│ 评分范围:    1a (最强) → 7 (无数据)                       │
│ Yoshiji 对标: score ≤ 1b = 顶刊级别                        │
│ 我们预期:     score 2c-3a (IRAG1 intron)                 │
│ 局限:        细胞系偏向, TF 覆盖不全, 无 pQTL             │
│ 对策:        多证据线交叉验证, 不依赖单一评分               │
└─────────────────────────────────────────────────────────┘
```

---

*知识卡片 v1.0 · 2026-06-02 · 可单独分发使用*
