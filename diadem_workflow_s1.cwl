cwlVersion: v1.2
class: Workflow

inputs:
  database_name: 
    type: string
    doc: "String with the database name"

  attributes_to_extract: 
    type: string[] | string
    doc: "List of attributes to extract from the database"

  data_selection_parameters:
    type: string
    doc: "Parameters used for filtering the data selection step"

  hpc_resources: 
    type: record
    fields:
      name:
        type: string
        doc: "HPC center name to which the BigDFT simulation job will be submitted"
      nodes:
        type: int
        doc: "Number of nodes to be used in the HPC center"
      jobname:
        type: string
        doc: "Name of the job submitted to the HPC center"
    doc: "Resources configuration for the HPC center"

outputs:
  simulation_output:
    type: File
    outputSource: run_simulation/simulation_data

steps:
  # Step 1: Access the Database
  access_database_and_get_data:
    run: access_database.cwl
    in:
      database_name: database_name
      attributes_to_extract: attributes_to_extract
    out: [database_content]
    doc: "This step accesses the DIAMOND database and outputs the extracted data in CSV format."

