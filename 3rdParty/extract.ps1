$host.UI.RawUI.WindowTitle = "Extract compressed files"

do {

  Write-Host ""
  Write-Host "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"

  $files = Get-ChildItem -Path .\* -Include "*.zip", "*.7z", "*.rar"

  Write-Host "Feature: Extract compressed files" -ForegroundColor Green
  Write-Host "`t1. Enter the specific number key to extract the corresponding compressed file"
  Write-Host "`t2. Enter the enter key to extract all compressed files"
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
      Write-Host "No compressed files !" -ForegroundColor Yellow
      return
  }

  Write-Host "Enter the file number " -NoNewline
  Write-Host "[1-$count]" -NoNewline -ForegroundColor Green
  Write-Host " to decompress itself, or directly press the " -NoNewline
  Write-Host "enter" -NoNewline -ForegroundColor Green
  $choice = Read-Host " key to decompress all files"

  if ($choice -eq "") {
    Write-Host "Start decompressing all files listed ..." -ForegroundColor Green
    foreach($file in $files) {
      & 7z x $file -aoa
    }
    Write-Host "Finished." -ForegroundColor Green
    return
  }

  $index = $choice-1
  Write-Host "Start decompressing $($names[$index]) ..." -ForegroundColor Green
  & 7z x $files[$index] -aoa
  Write-Host "Finished." -ForegroundColor Green

  $continue = Read-Host "Continue? (y/n)"

} while($continue -eq 'y')
