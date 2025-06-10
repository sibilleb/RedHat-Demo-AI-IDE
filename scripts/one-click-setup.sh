#!/bin/bash

# One-Click Setup for Red Hat Demo AI Development Environment
# This script automates the complete setup process

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Configuration
WORKSPACE_NAME="my-redhat-demo-workspace"
SETUP_REPO_NAME="RedHat-Demo-AI-IDE"
DEMOS_REPO_NAME="product-demos"

# Progress tracking
TOTAL_STEPS=12
CURRENT_STEP=0

print_step() {
    CURRENT_STEP=$((CURRENT_STEP + 1))
    echo -e "${BLUE}[${CURRENT_STEP}/${TOTAL_STEPS}]${NC} ${PURPLE}$1${NC}"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
    exit 1
}

print_info() {
    echo -e "${CYAN}ℹ️  $1${NC}"
}

# Prerequisites warning function
show_prerequisites_warning() {
    echo -e "${RED}⚠️  CRITICAL: Prerequisites Required Before Starting${NC}"
    echo -e "${WHITE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${YELLOW}The setup will FAIL without these credentials. Please prepare:${NC}"
    echo ""
    echo -e "${CYAN}✅ MANDATORY:${NC}"
    echo -e "${WHITE}   📋 GitHub Username:${NC} Your GitHub account username"
    echo -e "${WHITE}   🔑 GitHub Personal Access Token:${NC} https://github.com/settings/tokens"
    echo -e "${WHITE}   🔑 AWS Access Key + Secret:${NC} https://console.aws.amazon.com/iam/"
    echo ""
    echo -e "${YELLOW}⚠️  RECOMMENDED:${NC}"
    echo -e "${WHITE}   🤖 Anthropic API Key:${NC} https://console.anthropic.com/"
    echo ""
    echo -e "${PURPLE}📖 Complete guide:${NC} https://github.com/sibilleb/RedHat-Demo-AI-IDE/blob/main/SETUP_GUIDE.md"
    echo -e "${WHITE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
}

# Get command line arguments
GITHUB_USERNAME=""
FORCE_REINSTALL=false
SKIP_TOOLS=false

while [[ $# -gt 0 ]]; do
    case $1 in
        --username)
            GITHUB_USERNAME="$2"
            shift 2
            ;;
        --force)
            FORCE_REINSTALL=true
            shift
            ;;
        --skip-tools)
            SKIP_TOOLS=true
            shift
            ;;
        --help)
            echo "Red Hat Demo AI Development Environment - One-Click Setup"
            echo ""
            echo "Usage: $0 [OPTIONS]"
            echo ""
            echo "Options:"
            echo "  --username USERNAME    Your GitHub username (required)"
            echo "  --force               Force reinstall of tools"
            echo "  --skip-tools          Skip CLI tools installation"
            echo "  --help                Show this help message"
            echo ""
            echo "Example:"
            echo "  $0 --username myusername"
            exit 0
            ;;
        *)
            print_error "Unknown option $1. Use --help for usage information."
            ;;
    esac
done

# Validate GitHub username
if [[ -z "$GITHUB_USERNAME" ]]; then
    print_error "GitHub username is required. Use: $0 --username YOUR_USERNAME"
fi

# Show prerequisites warning
show_prerequisites_warning

echo -e "${PURPLE}🚀 Red Hat Demo AI Development Environment Setup${NC}"
echo -e "${PURPLE}=================================================${NC}"
echo -e "${CYAN}GitHub Username: ${GITHUB_USERNAME}${NC}"
echo -e "${CYAN}Workspace: ${WORKSPACE_NAME}${NC}"
echo ""

# Ask for user confirmation
echo -e "${YELLOW}Do you have all the required credentials listed above? (y/N)${NC}"
read -r response
if [[ ! "$response" =~ ^[Yy]$ ]]; then
    echo -e "${RED}Please gather the required credentials before continuing.${NC}"
    echo -e "${CYAN}Refer to the complete guide: https://github.com/sibilleb/RedHat-Demo-AI-IDE/blob/main/SETUP_GUIDE.md${NC}"
    exit 1
fi
echo ""

# Step 1: Create workspace directory
print_step "Creating workspace directory structure"
if [[ ! -d "$WORKSPACE_NAME" ]]; then
    mkdir -p "$WORKSPACE_NAME"
    print_success "Created workspace directory: $WORKSPACE_NAME"
else
    print_info "Workspace directory already exists"
fi
cd "$WORKSPACE_NAME"

# Step 2: Clone repositories
print_step "Cloning forked repositories"

# Clone setup repository
if [[ ! -d "$SETUP_REPO_NAME" ]]; then
    print_info "Cloning setup repository from your fork..."
    git clone "https://github.com/${GITHUB_USERNAME}/${SETUP_REPO_NAME}.git"
    cd "$SETUP_REPO_NAME"
    git remote add upstream "https://github.com/sibilleb/${SETUP_REPO_NAME}.git"
    print_success "Setup repository cloned and remotes configured"
    cd ..
else
    print_info "Setup repository already exists"
fi

# Clone demos repository  
if [[ ! -d "$DEMOS_REPO_NAME" ]]; then
    print_info "Cloning Red Hat demos repository from your fork..."
    git clone "https://github.com/${GITHUB_USERNAME}/${DEMOS_REPO_NAME}.git"
    cd "$DEMOS_REPO_NAME"
    git remote add upstream "https://github.com/ansible/${DEMOS_REPO_NAME}.git"
    print_success "Demos repository cloned and remotes configured"
    cd ..
else
    print_info "Demos repository already exists"
fi

# Step 3: Copy configuration files
print_step "Setting up Cursor IDE configuration"
cd "$SETUP_REPO_NAME"

# Create .cursor symlink in the workspace root and demos directory
cd ..
if [[ ! -L ".cursor" ]]; then
    ln -sf "${SETUP_REPO_NAME}/.cursor" ".cursor"
    print_success "Created .cursor symlink in workspace root"
fi

cd "$DEMOS_REPO_NAME"
if [[ ! -L ".cursor" ]]; then
    ln -sf "../${SETUP_REPO_NAME}/.cursor" ".cursor"
    print_success "Created .cursor symlink in demos directory"
fi
cd ..

# Step 4: Copy development configuration files
print_step "Installing development configuration files"
cd "$SETUP_REPO_NAME"

# Copy configuration files to workspace root
cp -f .editorconfig ../.editorconfig
cp -f .pre-commit-config.yaml ../.pre-commit-config.yaml
cp -f templates/.yamllint.yml ../.yamllint.yml

# Copy configuration files to demos directory  
cp -f .editorconfig "../${DEMOS_REPO_NAME}/.editorconfig"
cp -f .pre-commit-config.yaml "../${DEMOS_REPO_NAME}/.pre-commit-config.yaml"
cp -f templates/.yamllint.yml "../${DEMOS_REPO_NAME}/.yamllint.yml"
cp -f templates/ansible.cfg "../${DEMOS_REPO_NAME}/ansible.cfg"

print_success "Development configuration files installed"
cd ..

# Step 5: Install CLI tools (if not skipped)
if [[ "$SKIP_TOOLS" != true ]]; then
    print_step "Installing CLI tools and dependencies"
    
    echo -e "${YELLOW}The setup can install development tools for you (Terraform, Ansible, AWS CLI, etc.)${NC}"
    echo -e "${YELLOW}Tools already installed on your system will be automatically skipped.${NC}"
    echo ""
    echo -e "${YELLOW}Install development tools? (y/N)${NC}"
    read -r install_tools_response
    
    if [[ "$install_tools_response" =~ ^[Yy]$ ]]; then
        cd "$SETUP_REPO_NAME"
        
        # Make install script executable and run it with appropriate flags
        chmod +x scripts/install-tools.sh
        
        echo -e "${YELLOW}Choose installation mode:${NC}"
        echo -e "${WHITE}1. Interactive (ask for each tool) - Recommended${NC}"
        echo -e "${WHITE}2. Install all tools (skip prompts)${NC}"
        echo -e "${YELLOW}Enter choice (1 or 2): ${NC}"
        read -r install_mode
        
        case $install_mode in
            1)
                ./scripts/install-tools.sh
                ;;
            2)
                ./scripts/install-tools.sh --yes
                ;;
            *)
                print_info "Invalid choice, using interactive mode"
                ./scripts/install-tools.sh
                ;;
        esac
        
        print_success "CLI tools installation completed"
        cd ..
    else
        print_info "Skipping CLI tools installation"
        echo -e "${CYAN}You can install tools later by running: ./RedHat-Demo-AI-IDE/scripts/install-tools.sh${NC}"
    fi
else
    print_info "Skipping CLI tools installation (--skip-tools flag used)"
fi

# Step 6: Set up Python environment and requirements
print_step "Setting up Python environment"
cd "$DEMOS_REPO_NAME"

# Create requirements.txt if it doesn't exist
if [[ ! -f "requirements.txt" ]]; then
    cat > requirements.txt << 'EOF'
# Ansible and automation
ansible>=8.0.0
ansible-core>=2.15.0
ansible-lint>=6.22.0
ansible-navigator>=3.5.0
molecule>=6.0.0
molecule-plugins[docker]>=23.5.0

# Templating and data processing
jinja2>=3.1.0
jinja2-cli>=0.8.0
j2cli>=0.3.10

# YAML and data validation
yamllint>=1.32.0
pyyaml>=6.0.0

# Code quality
pre-commit>=3.5.0
black>=23.9.0
isort>=5.12.0
flake8>=6.1.0

# AWS and cloud tools (Python components)
boto3>=1.29.0
botocore>=1.32.0

# Testing and development
pytest>=7.4.0
pytest-cov>=4.1.0
requests>=2.31.0

# Documentation
mkdocs>=1.5.0
mkdocs-material>=9.4.0
EOF
    print_info "Created requirements.txt with essential Python packages"
fi

# Install Python requirements
if command -v pip3 &> /dev/null; then
    # Check for externally-managed environment
    if python3 -c "import sysconfig; print(sysconfig.get_path('purelib'))" 2>/dev/null | grep -q "/opt/homebrew\|/usr/local"; then
        print_info "Detected externally-managed Python environment"
        venv_path="$HOME/.venv/redhat-demo"
        
        if [[ -d "$venv_path" ]]; then
            print_info "Using existing virtual environment: $venv_path"
            source "$venv_path/bin/activate"
        else
            print_info "Creating virtual environment: $venv_path"
            python3 -m venv "$venv_path"
            source "$venv_path/bin/activate"
            python3 -m pip install --upgrade pip
        fi
        
        pip install -r requirements.txt
        print_success "Python requirements installed in virtual environment"
        
        # Add note about virtual environment
        echo -e "${CYAN}💡 Python packages installed in virtual environment: $venv_path${NC}"
        echo -e "${CYAN}   Activate with: source $venv_path/bin/activate${NC}"
    else
        pip3 install --user -r requirements.txt
        print_success "Python requirements installed"
    fi
else
    print_warning "pip3 not found, skipping Python requirements installation"
fi

cd ..

# Step 7: Initialize pre-commit
print_step "Setting up pre-commit hooks"
cd "$DEMOS_REPO_NAME"

# Activate virtual environment if it exists
venv_path="$HOME/.venv/redhat-demo"
if [[ -d "$venv_path" ]] && [[ -f "$venv_path/bin/activate" ]]; then
    source "$venv_path/bin/activate"
fi

if command -v pre-commit &> /dev/null; then
    pre-commit install
    pre-commit install --hook-type commit-msg
    print_success "Pre-commit hooks installed"
else
    print_warning "pre-commit not found, skipping hook installation"
fi

cd ..

# Step 8: Create helper scripts  
print_step "Creating helper scripts"
cd "$SETUP_REPO_NAME"

# Make all scripts executable
chmod +x scripts/*.sh

# Copy helper scripts to workspace
cp scripts/validate-environment.sh ../validate-environment.sh
cp scripts/start-demo-development.sh ../start-demo-development.sh

chmod +x ../validate-environment.sh
chmod +x ../start-demo-development.sh

print_success "Helper scripts created and made executable"
cd ..

# Step 9: Configure git for both repositories
print_step "Configuring git repositories"

cd "$SETUP_REPO_NAME"
git config pull.rebase false
git config core.autocrlf false
cd ..

cd "$DEMOS_REPO_NAME"  
git config pull.rebase false
git config core.autocrlf false
cd ..

print_success "Git repositories configured"

# Step 10: Create workspace documentation
print_step "Creating workspace documentation"

cat > README.md << EOF
# ${WORKSPACE_NAME}

Red Hat Demo AI Development Environment for **${GITHUB_USERNAME}**

## Quick Start

\`\`\`bash
# Validate your environment
./validate-environment.sh

# Start developing demos  
./start-demo-development.sh

# Or manually navigate to demos
cd ${DEMOS_REPO_NAME}
cursor .
\`\`\`

## Repository Structure

- **${SETUP_REPO_NAME}/**: Setup repository with configs and tools
- **${DEMOS_REPO_NAME}/**: Your fork of Red Hat Product Demos
- **.cursor**: Shared Cursor IDE configuration (symlink)

## Git Workflow

\`\`\`bash
# Update your forks with upstream changes
cd ${DEMOS_REPO_NAME}
git fetch upstream
git checkout main  
git merge upstream/main
git push origin main

cd ../${SETUP_REPO_NAME}
git fetch upstream
git checkout main
git merge upstream/main
git push origin main
\`\`\`

## Next Steps

1. Add your API keys to \`.cursor/mcp.json\`
2. Run \`./validate-environment.sh\` to verify setup
3. Start developing with \`./start-demo-development.sh\`

## Configuration Files

- \`.editorconfig\`: Consistent file formatting
- \`.pre-commit-config.yaml\`: Code quality hooks
- \`.yamllint.yml\`: YAML linting rules
- \`ansible.cfg\`: Ansible configuration (in demos directory)

Generated on: $(date)
Setup by: ${GITHUB_USERNAME}
EOF

print_success "Workspace documentation created"

# Step 11: Copy MCP template and prepare for API keys
print_step "Preparing MCP configuration"
cd "${SETUP_REPO_NAME}/.cursor"

if [[ -f "mcp.json.template" ]] && [[ ! -f "mcp.json" ]]; then
    cp mcp.json.template mcp.json
    print_success "MCP configuration template copied (10 servers configured)"
print_info "📋 Includes: Ansible, AWS Suite, Terraform, GitHub, Kubernetes, Docker"
print_warning "Remember to add your API keys to .cursor/mcp.json"
fi

cd ../..

# Step 12: Final validation and summary
print_step "Running final validation"

# Run validation if the script exists
if [[ -f "validate-environment.sh" ]]; then
    chmod +x validate-environment.sh
    if ./validate-environment.sh > /dev/null 2>&1; then
        print_success "Environment validation passed"
    else
        print_warning "Some validation checks failed - see details above"
    fi
fi

# Success summary
echo ""
echo -e "${GREEN}🎉 Setup Complete! 🎉${NC}"
echo -e "${PURPLE}===================${NC}"
echo ""
echo -e "${CYAN}Your Red Hat Demo AI Development Environment is ready!${NC}"
echo ""
echo -e "${RED}⚠️  CRITICAL NEXT STEPS:${NC}"
echo -e "${WHITE}1. ${RED}REQUIRED:${NC} Add your API keys to ${CYAN}.cursor/mcp.json${NC}"
echo -e "${WHITE}   📋 10 MCP servers waiting for: GitHub token, AWS keys, Anthropic key${NC}"
echo -e "${WHITE}   📖 See ${CYAN}docs/MCP_SERVERS.md${NC} for detailed server information"
echo -e "${WHITE}2. ${RED}REQUIRED:${NC} Run ${CYAN}./validate-environment.sh${NC} to verify configuration"
echo -e "${WHITE}3. ${GREEN}Start developing:${NC} ${CYAN}./start-demo-development.sh${NC}"
echo ""
echo -e "${YELLOW}⚠️  The environment will NOT work until API keys are configured!${NC}"
echo ""
echo -e "${YELLOW}🔧 Key Files to Configure:${NC}"
echo -e "${WHITE}- ${CYAN}.cursor/mcp.json${NC} - Add API keys for AI assistance"
echo -e "${WHITE}- ${CYAN}${DEMOS_REPO_NAME}/ansible.cfg${NC} - Ansible configuration"
echo -e "${WHITE}- ${CYAN}.editorconfig${NC} - Code formatting rules"
echo ""
echo -e "${YELLOW}📚 Documentation:${NC}"
echo -e "${WHITE}- ${CYAN}README.md${NC} - This workspace guide"
echo -e "${WHITE}- ${CYAN}${SETUP_REPO_NAME}/SETUP_GUIDE.md${NC} - Detailed setup guide"
echo -e "${WHITE}- ${CYAN}${SETUP_REPO_NAME}/CURSOR_SETUP_PROMPT.md${NC} - AI prompts"
echo ""
echo -e "${GREEN}Happy coding! 🚀${NC}" 