#!/bin/bash

# nmap wrapper for efficiency

IP="$1"
# Create nmap directory if it doesn't exist
mkdir -p nmap

# Define a function for each scan
quick_scan() {
 nmap -sC -sV -oA nmap/quick_scan -vv "$IP"
 echo "[o/] quick_scan completed!"
}

syn_scan() {
 sudo nmap -sS -p- -oA nmap/syn_scan -vv "$IP"
 echo "[o/] syn_scan completed!"
}

quick_udp() {
 sudo nmap -sU --open --top-ports 20 -o nmap/quick_udp -vv "$IP"
 echo "[o/] quick_udp completed!"
}

full_udp() {
 sudo nmap -sU -p- -o nmap/full_udp -vv "$IP"
 echo "[o/] full_udp completed!"
}

rated_scan() {
 ports=$(nmap -p- --min-rate=1000 "$IP" | grep ^[0-9] | cut -d '/' -f 1 | tr '\n' ',' | sed s/,$//)
 nmap -sC -sV --reason -T4 -oA nmap/services -p"$ports" "$IP" -vvv
 echo "[o/] rated_scan completed!"
}

# Execute the functions concurrently
echo "[+] Running quick_scan..."
quick_scan &

echo "[+] Running syn_scan..."
syn_scan &

echo "[+] Running quick_udp..."
quick_udp &

echo "[+] Running full_udp..."
full_udp &

echo "[+] Running rated_scan..."
rated_scan &

# Wait for all background processes to finish
wait

echo "[ C'est fini les ami/es ]"
