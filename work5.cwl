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

  hpc_resource:
    type: string
    label: "HPC Resource"
    doc: "HPC resource configuration file (without '.yaml'). For example: 'summer', 'tgcc', or 'genci'."

outputs:
  chosen_attributes:
    type: File
    label: "Chosen attributes to simulate"
    outputSource: data_selection/attributes

  bigdft_input_file:
    type: File
    label: "BigDFT Input YAML"
    outputSource: create_bigdft_input/bigdft_inp_file
    doc: "YAML file generated for BigDFT simulation input"

  hpc_job_results:
    type: File
    label: "HPC Job Results"
    outputSource: submit_hpc_job/job_results

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
      attributes: attributes_to_simulate
    out: [attributes]
    doc: "This step processes the queried data to select the final attributes for the BigDFT simulation."

  # Step 3: Create BigDFT Input File
  create_bigdft_input:
    run: create_bigdft_inp.cwl
    in:
      attributes: data_selection/attributes
    out: [bigdft_inp_file]
    doc: "This step takes the selected attributes and creates a BigDFT YAML input file."

  # Step 4: Submit HPC Job
  submit_hpc_job:
    run: submit_hpc_job.cwl
    in:
      function: create_bigdft_input/bigdft_inp_file
      hpc_resource: hpc_resource
    out: [job_results]
    doc: "This step submits the simulation job to the HPC cluster using the remotemanager module and the specified HPC resource."
