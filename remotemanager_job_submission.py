import os
import sys
import yaml
import logging
import argparse
from remotemanager import Dataset, URL, BaseComputer

#
# python remotemanager_job_submission.py --function my_simulation_function --hpc_resource summer
#

# Setup the logger
def setup_logger(log_path='hpc_test', log_level='debug'):
    """
    Sets up the logger for the HPC job submission.
    log_path: Path for the log file.
    log_level: Logging level (e.g., 'debug', 'info', 'warning', 'error', 'critical').
    """
    logging.basicConfig(level=log_level.upper(), filename=log_path, 
                        filemode='w', format='%(asctime)s - %(levelname)s - %(message)s')
    logging.info("Logger initialized with path %s and level %s", log_path, log_level)

# Load YAML file for HPC resources
def load_hpc_resources(hpc_resource_name):
    """
    Load the YAML file for the given HPC resource configuration.
    hpc_resource_name: Name of the HPC resource file to load (without '.yaml').
    Returns the host, submitter, and template from the configuration.
    """
    yaml_file_path = f'hpc_rss/hpc_resources_{hpc_resource_name}.yaml'
    try:
        with open(yaml_file_path, 'r') as yaml_file:
            metadata = yaml.safe_load(yaml_file)
        logging.info("HPC resource configuration loaded successfully from %s", yaml_file_path)
        
        hpc_resources = metadata['hpc_resources']  # Load HPC resources (nodes, omp, queue, time)
        return metadata['host'], metadata['submitter'], metadata['template'], hpc_resources
    except Exception as e:
        logging.error("Error loading HPC resource file: %s", e)
        sys.exit(1)

# Create and submit the job to HPC
def submit_job(function, hpc_resource, local_dir='summer_run_test', remote_dir='manager_run_test',
               extra_files_recv=['log.yaml', 'hosts']):
    """
    Submits the job to the HPC cluster based on the provided function and resources.
    hpc_resource: Name of the HPC resource configuration (YAML file).
    """
    # Load HPC resources
    host, submitter, template, hpc_resources = load_hpc_resources(hpc_resource)

    # Extract HPC parameters from the loaded resources
    nodes = hpc_resources['nodes']
    omp = hpc_resources['omp']
    queue = hpc_resources['queue']
    time = hpc_resources['time']
    
    # Setup the job submission using remotemanager
    sub = BaseComputer(template=template, host=host, submitter=submitter)
    
    # Create the dataset (job) for submission
    ds = Dataset(function=function,
                 url=sub,
                 local_dir=local_dir,
                 remote_dir=remote_dir,
                 block_reinit=True,
                 nodes=nodes,
                 omp=omp,
                 queue=queue,
                 time=time,
                 skip=False)
    
    logging.info("Job created with nodes: %d, omp: %d, queue: %s, time: %s", nodes, omp, queue, time)
    
    # Add additional files for tracking
    ds.append_run(extra_files_recv=extra_files_recv)
    
    # Submit the job
    ds.run()
    
    # Wait for job completion and retrieve results
    ds.wait(1, 60)
    logging.info("Job completed, retrieving results...")
    return ds.results

# Argument parsing for command-line inputs
def parse_arguments():
    """
    Parses command-line arguments for HPC job submission.
    """
    parser = argparse.ArgumentParser(description="Submit jobs to HPC clusters using remotemanager.")
    
    # Add arguments for function and hpc_resource
    parser.add_argument('--function', type=str, required=True, help="Function to run remotely on the cluster")
    parser.add_argument('--hpc_resource', type=str, required=True, help="HPC resource configuration file name (without .yaml)")
    parser.add_argument('--log_path', type=str, default='hpc_test', help="Path for logging the job")
    parser.add_argument('--log_level', type=str, default='debug', help="Logging level (debug, info, warning, error, critical)")

    return parser.parse_args()

# Main function
if __name__ == "__main__":
    # Parse command-line arguments
    args = parse_arguments()

    # Setup logger
    setup_logger(log_path=args.log_path, log_level=args.log_level)

    # Load HPC resource parameters from the YAML file
    hpc_resource_data = load_hpc_resources(args.hpc_resource)

    # Extract HPC-specific parameters from the YAML file
    nodes = hpc_resource_data.get('nodes', 2)  # Default value if not found in YAML
    omp = hpc_resource_data.get('omp', 4)      # Default value if not found in YAML
    queue = hpc_resource_data.get('queue', 'short')  # Default value
    time = hpc_resource_data.get('time', '30m')      # Default value

    # Submit job to HPC
    results = submit_job(
        function=args.function,
        hpc_resource=args.hpc_resource,
        nodes=nodes,
        omp=omp,
        queue=queue,
        time=time
    )

    # Log and output results
    logging.info("Job results: %s", results)
    print(f"Job completed successfully. Results: {results}")

