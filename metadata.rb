name             'zabbix'
maintainer       'tamu222i'
maintainer_email 'tamu222i'
license          'The MIT License (MIT)'
description      'Chef cookbook for Zabbix.'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.0'

%w(centos).each do |os|
  supports os
end

