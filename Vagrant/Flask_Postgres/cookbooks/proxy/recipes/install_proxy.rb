yum_package 'httpd'do
action :install
end
yum_package 'php'do
action :install
end
yum_package 'php-mysql'do
action :install
end
yum_package 'mysql'do
action :install
end

service 'httpd' do
  supports :status => true, :restart => true, :reload => true
  action [ :enable, :start ]
end
bash "open port" do
	user "root"
	code <<-EOH
	iptables -I INPUT 5 -p tcp -m state --state NEW -m tcp --dport 80 -j ACCEPT
	service iptables save
	EOH
end

template "/etc/httpd/conf/httpd.conf" do
	source "httpd.conf"
	mode 0644
	owner "root"
	group "wheel"
	variables({
		:ip_web_1 => "#{node[:aptmirror][:webip1]}",
		:ip_web_2 => "#{node[:aptmirror][:webip2]}"
	})
end
