#
# Cookbook Name:: deploy_guestbook
# Recipe:: default
#
# Copyright 2017, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'ruby_build'

# OS Dendencies
%w(git ruby-dev build-essential libsqlite3-dev libssl-dev libpq-dev).each do |pkg|
  package pkg
end

ssh_known_hosts_entry 'github.com'

  gem_package 'bundler' do
    version '1.14.3'
    # gem_binary '/home/ubuntu/.rvm/rubies/ruby-2.2.5/bin/gem'
    options '--no-ri --no-rdoc'
  end

   # we create new user that will run our application server
  user_account 'chefdeploy' do
    create_group true
    ssh_keygen false
  end

  group "sudo" do
    action :modify
    members "chefdeploy"
    append true
  end

   # we define our application using application resource provided by application cookbook
  include_recipe "runit"
  application 'guestbook' do
    owner 'chefdeploy'
    group 'chefdeploy'
    path '/home/chefdeploy/app'

    execute "clone repo" do
      command "cd /home/chefdeploy/app && if [ ! -d guestbook ]; then git clone https://github.com/askcharlie/guestbook.git; fi && ruby --version && cd guestbook && bundle install"
    end
    execute "exporting env variables + db migrate" do
      command "export REDIS_HOST=localhost && export DATABASE_URL=\"postgres://rails_app:Nfz98ukfki7Df2UbV8H@localhost/guestbook\" && cd /home/chefdeploy/app/guestbook && bundle exec rake db:migrate"
    end
    # execute "db migrate" do
    #   command "cd /home/chefdeploy/app/guestbook && bundle exec rake db:migrate" # && puma &"
    # end
    execute "server restart" do
      command "export REDIS_HOST=localhost && export DATABASE_URL=\"postgres://rails_app:Nfz98ukfki7Df2UbV8H@localhost/guestbook\" && cd /home/chefdeploy/app/guestbook && if [[ $(lsof -i tcp:9292 | awk 'NR!=1 {print $2}') ]]; then lsof -i tcp:9292 | awk 'NR!=1 {print $2}' | xargs kill; fi && puma -d" # && puma &"
    end
  # rails do
  #     bundler true
  #   end

  #  unicorn do
  #     worker_processes 2
  #   end
  end