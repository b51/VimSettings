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
sudo apt install neovim clang-format exuberant-ctags cscope global -y
pip2 install --user pynvim
pip3 install --user pynvim
mkdir -p ~/.config/nvim
cp init.vim ~/.config/nvim
cp vimrc.settings ~/.vimrc
cp -rf vim ~/.vim
cp clang-format.setting ~/.clang-format
cd ~/.vim/bundle/
nvim +PlugInstall +qall
