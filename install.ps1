<#
.SYNOPSIS
  大客户开发 skill 家族一键安装脚本。

.DESCRIPTION
  把家族 7 个 skill 文件夹（00-key-account-dev ~ 06-kehujingying）复制到指定的 agent skills 目录。
  - 安装前先把家族根目录 10-家族共享协议.md（母本）同步到 00-key-account-dev\reference\10-家族共享协议.md
    （运行时副本，剥离母本顶部"文件定位"块、保留副本自身定位块），同步失败中止安装；
  - 逐 skill 校验 frontmatter name 与文件夹名一致，输出安装报告；
  - 目标目录已存在同名文件夹时提示覆盖确认（-Force 跳过确认直接覆盖）。

.PARAMETER TargetDir
  目标 skills 目录。默认 $HOME\.claude\skills。

.PARAMETER Force
  跳过覆盖确认，直接覆盖已存在的同名文件夹。

.EXAMPLE
  powershell -ExecutionPolicy Bypass -File .\install.ps1
  powershell -ExecutionPolicy Bypass -File .\install.ps1 -TargetDir "D:\skills" -Force
#>
[CmdletBinding()]
param(
    [string]$TargetDir = (Join-Path $HOME ".claude\skills"),
    [switch]$Force
)

$ErrorActionPreference = "Stop"
$sourceRoot = $PSScriptRoot
$familyName = "大客户开发 skill 家族"
$skills = @(
    "00-key-account-dev",
    "01-shangji-pinggu",
    "02-juece-poyi",
    "03-jiejue-fangan",
    "04-biaozhun-yindao",
    "05-xinren-gonggu",
    "06-kehujingying"
)

Write-Host "== $familyName 安装 ==" -ForegroundColor Cyan
Write-Host "源目录：$sourceRoot"
Write-Host "目标：$TargetDir`n"

# --- 1. 校验源目录 ---
$missing = @()
foreach ($s in $skills) {
    if (-not (Test-Path (Join-Path $sourceRoot $s))) { $missing += $s }
}
if ($missing.Count -gt 0) {
    Write-Host "[中止] 源目录缺少以下 skill 文件夹：" -ForegroundColor Red
    $missing | ForEach-Object { Write-Host "  - $_" }
    Write-Host "请确认脚本位于家族根目录（与 7 个 skill 文件夹同级）后重试。"
    exit 1
}

# --- 2. 协议同步：家族根目录母本 → 总控路由运行时副本 ---
# 母本（10-家族共享协议.md，家族根目录）为唯一权威源；剥离其顶部"文件定位"引用块后，
# 与运行时副本顶部保留的定位块拼接，覆盖写入 00-key-account-dev\reference\10-家族共享协议.md。
# 同步失败即中止安装。
$syncStatus = "OK"; $syncDetail = ""
try {
    $masterPath  = Join-Path $sourceRoot "10-家族共享协议.md"
    $runtimePath = Join-Path $sourceRoot "00-key-account-dev\reference\10-家族共享协议.md"
    if (-not (Test-Path $masterPath)) { throw "母本缺失：10-家族共享协议.md（应位于家族根目录）" }
    if (-not (Test-Path $runtimePath)) { throw "运行时副本缺失：00-key-account-dev\reference\10-家族共享协议.md" }

    $masterRaw = Get-Content $masterPath -Raw -Encoding UTF8
    # 剥离母本顶部"文件定位"引用块（首个以 > **文件定位** 开头的引用段），正文从 "# 10 ·" 标题起
    $masterBody = $masterRaw -replace '(?s)^\s*> \*\*文件定位\*\*.*?(?=\r?\n# )', ''
    $masterBody = $masterBody.TrimStart()

    # 运行时副本顶部定位块：已存在则原样保留，不存在则写入默认文案
    $defaultRuntimeHeader = @'
> **文件定位**：本文件是家族共享协议母本（家族根目录 `10-家族共享协议.md`）的**运行时同步副本**，随总控路由（00-key-account-dev）安装分发。**编辑请改家族根目录母本**，再由 install.ps1 同步覆盖本文件；skill 内引用一律使用统一话术的三级回退链，不直接写死单一路径。

'@
    $runtimeHeader = $defaultRuntimeHeader
    $runtimeRaw = Get-Content $runtimePath -Raw -Encoding UTF8
    if ($runtimeRaw -match '(?s)^> \*\*文件定位\*\*.*?(?=\r?\n# )') {
        $runtimeHeader = $Matches[0] + "`n"
    }

    Set-Content -Path $runtimePath -Value ($runtimeHeader + $masterBody) -Encoding UTF8 -NoNewline
} catch {
    $syncStatus = "FAIL"; $syncDetail = $_.Exception.Message
}

Write-Host "--- 协议同步 ---" -ForegroundColor Yellow
$syncLine = "  协议同步：[$syncStatus] 家族根目录 10-家族共享协议.md → 00-key-account-dev\reference\10-家族共享协议.md"
if ($syncDetail) { $syncLine += "  -- $syncDetail" }
if ($syncStatus -eq "OK") { Write-Host $syncLine -ForegroundColor Green } else { Write-Host $syncLine -ForegroundColor Red }
if ($syncStatus -ne "OK") {
    Write-Host "[中止] 协议同步失败，请先修复后再安装。" -ForegroundColor Red
    exit 1
}

# --- 3. 逐 skill frontmatter 校验（name = 文件夹名） ---
$checkResults = @()
foreach ($s in $skills) {
    $skillMd = Join-Path (Join-Path $sourceRoot $s) "SKILL.md"
    $status = "OK"; $detail = ""
    if (-not (Test-Path $skillMd)) {
        $status = "FAIL"; $detail = "缺少 SKILL.md"
    } else {
        $content = Get-Content $skillMd -Raw -Encoding UTF8
        if ($content -match '(?m)^name:\s*(\S+)') {
            if ($Matches[1] -ne $s) { $status = "FAIL"; $detail = "frontmatter name='$($Matches[1])' 与文件夹名不一致" }
        } else {
            $status = "FAIL"; $detail = "frontmatter 缺少 name 字段"
        }
    }
    $checkResults += [PSCustomObject]@{ Skill = $s; Status = $status; Detail = $detail }
}

Write-Host "--- frontmatter 校验 ---" -ForegroundColor Yellow
foreach ($r in $checkResults) {
    $color = if ($r.Status -eq "OK") { "Green" } else { "Red" }
    $line = "  [$($r.Status)] $($r.Skill)"
    if ($r.Detail) { $line += "  -- $($r.Detail)" }
    Write-Host $line -ForegroundColor $color
}
$failed = @($checkResults | Where-Object { $_.Status -ne "OK" })
if ($failed.Count -gt 0) {
    Write-Host "`n[中止] $($failed.Count) 个 skill 校验未通过，请先修复上述问题再安装。" -ForegroundColor Red
    exit 1
}

# --- 4. 覆盖确认 ---
$conflicts = @($skills | Where-Object { Test-Path (Join-Path $TargetDir $_) })
if ($conflicts.Count -gt 0 -and -not $Force) {
    Write-Host "`n目标目录已存在以下同名 skill：" -ForegroundColor Yellow
    $conflicts | ForEach-Object { Write-Host "  - $_" }
    $answer = Read-Host "`n覆盖安装？输入 y 确认，其他键中止"
    if ($answer -ne "y") { Write-Host "已取消，未做任何修改。"; exit 0 }
}

# --- 5. 复制安装 ---
if (-not (Test-Path $TargetDir)) { New-Item -ItemType Directory -Path $TargetDir -Force | Out-Null }
$installed = 0; $errors = @()
foreach ($s in $skills) {
    try {
        $src = Join-Path $sourceRoot $s
        $dst = Join-Path $TargetDir $s
        if (Test-Path $dst) { Remove-Item $dst -Recurse -Force }
        Copy-Item $src $dst -Recurse -Force
        $installed++
        Write-Host "  [已安装] $s" -ForegroundColor Green
    } catch {
        $errors += "$s -- $($_.Exception.Message)"
        Write-Host "  [失败] $s -- $($_.Exception.Message)" -ForegroundColor Red
    }
}

Write-Host "`n--- 安装报告 ---" -ForegroundColor Yellow
Write-Host "协议同步：$syncStatus"
Write-Host "成功：$installed / $($skills.Count)；失败：$($errors.Count)"
if ($installed -eq $skills.Count) {
    Write-Host "全部安装完成。skills 目录：$TargetDir" -ForegroundColor Green
    exit 0
} else {
    exit 1
}
