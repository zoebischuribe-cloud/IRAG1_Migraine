# WSL_CC — 表观基因组注释 从 0 到 1 完整实操手册

**版本**: v2.0 | **日期**: 2026-06-02
**v2.0 新增**: §7 湿实验 vs 计算分析 完整辨析
**目的**: 任何小白 AI 或人类, 拿到一个 GWAS 显著 SNP (如 rs4910165), 能按照本文档独立完成表观基因组注释, 拿到正确结果
**对标**: Yoshiji 2025 Nat Genet Fig.6 — RegulomeDB + ENCODE + TF motif 分析

---

## 0. 背景: 为什么 GWAS SNP 需要表观基因组注释?

GWAS 找到的显著 SNP 绝大多数位于**非编码区** (内含子/基因间区)。虽然统计上显著, 但:
- 它可能只是 **tag SNP** (与真正的因果 SNP 处于 LD 中)
- 它可能调控**附近的基因**而非最近的基因
- 它可能影响**特定组织**中的基因表达 (e.g., 血管但不影响肝脏)

表观基因组注释用**功能基因组学数据**来判断: 这个 SNP 是"真正起作用的"还是"只是路过的"。

---

## 1. 5 个概念的定义、功能与作用

### 1.1 eQTL (expression Quantitative Trait Locus)

**定义**: 一个遗传变异 (SNP) 与某个基因的 mRNA 表达水平显著关联。

**功能**: 证明"这个 SNP → 这个基因的表达量"。是 V2G 的**最直接证据**。

**数据来源**: GTEx (Genotype-Tissue Expression) — 测量了 838 人的 49 个组织的基因表达 + 基因型。

**在 Yoshiji 2025 中的用法**:
> "rs11677932 was the **cis-eQTL of COL6A3 in the aorta** in GTEx v.8, with directionally concordant effects"

**我们的 IRAG1 案例**:
- rs4910165 位于 IRAG1 基因内部 (intron 1)
- 如果 rs4910165 的 C 等位基因 → IRAG1 mRNA 表达降低 → 血管平滑肌保护 → Migraine↓
- 需要在 GTEx 中验证: rs4910165 是否在**血管/血小板相关组织**中是 IRAG1 的 eQTL

### 1.2 TF Binding (Transcription Factor Binding)

**定义**: 转录因子蛋白在基因组 DNA 上的物理结合位置, 由 ChIP-seq 实验测定。

**功能**: 标记**基因组中哪些位置是调控热点**。如果 SNP 落在 TF 结合峰内 → 该 SNP 可能改变 TF 结合 → 影响基因表达。

**数据来源**: ENCODE (Encyclopedia of DNA Elements) — 数百种 TF 在多种细胞类型中的 ChIP-seq 数据。

**Yoshiji 2025 用法**: rs11677932 在**多个组织**的开放染色质区有 TF 结合信号 → 证明该位点在多种组织中都有调控活性。

### 1.3 TF Motif (Transcription Factor Binding Motif)

**定义**: TF 蛋白识别并结合的**特定 DNA 序列模式** (通常 6-20bp)。用 position weight matrix (PWM) 表示。

**功能**: 预测"这个 SNP 是否破坏了某个 TF 的结合序列"。如果参考等位基因 = TAGCTA (能结合 TF X), 替代等位基因 = TAGTTA (不能结合), → 该 SNP 影响 TF X 的调控。

**数据来源**: JASPAR, HOCOMOCO, TRANSFAC (TF motif 数据库)。

**Yoshiji 2025 用法**:
> "rs11677932 **disrupted the conserved nucleotide in the MEF2B TF binding motif**... consistent with reduced effects on COL6A3 expression"

### 1.4 DNase Footprint

**定义**: DNase I 消化实验中**被蛋白质保护而未被切割**的 DNA 小片段 (通常 6-40bp)。

**功能**: 这是**TF 结合的最高分辨率证据** — DNase footprint 精确定位了 TF 在 DNA 上的**实际物理接触位点**, 比 ChIP-seq 峰 (~200bp) 精确 10-100 倍。

**数据来源**: ENCODE DNase-seq 实验。

**Yoshiji 2025 用法**: rs11677932 有 "DNase footprint" 证据 → 该位点不仅有 TF 结合峰, 而且有**精确的核苷酸级保护** → 功能证据非常强。

### 1.5 DNase Peak (DNase Hypersensitivity Peak)

**定义**: DNase I 酶切的**宽峰区域** (通常 150-500bp)。是开放染色质 (非核小体占据) 的标志。

**功能**: 标记**基因组中所有潜在的调控区域**。DNase peak = "这段 DNA 是可访问的" (不同于被核小体紧紧包裹的非调控区)。

**数据来源**: ENCODE DNase-seq (同 DNase footprint)。

**Yoshiji 2025 用法**: rs11677932 位于 DNase peak 中 → 该区域在多种组织中都是**开放染色质**。

---

## 2. RegulomeDB — 一站式整合评分

**定义**: RegulomeDB 是一个**整合了所有上述 5 类数据**的数据库, 给每个 SNP 打一个综合评分。

**评分体系** (从最强到最弱):

| Score | 包含的证据 | 功能可能性 |
|-------|----------|:--:|
| **1a** | eQTL + TF binding + matched TF motif + DNase footprint + DNase peak | **最高** |
| **1b** | eQTL + TF binding + any TF motif + DNase footprint + DNase peak | 极高 |
| 1c | eQTL + TF binding + any TF motif + DNase peak | 很高 |
| 1d | eQTL + TF binding + any TF motif | 高 |
| 1e | eQTL + TF binding + DNase peak | 高 |
| 1f | eQTL + TF binding / DNase peak | 中高 |
| 2a | TF binding + matched TF motif + DNase footprint + DNase peak | 中高 |
| 2b | TF binding + any TF motif + DNase footprint + DNase peak | 中 |
| 2c | TF binding + any TF motif + DNase peak | 中 |
| 3a | TF binding + DNase peak | 中低 |
| 4 | TF binding or DNase peak alone | 低 |
| 5 | TF binding or DNase peak (weaker) | 很低 |
| 6 | Other | 极低 |
| 7 | No data | 无 |

**Yoshiji 的 rs11677932 得分 = 1b** → 几乎最高级别, 有 5 类功能证据。

**我们的 rs4910165 预期**: 
- In intron of IRAG1 → likely DNase peak + TF binding
- MAF=0.128, common variant → likely in RegulomeDB
- 预计 score: 2a-2c 范围

---

## 3. 不用 MCP 怎么获取这些信息? (手动方法)

### 3.1 RegulomeDB

```
Step 1: 打开浏览器 → https://regulomedb.org/regulome-search/
Step 2: 输入 "rs4910165" 或 "chr11:10652497-10652497"
Step 3: 查看:
  - RegulomeDB score (1a-7)
  - Supporting data: 哪些组织有 eQTL/TF binding/DNase
  - 基因注释: 该 SNP 关联到哪个基因
Step 4: 截图保存
```

**实际 URL**:
`https://regulomedb.org/regulome-search/?regions=chr11:10652497-10652497`

### 3.2 GTEx eQTL

```
Step 1: 打开浏览器 → https://gtexportal.org/home/snp/rs4910165
Step 2: 查看 Violin Plot — 不同基因型 (C/C, C/G, G/G) 下 IRAG1 的表达差异
Step 3: 查看 Tissue-by-Tissue table — 哪些组织中 rs4910165 是 IRAG1 的显著 eQTL
Step 4: 记录: NES (Normalized Effect Size), P-value, tissue
```

**实际 URL**:
`https://gtexportal.org/home/snp/rs4910165`

### 3.3 UCSC Genome Browser (ENCODE tracks)

```
Step 1: 打开浏览器 → https://genome.ucsc.edu/
Step 2: 菜单 → Genome Browser → 输入 region: "chr11:10,550,000-10,710,000"
Step 3: 右键 → Configure → 搜索并添加以下 tracks:
  - DNase Clusters (DNase hypersensitivity)
  - Transcription Factor ChIP-seq (选择 relevant TFs)
  - H3K27ac (active enhancer mark)
  - H3K4me3 (active promoter mark)
  - ATAC-seq (open chromatin)
Step 4: 缩小到感兴趣的 SNP 区域 → 截图
```

**实际 URL**:
`https://genome.ucsc.edu/cgi-bin/hgTracks?db=hg38&position=chr11:10550000-10710000`

### 3.4 JASPAR TF Motif

```
Step 1: 打开浏览器 → https://jaspar.elixir.no/
Step 2: 搜索可能受影响的 TF (如 MEF2, SRF, GATA — 血管/血小板相关 TF)
Step 3: 查看 motif logo + PWM
Step 4: 用 rs4910165 的参考/替代等位基因 比对 motif → 预测是否破坏
```

---

## 4. 用 MCP 怎么获取这些信息? (自动化方法)

### 4.1 可通过 MCP 获取的

| 数据类型 | MCP 工具 | 功能 | 局限 |
|---------|---------|------|------|
| **SNP 基本信息** | gwas-mcp `get_variant_info("rs4910165")` | chr/pos/MAF/consequence | 无 RegulomeDB score |
| **GWAS Catalog** | gwas-mcp `query_gwas_catalog(rsid="rs4910165")` | 该 SNP 的所有 GWAS 关联 | 无表观注释 |
| **V2G score** | biocontext-kb `bc_query_open_targets_graphql` | GWAS credible set + tractability | 间接 V2G 证据 |
| **基因注释** | ensembl `ensembl_lookup("ENSG00000072952")` | 基因结构/外显子/转录本 | 无调控注释 |
| **调控元件** | ensembl `ensembl_regulatory(region="11:...")` | 理论上有但 API 格式问题 | ⚠️ 当前不可用 |
| **文献** | pubmed-search | IRAG1 调控机制文献 | 需人工提取 |

### 4.2 不能通过 MCP 获取的 (必须手动/浏览器)

| 数据类型 | 原因 |
|---------|------|
| **RegulomeDB score** | 无公开 API, 仅 web 界面 |
| **GTEx eQTL** | 无 MCP 接口, 需 GTEx Portal |
| **ENCODE/UCSC tracks** | 数据量太大, 需交互式浏览器 |
| **TF motif 数据库 (JASPAR)** | 需交互式查询 |

### 4.3 MCP 实际执行结果 (rs4910165)

```
工具: gwas-mcp get_variant_info("rs4910165")
结果: chr11:10652497, C/G, intron_variant, MAF=0.128, clinical_significance: []

工具: biocontext-kb bc_query_open_targets_graphql
结果: GWAS credible set (migraine) = 0.876
      Tractability: SM all false (first-in-class)
      267 disease associations

工具: gwas-mcp query_gwas_catalog(rsid="rs4910165")  
结果: 21 GWAS associations, top P=1e-53 (triglycerides)

工具: ensembl ensembl_lookup("ENSG00000072952")
结果: IRAG1, chr11:10573091-10693988, protein_coding

工具: pubmed pubmed_fetch_articles(["21865585","37372987","32573102"])
结果: 4 promoters + 9 isoforms; VSMC+platelet expression; LOF→achalasia
```

---

## 5. 从 0 到 1 实操: 以 rs4910165 (IRAG1) 为例

### Step 1: 确认 SNP 基础信息

```bash
# MCP 方式
gwas-mcp get_variant_info("rs4910165")
→ chr11:10652497, C/G, intron_variant, MAF=0.128
→ IRAG1 基因内部! ✅
```

### Step 2: 查 RegulomeDB score

**手动方式**:
1. 打开 `https://regulomedb.org/regulome-search/?regions=chr11:10652497-10652497`
2. 记录 score (预期 1f-3a 范围)
3. 记录 supporting data 类型
4. 截图

### Step 3: 查 GTEx eQTL

**手动方式**:
1. 打开 `https://gtexportal.org/home/snp/rs4910165`
2. 查找 IRAG1 (MRVI1) 在哪些组织中是显著 eQTL
3. 特别关注: Artery (动脉), Heart (心脏), Brain (脑), Whole Blood (全血)
4. 截图 Violin Plot

### Step 4: 查 UCSC ENCODE tracks

**手动方式**:
1. 打开 `https://genome.ucsc.edu/cgi-bin/hgTracks?db=hg38&position=chr11:10550000-10710000`
2. 添加 tracks: DNase Clusters, H3K27ac, H3K4me3, ATAC-seq, TF ChIP-seq
3. 缩小到 rs4910165 位置 (chr11:10652497)
4. 截图

### Step 5: 文献整合

已有文献证据:
- **4 alternative promoters** (PMID:21865585): rs4910165 in intron 1 → may affect promoter choice
- **VSMC + platelet expression** (PMID:37372987): disease-relevant tissues
- **LOF → achalasia** (PMID:32573102): functional validation of IRAG1 importance

### Step 6: 整合输出

| 证据类型 | rs4910165 | 来源 |
|---------|----------|------|
| V2G: GWAS credible set | 0.876 (migraine) | Open Targets GraphQL |
| V2G: Physical location | IRAG1 intron 1 | gwas-mcp |
| RegulomeDB | **待手动查询** | regulomedb.org |
| GTEx eQTL | **待手动查询** | gtexportal.org |
| ENCODE open chromatin | **待手动查询** | UCSC Genome Browser |
| Alternative promoters | 4 promoters (tissue-specific) | PMID:21865585 |
| Tissue expression | VSMC, platelets, heart | PMID:37372987 |
| Functional validation | LOF → smooth muscle disease | PMID:32573102 |

---

## 6. 常见 FAQ

**Q: 为什么 RegulomeDB 没有 API?**
A: RegulomeDB 是斯坦福大学维护的学术数据库, 提供了批量下载 (`https://regulomedb.org/regulome-downloads/`) 但不提供实时 API。我们的 rs4910165 数据可以在下载的全基因组文件中查到。

**Q: 如果 RegulomeDB score 很低 (5-7) 怎么办?**
A: 这不代表 SNP 没有功能——RegulomeDB 只是已知数据的整合。如果 score 低但 GWAS credible set 高 (如我们的 0.876), 仍然有很强的调控证据。

**Q: GTEx eQTL 不显著怎么办?**
A: GTEx 只测了 838 人, 统计力有限。如果我们的 SNP 在 GTEx 中不显著, 可以用 BrainMeta (2865 脑皮层样本) 或 eQTLGen (31,684 血液样本) 补充。

---

## 7. 湿实验 vs 计算分析 — 这些数据到底是怎么来的？

### 7.1 核心认知

**所有这些数据的原始产生都是真实的湿实验**。但实验产生的原始数据被公开发布在 ENCODE/GTEx 等数据库中，其他研究者**不需要重做实验就可以直接用于计算分析**。

类比：GWAS 是真实的基因分型实验 → 发布 summary statistics → 你做 MR 不需要重新做 GWAS，直接用统计数据即可。

| 数据类型 | 原始湿实验 | 公开发布格式 | 你如何获取 | 需要自己做实验吗？ |
|---------|----------|------------|----------|:--:|
| GWAS | 数百万人的 SNP 芯片/测序 | summary statistics (.tsv.gz) | GWAS Catalog FTP 下载 | ❌ 不需要 |
| eQTL | 数百人的 RNA-seq + 基因型 | GTEx Portal | 浏览器查询/API | ❌ 不需要 |
| ATAC-seq | 细胞核 + Tn5 转座酶 + NGS 测序 | bigWig (.bw) 或 peak (.bed) | ENCODE Portal 下载 | ❌ 不需要 |
| H3K27ac ChIP-seq | 抗体富集 + NGS 测序 | bigWig (.bw) | ENCODE Portal 下载 | ❌ 不需要 |
| DNase-seq | DNase I 消化 + NGS 测序 | bigWig (.bw) | ENCODE Portal 下载 | ❌ 不需要 |
| TF motif | 通过 SELEX/ChIP-seq 实验确定 | PWM 矩阵 (JASPAR) | JASPAR 下载 | ❌ 不需要 |
| RegulomeDB | 整合上述所有数据 | 综合评分 | 网页查询 | ❌ 不需要 |

**结论：表观基因组注释 = 100% 计算分析，0% 自己做实验。所有数据别人已经做好了，你只需要下载和分析。**

---

### 7.2 DNase Footprint — 详细实验原理

**这个实验到底是怎么做的？**

```
Step 1: 取细胞核 (如来自冠状动脉的平滑肌细胞)
Step 2: 加入 DNase I 酶 → 消化未被蛋白质保护的 DNA
Step 3: 被 TF 紧紧包裹的 DNA (6-40bp) 不会被消化
Step 4: NGS 测序 → 比对到基因组 → 找到"缺口"
Step 5: 这些"缺口" = DNase footprints = TF 精确结合位点
```

**为什么 DNase footprint 比 ChIP-seq 更精确？**

```
ChIP-seq:       ~~~~~~~[==============峰==============]~~~~~~~
                抗体拉下来的 DNA 片段 (~200bp)
                知道 TF 在附近，但不知道精确位置

DNase footprint: ~~~~~~~[=缺口=]~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
                被 TF 保护而未被消化的精确小片段 (6-40bp)
                知道 TF 在基因组上的精确坐标, 精确到单个核苷酸!
```

**你能在自己的电脑上用这些数据做什么？**

1. **下载**: ENCODE Portal → 搜索 "DNase-seq" + "heart" → 下载 .bw 文件
2. **可视化**: UCSC Genome Browser 加载 .bw track → 在 rs4910165 位置查看是否有 DNase footprint
3. **定量**: 如果 rs4910165 的 C 等位基因位置有 DNase footprint，而 G 没有 → 证明该 SNP 影响 TF 结合
4. **预测**: 用 `motifbreakR` (R 包) 预测 C→G 改变了哪个 TF 的结合 motif

**所有这些操作都在电脑上完成**。你不需碰任何试管。原始实验是别人（ENCODE 联盟，数百个实验室，十几年）做的，数据是公开免费的。

---

### 7.3 五种数据的"湿/干"属性

| 数据 | 湿实验做了什么 | 干分析你能做什么 | 难度 |
|------|-------------|----------------|:--:|
| **eQTL** | 取 838 人的 49 个组织 → RNA-seq + 基因分型 → 计算 SNP-基因关联 | GTEx Portal 查 rs4910165 → 看哪个组织中该 SNP 影响 IRAG1 表达 | ⭐ |
| **TF ChIP-seq** | 用特定 TF 抗体拉下结合的 DNA → NGS 测序 → 找富集峰 | ENCODE 下载 → 在 rs4910165 位置查看是否有 TF 结合峰 | ⭐⭐ |
| **DNase-seq peak** | DNase I 消化开放染色质 → NGS 测序 → 找消化峰 | 下载 ENCODE .bw → UCSC 查看 rs4910165 是否在开放染色质中 | ⭐⭐ |
| **DNase footprint** | 同上，但用更高深度测序 → 在峰内找被保护的"缺口" | RegulomeDB 直接查 score（已整合）→ 看是否有 "DNase footprint" 标记 | ⭐ |
| **TF motif** | SELEX/ChIP-seq 实验确定每个 TF 喜欢结合什么 DNA 序列 | JASPAR 下载 PWM → motifbreakR 预测 rs4910165 的 C vs G 哪个更符合 motif | ⭐⭐ |

---

### 7.4 以我们的 rs4910165 为例 — 实际你能做的操作

**场景**: 你想知道 rs4910165 (C→G) 是否影响某个 TF 的结合，从而改变 IRAG1 的表达。

**完全不需要做实验的操作流程**：

```
1. RegulomeDB (30秒): 
   https://regulomedb.org/regulome-search/?regions=chr11:10652497-10652497
   → 查看 score (1a-7)
   → 查看 supporting data: 有没有 "DNase footprint"? 有没有 "TF binding"?
   
2. GTEx Portal (2分钟):
   https://gtexportal.org/home/snp/rs4910165
   → 在哪些组织中 rs4910165 是 IRAG1 的 eQTL?
   → 效果方向: C 等位基因 → IRAG1 mRNA ↑ 还是 ↓?

3. UCSC Genome Browser (5分钟):
   加载 ENCODE tracks → 在 rs4910165 位置截图
   → DNase Clusters track: 有 peak 吗?
   → H3K27ac track: 是增强子区域吗?
   → TF ChIP-seq tracks: 哪些 TF 在这里结合?

4. motifbreakR R包 (10分钟):
   install.packages("motifbreakR")
   → 输入 rs4910165 + 参考/替代等位基因 (C/G)
   → 自动扫描 JASPAR 数据库中的所有 TF motif
   → 输出: 哪些 TF 的 motif 被 C→G 破坏了?

5. 整合 (10分钟):
   → 制作表格: TF name | motif score change | tissue expression | reference
   → 画图: motif logo + SNP 位置标注
```

**这些操作你全部可以在没有实验室的情况下完成。你不需碰任何试管、细胞、抗体、或测序仪。**

---

### 7.5 常见误解

**误解1**: "我需要自己做 DNase-seq 实验才能知道 DNase footprint"
→ ❌ 错。ENCODE 已经做了数百个 DNase-seq 实验，数据公开可下载。你只需要"查"，不需要"做"。

**误解2**: "RegulomeDB score 是别人计算的，不能相信"
→ ❌ 错。RegulomeDB 整合的是 ENCODE 的原始湿实验数据 + GTEx 的 eQTL 数据，这些都是经过同行评审的公共数据库。比你自己从零开始分析更可靠。

**误解3**: "没有针对我的组织的 ENCODE 数据，所以这一步无法做"
→ ⚠️ 半对半错。ENCODE 确实偏向细胞系（K562, GM12878, HepG2），原代血管组织数据确实少。但：
  - 可以用相近组织（心脏、主动脉、全血）替代
  - 开放染色质/DNase 峰在多种细胞类型中高度保守
  - RegulomeDB 整合多种组织，即使你的特定组织不在其中，综合评分仍有参考价值
  - Yoshiji 2025 也面临同样的局限——他们用的也是有限的几种组织

**误解4**: "TF motif 预测是纯计算，不靠谱"
→ ⚠️ 需要区分：
  - "motif 被破坏" ≠ "功能一定改变" → 这需要实验验证
  - 但 "motif 被强烈破坏 + eQTL 证实 + GWAS 显著" → 三者合一 = 非常强的功能证据
  - 这正是 Yoshiji 2025 的策略：不依赖单一证据，而是多证据线交叉验证

---

*手册更新于 2026-06-02 12:30 CST · v2.0*
