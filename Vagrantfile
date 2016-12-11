# -*- mode: ruby -*-
# vi: set ft=ruby :
$commonScript = <<SCRIPT
   echo Installing dependencies...

   # install base tools 
   sudo yum update -y && yum install -y net-tools wget curl python unzip zip cron vim epel-release git

   # environment
   
   # user vagrant
   rm /home/vagrant/.bashrc
   rm /root/.bashrc
   ln -s /vagrant/host/.bashrc /home/vagrant
   ln -s /vagrant/host/.vim /home/vagrant
   ln -s /vagrant/host/.vimrc /home/vagrant
  
   # user root
   ln -s /vagrant/host/.bashrc /root
   ln -s /vagrant/host/.vim /root
   ln -s /vagrant/host/.vimrc /root
   
   # jdk
   wget --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" "http://download.oracle.com/otn-pub/java/jdk/8u111-b14/jdk-8u111-linux-x64.tar.gz" -P /opt && cd /opt \
     && tar xvzf jdk-8u111-linux-x64.tar.gz && rm jdk-8u111-linux-x64.tar.gz \
     && ln -s jdk1.8.0_111 jdk
   
   # spark
   wget http://d3kbcqa49mib13.cloudfront.net/spark-2.0.2-bin-hadoop2.7.tgz -P /opt && cd /opt \
     && tar xvzf spark-2.0.2-bin-hadoop2.7.tgz && rm spark-2.0.2-bin-hadoop2.7.tgz \
     && ln -s spark-2.0.2-bin-hadoop2.7 spark
SCRIPT

$masterScript = <<SCRIPT
  # passwordless ssh for root 
  mkdir /root/.ssh
  cp /vagrant/host/ssh/spark /root/.ssh/id_rsa
  chmod 600 /root/.ssh/id_rsa
  chown 644 /root/.ssh
  # create workers config file
  echo "spark-node-1" > /opt/spark/conf/slaves
  echo "spark-node-2" >> /opt/spark/conf/slaves
  # set SPARK_MASTER_HOST - allows slave connections to master on PORT 7077 
  CONF_DIR=/opt/spark/conf
  IP=$(ifconfig eth1|grep 'inet '|awk '{print $2}')
  sed "s/# \- SPARK_MASTER_HOST.*/SPARK_MASTER_HOST=$IP/" $CONF_DIR/spark-env.sh.template > $CONF_DIR/spark-env.sh
  chmod 755 $CONF_DIR/spark-env.sh
SCRIPT

$workerScript = <<SCRIPT
  # passwordless ssh from master to slave
  cat /vagrant/host/ssh/spark.pub >> /home/vagrant/.ssh/authorized_keys
  mkdir /root/.ssh
  chown 644 /root/.ssh
  cat /vagrant/host/ssh/spark.pub >> /root/.ssh/authorized_keys
  chown root:root /root/.ssh -R
  chmod 600 /root/.ssh/authorized_keys
  # set SPARK_LOCAL_IP - allows Spark UI to drill down into worker
  CONF_DIR=/opt/spark/conf
  IP=$(ifconfig eth1|grep 'inet '|awk '{print $2}')
  sed "s/# \- SPARK_LOCAL_IP.*/SPARK_LOCAL_IP=$IP/" $CONF_DIR/spark-env.sh.template > $CONF_DIR/spark-env.sh
  chmod 755 $CONF_DIR/spark-env.sh
SCRIPT

Vagrant.configure(2) do |config|
  config.vm.box = "centos/7"
  config.vm.provision "shell", inline: $commonScript
  config.vm.network "public_network", bridge: "eth0"
  config.vm.synced_folder ".", "/vagrant", type: "rsync"
  
  # define master
  config.vm.define "node-0" do |node|
     config.vm.provider "virtualbox" do |node| 
       node.name = "spark-master" 
       node.memory = 2048 
       node.cpus = 1 
     end 
     # expose port 8080 in VM to HOST for Spark UI 
     node.vm.network "forwarded_port", guest: 8080, host: 8080
     node.vm.network "forwarded_port", guest: 4040, host: 4040
     node.vm.hostname = "spark-master"
     node.vm.provision "shell", inline: $masterScript
  end

  # define workers
  (1..2).each do |i|
    config.vm.define "node-#{i}" do |node|
       config.vm.provider "virtualbox" do |node| 
         node.name = "spark-node-#{i}" 
         node.memory = 2048 
         node.cpus = 1 
       end 
       node.vm.network "forwarded_port", guest: 8081, host: "808#{i}"
       node.vm.hostname = "spark-node-#{i}"
       node.vm.provision "shell", inline: $workerScript
    end
  end
end
