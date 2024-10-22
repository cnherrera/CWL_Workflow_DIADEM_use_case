# Script to create the input file for the BigDFT simulation
import json
import yaml
import argparse

def convert_json_to_yaml(attributes_file, output_file):
    # Read the JSON file
    with open(attributes_file, 'r') as json_file:
        attributes_data = json.load(json_file)
    
    # Convert to YAML and write to output file
    with open(output_file, 'w') as yaml_file:
        yaml.dump(attributes_data, yaml_file, default_flow_style=False)

if __name__ == "__main__":
    # Parse command-line arguments
    parser = argparse.ArgumentParser(description='Convert selected attributes from JSON to YAML for BigDFT.')
    parser.add_argument('--attributes', required=True, help='Path to the JSON file with selected attributes.')
    parser.add_argument('--output', required=True, help='Path to save the output YAML file.')
    args = parser.parse_args()

    # Convert JSON to YAML
    convert_json_to_yaml(args.attributes, args.output)
