# Using DIAMOND_rover

Add stuff
import rover_diamond
import pandas as pd



def get_full_database(database_name)
    database = rover.connect(username=username, password=password,database=database_name)
    # get the collection
    for collection in database.collections:
        get_collection = collection

    data_collection = database.collections[get_collection]

    c_all = (data_collection.reference, "exists", True)
    database.search(c_all)

   #Fetching










def main():
    database_name = sys.argv[1]
    
    full_database = get_full_database(database_name)

    # Output the processed data
    output_file = "data_from_database"
    with open(output_file, 'w') as f:
        json.dump(processed_attributes, f, indent=4)

    print(f"Processed attributes saved to {output_file}")

if __name__ == "__main__":
    main()
