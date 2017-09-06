function Get-OS {
	<#
	.SYNOPSIS
		Returns the version of the operating system being ran on the local or remote machine.
	.EXAMPLE
		Return a remote computer's operating system.
			* C:\PS> Get-OS -ComputerName computer1234
			
		Return the local machine's operating system:
			* C:\PS> Get-OS -ComputerName computer1234
		
	#>
	
	param (
		[Parameter(
			Mandatory = $false,
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
		if ($ComputerName) {
			Write-Host -nonewline "OS: "
			(Get-WmiObject -ComputerName $ComputerName Win32_OperatingSystem).Caption
		} else {
			Write-Host -nonewline "OS: "
			(Get-WmiObject Win32_OperatingSystem).Caption
		}
	}
}