@echo off
REM One-click publish to GitHub + Gitee (double-click friendly)
REM Keeps ASCII-only content; UTF-8 output comes from publish.sh via bash
setlocal
set "BASE=%~dp0"

for %%P in (
  "D:\Program Files\Git\bin\bash.exe"
  "C:\Program Files\Git\bin\bash.exe"
  "D:\Program Files (x86)\Git\bin\bash.exe"
  "C:\Program Files (x86)\Git\bin\bash.exe"
) do (
  if exist %%P set "BASH=%%~P" && goto :found
)
for /f "delims=" %%B in ('where bash 2^>nul') do set "BASH=%%B" && goto :found

echo [ERROR] Git Bash not found. Install Git for Windows first.
echo Download: https://mirrors.tuna.tsinghua.edu.cn/github-release/git-for-windows/git/
pause
exit /b 1

:found
"%BASH%" -c "cd 'E:/xiangmu/classroom-behavior-detection/publish/repo' && if [ \"$1\" = \"\" ]; then MSG='docs: update'; else MSG=\"$1\"; fi; bash publish.sh \"$MSG\"" -- %1
pause
