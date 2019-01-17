sudo yum -y update && sudo yum -y clean all
sudo yum -y install git subversion \
	wget vim vim-X11 libX11-devel \
	lrzsz \
	xclip \
	make cmake \
	zip unzip zlib* \
	tar gzip bzip2 wget zlib \
	gcc-c++ gdb \
	openssl* \
	openssh-* ncurses-devel texinfo \
	glibc-devel.i686 \
	libgcc.i686 \
	ruby ruby-devel lua lua-devel luajit \
	luajit-devel ctags git svn \
	readline-devel \
	tcl-devel tree \
	perl perl-devel perl-ExtUtils-ParseXS \
	perl-ExtUtils-XSpp perl-ExtUtils-CBuilder \
	perl-ExtUtils-Embed \
	python-devel libX11 libX11-devel libXtst-devel \
	libXtst libXt-devel libXt libSM-devel libSM \
	libXpm libXpm-devel

# group
sudo yum -y groupinstall "Development tools"
	
# gdb info	
debuginfo-install glibc-2.17-196.el7_4.2.x86_64 libgcc-4.8.5-16.el7_4.2.x86_64 libstdc++-4.8.5-16.el7_4.2.x86_64

# netcat
wget http://sourceforge.net/projects/netcat/files/netcat/0.7.1/netcat-0.7.1.tar.gz
tar -xvf netcat-0.7.1.tar.gz
cd netcat-0.7.1
./configure
make && sudo make install

# docker
sudo yum install -y yum-utils \
    device-mapper-persistent-data \
    lvm2
sudo yum-config-manager \
    --add-repo \
    https://download.docker.com/linux/centos/docker-ce.repo
sudo yum-config-manager --enable docker-ce-edge
sudo yum-config-manager --enable docker-ce-test
sudo yum install -y docker-ce-18.03.0.ce
sudo systemctl start docker

# lua
curl -R -O http://www.lua.org/ftp/lua-5.3.4.tar.gz
tar zxf lua-5.3.4.tar.gz
cd lua-5.3.4
make linux test

# gcc
wget -O gcc-4.9.4.tar.gz http://gcc.parentingamerica.com/releases/gcc-4.9.4/gcc-4.9.4.tar.gz \
	&& tar -xvf gcc-4.9.4.tar.gz \
	&& cd gcc-4.9.4 && \
	&& ./contrib/download_prerequisites \
	&& ./configure --prefix=/usr/gcc-4.9.4 --enable-stage1-checking=release --enable-stage1-languages=c,c++,go \
	&& make -j 4 && make install \

# git tools
git config --global diff.tool vimdiff
git config --global difftool.prompt false

