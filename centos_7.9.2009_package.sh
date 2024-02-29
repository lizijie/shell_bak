yum update -y && yum install passwd sudo -y
sudo yum -y install git make vim tar zip file net-tools nc tcpdump procps-ng lsof perf iperf iotop htop dstat strace sysstat collectl

# docker
# @ref https://docs.docker.com/engine/install/centos/
sudo yum install -y yum-utils
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
sudo yum install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo systemctl start docker
sudo docker run hello-world
sudo systemctl enable docker.service
sudo systemctl enable containerd.service
sudo docker run --name mongodb -d -p 27017:27017 -v $(pwd)/data:/data/db -e MONGO_INITDB_ROOT_USERNAME=user -e MONGO_INITDB_ROOT_PASSWORD=pass mongo:4.4.28


