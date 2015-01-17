#!/bin/bash
#Things to add - rpcinfo script

ports=(21 80 110 445)
serviceList=( ftp http rpcbind netbios-ssn microsoft-ds )
ip=$1
last_two=`echo $ip | awk -F '[.]' '{print $3"_"$4;}' `

if [ -z "$1" ]; then
        echo "[*] Initial survey script that was written for offsec course"
        echo "[*] useage        : $0 <ip address> "
        exit 0
fi


#Scan for top twenty ports. Save file as nmap_scan.txt
nmap -sTU --top-ports=20 $ip -oN nmap_scan.txt

#Grab version info for top twenty ports and save to file
nmap -sTU --top-ports=20 -sV $ip -oN nmap_scan_version.txt &

for service in ${serviceList[@]}; do
        grep -w $service nmap_scan.txt | grep open
        exitCode=$?
        if [ $exitCode == 0 ]; then
                if [ $service  == ftp ]; then
                        nmap --script=ftp-anon $ip -oN ftp_anon_scan.txt
                elif [ $service == http ]; then
                        nikto -host $ip -output nikto_scan_output.txt
                        nc -v -z1 $ip > banner_grab.txt
                elif [ $service == rpcbind]; then 
                        nmap --script=rpcinfo $ip -oN rpcinfo_scan.txt
                elif [ $service == netbios-ssn ]; then
                        echo "do port 445 scans"
                        nmap --script=smb-check-vulns $ip smb-check-vulns --script-args=unsafe=1 -oN smb_vul_scan.txt
                        nmap --script=smb-os-discovery $ip -oN nmap_smb_os_discovery.txt
                        
                        rpcclient -U "" -N $ip -c exit
                        exitCode=$?
                        if [ $exitCode == 0 ]; then
                                enum4linux $ip > enum4linux_out.txt
                        fi
                fi

        fi
done

#Check for snmp regardless of whether nmap shows port open or not
onesixtyone $ip public -o snmpcheck.txt

