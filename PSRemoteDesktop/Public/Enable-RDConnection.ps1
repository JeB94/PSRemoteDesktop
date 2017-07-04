function Enable-RDConnection {
    #Requires -RunAs
    [CmdletBinding()]
    param (

        [parameter(Position = 0)]
        [String[]]
        $ComputerName = "Localhost",

        [PScredential]
        $Credential

    )
    $Command = { Set-ItemProperty -path "HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\" -Name fdenytsconnections -Value '0' }

    Foreach ($Computer in $ComputerName) {
        try {
            Write-Verbose "Enabling Remote Desktop connection on $Computer"
            $Params = @{
                ScriptBlock  = $Command
                ComputerName = $Computer
            } # hashtable

            IF ($Computer -match "Localhost|$($env:computername)") {
                $Params.remove("ComputerName")
            }
            elseif ($PSBoundParameters.ContainsKey("Credential")) {
                $Params.credential = $Credential
            } # if
            Invoke-Command @Params -ErrorAction Stop
            Write-Verbose "Enabled remote desktop on $computer"
        }
        catch {
            Write-Error $_
        }
    } # foreach
} # function
