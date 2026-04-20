# Codex 接入说明（OC_dev 私人知识库）

## 知识库位置

`/Users/mac/Documents/Vaults/OC_dev/`

完整的 schema 规则、页面类型定义、ingest 流程见：
`/Users/mac/Documents/Vaults/OC_dev/CLAUDE.md`

## 任务开始前：读取上下文

按顺序读取以下文件，建立项目全貌：

1. `/Users/mac/Documents/Vaults/OC_dev/wiki/index.md` — 项目、实体、概念总览
2. `/Users/mac/Documents/Vaults/OC_dev/wiki/projects/` — 找到与当前任务相关的项目页
3. 根据项目页中的 `key_entities`，按需读取 `wiki/entities/` 和 `wiki/concepts/` 中的相关页面

如果 wiki 尚无相关内容，直接开始任务即可。

## 任务完成后：产出资料并炼制知识

完成非 trivial 的修复或功能后，按以下步骤操作：

### 第 1 步：写入原始资料

将产出内容（分析文档、实施记录、问题总结等）写入：

```
/Users/mac/Documents/Vaults/OC_dev/raw/<主题>/
```

每份文件至少包含：背景、做了什么、结果、可复用规则。

### 第 2 步：Ingest 进 wiki

按照 `CLAUDE.md` 中的 **Ingest 操作流程** 执行：

1. 检测变化：`git diff last-ingest -- raw/`（首次用初始 commit 做基线）
2. 读取新文件 → 创建/更新 source 摘要页（含 `touches` 字段）
3. 创建/更新相关的 entities、concepts、projects 页面
4. 更新 `wiki/index.md` 和 `wiki/_index_sources.md`
5. 在 `wiki/log.md` 追加记录
6. Commit 并更新基线：
   ```bash
   git add -A && git commit -m "[ingest] <主题简述>"
   git tag -f last-ingest HEAD
   ```
