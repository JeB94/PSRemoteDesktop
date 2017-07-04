function Get-RDUser {
    #Require -Verb RunAs

    [CmdletBinding()]
    param (
        [parameter(Position = 0)]
        [String[]]
        $ComputerName = "Localhost",

        [PSCredential]
        $Credential

    )

    $Command = {
        $language = (Get-UICulture).name.substring(0, 2)

        $GroupsinLang = @{
            es = "Usuarios de escritorio remoto"
            en = "Remote Desktop Users"
        } # hashtable languages

        $Group = $GroupsinLang[$Language]

        IF ($PSVersionTable.PSVersion.Major -ne '5') {

            $Wmi = Get-WmiObject -Class Win32_GroupUser |
                Where-Object { $_.groupcomponent -match "$($env:computername)`",Name=`"$Group`"" }
            IF ($null -ne $wmi) {

                $Wmi | ForEach-Object {
                    IF ($_.PartComponent -match "Group.Domain") {
                        $Type = "Group"
                    }
                    else {
                        $Type = "User"
                    } # if else

                    $parser = $_.partComponent.split(".")[1]

                    $user = $Parser.split(",")[1].trimstart("Name=").trim('"')
                    $Domain = $Parser.split(",")[0].trimstart("Domain=").trim('"')

                    $Output = @{
                        Name        = "{0}\{1}" -F $Domain, $User
                        ObjectClass = $Type
                        ComputerName = $Env:ComputerName
                    } # hashtable

                    #output object
                    [PSCustomObject]$Output
                } #foreach
            }
        }
        else {
            Get-LocalGroupMember -Group $Group | Select-Object ObjectClass,Name,@{
                Name='ComputerName';
                Expression={$Env:ComputerName}
            }
        }
    }

    Foreach ($Computer in $ComputerName) {
        Write-Verbose "Retriving members from $Computer"
        $Params = @{
            ComputerName = $Computer
            ScriptBlock  = $Command
            HideComputerName = $True
        } # hashtable

        IF ($Computer -match "Localhost|$($env:computername)") {
            $Params.Remove('ComputerName')
            $Params.Remove('HideComputerName')
        }
        elseif ($PSBoundParameters.ContainsKey("Credential")) {
            $Params.credential = $Credential
        } # elseif

        try {
            Invoke-Command @Params -ErrorAction Stop
        }
        catch {
            Write-Error $_
        }
    } # foreach
} # function
