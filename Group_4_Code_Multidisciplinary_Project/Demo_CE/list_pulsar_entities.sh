#!/bin/bash

# Define the full path to pulsar-admin
PULSAR_ADMIN="/pulsar/bin/pulsar-admin"

# Function to print a separator
print_separator() {
    echo "============================"
}

# Get and print all tenants
echo "=== Listing all Tenants ==="
tenants=$($PULSAR_ADMIN tenants list)
echo "$tenants"
print_separator

# Loop through each tenant to get namespaces
for tenant in $tenants; do
    echo "=== Listing all Namespaces for Tenant: $tenant ==="
    namespaces=$($PULSAR_ADMIN namespaces list $tenant)
    
    if [[ -z "$namespaces" ]]; then
        echo "No namespaces found"
    else
        echo "$namespaces"
        print_separator
        
        # Loop through each namespace to get topics
        for namespace in $namespaces; do
            echo "=== Listing all Topics in Namespace: $namespace ==="
            topics=$($PULSAR_ADMIN topics list $namespace)
            
            if [[ -z "$topics" ]]; then
                echo "No topics found"
            else
                echo "$topics"
            fi
            print_separator
        done
    fi
done

echo "Script finished!"