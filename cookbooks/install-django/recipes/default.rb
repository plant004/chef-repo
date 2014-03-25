#
# Cookbook Name:: install-django
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute

# download ez_setup.py if not exists
remote_file "#{Chef::Config[:file_cache_path]}/ez_setup.py" do
  source "http://peak.telecommunity.com/dist/ez_setup.py"
  not_if "easy_install -h | grep -q '^usage'"
  action :create
#  notifies :run, "bash[install_easy_install]", :immediately
end

# exec ez_setup.py if download succeeded
bash "install_easy_install" do
  not_if "easy_install -h | grep -q '^usage'"
  code <<-COMMAND
    python "#{Chef::Config[:file_cache_path]}/ez_setup.py"
  COMMAND
#  action :run
end

# install pip if pip is not installed
bash "install_pip" do
  not_if "pip --version | grep -q '^pip'"
  code <<-COMMAND
    easy_install pip
  COMMAND
end

# install django if django is not installed
# remove '==1.6' if you want to install latest version
bash "install_django" do
  not_if "pip freeze | grep -q 'Django=='"
  code <<-COMMAND
    pip install django==1.6
  COMMAND
end

# install httpd if httpd is not installed
yum_package "httpd" do
  not_if "yum list installed httpd | grep -q '^httpd'"
  action :install
end

# install httpd-devel if httpd-devel is not installed
yum_package "httpd-devel" do
  not_if "yum list installed httpd-devel | grep -q '^httpd-devel'"
  action :install
end

# install python-devel if python-devel is not installed
yum_package "python-devel" do
  not_if "yum list installed python-devel | grep -q '^python-devel'"
  action :install
end

# download mod_wsgi if mod_wsgi is not installed
# change latest version if needed
remote_file "#{Chef::Config[:file_cache_path]}/mod_wsgi-3.4.tar.gz" do
  source "http://modwsgi.googlecode.com/files/mod_wsgi-3.4.tar.gz"
  not_if "ls /etc/httpd/modules/ | grep -q 'mod_wsgi.so'"
  action :create
  notifies :run, "bash[install_wsgi]", :immediately
end

bash "install_wsgi" do
  not_if "ls /etc/httpd/modules/ | grep -q 'mod_wsgi.so'"
  code <<-COMMAND
    cd "#{Chef::Config[:file_cache_path]}/"
    tar xzvf mod_wsgi-3.4.tar.gz
    cd mod_wsgi-3.4
    ./configure
    make
    make install
  COMMAND
end

