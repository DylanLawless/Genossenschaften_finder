#!/bin/bash

# ANSI Color Codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Introductory notice for the user
clear
echo ""
echo -e "${YELLOW}Starting Genossenschaften monitoring...${NC}"
echo ""
echo -e "${GREEN}✅ No change detected${NC} - since the last recorded check."
echo -e "${RED}🚨 Change detected${NC} - review is recommended."
echo -e "${YELLOW}⚠️ Initial hash stored${NC} - First-time setup for this webpage."
echo "Results for each page :"
echo ""

# Array of names
names=("BGL" "Zuercher_Bau" "BDZ")

# Array of corresponding URLs
urls=("https://www.bgl-zuerich.ch/vermietungen" "https://www.zbwg.ch/siedlungen/wie-bewerbe-ich-mich/" "https://bdz.ch/vermietung/")

# Directory to store checksum files and logs
HASH_DIR="checksums"
mkdir -p "$HASH_DIR"

# Function to check webpage
check_webpage() {
    local name="$1"
    local url="$2"

    # File to store the current checksum
    local current_hash_file="${HASH_DIR}/${name}_hash.txt"
    # File to store the date of last change
    local last_change_file="${HASH_DIR}/${name}_last_change.txt"

    # Fetch the webpage using curl
    local content=$(curl -s "$url")

    # Generate a checksum of the webpage content
    local new_hash=$(echo "$content" | md5 | awk '{print $1}')

    # Check if the checksum file exists
    if [ ! -f "$current_hash_file" ]; then
        echo "$new_hash" > "$current_hash_file"
        echo "$(date '+%Y%m%d') - Initial hash stored" > "$last_change_file"
        echo -e "${YELLOW}⚠️  Initial hash stored for $name on $(date '+%Y%m%d')${NC}"
        return
    fi

    # Read the last checksum
    local old_hash=$(cat "$current_hash_file")
    # Initialize or read the last change date
    if [ ! -f "$last_change_file" ]; then
        echo "$(date '+%Y%m%d')" > "$last_change_file"
        local last_change_date="$(date '+%Y%m%d')"
    else
        local last_change_date=$(cat "$last_change_file")
    fi

    # Compare the old and new checksums
    if [ "$new_hash" != "$old_hash" ]; then
        # Notify the user
        echo -e "${RED}🚨 Change detected at $url ($name). Check the webpage.${NC}"
        # Update the checksum and last change date files
        echo "$new_hash" > "$current_hash_file"
        echo "$(date '+%Y%m%d')" > "$last_change_file"
    else
        echo -e "${GREEN}✅ No change detected for $name since $last_change_date.${NC}"
    fi
}

# Loop through all webpages
for i in "${!names[@]}"; do
    check_webpage "${names[$i]}" "${urls[$i]}"
done
echo ""

