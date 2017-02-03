# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  config.vm.box = "ubuntu/trusty64"
  # Copies all code in current working directory to a /app directory in vagrant box
  config.vm.synced_folder "./", "/app", owner: "root", group: "root"
  # Port forwards any services listening on port 3000 in provisioned box to port 1234 in local machine
  config.vm.network "forwarded_port", guest: 9292, host: 3000
  # Automatically assign an IP address from the reserved address space to the provisioned machine
  config.vm.network "private_network", type: "dhcp"
  # Prevents vagrant from checking for vm updates everytime vagrant up is executed
  config.vm.box_check_update = false
  # Limits the provisioned box to 2GB of memory and 1 CPUs from host machine
  config.vm.provider "virtualbox" do |vb|
    vb.memory = "2048"
    vb.cpus = 1
  end

  # Helps us get over the no-tty issue
  config.vm.provision "fix-no-tty", type: "shell" do |s|
    s.privileged = false
    s.inline = "sudo sed -i '/tty/!s/mesg n/tty -s \\&\\& mesg n/' /root/.profile"
  end
  # Provisions rvm to install specific version of ruby
  config.vm.provision :shell, path: "install-rvm.sh", args: "stable"
  config.vm.provision :shell, path: "install-ruby.sh", args: "2.2.5"

  # Installs postgresql from recipe
  config.vm.provision "chef_solo" do |chef|
      chef.cookbooks_path = ['cookbooks','custom_cookbook']
      chef.add_recipe 'postgresql::server'
      chef.json = {
        "postgresql" => {
        "password" => {
        "postgres" => "redshift#213"
      }
    }
  }
  end

  # Install redis from recipe
  config.vm.provision "chef_solo" do |chef|
      chef.cookbooks_path = ['cookbooks','custom_cookbook']
      chef.add_recipe 'redis-cookbook'
  end

  # Creates required credentials for guestbook app on postgres
  config.vm.provision "shell", inline: <<-SHELL
  # Create Role and login
  echo "CREATE USER rails_app WITH PASSWORD 'Nfz98ukfki7Df2UbV8H';" | sudo -u postgres psql
  echo "CREATE DATABASE guestbook;" | sudo -u postgres psql
  echo "GRANT ALL privileges on DATABASE guestbook TO rails_app;" | sudo -u postgres psql
  SHELL


  # Installs docker on provisioned machine if it doesn't exit
  config.vm.provision "shell", inline: <<-SHELL
    sudo docker 2> /dev/null
    if [ $? -eq 0 ]
      then
        echo "Docker exists, skipping..."
        exit 0
      else
        sudo curl -sSL https://get.docker.com/ | sh
        sudo curl -L https://github.com/docker/compose/releases/download/1.10.0/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
        sudo chmod +x /usr/local/bin/docker-compose
    fi
  SHELL

  # Gives the vagrant user permission to execute docker commands without the need for sudo
  config.vm.provision "chef_apply" do |chef|
    chef.recipe = <<-RECIPE

      package 'awscli'

      group 'docker'

      bash 'docker_sudoer' do
        code 'sudo usermod -aG docker vagrant'
      end

      service 'docker' do
        action :start
      end
    RECIPE
  end

  config.vm.provision "chef_solo" do |chef|
        chef.cookbooks_path = ['cookbooks','custom_cookbook']
        chef.add_recipe 'deploy_guestbook'
    end

end
