# -*- mode: ruby -*-
# vi: set ft=ruby :
VAGRANTFILE_API_VERSION = "2"

def shell(*args)
  x=%x(#{args.join(" ")} 2>/dev/null).strip
  !x.empty? or nil and x
end

# Size of the cluster created by Vagrant
num_instances=4
# Change basename of the VM
instance_name_prefix="kn"
GATEWAY="192.168.15.1"
VM_NETMASK = "255.255.255.0"
VM_BRIDGE = ENV["VAGRANT_BRIDGE"] || "Wireless LAN adapter Wi-Fi"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # always use Vagrants insecure key
  config.ssh.insert_key = false     
  config.vm.box = "centos/7"
  
    
  config.vm.synced_folder ".", "/vagrant", disabled: true
  config.vm.provision "shell", path: "script.sh", :privileged => true
    
  config.vm.provider :virtualbox do |v|
    v.check_guest_additions = false
    v.memory = 1024 
    v.cpus = 1
    v.functional_vboxsf     = false
	v.customize ["modifyvm", :id, "--nictype1", "virtio"]
    v.customize ["modifyvm", :id, "--nictype2", "virtio"]
  end

  # Set up each box
  (1..num_instances).each do |i|
    if i == 1
      vm_name = "km-01"
    else      
	  vm_name = "%s-%02d" % [instance_name_prefix, i-1]
    end
		
    config.vm.define vm_name do |host|
		host.vm.hostname = vm_name	
		ip = "192.168.15.#{i+200}"		
		host.vm.network "public_network", bridge: VM_BRIDGE, ip: ip, :auto_config => "false", :netmask => VM_NETMASK
		  
		current_dir    = File.dirname(File.expand_path(__FILE__))	  
		disk_perfix = 'secondDisk'
		disk_ext ='.vdi'	  
		disk =  "%s/%s-%02d%s" % [current_dir,disk_perfix, i, disk_ext]	  
		#puts "Disk Path #{disk}"

		config.vm.provider "virtualbox" do |vb|
		unless File.exist?(disk)	  
		vb.customize ['createhd', '--filename',disk , '--variant', 'Fixed', '--size', 1 * 1024]
		end      
		vb.customize ['storageattach', :id, '--storagectl', 'IDE', '--port', 1, '--device', 0, '--type', 'hdd', '--medium', disk]	  
		end

		host.vm.provision :shell, :inline => "echo '127.0.0.1\tlocalhost' > /etc/hosts", :privileged => true

	   host.vm.provision :shell, :inline => "[ -d /root/.ssh ] || mkdir -p -m 700 /root/.ssh ", :privileged => true
       host.vm.provision :file, source: "~/.ssh/authorized_keys ", destination: "/tmp/authorized_keys"
	   host.vm.provision :shell, :inline => "[ -f  /tmp/authorized_keys ] && mv /tmp/authorized_keys /root/.ssh/authorized_keys", :privileged => true
	   host.vm.provision :shell, :inline => "[ -f /root/.ssh/authorized_keys ] && chown root:root /root/.ssh/authorized_keys", :privileged => true
	   host.vm.provision :shell, :inline => "[ -f /root/.ssh/authorized_keys ] && chmod 600 /root/.ssh/authorized_keys", :privileged => true
	   host.vm.provision :shell, :inline => "setenforce 0"
       host.vm.provision :shell, :inline => "sed -i 's/^SELINUX=.*/SELINUX=disabled/g' /etc/sysconfig/selinux"
	   host.vm.provision :shell, path: File.join(File.dirname(__FILE__), "provision.sh"), args: [GATEWAY]
	  	  
    end
  end
end
