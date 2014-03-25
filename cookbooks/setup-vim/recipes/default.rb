#
# Cookbook Name:: setup-vim
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

# download solarized.vim from github
remote_file "#{Chef::Config[:file_cache_path]}/solarized.vim" do
  source "https://raw.github.com/altercation/vim-colors-solarized/master/colors/solarized.vim"
  not_if "ls #{Chef::Config[:file_cache_path]} | grep 'solarized.vim'"
  action :create
end

# copy solarized.vim to root vim colors directory
bash "install_solarized_vim" do
  not_if "ls /root/.vim/colors/ | grep -q 'solarized.vim'"
  code <<-COMMAND
    mkdir -p /root/.vim/colors
    cp "#{Chef::Config[:file_cache_path]}/solarized.vim" /root/.vim/colors/
  COMMAND
end

# install pandoc
yum_package "pandoc" do
  action :install
end


