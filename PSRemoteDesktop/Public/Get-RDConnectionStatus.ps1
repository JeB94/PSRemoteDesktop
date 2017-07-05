function Get-RDConnectionStatus {
    #Requires -RunAs
    [CmdletBinding()]
    param (

        [parameter(Position = 0)]
        [String[]]
        $ComputerName = "Localhost",

        [pscredential]
        $Credential

    )


    $Command = {
        Write-Verbose "Retrieving remote desktops status on $($ENV:ComputerName)"
        $Value = (Get-ItemProperty -path "HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\" -Name fdenytsconnections).fdenytsconnections

        $dicValues = @{
            0 = "ENABLED"
            1 = "DISABLED"
        }

        $Output = @{
            Status       = $dicValues[$Value]
            ComputerName = $Env:ComputerName
        }

        Write-Verbose "Outputting status"
        [PSCustomObject]$Output

    } # script block

    Foreach ($Computer in $ComputerName) {
        Write-Verbose "Connecting to $Computer"
        $Params = @{
            ComputerName     = $Computer
            ScriptBlock      = $Command
            HideComputerName = $True
        } # hashtable

        IF ($Computer -match "Localhost|$($env:computername)") {
            $Params.remove("ComputerName")
            $Params.Remove("HideComputerName")
        }
        elseIF ($PSBoundParameters.ContainsKey("Credential")) {
            $Params.credential = $Credential
        } # if

        try {
            Invoke-Command @Params -ErrorAction Stop
        }
        catch {
            Write-Error $_
        }
    }

}
