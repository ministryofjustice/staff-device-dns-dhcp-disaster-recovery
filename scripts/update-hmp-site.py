import json, sys

# Check if the file path argument is provided
if len(sys.argv) < 2:
    print("Usage: python3 update-hmp-site.py <dhcp_config_json_file_path>")
    sys.exit(1)

# Retrieve the file path argument
json_file_path = sys.argv[1]

# Defining the sites that requires update. More can be added to the list
sites_requirring_update = ["HMP", "HMYOI"]

# Define the new domain value to replace the existing entry
new_domain = "dom1.infra.int"

# Read the JSON data from the file
with open(json_file_path) as json_file:
    json_data = json.load(json_file)

def extract_client_classes_subnet_value_for_sites(json_data, sites):
    client_classes = []  # Initialize an empty list to collect the values for client classes

    for shared_network in json_data["Dhcp4"]["shared-networks"]:
        # Using the get method to handle missing or empty fields in the JSON data.
        for subnet_entry in shared_network.get("subnet4", []):
            user_context = subnet_entry.get("user-context", {})
            site_name = user_context.get("site-name", "")
            if any(site_name.startswith(site) for site in sites):
                require_client_classes = subnet_entry.get("require-client-classes", [])
                client_classes.extend(require_client_classes)  # Append the values to the list

    return client_classes  # Return the collected list of client classes

def update_domain_name_for_specific_site(json_data, subnets, new_domain):
    for client_class in json_data["Dhcp4"]["client-classes"]:
        if any(subnet in client_class["name"] for subnet in subnets):
            option_data = client_class.get("option-data", [])
            for entry in option_data:
                if entry["name"] == "domain-name":
                    entry["data"] = new_domain

# Call the function and get the list of client classes for defined  sites
client_classes_subnet_value_list = extract_client_classes_subnet_value_for_sites(json_data, sites_requirring_update)

# Call the function to update the domain name entry
update_domain_name_for_specific_site(json_data, client_classes_subnet_value_list, new_domain)

# Write the modified JSON data to the output file named updated_dhcp_config.json
output_file_path = "updated_dhcp_config.json"
with open(output_file_path, 'w') as json_output_file:
    json.dump(json_data, json_output_file, indent=4)
