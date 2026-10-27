# 大客户开发 Skill 家族

![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)

一套面向大客户（B2B 复杂销售）场景的 agent skill 家族：从一个商机进来到交付后经营，覆盖 **商机评估 → 决策链破译 → 解决方案设计 → 标准引导 → 信任巩固 → 客户经营** 六个阶段，外加一个总控路由（Gateway）负责判题、调度与体检复盘。家族强调"工具表格驱动 + 推断式采集 + 每句结论配大白话"，让销售过程可复盘、可复制。

> **English summary**
>
> A family of 7 Agent Skills for B2B enterprise / key-account (complex) sales, covering the full pipeline from opportunity qualification to post-delivery account growth: opportunity assessment, decision-chain mapping, solution design, bid-standard shaping, trust consolidation, and account management — plus a gateway skill that routes, orchestrates, and reviews the whole process. Each skill is a self-contained folder (SKILL.md with YAML frontmatter + a reference/ directory), installed by copying into your agent's skills directory. Open source under the MIT License.

## 家族成员一览（7 个 skill）

| code_name | 环节名 | 一句话定位 |
| --- | --- | --- |
| `00-key-account-dev` | 总控路由（Gateway） | 判题、阶段定位、上下文包组装、体检复盘、档案管理——说不清该找哪个环节时的第一入口 |
| `01-shangji-pinggu` | 商机评估 | 项目打分、客户分级、定投入打法——"这单值不值得做、投多少" |
| `02-juece-poyi` | 决策链破译 | 组织架构、权力地图、关键人五维画像——"谁拍板、谁支持谁反对、从哪切入" |
| `03-jiejue-fangan` | 解决方案设计 | 需求探挖、价值地图、方案汇报——"把方案对着客户高层 KPI 算账讲" |
| `04-biaozhun-yindao` | 标准引导 | 评标标准攻防、参数引导——"标书定稿前的攻防布局" |
| `05-xinren-gonggu` | 信任巩固 | 签约前顾虑处理、临门一脚——"客户快签约时犹豫了怎么办" |
| `06-kehujingying` | 客户经营 | 交付期经营、老客挖潜、定期体检——"交付之后怎么干出复购和转介绍" |

按场景找 skill（"你需要它当……"）：

- 你的客户组织很复杂、不知道谁拍板 → `02-juece-poyi` 决策链破译
- 手上好几个商机都说是重点、不知道先打哪个 → `01-shangji-pinggu` 商机评估（或先找 `00-key-account-dev` 判题）
- 方案不错但客户嫌贵、下周要给一把手汇报 → `03-jiejue-fangan` 解决方案设计
- 标书参数一看就是照着对手写的 → `04-biaozhun-yindao` 标准引导
- 客户临门一脚犹豫了、拖延签约 → `05-xinren-gonggu` 信任巩固
- 项目交付了、想从老客户身上长出新业务 → `06-kehujingying` 客户经营
- 这单丢了想复盘、或说不清问题属于哪一环节 → `00-key-account-dev` 总控路由

## 快速上手（Quick Start）

安装后直接用大白话向你的 agent 描述手上遇到的事即可，不需要记任何命令。以商机评估（`01-shangji-pinggu`）为例：

**你说：**

> 听说 S 集团一个厂要改造产线，预算千把万，帮我评估下这单值不值得做。

**skill 会产出（要点）：**

- **评分结论**：客户价值分级（A/B/C/D 级）+ 项目综合评分，给出"项目推进／深入评估／暂缓／放弃"四选一立项建议；
- **定位九宫格**：按"地盘 × 开局"落入九种策略之一，定出本单攻坚打法；
- **策略建议**：分阶段作战计划与资源投入建议（POC 验证、高层拜访等），每条结论附依据与置信度。

其他环节同理：带着"谁拍板""方案嫌贵""标书不利""签前犹豫""老客户挖潜"等真实问题开口即可，gateway（`00-key-account-dev`）会自动判题接力到对应 skill。

## 目录结构

家族根目录（每个 skill 文件夹内含 `SKILL.md` + `reference/` 参考资料目录）：

```text
key-account-dev-skills/
├── 00-key-account-dev/       # 总控路由（Gateway）
├── 01-shangji-pinggu/        # 商机评估
├── 02-juece-poyi/            # 决策链破译
├── 03-jiejue-fangan/         # 解决方案设计
├── 04-biaozhun-yindao/       # 标准引导
├── 05-xinren-gonggu/         # 信任巩固
├── 06-kehujingying/          # 客户经营
├── 10-家族共享协议.md         # 家族共享协议母本
├── install.ps1               # Windows 一键安装脚本
├── LICENSE                   # MIT
└── README.md
```

## 兼容性与平台说明

本家族适用于支持 **Agent Skills 规范**（SKILL.md + YAML frontmatter）的 agent，例如 Claude Code、Kimi Code、Cursor 等；任何按该规范加载 skills 目录的 agent 均可使用。各 skill 对数据的需求走"声明需求 + 环境自行解析"协议，不绑定特定记忆或工具实现。

**注意**：`install.ps1` 一键脚本仅支持 **Windows（PowerShell）**；macOS / Linux 用户请手动复制 skill 文件夹到 agent 的 skills 目录，效果等同。

## 安装方式

### 方式一：整个家族安装（推荐）

把本目录下 7 个 skill 文件夹（`00-key-account-dev` ~ `06-kehujingying`）整体复制到你的 agent skills 目录。Windows 下可运行一键安装脚本（默认目标 `$HOME\.claude\skills`，可用 `-TargetDir` 指定其他目录）：

```powershell
# 在家族根目录执行
powershell -ExecutionPolicy Bypass -File .\install.ps1
powershell -ExecutionPolicy Bypass -File .\install.ps1 -TargetDir "D:\your\skills\dir"
powershell -ExecutionPolicy Bypass -File .\install.ps1 -Force   # 跳过覆盖确认
```

脚本安装前会先把家族根目录的共享协议母本 `10-家族共享协议.md` 同步到 `00-key-account-dev\reference\10-家族共享协议.md`（运行时副本，详见下文"家族共享协议"一节），再逐 skill 校验 frontmatter `name` 与文件夹名一致，并输出安装报告。

手动安装亦可：直接复制 7 个文件夹到 skills 目录，保持文件夹名不变（frontmatter `name` 必须与文件夹名一致，含数字前缀）。

### 方式二：单 skill 独立安装

任意一个 skill 文件夹都可单独复制到 skills 目录独立使用。每个 skill 自带内置兜底（降级链、档案模板、共享协议要点），单独安装时不依赖家族其他成员也能完成任务；专用 agent 环境下整族安装可获得免判题、免重问、自动接力等增益。

## 使用模式

- **Gateway 模式（整族安装）**：所有会话经 `00-key-account-dev` 判题后接力到对应阶段 skill。00 负责组装上下文包、防重复提问、跨会话缺口继承、收尾落档督办。适合长期、多客户、多商机的使用场景。
- **独立模式（单 skill 安装）**：用户直接带着具体问题调用某个阶段 skill，该 skill 自行做环境自检、逐格采集、产出与落档。适合只关心某一环节的场景。

两种模式下，交互机械协议、输出规范、落档纪律、外部输入安全护栏等家族共享协议均默认生效。

## 家族共享协议

7 个 skill 共同遵守的默认交互与输出协议定义在 `00-key-account-dev\reference\10-家族共享协议.md`（三条铁律、12 条交互机械协议、输出通用规范、落档纪律、数据供给降级链、外部输入安全、单轮提问上限）。各 SKILL.md 只写本环节特有的领域逻辑，共享规则单一事实源、不重复。

**协议母本与同步**：共享协议的**母本**（canonical source）位于家族根目录 `10-家族共享协议.md`，家族所有 skill 的规则改动在此先行修改；`00-key-account-dev\reference\10-家族共享协议.md` 是随总控路由（00-key-account-dev）安装分发的运行时同步副本，由 install.ps1 在安装时自动从母本同步覆盖（安装报告会输出"协议同步：OK/FAIL"，FAIL 中止安装）。skill 内引用统一使用三级回退链：一级读家族根目录母本 → 二级读已安装环境的总控路由运行时副本 → 三级按各 skill 头部"独立模式内置兜底"块执行。手动整族复制安装（不走 install.ps1）的用户需自行保证两处一致，或单独运行 install.ps1 的同步逻辑后再复制。

## 版本

| code_name | 版本 |
| --- | --- |
| `00-key-account-dev` | 1.2.0 |
| `01-shangji-pinggu` | 1.1.0 |
| `02-juece-poyi` | 1.0.0 |
| `03-jiejue-fangan` | 1.1.0 |
| `04-biaozhun-yindao` | 1.0.0 |
| `05-xinren-gonggu` | 1.0.0 |
| `06-kehujingying` | 1.1.0 |

## 免责声明

本家族所有案例与示例中涉及的公司、集团与人名（如 A 公司、S 集团、张斌、李峰等）均为虚构，仅用于方法论演示与演练，不指向任何真实的企业、组织或个人；如有雷同，纯属巧合。

## License 与署名

- License：MIT（见根目录 LICENSE 文件；各 skill frontmatter 已同步声明）
- 作者：tomoshaw
- 来源：大客户开发 skill 家族
