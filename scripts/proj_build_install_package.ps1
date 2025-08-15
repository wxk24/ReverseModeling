# check file ..\config.txt
if((Test-Path ..\config.txt) -eq $false) {
    Write-Warning "'..\config.txt' doesn't exist. " -NoNewline
    Write-Warning "Please push a new tag to the remote first."
    Pause
    return
}

# get version num
$content= Get-Content -Raw "..\config.txt"
$regex = "(?<=PROJECT_NAME=)[\-\[\w\]]+(?=`r`n)"
$project_name = [regex]::Match($content, $regex).Value
[string[]]$types = @(
    'MAJOR',
    'MINOR',
    'PATCH'
)
[int32[]]$version_num = 1, 0, 0
for($i = 0; $i -lt $types.Count; $i++) {
    $regex = "(?<=${project_name}_VERSION_$($types[$i])=)\d+(?=`r`n)"
    $version_num[$i] = [regex]::Match($content, $regex).Value
}

# get version num string
[string]$version = $version_num[0].ToString() + "." + $version_num[1].ToString() + "." + $version_num[2].ToString()

Write-Host "Start build verson: " -NoNewline
Write-Host "$version" -ForegroundColor Green

# get project name
[string[]]$slns = Get-ChildItem -Path "..\*.sln" -Name
if($slns.Count -ne 1) {
	Write-Warning "Fail to find the solution file! " -NoNewline
    Write-Warning "Please check and retry."
	Pause
	return
}

[string]$project_base_name = [System.IO.Path]::GetFileNameWithoutExtension($slns[0])
[string]$project_name = "$project_base_name.vcxproj"

Write-Host "Project base name: " -NoNewline
Write-Host "$project_base_name" -ForegroundColor Green

# test MSBuild
try {
    & MSBuild.exe -ErrorAction Stop | Out-Null
}
catch {
    Write-Warning "Fail to find 'MSBuild.exe'!"
    Write-Host -NoNewline "Please add the directory where 'MSBuild.exe'"
    Write-Host " is located to the system variable <Path> and then retry"
    Write-Host "e.g. E:\OtherApps\VS_2017_Community\IDE\MSBuild\15.0\Bin"
	Pause
    return
}

# test 7z
try {
	& 7z.exe -ErrorAction Stop | Out-Null
}
catch {
	Write-Warning "Fail to find '7z.exe'!"
    Write-Host -NoNewline "Please add the directory where '7z.exe'"
    Write-Host " is located to the system variable <Path> and then retry"
    Write-Host "e.g. E:\UserApps\apps\7zip\23.01"
	Pause
    return
}

# build project (x86|Debug)
& MSBuild.exe /m "..\$project_base_name\$project_name" `
/p:SolutionDir=..\ `
/p:Platform=x86 `
/p:Configuration=Debug `
/p:TargetExt=.dll `
/p:ConfigurationType=DynamicLibrary

# build project (x86|Release)
& MSBuild.exe /m "..\$project_base_name\$project_name" `
/p:SolutionDir=..\ `
/p:Platform=x86 `
/p:Configuration=Release `
/p:TargetExt=.dll `
/p:ConfigurationType=DynamicLibrary

# build project (x64|Debug)
& MSBuild.exe /m "..\$project_base_name\$project_name" `
/p:SolutionDir=..\ `
/p:Platform=x64 `
/p:Configuration=Debug `
/p:TargetExt=.dll `
/p:ConfigurationType=DynamicLibrary

# build project (x64|Release)
& MSBuild.exe /m "..\$project_base_name\$project_name" `
/p:SolutionDir=..\ `
/p:Platform=x64 `
/p:Configuration=Release `
/p:TargetExt=.dll `
/p:ConfigurationType=DynamicLibrary

enum DEST_TYPE {
	INCLUDE
	X86_DEBUG_BIN
	X86_DEBUG_LIB
	X86_RELEASE_BIN
	X86_RELEASE_LIB
	X64_DEBUG_BIN
	X64_DEBUG_LIB
	X64_RELEASE_BIN
	X64_RELEASE_LIB
	DOCS
	OTHERS
}

function copy-files {
	param (
		[string[]]$files,
		[string]$dest_folder,
		[DEST_TYPE[]]$dest_type
	)

	$source_prefix = ".";
	switch ($dest_type) {
		INCLUDE {
			$source_prefix = "..\src"
		}
		X86_DEBUG_BIN {
			$source_prefix = "..\Debug"
		}
		X86_DEBUG_LIB {
			$source_prefix = "..\Debug"
		}
		X86_RELEASE_BIN {
			$source_prefix = "..\Release"
		}
		X86_RELEASE_LIB {
			$source_prefix = "..\Release"
		}
		X64_DEBUG_BIN {
			$source_prefix = "..\x64\Debug"
		}
		X64_DEBUG_LIB {
			$source_prefix = "..\x64\Debug"
		}
		X64_RELEASE_BIN {
			$source_prefix = "..\x64\Release"
		}
		X64_RELEASE_LIB {
			$source_prefix = "..\x64\Release"
		}
		DOCS {
			$source_prefix = "..\docs"
		}
		OTHERS {
			$source_prefix = ".."
		}
	}

	if($files.Length -gt 0) {
		Write-Host "Copy to $dest_folder" -ForegroundColor Green
		foreach ($file in $files) {
			$dest_path = $dest_folder + "\" + $file
			$dest_dir = Split-Path $dest_path
			if(!(Test-Path $dest_dir)) {
				New-Item -ItemType Directory -Force -Path $dest_dir > $null
			}
			Copy-Item -Path $source_prefix\$file -Destination $dest_dir -Recurse -Force
			Write-Host "$file"
		}
		Write-Host ""
	}
	else {
		Write-Warning "No files to copy to $dest"
	}
}

function mk-dir($dest) {
	$exist_dir = Test-Path -Path $dest
	if($exist_dir -eq $true) {
		Remove-Item -Path "$dest\**" -Exclude ".gitkeep" -Recurse -Force
	}
	else {
		New-Item -Path "$dest" -ItemType Directory
	}
}

# get files to install
$includes = Get-ChildItem -Path "..\include" -Filter "*.h" -Name -Recurse
$dlls_win32_debug = Get-ChildItem -Path "..\Debug" -Filter "*.dll" -Name -Recurse
$libs_win32_debug = Get-ChildItem -Path "..\Debug" -Filter "*.lib" -Exclude "*UTest.lib" -Name -Recurse
$dlls_win32_release = Get-ChildItem -Path "..\Release" -Filter "*.dll" -Name -Recurse
$libs_win32_release = Get-ChildItem -Path "..\Release" -Filter "*.lib" -Exclude "*UTest.lib" -Name -Recurse
$dlls_win64_debug = Get-ChildItem -Path "..\x64\Debug" -Filter "*.dll" -Name -Recurse
$libs_win64_debug = Get-ChildItem -Path "..\x64\Debug" -Filter "*.lib" -Exclude "*UTest.lib" -Name -Recurse
$dlls_win64_release = Get-ChildItem -Path "..\x64\Release" -Filter "*.dll" -Name -Recurse
$libs_win64_release = Get-ChildItem -Path "..\x64\Release" -Filter "*.lib" -Exclude "*UTest.lib" -Name -Recurse
$docs = @()
$others = @("README.md")

# create upload folder
mk-dir "..\upload"

# x86|Debug
Write-Host ""
Write-Host '[x86|Debug]' -ForegroundColor Green
$root = "..\upload\$project_base_name-$version-win32-debug"

if($includes.Count -ne 0) {
    mk-dir "$root\include"
    copy-files $includes "$root\include" INCLUDE
}
if($dlls_win32_debug.Count -ne 0) {
    mk-dir "$root\bin"
    copy-files $dlls_win32_debug "$root\bin" X86_DEBUG_BIN
}
if($libs_win32_debug.Count -ne 0) {
    mk-dir "$root\lib"
    copy-files $libs_win32_debug "$root\lib" X86_DEBUG_LIB
}
if($docs.Count -ne 0) {
	mk-dir "$root\docs"
	copy-files $docs "$root\docs" DOCS
}
if($others.Count -ne 0) {
	copy-files $others "$root" OTHERS
}

& 7z a ..\upload\$project_base_name-$version-win32-debug.zip "$root" -aoa

# x86|Release
Write-Host ""
Write-Host '[x86|Release]' -ForegroundColor Green
$root = "..\upload\$project_base_name-$version-win32-release"

if($includes.Count -ne 0) {
    mk-dir "$root\include"
    copy-files $includes "$root\include" INCLUDE
}
if($dlls_win32_release.Count -ne 0) {
    mk-dir "$root\bin"
    copy-files $dlls_win32_release "$root\bin" X86_RELEASE_BIN
}
if($libs_win32_release.Count -ne 0) {
    mk-dir "$root\lib"
    copy-files $libs_win32_release "$root\lib" X86_RELEASE_LIB
}
if($docs.Count -ne 0) {
	mk-dir "$root\docs"
	copy-files $docs "$root\docs" DOCS
}
if($others.Count -ne 0) {
	copy-files $others "$root" OTHERS
}

& 7z a ..\upload\$project_base_name-$version-win32-release.zip "$root" -aoa

# x64|Debug
Write-Host ""
Write-Host '[x64|Debug]' -ForegroundColor Green
$root = "..\upload\$project_base_name-$version-win64-debug"

if($includes.Count -ne 0) {
    mk-dir "$root\include"
    copy-files $includes "$root\include" INCLUDE
}
if($dlls_win64_debug.Count -ne 0) {
    mk-dir "$root\bin"
    copy-files $dlls_win64_debug "$root\bin" X64_DEBUG_BIN
}
if($libs_win64_debug.Count -ne 0) {
    mk-dir "$root\lib"
    copy-files $libs_win64_debug "$root\lib" X64_DEBUG_LIB
}
if($docs.Count -ne 0) {
	mk-dir "$root\docs"
	copy-files $docs "$root\docs" DOCS
}
if($others.Count -ne 0) {
	copy-files $others "$root" OTHERS
}

& 7z a ..\upload\$project_base_name-$version-win64-debug.zip "$root" -aoa

# x64|Release
Write-Host ""
Write-Host '[x64|Release]' -ForegroundColor Green
$root = "..\upload\$project_base_name-$version-win64-release"

if($includes.Count -ne 0) {
    mk-dir "$root\include"
    copy-files $includes "$root\include" INCLUDE
}
if($dlls_win64_release.Count -ne 0) {
    mk-dir "$root\bin"
    copy-files $dlls_win64_release "$root\bin" X64_RELEASE_BIN
}
if($libs_win64_release.Count -ne 0) {
    mk-dir "$root\lib"
    copy-files $libs_win64_release "$root\lib" X64_RELEASE_LIB
}
if($docs.Count -ne 0) {
	mk-dir "$root\docs"
	copy-files $docs "$root\docs" DOCS
}
if($others.Count -ne 0) {
	copy-files $others "$root" OTHERS
}

& 7z a ..\upload\$project_base_name-$version-win64-release.zip "$root" -aoa
