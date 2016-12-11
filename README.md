# Apache Spark stand alone cluster setup by Paul Russo
## Three Centos 7 VMs are provisioned
* node-0 = spark-master node
* node-1 = spark worker node
* node-3 = spark worker node

## Each node downloads and installs
* spark-2.0.2 in /opt/spark
* jdk-8u111-linux-x64 in /opt/jdk

---
### The Master node has passwordless ssh access to the worker nodes

## Steps to start the cluster
1. vagrant up
2. vagrant ssh node-0
3. sudo su
4. /opt/spark/sbin/start-all.sh
5. [http://localhost:8080](http://localhost:8080)

## Check log files
### Check log file on master node
* cat /opt/spark/logs/spark-root-org.apache.spark.deploy.master.Master-1-spark-master.out

### Check log file on worker nodes 
#### logon to worker node from master
  * ssh spark-node-1
  * cat /opt/spark/logs/spark-root-org.apache.spark.deploy.worker.Worker-1-spark-node-1.out
  * exit
  * ssh spark-node-2
  * cat /opt/spark/logs/spark-root-org.apache.spark.deploy.worker.Worker-1-spark-node-2.out

### Notes
* on the master node
   * /opt/spark/conf/slaves is created with the names of the worker nodes
   * SPARK_MASTER_HOST is set in /opt/spark/conf/spark-env.sh to the master ip
     * this allows connections from slave to master on default port 7077
* on the slave node
  * SPARK_LOCAL_IP is set in /opt/spark/conf/spark-env.sh
     * this allows Spark UI to drill down into worker nodes
