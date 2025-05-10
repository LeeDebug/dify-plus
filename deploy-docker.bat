@echo off
setlocal enabledelayedexpansion

:: 基础目录配置
set "BASE_DIR=C:\www\wwwroot\ys_dify-plus"
cd /d "%BASE_DIR%" || (echo 无法进入基础目录 & exit /b 1)

:: 日志配置
set "LOG_DIR=logs"
mkdir "%LOG_DIR%" >nul 2>&1
set "TIMESTAMP=%DATE:/=-%_%TIME::=-%"
set "TIMESTAMP=%TIMESTAMP: =0%"
set "LOG_FILE=%LOG_DIR%\deploy_%TIMESTAMP:.=%.log"

:: 预检配置文件
set "DOCKER_COMPOSE_FILE=docker\docker-compose.dify-plus.yaml"
if not exist "%DOCKER_COMPOSE_FILE%" (
    echo [ERROR] Docker compose文件不存在: %DOCKER_COMPOSE_FILE%
    exit /b 1
)

:: 日志函数
:log
set "level=%~1"
set "message=%~2"
set "timestamp=%DATE% %TIME%"
echo [%timestamp%] [%level%] %message% >> "%LOG_FILE%"
echo [%timestamp%] [%level%] %message%
exit /b

:: 增强版命令执行
:execute
set "cmd=%~1"
set "desc=%~2"

call :log "INFO" "开始执行: %desc%"
call :log "DEBUG" "执行命令: %cmd%"

:: 执行命令并记录输出
%cmd% >> "%LOG_FILE%" 2>&1
if %ERRORLEVEL% neq 0 (
    call :log "ERROR" "操作失败: %desc% (错误码: %ERRORLEVEL%)"
    exit /b 1
)

call :log "INFO" "操作成功: %desc%"
exit /b

:: 主流程
call :log "INFO" "======== 开始部署 ========"

call :execute "git fetch --prune" "Git仓库更新"
call :execute "git pull --no-rebase" "代码拉取"
call :execute "cd docker && docker-compose -p dify-plus -f docker-compose.dify-plus.yaml down --remove-orphans" "停止容器"
call :execute "cd docker && docker-compose -p dify-plus -f docker-compose.dify-plus.yaml up -d --build --force-recreate" "启动容器"

call :log "INFO" "======== 部署完成 ========"
endlocal
