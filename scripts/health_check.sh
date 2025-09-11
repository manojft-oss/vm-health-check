#!/bin/bash

# -------------------------------
# VM Health Check Script
# -------------------------------

#Threshold
CPU_THRESHOLD=4
MEM_THRESHOLD=10
DISK_THRESHOLD=20


# Function: Check CPU usage
check_cpu() {
    echo " CPU Check:"
    cpu_idle=$(top -bn1 | grep "Cpu(s)" | awk '{print $8}')
    cpu_usage=$(echo "100 - $cpu_idle" | bc)
    echo "CPU Usage: $cpu_usage%"
    if (( $(echo "$cpu_usage > $CPU_THRESHOLD" | bc -l) )); then
       echo
       printf "\xF0\x9F\x9A\xA8  %s" "$1"
       echo "  Alert: CPU usage is high"
    fi
    echo


}

# Function: Check Memory usage
check_memory() {
    echo " Memory Check:"
    mem_total=$(free -m | awk '/Mem:/ {print $2}')
    mem_used=$(free -m | awk '/Mem:/ {print $3}')
    mem_percent=$(echo "scale=2; $mem_used / $mem_total * 100" | bc)
    echo "Memory Usage: $mem_used MB / $mem_total MB ($mem_percent%)"
    if (( $(echo "$mem_percent > $MEM_THRESHOLD" | bc -l) )); then
       echo
       printf "\xF0\x9F\x9A\xA8  %s" "$1"
       echo "  Alert: MEM usage is high"
    fi

    echo
}

# Function: Check Disk usage
check_disk() {
    echo " Disk Check:"
    df -h / | awk 'NR==2 {print "Disk Usage: "$5" used on "$6" ("$3" of "$2")"}'
    disk_percentsign=$(df -h / | awk 'NR==2 {print $5}')
        


#    echo "Disk usage with sign is at ${disk_percentsign}"
    disk_percent=${disk_percentsign%\%}
#    echo "Disk usage with sign is at ${disk_percent}"
 
#    echo "------------" 
   if (( $(echo "$disk_percent > $DISK_THRESHOLD" | bc -l) )); then
       echo
       printf "\xF0\x9F\x9A\xA8  %s" "$1"
       echo "  Alert: Disk usage is high"
    fi

    echo
}

# Main function
main() {
    echo "=================================="
    echo "VM Health Check - $(date)"
    echo "=================================="
    check_cpu
    check_memory
    check_disk
    echo "Health check complete."
}

# Execute main
main








