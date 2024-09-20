cwlVersion: v1.2
class: CommandLineTool

label: "Data selection for BigDFT simulation"
doc: >
  This process uses the queried data from the database to select the final attributes to be 
  used for the BigDFT calculation.

baseCommand: python3
arguments: ["filtering_tool.py"]

inputs:
  data:
    type: File
    label: "Queried data"
    doc: >
      Queried and filtered data from the DIADEM/DIAMOND database
    inputBinding:
      position: 1
  parameters:
    type: string
    label: "Parameters"
    inputBinding:
      position: 2

outputs:
  attributes:
    type: File
    outputBinding:
      glob: "*.csv"
