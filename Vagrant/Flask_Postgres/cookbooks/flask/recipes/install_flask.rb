execute 'pg' do
 command 'yum localinstall http://yum.postgresql.org/9.4/redhat/rhel-6-x86_64/pgdg-centos94-9.4-3.noarch.rpm -y'
end

#yum_package 'postgresql94' do
# action :install
#end

bash "open port" do
	user "root"
	code <<-EOH
	iptables -I INPUT 5 -p tcp -m state --state NEW -m tcp --dport 80 -j ACCEPT
	service iptables save
	EOH
end
cookbook_file "/home/vagrant/provisioner.py" do
	source "provisioner.py"
	mode 0644
	owner "vagrant"
	group "wheel"
end
cookbook_file "/home/vagrant/greedy.py" do
	source "greedy.py"
	mode 0644
	owner "vagrant"
	group "wheel"
end
cookbook_file "/etc/init/service.conf" do
	source "service.conf"
	mode 0644
	owner "root"
	group "wheel"
end


#execute 'provisioner' do
#	command sudo python provisioner.py
#end