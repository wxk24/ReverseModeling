$host.UI.RawUI.WindowTitle = "Compress folders"

do {

  Write-Host ""
  Write-Host "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"

  $files = Get-ChildItem -Directory

  Write-Host "Feature: Compress folders" -ForegroundColor Green
  Write-Host "`t1. Enter the specific number key to compress the folder"
  Write-Host "`t2. Enter the enter key to compress all folders"
  Write-Host ""

  [int]$count = 0
  $names = @()
  foreach ($file in $files) {
    $count++;
    Write-Host $count". " -ForegroundColor Green -NoNewline
    $file_name = Split-Path -Path $file -Leaf
    $names += $file_name
    Write-Host $file_name
  }
  Write-Host ""

  if ($count -lt 1) {
      Write-Host "No folders !" -ForegroundColor Yellow
      return
  }

  Write-Host "Enter the folder number " -NoNewline
  Write-Host "[1-$count]" -NoNewline -ForegroundColor Green
  Write-Host " to compress itself, or directly press the " -NoNewline
  Write-Host "enter" -NoNewline -ForegroundColor Green
  $choice = Read-Host " key to compress all folders"

  if ($choice -eq "") {
    Write-Host "Start compressing all folders listed ..." -ForegroundColor Green
    foreach($file in $files) {
      $name = Split-Path -Path $file -Leaf
      & 7z a "$name.7z" "$name" -aoa
    }
    Write-Host "Finished." -ForegroundColor Green
    return
  }

  $index = $choice-1
  Write-Host "Start compressing $($names[$index]) ..." -ForegroundColor Green
  & 7z a "$($names[$index]).7z" "$($names[$index])" -aoa
  Write-Host "Finished." -ForegroundColor Green

  $continue = Read-Host "Continue? (y/n)"

} while($continue -eq 'y')