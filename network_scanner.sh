#!/bin/bash

# nmap wrapper for efficiency

IP="$1"
# Create nmap directory if it doesn't exist
mkdir -p nmap
# Execute the commands with the provided IP
{
 nmap -sC -sV -oA nmap/quick_scan -vv "$IP" &
 pid1=$!
 echo "[+] Running quick_scan..."
 # Start a timer for the first process
 while kill -0 $pid1 >/dev/null 2>&1; do
 echo -n "."
 sleep 1
 done
 echo "[o/] quick_scan completed!"
} &
{
 sudo nmap -sS -p- -oA nmap/syn_scan -vv "$IP" &
 pid2=$!
echo "[+] Running syn_scan..."
 # Start a timer for the second process
while kill -0 $pid2 >/dev/null 2>&1; do
 echo -n "."
 sleep 1
 done
 echo "[o/] syn_scan completed!"
} &
{
 sudo nmap -sU --open --top-ports 20 -o nmap/quick_udp -vv "$IP" &
 pid3=$!
 echo "[+] Running quick udp..."
 # Start a timer for the third process
 while kill -0 $pid3 >/dev/null 2>&1; do
 echo -n "."
 sleep 1
 done
 echo "[o/] udp completed!"
} &
{
 sudo nmap -sU -p- -o nmap/full_udp -vv "$IP" &
 pid3=$!
 echo "[+] Running full udp..."
 # Start a timer for the third process
 while kill -0 $pid3 >/dev/null 2>&1; do
 echo -n "."
 sleep 1
 done
 echo "[o/] udp completed!"
} &
echo "[+] Running rated scan!"
ports=$(nmap -p- --min-rate=1000 "$IP" | grep ^[0-9] | cut -d '/' -f 1 | tr '\n' ',' | sed
s/,$//)
echo "[+] Checking services!"
nmap -sC -sV --reason -T4 -oA nmap/services -p"$ports" "$IP" -vvv
echo "[ C'est fini les ami/es ]'
