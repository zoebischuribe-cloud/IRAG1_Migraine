# WSL_CC — IRAG1→Migraine 5 差异化步骤 完整执行方案

**对标**: Yoshiji 2025 Nat Genet | **可用工具**: 19 MCP + QTLMR + KS Skills

---

## Step 1: 复制 MR (Replication MR)

**对标 Yoshiji §**: "Replication MR for step 1 and step 2 for C-terminal COL6A3"
**目的**: 用不同蛋白组平台 (Olink) 验证 IRAG1→Migraine 的因果效应

| 工具 | 用途 |
|------|------|
| **gwas-mcp** `search_open_targets` | 查 UKB-PPP 是否有 IRAG1 pQTL |
| **biomcp** `search article -g IRAG1` | 找 UKB-PPP Olink IRAG1 的 pQTL 文献 |
| **IEU OpenGWAS** `extract_instruments` | 提取 UKB-PPP cis-pQTL (需 JWT) |
| **QTLMR** `format_data_ukb_pQTL_cis` | 格式化 UKB-PPP pQTL 数据 |
| **TwoSampleMR** | harmonise + MR |
| **pubmed-search** | 查已发表的 IRAG1 pQTL 论文 (PMID:39578729 Lou 2024 有 eQTL 数据) |

**执行**: 
1. gwas-mcp `search_open_targets("IRAG1")` → 找 UKB-PPP 中 IRAG1 的 pQTL
2. IEU 提取 UKB-PPP cis-pQTL → 格式化为 TwoSampleMR exposure
3. 结局: FinnGen Migraine GWAS (已有)
4. MR: cis-pQTL → Migraine (用 IEU clumping)

**预期**: 复制 IRAG1 保护效应, OR≈0.57, P<0.05

---

## Step 2: V2G 映射 (Variant-to-Gene Mapping)

**对标 Yoshiji §**: "V2G mapping — querying the Open Targets Genetics database"
**目的**: 确认 SuSiE 因果 SNP (rs4910165) 通过增强子-TSS 互作调控 IRAG1

| 工具 | 用途 |
|------|------|
| **gwas-mcp** `get_variant_info("rs4910165")` | 获取 rs4910165 基本信息 (位置/MAF/consequence) |
| **gwas-mcp** `search_open_targets("IRAG1")` | Open Targets V2G score + enhancer-TSS 互作 |
| **gwas-mcp** `query_gwas_catalog(gene="IRAG1")` | GWAS Catalog 中 IRAG1 位点关联 |
| **ensembl** `ensembl_lookup(ENSG00000072952)` | Ensembl 基因结构 + 调控元件 |
| **ensembl** `ensembl_regulatory` | 该位点调控特征 |
| **biomcp** `get gene IRAG1` | NCBI Gene 完整注释 |

**执行**:
1. `get_variant_info("rs4910165")` → chr11:10652497, consequence
2. `search_open_targets("IRAG1")` → V2G score, enhancer-TSS interactions
3. `ensembl_regulatory(region="11:10647497-10657497")` → 调控注释

**预期**: rs4910165 在 IRAG1 启动子/增强子区域, 高 V2G score

---

## Step 3: 表观基因组注释 (Epigenomics)

**对标 Yoshiji §**: "Regulatory role of the lead cis-pQTL — ENCODE, RegulomeDB, TF motif disruption"
**目的**: 证明 rs4910165 位于活性调控区域, 可能破坏转录因子结合

| 工具 | 用途 |
|------|------|
| **gwas-mcp** `get_variant_info("rs4910165")` | RegulomeDB score (如果 gwas-mcp 支持) |
| **biomcp** | 基因调控注释 |
| **ensembl** `ensembl_regulatory(region, species)` | ENCODE 数据: ATAC-seq, H3K27ac, H3K4me3 ChIP-seq peaks |
| **pubmed-search** | 查 ENCODE/RegulomeDB 相关方法学论文 |

**执行**:
1. `ensembl_regulatory(region="11:10647497-10657497")` → 列出该区域所有调控特征
2. 提取 ATAC-seq + H3K27ac + H3K4me3 peaks 在 rs4910165 位置
3. 识别可能受影响的 TF 结合 motif

**预期**: rs4910165 在开放染色质区, 有 H3K27ac 增强子标记, 可能破坏某 TF 结合

---

## Step 4: 单细胞表达分析 (scRNA-seq)

**对标 Yoshiji §**: "COL6A3 expression analyses — single-cell RNA sequencing in adipose tissues and coronary arteries"
**目的**: 确定 IRAG1 在偏头痛相关细胞类型中的表达特异性

| 工具 | 用途 |
|------|------|
| **biomcp** `get gene IRAG1 protein` | IRAG1 蛋白定位 (已确认: 血管平滑肌, 血小板, ER膜) |
| **biomcp** (PanglaoDB) | 单细胞 marker gene 数据库 |
| **gwas-mcp** `get_gene_pathways("IRAG1")` | KEGG/Reactome 通路 |
| **pubmed-search** | 查脑血管/血小板 scRNA-seq 论文 |
| **KS** `scientific-brainstorming` | 生成 IRAG1 细胞类型假说 |

**执行**:
1. `bc_get_panglaodb_marker_genes(gene_symbol="IRAG1", species="Hs")` → 查 IRAG1 在哪些细胞类型中是 marker
2. pubmed_search_articles("IRAG1 AND (single-cell OR scRNA-seq) AND (brain OR vascular OR platelet)")
3. 文献整合: IRAG1 在血管平滑肌细胞 + 血小板 + 脑微血管内皮细胞中的表达

**预期**: IRAG1 在脑微血管内皮细胞 + 血小板中高表达, 连接血管假说与偏头痛

---

## Step 5: PheWAS (药物安全性评估)

**对标 Yoshiji §**: "Assessment of actionability — phenome-wide association analysis using Open Target Genetics at P<1e-5"
**目的**: 评估 IRAG1 扰动对全身表型的影响 (药物安全性)

| 工具 | 用途 |
|------|------|
| **gwas-mcp** `get_disease_associations("IRAG1")` | Open Targets: IRAG1 与 267 个疾病的遗传关联 |
| **gwas-mcp** `query_gwas_catalog(trait="...")` | 反向查 rs4910165 与哪些表型关联 |
| **gwas-mcp** `get_variant_info("rs4910165")` | 该 SNP 的已知 GWAS 关联 |
| **biomcp** `search drug --target IRAG1` | 已有靶向药物 (0 — 新颖性!) |
| **pubcrawl** `search_by_indication("migraine")` | 已有偏头痛药物 |
| **clinicaltrialsgov** | 偏头痛 + CRP/抗炎临床试验 |
| **KS** `scientific-critical-thinking` | 安全性评估框架 |

**执行**:
1. `get_disease_associations("IRAG1")` → 267 关联 (已获取: migraine 0.547, CAD 0.418, Pain 0.327)
2. `query_gwas_catalog(rsid="rs4910165")` → 该 SNP 的 GWAS 表型全景
3. 评估: 降低 IRAG1 是否增加其他疾病风险? (CAD, Pain, 血小板功能障碍?)
4. `search drug --target IRAG1` → 0 results → FIRST-IN-CLASS ✅
5. 已有 CRP 通路药物: 他汀, IL-6 抑制剂 (tocilizumab), CRP apheresis

**预期**: IRAG1 降低安全 (无已知副作用), first-in-class 药靶潜力

---

## 工具使用总览

| Step | gwas-mcp | biomcp | ensembl | pubmed | pubcrawl | clinicaltrials | QTLMR | KS Skills |
|------|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|
| 1. 复制 MR | ✅ | ✅ | — | ✅ | — | — | ✅ | — |
| 2. V2G | ✅ | ✅ | ✅ | — | — | — | — | — |
| 3. 表观基因组 | ✅ | ✅ | ✅ | ✅ | — | — | — | — |
| 4. scRNA-seq | ✅ | ✅ | — | ✅ | — | — | — | ✅ |
| 5. PheWAS | ✅ | ✅ | — | — | ✅ | ✅ | — | ✅ |

**总计**: 12/19 MCP 使用 + QTLMR + 3 KS Skills
