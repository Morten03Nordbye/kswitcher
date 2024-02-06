
# kswitcher

## Introduction
`kswitcher` is a utility script designed to simplify the process of switching between different Kubernetes (kubectl) configurations. This is particularly useful for developers and system administrators who manage multiple Kubernetes clusters and need an efficient way to switch context.

## Requirements
- `kubectl` installed on your system.
- Properly configured Kubernetes configuration files.

## Installation
1. Clone the `kswitcher` repository to your local machine.
2. Ensure `kswitcher.sh` is executable: `chmod +x kswitcher.sh`

## Usage
To switch between Kubernetes configurations, run the `kswitcher.sh` script followed by the name of the configuration you wish to use. The configurations should be stored in the `customers` directory.

Example:
```bash
./kswitcher.sh my-cluster-config
```

## Configuration
Place your Kubernetes configuration files in the `customers` directory. Each file should be named according to the cluster it represents.

## Contribution
Contributions to `kswitcher` are welcome! Please submit your pull requests or issues on GitHub.

## License
[License details here]
