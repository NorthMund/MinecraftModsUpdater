Add-Type -assembly System.Windows.Forms | Out-Null
Add-Type -AssemblyName PresentationCore,PresentationFramework | Out-Null
$Global:main_form = New-Object System.Windows.Forms.Form
$Global:main_form.Text = "Mods Updater"
$Global:main_form.Width = 600
$Global:main_form.Height = 400
$Global:main_form.AutoSize = $false
$Global:main_form.MaximumSize = New-Object System.Drawing.Size(600,400)
$Global:main_form.MinimumSize = New-Object System.Drawing.Size(600,400)


$Global:address
$Global:port
$Global:defaultAddress = "192.168.1.66"
$Global:defaultPort = "8321"


function Init-UI(){
    $Header = New-Object System.Windows.Forms.Label
    $Header.Text = "MODS UPDATER"
    $Header.TextAlign = [System.Drawing.ContentAlignment]::TopCenter
    $Header.AutoSize = $true
    $Header.Location = New-Object System.Drawing.Point(160,10)
    $Header.Font = "Minecraft, 24pt"
    $Global:main_form.Controls.Add($Header)

    $Header2 = New-Object System.Windows.Forms.Label
    $Header2.Text = "version 1.1; made by northmund"
    $Header2.TextAlign = [System.Drawing.ContentAlignment]::MiddleCenter
    $Header2.AutoSize = $true
    $Header2.Location = New-Object System.Drawing.Point(160,55)
    $Header2.Font = "Minecraft, 12pt"
    $Global:main_form.Controls.Add($Header2)

    $addressLabel = New-Object System.Windows.Forms.Label
    $addressLabel.Text = "Server hostname/IP"
    $addressLabel.Font = "Minecraft, 12pt"
    $addressLabel.AutoSize = $true
    $addressLabel.Location = New-Object System.Drawing.Point(20,130)
    $Global:main_form.Controls.Add($addressLabel)
    
    $Global:addRessTextBox = New-Object System.Windows.Forms.TextBox
    $Global:addRessTextBox.Width = 150
    $Global:addRessTextBox.Text = "ip"
    $Global:addRessTextBox.Font = "Minecraft, 12pt"
    $Global:addRessTextBox.Location = New-Object System.Drawing.Point(20,155)
    $Global:main_form.Controls.Add($Global:addRessTextBox)

    $portLabel = New-Object System.Windows.Forms.Label
    $portLabel.Text = "Server port"
    $portLabel.Font = "Minecraft, 12pt"
    $portLabel.AutoSize = $true
    $portLabel.Location = New-Object System.Drawing.Point(200,130)
    $Global:main_form.Controls.Add($portLabel)
    
    $Global:portTextBox = New-Object System.Windows.Forms.TextBox
    $Global:portTextBox.Width = 150
    $Global:portTextBox.Text = "port"
    $Global:portTextBox.Font = "Minecraft, 12pt"
    $Global:portTextBox.Location = New-Object System.Drawing.Point(200,155)
    $Global:main_form.Controls.Add($Global:portTextBox)

    $updateFromConfigButton = New-Object System.Windows.Forms.Button
    $updateFromConfigButton.Text = "Refresh from configuration file"
    $updateFromConfigButton.Height = 50
    $updateFromConfigButton.Width = 180
    $updateFromConfigButton.Font = "Minecraft, 12pt"
    $updateFromConfigButton.Location = New-Object System.Drawing.Point(370,140)
    $Global:main_form.Controls.Add($updateFromConfigButton)

    $updateModsButton = New-Object System.Windows.Forms.Button
    $updateModsButton.Width=240
    $updateModsButton.Height=40
    $updateModsButton.TextAlign = [System.Drawing.ContentAlignment]::MiddleCenter
    $updateModsButton.Font="Minecraft,20pt"
    $updateModsButton.Text="UPDATE MODS"
    $updateModsButton.Location = New-Object System.Drawing.Point(160,240)
    $Global:main_form.Controls.Add($updateModsButton)

    $updateFromConfigButton.Add_Click({
        Get-SettingsFromConfig
        $Global:addRessTextBox.Text = $Global:address
        $Global:portTextBox.Text = $Global:port
    })

    $updateModsButton.Add_Click({
        showWarning
    })
}

function Get-SettingsFromConfig(){
    $Global:address = Get-Content conf\updater.conf -Head 1
    $Global:port = Get-Content conf\updater.conf -Tail 1
}

function Set-InitialConfig(){
    # Удаляем архив mods.zip, если он имеется
    if (Test-Path tmp\mods.zip){
        New-Item -ItemType Directory tmp | Out-Null
        Remove-Item tmp\mods.zip 
    }
    # Проверяем, есть ли файл конфигурации. Если нет, создаем новый и записываем в него переменные defaultAddress и defaultPort
    if (Test-Path conf\updater.conf){}
    else {
      New-Item -ItemType Directory conf | Out-Null
      New-Item conf\updater.conf | Out-Null
      Write-Output ${Global:defaultAddress}`n${Global:defaultPort} > conf\updater.conf | Out-Null
    }
}

function Install-ModsUpdate(){
    if(Test-Path $env:APPDATA\.minecraft\mods){Remove-Item $env:APPDATA\.minecraft\mods\*}
    Get-SettingsFromConfig
    if(Test-Path tmp){}else{New-Item -ItemType Directory tmp | Out-Null}
    Invoke-WebRequest -Uri http://${Global:address}:${Global:port}/mods.zip -OutFile tmp\mods.zip
    Expand-Archive tmp\mods.zip -DestinationPath $env:APPDATA\.minecraft\mods
    Remove-Item tmp\mods.zip
}

function showWarning(){
    $warningInput = [System.Windows.MessageBox]::Show('Warning! All files in dir %appdata%/.minecraft/mods will be deleted! Continue?','Warning!','YesNo','Error')
    if ($warningInput -eq "Yes"){
        Install-ModsUpdate
    }
}

function InitUpdater(){
    # Инициализируем конфиг
    Set-InitialConfig
    # Считываем данные из конфига в глобальные переменные
    Get-SettingsFromConfig


    # Записываем в текстбоксы текст из конфига 
    $Global:addRessTextBox.Text = $Global:address
    $Global:portTextBox.Text = $Global:port
}

Init-UI
InitUpdater
$Global:main_form.ShowDialog() | Out-Null