function Get-RemoteSessions {
	<#
	.SYNOPSIS
		Returns a list of logged on users of a remote system.
	.EXAMPLE
		C:\PS> Get-RemoteSessions -ComputerName computer1234 -Logoff
	#>
	
	param (
		[Parameter(
			Mandatory = $true,
			Position = 0,
			ValueFromPipeline = $true)]
		[string] $ComputerName,
		[Parameter(
			Mandatory = $false,
			Position = 1,
			ValueFromPipeline = $false)]
		[switch] $Logoff
	)
	Process {
		quser.exe /SERVER:$ComputerName
		
		if ($Logoff) {
			$SessionID = Read-Host "Logoff SessionID"
			if ($SessionID -ne "") {
			logoff.exe $SessionID /SERVER:$ComputerName
			$Message = "INFO: SessionID " + $SessionID + " logged off."
			Write-Host $Message -ForegroundColor Yellow -BackgroundColor Black
			} else {
				Write-Error "SessionID Required."				
			}
		}
	}
}