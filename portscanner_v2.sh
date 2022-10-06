#! /bin/bash


# Assigning the Flags to the Varbiables
while getopts  i:p:o: flag
do
	case "${flag}" in
		i) IP=${OPTARG} ;;
		p) PORTS=${OPTARG};;
		o) FileName=${OPTARG};;
	esac
done

if [ -z  $FileName  ]; then
    echo
else 
    FileName=$FileName.txt
    touch  $FileName
fi
YoN=false

# List of Ports
# Option 1
top_10="80 23 554 3306 179 1080 445 161 162 443"
# Option 2
top_50="80 23 554 3306 179 1080 445 161 162 443 7 20 21 22 25 53 69 88 102 110 135 137 139 143 381 383 465 587 593 636 691 902 989 990 995 1025 1194 "
# Option 3 n/a -> Port List must be extended    
top_100="23 554 3306 445 80 5432 443"


results=()


# Set the color variable
green='\033[0;32m'
red='\033[31m'
clear='\033[0m'
# Clear the color after that

# Check which Ports should be scanned
if [ "$PORTS" -eq 1 ]
 then
 	PORTS=$top_10
elif [ "$PORTS" -eq 2 ]
 then
	PORTS=$top_50
else
 echo Wrong Input at Flag [-p]!
 echo You can only choose from [1-2]!
 exit
# elif [ "$PORTS" -eq 3 ]
#  then
# 	PORTS=$top_100
fi

if [ -z $FileName ] ; then
echo Results are not being saved!
	# Port Scan via NetCat without saving it to a file
	# Iterate through PORTS List to Scan those given Ports at the given IP
	echo
	echo Please be patient this could take a while, depending on your Internet Speed! 
	echo " "
		for port in ${PORTS[@]};do
 		    if nc -vz $IP $port &> /dev/null ; then
			    results+="$IP:$port ${green}open${clear}"
 		    else
			    results+="$IP:$port ${red}closed${clear}"
		    fi
		done
	    for res in ${results[@]}; do
	        printf $res
	    done
else
	# normal='echo -en "\e[0m"'
	#Check the Location of the File
	echo Results are being saved to $FileName!

	# Port Scan via NetCat and saving it to a .txt file 
	# Iterate through PORTS List to Scan those given Ports at the given IP
	echo 
	echo >> $FileName
	echo Please be patient this could take a while, depending on your Internet Speed! 
	echo Please be patient this could take a while, depending on your Internet Speed! >> $FileName 
	echo " " 
    echo " " >> $FileName
		for port in ${PORTS[@]};do
 			#echo Checking $IP:$port >> $FileName
	        #sleep 1
 		if nc -vz $IP $port &> /dev/null ; then
		 	results+="$IP:$port ${green}open${clear}"
            echo "$IP:$port open" >> $FileName
			echo >> $FileName
 		else
            results+="$IP:$port ${red}closed${clear}"
			echo "$IP:$port closed" >> $FileName
			echo >> $FileName
		fi
		done
        for res in ${results[@]}; do
            printf $res
        done

fi
printf "${green}Script has Sucessfully executed${clear}!" 