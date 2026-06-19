# NixOS Configuration

## Adding a new device
To add a new device, first boot from and install via the official NixOS ISO.
Run through the whole setup, create your user, parition the disks, etc.

### Enrollment
Since we use SOPS secrets in this repository, you will have to "enroll" your new installation first.
On your new installation, run the following:

```bash
nix-shell -I nixpkgs=channel:nixos-unstable -p ssh-to-age --run 'ssh-to-age -i /etc/ssh/ssh_host_ed25519_key.pub'
```

The generated aged string needs to be placed into the `.sops.yaml` file.
Next, you will need to move to a **known** machine (or gain access to their secret key) and run:

```bash
nix-shell -I nixpkgs=channel:nixos-unstable -p sops --run 'sops updatekeys'
```

> [!INFO]
> This repository should include sops and ssh-to-age ... you may have it installed already, thus no need for the nix-shell!

Finally, commit and push the updated `secrets.yaml` **and** `.sops.yaml`.

### Backup
Next, make a backup of the generated configuration:
```bash
cp -r /etc/nixos /etc/nixos_bak
```

### Checkout
Clean the generated configuration and initialize this repository:
```bash
rm -f /etc/nixos/*
cd /etc/nixos
git init
git remote add origin https://forgejo.sakul-flee.de/SakulFlee/NixOS-Config.git
```

### Adjustments
A new machine _most likely_ also requires an entry under `./hosts/` (also update `flake.nix`!).
You need to **at least** copy the hardware configuration from your backup (/etc/nixos_bak/hardware.nix) into the configuration.
However, most host configs are sharded, you may only need boot-loader flags and **definitely the parititon layout**!
Check an example config for guidance.

### Build & Apply
Finally, build and apply your configuration via:

```bash
./rebuild-and-switch.sh <your-chosen-hostname>
```

> [!NOTE]
> On Subsequent runs, you will only need to run `./rebuild-and-switch.sh` without the hostname!
> The current system's hostname will be used automatically.
> Also, a service will be installed that regularly checks for updates in this repository ... you may not even need to update manually.

