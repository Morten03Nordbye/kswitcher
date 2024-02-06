#!/bin/bash

# Define color variables
ORANGE='\033[38;5;208m'  # Orange color from the 256-color palette
WHITE='\033[1;37m'       # Bright White for better readability
RESET='\033[0m'          # Reset to default terminal color
RED='\033[0;31m'         # Red color for error messages

# Define the directory containing the config files
CONFIG_DIR="$HOME/.kube/customers"

# Define the symlink path for the kube config
SYMLINK_PATH="$HOME/.kube/config"

# Function to display a colorful header with ASCII art
display_header() {
    echo -e "${ORANGE}"
    echo "    __ __      __              __  __           __                               "
    echo "   / //_/_  __/ /_  ___  _____/ /_/ /     _____/ /_  ____ _____  ____ ____  _____"
    echo "  / ,< / / / / __ \\/ _ \\/ ___/ __/ /_____/ ___/ __ \\/ __ \`/ __ \\/ __ \`/ _ \\/ ___/"
    echo " / /| / /_/ / /_/ /  __/ /__/ /_/ /_____/ /__/ / / / /_/ / / / / /_/ /  __/ /    "
    echo "/_/ |_|\\__,_/_.___/\\___/\\___/\\__/_/      \\___/_/ /_/\\__,_/_/ /_/\\__, /\\___/_/     "
    echo "                                                              /____/             "
    echo -e "${RESET}"
    echo -e "${ORANGE}Available Kubernetes Configurations:${RESET}"
}

# Function to display configurations with better formatting and symmetrical barriers
display_configs() {
    local prev_customer=""
    local i=1
    local barrier=$(printf '%*s' 80 | tr ' ' '-')  # Dynamic barrier length
    
    for config in "${configs[@]}"; do
        # Extract customer name and config file name
        local customer_name=$(basename $(dirname "$config"))
        local config_file=$(basename "$config")

        # Insert a symmetrical barrier between different customers
        if [[ "$customer_name" != "$prev_customer" ]]; then
            [[ -n "$prev_customer" ]] && echo -e "${ORANGE}$barrier${RESET}" # Orange barrier line
            prev_customer=$customer_name
        fi

        # Display customer name in orange and config file in white for readability
        echo -e "${ORANGE}$i) ${WHITE}$customer_name / $config_file${RESET}"
        ((i++))
    done
}

# Find all config files in the CONFIG_DIR directory and sort them
configs=($(find "$CONFIG_DIR" -type f | sort))
if [ ${#configs[@]} -eq 0 ]; then
    echo -e "${RED}No configurations found in $CONFIG_DIR. Please check the directory and try again.${RESET}"
    exit 1
fi

display_header
display_configs

# Prompt the user to select a configuration
echo -ne "${WHITE}Select configuration to use (1-${#configs[@]}) or type 'cancel' to exit: ${RESET}"
read -r selection

# Allow user to cancel operation
if [[ "$selection" == "cancel" ]]; then
    echo -e "${ORANGE}Operation cancelled by user.${RESET}"
    exit 0
fi

# Validate the input is a number within range
if ! [[ "$selection" =~ ^[0-9]+$ ]] || [ "$selection" -lt 1 ] || [ "$selection" -gt "${#configs[@]}" ]; then
    echo -e "${RED}Invalid selection. Exiting.${RESET}"
    exit 1
fi

selected_config="${configs[$((selection-1))]}"

# Validate selected configuration file
if ! kubectl --kubeconfig="$selected_config" config view &> /dev/null; then
    echo -e "${RED}The selected configuration file is not valid. Please check the file and try again.${RESET}"
    exit 1
fi

# Update the symlink to point to the selected configuration
ln -sfn "$selected_config" "$SYMLINK_PATH"
echo -e "${ORANGE}Switched to ${WHITE}$(basename $(dirname "$selected_config")) / $(basename "$selected_config")${RESET}"
