cwlVersion: v1.2
class: CommandLineTool

baseCommand: python3
arguments: ["create_bigdft_inp.py"]

inputs:
  attributes:
    type: File
    inputBinding:
      position: 1

outputs:
  bigdft_inp_file:
    type: File
    outputBinding:
      glob: "*.txt"
