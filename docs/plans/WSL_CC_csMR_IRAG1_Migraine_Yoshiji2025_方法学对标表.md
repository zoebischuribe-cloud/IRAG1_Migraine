# WSL_CC — Yoshiji 2025 Nat Genet 方法学深度对标表

**参考论文**: Yoshiji et al. 2025, *Nature Genetics* 57(2):345-357 (PMID: 39856218)
**对标项目**: CRP → IRAG1 → Migraine 两阶段 pQTL MR

---

## 1. Yoshiji 2025 完整结果架构 (含方法学映射)

| Yoshiji 2025 结果节 | 方法 | 工具/数据 | 我们的对标 | 状态 |
|---------------------|------|---------|-----------|:--:|
| **Overall study design** | 两阶段 MR 研究设计总览 | BMI→4907 proteins→CAD/Stroke/T2D | CRP→1755 proteins→Migraine | ✅ |
| **MR step 1** | IVW + Bonferroni + heterogeneity/pleiotropy/reverse causation/directional concordance | deCODE pQTL (N=35,559) + BMI GWAS (N=681,275) | CRP GWAS (N=575,531) → IRAG1 pQTL (N=35,559) | ✅ P=0.037 |
| **MR step 2** | cis-pQTL instruments only (±1Mb TSS), 仅与1个蛋白关联, Bonferroni per outcome | cis-pQTLs from deCODE | IRAG1 cis-pQTL (rs7940646) → Migraine GWAS | ✅ P=5.84e-11 |
| **Colocalization** | coloc.abf, PP.H4>0.8, 500kb window | coloc R包 | IRAG1 cis-pQTL × Migraine GWAS, ±500kb | ✅ PP.H4=0.993 |
| **Replication MR** | 多平台 pQTL (Fenland/ARIC/UKB Olink) 复制 Step 1+2 | 不同蛋白组平台 | ⬜ 需 UKB-PPP Olink 数据 | ⬜ |
| **Observational evaluation** | EPIC-Norfolk 队列 (n=872) 观察性验证 | BMI-CRP-COL6A3 association | ⬜ 需独立队列 | ⬜ |
| **Cox regression** | UK Biobank (n=38,361) 累计发病率 | COL6A3 levels × CAD risk | ⬜ 需 UK Biobank 数据 | ⬜ |
| **Domain-aware MR** | N-terminal vs C-terminal aptamers 分别 MR | COL6A3 双 aptamer | IRAG1 有 9 isoforms → domain-aware MR | ⬜ |
| **Body fat compartment MR** | MRI-derived fat depots GWAS → protein levels | Agrawal 2022 GWAS | 不适用 (CRP 非 BMI) | N/A |
| **Fine-mapping (SuSiE)** | SuSiE RSS, 95% credible set, PIP | susieR R包 | IRAG1 cis-region SuSiE | ✅ 3 CS, max PIP=0.999 |
| **V2G mapping** | Open Targets Genetics → variant-to-gene score | Open Targets API | rs7940646 → IRAG1 | ⬜ 待执行 |
| **Epigenomics** | ENCODE ATAC-seq + H3K27ac + H3K4me3 ChIP-seq + RegulomeDB + TF motif disruption | ENCODE + RegulomeDB | rs4910165 (top SuSiE SNP) | ⬜ 待执行 |
| **Sex-stratified MR** | 性别分层 Step 1 + Step 2 MR | sex-stratified GWAS | ⬜ 需性别分层 GWAS | ⬜ |
| **scRNA-seq** | 脂肪组织 + 冠状动脉 COL6A3 表达 | SCP1376 + GSE131780 | 脑血管 + 血小板 IRAG1 表达 | ⬜ 待执行 |
| **Multivariable MR** | 脂肪质量 vs 瘦质量独立效应 | MVMR | ⬜ CRP × 其他炎症标志物 MVMR | ⬜ |
| **PheWAS** | Open Targets Genetics, P<1e-5 | rs11677932 ±500kb | rs4910165 ±500kb | ⬜ 待执行 |
| **Actionability assessment** | 减重→蛋白质↓→疾病风险↓ | 临床干预 | 抗炎 (他汀/IL-6i)→CRP↓→IRAG1 恢复→Migraine↓ | ⬜ |

---

## 2. 关键参数对标

| 参数 | Yoshiji 2025 | 本研究 | 文献来源 |
|------|-------------|--------|---------|
| Step 1 暴露 GWAS N | 681,275 (BMI) | 575,531 (CRP) | Said 2022 (PMID:35459240) |
| pQTL 数据 | deCODE (N=35,559, SomaScan v4) | deCODE (N=35,559, SomaScan v4) — **相同!** | Ferkingstad 2021 |
| Step 2 结局 GWAS | CARDIoGRAM (CAD), GIGASTROKE, MAGIC | FinnGen R12 Migraine (N=401,499) | FinnGen R12 |
| 工具变量类型 | cis-pQTL only (±1Mb TSS) | cis-pQTL only (rs7940646 ±1Mb) | ✅ 相同策略 |
| MR p 值阈值 | Bonferroni 0.05/4907=1e-5 | Bonferroni 0.05/1138=4.39e-5 | ✅ 相同原则 |
| Coloc 窗口 | ±500kb | ±500kb | ✅ 相同 |
| Coloc 方法 | coloc.abf | coloc.abf (v6.0.1) | ✅ 相同包 |
| Coloc 先验 | p1=1e-4, p2=1e-4, p12=1e-5 | p1=1e-4, p2=1e-4, p12=1e-5 | ✅ 相同 (Giambartolomei 2014 defaults) |
| Coloc 阈值 | PP.H4 > 0.8 | PP.H4 > 0.8 | ✅ 相同 |
| Fine-mapping 方法 | SuSiE RSS | SuSiE RSS | ✅ 相同 |
| Fine-mapping 可信集 | 95% CS | 95% CS | ✅ 相同 |
| SuSiE L | 未明确 | L=10 | Wang 2020 (PMID:31943143) |

---

## 3. 已完成 vs 待执行 vs N/A

| 类别 | 数量 | 内容 |
|------|:---:|------|
| ✅ **已完成** | 7 | MR Step 1, MR Step 2, Coloc, SuSiE, Study Design, 统计框架, 参数对标 |
| ⬜ **待执行** | 8 | 复制 MR, V2G, 表观基因组, scRNA-seq, PheWAS, MVMR, 性别分层, 可操作性评估 |
| N/A | 2 | 观察性队列, Cox 回归 (需个体数据), 体脂区域 MR (不适用 CRP) |

---

## 4. 论文结构模板（对标 Yoshiji 2025）

| 论文章节 | 对应 Yoshiji 2025 结果节 | 我们的内容 |
|---------|------------------------|-----------|
| **Main** | Overall study design | CRP→IRAG1→Migraine 两阶段 MR 设计总览 |
| **Results §1** | MR step 1 | CRP → IRAG1: P=0.037, 264 instruments |
| **Results §2** | MR step 2 | IRAG1 → Migraine: P=5.84e-11, 唯一 FDR 显著 |
| **Results §3** | Colocalization | coloc PP.H4=0.993, 共享因果变异 |
| **Results §4** | Fine-mapping + V2G + epigenomics | SuSiE CS1 (rs4910165, PIP=0.999), RegulomeDB, ENCODE |
| **Results §5** | Replication MR | UKB-PPP Olink 复制 (待) |
| **Results §6** | COL6A3 expression analyses / scRNA-seq | IRAG1 脑血管+血小板 scRNA-seq (待) |
| **Results §7** | Assessment of actionability | PheWAS + CRP 药物干预 (待) |
| **Discussion** | Discussion | 炎症-血管 cGMP-Ca²⁺ 新机制, 与 Lou 2024 差异化 |
