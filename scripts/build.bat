@echo off

:: build & install & package
powershell.exe -ExecutionPolicy RemoteSigned ".\proj_build_install_package.ps1"

:: create-props
powershell.exe -ExecutionPolicy RemoteSigned -File ./create_props.ps1

echo.
echo.
echo Build completed.

set time=3
echo This Window will automatically close in %time% seconds..
choice -C YN -D Y -N -T %time% 1> nul
