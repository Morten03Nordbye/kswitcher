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

# Function to display the active configuration
display_active_config() {
    local current_config=$(readlink -f "$SYMLINK_PATH")
    if [ -n "$current_config" ]; then
        local active_customer_name=$(basename $(dirname "$current_config"))
        local active_config_file=$(basename "$current_config")
        echo -e "${WHITE}Currently Active Configuration: ${ORANGE}$active_customer_name / $active_config_file${RESET}"
    else
        echo -e "${RED}No active configuration detected.${RESET}"
    fi
}

# Function to display configurations with better formatting and symmetrical barriers
display_configs() {
    local prev_customer=""
    local i=1
    local barrier=$(printf '%*s' 80 | tr ' ' '-')
    local current_config=$(readlink -f "$SYMLINK_PATH")

    for config in "${configs[@]}"; do
        local customer_name=$(basename $(dirname "$config"))
        local config_file=$(basename "$config")

        if [[ "$customer_name" != "$prev_customer" ]]; then
            [[ -n "$prev_customer" ]] && echo -e "${ORANGE}$barrier${RESET}"
            prev_customer=$customer_name
        fi

        if [ "$config" == "$current_config" ]; then
            echo -e "${ORANGE}$i) ${WHITE}$customer_name / $config_file (active)${RESET}"
        else
            echo -e "${ORANGE}$i) ${WHITE}$customer_name / $config_file${RESET}"
        fi
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
display_active_config
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

# Check if the selected configuration file is not empty
if [ ! -s "$selected_config" ]; then
    echo -e "${RED}The selected configuration file is empty. Please choose a different file or check the content.${RESET}"
    exit 1
fi

# Update the symlink to point to the selected configuration
ln -sfn "$selected_config" "$SYMLINK_PATH"
echo -e "${ORANGE}Switched to ${WHITE}$(basename $(dirname "$selected_config")) / $(basename "$selected_config")${RESET}"

