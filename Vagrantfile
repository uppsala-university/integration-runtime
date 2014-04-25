Vagrant.configure("2") do |config|      

  config.vm.hostname = "centos.dev.uu.se"

  config.vm.provision :puppet do |puppet|
     puppet.manifests_path = "provision/manifests"
     puppet.module_path    = "provision/modules"
     puppet.manifest_file  = "default.pp"
  end

  config.vm.provider :virtualbox do |vb, override|
    override.vm.box = "CentOS-6.3-x86_64-minimal.box"
    override.vm.box_url = "http://static.uu.se/ark/box/centos-64-x64-vbox4210.box"
    override.vm.network :forwarded_port, guest: 8080, host: 8080
    override.vm.network :forwarded_port, guest: 8081, host: 8081
    override.vm.network :forwarded_port, guest: 8101, host: 8101
    override.vm.network :forwarded_port, guest: 8181, host: 8181
    vb.customize ["modifyvm", :id, "--memory", 1024]
    vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
  end

end
