#
# Cookbook Name:: zabbix-cookbook
# Recipe:: default
#
# Copyright (C) 2014 YOUR_NAME
#
# All rights reserved - Do Not Redistribute
#

# https://www.zabbix.com/documentation/2.2/manual/installation/install_from_packages
# http://stackoverflow.com/questions/18174557/chef-correct-way-to-load-new-rpm-and-install-package
remote_file "#{Chef::Config[:file_cache_path]}/zabbix-release-2.2-1.el6.noarch.rpm" do
    source "http://repo.zabbix.com/zabbix/2.2/rhel/6/x86_64/zabbix-release-2.2-1.el6.noarch.rpm"
    action :create
end

rpm_package "zabbix-release-2.2-1.el6.noarch.rpm" do
    source "#{Chef::Config[:file_cache_path]}/zabbix-release-2.2-1.el6.noarch.rpm"
    action :install
end
