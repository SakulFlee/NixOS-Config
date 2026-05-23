# Agent Guide for NixOS Configuration

This document provides a map of the configuration and guidelines for agents working on this repository to avoid wasting tokens on exploration.

## 🗺️ Directory Structure

- `flake.nix`: The main entry point. Defines the system configurations and inputs.
- `hosts/`: Host-specific configurations.
  - `hosts/vm/`: Configuration for the Virtual Machine.
    - `configuration.nix`: Main system configuration for the VM.
    - `hardware.nix`: Hardware-specific settings.
- `shared/`: Common system-level configuration modules.
  - `_defaults.nix`: Aggregator for basic system modules.
  - `home-manager.nix`: Integration of the Home Manager NixOS module.
  - `system-core.nix`, `system-network.nix`, etc.: Modular system settings.
- `users/`: User account definitions and Home Manager linkages.
  - `<username>.nix`: Defines the user account and imports Home Manager modules for that user.
- `home-manager/`: User-level (Home Manager) configurations.
  - `home-manager/<username>/`: User-specific packages and programs.
  - `home-manager/shared/`: Reusable Home Manager configurations (e.g., Hyprland, Waybar).
- `run_vm.sh`: Utility script for launching the VM.
- `VM.qcow2`: The VM disk image.

## 🛠️ Workflow & Guidelines

### General Tasks
- **Commits**: Commit every meaningful change immediately. 
- **Pushing**: **DO NOT PUSH** changes to any remote repository unless explicitly requested.
- **Testing**: Since this is a VM-based config, changes should ideally be tested within the VM. However, only run the VM if the user agrees!

### Modifying System Configuration
1. To add global packages: Edit `shared/system-packages.nix`.
2. To change system-wide settings: Check `shared/` for the relevant module.
3. To add a new host: Create a new directory under `hosts/` and add it to `flake.nix`.

### Modifying User Configuration
1. To add user-specific packages: Edit `home-manager/<username>/packages.nix`.
2. To configure user-level programs: Edit `home-manager/<username>/programs.nix`.
3. To modify shared desktop environments (e.g., Hyprland): Edit `home-manager/shared/`.

## 🚀 Quick Reference
- **System-level**: `shared/` $\rightarrow$ `hosts/vm/configuration.nix` $\rightarrow$ `flake.nix`
- **User-level**: `home-manager/` $\rightarrow$ `users/<username>.nix` $\rightarrow$ `shared/_defaults.nix` $\rightarrow$ `hosts/vm/configuration.nix` $\rightarrow$ `flake.nix`
