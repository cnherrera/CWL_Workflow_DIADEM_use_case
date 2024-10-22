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
    doc: "Name of the CSV file"

  conditions:
    type: string
    doc: >
      Filtering conditions as a JSON string (e.g., '{"temperature": "> 300", "pressure": "<= 1"}').
  
outputs:
  chosen_attributes:
    type: File
    outputSource: data_selection/attributes

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

  # Step 2: Data Selection
  data_selection:
    run: data_selection.cwl
    in:
      data: access_database_and_get_data/database_content
      conditions: conditions
      attributes: attributes_to_extract
    out: [attributes]
    doc: "This step processes the queried data to select the final attributes for the BigDFT simulation."
