# vagrant-chef-redis-postgres

Sets up a basic ruby application dependent on redis and postgres dbs which are provisioned using vagrant chef provisioning.

# Requirements
MacOS:
  1. Vagrant
  2. Chef

# Installation & Setup
 1. Clone repo && ```cd vagrant-chef-redis-postgres```
 2. Install vagrant plugins `vagrant-librarian-chef` and `vagrant-vbguest` using: ```vagrant plugin install vagrant-librarian-chef vagrant-vbguest```
 3. Startup application:
    ```vagrant up --provision``` (PS: this step might take a few minutes)
 4. Goto `http://localhost:3000` on your browser to access guestbook application
