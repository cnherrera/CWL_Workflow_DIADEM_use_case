cwlVersion: v1.2
class: CommandLineTool

inputs:
  attributes:
    type: File
    label: "Selected attributes (JSON)"
    doc: "File containing the selected attributes to simulate, in JSON format."

outputs:
  bigdft_inp_file:
    type: File
    label: "BigDFT Input YAML"
    outputBinding:
      glob: "bigdft_inp_file.yaml"

baseCommand: [python3, create_bigdft_input.py]  # You will write this Python script for converting JSON to YAML

arguments:
  - "--attributes"
  - $(inputs.attributes.path)
  - "--output"
  - "bigdft_inp_file.yaml"
