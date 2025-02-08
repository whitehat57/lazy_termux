#!/bin/bash

set -e

# Update dan upgrade paket
echo "Memperbarui dan mengupgrade paket sistem..."
pkg update -y && pkg upgrade -y

# Install paket utama
echo "Menginstall paket utama..."
pkg install -y python golang nodejs zsh nmap curl clang libffi libxml2 libxslt openssl

# Setup Zsh sebagai shell default
echo "Mengkonfigurasi Zsh..."
chsh -s zsh

# Install Oh My Zsh
echo "Menginstall Oh My Zsh..."
RUNZSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Install Python Virtual Environment
echo "Menyiapkan Python Virtual Environment..."
python -m venv $HOME/.venv

# Install dan upgrade Python tools
echo "Menginstall dan mengupgrade Python tools..."
pip install --upgrade pip wheel setuptools

# Install library Python untuk cybersecurity
echo "Menginstall library Python untuk cybersecurity..."
pip install scapy pycryptodome cryptography paramiko impacket requests beautifulsoup4 colorama rich

# Install tools dan library tambahan untuk keamanan
echo "Menginstall tools dan library tambahan..."
pip install pwntools pyOpenSSL dnspython ipwhois shodan

# Setup environment variables untuk Go
echo "Mengkonfigurasi Go environment..."
echo 'export GOPATH=$HOME/go' >> $HOME/.zshrc
echo 'export PATH=$PATH:$GOPATH/bin' >> $HOME/.zshrc
mkdir -p $HOME/go/{bin,src,pkg}

# Finalisasi
echo -e "\n\033[1;32mInstalasi selesai!\033[0m"
echo "Silakan lakukan berikut:"
echo "1. Tutup dan buka kembali Termux"
echo "2. Jalankan 'zsh' untuk pertama kali"
echo "3. Untuk Python Virtual Environment: 'source ~/.venv/bin/activate'"
