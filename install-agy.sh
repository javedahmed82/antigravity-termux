#!/data/data/com.termux/files/usr/bin/bash

# ==========================================================
# Antigravity CLI Installer for Termux (v1.0.5)
# Created by Gemini CLI (Termux Bridge Method)
# ==========================================================

set -e

echo "🚀 Starting Antigravity CLI installation for Termux..."

# 1. Update and install dependencies
echo "📦 Installing core dependencies..."
pkg update -y
pkg install -y proot-distro curl tar coreutils

# 2. Setup Ubuntu proot if not exists
echo "🔍 Checking for Ubuntu proot environment..."
# Check both via proot-distro list and the filesystem for robustness
if proot-distro list | grep -iq "ubuntu" || [ -d "$PREFIX/var/lib/proot-distro/containers/ubuntu" ]; then
    echo "✅ Ubuntu proot already installed. Skipping installation."
else
    echo "🐧 Installing Ubuntu proot environment (this may take a while)..."
    proot-distro install ubuntu
fi

# 3. Download and Install agy inside Ubuntu
echo "📥 Setting up certificates and downloading Antigravity CLI..."
# We install ca-certificates and update them to prevent TLS verification errors
proot-distro login ubuntu -- bash -c "apt update && apt install -y ca-certificates && update-ca-certificates --fresh && curl -fsSL https://antigravity.google/cli/install.sh | bash"

# 4. Create the Termux Wrapper
echo "🛠 Creating Termux bridge wrapper..."
mkdir -p "$HOME/bin"

cat > "$HOME/bin/agy" << 'EOF'
#!/data/data/com.termux/files/usr/bin/bash
# Antigravity CLI Bridge for Termux
proot-distro login ubuntu -- env ANTIGRAVITY_API_KEY="$ANTIGRAVITY_API_KEY" GEMINI_API_KEY="$GEMINI_API_KEY" /root/.local/bin/agy "$@"
EOF

chmod +x "$HOME/bin/agy"

# 5. Update Shell Configuration
setup_path() {
    local rc_file=$1
    if [ ! -f "$rc_file" ]; then
        touch "$rc_file"
    fi
    if ! grep -q "export PATH=\$HOME/bin:\$PATH" "$rc_file"; then
        echo "Updating $rc_file..."
        echo '' >> "$rc_file"
        echo '# Antigravity CLI PATH' >> "$rc_file"
        echo 'export PATH=$HOME/bin:$PATH' >> "$rc_file"
    fi
}

setup_path "$HOME/.bashrc"
setup_path "$HOME/.zshrc"

echo ""
echo "✅ Installation Complete!"
echo "-------------------------------------------------------"
echo "1. Restart Termux (Exit and Re-open)"
echo "2. OR run: source ~/.bashrc (or ~/.zshrc)"
echo "3. Then run: agy"
echo "-------------------------------------------------------"
