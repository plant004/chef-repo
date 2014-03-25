#
# Cookbook Name:: setup-user
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
group "ssh_admin" do
  gid 1000
  action :create
end

user "ssh_admin" do
  home "/home/ssh_admin"
  # password hash (using grub-crypt --sha-512)
  password '$6$eiJdcQhdWVgvEdX6$f.AXEdzz.doWAbz0WsOKZ7i25oJfdaQFbljEtmgvbGXjPpcqHg5lqro6W0c/..viGZFz9m5d6eZmiFifQ8NZ9.'
  shell "/bin/bash"
  uid 1000
  gid "ssh_admin"
  supports :manage_home => true
  action :create
end

