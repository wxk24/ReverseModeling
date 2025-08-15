@echo off
set name=%~n0
powershell.exe -ExecutionPolicy RemoteSigned .\%name%.ps1
choice -C YN -D Y -N -T 1
