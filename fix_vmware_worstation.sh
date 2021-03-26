#!/bin/bash
sudo apt update -y sudo apt upgrade -y ; sudo dist-upgrade 

sudo init -y 



sudo pkill vmware-vmx
sudo  vmware-modconfig --console --install-all  
sudo init 6
