#!/bin/bash

YELLOW='\033[1;33m'
NC='\033[0m' # No Color

log () {
    echo -e "${YELLOW}==========================${NC}"
    echo -e "${YELLOW}==========================${NC}"
    echo -e "${YELLOW} $1 ${NC}"
    echo -e "${YELLOW}==========================${NC}"
    echo -e "${YELLOW}==========================${NC}"
}

################################################################################
# Update system
################################################################################

log "Update system"
export DEBIAN_FRONTEND=noninteractive
apt-mark hold keyboard-configuration
apt-get update
apt-get -y upgrade
apt-mark unhold keyboard-configuration

################################################################################
# Install the mandatory tools
################################################################################

# Install utilities
log "Install utilities"
apt-get -y install vim git zip bzip2 fontconfig curl language-pack-en

# Install Node.js
log "Install Nodejs"
wget https://nodejs.org/dist/v12.13.1/node-v12.13.1-linux-x64.tar.gz -O /tmp/node.tar.gz
tar -C /usr/local --strip-components 1 -xzf /tmp/node.tar.gz

# Update NPM
log "Install NPM"
npm install -g npm

# Install Yarn
log "Install Yarn"
npm install -g yarn
su -c "yarn config set prefix /home/vagrant/.yarn-global" vagrant

# Force encoding
log "Force encoding to english"
echo 'LANG=en_US.UTF-8' >> /etc/environment
echo 'LANGUAGE=en_US.UTF-8' >> /etc/environment
echo 'LC_ALL=en_US.UTF-8' >> /etc/environment
echo 'LC_CTYPE=en_US.UTF-8' >> /etc/environment

# Set timezone to Paris
log "Set timezone to Europe/Paris"
timedatectl set-timezone Europe/Paris

# Set keyboard to fr
log "Set AZERTY keyboard"
L='fr' && sed -i -e 's/XKBLAYOUT=\"\w*"/XKBLAYOUT=\"'$L'\"/g' /etc/default/keyboard

# Run GUI as non-privileged user
log "Allow GUI"
echo 'allowed_users=anybody' > /etc/X11/Xwrapper.config

# Install Ubuntu desktop and VirtualBox guest tools
log "Install Desktop and guest additions"
apt-get install -y xubuntu-desktop virtualbox-guest-dkms virtualbox-guest-utils virtualbox-guest-x11

# Remove light-locker (see https://github.com/jhipster/jhipster-devbox/issues/54)
log "Uninstall light-locker"
apt-get remove -y light-locker --purge

################################################################################
# Install the development tools
################################################################################

# Install Snap Linux
log "Install Snap"
apt-get install -y snapd

# Install Chromium Browser
log "Install Chromium"
apt-get install -y chromium-browser

# Install Heroku toolbelt
log "Install Heroku client"
wget -O- https://toolbelt.heroku.com/install-ubuntu.sh | sh

# Install Guake
log "Install Guake"
apt-get install -y guake
cp /usr/share/applications/guake.desktop /etc/xdg/autostart/

# Install zsh
log "Install ZSH"
apt-get install -y zsh

# Install oh-my-zsh
log "Install Oh My ZSH"
git clone https://github.com/ohmyzsh/ohmyzsh.git /home/vagrant/.oh-my-zsh
cp /home/vagrant/.oh-my-zsh/templates/zshrc.zsh-template /home/vagrant/.zshrc
chsh -s /bin/zsh vagrant
echo 'SHELL=/bin/zsh' >> /etc/environment

# Install oh-my-zsh themes and plugins
log "Configure Oh My Zsh"
apt-get install -y fonts-powerline
git clone https://github.com/bhilburn/powerlevel9k.git /home/vagrant/.oh-my-zsh/custom/themes/powerlevel9k
sed -i -e "s/plugins=(git)/plugins=(git docker docker-compose)/g" /home/vagrant/.zshrc
sed -i -e 's/ZSH_THEME="robbyrussell"/ZSH_THEME="powerlevel9k\/powerlevel9k"/g' /home/vagrant/.zshrc
echo 'export PATH="$PATH:/usr/bin:/home/vagrant/.yarn-global/bin:/home/vagrant/.yarn/bin:/home/vagrant/.config/yarn/global/node_modules/.bin"' >> /home/vagrant/.zshrc

# Change user to vagrant
chown -R vagrant:vagrant /home/vagrant/.zshrc /home/vagrant/.oh-my-zsh

# Install IDEs
log "Install IDEs"
snap install code --classic
snap install pycharm-professional --classic

# Increase Inotify limit (see https://confluence.jetbrains.com/display/IDEADEV/Inotify+Watches+Limit)
echo "fs.inotify.max_user_watches = 524288" > /etc/sysctl.d/60-inotify.conf
sysctl -p --system

# Install latest Docker
log "Install Docker"
curl -sL https://get.docker.io/ | sh

# Install latest Docker-compose
log "Install Docker Compose"
curl -L "https://github.com/docker/compose/releases/download/1.25.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

# Configure docker group
usermod -aG docker vagrant

# Install Miniconda
log "Install Miniconda"
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda.sh
bash ~/miniconda.sh -b -p /miniconda
rm ~/miniconda.sh

################################################################################
# Configure
################################################################################

log "Configure stuff"

# Fix ownership of home
chown -R vagrant:vagrant /home/vagrant/

# Allow vagrant to do sudo operations
adduser vagrant sudo
chown -R vagrant:vagrant /home/vagrant

################################################################################
# Cleaning
################################################################################

# Clean the box
log "Cleaning ..."
apt-get -y autoclean
apt-get -y clean
apt-get -y autoremove
dd if=/dev/zero of=/EMPTY bs=1M > /dev/null 2>&1
rm -f /EMPTY
