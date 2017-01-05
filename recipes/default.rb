#
# Cookbook Name:: tomcat
# Recipe:: default
#
# Copyright 2016, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
url = node['tomcat']['url']
name = node['tomcat']['name']
directory '/opt/tomcat' do
	action :create
	recursive true
end

package 'java-1.7.0-openjdk-devel'

#execute 'java pathe setup' do
#	command '/usr/sbin/alternatives --set java /usr/lib/jvm/jre-1.8.0.openjdk.x86_64/bin/java'
#end
remote_file '/opt/apache-tomcat-7.0.69.tar.gz' do
	source url
	action :create
#	not_if { ::Dir.Exist?('/opt/apache-tomcat-7.0.69.tar.gz') }
end

bash 'install tomcat' do
	cwd '/opt'	
	code <<EOH
tar -xvf name -C /opt/tomcat --strip-components=1
chmod g+rwx /opt/tomcat/conf
chmod g+r /opt/tomcat/conf/*
EOH
	not_if { ::Dir.Exist?('/opt/tomcat') }
end
template '/opt/tomcat/conf/tomcat-users.xml' do
	source 'tomcat-users.xml.erb'
end

service 'tomcat' do
	action [:start, :enable]
	# notifies :restart
end
