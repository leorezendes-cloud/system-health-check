#!/bin/bash
set -u

# Handle command-line options
    if [ "$1" = "--help" ]; then
        echo "Usage: ./health-check.sh [computer-name]"
        echo ""
        echo "Runs basic system and network health checks."
        exit 0
    fi

#Set computer name
computer_name="${1:-$(hostname)}"

    if [ -z "$1" ]; then
        echo "No computer name provided. Using hostname."
    fi

overall_status="PASS"

# Check required commands
check_command() {
    if command -v "$1" > /dev/null 2>&1; then
        echo "$1: available"
    else
        echo "$1: NOT FOUND"
        overall status="WARNING"
    fi
}

check_file(){
    if [ -f "$1" ]; then 
        echo "$1: file exists"
    else
        echo "$1: NOT FOUND"
    fi
}
echo "==========================="
echo "    SYSTEM HEALTH CHECK    "
echo "==========================="
echo "Time: $(date)"
echo "Computer : $computer_name"
echo "" 

echo "User: $USER"
echo "Home: $HOME"
echo "Current directory: $(pwd)"
echo ""

# Check disk usage
echo "Disk Space:"
df -h /
disk_usage=$(df -h / | tail -1 | awk '{print $5}' | tr -d '%')

if [ "$disk_usage" -ge 90 ]; then
    echo "WARNING: Disk usage is ${disk-usage}%"
    overall_status="WARNING"
else
    echo "Disk usage: ${disk_usage}% - OK"
fi 

echo ""
echo "Memory Information"
vm_stat

echo ""
echo "IPv4 Addresses:"
ifconfig | grep "inet "

# Check internet connectivity
echo ""
echo "Internet Connectivity:"
if ping -c 4 1.1.1.1 > /dev/null 2>&1; then
    echo "Internet connectivity: OK"
else
    echo "Internet connectivity: FAILED"
    overall_status="WARNING"
fi

# Check DNS resolution
echo ""
echo "DNS Resolution:"
if nslookup google.com > /dev/null 2>&1; then
    echo "DNS resolution: OK"
else
    echo "DNS resolution: FAILED"
    overall_status="WARNING"
fi

echo ""
echo "Default Gateway:"
gateway=$(route -n get default | grep "gateway:" | awk '{print $2}')

if [ -n "$gateway" ]; then
    echo "Default gateway: $gateway"
else
    echo "Default gateway: NOT FOUND"
    overall_satus="WARNING"
fi

echo""
echo "System Information:"
sw_vers
echo "Architecture: $(uname -m)"


commands=(df ping nslookup git brew awk)

for command in "${commands[@]}"
do
    check_command "$command"
done

echo ""
echo "File Checks:"
check_file health-check.sh
check_file README.md

# Display system load
echo ""
echo "System Load:"
uptime

# Display overall status
echo ""
echo "================================="
echo "Overall Status : $overall_status"
echo "================================="

# Return exit status
if [ "$overall_status" = "PASS" ]; then
    exit 0
else
    exit 1
fi
