# Key Account Development Skill Family

[English](README.md) | [简体中文](README.zh-CN.md)

![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)

A family of agent skills for key-account (B2B complex) sales: from the moment an opportunity comes in through post-delivery account growth, it covers six stages — **Opportunity Assessment → Decision-Chain Mapping → Solution Design → Bid-Standard Shaping → Trust Consolidation → Account Management** — plus a Gateway skill that handles problem diagnosis, orchestration, and review/retrospective. The family emphasizes "tool-and-table driven workflows + inferential data collection + every conclusion explained in plain language", making the sales process reviewable and replicable.

> A family of 7 Agent Skills for B2B enterprise / key-account (complex) sales, covering the full pipeline from opportunity qualification to post-delivery account growth: opportunity assessment, decision-chain mapping, solution design, bid-standard shaping, trust consolidation, and account management — plus a gateway skill that routes, orchestrates, and reviews the whole process. Each skill is a self-contained folder (SKILL.md with YAML frontmatter + a reference/ directory), installed by copying into your agent's skills directory. Open source under the MIT License.

## Family Members (7 Skills)

| code_name | Stage | One-line positioning |
| --- | --- | --- |
| `00-key-account-dev` | Gateway | Problem diagnosis, stage positioning, context-package assembly, health-check retrospectives, profile management — the first entry point when you're not sure which stage skill to use |
| `01-opportunity-assessment` | Opportunity Assessment | Project scoring, customer grading, and investment strategy — "Is this deal worth pursuing, and how much should we invest?" |
| `02-decision-chain-mapping` | Decision-Chain Mapping | Org structure, power maps, five-dimension profiles of key people — "Who makes the call, who supports or opposes, and where do we break in?" |
| `03-solution-design` | Solution Design | Needs discovery, value mapping, solution presentations — "Pitch the solution against the customer's executive KPIs, in numbers" |
| `04-bid-standard-shaping` | Bid-Standard Shaping | Offense and defense on bid-evaluation criteria, parameter steering — "The attack-and-defense layout before the bid document is finalized" |
| `05-trust-consolidation` | Trust Consolidation | Pre-signing objection handling and closing the deal — "What to do when the customer hesitates right before signing" |
| `06-account-management` | Account Management | Delivery-phase account growth, mining existing customers, periodic health checks — "How to generate repurchases and referrals after delivery" |

Find a skill by scenario ("when you need it as…"):

- Your customer's organization is complex and you don't know who makes the call → `02-decision-chain-mapping`
- Several opportunities are all labeled "top priority" and you don't know which to attack first → `01-opportunity-assessment` (or start with `00-key-account-dev` for diagnosis)
- The solution looks good but the customer says it's too expensive, and you present to the top executive next week → `03-solution-design`
- The bid's technical parameters are clearly written around a competitor → `04-bid-standard-shaping`
- The customer hesitates at the last mile and keeps delaying signing → `05-trust-consolidation`
- The project has been delivered and you want to grow new business from an existing customer → `06-account-management`
- You lost the deal and want a retrospective, or you can't tell which stage the problem belongs to → `00-key-account-dev`

## Quick Start

After installation, just describe your situation to your agent in plain language — no commands to memorize. Take opportunity assessment (`01-opportunity-assessment`) as an example:

**You say:**

> I heard one of S Group's factories is planning a production-line upgrade with a budget of around ten million. Help me assess whether this deal is worth pursuing.

**The skill produces (key outputs):**

- **Scoring conclusion**: customer value grade (A/B/C/D) + composite project score, with a four-way go/no-go recommendation ("proceed / deep-dive assessment / hold / walk away");
- **Nine-grid positioning**: maps "territory × opening position" into one of nine strategies to set the attack plan for this deal;
- **Strategy recommendations**: a phased battle plan with resource-investment advice (POC validation, executive visits, etc.), with evidence and confidence attached to every conclusion.

The same applies to other stages: just start with real problems like "who makes the call", "the solution is seen as too expensive", "the bid parameters are against us", "hesitation before signing", or "mining an existing customer" — the gateway (`00-key-account-dev`) will automatically diagnose the problem and hand off to the right skill.

## Directory Structure

Family root (each skill folder contains a `SKILL.md` + a `reference/` directory):

```text
key-account-dev-skills/
├── 00-key-account-dev/            # Gateway
├── 01-opportunity-assessment/     # Opportunity assessment
├── 02-decision-chain-mapping/     # Decision-chain mapping
├── 03-solution-design/            # Solution design
├── 04-bid-standard-shaping/       # Bid-standard shaping
├── 05-trust-consolidation/        # Trust consolidation
├── 06-account-management/         # Account management
├── 10-家族共享协议.md              # Shared-protocol master copy
├── install.ps1                    # Windows one-click install script
├── LICENSE                        # MIT
└── README.md
```

## Compatibility & Platform Notes

This family works with any agent that supports the **Agent Skills specification** (SKILL.md + YAML frontmatter), such as Claude Code, Kimi Code, Cursor, etc.; any agent that loads a skills directory per that specification can use it. Each skill's data requirements follow a "declare requirements + let the environment resolve them" protocol, and do not bind to any specific memory or tool implementation.

**Note**: the `install.ps1` one-click script only supports **Windows (PowerShell)**; macOS / Linux users should manually copy the skill folders into their agent's skills directory — the result is equivalent.

## Installation

### Option 1: Install the Whole Family (Recommended)

Copy all 7 skill folders (`00-key-account-dev` ~ `06-account-management`) into your agent's skills directory. On Windows you can run the one-click install script (default target `$HOME\.claude\skills`; use `-TargetDir` to specify another directory):

```powershell
# Run from the family root directory
powershell -ExecutionPolicy Bypass -File .\install.ps1
powershell -ExecutionPolicy Bypass -File .\install.ps1 -TargetDir "D:\your\skills\dir"
powershell -ExecutionPolicy Bypass -File .\install.ps1 -Force   # Skip overwrite confirmation
```

Before installing, the script syncs the shared-protocol master copy (`10-家族共享协议.md`) from the family root to `00-key-account-dev\reference\10-家族共享协议.md` (the runtime copy; see the "Family Shared Protocol" section below), then validates each skill's frontmatter `name` against its folder name, and prints an installation report.

Manual installation also works: simply copy the 7 folders into the skills directory, keeping folder names unchanged (the frontmatter `name` must match the folder name, including the numeric prefix).

### Option 2: Install a Single Skill Standalone

Any single skill folder can be copied into the skills directory and used on its own. Each skill ships with built-in fallbacks (degradation chain, profile templates, shared-protocol key points), so it can complete its task without the rest of the family when installed alone; installing the whole family in a dedicated-agent environment gains extra benefits such as no manual diagnosis, no repeated questioning, and automatic handoffs.

## Usage Modes

- **Gateway mode (full-family install)**: every session is first diagnosed by `00-key-account-dev`, which then hands off to the appropriate stage skill. The 00 skill is responsible for assembling context packages, preventing repeated questions, inheriting gaps across sessions, and supervising closing/profile filing. Best for long-term, multi-customer, multi-opportunity usage.
- **Standalone mode (single-skill install)**: the user invokes a stage skill directly with a specific problem, and that skill performs its own environment self-check, cell-by-cell data collection, output generation, and profile filing. Best when you only care about one stage.

In both modes, the Family Shared Protocol — interaction mechanics, output specifications, profile-filing discipline, external-input safety guardrails, etc. — is in effect by default.

## Family Shared Protocol

The default interaction and output protocol shared by all 7 skills is defined in `00-key-account-dev\reference\10-家族共享协议.md` (three iron rules, 12 interaction-mechanics clauses, general output specifications, profile-filing discipline, data-provision degradation chain, external-input safety, single-round question cap). Each SKILL.md only writes the domain logic specific to its own stage; shared rules have a single source of truth and are not duplicated.

**Protocol master copy & sync**: the **master copy** (canonical source) of the shared protocol lives at the family root as `10-家族共享协议.md`; all rule changes for the family are made there first. `00-key-account-dev\reference\10-家族共享协议.md` is the runtime synced copy distributed with the gateway skill (`00-key-account-dev`), automatically overwritten from the master by install.ps1 at install time (the installation report prints a "protocol sync: OK/FAIL" line; FAIL aborts the installation). References inside skills use a unified three-level fallback chain: level 1 reads the family-root master copy → level 2 reads the installed gateway's runtime copy → level 3 executes the "standalone-mode built-in fallback" block at the head of each skill. Users who install the full family by manual copy (without install.ps1) must keep the two copies consistent themselves, or run install.ps1's sync logic alone before copying.

## Versions

| code_name | Version |
| --- | --- |
| `00-key-account-dev` | 1.2.0 |
| `01-opportunity-assessment` | 1.1.0 |
| `02-decision-chain-mapping` | 1.0.0 |
| `03-solution-design` | 1.1.0 |
| `04-bid-standard-shaping` | 1.0.0 |
| `05-trust-consolidation` | 1.0.0 |
| `06-account-management` | 1.1.0 |

## Disclaimer

All companies, groups, and personal names in the family's cases and examples (such as Company A, S Group, Zhang Bin, Li Feng, etc.) are fictional, used only for methodology demonstration and practice; they do not refer to any real enterprise, organization, or individual. Any resemblance is purely coincidental.

## License & Credits

- License: MIT (see the LICENSE file in the root; also declared in each skill's frontmatter)
- Author: tomoshaw
- Source: Key Account Development Skill Family
