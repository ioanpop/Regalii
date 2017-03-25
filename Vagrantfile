# -*- mode: ruby -*-
# vi: set ft=ruby :
user = ENV['USER']

Vagrant.configure("2") do |config|
  config.vm.box = "bento/centos-7.2"
  
  # ssh settings
  config.ssh.insert_key = false
  config.ssh.private_key_path = ["key/insecure_private_key", "key/private_key"]
  config.vm.provision "file", source: "key/public_key", destination: "~/.ssh/authorized_keys"
  config.vm.synced_folder "app", "/home/vagrant/app"
  
  node_id = "#{user}.app-server"
  config.vm.define node_id do |node|
  	node.vm.hostname = node_id
  end
  config.vm.boot_timeout = 600
  config.ssh.forward_agent = true
  config.vm.provider "virtualbox" do |v|
    v.memory = 2048
    v.cpus = 2
    v.customize ["modifyvm", :id, "--vram", "12"]
  end
  # Forward ports for servicess
  config.vm.network "forwarded_port", guest: 22, host: 22, host_ip: "127.0.0.1", auto_correct: true
  config.vm.network "forwarded_port", guest: 8080, host: 8080, host_ip: "127.0.0.1", auto_correct: true
  
  # install files
  config.vm.provision :shell, :inline => "sudo yum -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm"
  config.vm.provision :shell, :inline => "sudo yum -y install https://centos7.iuscommunity.org/ius-release.rpm"
  config.vm.provision :shell, :inline => "sudo yum -y install http://rpms.famillecollet.com/enterprise/remi-release-7.rpm"
  config.vm.provision :shell, :inline => "sudo yum -y install centos-release-scl"
  config.vm.provision :shell, :inline => "sudo yum -y update"
  config.vm.provision :shell, :inline => "sudo yum -y install python27 python-pip unzip curl ntp crontabs git freetype wget nano gcc zlib zlib-devel mailx"
  config.vm.provision :shell, :inline => "sudo yum -y install ruby ruby-devel rubygems rubygem-rack"
  config.vm.provision "shell" do |s|
    s.path = "provision/files.sh"
  end
  config.vm.provision :shell, :inline => "gem install bundler"
  config.vm.provision :shell, :inline => "gem install puma"
  config.vm.provision :shell, :inline => "sudo yum -y install ansible"
  config.vm.provision :shell, :inline => "echo '*/5 * * * * /home/vagrant/app_check.sh' > /home/vagrant/cron.txt"
  config.vm.provision :shell, :inline => "ansible-playbook /home/vagrant/app.yml"
  config.vm.provision :shell, :inline => "crontab -u vagrant /home/vagrant/cron.txt"
end