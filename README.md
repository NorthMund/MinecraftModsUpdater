
MMU (Minecraft Mods Updater) is a simple http client-server application, made for easy updating mods for players.

How to use: 
Install backend on your server:
   1. install golang;
   2. copy files from backend folder to your server;
   3. initialize go module (go mod init updater)
   4. build updater application (go build .)
   5. run application (./updater)
After the first launch, a conf directory will be created. First line in file conf/server.conf is ip address, second line is a port (default port is 8321)
Configure your ip and restart server.
    You need to put your mods in .zip archive in html folder.

To update mods from this server, use frontend app. Initially, there is a powershell script with windows forms GUI.
You can compile script to exe using [ps2exe](https://github.com/MScholtes/PS2EXE). 
Enter your updater-server hostname/IP and port. You can also get settings from conf/updater.conf file.
Press "Update Mods" to update your mods.
