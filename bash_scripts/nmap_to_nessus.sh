#!/bin/bash

#need to set the homedir based on the client name
HomeDirNMAP=/root/coyote/NMAPscans
HomeDirNessus=/root/coyote/Nessus
HOMEDIR=/root/coyote/Scope


while IFS=, read internal network subnetSize location hostExpectedOnline; do
        network_ID=${network%/*}
        CIDR=${network##*/}
        outputFileName="$network_ID"_"$CIDR"
        outputFileNameXML=$outputFileName.xml
        outputFileNameGrep=$outputFileName.gnmap
        outputFileNameNESSUS=$outputFileName.nessus
        nmap -sTU -sV --top-ports=200 $network -oA $HomeDirNMAP/$outputFileName
        status=$?
        if [ $status -ne 0]; then
                break
        fi
        actualHostFoundOnline=`cat $HomeDirNMAP/$outputFileNameGrep | grep "Status: Up" | wc -l`
        python /usr/local/bin/nmap2ness.py -s 127.0.0.1 -u admin -p nessusscanner -i $HomeDirNMAP/outputFileNameXML -t basic_network_scan -o $HomeDirNessus/$outputFileNameNESSUS
        echo "$network","$location","$hostExpectedOnline","$actualHostFoundOnline",`date` >> $HOMEDIR/completed_scans/project_completed_scan.txt

done < $HOMEDIR/todays_scan.txt
