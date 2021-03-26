# devstuff
Local development setup using agrant for virtual machines and ansible for server setup.

Both folders have [vagrantfile](ubuntu/Vagrant) for multi node/server setup and using ansible to setup the machines.
- [ubuntu18.04-folder](vagrant/ubuntu18.04)
- [ubuntu20.04-folder](vagrant/ubuntu20.04)
- [centos7-folder](vagrant/centos7)
- [centos8-folder](vagrant/centos8)


To choose how many nodes you want edit the variable `NODE_COUNT` in [vagrantfile](ubuntu/Vagrant) and if you choose zero it will make one node called master.

There are also ansible-playbooks to setup jenkins mainly to test out ansible with masters node defined in [vagrantfile](ubuntu/Vagrant) and the other os playbooks.

- [jenkins](ansible/jenkins)
- [foreman](ansible/foreman)
- [nodejs](ansible/node-install.yml)
- [confluence](ansible/confluence)

There is also some example terraform setup.

- [terraform](terraform)

When to try out a terraform config you an use this script [gettf](gettf) to copy 
terraform examples to your home folder.


If you want an example on a cloud server setup with asible playbook that use
fail2ban look here [cloud server setup](https://github.com/habbis/cloud_server_setup)
