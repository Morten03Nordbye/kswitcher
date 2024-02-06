
# kswitcher

This script is designed to streamline the process of managing and switching between different Kubernetes configurations, particularly useful for consultants or administrators managing multiple customer environments. It provides a simplified, interactive interface to select and set a specific Kubernetes configuration as the active one.

## Dependencies

Ensure the following dependencies are met for the script to function correctly:

1. **Bash**: The primary environment for the script.
2. **find & sort**: For locating and organizing Kubernetes configuration files.
3. **ln**: To manage symlinks for Kubernetes configurations.

## Setup Instructions

1. **Clone the repository** and navigate to the script's directory:

   ```bash
   git clone https://github.com/Morten03Nordbye/kswitcher.git
   cd kswitcher
   ```

2. **Make the script executable:**

   ```bash
   chmod +x kswitcher.sh
   ```

3. **Run the script:**

   ```bash
   ./kswitcher.sh
   ```

Follow the prompts to choose and apply the desired Kubernetes configuration.

## Customization

Adjust the following within the script as needed:

- **`CONFIG_DIR`**: Path to the directory containing Kubernetes configurations.
- **`SYMLINK_PATH`**: Destination for the symlink pointing to the active configuration.
- **Color Variables**: Customize the script's appearance by modifying the defined color variables.

## Creating an Alias

For convenience, consider adding an alias to your shell profile (`~/.bashrc`, `~/.zshrc`, etc.):

```bash
alias kswitcher='~/path/to/kswitcher.sh'
```

After adding the alias, apply the changes:

```bash
source ~/.bashrc  # Or the relevant profile file for your shell
```

Now, you can run the script using the `kswitcher` command.

## Example File Structure

The script expects Kubernetes configurations to be stored in a structured manner, typically under `~/.kube/customers`:

```
~/.kube/customers
├── prefix1
│   ├── config1
│   └── config2
└── prefix2
    └── config1
```

Each subdirectory under `customers` represents a different customer or project prefix, containing the actual Kubernetes configuration files.

## Important Notes

- The script's default configuration directory is set to `~/.kube/customers`. Adjust `CONFIG_DIR` in the script if your setup differs.
- Ensure your Kubernetes configurations are organized in a way that makes them easily identifiable when listed by the script.
- Running the script requires permissions to create and modify symlinks in the `.kube` directory.

## Contributing

Contributions are welcome. Fork the repository, make your changes, and submit a pull request. For more information about my projects and professional background, visit [nordbye.it](https://nordbye.it/).

Adjust the README as necessary to align with your project's specific requirements and guidelines.
