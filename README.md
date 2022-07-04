Prerequisite
1) jq-1.6

Install shell script as service using below steps

Step 1 – Create a Shell Script
sudo vi /usr/bin/script.sh 
sudo chmod +x /usr/bin/script.sh 

Step 2 – Create A SystemD File
sudo vi /lib/systemd/system/shellscript.service

add the following content 

[Unit]
Description= Shell Script

[Service]
ExecStart=/usr/bin/script.sh

[Install]
WantedBy=multi-user.target

Step 3 – Enable New Service
sudo systemctl daemon-reload 

sudo systemctl enable shellscript.service 
sudo systemctl start shellscript.service 
