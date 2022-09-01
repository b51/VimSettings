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

# sudo apt update
brew install clang-format exuberant-ctags cscope
cp vimrc.settings ~/.vimrc
cp -rf vim ~/.vim
cp -rf nvim.config/* ~/.config/nvim/
cp clang-format.setting ~/.clang-format
cd ~/.vim/bundle/
vim +PlugInstall +qall
# cat .rosinstall | grep uri | awk '{print $2}' | while read line; do git clone --recursive $line; done;
# nvim --headless +PlugInstall +qall
# wstool update -j4
# cd YouCompleteMe
# python3 install.py --clang-completer
