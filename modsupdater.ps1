$defaultAddress = "192.168.1.66"
$defaultPort = "8321"

if (Test-Path .\mods.zip){
    Remove-Item .\mods.zip 
}

if (Test-Path .\updater.conf){
    
} else {
    New-Item updater.conf
    # Add-Content -Path .\updater.conf -Value ${defaultAddress}
    # Add-Content -Path .\updater.conf -Value ${defaultPort}
    echo ${defaultAddress}`n${defaultPort} >> .\updater.conf
}

$address = Get-Content .\updater.conf -Head 1
$port = Get-Content .\updater.conf -Tail 1
Remove-Item $env:APPDATA\.minecraft\mods\*
Invoke-WebRequest -Uri http://${address}:${port}/mods.zip -OutFile mods.zip
Expand-Archive mods.zip -DestinationPath $env:APPDATA\.minecraft\mods
Remove-Item .\mods.zip