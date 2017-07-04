function Remove-RDUser {
    #Requires -RunAs
    [CmdletBinding()]
    param (

        [parameter(Position = 0)]
        [String]
        $ComputerName = "Localhost" ,

        [String[]][Parameter(Mandatory)]
        [Alias("Username", "Identity")]
        $Member ,

        [PSCredential]
        $Credential

    )

    $Action = "DELETE"

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
        $Error[0]
    } # try catch
} # function
