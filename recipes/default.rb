#
# Cookbook Name:: zabbix
# Recipe:: default
#
# Copyright (C) 2014 tamu222i
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

%w(mysqld zabbix-server httpd).each do |s|
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

# http://qiita.com/sawanoboly/items/355288c4592bdf4a3550
%w(/etc/zabbix/zabbix_server.conf).each do |f|
  file f do
    content lazy {
      _file = Chef::Util::FileEdit.new(path)
      _file.insert_line_if_no_match(/^DBPassword=zabbix$/, "DBPassword=zabbix")
      _file.send(:editor).lines.join
    }
  end
end

%w(/etc/php.ini).each do |f|
  file f do
    content lazy {
      _file = Chef::Util::FileEdit.new(f)
      _file.insert_line_if_no_match(/^date.timezone = "Asia\/Tokyo"$/, 'date.timezone = "Asia/Tokyo"')
      _file.send(:editor).lines.join
    }
  end
end

%w(/etc/zabbix/web/zabbix.conf.php).each do |f|
  filename = File.basename(f)
  template f do
    source "#{filename}.erb"
    mode 0644
    owner "root"
    group "root"
    notifies :reload, "service[httpd]"
  end
end
