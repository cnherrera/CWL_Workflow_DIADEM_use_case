cwlVersion: v1.2
class: Workflow

inputs:
  database_name: 
    type: string
    doc: "String with the database name"

  attributes_to_extract: 
    type: string[] | string
    doc: "List of attributes to extract from the database"

outputs:
  database_content:
    type: File
    outputSource: access_database_and_get_data/database_contet

steps:
  # Step 1: Access the Database
  access_database_and_get_data:
    run: access_database.cwl
    in:
      database_name: database_name
      attributes_to_extract: attributes_to_extract
    out: [database_content]
    doc: "This step accesses the DIAMOND database and outputs the extracted data in CSV format."

