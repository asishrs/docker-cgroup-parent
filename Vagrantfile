Vagrant.configure("2") do |config|
  config.vm.hostname = 'cgrouphost'
  config.vm.box = "centos/7"
  config.vm.box_version = "1809.01"

  config.vm.provider :virtualbox do |vb|
    vb.name = 'cgroup-limit-host'
    vb.customize ['modifyvm', :id, '--memory', '1024', '--cpus', '2']
  end

  config.vm.synced_folder "./", "/vagrant"

  #Install Docker using the get-docker.sh script.
  config.vm.provision "shell",
      inline: "/bin/sh /vagrant/get-docker.sh"

  config.vm.provision "shell", inline: <<-SHELL
    #Install htop
    yum install -y wget
    wget dl.fedoraproject.org/pub/epel/7/x86_64/Packages/e/epel-release-7-11.noarch.rpm
    rpm -ihv epel-release-7-11.noarch.rpm
    yum install -y htop

    #Start Docker
    systemctl start docker

    #Intall cgroup tools
    yum install -y libcgroup
    yum install -y libcgroup-tools

    #We have to use same name for the cpu and memory cgroups as we can pass only one cgroup-parent to the docker start.
    #Create cgroup and add cpu limits
    cgcreate -g cpu:cgroup-limit
    #Limit CPU Usage by 50%
    #https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/6/html/resource_management_guide/sec-cpu
    #https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/6/html/resource_management_guide/sect-cpu-example_usage
    echo 100000 > /sys/fs/cgroup/cpu/cgroup-limit/cpu.cfs_quota_us
    echo 100000 > /sys/fs/cgroup/cpu/cgroup-limit/cpu.cfs_period_us
    #Create cgroup and add memory limits
    cgcreate -g memory:cgroup-limit
    #Limit memory by 100mb
    #This is similar passing --memory at the docker start but applying at cgroup-parent will apply for all containers on the host.
    #Example - docker run -it --rm --memory=100m image-name
    echo 104857600 > /sys/fs/cgroup/memory/cgroup-limit/memory.limit_in_bytes
  SHELL

  config.vm.provision "shell", inline: <<-SHELL
    docker build -t asishrs/alpine-stress /vagrant
  SHELL
end
