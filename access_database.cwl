cwlVersion: v1.2
class: CommandLineTool

label: "Access Database Tool"
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

outputs:
  database_content:
    type: File
    label: "Attributes of the numerical simulation CSV"
    doc: >
      A CSV file containing the results from fetching the data
    outputBinding:
      glob: "*.csv"
