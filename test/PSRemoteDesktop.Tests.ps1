$ModuleManifestName = 'PSRemoteDesktop.psd1'
$ModulePath = "$PSScriptRoot\..\PSRemoteDesktop"
$ModuleManifestPath = Join-Path $ModulePath $ModuleManifestName

Describe 'Module Manifest Tests' {
    It 'Passes Test-ModuleManifest' {
        Test-ModuleManifest -Path $ModuleManifestPath
        $? | Should Be $true
    }
}
