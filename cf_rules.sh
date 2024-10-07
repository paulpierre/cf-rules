#!/bin/bash



# Your Cloudflare email address
CF_EMAIL="your_cloudflare_email@example.com"

# Your Cloudflare Global API Key
CF_GLOBAL_API_KEY="your_global_api_key_here"


#!/usr/bin/env bash

# Cloudflare API base URL
API_BASE_URL="https://api.cloudflare.com/client/v4"

# ANSI color codes
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to get all zones for the account, handling pagination
get_zones() {
    local page=1
    local total_pages=1
    while [ "$page" -le "$total_pages" ]; do
        # Fetch zones for the current page
        response=$(curl -s -X GET "$API_BASE_URL/zones?page=$page&per_page=50" \
        -H "X-Auth-Email: $CF_EMAIL" \
        -H "X-Auth-Key: $CF_GLOBAL_API_KEY" \
        -H "Content-Type: application/json")
        
        # Check for curl errors
        if [ $? -ne 0 ]; then
            echo "Error: Failed to fetch zones" >&2
            exit 1
        fi
        
        # Check for API errors
        if ! echo "$response" | jq -e '.success' > /dev/null; then
            echo "API Error: $(echo "$response" | jq -r '.errors[0].message')" >&2
            exit 1
        fi
        
        # Extract the total number of pages (from the first request)
        total_pages=$(echo "$response" | jq -r '.result_info.total_pages')
        
        # Output the zone IDs and names from the current page
        echo "$response" | jq -r '.result[] | .id, .name'
        
        # Increment the page number for the next iteration
        ((page++))
    done
}

# Function to get all page rules for a zone and print the count next to the zone name
get_page_rules() {
    local zone_id=$1
    local zone_name=$2
    
    # Get the page rules for the zone
    response=$(curl -s -X GET "$API_BASE_URL/zones/$zone_id/pagerules" \
    -H "X-Auth-Email: $CF_EMAIL" \
    -H "X-Auth-Key: $CF_GLOBAL_API_KEY" \
    -H "Content-Type: application/json")
    
    # Check for curl errors
    if [ $? -ne 0 ]; then
        echo "Error: Failed to fetch page rules for zone $zone_name" >&2
        return
    fi
    
    # Check for API errors
    if ! echo "$response" | jq -e '.success' > /dev/null; then
        echo "API Error for zone $zone_name: $(echo "$response" | jq -r '.errors[0].message')" >&2
        return
    fi
    
    # Get the number of page rules
    page_rules=$(echo "$response" | jq '.result | length')
    
    # Print the zone name and the number of page rules with color coding
    if [ "$page_rules" -gt 3 ]; then
        echo -e "${RED}❌ Zone: $zone_name | Page Rules: $page_rules${NC}"
    elif [ "$page_rules" -eq 3 ]; then
        echo -e "${YELLOW}Zone: $zone_name | Page Rules: $page_rules${NC}"
    else
        echo "Zone: $zone_name | Page Rules: $page_rules"
    fi
}

# Main script logic
main() {
    # Fetch all zones (with pagination)
    zones=$(get_zones)
    
    # Loop through each zone
    while read -r zone_id && read -r zone_name; do
        #echo "Processing zone: $zone_name ($zone_id)"
        get_page_rules "$zone_id" "$zone_name"
        #echo "------------------------"
    done <<< "$zones"
}

# Run the script
main