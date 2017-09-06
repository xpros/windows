Function Add-UserToRemoteLocalRDPGroup {
	<#
	.SYNOPSIS
		Will add a user to the Remote Desktop Users Group.
	.EXAMPLE
		C:\PS> Add-UserToRemoteLocalGroup -ComputerName <computername> -Username <username>
	#>

	Param (
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $true)]
		[string] $ComputerName,
        [Parameter(
			Mandatory = $true,
			ValueFromPipeline = $true)]
		[string] $Username
	) 
	Process {
        $DOMAIN = "MATTHASSEL"
        $GROUP = "Remote Desktop Users"
        If (!(Test-Connection -Count 1 -Quiet -ComputerName $Computername)){}
        Else {
            # iGet AD object (also tests whether object exsts)
            $objADUser = Get-ADUser $Username
            if (!($objADUser)){}
            Else { # Create ADSI User Object
                $objUser = [ADSI]("WinNT://$DOMAIN/$Username")
            }
            # Create ADSI Group Object
            $objGroup = [ADSI]("WinNT://$ComputerName/$GROUP")
        }
        # Add user to local Remote Desktop Users Group
        $objGroup.PSBase.Invoke("Add",$objUser.PSBase.Path)
        Write-Host "$Username has been added to $GROUP group of $ComputerName." -ForegroundColor Green
    }
}

Function Remove-UserFromRemoteLocalRDPGroup {
    <#
	.SYNOPSIS
		Will remove a user from the Remote Desktop Users Group.
	.EXAMPLE
		C:\PS> Remove-UserFromRemoteLocalRDPGroup -ComputerName <computername> -Username <username>
	#>

	Param (
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $true)]
		[string] $ComputerName,
        [Parameter(
			Mandatory = $true,
			ValueFromPipeline = $true)]
		[string] $Username
	) 
	Process {
        $DOMAIN = "MATTHASSEL"
        $GROUP = "Remote Desktop Users"
        If (!(Test-Connection -Count 1 -Quiet -ComputerName $Computername)){}
        Else {
            # iGet AD object (also tests whether object exsts)
            $objADUser = Get-ADUser $Username
            if (!($objADUser)){}
            Else { # Create ADSI User Object
                $objUser = [ADSI]("WinNT://$DOMAIN/$Username")
            }
            # Create ADSI Group Object
            $objGroup = [ADSI]("WinNT://$ComputerName/$GROUP")
        }
        # Add user to local Remote Desktop Users Group
        $objGroup.PSBase.Invoke("Remove",$objUser.PSBase.Path)
        Write-Host "$Username has been removed from $GROUP group of $ComputerName." -ForegroundColor Green
    }
}

Function Get-UserFromRemoteLocalRDPGroup {
    <#
	.SYNOPSIS
		Will list users from the Remote Desktop Users Group.
	.EXAMPLE
		C:\PS> Get-UserFromRemoteLocalRDPGroup -ComputerName <computername>
	#>

	Param (
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $true)]
		[string] $ComputerName
	) 
	Process {
        $DOMAIN = "MATTHASSEL"
        $GROUP = "Remote Desktop Users"
        If (!(Test-Connection -Count 1 -Quiet -ComputerName $Computername)){}
        Else {
            # Create ADSI Group Object
            $objGroup = [ADSI]("WinNT://$ComputerName/$GROUP")
        }
        # Add user to local Remote Desktop Users Group
        $Members = $objGroup.PSBase.Invoke("Members")
        if ($Members){
            Write-Host "The following users are of the local $GROUP group of machine $ComputerName." -ForegroundColor Gray
            foreach ($member in $Members) {
                $user = $member.GetType().InvokeMember("Name", 'GetProperty', $null, $member, $null)
                Write-Host $user -ForegroundColor Magenta
            }
        }
        Else { # This logic doesn't actually work at the moment. Need a good way to test whether $Members has any $members.
            Write-Host "No users are of the local $GROUP group of machine $ComputerName." -ForegroundColor DarkRed
        }
    }
}