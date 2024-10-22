# Using DIAMOND_rover
import argparse
import rover_diamond as rover
import pandas as pd
import getpass
import re
import json

def get_identifiers():
    """
    Prompt the user for a username and password, using getpass for secure input.
    """
    username = input("Username: ")
    password = getpass.getpass("Password: ")
    return username, password

def get_full_database(database_name, attributes_to_extract='all'):
    """
    Connect to the database and fetch the full dataset, either with all attributes 
    or a specific list of attributes.

    Parameters:
    - database_name (str): Name of the database to connect to.
    - attributes_to_extract (str or list): Either 'all' or a list of specific attributes.

    Returns:
    - dataset_df (pandas.DataFrame): The fetched dataset as a DataFrame.
    """
    # Get identifiers
    username, password = get_identifiers()

    # Database session
    database = rover.connect(username=username, password=password, database=database_name)

    # Get the first collection
    get_collection = database.collections[0]
    
    if len(database.collections) == 1:
        print("Unique collection")

    data_collection = database.collections[get_collection]

    # Find all data in the database
    c_all = (data_collection.reference, "exists", True)

    # Fetching data
    if attributes_to_extract == 'all':
        dataset = database.fetch(c_all)
    else:
        list_attributes = []
        for attribute in attributes_to_extract:
            list_attributes.append(data_collection + '.' + attribute)
        
        # Fetch data with specific attributes
        dataset = database.fetch(c_all, attributes=list_attributes)

    # Convert the dataset to a DataFrame
    dataset_df = dataset.to_dataframe()
    return dataset_df   

def main():
    """
    Main function to process command-line arguments, fetch the database data, and save it as a CSV file.
    """
    # Set up argument parsing
    parser = argparse.ArgumentParser(
        description="Fetch data from a Rover database, either all attributes or a subset.",
        epilog=(
            "Example:\n"
            "python your_script.py my_database --attributes A1 A2 A3 --output data.csv\n"
            "python your_script.py my_database --output data.csv"
        ),
        formatter_class=argparse.RawDescriptionHelpFormatter
    )

    # Required positional argument for database name
    parser.add_argument('database_name', type=str, help="Name of the DIAMOND database to connect to.")

    # Optional argument for attributes to extract
    parser.add_argument(
        '--attributes',
        type=str,
        nargs='+',
        default='all',
        help="List of attributes to extract. If not specified, all attributes are extracted."
    )

    # Optional argument for output file name (default: 'data_from_database.csv')
    parser.add_argument(
        '--output',
        type=str,
        default="data_from_database.csv",
        help="Name of the output CSV file (default: 'data_from_database.csv')."
    )

    # Parse arguments
    args = parser.parse_args()

    # Fetch the full database using the provided arguments
    full_database = get_full_database(args.database_name, args.attributes)

    # Output the processed data to a CSV file
    output_file = args.output
    full_database.to_csv(output_file, index=False)

    print(f"Processed attributes saved to {output_file}")

if __name__ == "__main__":
    main()
