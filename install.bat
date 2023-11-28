@echo off

schtasks /create /tn "ChangeWallpaper" /tr "%~dp0\start.vbs" /sc minute /mo 1
