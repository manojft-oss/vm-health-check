
#!/bin/bash

# -------------------------------
# VM Health Check Script
# -------------------------------

#Threshold
CPU_THRESHOLD=70
MEM_THRESHOLD=600
DISK_THRESHOLD=60
DISK_THRESHOLD_HIGH=80

# ANSI color codes
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Unicode symbols
CHECK='\u2705'       # ✅
CROSS='\u274C'       # ❌
EXCLAMATION='\u2757' # ❗


# Function: Check CPU usage
check_cpu() {
    echo " CPU Check:"
    cpu_idle=$(top -bn1 | grep "Cpu(s)" | awk '{print $8}')
    cpu_usage=$(echo "100 - $cpu_idle" | bc)
    echo "CPU Usage: $cpu_usage%"
    if (( $(echo "$cpu_usage > $CPU_THRESHOLD" | bc -l) )); then
       echo
       printf "\xF0\x9F\x9A\xA8  %s" "$1"
#       echo "  Alert: CPU usage is high"
       echo -e "${YELLOW}${EXCLAMATION} Alert CPU Usage is high ${NC}"
    else
	echo -e "${GREEN}${CHECK} CPU Usage is below threshold ${NC}"
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
#       echo "  Alert: MEM usage is high"
       echo -e "${YELLOW}${EXCLAMATION} Alert Memory Usage is high ${NC}"
    else
       echo -e "${GREEN}${CHECK} Memory Usage is below threshold ${NC}"
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

   if (( $(echo "$disk_percent > $DISK_THRESHOLD_HIGH" | bc -l) )); then
       echo
       echo -e "${RED}${CROSS} Disk Failure${NC}"

    elif (( $(echo "$disk_percent > $DISK_THRESHOLD" | bc -l) )); then
        echo -e "${YELLOW}${EXCLAMATION} Alert Disk Usage is high ${NC}"
    else
       echo -e "${GREEN}${CHECK} Disk Usage is below threshold ${NC}"
    fi


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








