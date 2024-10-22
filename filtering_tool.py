#From the full database,  analyse and extract (or estoimate) the properties (atoms?, positions?) that will be used for the input file for the simulation.
import pandas as pd
import numpy as np
import argparse

# Function to read the CSV file and return a dataframe
def read_csv_data(file_path):
    try:
        data = pd.read_csv(file_path)
        print("CSV file read successfully.")
        return data
    except Exception as e:
        print(f"Error reading the file: {e}")
        return None

# Filter data based on input conditions
def filter_data(data, conditions):
    """
    To apply filtering conditions to analyse data.
    We use the .query method from pandas to filter.
    """
    print("Analyzing data based on provided conditions...")
    filtered_data = data.copy()

    # Apply the conditions
    for column, condition in conditions.items():
        if column in filtered_data.columns:
            filtered_data = filtered_data.query(f"{column} {condition}")
        else:
            print(f"Warning: {column} not found in the data.")
    
    return filtered_data

# Function to chose and extract attributes
def extract_attributes(data, attributes):
    """
    Chose and  extract specific attributes for BigDFT simulation.
    """
    print("Choosing attributes and values")
    # DO stuff to chose this. Finding outliers in energy for instance.
    # out: chosen daa

    print("Extracting relevant attributes...")
    # 
    if 'atomic_positions' in data.columns:
        atomic_positions = data['atomic_positions'].values
    else:
        atomic_positions = None
        print("Atomic positions not found in the dataset.")
    
    # ...
    #  Write a json file?


    return  dict_attributes_for_simu

# Process steps
def process_data(file_path, conditions, attributes):
    # 1. Read CSV file
    data = read_csv_data(file_path)
    if data is None:
        return

    # 2. Apply filtering
    analyzed_data = filter_data(data, conditions)

    # 3. Extract attributes
    attributes = extract_attributes(analyzed_data,attributes)

    # 4. Show chosen data
    if attributes is not None:
	print("Chosen attributes for simulation")
        for key, value in attributes.items():
		print(f"{key}: {value}")
        print(f"Extracted attributes (atomic positions): {attributes}")
    else:
        print("No attributes to display.")

    return attributes


if __name__ == "__main__":
    # Set up argument parsing
    parser = argparse.ArgumentParser(
        description="Process data based on input conditions and attributes.",
        epilog=(
            "Example:\n"
            "python your_script.py path_to_your_data.csv \\\n"
            '--conditions \'{"temperature": "> 300", "pressure": "<= 1"}\' \\\n'
            "--attributes A1 A2"
        ),
        formatter_class=argparse.RawDescriptionHelpFormatter
    )
    parser = argparse.ArgumentParser(description="Process data based on input conditions.")
    
    # Argument for the file path
    parser.add_argument('file_path', type=str, help='Path to the CSV data file')
    
    # Argument for conditions (passed as a stringified dictionary)
    parser.add_argument('--conditions', type=str, help="Filtering conditions (example: '{\"temperature\": \"> 300\", \"pressure\": \"<= 1\"}')", required=True)

    # Argument for attributes (list of column names)
    parser.add_argument('--attributes', type=str, nargs='+', help='List of attributes to include for next simulation', required=True)

    # Parse arguments
    args = parser.parse_args()

    # Convert the conditions string to a dictionary
    conditions = eval(args.conditions)

    # Call the process_data function with parsed arguments
    process_data(args.file_path, conditions, args.attributes)

