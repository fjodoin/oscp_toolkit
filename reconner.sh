#!/bin/bash
# Get current date and time for timestamping the output files
timestamp=$(date +"%Y%m%d_%H%M%S")
# Get the hostname and username
hostname=$(hostname)
username=$(whoami)
# Set the output directory and file name
outputDir="/tmp"
outputFile="$outputDir/${hostname}_${username}_reconner.txt"
# Define the commands to execute
commands=(
 "hostname"
 "whoami && id"
 "sudo --version"
 "cat /etc/issue"
 "uname -r"
 "arch"
 "cat /etc/passwd"
 "find / -perm -4000 -type f 2>/dev/null"
 "groups"
 "cat /etc/group"
 "find / -perm -g=s -type f 2>/dev/null"
 "ip addr show"
 "netstat -tuln"
 "ip route show"
 "arp -a"
 "iptables -L"
 "find /home -type f \( -iname '*.git' -o -iname '*.php' -o -iname '*.log' -o -iname '*.conf' -o -iname '*.config'-o -iname '*.sh' -o -iname '*.txt' -o -iname '*.pdf' -o -iname '*.kdbx' -o -iname '*.pem' -o -iname '*id_rsa' -o -iname '*.db' \) 2>/dev/null"
 "find /var -type f \( -iname '*.git' -o -iname '*.php' -o -iname '*.log' -o -iname '*.conf' -o -iname '*.config' -o -iname '*.sh' -o -iname '*.txt' -o -iname '*.pdf' -o -iname '*.kdbx' -o -iname '*.pem' -o -iname '*.db' \) 2>/dev/null"
 "find /etc -type f \( -iname '*.git' -o -iname '*.php' -o -iname '*.log' -o -iname '*.conf'-o -iname '*.config' -o -iname '*.sh' -o -iname '*.txt' -o -iname '*.pdf' -o -iname '*.kdbx' -o -iname '*.pem' -o -iname '*.db' \) 2>/dev/null"
 "ls -la /home/* 2>/dev/null && /var/www/* 2>/dev/null"
 "ps -eo user,pid,ppid,cmd --sort=user -U root"
 "cat /etc/crontab"
 "grep 'CRON' /var/log/syslog"
 "cat /etc/systemd/system/*.service"
 "dpkg -l"
)
# Execute commands and append output to the reconner.txt file
for command in "${commands[@]}"; do
 echo "Running: $command"
 echo "-------------------------------" >> "$outputFile"
 echo "Output for: $command" >> "$outputFile"
 echo "-------------------------------" >> "$outputFile"
 echo "" >> "$outputFile"
 output=$(eval "$command" 2>/dev/null)
 if [ $? -eq 0 ]; then
   echo "$output" >> "$outputFile"
 else
   echo "Command failed: $output" >> "$outputFile"
 fi
 echo "" >> "$outputFile"
done
if [ -s "$outputFile" ]; then
 echo "Reconner script completed. Output file saved at: $outputFile"
else
 echo "No output generated. Check for errors."
fi
