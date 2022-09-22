# CPUSET TOOLS
The tool to setup cpuset.

## HOW TO USE
1. Setup `config.yaml` file.
    - `backup`
        - A cpuset which has tasks executed before cpuset setup in root cpuset. Used for isolation between tasks in other cpusets. 
        - It must be configured to `config.yaml`.
    - Foramt
        ```
        config.yaml
        └───backup
        │   └─  cpus: 7-10
        │
        └───cpuset1
        │   └─  cpus: 1-3
        ```

2. Launch `cpuset_tools.py`. (If you need, use `-h` option.)

