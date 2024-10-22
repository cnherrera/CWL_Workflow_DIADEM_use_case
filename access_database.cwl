cwlVersion: v1.2
class: CommandLineTool

label: "Access Database and Get Data"
doc: >
  This process accesses a DIAMOND database using the rover_diamond library. It allows users to extract
  all attributes or a specified subset, saving the result in a CSV file.

baseCommand: python3
arguments: ["access_database.py"]

inputs:
  database_name:
    type: string
    label: "DIADEM/DIAMOND Database filename"
    doc: >
      Name of the DIADEM/DIAMOND database to connect to.
    inputBinding:
      position: 1

  attributes_to_extract:
    type: string[]
    label: "List of Attributes to Extract"
    doc: >
      A list of attributes (as strings) that the user wants to extract from the database.
      If not specified, all attributes are extracted by default.
    inputBinding:
      position: 2
      prefix: "--attributes"

  output_file:
    type: string
    label: "Output CSV file"
    doc: >
      Name of the CSV file to save the extracted data. Defaults to 'data_from_database.csv' if not specified.
    inputBinding:
      position: 3
      prefix: "--output"

outputs:
  database_content:
    type: File
    label: "Extracted data as CSV"
    doc: >
      The output is a CSV file containing the extracted attributes from the DIAMOND database.
    outputBinding:
      glob: "$(inputs.output_file)"

