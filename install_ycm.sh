#bin/sh
install_common_use_pkg.sh

# TODO check dir
# TODO remove old python
echo "remove python_download_temp"
rm -rf ~/python_download_temp
mkdir ~/python_download_temp
cd ~/python_download_temp
wget --no-check-certificate -O Python-2.7.9.tar.xz https://www.python.org/ftp/python/2.7.9/Python-2.7.9.tgz
tar -xvf Python-2.7.9.tar.xz
cd Python-2.7.9
./configure --enable-shared
make -j 4 && sudo make altinstall


# TODO check dir
# TODO remove old cmake
echo "remove cmake_download_temp"
rm -rf ~/cmake_download_temp
mkdir ~/cmake_download_temp
cd ~/cmake_download_temp
wget --no-check-certificate -O cmake-3.11.0-rc4.tar.gz  https://cmake.org/files/v3.11/cmake-3.11.0-rc4.tar.gz
tar -xvf cmake-3.11.0-rc4.tar.gz
cd cmake-3.11.0-rc4
./configure
make -j 4 && sudo make install


# TODO check dir
# TODO remove old vim
echo "remove vim_download_temp"
mkdir ~/vim_download_temp
cd ~/vim_download_temp
wget --no-check-certificate -O v8.0.1626.zip https://github.com/vim/vim/archive/v8.0.1626.zip
unzip v8.0.1626.zip
cd ~/vim_download_temp/vim-8.0.1626
./configure --with-features=huge --enable-pythoninterp --enable-rubyinterp --enable-luainterp --with-python-config-dir=/usr/local/lib/python2.7/config/ --enable-gui=auto --enable-gtk2-check --enable-gnome-check --with-x --enable-cscope --prefix=/usr LDFLAGS="-Wl,-rpath /usr/local/lib"
make -j 4 && sudo make install

# vim vundle
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

#
mkdir ~/sourceInstallations
cd ~/sourceInstallations
svn co http://llvm.org/svn/llvm-project/llvm/tags/RELEASE_600/final llvm_RELEASE_600
cd llvm_RELEASE_600/tools
svn co http://llvm.org/svn/llvm-project/cfe/tags/RELEASE_600/final clang
cd ../projects
svn co http://llvm.org/svn/llvm-project/compiler-rt/tags/RELEASE_600/final compiler-rt
svn co http://llvm.org/svn/llvm-project/libcxx/tags/RELEASE_600/final libcxx
svn co http://llvm.org/svn/llvm-project/libcxxabi/tags/RELEASE_600/final libcxxabi
cd ..
svn update
mkdir ../llvm_RELEASE_600_build
cd ../llvm_RELEASE_600_build
cmake -G "Unix Makefiles" -DCMAKE_BUILD_TYPE=Release -DCMAKE_C_COMPILER=/usr/bin/gcc -DCMAKE_CXX_COMPILER=/usr/bin/g++ ../llvm_RELEASE_600 && make && sudo make install && echo success

mkdir ../ycm_build
cd ../ycm_build
cmake -G "Unix Makefiles" -DEXTERNAL_LIBCLANG_PATH=/usr/local/lib/libclang.so . ~/.vim/bundle/YouCompleteMe/third_party/ycmd/cpp
cmake --build . --target ycm_core --config Release
