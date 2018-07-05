@echo off

set DIR=%~dp0
SET excel_root=E:\..xx\project\excel
SET pulish_root=E:\..xx\project\config

del /q/a/f %DIR%\_ceche\*.*

call %DIR%/python27/python.exe main.py %excel_root%
call %DIR%/lua5.1/lua.exe main.lua %pulish_root%
pause