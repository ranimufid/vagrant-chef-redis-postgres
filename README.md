# vagrant-chef-redis-postgres

Sets up a basic ruby application dependent on redis and postgres dbs which are provisioned using vagrant chef provisioning.

# Requirements
MacOS:
  1. Vagrant
  2. Chef

# Installation & Setup
 1. Clone repo && ```cd vagrant-chef-redis-postgres```
 2. Install `librarian-chef`:
    ```gem install librarian-chef```
 3. Startup application:
    ```vagrant up --provision```
 4. Goto `localhost:3000` on your browser to access guestbook application
