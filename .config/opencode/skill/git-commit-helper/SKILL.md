---
name: git-commit-helper
description: Analyzes git changes and generates commit messages that match the repository's commit history style and conventions. This skill should be used when creating git commits or when the user asks to check git changes and create commit messages.
---

# Git Commit Helper

This skill analyzes your git changes and generates commit messages that follow your repository's established conventions and language style.

## When to Use This Skill

Use this skill when:
- User asks to create a commit message
- User asks to check git changes
- User requests help with committing changes
- User wants a commit message that matches the project's style

## Workflow

### Step 1: Analyze Git Changes

Run these commands in parallel to understand the changes:

```bash
# Check status
git status

# View staged changes
git diff --cached

# View unstaged changes (if needed)
git diff

# Get recent commit messages for style reference
git log --pretty=format:"%s" -10
```

### Step 2: Determine Commit Message Language

**CRITICAL**: The commit message language MUST match the repository's existing commits.

1. Read recent commit history from `git log`
2. Detect the primary language used (Chinese, English, etc.)
3. Use that same language for the new commit message

**Example Analysis**:
- If recent commits are: "feat: 添加新功能", "fix: 修复bug" → Use **Chinese**
- If recent commits are: "feat: add new feature", "fix: resolve bug" → Use **English**
- If mixed, use the majority language from the last 10 commits

### Step 3: Load Commit Message Template (if exists)

Check if `.gitmessage` exists in the repository root:

```bash
cat .gitmessage 2>/dev/null || echo "No template found"
```

If found, use it as a reference for:
- Commit message format
- Type conventions (feat, fix, docs, etc.)
- Scope usage patterns
- Subject line guidelines

### Step 4: Analyze the Changes

Review the diff output to understand:
1. **Type of change**: 
   - feat (新功能/new feature)
   - fix (修复/bug fix)
   - docs (文档/documentation)
   - style (格式/formatting)
   - refactor (重构/refactoring)
   - perf (性能优化/performance)
   - test (测试/tests)
   - chore (构建/工具/dependencies)
   - revert (回滚/revert)

2. **Scope**: What part of the codebase is affected?
   - Module name (e.g., "zsh", "nvim", "waybar")
   - Feature area (e.g., "auth", "api", "ui")
   - Leave empty if change is global

3. **Impact**: What is the core change?
   - Focus on the "why" and "what" not "how"
   - Keep it concise (< 50 characters if possible)

### Step 5: Generate Commit Message

Follow this format based on the template:

```
<type>(<scope>): <subject>

[Optional: Detailed body if changes are complex]

[Optional: Breaking changes or issue references]
```

**Guidelines**:
- **Subject line**:
  - Use imperative mood verbs (添加/add, 修复/fix, 调整/adjust, 移除/remove)
  - Keep under 50 characters
  - No period at the end
  - Match the language of existing commits
- **Scope**:
  - Optional but recommended
  - Use lowercase
  - Be specific but not too granular
- **Body** (if needed):
  - Explain WHY the change was made
  - Describe WHAT changed
  - Note any side effects or risks

### Step 6: Present the Commit Message

Show the user:
1. **Summary of changes**: Brief overview of what was modified
2. **Proposed commit message**: The generated message
3. **Ask for confirmation**: "Should I proceed with this commit message, or would you like me to adjust it?"

## Examples

### Example 1: Chinese commits with scope

**Recent commits**:
```
chore(zsh): 模块化配置并规范git提交信息
feat(sway): 更新快捷键配置
fix(waybar): 修复时钟显示问题
```

**Changes**: Modified `.zshrc` to add new aliases

**Generated message**:
```
feat(zsh): 添加常用命令别名
```

### Example 2: English commits without scope

**Recent commits**:
```
Add user authentication
Fix database connection issue
Update README documentation
```

**Changes**: Added input validation to user form

**Generated message**:
```
feat: add input validation to user registration form
```

### Example 3: Mixed changes requiring detailed message

**Changes**: Refactored authentication module, updated tests, and fixed a race condition

**Generated message**:
```
refactor(auth): 重构认证模块并修复竞态条件

1. 【修改背景】
- 原有认证流程存在竞态条件，导致偶发性登录失败

2. 【修改内容】
- 重构 AuthService 类，使用互斥锁保护共享状态
- 更新相关单元测试
- 优化错误处理逻辑

3. 【影响与风险】
- 修复了竞态条件，提升系统稳定性
- 向后兼容，无破坏性变更
```

## Important Notes

1. **Never commit automatically** - Always present the message and ask for confirmation
2. **Match existing style** - Language, format, and conventions must align with the repository's history
3. **Be concise** - Favor short, clear messages over verbose explanations
4. **Focus on intent** - Explain WHY the change was made, not just WHAT changed
5. **Use appropriate type** - Choose the correct commit type based on the nature of the change

## Error Handling

If no changes are staged:
- Inform the user: "No staged changes found. Please stage your changes with `git add` first."
- Optionally show unstaged changes and ask if they should be staged

If commit history is unavailable or empty:
- Default to English
- Use conventional commits format
- Ask user for language preference
