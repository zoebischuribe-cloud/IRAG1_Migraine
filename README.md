# IRAG1→Migraine — CRP两阶段 pQTL MR 项目

**对标**: Yoshiji 2025 Nat Genet (PMID:39856218)
**框架**: CRP (炎症) → IRAG1/MRVI1 → Migraine (偏头痛)
**创建**: 2026-06-02 | **Meta SOP**: Track 2 (科研任务)

---

## 目录结构

```
IRAG1_Migraine/
├── README.md                          ← 本文件
│
├── docs/                              ← 所有文档
│   ├── arc/                           ← ARC 基础设施 (4 文件)
│   │   ├── ARC_STATE.md               ← 8 Phase 状态 + 累计产出
│   │   ├── ARC_FRAMEWORK.md           ← PICO + 假设 + 数据源
│   │   ├── GATE_LOG.md                ← 3 GATE 审批记录
│   │   └── ARC_PREVENTION.md          ← 错误预防清单
│   ├── execution_logs/                ← 逐步执行记录 (§20 模板)
│   │   └── StepXX_*.md                ← 每步: 目的/文献/工具/结果/溯源
│   ├── plans/                         ← 对齐文档 + 分析方案
│   ├── reference/                     ← 参考论文 PDF + 补充材料
│   │   └── 41588_2024_Article_2052.pdf ← Yoshiji 2025 原文
│   └── knowledge_cards/               ← 可独立分发的知识卡片
│       ├── 表观基因组注释_从0到1.md
│       ├── RegulomeDB知识卡片.md
│       ├── JASPAR_TFmotif_motifbreakR.md
│       └── PheWAS知识卡片.md
│
├── results/                           ← 所有分析产出
│   ├── figures/                       ← 图片 (.png/.tiff)
│   │   └── Fig06_IRAG1_GeneModel.png
│   └── tables/                        ← 表格 (.csv)
│
├── scripts/                           ← 所有脚本
│   ├── mr/                            ← MR 分析脚本
│   │   ├── crp_ieu_mr.R               ← CRP→IRAG1 (IEU clumping)
│   │   ├── sensitivity_irig1_migraine.R ← 敏感性分析
│   │   ├── mr_fast.R                  ← Phase 2 Docker MR 核心
│   │   └── phase2_watchdog.sh         ← Phase 2 断点续跑
│   ├── coloc/                         ← Coloc + Fine-mapping
│   │   ├── coloc_v2.R                 ← coloc.abf + SuSiE
│   │   └── locuscompare_irig1.R       ← LocusCompare 图
│   ├── epigenomics/                   ← 表观基因组
│   │   ├── fig6_irig1_genemodel.R     ← 基因模型图
│   │   └── fig6c_motif.R              ← TF motif 分析
│   ├── phewas/                        ← PheWAS + 批量 MR
│   │   └── batch_mr_v2.R              ← IEU 批量暴露搜索
│   └── run_motifbreakR_windows.R      ← Windows 端 motifbreakR
│
└── data/                              ← 项目专属数据 (小文件)
```

---

## 数据存储规则 (双轨制)

| 数据类型 | 存放路径 | 示例 |
|---------|---------|------|
| **公共/可复用数据** | `D:\00_Ref_data\` | ENCODE tracks, 1000G ref, RegulomeDB DB |
| **GWAS 原始数据** | `D:\01_Projects\GWAS_rawdata\` | CRP GWAS, deCODE pQTL, FinnGen GWAS |
| **项目专属数据** | `D:\01_Projects\IRAG1_Migraine\data\` | MR 结果子集, coloc 输入 |
| **项目产出** | `D:\01_Projects\IRAG1_Migraine\results\` | Figures, Tables |

## 文档存储规则

| 文档类型 | 存放路径 | 命名格式 |
|---------|---------|---------|
| **ARC 文件** | `docs/arc/` | `ARC_*.md` |
| **执行日志** | `docs/execution_logs/` | `StepXX_名称.md` (7 字段模板) |
| **对齐文档** | `docs/plans/` | `PhaseX_名称_对齐文档.md` |
| **知识卡片** | `docs/knowledge_cards/` | `WSL_CC_主题_知识卡片.md` |
| **参考论文** | `docs/reference/` | 原始文件名 |

## 脚本命名规则

```
{功能描述}_{子功能}.{ext}
例: coloc_v2.R, sensitivity_irig1_migraine.R, fig6_irig1_genemodel.R
```

## 关键外部路径

```
GWAS_rawdata:    D:\01_Projects\GWAS_rawdata\
1000G ref:       D:\00_Ref_data\1kg.v3\EUR
RegulomeDB:      D:\00_Ref_data\RegulomeDB\
ENCODE:          D:\00_Ref_data\ENCODE\
GWAS Catalog:    D:\00_Ref_data\GWAS数据源\
Phase 2 results: /home/zhu/Projects/0531/results/ralph/
Nutstore 文档:   C:\Users\Admin\Nutstore\1\SunnyWiki\raw\inbox\YYYYMMDD\
```

---

## 快速导航

| 你想... | 去哪里 |
|--------|--------|
| 了解项目定义? | `docs/arc/ARC_FRAMEWORK.md` |
| 查看当前进度? | `docs/arc/ARC_STATE.md` |
| 看所有分析步骤? | `docs/execution_logs/` |
| 看 Yoshiji 原文? | `docs/reference/41588_2024_Article_2052.pdf` |
| 找 MR 脚本? | `scripts/mr/` |
| 找 coloc 脚本? | `scripts/coloc/` |
| 看结果图? | `results/figures/` |
| 学习表观基因组? | `docs/knowledge_cards/表观基因组注释_从0到1.md` |
| 学习 PheWAS? | `docs/knowledge_cards/PheWAS知识卡片.md` |
