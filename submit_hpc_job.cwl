cwlVersion: v1.2
class: CommandLineTool

label: "Submit HPC Job"
doc: >
  This step submits a simulation job to the HPC resource using the provided HPC submission template and simulation function.

inputs:
  simulation_function:
    type: File
    label: "Simulation Function (YAML)"
    doc: "The YAML file containing the simulation function to be executed on the HPC."
    inputBinding:
      position: 1
      prefix: "--function"

  hpc_resource:
    type: string
    label: "HPC Resource Type"
    doc: "The type of HPC resource (e.g., slurm, pbs)."
    inputBinding:
      position: 2
      prefix: "--hpc_resource"

  nodes:
    type: int
    label: "Number of Nodes"
    doc: "The number of nodes to use for the job."
    inputBinding:
      position: 3
      prefix: "--nodes"

  omp:
    type: int
    label: "Number of OpenMP Threads"
    doc: "The number of OpenMP threads to use."
    inputBinding:
      position: 4
      prefix: "--omp"

  queue:
    type: string
    label: "Queue Name"
    doc: "The name of the HPC queue to submit the job to."
    inputBinding:
      position: 5
      prefix: "--queue"

  time:
    type: string
    label: "Job Time Limit"
    doc: "The time limit for the job (e.g., 2h, 30m)."
    inputBinding:
      position: 6
      prefix: "--time"

outputs:
  job_log:
    type: File
    label: "Job Submission Log"
    doc: "Log file generated from the HPC job submission."
    outputBinding:
      glob: "job_submission_log.txt"

baseCommand: ["python3", "submit_hpc_job.py"]
