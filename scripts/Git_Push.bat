:: Git_PushDirectly.bat
@echo off
cd ..
for /f "delims=" %%i in ('git branch --show-current') do set "curr_branch=%%i"
echo current branch: %curr_branch%
git status
git add .
set /P msg=Input your commit: 
git commit -m "%msg%" 
git fetch origin dev:dev
git rebase dev
git checkout dev
git merge %curr_branch%
git push
git checkout %curr_branch%
cd scripts
choice /C YN /N /T 3 /D Y >nul
