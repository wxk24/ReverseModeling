Push-Location ..

if((Test-Path -Path 3rdParty) -eq $false) {
  Write-Host "No folder `"3rdParty`", nothing to extract" -ForegroundColor Green
  Write-Host ""
  exit
}

$folder_suffix = @{
  "Debug" = "*-win32-debug"
  "Release" = "*-win32-release"
  "x64/Debug" = "*-win64-debug"
  "x64/Release" = "*-win64-release"
}

# create folder Debug,Release
foreach($f in $folder_suffix.Keys) {
  (Test-Path -Path $f) -or (mkdir $f)
}

# Find 3rdParty dlls and copy
foreach($folder in $folder_suffix.keys) {
  $suffix = $($folder_suffix[$folder])
  Write-Host "Copy to $folder" -ForegroundColor Green
  $dirs = Get-ChildItem -Path ".\3rdParty" -Directory -Filter $suffix
  foreach($d in $dirs) {
    Write-Host "Extracting dlls from $d"
    $dlls = Get-ChildItem -Path ".\3rdParty\$d" -Recurse -Filter "*.dll" | Select-Object -ExpandProperty FullName
    foreach($dll in $dlls) {
      Copy-Item -Path $dll -Destination $folder -Force
    }
  }
  Write-Host ""
}

Pop-Location
