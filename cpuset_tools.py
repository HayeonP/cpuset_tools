import os
import sys
import yaml
import multiprocessing
import argparse

cpu_num = multiprocessing.cpu_count()

# Args parsing
parser = argparse.ArgumentParser(description='The Tool for setup cpuset')
group = parser.add_mutually_exclusive_group()
group.add_argument('-s', '--setup', help='Setup cpuset by config.yaml', action='store_true')
group.add_argument('-a', '--add', nargs=2, metavar=('pid', 'cpuset'), help='Add pid to cpuset')
group.add_argument('-m', '--monitor', nargs=1, metavar=('cpuset'), help='Monitor tasks in target cpuset')
group.add_argument('-l', '--list', help='List all cpusets configs', action='store_true')
args = parser.parse_args()

# Read configs.yaml
with open('config.yaml') as f:
    cpuset_config = yaml.load(f, Loader=yaml.FullLoader)


if 'backup' not in cpuset_config:
    print('[ERROR] Configuration for "backup" does not exist in config.yaml')

# Setup cpuset
if args.setup:    
    for cpuset in cpuset_config:
        os.system('sudo ./scripts/setup_cpuset.sh ' + cpuset + ' ' + cpuset_config[cpuset]['cpus'])
# Monitor cpuset
elif args.add:
    os.system('sudo ./scripts/add_task.sh '+ args.add[0] + ' ' + args.add[1])
# Add task
elif args.list:
    os.system('sudo bash ./scripts/monitor_cpuset.sh -l')
elif args.monitor:    
    os.system('sudo bash ./scripts/monitor_cpuset.sh -t '+args.monitor[0])
else:
    print('Please select option.')    
