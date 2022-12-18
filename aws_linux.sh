
sudo yum install git
# ====================
# 安装pyenv
# 参考：https://blog.serverworks.co.jp/install-python3-with-openssl11
# ====================
# 官方推荐依赖
sudo yum install -y gcc make zlib-devel bzip2 bzip2-devel readline-devel sqlite sqlite-devel tk-devel libffi-devel xz-devel
# 3.10以上版本Python需要ssl11
sudo yum install -y openssl11 openssl11-devel
# 自动安装脚本
curl https://pyenv.run | bash
# 设置环境变量
echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.bashrc
echo 'command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.bashrc
echo 'eval "$(pyenv init -)"' >> ~/.bashrc
echo 'eval "$(pyenv virtualenv-init -)"' >> ~/.bashrc
exec $SHELL -l
# 安装Python
pyenv install 3.11.1

