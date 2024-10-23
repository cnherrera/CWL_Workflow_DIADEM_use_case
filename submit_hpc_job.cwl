cwlVersion: v1.2
class: CommandLineTool

label: "Submit HPC Job"
doc: >
  This step submits a simulation job to the HPC resource using the provided HPC submission template and simulation function.

inputs:
  bigdft_simulation_function:
    type: File
    label: "BigDFT simulation Function to run"
    doc: "YAML file containing the Python simulation function to be executed on the HPC."
    inputBinding:
      position: 1
      prefix: "--function"

  hpc_resource:
    type: string
    label: "HPC Resource"
    doc: "HPC resource configuration file (without '.yaml')"
    inputBinding:
      position: 2
      prefix: "--hpc_resource"

  log_path:
    type: string
    label: "Log File Path"
    doc: "Path for logging the job"
    inputBinding:
      position: 3
      prefix: "--log_path"
#      default: "hpc_test"

  log_level:
    type: string
    label: "Log Level"
    doc: "Logging level (debug, info, warning, error, critical)"
    inputBinding:
      position: 4
      prefix: "--log_level"
#      default: "debug"

outputs:
  hpc_job_results:
    type: stdout
    label: "Job Submission Results"
    doc: "Results of the HPC job submission"

stdout: "hpc_job_results.log"

requirements:
  ResourceRequirement:
    coresMin: 1
    ramMin: 1024
  InlineJavascriptRequirement: {}



baseCommand: ["python3", "remotemanager_job_submission.py"]
