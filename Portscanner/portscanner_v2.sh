#!/bin/bash

# Ensure the Scanner_Results directory exists
mkdir -p ./Scanner_Results

# Display introductory message
echo "Starting port scanner..."
echo "Scanning will begin shortly. Please wait as the script checks host reachability and scans the specified ports."

# Assigning the Flags to the Variables
while getopts i:p:o:r: flag
do
    case "${flag}" in
        i) IP=${OPTARG} ;;
        p) PORTS=${OPTARG};;
        o) FileName=${OPTARG};;
        r) RANGE=${OPTARG};;
    esac
done

# Handle file naming
if [ -n "$FileName" ]; then
    FileName="./Scanner_Results/${FileName}.txt"
    touch "$FileName"
fi

# List of Ports
top_10="80 23 554 3306 179 1080 445 161 162 443"
top_50="80 23 554 3306 179 1080 445 161 162 443 7 20 21 22 25 53 69 88 102 110 135 137 139 143 381 383 465 587 593 636 691 902 989 990 995 1025 1194 5432 5900 5984 6379 7000 8000 8080 8443 3389 27017 9092"
top_100="80 23 554 3306 179 1080 445 161 162 443 7 20 21 22 25 53 69 88 102 110 135 137 139 143 381 383 465 587 593 636 691 902 989 990 995 1025 1194 5432 5900 5984 6379 7000 8000 8080 8443 3389 27017 9092 11211 4444 8081 5000 8888 7070 6660-6669 9898 1521 3148 15672 5433 9000 9100 8008 6378 8082 7071 9001 9191 6000-6005 54321 5001 4880 6666 8084 33060 5800 6370 29015 15000 5003 9002 8983 5353 5500 7200 10100 7443 25000 8889 5120 9003 8484 3307 3080 51820 8083 8500 4422"

# Port descriptions mapping
declare -A PORT_DESCRIPTIONS
PORT_DESCRIPTIONS=(
    [80]="HTTP"
    [23]="Telnet"
    [554]="RTSP"
    [3306]="MySQL"
    [179]="BGP"
    [1080]="SOCKS"
    [445]="SMB"
    [161]="SNMP"
    [162]="SNMPTRAP"
    [443]="HTTPS"
    [7]="Echo"
    [20]="FTP Data"
    [21]="FTP Control"
    [22]="SSH"
    [25]="SMTP"
    [53]="DNS"
    [69]="TFTP"
    [88]="Kerberos"
    [102]="ISO-TP0"
    [110]="POP3"
    [135]="MS RPC"
    [137]="NetBIOS Name"
    [139]="NetBIOS Session"
    [143]="IMAP"
    [381]="HP OpenView"
    [383]="HP OpenView"
    [465]="SMTPS"
    [587]="SMTP (STARTTLS)"
    [593]="HTTP RPC"
    [636]="LDAP (SSL)"
    [691]="MS SQL"
    [902]="VMWare"
    [989]="FTPS Data"
    [990]="FTPS Control"
    [995]="POP3S"
    [1025]="NFS"
    [1194]="OpenVPN"
    [5432]="PostgreSQL"
    [5900]="VNC"
    [5984]="CouchDB"
    [6379]="Redis"
    [7000]="Asterisk"
    [8000]="HTTP Alternative"
    [8080]="HTTP Alternative"
    [8443]="HTTPS Alternative"
    [3389]="RDP"
    [27017]="MongoDB"
    [9092]="Kafka"
    [11211]="Memcached"
    [4444]="Metasploit"
    [8081]="HTTP Alternative"
    [5000]="Flask"
    [8888]="Jupyter"
    [7070]="RealPlayer"
    [6660-6669]="IRC"
    [9898]="Gemalto"
    [1521]="Oracle"
    [3148]="Backup"
    [15672]="RabbitMQ"
    [5433]="PostgreSQL"
    [9000]="SonarQube"
    [9100]="Printer"
    [8008]="HTTP Alternative"
    [6378]="Redis Sentinel"
    [8082]="HTTP Alternative"
    [7071]="RealPlayer"
    [9001]="Tor"
    [9191]="FreePBX"
    [6000-6005]="X11"
    [54321]="Telnet"
    [5001]="iPerf"
    [4880]="Couchbase"
    [6666]="IRC"
    [8084]="HTTP Alternative"
    [33060]="MySQL"
    [5800]="VNC"
    [6370]="Redis"
    [29015]="MongoDB"
    [15000]="Lightwave"
    [5003]="VNC"
    [9002]="Hadoop"
    [8983]="Solr"
    [5353]="mDNS"
    [5500]="VNC"
    [7200]="P4D"
    [10100]="Timescale"
    [7443]="HTTPS Alternative"
    [25000]="Mumble"
    [8889]="Anaconda"
    [5120]="Affinity"
    [9003]="IntelliJ"
    [8484]="HTTP Alternative"
    [3307]="MySQL"
    [3080]="HTTP Alternative"
    [51820]="WireGuard"
    [8083]="HTTP Alternative"
    [8500]="HTTP Alternative"
    [4422]="HTTP Alternative"
)

# Function to handle port lists based on the flag
get_ports() {
    case $PORTS in
        1) echo "$top_10" ;;
        2) echo "$top_50" ;;
        3) echo "$top_100" ;;
        *) echo "Invalid port list requested"; exit 1 ;;
    esac
}

# Set the color variables
green='\033[0;32m'
red='\033[31m'
clear='\033[0m'

# Function to check if an IP is reachable
ping_host() {
    local ip=$1
    if ping -c 1 $ip &> /dev/null; then
        return 0
    else
        return 1
    fi
}

# Retrieve the list of ports
PORTS=$(get_ports)
IFS=' ' read -r -a PORT_ARRAY <<< "$PORTS"

# Function to scan a single IP address
scan_ip() {
    local ip=$1
    local results=()
    
    echo "Scanning IP: $ip"
    
    # Check if the IP is reachable
    if ping_host $ip; then
        echo -e "\nScanning results for $ip:\n"
        
		# Create and print the table header
		if [ -n "$FileName" ]; then
			echo "|¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯|¯¯¯¯¯¯¯¯¯|" >> "$FileName"
			printf "| %-23s | %-7s |\n" "Ports" "Status" >> "$FileName"
			printf "|%-25s|%-7s|\n" "-------------------------" "---------" >> "$FileName"
		fi
		echo "|¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯|¯¯¯¯¯¯¯¯¯|"
		printf "| %-23s | %-7s |\n" "Ports" "Status"
		printf "|%-25s|%-7s|\n" "-------------------------" "---------"


        # Port Scan via NetCat
        for port in "${PORT_ARRAY[@]}"; do
            description=${PORT_DESCRIPTIONS[$port]:-$port}
            if nc -vz $ip $port &> /dev/null ; then
                result="$ip:$port ($description) open"
                results+=("$result")
                printf "| %-23s | %b%-7s%b |\n" "$port ($description)" "${green}" "open" "${clear}"
                if [ -n "$FileName" ]; then
                    printf "| %-23s | %b%-7s%b |\n" "$port ($description)" "open" >> "$FileName"
                fi
            else
                result="$ip:$port ($description) closed"
                results+=("$result")
                printf "| %-23s | %b%-7s%b |\n" "$port ($description)" "${red}" "closed" "${clear}"
                if [ -n "$FileName" ]; then
                    printf "| %-23s | %b%-7s%b |\n" "$port ($description)" "closed" >> "$FileName"
                fi
            fi
		    
				printf "|%-25s|%-7s|\n" "-------------------------" "---------"

        done

       	# Footer line and new line
		if [ -n "$FileName" ]; then
			printf "|%-25s|%-7s|\n" "----------------------" "---------" >> "$FileName"
			echo "" >> "$FileName"  # Add a new line after the table footer in the file
		fi
		echo ""  # Add a new line after the table footer in the console output
    else
        echo "Host $ip is not reachable"
		echo ""
		
        if [ -n "$FileName" ]; then
            echo "Host $ip is not reachable" >> "$FileName"
			echo "" >> "$FileName"
        fi
    fi
}

# Function to scan a range of IP addresses
scan_range() {
    local base_ip=$1
    local start=$2
    local end=$3
    for i in $(seq $start $end); do
        local ip="$base_ip.$i"
        scan_ip $ip
    done
}

# Check if a range is provided
if [ -n "$RANGE" ]; then
    IFS='-' read -r start end <<< "$RANGE"
    base_ip=$(echo $IP | cut -d'.' -f1-3)
    scan_range $base_ip $start $end
else
    scan_ip $IP
fi

printf "${green}Script has successfully executed${clear}!\n"
