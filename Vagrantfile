# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"
nodes = [
  ['proxy', 1, 10],
  ['app', 3, 20],
  ['db', 1, 30],
]
Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  nodes.each do |name, number, ip_start|
    number.times do |i|
      config.vm.define "#{name}-#{i}" do |c|
        c.vm.box = "precise64_vmware"
        # c.vm.box_url = ""

        c.vm.provider "vmware_fusion" do |v|
          v.gui = false
          v.vmx["memsize"] = "512"
          # v.vmx["numvcpus"] = "2"
        end

        c.vm.hostname = "#{name}-#{i}.conductor.local"
        c.vm.network "private_network", ip: ("192.168.0.%d" % [(ip_start + i)])

        c.vm.synced_folder ".", "/vagrant", nfs: true

        # c.vm.provision :shell, inline: "/opt/ruby/bin/gem update puppet --no-ri --no-rdoc"
        c.vm.provision :puppet do |puppet|
          puppet.manifests_path = "manifests"
          puppet.manifest_file  = "site.pp"
          # puppet.hiera_config_path = "hiera.yml"
          # puppet.module_path = "modules"
        end
      end
    end
  end
end

