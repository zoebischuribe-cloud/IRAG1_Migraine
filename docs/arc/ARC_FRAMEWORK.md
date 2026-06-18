# ARC_FRAMEWORK — IRAG1→Migraine 项目定义

**创建**: 2026-06-02 | **对标**: Yoshiji 2025 Nat Genet (PMID:39856218)
**Meta SOP**: Track 2 (科研任务), RALPH + ARC 23-Stage

## PICO 框架

| 要素 | 定义 |
|------|------|
| **P** (Population) | 欧洲祖先人群 (deCODE + FinnGen + GWAS Catalog) |
| **I** (Intervention/Exposure) | CRP (C-reactive protein) — 可修改炎症标志物 |
| **C** (Comparison) | 基因预测的 CRP 水平差异 (MR) |
| **O** (Outcome) | Migraine (偏头痛) + Migraine with Aura (偏头痛伴先兆) |

## 两阶段 MR 框架

```
Step 1: CRP (N=575,531) → IRAG1/MRVI1 pQTL (N=35,559)
Step 2: IRAG1 cis-pQTL → Migraine (FinnGen R12, N=401,499)
```

## 核心假设

1. **H1**: CRP 水平升高 → IRAG1 蛋白水平变化 (补偿性保护反应)
2. **H2**: IRAG1 蛋白水平 → 偏头痛风险 (保护效应, 通过 cGMP-PKG-Ca²⁺ 通路)
3. **H3**: CRP 与 IRAG1 的 cis-pQTL (rs4910165) 共享因果变异 (PP.H4 > 0.8)
4. **H4**: IRAG1 在血管平滑肌 + 血小板中高表达 → 偏头痛血管假说的分子基础
5. **H5**: 靶向 IRAG1 安全 (PheWAS 无有害副作用)

## 数据源

| 数据 | 来源 | N | 访问 |
|------|------|-----|------|
| CRP GWAS | Said 2022, GCST90029070 | 575,531 | D:\01_Projects\GWAS_rawdata\ |
| IRAG1 pQTL | deCODE, Ferkingstad 2021 | 35,559 | D:\01_Projects\GWAS_rawdata\decode\ |
| Migraine GWAS | FinnGen R12 | 401,499 | D:\01_Projects\GWAS_rawdata\ |
| 1000G Ref | 1kg.v3 EUR | 503 | D:\00_Ref_data\1kg.v3\EUR |

## 方法学对标

| 分析 | 工具 | 文献 |
|------|------|------|
| Two-sample MR | TwoSampleMR 0.7.5 | PMID:39856218 |
| Coloc | coloc 6.0.1 | PMID:24830394 |
| Fine-mapping | susieR 0.12.35 | PMID:31943143 |
| V2G | Open Targets GraphQL | PMID:39856218 |
| Epigenomics | ENCODE + RegulomeDB | PMID:39856218 |

## 项目目录

```
D:\01_Projects\IRAG1_Migraine\
├── docs\arc\           ← ARC 基础设施
├── docs\execution_logs\ ← 逐步执行记录 (§20 模板)
├── results\            ← 分析产出
└── scripts\            ← R/Python 脚本
```
