Vagrant.configure("2") do |config|

  config.vm.hostname = "centos.dev.uu.se"

  config.vm.synced_folder "~/.m2", "/vagrant/m2", create: true, mount_options: ["uid=497,gid=497"]
  # ["dmode=777,fmode=666"]

  config.vm.provision :puppet do |puppet|
     puppet.environment_path = "environments"
     puppet.environment = "dev"
     puppet.manifests_path = "environments/dev/manifests"
     puppet.module_path    = "environments/dev/modules"
     puppet.manifest_file  = "default.pp"
  end

  config.vm.provider :virtualbox do |vb, override|
    override.vm.box = "CentOS-6.7-x86_64-minimal.box"
    override.vm.box_url = "http://static.uu.se/ark/box/centos-67-x64-vbox5014.box"
    override.vm.network :forwarded_port, guest: 8080, host: 8080
    override.vm.network :forwarded_port, guest: 8081, host: 8081
    override.vm.network :forwarded_port, guest: 8101, host: 8101
    override.vm.network :forwarded_port, guest: 8181, host: 8181
    override.vm.network :forwarded_port, guest: 8989, host: 8989
    override.vm.network :forwarded_port, guest: 8990, host: 8990
    vb.customize ["modifyvm", :id, "--memory", 1024]
    vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
  end

end
