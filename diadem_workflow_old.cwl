cwlVersion: v1.2
class: Workflow

inputs:
  database_name: 
    type: string
    doc: "String with the database name"
  database_filter_condition: 
    type: string
    doc: "String giving the condition to filter the database and retrieve the data in CSV form"
  hpc_center: 
    type: string
    doc: "The HPC center to which the BigDFT simulation job will be submitted"

outputs:
  simulation_output:
    type: File
    outputSource: run_simulation/simulation_data

steps:
  # Step 1: Access the Database
  access_database:
    run: access_database.cwl
    in:
      database_name: database_name
    out: [database_content]
    doc: "This step access and retrieves the database" 

  # Step 2: Filtering Tool
  filtering_tool:
    run: filtering_tool.cwl
    in:
      data: access_database/database_content
      condition: database_filter_condition
    out: [attributes]
    doc: "This step runs the conditions to filter the database, output are the values needed to create the inp file for the BigDFT simulation"

  # Step 3: Create BigDFT Simulation Template
  create_bigdft_inp:
    run: create_bigdft_inp.cwl
    in:
      attributes: filtering_tool/attributes
    out: [bigdft_inp_file]
    doc: "This step generates a template for the BigDFT simulation using the analysis results."

  # Step 4: Job Submission to HPC Center
  run_simulation:
    run: run_simulation.cwl
    in:
      job_to_be_submitted: create_bigdft_inp/bigdft_inp_file
      hpc_center: hpc_center
    out: [simulation_data]
