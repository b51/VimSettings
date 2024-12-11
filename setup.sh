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

cp -r nvim ~/.config/
cp clang-format.setting ~/.clang-format

# install colorscripts
git clone https://gitlab.com/dwt1/shell-color-scripts
cd shell-color-scripts
sudo make install
cd -

# CocInstall coc-snippets
# CocInstall coc-jedi
# CocInstall coc-clangd
