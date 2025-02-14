# os: debian 12

# isntall nvida drivers
# amao@amao:~$ nvidia-detect 
# Detected NVIDIA GPUs:
# 01:00.0 VGA compatible controller [0300]: NVIDIA Corporation GK107M [GeForce GT 755M] [10de:0fcd] (rev a1)
# Checking card:  NVIDIA Corporation GK107M [GeForce GT 755M] (rev a1)
# Your card is supported by the Tesla 470 drivers series.
# It is recommended to install the
#     nvidia-tesla-470-driver
# package.
sudo apt install linux-headers-amd64
sudo apt install -y nvidia-tesla-470-driver
# systemctl reboot

# 2. change apt sources.list
# @ref https://mirror.tuna.tsinghua.edu.cn/help/debian/
sudo mv /etc/apt/sources.list /etc/apt/sources.list_bak
sudo tee /etc/apt/sources.list  << EOF
# 默认注释了源码镜像以提高 apt update 速度，如有需要可自行取消注释
deb https://mirrors.tuna.tsinghua.edu.cn/debian/ bookworm main contrib non-free non-free-firmware
# deb-src https://mirrors.tuna.tsinghua.edu.cn/debian/ bookworm main contrib non-free non-free-firmware

deb https://mirrors.tuna.tsinghua.edu.cn/debian/ bookworm-updates main contrib non-free non-free-firmware
# deb-src https://mirrors.tuna.tsinghua.edu.cn/debian/ bookworm-updates main contrib non-free non-free-firmware

deb https://mirrors.tuna.tsinghua.edu.cn/debian/ bookworm-backports main contrib non-free non-free-firmware
# deb-src https://mirrors.tuna.tsinghua.edu.cn/debian/ bookworm-backports main contrib non-free non-free-firmware

# deb https://mirrors.tuna.tsinghua.edu.cn/debian-security bookworm-security main contrib non-free non-free-firmware
# # deb-src https://mirrors.tuna.tsinghua.edu.cn/debian-security bookworm-security main contrib non-free non-free-firmware

deb https://security.debian.org/debian-security bookworm-security main contrib non-free non-free-firmware
# deb-src https://security.debian.org/debian-security bookworm-security main contrib non-free non-free-firmware
EOF
sudo apt update

# intstall Docker
# @ref https://docs.docker.com/engine/install/debian/#install-using-the-repository
# @ref https://status.daocloud.io/status/docker
# @ref https://gist.github.com/y0ngb1n/7e8f16af3242c7815e7ca2f0833d3ea6
# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install -y ca-certificates curl gnupg
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg
# Add the repository to Apt sources:
echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
# docker image mirror
# 1. set request proxy
# @ref https://docs.docker.com/engine/daemon/proxy/#systemd-unit-file
sudo mkdir -p /etc/systemd/system/docker.service.d
sudo tee /etc/systemd/system/docker.service.d/http-proxy.conf  << EOF
[Service]
Environment="HTTP_PROXY=http://127.0.0.1:7890"
Environment="HTTPS_PROXY=http://127.0.0.1:7890"
EOF
# 2.
sudo mkdir -p /etc/docker
sudo tee /etc/docker/daemon.json <<-'EOF'
{
    "registry-mirrors": [
        "https://docker.m.daocloud.io",
        "https://docker.1ms.run"
    ]
}
EOF
sudo systemctl daemon-reload
sudo systemctl restart docker

sudo systemctl daemon-reload
sudo systemctl restart docker
sudo docker run hello-world

# mongod server
sudo docker run --name mongodb -d -p 27017:27017 -v $(pwd)/data:/data/db -e MONGO_INITDB_ROOT_USERNAME=user -e MONGO_INITDB_ROOT_PASSWORD=pass mongo:4.4.28

# mongo database tools
wget https://fastdl.mongodb.org/tools/db/mongodb-database-tools-debian12-x86_64-100.10.0.deb
sudo dpkg -i mongodb-database-tools-debian12-x86_64-100.10.0.deb

# mongosh
wget https://downloads.mongodb.com/compass/mongodb-mongosh_2.1.5_amd64.deb
sudo dpkg -i mongodb-mongosh_2.1.5_amd64.deb

# redis server
sudo docker run --name redis -d -p 6379:6379 redis:7.2.6 redis-server --save 60 1 --loglevel warning

# install wine
# mirror: https://mirror.tuna.tsinghua.edu.cn/help/wine-builds/
sudo dpkg --add-architecture i386
sudo wget -nc -O /usr/share/keyrings/winehq-archive.key https://dl.winehq.org/wine-builds/winehq.key
sudo mv /etc/apt/sources.list.d/winehq.list /etc/apt/sources.list.d/winehq.list_bak
cat > /etc/apt/sources.list.d/winehq.list  << EOF
deb [arch=amd64,i386 signed-by=/usr/share/keyrings/winehq-archive.key] https://mirrors.tuna.tsinghua.edu.cn/wine-builds/debian/ bookworm main
EOF
sudo apt update
sudo apt install -y --install-recommends winehq-stable

# my dev tools
sudo apt-get install -y vim wget openssh-client make cmake git ibus-table-wubi net-tools libpcre3-dev libssl-dev perl build-essential curl systemd-timesyncd python3 python3-pip ython3.11-venv tmux
# 创建python环境
python3 -m venv ~/py3env
source ~/py3env/bin/activate
# 删除python环境
deactivate
rm -f ~/py3env
# wsl vscode调车python虚拟环境路径
# @ref https://code.visualstudio.com/docs/python/environments

# nodejs
# @ref https://github.com/nodesource/distributions?tab=readme-ov-file#using-debian-as-root-nodejs-23
curl -fsSL https://deb.nodesource.com/setup_23.x -o nodesource_setup.sh
bash nodesource_setup.sh
apt-get install -y nodejs
npm install -g http-server

# 同步网络时间
sudo timedatectl set-ntp true
＃ 设置git环境
git config --global core.editor vim
git config --global diff.tool vimdiff
git config --global merge.tool vimdiff
git config --global --add difftool.prompt false
git config --global core.autocrlf input
cat >> ~/.vimrc << EOF
" 显示空白字符
set list
" vimdiff 高亮关闭
if &diff
        colorscheme evening
endif
EOF
touch /etc/profile 
cat >> /etc/profile << EOF
export PATH=$PATH:/usr/sbin/
EOF
source /etc/profile

# 蓝牙连接异常
# ref: https://wiki.debian.org/BluetoothUser
sudo apt-get install pulseaudio-module-bluetooth
sudo killall pulseaudio
pulseaudio --start    
sudo systemctl restart bluetooth
sudo apt install rfkill
/usr/sbin/rfkill unblock bluetooth
# bluetoothctl tip:
-scan on
-remove XX:XX:XX:XX:XX:XX, if it had already been paired
-trust XX:XX:XX:XX:XX:XX
-pair XX:XX:XX:XX:XX:XX
-connect XX:XX:XX:XX:XX:XX

# os: debian 12

# isntall nvida drivers
# amao@amao:~$ nvidia-detect 
# Detected NVIDIA GPUs:
# 01:00.0 VGA compatible controller [0300]: NVIDIA Corporation GK107M [GeForce GT 755M] [10de:0fcd] (rev a1)
# Checking card:  NVIDIA Corporation GK107M [GeForce GT 755M] (rev a1)
# Your card is supported by the Tesla 470 drivers series.
# It is recommended to install the
#     nvidia-tesla-470-driver
# package.
sudo apt install linux-headers-amd64
sudo apt install -y nvidia-tesla-470-driver
# systemctl reboot

# 2. change apt sources.list
# @ref https://mirror.tuna.tsinghua.edu.cn/help/debian/
sudo mv /etc/apt/sources.list /etc/apt/sources.list_bak
cat > /etc/apt/sources.list  << EOF
# 默认注释了源码镜像以提高 apt update 速度，如有需要可自行取消注释
deb https://mirrors.tuna.tsinghua.edu.cn/debian/ bookworm main contrib non-free non-free-firmware
# deb-src https://mirrors.tuna.tsinghua.edu.cn/debian/ bookworm main contrib non-free non-free-firmware

deb https://mirrors.tuna.tsinghua.edu.cn/debian/ bookworm-updates main contrib non-free non-free-firmware
# deb-src https://mirrors.tuna.tsinghua.edu.cn/debian/ bookworm-updates main contrib non-free non-free-firmware

deb https://mirrors.tuna.tsinghua.edu.cn/debian/ bookworm-backports main contrib non-free non-free-firmware
# deb-src https://mirrors.tuna.tsinghua.edu.cn/debian/ bookworm-backports main contrib non-free non-free-firmware

# deb https://mirrors.tuna.tsinghua.edu.cn/debian-security bookworm-security main contrib non-free non-free-firmware
# # deb-src https://mirrors.tuna.tsinghua.edu.cn/debian-security bookworm-security main contrib non-free non-free-firmware

deb https://security.debian.org/debian-security bookworm-security main contrib non-free non-free-firmware
# deb-src https://security.debian.org/debian-security bookworm-security main contrib non-free non-free-firmware
EOF
sudo apt update

# intstall Docker
# @ref https://docs.docker.com/engine/install/debian/#install-using-the-repository
# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install -y ca-certificates curl gnupg
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg
# Add the repository to Apt sources:
echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update

sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
# set request proxy
# @ref https://docs.docker.com/engine/daemon/proxy/#systemd-unit-file
sudo mkdir -p /etc/systemd/system/docker.service.d
sudo cat > /etc/systemd/system/docker.service.d/http-proxy.conf  << EOF
[Service]
Environment="HTTP_PROXY=http://127.0.0.1:7890"
Environment="HTTPS_PROXY=http://127.0.0.1:7890"
EOF
sudo systemctl daemon-reload
sudo systemctl restart docker
sudo docker run hello-world

＃ mongod server
sudo docker run --name mongodb -d -p 27017:27017 -v $(pwd)/data:/data/db -e MONGO_INITDB_ROOT_USERNAME=user -e MONGO_INITDB_ROOT_PASSWORD=pass mongo:4.4.28
wget https://downloads.mongodb.com/compass/mongodb-mongosh_2.1.5_amd64.deb
sudo dpkg -i mongodb-mongosh_2.1.5_amd64.deb

# go
echo "export GO111MODULE=on" >> ~/.profile
echo "export GOPROXY=https://goproxy.cn" >> ~/.profile
source ~/.profile

# install wine
# mirror: https://mirror.tuna.tsinghua.edu.cn/help/wine-builds/
sudo dpkg --add-architecture i386
sudo wget -nc -O /usr/share/keyrings/winehq-archive.key https://dl.winehq.org/wine-builds/winehq.key
sudo mv /etc/apt/sources.list.d/winehq.list /etc/apt/sources.list.d/winehq.list_bak
cat > /etc/apt/sources.list.d/winehq.list  << EOF
deb [arch=amd64,i386 signed-by=/usr/share/keyrings/winehq-archive.key] https://mirrors.tuna.tsinghua.edu.cn/wine-builds/debian/ bookworm main
EOF
sudo apt update
sudo apt install -y --install-recommends winehq-stable

# my dev tools
sudo apt-get install -y vim wget openssh-client make cmake git ibus-table-wubi net-tools libpcre3-dev libssl-dev perl build-essential curl systemd-timesyncd python3 python3-pip ython3.11-venv
# 创建python环境
python3 -m venv ~/py3env
source ~/py3env/bin/activate
# 删除python环境
deactivate
rm -f ~/py3env
# wsl vscode调车python虚拟环境路径
# @ref https://code.visualstudio.com/docs/python/environments

# 同步网络时间
sudo timedatectl set-ntp true
＃ 设置git环境
git config --global core.editor vim
git config --global diff.tool vimdiff
git config --global merge.tool vimdiff
git config --global --add difftool.prompt false
git config --global core.autocrlf input
cat >> ~/.vimrc << EOF
" 显示空白字符
set list
" vimdiff 高亮关闭
if &diff
        colorscheme evening
endif
EOF
touch /etc/profile 
cat >> /etc/profile << EOF
export PATH=$PATH:/usr/sbin/
EOF
source /etc/profile

# 蓝牙连接异常
# ref: https://wiki.debian.org/BluetoothUser
sudo apt-get install pulseaudio-module-bluetooth
sudo killall pulseaudio
pulseaudio --start    
sudo systemctl restart bluetooth
sudo apt install rfkill
/usr/sbin/rfkill unblock bluetooth
:'
Start the bluetoothctl interactive command. Enter "help" to get a list of available commands.

    Turn the power to the controller on by entering "power on". It is off by default.
    Enter "devices" to get the MAC Address of the device with which to pair.
    Enter device discovery mode with "scan on" command if device is not yet on the list.
    Turn the agent on with "agent on".

    Enter "pair MAC Address" to do the pairing (tab completion works).

    If using a device without a PIN, one may need to manually trust the device before it can reconnect successfully. Enter "trust MAC Address" to do so.

    Finally, use "connect MAC address" to establish a connection. 
'
