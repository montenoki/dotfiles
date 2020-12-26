#!/bin/bash

# Ubuntu系统初始化脚本
# 适用于Ubuntu 20.04最小化安装
# 作者: Monten
# 创建日期: 2020/12/24
################################################################################
#                                    Utils                                     #
################################################################################
function check_file() {
    if [ ! -f "${1}" ]; then
        choose "未发现文件${1}，按任意键跳过此步，或自动创建, 是否自动创建?" && sudo touch ${1}
    fi

    if [ -f "${1}" ]; then
        return 0
    fi
    return 1
}

function check_dir() {
    if [ ! -d "${1}" ]; then
        mkdir ${1} -p
    fi

    if [ -d "${1}" ]; then
        return 0
    fi
    return 1
}

function press_any_key_to_continue() {
    if [[ $# != 0 ]]; then
        echo -e "${1}"
    fi
    read -p "按任意键继续..." -rn 1
}

function choose() {
    read -rp "${1}""(y/n): " choose
    if [[ "${choose}" = "y" ]]; then
        return 0
    fi
    return 1
}

# echo "是否配置git账号?" && choose && if_conf_git=true

################################################################################
#                                  Softwares                                   #
################################################################################
function install_git() {
    sudo apt install -y git
    if [ ! ${git_email} ] || [ ! ${git_name} ]; then
        read -rp "输入git邮箱:" git_email
        read -rp "输入git用户名:" git_name
    fi
    git config --global user.email ${git_email}
    git config --global user.name ${git_name}
    ssh-keygen -t rsa -C ${git_email}""

}
function install_zsh() {
    sudo apt install -y zsh
    # oh-my-zsh
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    # 设置zsh为默认
    chsh -s /bin/zsh
    # 配置zsh插件
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
    # 加载zsh配置文件
    cd ~ && wget https://raw.githubusercontent.com/montenoki/auto_setup/main/.zshrc -O .zshrc
}
function install_tmux() {
    sudo apt install -y tmux
    # 安装tmux插件
    check_dir ~/.tmux/plugins && cd ~/.tmux/plugins
    git clone https://github.com/tmux-plugins/tmux-resurrect.git
    git clone https://github.com/tmux-plugins/tmux-continuum.git
    # 加载tmux配置文件
    cd ~ && wget https://raw.githubusercontent.com/montenoki/auto_setup/main/.tmux.conf -O .tmux.conf
}
function install_pyenv() {
    check_dir ~/.pyenv && git clone https://github.com/pyenv/pyenv.git ~/.pyenv
    # 安装pyenv插件
    check_dir ~/.pyenv/plugins/pyenv-virtualenv && git clone https://github.com/pyenv/pyenv-virtualenv.git ~/.pyenv/plugins/pyenv-virtualenv
}
function install_vim() {
    echo "?"
}
function install_python_softwares() {
    export PYENV_ROOT="$HOME/.pyenv"
    export PATH="$PYENV_ROOT/bin:$PATH"
    pyenv install -v 3.9.1
    pyenv global 3.9.1
    python -m pip install --upgrade pip
    pip install you-get thefuck
}
################################################################################
#                                 Sub process                                  #
################################################################################
function system_update() {
    # 更新系统 #
    sudo apt update && sudo apt upgrade -y
}
function ssh_config() {
    # 配置SSH #
    check_dir ~/.ssh && sudo chown -R `whoami`:`whoami` ~/.ssh && chmod -R 700 ~/.ssh
}
function home_config() {
    # 调整HOME目录结构 #
    # 修改中文目录为英文目录
    mkdir ~/{Desktop,Downloads,Templates,Public,Documents,Musics,Pictures,Videos}
    sed -i 's/.*XDG_DESKTOP_DIR.*/XDG_DESKTOP_DIR="$HOME\/Desktop"/g' ~/.config/user-dirs.dirs
    sed -i 's/.*XDG_DOWNLOAD_DIR.*/XDG_DOWNLOAD_DIR="$HOME\/Downloads"/g' ~/.config/user-dirs.dirs
    sed -i 's/.*XDG_TEMPLATES_DIR.*/XDG_TEMPLATES_DIR="$HOME\/Templates"/g' ~/.config/user-dirs.dirs
    sed -i 's/.*XDG_PUBLICSHARE_DIR.*/XDG_PUBLICSHARE_DIR="$HOME\/Public"/g' ~/.config/user-dirs.dirs
    sed -i 's/.*XDG_DOCUMENTS_DIR.*/XDG_DOCUMENTS_DIR="$HOME\/Documents"/g' ~/.config/user-dirs.dirs
    sed -i 's/.*XDG_MUSIC_DIR.*/XDG_MUSIC_DIR="$HOME\/Musics"/g' ~/.config/user-dirs.dirs
    sed -i 's/.*XDG_PICTURES_DIR.*/XDG_PICTURES_DIR="$HOME\/Pictures"/g' ~/.config/user-dirs.dirs
    sed -i 's/.*XDG_VIDEOS_DIR.*/XDG_VIDEOS_DIR="$HOME\/Videos"/g' ~/.config/user-dirs.dirs
    # 删除无用目录
    cd ~ && rmdir 文档 公共的 模板 下载 音乐 桌面 视频; rm -r 图片
    # 创建必需目录
    mkdir ~/{Codes,Projects}
    # 创建tmp文件夹链接
    ln -s /tmp ~
}
function software_install() {
    sudo apt install -y bat curl aria2
    sudo apt install -y clang cmake gcc g++ make build-essential
    sudo apt install -y python3-pip autojump
    sudo apt install -y fonts-powerline
    sudo apt install -y libssl-dev libbz2-dev libsqlite3-dev
    install_git
    install_zsh
    install_tmux
    install_pyenv
    install_vim
    install_python_softwares
}
function fonts_config() {
    # 配置字体 #
    # 安装iosevka字体
    aria2c https://github.com/be5invis/Iosevka/releases/download/v4.2.0/ttf-iosevka-4.2.0.zip -d ~/Downloads
    mkdir ~/tmp/iosevka && unzip ~/Downloads/ttf-iosevka-4.2.0.zip -d ~/tmp/iosevka
    sudo mkdir /usr/share/fonts/custom/iosevka -p
    sudo mv ~/tmp/iosevka/* /usr/share/fonts/custom/iosevka
    # 安装iosevka字体
    aria2c https://github.com/be5invis/Iosevka/releases/download/v4.2.0/ttf-iosevka-term-4.2.0.zip  -d ~/Downloads
    mkdir ~/tmp/iosevka-term && unzip ~/Downloads/ttf-iosevka-term-4.2.0.zip -d ~/tmp/iosevka-term
    sudo mkdir /usr/share/fonts/custom/iosevka-term -p
    sudo mv ~/tmp/iosevka-term/* /usr/share/fonts/custom/iosevka-term
}
function software_del() {
    # 删除无用软件
    sudo apt remove libreoffice-common unity-webapps-common thunderbird totem rhythmbox empathy brasero simple-scan gnome-mahjongg aisleriot gnome-mines cheese transmission-common gnome-orca webbrowser-app gnome-sudoku onboard deja-dup -y
}
function cleanup {
    # 自动清理
    sudo apt autoremove && sudo apt autoclean
}
################################################################################
#                                    Main                                      #
################################################################################
function chinese {
    clear
    echo -e "\033[31m 此功能尚未完工\033[0m"
}

function custom_process {
    clear
    echo -e "\033[31m 此功能尚未完工\033[0m"
}

function default_process {
    clear
    system_update
    ssh_config
    home_config
    software_install
    fonts_config
    software_del
    cleanup
    press_any_key_to_continue
}

function menu {
    clear
    echo
    echo -e "\033[31m \t\t\tLinux系统初始化脚本\033[0m"
    echo -e "\033[34m \t\t\tVer 1.0 作者:monten\033[0m" 
    echo -e "\t1. Install Chinese character display"
    echo -e "\t2. 自定义设置"
    echo -e "\t3. 开始执行(默认设置)"
    echo -e "\t0. 退出(Exit)\n\n"
    echo -en "\t\t输入选择:"
    read -n 1 option
}

while [ 1 ]
do
    menu
    case $option in
        0)
        clear && break ;;
        1)
        chinese ;;
        2)
        custom_process ;;
        3)
        default_process ;;
        *)
        clear
        echo "输入错误, 请重新选择";;
    esac
    echo -en "\n\n\t\t\t按任意键继续..."
    read -n 1 line
done
