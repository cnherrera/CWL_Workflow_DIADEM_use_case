cwlVersion: v1.2
class: CommandLineTool

label: "Access Database and Get Data"
doc: >
  This process accesses a database using the rover_diamond libraries. It was thought to access
  a numerical simulation database, which name is given as input. Needs to have access without 
  authentication (r.g. token).  
  Database contains attributes and dictionaries, outputs of the results as a CSV file. 


baseCommand: python3
arguments: ["access_database.py"]

inputs:
  database_name:
    type: string
    label: "DIADEM/DIAMOND Database filename"
    doc: >
      Name of the DIAMOND database hosted at TGCC-cloud. 
    inputBinding:
      position: 1
  condition:
    type: string
    label: "Condition to get data"
    inputBinding:
      position: 2
  attributes_to_extract:
    type: string[]
    label: "List of Attributes to Extract"
    doc: >
      A list of attributes (as strings) that the user wants to extract from the database.
      These attributes will be used to filter and extract specific data from the input database file.
    inputBinding:
      position: 3


outputs:
  database_content:
    type: File
    label: "Attributes of the numerical simulation CSV"
    doc: >
      A CSV file containing the results from fetching the data
    outputBinding:
      glob: "*.csv"
