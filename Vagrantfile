Vagrant.configure("2") do |config|
  config.vm.box = "precise64"
  config.omnibus.chef_version = :latest
  config.berkshelf.enabled = true

  config.vm.define :titan do |titan|
    titan.vm.network :private_network, ip: "33.33.33.28"
    titan.vm.provider :virtualbox do |vb|
      vb.customize ["modifyvm", :id, "--memory", 1024]
    end
    titan.vm.hostname = "titan"		 
    titan.vm.provision :chef_solo do |chef|
      chef.add_recipe "apt"
      chef.add_recipe "titan"
    end
  end
end
