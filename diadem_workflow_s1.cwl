cwlVersion: v1.2
class: Workflow

inputs:
  database_name: 
    type: string
    doc: "String with the database name"

  attributes_to_extract: 
    type: string[]
    doc: "List of attributes to extract from the database"

  output_file:
    type: string
    doc: "name CSV file"

outputs:
  database_content:
    type: File
    outputSource: access_database_and_get_data/database_content

steps:
  # Step 1: Access the Database
  access_database_and_get_data:
    run: access_database.cwl
    in:
      database_name: database_name
      attributes_to_extract: attributes_to_extract
      output_file: output_file
    out: [database_content]
    doc: "This step accesses the DIAMOND database and outputs the extracted data in CSV format."

