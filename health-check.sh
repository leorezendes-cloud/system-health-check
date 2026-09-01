#!/bin/bash
echo "==========================="
echo "    SYSTEM HEALTH CHECK    "
echo "==========================="
echo "Time: $(date)"
echo "" 

echo "User: $USER"
echo "Home: $HOME"
echo "Current directory: $(pwd)"
echo ""

echo "Disk Space:"
df -h / 

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
fi

echo ""
echo "DNS Resolution:"
if nslookup google.com > /dev/null 2>&1; then
    echo "DNS resolution: OK"
else
    echo "DNS resolution: FAILED"
fi

echo ""
echo "Default Router:"
route -n get default | grep "gateway:"

echo""
echo "System Information:"
sw_vers
echo "Architecture: $(uname -m)"
