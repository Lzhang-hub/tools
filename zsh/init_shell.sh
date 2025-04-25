#!/bin/bash
# 安装依赖
if [ -f /etc/debian_version ]; then
    sudo apt update && sudo apt install -y zsh curl git
elif [ -f /etc/redhat-release ]; then
    sudo yum install -y zsh curl git
elif [ -f /etc/arch-release ]; then
    sudo pacman -Sy --noconfirm zsh curl git
else
    echo "错误：不支持的操作系统"
    exit 1
fi
# 安装oh-my-zsh
sh install_ohmyzsh.sh -y

# update source
cd ~/.oh-my-zsh
git remote set-url origin https://gitee.com/mirrors/oh-my-zsh.git 
git pull

# install plugins
git clone https://gitee.com/hailin_cool/zsh-autosuggestions.git $ZSH_CUSTOM/plugins/zsh-autosuggestions
git clone https://gitee.com/Greenplumwine/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting

# fix zshrc
[ -f ~/.zshrc ] && mv ~/.zshrc ~/.zshrc.bak
cp .zshrc ~/
source ~/.zshrc
