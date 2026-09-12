# Protocols v1.0

所有协议使用 YAML。敏感信息只允许写引用位置，例如 `vault://metainflow/feynman/zhangsan`，禁止写真实值。

## employee_onboarding_request

```yaml
type: employee_onboarding_request
version: "1.0"
stage: S2
employee:
  name: ""
  feishu_account: ""
  github_email: ""
  role: ""
  manager: ""
  start_date: ""
work_context:
  business_lines: []
  projects: []
  tasks: []
dependencies:
  baseline: []
  role_based: []
  business_line_based: []
  project_based: []
excluded_by_default: []
approval_required: []
acceptance_checks: []
security:
  production_access_requested: false
  credentials_included: false
```

每项依赖：`resource`、`permission`、`source_mapping`、`reason`、`required`、`temporary`、`expires_at`、`acceptance_check`，以及：

```yaml
provisioning:
  entrypoint: ""
  prerequisites: []
  executor: ""
  cli_status: native|partial|missing
  manual_fallback: ""
```

## employee_access_result

```yaml
type: employee_access_result
version: "1.0"
stage: A1
employee:
  name: ""
  role: ""
approval:
  approver: ""
  approved_at: ""
permissions: []
verification:
  completed: []
  pending: []
  failed: []
next_actions: []
security:
  credentials_exposed: false
  production_access: false
status: pending
```
