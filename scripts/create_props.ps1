Push-Location ..

$macro = Split-Path $PWD -Leaf

# Test PropsCreate_exe.exe
if((Test-Path -Path tools/PropsCreate_exe.exe) -eq $false){
  Write-Host "Fail to find PropsCreate_exe.exe" -ForegroundColor Yellow
  Pop-Location
  return 0
}

# Test 7z
try {
    & 7z.exe -ErrorAction Stop | Out-Null
}
catch {
    Write-Warning "Fail to find '7z.exe'!"
    Write-Host -NoNewline "Please add the directory where '7z.exe'"
    Write-Host " is located to the system variable <Path> and then retry"
    Write-Host "You can download it here => https://www.7-zip.org"
	Pause
    return
}

# Find all zips
$zips = Get-ChildItem ./upload/*.zip -Name
foreach($zip in $zips) {
  # echo $zip
  $base_name = [System.IO.Path]::GetFileNameWithoutExtension($zip)
  # echo $base_name
  7z x upload\$zip -oupload\($base_name) -aoa
  .\tools\PropsCreate_exe.exe "upload\$base_name" "$macro" '"XI_USE_DLL_TARGET;%(PreprocessorDefinitions)"' "upload\$base_name.props"
  7z a upload\$zip ".\upload\$base_name.props" -aoa
}

Pop-Location
