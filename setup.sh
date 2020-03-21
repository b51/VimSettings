#########################################################################
#
#              Author: b51
#                Mail: b51live@gmail.com
#            FileName: setup.sh
#
#          Created On: Thu 06 Sep 2018 08:46:10 PM CST
#
#########################################################################

#!/bin/bash

sudo apt update
sudo apt install clang-format exuberant-ctags cscope global python-wstool -y
cp vimrc.settings ~/.vimrc
cp -rf vim ~/.vim
cp clang-format.setting ~/.clang-format
cd ~/.vim/bundle/
#cat .rosinstall | grep uri | awk '{print $2}' | while read line; do git clone --recursive $line; done;
wstool update -j4
cd YouCompleteMe
python3 install.py --clang-completer
