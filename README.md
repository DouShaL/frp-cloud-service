# 云服务器穿透校园网  
  
#### 介绍  
内网穿透  

#### 软件架构  
校园网主机frpc客户端->云服务器frps客户端  


#### 安装教程  
解压即可  
   
  
#### 使用说明  
  
使用open-ports.sh脚本开放所需端口  
  
云服务器常驻  
sudo vim /etc/systemd/system/frps.service  
{  
[Unit]  
Description=Frp Server Service  
After=network.target  
  
[Service]  
Type=simple  
！如果FRP需要绑定特权端口（<1024），使用root用户  
User=root  
！确保工作目录存在且有适当权限  
WorkingDirectory=/root/frp_0.54.0_linux_amd64  
！使用绝对路径指向frps可执行文件  
ExecStart=/root/frp_0.54.0_linux_amd64/frps -c /root/frp_0.54.0_linux_amd64/frps.ini  
Restart=on-failure  
RestartSec=5s  
  
[Install]  
WantedBy=multi-user.target  
}  
sudo systemctl daemon-reload  
sudo systemctl start frps  
sudo systemctl enable frps  
sudo systemctl status frps  
  
  
windows端自启  
  
脚本frpc_watchdog.ps1  
设置脚本自启  
按 Win + R，输入 shell:startup 并回车  
创建一个快捷方式指向你的 PowerShell 脚本  
或者使用计划任务在登录时运行这个脚本  

