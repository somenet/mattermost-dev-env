Vagrant.configure("2") do |config|
  config.vm.box = "debian/contrib-buster64"

  config.vm.provider "virtualbox" do |v|
    v.name = "mm-dev-env"
    v.cpus = 4
    v.memory = 8192
  end

  config.vm.provider "libvirt" do |v|
    v.memory = 8192

    config.vm.synced_folder ".", "/vagrant", type: "rsync"
  end

  # design-choice: run file in vm.
  config.vm.provision "shell", inline: "/vagrant/vagrant_provision.sh"

  config.vm.network "forwarded_port", adapter: 1, guest: 8065, host: 8065

end
