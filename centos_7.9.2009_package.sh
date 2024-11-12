yum update -y && yum install passwd sudo -y
sudo yum -y install wget git make vim tar zip file net-tools nc gcc tcpdump procps-ng lsof perf iperf iotop htop dstat strace sysstat collectl

# upgrade gcc to v10
sudo yum install -y centos-release-scl devtoolset-10
source /opt/rh/devtoolset-10/enable

# docker
# @ref https://docs.docker.com/engine/install/centos/
sudo yum install -y yum-utils
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
sudo yum install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo systemctl start docker
sudo docker run hello-world
sudo systemctl enable docker.service
sudo systemctl enable containerd.service

# mongo server
sudo docker run --name mongodb -d -p 27017:27017 -v $(pwd)/data:/data/db -e MONGO_INITDB_ROOT_USERNAME=user -e MONGO_INITDB_ROOT_PASSWORD=pass mongo:4.4.28
wget https://downloads.mongodb.com/compass/mongodb-mongosh-2.1.5.x86_64.rpm
rpm -i mongodb-mongosh-2.1.5.x86_64.rpm
