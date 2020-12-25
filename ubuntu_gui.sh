#!/bin/bash

# Ubuntu系统初始化脚本
# 适用于Ubuntu 20.04最小化安装
# 作者: Monten
# 创建日期: 2020/12/24
################################################################################
#                                    Utils                                     #
################################################################################
function log() {
    space=""
    for (( i = 0; i < ${1}; i++ )); do
        space=${space}"    "
    done
    echo -e "${space}""${2}"
    sleep 0.2
}

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
        choose "未发现文件夹${1}，按任意键跳过此步, 或自动创建, 是否自动创建?" && sudo mkdir ${1}
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

################################################################################
#                                    Steps                                     #
################################################################################
function init_system {
    log 0 "1. 初始化系统"
    log 1 "1.1 系统更新"
    sudo apt update && sudo apt upgrade -y
    log 1 "1.2 发行版本更新"
    sudo apt dist-upgrade
    log 1 "1.3 删除无用软件"
    sudo apt remove libreoffice-common unity-webapps-common thunderbird totem rhythmbox empathy brasero simple-scan gnome-mahjongg aisleriot gnome-mines cheese transmission-common gnome-orca webbrowser-app gnome-sudoku onboard deja-dup -y
}

function base_env_config() {
    log 0 "2. 配置基本环境"
    log 1 "2.1 配置SSH"
    check_dir ~/.ssh && sudo chown -R `whoami`:`whoami` ~/.ssh && chmod -R 700 ~/.ssh
    log 1 "2.2 调整HOME目录结构"
    log 2 "2.2.1 修改中文目录为英文目录"
    mkdir ~/{Desktop,Downloads,Temp,Public,Documents,Musics,Pictures,Videos}
    sed -i 's/.*XDG_DESKTOP_DIR.*/XDG_DESKTOP_DIR="$HOME\/Desktop"/g' ~/.config/user-dirs.dirs
    sed -i 's/.*XDG_DOWNLOAD_DIR.*/XDG_DOWNLOAD_DIR="$HOME\/Downloads"/g' ~/.config/user-dirs.dirs
    sed -i 's/.*XDG_TEMPLATES_DIR.*/XDG_TEMPLATES_DIR="$HOME\/Temp"/g' ~/.config/user-dirs.dirs
    sed -i 's/.*XDG_PUBLICSHARE_DIR.*/XDG_PUBLICSHARE_DIR="$HOME\/Public"/g' ~/.config/user-dirs.dirs
    sed -i 's/.*XDG_DOCUMENTS_DIR.*/XDG_DOCUMENTS_DIR="$HOME\/Documents"/g' ~/.config/user-dirs.dirs
    sed -i 's/.*XDG_MUSIC_DIR.*/XDG_MUSIC_DIR="$HOME\/Musics"/g' ~/.config/user-dirs.dirs
    sed -i 's/.*XDG_PICTURES_DIR.*/XDG_PICTURES_DIR="$HOME\/Pictures"/g' ~/.config/user-dirs.dirs
    sed -i 's/.*XDG_VIDEOS_DIR.*/XDG_VIDEOS_DIR="$HOME\/Videos"/g' ~/.config/user-dirs.dirs
    log 2 "2.2.2 删除无用目录"
    cd ~ && rmdir 文档 公共的 模板 下载 音乐 桌面 视频; rm -r 图片
    log 2 "2.2.3 创建必需目录"
    mkdir ~/{Codes,Projects}
    ln -s /tmp ~/Temp
    log 2 "2.2.4 安装Powerline字体"
    cd ~ && mkdir powerline && cd powerline
    wget https://raw.githubusercontent.com/powerline/powerline/develop/font/10-powerline-symbols.conf
    wget https://raw.githubusercontent.com/powerline/powerline/develop/font/PowerlineSymbols.otf
    sudo mkdir /usr/share/fonts/OTF
    sudo cp 10-powerline-symbols.conf /usr/share/fonts/OTF/
    sudo mv 10-powerline-symbols.conf /etc/fonts/conf.d/
    sudo mv PowerlineSymbols.otf /usr/share/fonts/OTF/
    rm -r ~/powerline
}

function software() {
    log 0 "4. 软件安装"
    sudo apt install git zsh bat autojump tmux curl build-essential python3-pip clang cmake gcc g++ make libssl-dev libbz2-dev libsqlite3-dev -y
    log 1 "4.1 git"
    echo "是否配置git账号?" && choose && if_conf_git=true
    if [ ${if_conf_git} ]; then
        read -rp "输入git邮箱:" git_email
        read -rp "输入git用户名:" git_name
        git config --global user.email ${git_email}
        git config --global user.name ${git_name}
        ssh-keygen -t rsa -C ${git_email}
        cd ~/.ssh
        gedit id_rsa.pub
    fi
    log 1 "4.2 zsh"
    log 2 "4.2.1 oh-my-zsh"
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    log 2 "4.2.2 设置zsh为默认"
    chsh -s /bin/zsh
    log 2 "4.2.3 配置zsh插件"
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
    log 2 "4.2.4 加载zsh配置文件"
    cd ~ && wget https://raw.githubusercontent.com/montenoki/setup_debian/main/.zshrc -O .zshrc
    log 1 "4.3 tmux"
    log 2 "4.3.1 配置tmux插件"
    mkdir ~/.tmux && mkdir ~/.tmux/plugins
    cd ~/.tmux/plugins
    git clone https://github.com/tmux-plugins/tmux-resurrect.git
    git clone https://github.com/tmux-plugins/tmux-continuum.git
    log 2 "4.3.2 加载tmux配置文件"
    cd ~ && wget https://raw.githubusercontent.com/montenoki/setup_debian/main/.tmux.conf -O .tmux.conf
    log 1 "4.4 pyenv"
    log 2 "4.4.1 安装本体"
    git clone https://github.com/pyenv/pyenv.git ~/.pyenv
    log 2 "4.4.2 安装插件"
    git clone https://github.com/pyenv/pyenv-virtualenv.git ~/.pyenv/plugins/pyenv-virtualenv
    log 2 "4.4.3 安装新版python"
    export PYENV_ROOT="$HOME/.pyenv"
    export PATH="$PYENV_ROOT/bin:$PATH"
    eval "$(pyenv virtualenv-init -)"
    pyenv install -v 3.9.1
    pyenv global 3.9.1
    python -m pip install --upgrade pip
    pip install you-get thefuck
    log 1 "4.5 vim"
    log 1 "4.6 docker"
    log 1 "4.7 vscode"
    log 1 ""
}

function cleanup {

    log 1 "1.4 自动移除不再使用的依赖程序包"
    sudo apt autoremove
    log 1 "1.5 删除已下载的旧包文件"
    sudo apt autoclean

}

################################################################################
#                                 Sub process                                  #
################################################################################

################################################################################
#                                    Main                                      #
################################################################################
function chinese {
    clear
    echo -e "\033[31m 此功能尚未完工\033[0m"
}

function setting {
    clear
    echo -e "\033[31m 此功能尚未完工\033[0m"
}

function main_process {
    clear
    init_system
    base_env_config
    software
    cleanup
}

function menu {
    clear
    echo
    echo -e "\033[31m \t\t\tLinux系统初始化脚本\033[0m"
    echo -e "\033[34m \t\t\tVer 1.0 作者:monten\033[0m" 
    echo -e "\t1. Install Chinese character display"
    echo -e "\t2. 自定义设置"
    echo -e "\t3. 开始执行"
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
        setting ;;
        3)
        main_process ;;
        *)
        clear
        echo "输入错误, 请重新选择";;
    esac
    echo -en "\n\n\t\t\t按任意键继续..."
    read -n 1 line
done
