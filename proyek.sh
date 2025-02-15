#!/bin/bash

# Menangani Ctrl+C agar tidak keluar mendadak
trap ctrl_c INT
function ctrl_c() {
    echo -e "\n\e[31m[!] Pemindaian dibatalkan oleh pengguna!\e[0m"
    exit 1
}

echo -e "\e[34m=== TOOL SCANNING JARINGAN ===\e[0m"

# Fungsi validasi input IP/CIDR
function validate_ip() {
    local ip=$1
    local regex="^([0-9]{1,3}\.){3}[0-9]{1,3}(/([0-9]|[12][0-9]|3[0-2]))?$"
    if [[ $ip =~ $regex ]]; then
        return 0  # Valid
    else
        return 1  # Tidak valid
    fi
}

# Meminta input dengan validasi
while true; do
    read -p "Masukkan IP/CIDR: " target
    if validate_ip "$target"; then
        break
    else
        echo -e "\e[31m[!] Format IP/CIDR tidak valid! Coba lagi.\e[0m"
    fi
done

# Menjalankan pemindaian
echo -e "\e[33m[+] Memulai pemindaian...\e[0m"
nmap -sV "$target" > scan_result.txt

# Menampilkan hasil dan memberi warna pada teks tertentu
echo -e "\e[32m[+] Hasil pemindaian:\e[0m"
cat scan_result.txt | grep "open" | sed 's/open/\x1b[31mopen\x1b[0m/g'

echo -e "\e[34m[+] Pemindaian selesai. Hasil disimpan di scan_result.txt\e[0m"
