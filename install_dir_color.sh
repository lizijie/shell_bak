#!bin/sh

COLOR_DIR=$HOME/solarized

if [ ! -d $COLOR_DIR ]
then
    mkdir $COLOR_DIR
fi

cd $COLOR_DIR
#git clone git://github.com/seebi/dircolors-solarized.git

STR="eval \`dircolors $COLOR_DIR/dircolors-solarized/dircolors.ansi-dark\`"

touch $HOME/.bash_profile
echo $STR  >> $HOME/.bash_profile
source $HOME/.bash_profile
