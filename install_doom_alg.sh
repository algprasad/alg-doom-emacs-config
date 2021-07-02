sudo add-apt-repository ppa:kelleyk/emacs
sudo apt-get update
sudo apt-get install emacs27
wget https://github.com/BurntSushi/ripgrep/releases/download/13.0.0/ripgrep_13.0.0_amd64.deb
sudo dpkg -i ripgrep_13.0.0_amd64.deb
wget https://github.com/sharkdp/fd/releases/download/v8.2.1/fd_8.2.1_amd64.deb
sudo dpkg -i fd_8.2.1_amd64.deb
git clone https://github.com/hlissner/doom-emacs ~/.emacs.d
~/.emacs.d/bin/doom install
cd ~/.doom.d
mkdir old_config
mv config.el init.el packages.el old_config/
git init
git remote add origin https://github.com/algprasad/alg-doom-emacs-config.git
git pull origin main
source ~/.bashrc
doom sync
doom doctor 
