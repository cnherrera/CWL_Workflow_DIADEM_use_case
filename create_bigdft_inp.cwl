cwlVersion: v1.2
class: CommandLineTool

label: "Create BigDFT inp file"
doc: >
  This process creates the input file for the BigDFT
  dimulation

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
