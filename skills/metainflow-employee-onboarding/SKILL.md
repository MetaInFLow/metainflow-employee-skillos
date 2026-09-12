---
name: metainflow-employee-onboarding
version: "0.3.0"
description: 为 MetaInFlow 新员工根据开发部飞书 Base、岗位、业务线和任务生成最小必要依赖申请单。用于员工入职、换机或新增工作方向。
intent: 读取团队事实源和岗位 Mapping，输出 employee_onboarding_request；不执行账号授权，不输出密码、Token、API Key 或私钥。
type: workflow
---

# Purpose

让员工获得开始工作所需的最小能力，并把岗位权限与项目权限分开。申请单必须告诉负责人每项依赖的开通入口、前置依赖、执行人和验证方式。

# Interaction contract

每轮回复开头必须使用以下固定格式，不能只给一张静态清单：

```text
当前大阶段：<阶段编号>/<阶段总数> <阶段名称>
阶段目标：<本阶段完成后得到什么>
已完成：<已通过的事项>
当前动作：<本轮正在检查或等待什么>
完成标准：<什么证据代表本阶段完成>
下一步：<完成当前动作后唯一要做的事>
```

一次只推进一个大阶段。员工 Skill 的目标是让员工一次性完成所有自助动作，只向负责人 Handoff 一次；不要把每个账号拆成一轮对话。

# Onboarding stages

```text
S1 员工自助准备
→ S2 一次性 Handoff 给负责人
→ S3 等待负责人办理
→ S4 员工最终验证
```

S1 员工一次性完成飞书注册、开发部登记、GitHub 邮箱提交、本地工具安装和基础自检。
S2 输出完整申请单和员工已完成事项，交给负责人 Skill。
S3 负责人办理组织权限、GitHub、Feynman，并一次性通知员工。
S4 员工完成飞书 CLI 登录、Feynman/Codex 最小请求和目标仓库验证。

# When to use

员工本人或负责人提出入职、换机、转岗或新增开发方向时使用。

# When not to use

不要用本 Skill 直接开通 GitHub、飞书、Feynman、VPN、SSH 或云平台权限；不要把项目资料自动视为员工默认依赖。

# Required inputs

- 姓名、手机号或飞书账号
- GitHub 账号邮箱
- 岗位
- 直属负责人
- 当前业务线或工作方向，可为空
- 当前项目/任务，可为空

# Employee setup entrypoints

员工必须按以下顺序完成自助配置：

1. 使用 [Metainflow-INF 员工邀请链接](https://metainflow-inf-fde.feishu.cn/invite/member/SVMCoTs7pDU) 注册并加入飞书组织。
   - 中国大陆手机号可直接通过链接加入。
   - 其他用户使用邀请码 `DVBQPBKG` 或联系管理员。
2. 在入职申请单中填写 GitHub 账号邮箱。负责人使用该邮箱通过 GitHub/`gh` 邀请加入组织和指定仓库团队。
3. 飞书账号加入组织后，完成飞书基础配置和管理员/资源 Owner 授权。
4. 以提问方式收集个人信息，由 Skill 使用 `inf-feishu` profile 通过 CLI 写入人事 Base；员工不手动编辑 Base，工资字段跳过，由负责人填写。
5. 检查本机 Feishu profiles，已有 profile 时不覆盖；本次命令显式使用 `--profile inf-feishu`。
6. 创建绝对路径 `~/.metainflow` 运行时目录和 `~/MetaInFlow` 工作区。
7. 登记完成后再运行 `lark-cli` 读取开发部事实源。

员工侧固定顺序：

```text
注册飞书
→ 配置飞书与基础协同
→ CLI 写入人事 Base
→ 创建 `~/.metainflow` 和 `~/MetaInFlow`
→ 提交 GitHub 邮箱
→ 负责人开通 GitHub / Feynman
→ 员工完成本地工具和模型验证
```

# Dependency chain

基础链路必须按顺序理解：

```text
飞书企业账号
→ 飞书基础群/文档/Base权限
→ 飞书 CLI profile + user OAuth + required scopes
→ GitHub个人账号与组织邀请
→ Feynman个人API使用权限
→ 业务线/项目仓库与测试环境
→ 服务器 SSH（仅承担服务器任务时追加）
```

`lark-cli` 只能操作飞书开放能力，不能替代 GitHub、Feynman、SSH、云控制台或客户平台的开通流程。GitHub 由 `gh` 负责；Codex 由员工自行安装；VPN 不纳入公司入职配置。

# Local write boundary

所有写本地文件的工具动作必须经过 Hook。允许写入展开后的 `~/.metainflow` 运行时目录和 `~/MetaInFlow` 工作区及子目录；其他路径默认阻止。

# Method

1. 先确认员工已经通过 Metainflow-INF 邀请链接加入组织，并收集 GitHub 账号邮箱。
2. 读取 `13-团队成员`，确认员工在岗并读取角色；若尚未登记，提示员工先完成开发部工作区登记。
3. 读取 `10-业务线`、`12-项目`、`01-需求池`、`02-子任务`，只保留当前启用且与员工相关的上下文。
4. 按 `references/role-mapping.yaml` 匹配基础、岗位、业务线和项目依赖。
5. 去重，并排除 Mapping 中的默认禁止权限。
6. 对 Feynman 管理、SSH、云控制台、生产数据等高风险依赖加入负责人审批项。
7. 为每项依赖补齐 `provisioning` 信息：入口、前置依赖、执行人、CLI 能力和人工降级路径。
8. 生成符合 `references/protocols.md` 的 `employee_onboarding_request`。

# Output

同时输出：

- 给员工看的简版依赖清单。
- 给负责人使用的完整 YAML 申请单。

申请单生成后，必须提示一次性 Handoff：

```text
当前大阶段：S2/4 一次性 Handoff 给负责人
下一步：将完整申请单交给直属负责人；负责人完成办理后只需通知你一次。
```

没有业务线或项目时，`business_line_based` 和 `project_based` 必须为空数组。

# Checks

- 角色必须能映射到至少一个基础依赖，否则标记 `BLOCKED`。
- 没有 GitHub 账号邮箱时，申请单不得进入负责人办理阶段。
- 人事 Base 登记回读失败，或 `~/.metainflow`、`~/MetaInFlow` 创建失败时，状态为 `BLOCKED`。
- 每项依赖必须包含 `source_mapping`、`reason` 和 `acceptance_check`。
- 每项依赖必须说明 `provisioning.entrypoint`、`provisioning.prerequisites`、`provisioning.executor` 和 `provisioning.cli_status`。
- `credentials_included` 永远为 `false`。
- 普通开发岗位不得默认申请生产 SSH、Sub2api 管理、NewAPI 管理或云控制台。

# Failure modes

- 员工不存在或已离职：停止并要求负责人先修正 `13-团队成员`。
- 岗位无 Mapping：输出缺失 Mapping，不自行猜测权限。
- 项目与任务冲突：以当前 `02-子任务` 的负责人和状态为准，提交负责人复核。
