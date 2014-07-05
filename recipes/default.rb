#
# Cookbook Name:: zabbix-cookbook
# Recipe:: default
#
# Copyright (C) 2014 YOUR_NAME
#
# All rights reserved - Do Not Redistribute
#

# https://www.zabbix.com/documentation/2.2/manual/installation/requirements
%w(mysql-server httpd php php-mysql).each do |p|
  package p do
    action :install
  end
end

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

%w(zabbix-server-mysql zabbix-web-mysql zabbix-agent).each do |p|
  package p do
    action :install
  end
end

%w(mysqld).each do |s|
  service s do
    supports :status => true, :restart => true
    action [:enable, :start]
  end
end

execute "create zabbix database" do
  command <<-EOF
    echo "create database zabbix character set utf8 collate utf8_bin;" | mysql -uroot
    echo "grant all privileges on zabbix.* to zabbix@localhost identified by 'zabbix';" | mysql -uroot
    cd /usr/share/doc/zabbix-server-mysql-2.2.*/create
    mysql -uroot zabbix < schema.sql
    mysql -uroot zabbix < images.sql
    mysql -uroot zabbix < data.sql
  EOF
  not_if "mysqlshow | grep zabbix"
end


