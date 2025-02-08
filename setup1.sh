#!/bin/bash
set -e

# Fungsi untuk menampilkan pesan
info() {
  echo -e "\033[1;34m[INFO]\033[0m $1"
}
success() {
  echo -e "\033[1;32m[SUCCESS]\033[0m $1"
}

# 1. Optimasi Performa
info "Memperbarui dan mengupgrade paket sistem..."
pkg update -y && pkg upgrade -y

info "Membuat swap file untuk optimasi RAM..."
if [ ! -f $HOME/swapfile ]; then
  dd if=/dev/zero of=$HOME/swapfile bs=1M count=1024
  chmod 600 $HOME/swapfile
  mkswap $HOME/swapfile
  swapon $HOME/swapfile
  echo 'swapon $HOME/swapfile' >> ~/.zshrc
  success "Swap file berhasil dibuat dan diaktifkan."
else
  info "Swap file sudah ada, melewati pembuatan swap file."
fi

info "Membersihkan cache dan file tidak perlu..."
pkg clean
rm -rf ~/.cache/*

# 2. Instalasi Aplikasi yang Direkomendasikan
info "Menginstall aplikasi yang direkomendasikan..."
pkg install -y tmux ranger neovim git termux-api proot-distro openssh

# 3. Optimasi Tampilan
info "Menginstall font Hack untuk tampilan yang lebih baik..."
if ! pkg install -y font-hack 2>/dev/null; then
  info "Paket font-hack tidak tersedia, mengunduh font Hack secara manual..."
  mkdir -p ~/.termux/fonts
  curl -L https://github.com/source-foundry/Hack/releases/download/v3.003/Hack-v3.003-ttf.zip -o ~/Hack-font.zip
  unzip ~/Hack-font.zip -d ~/Hack-font
  cp ~/Hack-font/ttf/*.ttf ~/.termux/fonts/
  rm -rf ~/Hack-font ~/Hack-font.zip
  success "Font Hack berhasil diunduh dan diinstal secara manual."
fi

info "Mengkonfigurasi tema dan styling Termux..."
mkdir -p ~/.termux
cat <<EOL > ~/.termux/termux.properties
# Konfigurasi tema dan font
terminal-transcript-color: true
allow-external-apps: true
use-fullscreen: false
use-black-ui: true
font: Hack-Regular.ttf
EOL
info "Restart Termux untuk menerapkan perubahan tema dan font."

info "Menginstall tema Zsh (powerlevel10k) dan plugin..."
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k
echo 'source ~/powerlevel10k/powerlevel10k.zsh-theme' >> ~/.zshrc
git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting ~/.zsh/zsh-syntax-highlighting
echo 'source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh' >> ~/.zshrc
echo 'source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh' >> ~/.zshrc

# 4. Backup dan Restore
info "Membuat direktori backup..."
mkdir -p ~/termux-backup

info "Membuat script backup otomatis..."
cat <<EOL > ~/termux-backup/backup.sh
#!/bin/bash
tar -zcvf ~/termux-backup/termux-backup-\$(date +%Y%m%d).tar.gz -C /data/data/com.termux/files ./home ./usr
echo "Backup selesai! File backup disimpan di ~/termux-backup/"
EOL
chmod +x ~/termux-backup/backup.sh

info "Membuat script restore otomatis..."
cat <<EOL > ~/termux-backup/restore.sh
#!/bin/bash
if [ -z "\$1" ]; then
  echo "Usage: ./restore.sh <backup-file.tar.gz>"
  exit 1
fi
tar -zxvf \$1 -C /data/data/com.termux/files
echo "Restore selesai!"
EOL
chmod +x ~/termux-backup/restore.sh

# 5. Setup Python dan Tools Cybersecurity
info "Menyiapkan Python Virtual Environment..."
python -m venv $HOME/.venv

info "Menginstall dan mengupgrade Python tools..."
$HOME/.venv/bin/pip install --upgrade pip wheel setuptools

info "Menginstall library Python untuk cybersecurity..."
$HOME/.venv/bin/pip install scapy pycryptodome cryptography paramiko impacket requests beautifulsoup4 colorama rich pwntools pyOpenSSL dnspython ipwhois shodan

# 6. Finalisasi
success "Instalasi selesai!"
echo -e "\nBerikut beberapa hal yang perlu dilakukan:"
echo "1. Tutup dan buka kembali Termux."
echo "2. Jalankan 'zsh' untuk pertama kali dan ikuti panduan setup powerlevel10k."
echo "3. Untuk mengaktifkan Python Virtual Environment, jalankan:"
echo "   source ~/.venv/bin/activate"
echo "4. Untuk membuat backup, jalankan:"
echo "   ~/termux-backup/backup.sh"
echo "5. Untuk merestore backup, jalankan:"
echo "   ~/termux-backup/restore.sh <backup-file.tar.gz>"
