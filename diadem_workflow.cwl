cwlVersion: v1.2
class: Workflow

inputs:
  database_name: 
    type: string
    doc: "String with the database name"
  database_filter_condition: 
    type: string
    doc: "String giving the condition to filter the database and retrieve the data in CSV form"
  attributes_to_extract: 
    type: string[]
    doc: "List of attributes to extract from the database"
  data_selection_parameters:
    type: string
    doc: "Parameters used for filtering the data selection step"
  hpc_center: 
    type: string
    doc: "The HPC center to which the BigDFT simulation job will be submitted"

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
      condition: database_filter_condition
      attributes_to_extract: attributes_to_extract
    out: [database_content]
    doc: "This step access, extracts the specified attributes, and outputs the data in CSV format."


  # Step 2: Data input selection
  data_selection:
    run: data_selection.cwl
    in:
      data: access_database_and_get_data/database_content
      parameters: data_selection_parameters
    out: [attributes]
    doc: "This step runs the conditions to filter the database, output are the values needed to create the inp file for the BigDFT simulation"

  # Step 3: Create BigDFT Simulation Template
  create_bigdft_inp:
    run: create_bigdft_inp.cwl
    in:
      attributes: data_selection/attributes
    out: [bigdft_inp_file]
    doc: "This step generates a template for the BigDFT simulation using the analysis results."

  # Step 4: Job Submission to HPC Center
  run_simulation:
    run: run_simulation.cwl
    in:
      job_to_be_submitted: create_bigdft_inp/bigdft_inp_file
      hpc_center_name: hpc_center
    out: [simulation_data]

