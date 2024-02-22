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
sudo docker run hello-world

＃ mongod server
sudo docker run --name mongodb -d -p 27017:27017 -v $(pwd)/data:/data/db -e MONGO_INITDB_ROOT_USERNAME=user -e MONGO_INITDB_ROOT_PASSWORD=pass mongo:4.4.28

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
sudo apt-get install -y vim wget openssh-client make cmake git ibus-table-wubi net-tools libpcre3-dev libssl-dev perl build-essential curl systemd-timesyncd
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

