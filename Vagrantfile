# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.proxy.enabled = false

  config.vm.box = "ubuntu/bionic64"
  config.disksize.size = "20GB"

  config.vm.provision :shell, path: "bootstrap.sh"
  config.vm.provision :shell, path: "configure.sh", privileged: false
  # config.vm.synced_folder '.', '/vagrant', disabled: true # synced project root to vagrant enabled by default
  
  config.vm.provider :virtualbox do |vb|
    vb.customize ["modifyvm", :id, "--name", "devbox"]
    vb.customize ["modifyvm", :id, "--memory", 8192]
    vb.customize ["modifyvm", :id, "--cpus", 1]
    vb.customize ["modifyvm", :id, "--cpuexecutioncap", "80"]
    vb.customize ['modifyvm', :id, '--clipboard', 'bidirectional']
    vb.customize ['modifyvm', :id, '--draganddrop', 'bidirectional']
    vb.customize ["modifyvm", :id, "--vram", "128"]

    vb.gui = true
  end
end
