@echo off
chcp 65001 >nul
title 一键管理员安装依赖

:: 检查是否以管理员权限运行
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo 请求管理员权限...
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)

echo ======================================================
echo             正在以管理员权限安装依赖
echo ======================================================
echo.

:: 切换到批处理文件所在目录
cd /d %~dp0

:: 执行npm install
echo 正在执行 npm install，请稍候...
npm install

echo.
echo ======================================================
echo             依赖安装完成
echo             请运行 启动项目.bat 来启动项目
echo ======================================================
echo.

pause 