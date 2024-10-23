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

  hpc_resources:
    type: File
    label: "HPC Resources YAML"
    doc: "YAML file containing all the HPC submission details such as resource type, nodes, queue, etc."
    inputBinding:
      position: 2
      prefix: "--hpc_resources"

outputs:
  job_log:
    type: File
    label: "Job Submission Log"
    doc: "Log file generated from the HPC job submission."
    outputBinding:
      glob: "job_submission_log.txt"

baseCommand: ["python3", "remotemanager_job_submission.py"]
