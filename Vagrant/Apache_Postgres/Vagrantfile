# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"
#Se establece la creacion para las siguientes maquinas:
# centos_balancer / centos_web_1 / centos_web_2 / centos_database
Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.define :centos_balancer do |node|
    node.vm.box = "centos6.4"
    node.vm.network :private_network, ip: "192.168.56.51"
    node.vm.network "public_network", :bridge => "eth2", ip:"192.168.131.51", :auto_config => "false", :netmask => "255.255.255.0"
    node.vm.provider :virtualbox do |vb|
      vb.customize ["modifyvm", :id, "--memory", "1024","--cpus", "2", "--name", "centos_balancer" ]
    end
    config.vm.provision :chef_solo do |chef|
    	chef.cookbooks_path = "cookbooks"
    	chef.add_recipe "mirror"
	chef.add_recipe "proxy"
    	chef.json = {"aptmirror" => {"server" => "192.168.131.254", "webip1" => "192.168.56.52", "webip2" => "192.168.56.53"}}
    end

  end
  config.vm.define :centos_web_1 do |node|
    node.vm.box = "centos6.4"
    node.vm.network :private_network, ip: "192.168.56.52"
    node.vm.network "public_network", :bridge => "eth2", ip:"192.168.131.52", :auto_config => "false", :netmask => "255.255.255.0"
    node.vm.provider :virtualbox do |vb|
      vb.customize ["modifyvm", :id, "--memory", "1024","--cpus", "2", "--name", "centos_web_1" ]
    end
    config.vm.provision :chef_solo do |chef|
    	chef.cookbooks_path = "cookbooks"
    	chef.add_recipe "mirror"
	chef.add_recipe "apache"
    	chef.json = {"aptmirror" => {"server" => "192.168.131.254"}}
    end

  end
  config.vm.define :centos_web_2 do |node|
    node.vm.box = "centos6.4"
    node.vm.network :private_network, ip: "192.168.56.53"
    node.vm.network "public_network", :bridge => "eth2", ip:"192.168.131.53", :auto_config => "false", :netmask => "255.255.255.0"
    node.vm.provider :virtualbox do |vb|
      vb.customize ["modifyvm", :id, "--memory", "1024","--cpus", "2", "--name", "centos_web_2" ]
    end
    config.vm.provision :chef_solo do |chef|
    	chef.cookbooks_path = "cookbooks"
    	chef.add_recipe "mirror"
	chef.add_recipe "apache2"
    	chef.json = {"aptmirror" => {"server" => "192.168.131.254"}}
    end

  end
  config.vm.define :centos_database do |db|
    db.vm.box = "centos6.4"
    db.vm.network :private_network, ip: "192.168.56.54"
    db.vm.network "public_network", :bridge => "eth2", ip:"192.168.131.54", :auto_config => "false", :netmask => "255.255.255.0"
    db.vm.provider :virtualbox do |vb|
      vb.customize ["modifyvm", :id, "--memory", "1024","--cpus", "1", "--name", "centos_database" ]
    end
    config.vm.provision :chef_solo do |chef|
      chef.cookbooks_path = "cookbooks"
      chef.add_recipe "mirror"
      chef.add_recipe "postgres"
      chef.json ={"aptmirror" => {"server" => "192.168.131.254"}}    
    end
  end


end
