#!/bin/bash

# 防火墙端口开放脚本 (使用 firewall-cmd)
# 适用于使用 firewalld 的 Linux 发行版（如 CentOS、RHEL、Fedora，或安装了 firewalld 的 Ubuntu）

# 需要开放的端口列表（请根据实际情况修改）
FRP_TCP_PORTS=(7000 7500)      # FRP 服务端端口和管理面板端口
FRP_UDP_PORTS=(7001 7000)           # FRP UDP 端口
SUNSHINE_TCP_PORTS=(47984 47989 47990 48010)  # Sunshine TCP 端口
SUNSHINE_UDP_PORTS=(47998 47999 48000 48010)        # Sunshine UDP 端口
SSH_PORT=22                    # SSH 端口

# 合并所有端口
TCP_PORTS=(${FRP_TCP_PORTS[@]} ${SUNSHINE_TCP_PORTS[@]} $SSH_PORT)
UDP_PORTS=(${FRP_UDP_PORTS[@]} ${SUNSHINE_UDP_PORTS[@]})

# 去重
TCP_PORTS=($(printf "%s\n" "${TCP_PORTS[@]}" | sort -u))
UDP_PORTS=($(printf "%s\n" "${UDP_PORTS[@]}" | sort -u))

# 检查 firewalld 是否安装和运行
check_firewalld() {
    if ! command -v firewall-cmd &> /dev/null; then
        echo "错误: firewalld 未安装。"
        echo "请先安装 firewalld:"
        echo "Ubuntu/Debian: sudo apt update && sudo apt install firewalld"
        echo "CentOS/RHEL: sudo yum install firewalld"
        exit 1
    fi
    
    if ! systemctl is-active --quiet firewalld; then
        echo "firewalld 未运行，正在启动..."
        sudo systemctl start firewalld
        sudo systemctl enable firewalld
    fi
}

# 开放端口函数
open_ports() {
    echo "正在配置 firewalld 开放端口..."
    echo "TCP 端口: ${TCP_PORTS[*]}"
    echo "UDP 端口: ${UDP_PORTS[*]}"
    echo

    # 开放 TCP 端口
    for port in "${TCP_PORTS[@]}"; do
        echo "开放 TCP 端口 $port"
        sudo firewall-cmd --permanent --add-port=$port/tcp
    done

    # 开放 UDP 端口
    for port in "${UDP_PORTS[@]}"; do
        echo "开放 UDP 端口 $port"
        sudo firewall-cmd --permanent --add-port=$port/udp
    done

    # 重新加载防火墙配置
    echo "重新加载防火墙配置..."
    sudo firewall-cmd --reload

    echo
    echo "端口开放完成!"
}

# 显示当前开放的端口
show_open_ports() {
    echo "当前开放的端口:"
    sudo firewall-cmd --list-ports
}

# 主函数
main() {
    # 检查 root 权限
    if [[ $EUID -ne 0 ]]; then
        echo "此脚本需要以 root 权限运行" 
        exit 1
    fi
    
    echo "开始配置防火墙..."
    
    # 检查 firewalld
    check_firewalld
    
    # 开放端口
    open_ports
    
    echo
    # 显示当前开放的端口
    show_open_ports
    
    echo
    echo "请注意: 如果你使用的是云服务器（如阿里云、腾讯云等），还需要在云平台的安全组设置中开放相应端口。"
}

# 执行主函数
main

