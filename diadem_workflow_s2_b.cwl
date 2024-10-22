cwlVersion: v1.2
class: Workflow

$namespaces:
  cwltool: http://www.commonwl.org/cwltool#  # Add this line for namespaces


inputs:
  database_name: 
    type: string
    label: "Database Name"
    doc: "String with the database name"

  attributes_to_extract: 
    type: string[]
    label: "Attributes to extract from full database"
    doc: "List of attributes to extract from the database"

  attributes_to_simulate: 
    type: string[]
    label: "Attributes to simulate"
    doc: "List of attributes to simulate"

  output_file:
    type: string
    label: "CSV file name"
    doc: "Name of the CSV file"

  conditions:
    type: string
    doc: >
      All filtering conditions as a JSON string to be used to select specific values to simulate (e.g., '{"temperature": "> 300", "pressure": "<= 1"}').
  
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
