@echo off
echo 启动天气应用MCP桥接服务...
echo.

REM 检查Node.js是否安装
node --version >nul 2>&1
if errorlevel 1 (
    echo 错误: 未找到 Node.js。请先安装 Node.js 16+ 版本。
    pause
    exit /b 1
)

echo 检测到 Node.js 版本:
node --version

echo.
echo 检查依赖包...
if not exist node_modules (
    echo 安装依赖包...
    npm install
    if errorlevel 1 (
        echo 依赖安装失败！
        pause
        exit /b 1
    )
)

echo.
echo 启动MCP桥接服务...
echo 服务地址: http://localhost:3000
echo 按 Ctrl+C 停止服务
echo.

npm start 