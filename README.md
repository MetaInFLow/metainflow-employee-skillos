# INF | MetaInFlow Employee SkillOS

```text
INF
MetaInFlow 源子 AI
```

欢迎加入 MetaInFlow 源子 AI（深圳）。

这是一套帮助新员工完成入职准备、接入工作系统、建立本地工作区并开始工作的员工 SkillOS。你不需要记住复杂的系统入口，按 Skill 引导完成即可。

## 你会得到什么

- 飞书组织加入指引
- 员工基本信息提问与登记
- GitHub 账号邮箱收集
- 本地 MetaInFlow 工作区初始化
- Feishu CLI Profile 检查与切换提示
- 入职依赖申请单
- 交给负责人的标准 Handoff

## 快速开始

安装 Plugin 后运行：

```text
员工入职
```

按提示加入 MetaInflow-INF 飞书组织、回答个人信息和 GitHub 邮箱问题，并确认本地已建立 `~/MetaInFlow` 工作区。Skill 会自动通过 CLI 登记可登记的人事信息，不要求手动编辑 Base。薪资信息由负责人填写。

## 本地目录

```text
~/.metainflow/   # MetaInFlow 运行时配置与状态
~/MetaInFlow/    # 员工工作区
```

工作区建议结构：

```text
~/MetaInFlow/
├── repos/
├── skills/
├── projects/
└── notes/
```

## 安全边界

- 不在聊天、代码、日志或截图中保存密码、Token、API Key 或私钥。
- 不要求员工填写日薪、月薪、年薪或奖金。
- 不自动申请生产服务器、云控制台或客户生产数据权限。
- 本地工具写文件时，只允许写入 `~/.metainflow` 和 `~/MetaInFlow`。

## 当前版本

`0.3.0`

## License

MIT
