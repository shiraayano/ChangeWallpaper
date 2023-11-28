@echo off
setlocal EnableDelayedExpansion

:: 获取当前脚本的绝对路径
for %%I in ("%~dp0.") do set "ScriptPath=%%~fI"

:: 设置壁纸文件夹路径
set "WallpaperDir=%ScriptPath%\img"

:: 获取所有子文件夹
for /D %%D in ("%WallpaperDir%\*") do (
    set /A "DirCount+=1"
    set "DirList[!DirCount!]=%%~fD"
)

:selectDir
:: 生成随机数来选择一个子文件夹
set /A "RandomDirIndex=!random! %% DirCount + 1"
set "SelectedDir=!DirList[%RandomDirIndex%]!"

:: 检查选定的文件夹是否与上一次的相同
if exist last_folder.txt (
    set /p LastFolder=<last_folder.txt
    if "!LastFolder!"=="!SelectedDir!" goto :selectDir
)

:: 将选定的文件夹名保存为下一次检查
echo !SelectedDir! > last_folder.txt

:: 获取选定文件夹中的所有.jpg和.png文件
set "FileCount=0"
for %%F in ("%SelectedDir%\*.jpg" "%SelectedDir%\*.png") do (
    set /A "FileCount+=1"
    set "FileList[!FileCount!]=%%~fF"
)

:: 生成随机数来选择一个文件
set /A "RandomFileIndex=!random! %% FileCount + 1"
set "SelectedFile=!FileList[%RandomFileIndex%]!"

:: 更改壁纸
reg add "HKCU\Control Panel\Desktop" /v Wallpaper /t REG_SZ /d "" /f
reg add "HKCU\Control Panel\Desktop" /v Wallpaper /t REG_SZ /d "!SelectedFile!" /f

:: 应用更改并添加延迟以确保刷新
RUNDLL32.EXE user32.dll,UpdatePerUserSystemParameters
timeout /t 2 /nobreak >nul
RUNDLL32.EXE user32.dll,UpdatePerUserSystemParameters
