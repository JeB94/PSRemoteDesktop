function Disable-RDConnection {
    #Requires -RunAs
    [CmdletBinding()]
    param (
        [parameter(Position = 0)]
        [String[]]
        $ComputerName = "Localhost",

        [pscredential]
        $Credential

    )
    $Command = { Set-ItemProperty -path "HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\" -Name fdenytsconnections -Value '1' }
    Foreach ($Computer in $ComputerName) {
        try {
            Write-Verbose "Disabling Remote Desktop connection on $Computer"
            $Params = @{
                ScriptBlock  = $Command
                ComputerName = $Computer
            } # hashtable


            IF ($Computer -match "Localhost|$($env:computername)" ) {
                $Params.remove("ComputerName")
            }
            elseif ($PSBoundParameters.ContainsKey("Credential")) {
                $Params.credential = $Credential
            } # if

            Invoke-Command @Params -ErrorAction Stop
            Write-Verbose "Disabled Remote Desktop connection on $Computer"

        }
        catch {
            Write-Error $_
        }
    } # foreach
} # function