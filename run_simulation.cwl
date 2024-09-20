cwlVersion: v1.2
class: CommandLineTool

label: "Sendind Job to HPC center"
doc: >
  This process uses remotemanager to send the job to a
  HPC center.

baseCommand: python3
arguments: ["run_simulation.py"]

inputs:
  job_to_be_submitted:
    type: File
    inputBinding:
      position: 1
  hpc_center:
    type: string
    inputBinding:
      position: 2

outputs:
  simulation_data:
    type: File
    outputBinding:
      glob: "*.yaml"
