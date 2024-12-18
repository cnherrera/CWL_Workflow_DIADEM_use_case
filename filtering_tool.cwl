cwlVersion: v1.2
class: CommandLineTool

label: "Access Database and Get Data"
doc: >
  This process accesses a DIAMOND database using the rover_diamond library. It allows users to extract
  all attributes or a specified subset, saving the result in a CSV file.

baseCommand: python
arguments: ["filtering_tool.py"]

requirements:
  # Ensure the Python script is accessible within the working directory
  - class: InitialWorkDirRequirement
    listing:
      - class: File
        location: ./filtering_tool.py  # Ensure that this Python script is included in the working directory
      - class: File
        location: ./conditions.json


  # Singularity requirement with the correct path to the Singularity image
  - class: DockerRequirement
    dockerImageId: "/homelocal/ch279548/NUMPEX/ExAToW/DIADEM_use_case/github/CWL_Workflow_DIADEM_use_case/python3.10_with_pandas_numpy_rover.sif"  # Absolute path to the Singularity image

  # Inline Javascript requirement, which is often required for file globbing and other features
  - class: InlineJavascriptRequirement

inputs:
  file_path:
    type: File
    label: "Queried data"
    doc: >
      Queried and filtered data from the DIADEM/DIAMOND database
    inputBinding:
      position: 1
      prefix: "--file_path"

  conditions:
    type: string
    label: "Filtering conditions"
    doc: >
      Filtering conditions as a JSON string (e.g., '{"temperature": "> 300", "pressure": "<= 1"}').
    inputBinding:
      position: 2
      prefix: "--conditions"

  attributes:
    type: string[]?
    label: "List of Attributes"
    doc: >
      List of attributes to extract for the simulation.
    inputBinding:
      position: 3
      prefix: "--attributes"

outputs:
  attributes_files:
    type: File
    label: "Chosen Attributes"
    doc: >
      Output file containing the chosen attributes for the simulation, in the specified format.
    outputBinding:
      glob: "*attributes*.json"  # Assuming the output is a JSON file; adjust if necessary.


