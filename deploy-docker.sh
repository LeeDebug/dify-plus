#!/bin/bash
set -e

# 工作目录配置
BASE_DIR="/www/wwwroot/ys_dify-plus"
cd "$BASE_DIR" || { echo "Failed to enter base directory"; exit 1; }

# 日志配置
LOG_DIR="./logs"
mkdir -p "$LOG_DIR"
LOG_FILE="$LOG_DIR/deploy_$(date +%Y%m%d%H%M%S).log"

# 预检配置文件
DOCKER_COMPOSE_FILE="docker/docker-compose.dify-plus.yaml"
if [ ! -f "$DOCKER_COMPOSE_FILE" ]; then
    echo "ERROR: Docker compose file not found: $DOCKER_COMPOSE_FILE" | tee -a "$LOG_FILE"
    exit 1
fi

# 日志函数
log() {
    local level=$1
    local message=$2
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    echo "$timestamp $level: $message" | tee -a "$LOG_FILE"
}

# 增强版命令执行
execute_command() {
    local cmd=$1
    local description=$2

    log "INFO" "START $description"
    log "DEBUG" "CMD: $cmd"

    # 带缓冲区的实时日志输出
    if ! eval "$cmd" 2>&1 | while IFS= read -r line; do
        log "DEBUG" "$line"
    done; then
        log "ERROR" "$description FAILED - exit code $?"
        exit 1
    fi

    log "INFO" "$description SUCCESS"
}

# 主流程
main() {
    log "INFO" "===== DEPLOY START ====="

    execute_command "git fetch --prune" "Git仓库更新"
    execute_command "git pull --no-rebase" "代码拉取"

    execute_command \
        "cd docker && docker-compose -p dify-plus -f docker-compose.dify-plus.yaml down" \
        "容器停止"

    execute_command \
        "cd docker && docker-compose -p dify-plus -f docker-compose.dify-plus.yaml up -d" \
        "容器启动"

    log "INFO" "===== DEPLOY COMPLETED ====="
}

# 执行入口
main