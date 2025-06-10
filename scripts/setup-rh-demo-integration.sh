#!/bin/bash

# Red Hat Demo AI Development Environment Setup
# This script sets up the complete AI-enhanced development environment

set -e

echo "🚀 Setting up Red Hat Demo AI Development Environment..."

# Get current directory
WORKSPACE_DIR=$(pwd)
echo "📁 Workspace Directory: $WORKSPACE_DIR"

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to install via Homebrew (macOS)
install_homebrew_tools() {
    echo "🍺 Installing tools via Homebrew..."
    
    # Install Homebrew if not present
    if ! command_exists brew; then
        echo "Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
    
    # Essential tools
    brew install terraform ansible vault awscli kubernetes-cli helm openshift-cli podman
    
    # Development tools
    brew install jq yq tree watch htop
    brew install hadolint shellcheck
    
    # Python tools
    pip3 install ansible-lint molecule yamllint pre-commit jinja2 jinja2-cli j2cli
}

# Function to install via apt (Linux)
install_apt_tools() {
    echo "📦 Installing tools via apt..."
    
    sudo apt update
    
    # Add HashiCorp repository
    wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
    echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
    
    sudo apt update
    sudo apt install -y terraform vault
    
    # Other tools
    sudo apt install -y jq tree watch htop shellcheck
    
    # AWS CLI
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
    unzip awscliv2.zip
    sudo ./aws/install
    rm -rf awscliv2.zip aws/
    
    # Kubernetes tools
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
    chmod +x kubectl
    sudo mv kubectl /usr/local/bin/
    
    # Helm
    curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
    
    # OpenShift CLI
    curl -LO https://mirror.openshift.com/pub/openshift-v4/clients/ocp/latest/openshift-client-linux.tar.gz
    tar -xzf openshift-client-linux.tar.gz
    sudo mv oc kubectl /usr/local/bin/
    rm -f openshift-client-linux.tar.gz oc kubectl
    
    # Python tools
    pip3 install ansible ansible-lint molecule yamllint pre-commit jinja2 jinja2-cli j2cli
}

# Detect OS and install tools
echo "🔍 Detecting operating system..."
if [[ "$OSTYPE" == "darwin"* ]]; then
    echo "🍎 macOS detected"
    install_homebrew_tools
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    echo "🐧 Linux detected"
    install_apt_tools
else
    echo "❌ Unsupported operating system: $OSTYPE"
    echo "Please install tools manually following the Setup Guide"
    exit 1
fi

# Clone repositories if not already present
echo "📥 Setting up repositories..."
echo ""
echo "⚠️  IMPORTANT: For proper contribution workflow, you should work with FORKED repositories!"
echo "   This script will guide you through the process."
echo ""

# Get GitHub username for forked repositories
if [ -z "$GITHUB_USERNAME" ]; then
    echo "🔑 GitHub Username Required:"
    echo "   To properly contribute to Red Hat demos, you need forked repositories."
    echo "   You should have already forked:"
    echo "   - https://github.com/sibilleb/RedHat-Demo-AI-IDE"
    echo "   - https://github.com/ansible/product-demos"
    echo ""
    read -p "Enter your GitHub username (for forked repositories): " GITHUB_USERNAME
    
    if [ -z "$GITHUB_USERNAME" ]; then
        echo "❌ GitHub username is required for proper setup. Exiting."
        echo "   Please fork the repositories first, then run this script again."
        exit 1
    fi
fi

# Clone setup repository (forked version)
if [ ! -d "RedHat-Demo-AI-IDE" ]; then
    echo "📥 Cloning your forked RedHat-Demo-AI-IDE repository..."
    if git clone https://github.com/${GITHUB_USERNAME}/RedHat-Demo-AI-IDE.git; then
        cd RedHat-Demo-AI-IDE
        git remote add upstream https://github.com/sibilleb/RedHat-Demo-AI-IDE.git
        echo "✅ Remotes configured for RedHat-Demo-AI-IDE:"
        echo "   origin: https://github.com/${GITHUB_USERNAME}/RedHat-Demo-AI-IDE.git (your fork)"
        echo "   upstream: https://github.com/sibilleb/RedHat-Demo-AI-IDE.git (original)"
        cd ..
    else
        echo "❌ Failed to clone your fork. Please ensure you have forked the repository."
        echo "   Fork: https://github.com/sibilleb/RedHat-Demo-AI-IDE"
        exit 1
    fi
else
    echo "✅ RedHat-Demo-AI-IDE repository already exists"
fi

# Clone Red Hat Product Demos repository (forked version)
if [ ! -d "product-demos" ]; then
    echo "📥 Cloning your forked Red Hat Product Demos repository..."
    if git clone https://github.com/${GITHUB_USERNAME}/product-demos.git; then
        cd product-demos
        git remote add upstream https://github.com/ansible/product-demos.git
        echo "✅ Remotes configured for product-demos:"
        echo "   origin: https://github.com/${GITHUB_USERNAME}/product-demos.git (your fork)"
        echo "   upstream: https://github.com/ansible/product-demos.git (official Red Hat)"
        cd ..
    else
        echo "❌ Failed to clone your fork. Please ensure you have forked the repository."
        echo "   Fork: https://github.com/ansible/product-demos"
        exit 1
    fi
else
    echo "✅ product-demos repository already exists"
    echo "⚠️  Checking remote configuration..."
    cd product-demos
    echo "Current remotes:"
    git remote -v
    cd ..
fi

# Set up symlinks for Cursor configuration
echo "🔗 Setting up Cursor configuration..."
if [ ! -L ".cursor" ]; then
    ln -sf "$WORKSPACE_DIR/RedHat-Demo-AI-IDE/.cursor" "$WORKSPACE_DIR/.cursor"
    echo "Created symlink: .cursor -> RedHat-Demo-AI-IDE/.cursor"
fi

# Copy MCP template if Cursor directory exists
if [ -d "$WORKSPACE_DIR/RedHat-Demo-AI-IDE/.cursor" ]; then
    if [ ! -f "$WORKSPACE_DIR/.cursor/mcp.json" ] && [ -f "$WORKSPACE_DIR/RedHat-Demo-AI-IDE/.cursor/mcp.json.template" ]; then
        cp "$WORKSPACE_DIR/RedHat-Demo-AI-IDE/.cursor/mcp.json.template" "$WORKSPACE_DIR/.cursor/mcp.json"
        echo "📋 Copied MCP configuration template to .cursor/mcp.json"
        echo "⚠️  Please edit .cursor/mcp.json and add your API keys"
    fi
fi

# Set up pre-commit hooks
echo "🎣 Setting up pre-commit hooks..."
if [ -f "RedHat-Demo-AI-IDE/.pre-commit-config.yaml" ]; then
    ln -sf "$WORKSPACE_DIR/RedHat-Demo-AI-IDE/.pre-commit-config.yaml" "$WORKSPACE_DIR/.pre-commit-config.yaml"
    cd "$WORKSPACE_DIR/product-demos"
    pre-commit install
    cd "$WORKSPACE_DIR"
fi

# Initialize TaskMaster (if available)
echo "📋 Initializing TaskMaster..."
if command_exists npx; then
    cd "$WORKSPACE_DIR/RedHat-Demo-AI-IDE"
    npx task-master-ai init --name="Red Hat Demo Environment" \
        --description="AI-enhanced Red Hat demo development environment" \
        --version="1.0.0" \
        --yes || echo "TaskMaster initialization skipped"
    cd "$WORKSPACE_DIR"
fi

# Create helpful scripts
echo "📝 Creating helper scripts..."
cat > start-demo-development.sh << 'EOF'
#!/bin/bash
echo "🚀 Starting Red Hat Demo Development Environment"
echo "📁 Opening product-demos in Cursor..."
cd product-demos
cursor .
EOF

chmod +x start-demo-development.sh

cat > validate-environment.sh << 'EOF'
#!/bin/bash
echo "🔍 Validating Environment Setup..."

echo "📋 CLI Tools:"
terraform version
ansible --version
vault version
aws --version 2>/dev/null || echo "AWS CLI not configured"
oc version --client 2>/dev/null || echo "OpenShift CLI not found"
kubectl version --client
helm version

echo "🐍 Python Tools:"
python3 -c "import jinja2; print(f'Jinja2: {jinja2.__version__}')"
ansible-lint --version
molecule --version

echo "🔗 Repository Status:"
[ -d "RedHat-Demo-AI-IDE" ] && echo "✅ RedHat-Demo-AI-IDE repository present" || echo "❌ Missing RedHat-Demo-AI-IDE"
[ -d "product-demos" ] && echo "✅ product-demos repository present" || echo "❌ Missing product-demos"
[ -L ".cursor" ] && echo "✅ Cursor configuration linked" || echo "❌ Cursor configuration not linked"

echo "✅ Environment validation complete!"
EOF

chmod +x validate-environment.sh

echo ""
echo "🎉 Setup Complete!"
echo ""
echo "📋 Next Steps:"
echo "1. Edit .cursor/mcp.json and add your API keys:"
echo "   - ANTHROPIC_API_KEY (for Claude)"
echo "   - GITHUB_PERSONAL_ACCESS_TOKEN"
echo "   - Additional AI provider keys as needed"
echo ""
echo "2. Validate your environment:"
echo "   ./validate-environment.sh"
echo ""
echo "3. Start developing Red Hat demos:"
echo "   ./start-demo-development.sh"
echo ""
echo "4. Or manually navigate to demos:"
echo "   cd product-demos"
echo "   cursor ."
echo ""
echo "📚 Documentation:"
echo "- Setup Guide: RedHat-Demo-AI-IDE/SETUP_GUIDE.md"
echo "- Development Workflow: RedHat-Demo-AI-IDE/docs/"
echo ""
echo "🆘 Need help? Ask Claude in Cursor chat!"
echo "" 