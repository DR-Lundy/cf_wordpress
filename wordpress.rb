
yum_package %w(php php-mysql mysql mysql-server mysql-devel mysql-libs httpd) do
  action :install
end

remote_file '/tmp/latest.tar.gz' do
  source 'http://wordpress.org/latest.tar.gz'
  owner 'root'
  group 'root'
  mode '0755'
  action :create
  not_if { File.exist?('/var/www/html/wordpress') }
end

service 'httpd' do
  action [:enable, :start]
end

service 'mysqld' do
  action [:enable, :start]
end

file '/tmp/setup.mysql' do
  content <<-EOH
  CREATE DATABASE #{dbname};
  CREATE USER '#{dbuser}'@'localhost' IDENTIFIED BY '#{dbuserpass}';
  GRANT ALL ON #{dbname}.* TO '#{dbuser}'@'localhost';
  FLUSH PRIVILEGES;
  EOH
  owner 'root'
  group 'root'
  mode '0400'
  retries 3
  action :nothing
end

bash 'wp-config' do
  code <<-EOH
  #!/bin/bash -xe
  cp /var/www/html/wordpress/wp-config-sample.php /var/www/html/wordpress/wp-config.php
  sed -i \"s/'database_name_here'/'#{dbname}'/g" /var/www/html/wordpress/wp-config.php
  sed -i \"s/'username_here'/'#{dbuser}'/g" /var/www/html/wordpress/wp-config.php
  sed -i \"s/'password_here'/'#{dbuserpass}'/g" /var/www/html/wordpress/wp-config.php
  EOH
  action :nothing
  not_if { File.exist?('/var/www/html/wordpress/wp-config.php') }
end

bash 'Set mysql root password' do
  code <<-EOH
  mysqladmin -u root password '#{dbrootpass}'
  EOH
  action :run
  only_if "$(mysql -u root --password='#{dbrootpass}' >/dev/null 2>&1 </dev/null); (( $? != 0 ))"
end

bash 'Create mysql Database' do
  code <<-EOH
  mysql -u root --password='#{dbrootpass}' < /tmp/setup.mysql
  EOH
  action :run
  notifies :create, 'file[/tmp/setup.mysql]', :before
  notifies :run, 'bash[wp-config]', :immediately
  only_if "$(mysql '#{dbname}' -u root --password='#{dbrootpass}' >/dev/null 2>&1 </dev/null); (( $? != 0 ))"
end
