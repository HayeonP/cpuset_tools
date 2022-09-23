#!/bin/bash

if [ -z "$1" ]
  then
    echo "There is no input argument"
    echo "$ setup_cpuset.sh {number of cpuset}"
    exit
fi

if [[ $(id -u) -ne 0 ]]; then 
	echo "Please run as root"
  exit
fi

cpuset_name=$1
cpuset_cpus=$2

number_of_cores=`grep -c ^processor /proc/cpuinfo`

# sched rt check off
sudo echo -1 > /proc/sys/kernel/sched_rt_runtime_us 

# Root cpuset setup
/bin/echo 1 > /sys/fs/cgroup/cpuset/cpuset.cpu_exclusive
/bin/echo 1 > /sys/fs/cgroup/cpuset/cpuset.sched_load_balance

# Setup new cpuset

if [ ! -d /sys/fs/cgroup/cpuset/${cpuset_name} ]; then
  mkdir /sys/fs/cgroup/cpuset/${cpuset_name} &> /dev/null
fi

/bin/echo 0 > /sys/fs/cgroup/cpuset/${cpuset_name}/cpuset.mems
/bin/echo ${cpuset_cpus} > /sys/fs/cgroup/cpuset/${cpuset_name}/cpuset.cpus
/bin/echo 1 > /sys/fs/cgroup/cpuset/${cpuset_name}/cpuset.sched_load_balance
/bin/echo 1 > /sys/fs/cgroup/cpuset/${cpuset_name}/cpuset.cpu_exclusive
/bin/echo 0 > /sys/fs/cgroup/cpuset/${cpuset_name}/cpuset.mem_exclusive
/bin/echo 1 > /sys/fs/cgroup/cpuset/${cpuset_name}/cpuset.memory_migrate

printf "[${cpuset_name}] cpuset.cpus: "
cat /sys/fs/cgroup/cpuset/${cpuset_name}/cpuset.cpus
printf "[${cpuset_name}] cpuset.cpu_exclusive: "
cat /sys/fs/cgroup/cpuset/${cpuset_name}/cpuset.cpu_exclusive
printf "[${cpuset_name}] cpuset.sched_load_balance: "
cat /sys/fs/cgroup/cpuset/${cpuset_name}/cpuset.sched_load_balance

if [ ${cpuset_name} = 'backup' ]; then
  echo "[STATUS] Move tasks in [root] tasks to [backup]..."
  for T in $(cat /sys/fs/cgroup/cpuset/tasks);
  do
    sudo scripts/add_task.sh $T "backup" &> /dev/null 
  done
  echo "[STATUS] Complete"  
fi

