function Set-LGroup {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [Alias("Username", "Identity")]
        [String[]]
        $Member ,

        [Parameter(Mandatory)]
        [ValidateSet("Add", "Delete")]
        [String]
        $Action,

        [Switch]
        $IsLocal
    )
    process {
        if ($IsLocal) {

            $Command = {

                $language = (Get-UICulture).name.substring(0, 2)

                $GroupsinLang = @{
                    es = "Usuarios de escritorio remoto"
                    en = "Remote Desktop Users"
                } # hashtable

                $Group = $GroupsinLang[$Language]

                Foreach ($user in $Member) {
                    Write-Verbose "Setting operation $Action over user $User on $($Env:COMPUTERNAME)"
                    net LocalGroup $Group /$Action $user
                } # foreach
            }
        }
        else {
            $Command = {

                $language = (Get-UICulture).name.substring(0, 2)

                $GroupsinLang = @{
                    es = "Usuarios de escritorio remoto"
                    en = "Remote Desktop Users"
                } # hashtable

                $Group = $GroupsinLang[$Language]

                Foreach ($user in $using:Member) {
                    Write-Verbose "Setting operation $Action over user $User on $($Env:ComputerName)"
                    net LocalGroup $Group /$Using:Action $user
                } # foreach
            }
        }

        # return a scriptblock
        Write-Output $Command
    } # process
} #Function