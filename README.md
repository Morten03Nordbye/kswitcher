
# kswitcher

![image](https://github.com/Morten03Nordbye/kswitcher/assets/74780083/b2c05fd6-befa-4c29-98c9-597dd73f8cdd)

This script is designed to streamline the process of managing and switching between different Kubernetes configurations, particularly useful for consultants or administrators managing multiple customer environments. It provides a simplified, interactive interface to select and set a specific Kubernetes configuration as the active one. Additionally, the script now supports executing any command after switching the configuration, allowing for seamless transitions between environments and immediate command execution.

## Dependencies

Ensure the following dependencies are met for the script to function correctly:

1. **Bash**: The primary environment for the script.
2. **find & sort**: For locating and organizing Kubernetes configuration files.
3. **ln**: To manage symlinks for Kubernetes configurations.
4. **kubectl** (optional): If intending to use Kubernetes commands post-switch.

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

3. **Run the script optionally with a command to execute after switching:**

   ```bash
   ./kswitcher.sh '<command>'
   ```

   Replace `<command>` with any command you wish to execute after the configuration switch. For example, `./kswitcher.sh 'kubectl get nodes'`.

## Customization

Adjust the following within the script as needed:

- **`CONFIG_DIR`**: Path to the directory containing Kubernetes configurations.
- **`SYMLINK_PATH`**: Destination for the symlink pointing to the active configuration.
- **Color Variables**: Customize the script's appearance by modifying the defined color variables.

## Creating an Alias with Command Support

For convenience, consider adding aliases to your shell profile (`~/.bashrc`, `~/.zshrc`, etc.) to support both fixed and dynamic command execution:

```bash
# Alias for fixed command execution
alias kswitcher"/path/to/kswitcher.sh 'kubectl get nodes'"

# Alias for dynamic command execution
alias kswitcher"/path/to/kswitcher.sh"
```

After adding the aliases, apply the changes:

```bash
source ~/.bashrc  # Or the relevant profile file for your shell
```

Now, you have the flexibility to use `kswitcher_nodes` for a quick `kubectl get nodes` command after switching configurations, or use `kswitcher` with any command you need to run post-switch.

## Example File Structure

Ensure your Kubernetes configuration files are organized within the `CONFIG_DIR` directory. The script will automatically find and list these configurations for selection.

## Important Notes

- The script's default configuration directory is set to `~/.kube/customers`. Adjust `CONFIG_DIR` in the script if your setup differs.
- Ensure your Kubernetes configurations are organized in a way that makes them easily identifiable when listed by the script.
- Running the script requires permissions to create and modify symlinks in the `.kube` directory.

## Contributing

Contributions are welcome. Fork the repository, make your changes, and submit a pull request. For more information about my projects and professional background, visit [nordbye.it](https://nordbye.it/).

Adjust the README as necessary to align with your project's specific requirements and guidelines.
