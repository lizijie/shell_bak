free -m
sudo mkdir /opt/images/
sudo rm -rf /opt/images/swap
sudo dd if=/dev/zero of=/opt/images/swap bs=1024 count=2048000
sudo mkswap /opt/images/swap
sudo swapon /opt/images/swap
free -m
