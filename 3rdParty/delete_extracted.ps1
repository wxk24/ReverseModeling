Get-ChildItem -Path . -Directory | Remove-Item -Recurse -Force
Get-ChildItem -Path . -Filter "*.props" | Remove-Item -Recurse -Force
