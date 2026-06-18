# ARC_PREVENTION — IRAG1→Migraine 错误预防清单

**创建**: 2026-06-02
**用途**: 每次新对话/新 Phase 启动时，AI 必须先读此文件

## 本项目已犯错误 (防止再犯)

| # | 错误 | 根因 | 预防 |
|---|------|------|------|
| 1 | **跳过 ARC 先执行** | 无检查点绑定 | 每次 Phase 启动前检查 ARC_STATE.md 是否存在 |
| 2 | **跳过对齐文档** | Meta SOP §0.1 未自动触发 | Phase 边界强制 Halt → 等用户说 APPROVE |
| 3 | **Windows zcat 失败** | 未区分 OS | WSL 用 `cmd="zcat < file"`, Windows 用 `fread("file")` |
| 4 | **GWAS \r bug 修复 5 次** | 未用二进制模式 | 二进制读取 → .replace(b'\r', b'') → 二进制写入 |
| 5 | **coloc SNP 去重** | coloc.abf 不允许重复 | 合并后先 `!duplicated(SNP)` |
| 6 | **两阶段方向不一致跳过** | 未提前识别 | Phase C 知识合成时应标注 β1×β2<0 |

## 项目特定规则

1. **CRP→IRAG1 方向**: β=+0.039 (CRP↑ → IRAG1↑), 但 IRAG1→Migraine: β=-0.558 (保护)
   → **不一致中介** — Discussion 解释为"补偿性保护反应", 引用 Lou 2024 先例
2. **cis-only 工具变量**: 必须用 IRAG1 ±1Mb cis-pQTL, 禁止全基因组 instruments (已验证 cis vs trans 方向反转)
3. **IEU JWT**: token 2026-06-11 到期 — 到期前必须续期
4. **参考面板**: 1kg.v3 EUR (503 人, 8.55M SNPs) — 比 IEU 面板 SNP 少, clumping 结果不同

## 🔗 强提醒联动

- 违反 #1 → 强提醒 #35 (ARC 铁律)
- 违反 #2 → Meta SOP §0.1 铁律 1
- 违反 #3-5 → 本文件 + 项目知识库
