#!/bin/bash

    if [ "$1" = "--help" ]; then
        echo "Usage: ./health-check.sh [computer-name]"
        echo ""
        echo "Runs basic system and network health checks."
        exit 0
    fi

computer_name="${1:-$(hostname)}"

    if [ -z "$1" ]; then
        echo "No computer name provided. Using hostname."
    fi

overall_status="PASS"

check_command() {
    if command -v "$1" > /dev/null 2>&1; then
        echo "$1: available"
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

echo ""
echo "Internet Connectivity:"
if ping -c 4 1.1.1.1 > /dev/null 2>&1; then
    echo "Internet connectivity: OK"
else
    echo "Internet connectivity: FAILED"
    overall_status="WARNING"
fi

echo ""
echo "DNS Resolution:"
if nslookup google.com > /dev/null 2>&1; then
    echo "DNS resolution: OK"
else
    echo "DNS resolution: FAILED"
    overall_status="WARNING"
fi

echo ""
echo "Default Router:"
route -n get default | grep "gateway:"

echo""
echo "System Information:"
sw_vers
echo "Architecture: $(uname -m)"

echo ""
echo "Required Commands:"
check_command df
check_command ping
check_command nslookup
check_command git
check_command brew

echo ""
echo "System Load:"
uptime

echo ""
echo "================================="
echo "Overall Status : $overall_status"
echo "================================="
