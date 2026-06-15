# Antigravity CLI for Termux (Glibc Bridge)

Official Antigravity CLI (`agy`) binary is built for standard Linux (glibc), which makes it incompatible with Termux's native environment (Bionic libc). This project provides a **bridge installer** that sets up `agy` inside a lightweight Ubuntu `proot` environment, allowing it to run seamlessly on Android.

## Features
- **Automatic Setup:** Installs `proot-distro` and Ubuntu if they aren't already present.
- **Native Experience:** Creates a wrapper so you can just type `agy` in your Termux shell.
- **Environment Sync:** Automatically passes your API keys from Termux to the bridge.

## Quick Installation

Run this command in your Termux:

```bash
curl -fsSL https://raw.githubusercontent.com/javedahmed82/antigravity-termux/master/install-agy.sh | bash
```

*(Note: Replace `javedahmed82` with your GitHub username after pushing)*

## Manual Installation
1. Clone the repo:
   ```bash
   git clone https://github.com/javedahmed82/antigravity-termux.git
   cd antigravity-termux
   ```
2. Make the script executable:
   ```bash
   chmod +x install-agy.sh
   ```
3. Run the installer:
   ```bash
   ./install-agy.sh
   ```

## Usage
After installation, restart Termux or run `source ~/.bashrc`.

Set your API key (if not already set):
```bash
export ANTIGRAVITY_API_KEY='your-google-api-key'
```

Launch the CLI:
```bash
agy
```

## How it works
Termux doesn't support the official `agy` binary because of library differences. This installer:
1. Installs a minimal Ubuntu environment via `proot-distro`.
2. Downloads the official `agy` binary into that environment.
3. Creates a "bridge" script in `~/bin/agy` that acts as a shortcut to run the binary inside Ubuntu while staying in your current Termux directory.

## Requirements
- Android 7.0+
- Termux (latest version from F-Droid)
- ~500MB free space (for the Ubuntu environment)
