function Add-RDUser {
    <#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER alguno

    .EXAMPLE

    .NOTES

#>

    #Requires -RunAs
    [CmdletBinding()]
    param (

        [parameter(Position = 0)]
        [String]
        $ComputerName = "Localhost" ,

        [Parameter(Mandatory)]
        [Alias("Username", "Identity")]
        [String[]]
        $Member ,

        [PSCredential]
        $Credential

    )
    process {

        $Action = "Add"
        $Command = @{
            Action = $Action
            Member = $Member
        }

        $Params = @{
            ComputerName = $ComputerName
        } # hashtable

        IF ($ComputerName -match "Localhost|$($env:computername)") {
            $Params.remove("ComputerName")
            $Command.IsLocal = $true
        } # if
        ELSEIF ($PSBoundParameters.ContainsKey("Credential")) {
            $Params.credential = $Credential
        } # elseif

        $Params.ScriptBlock = Set-LGroup @Command

        try {
            Invoke-Command @Params -ErrorAction Stop
        }
        catch {
            Write-Error $_
        }
    }
}
