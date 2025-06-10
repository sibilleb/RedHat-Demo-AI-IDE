#!/bin/bash

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Script configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
WORKSPACE_DIR="${HOME}/redhat-demo-workspace"
RH_DEMOS_REPO="https://github.com/ansible/product-demos.git"

echo -e "${BLUE}=== Red Hat Product Demos Integration Setup ===${NC}"
echo "This script sets up integration with the official Red Hat product demos repository"
echo "Repository: ${RH_DEMOS_REPO}"
echo ""

# Function to print status messages
print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check prerequisites
check_prerequisites() {
    print_status "Checking prerequisites..."
    
    # Check if git is installed
    if ! command -v git &> /dev/null; then
        print_error "Git is not installed. Please install git first."
        exit 1
    fi
    
    # Check if ansible is installed
    if ! command -v ansible &> /dev/null; then
        print_error "Ansible is not installed. Please run the main setup guide first."
        exit 1
    fi
    
    # Check if cursor is available
    if ! command -v cursor &> /dev/null; then
        print_warning "Cursor IDE not found in PATH. You may need to install it manually."
    fi
    
    print_status "Prerequisites check completed."
}

# Create workspace directory
setup_workspace() {
    print_status "Setting up workspace directory: ${WORKSPACE_DIR}"
    
    if [ ! -d "$WORKSPACE_DIR" ]; then
        mkdir -p "$WORKSPACE_DIR"
        print_status "Created workspace directory: ${WORKSPACE_DIR}"
    else
        print_status "Workspace directory already exists: ${WORKSPACE_DIR}"
    fi
}

# Clone Red Hat demos repository
clone_rh_demos() {
    print_status "Cloning Red Hat product demos repository..."
    
    cd "$WORKSPACE_DIR"
    
    if [ ! -d "product-demos" ]; then
        git clone "$RH_DEMOS_REPO" product-demos
        print_status "Successfully cloned Red Hat product demos repository"
    else
        print_status "Red Hat demos repository already exists, updating..."
        cd product-demos
        git pull origin main
        cd ..
    fi
}

# Setup enhanced development environment
setup_enhanced_environment() {
    print_status "Setting up enhanced development environment..."
    
    cd "${WORKSPACE_DIR}/product-demos"
    
    # Create symlinks to enhanced development tools
    if [ ! -L ".cursor" ]; then
        ln -s "${PROJECT_ROOT}/.cursor" .cursor
        print_status "Linked Cursor IDE configuration"
    fi
    
    if [ ! -L ".pre-commit-config.yaml" ]; then
        ln -s "${PROJECT_ROOT}/.pre-commit-config.yaml" .pre-commit-config.yaml
        print_status "Linked pre-commit configuration"
    fi
    
    if [ ! -d "scripts/enhanced" ]; then
        mkdir -p scripts
        ln -s "${PROJECT_ROOT}/scripts" scripts/enhanced
        print_status "Linked enhanced scripts"
    fi
    
    # Install pre-commit hooks
    if command -v pre-commit &> /dev/null; then
        pre-commit install
        print_status "Installed pre-commit hooks"
    else
        print_warning "pre-commit not available, skipping hook installation"
    fi
}

# Setup git configuration for contributions
setup_git_config() {
    print_status "Setting up Git configuration for Red Hat contributions..."
    
    cd "${WORKSPACE_DIR}/product-demos"
    
    # Check if user has configured git
    if ! git config user.name &> /dev/null; then
        print_warning "Git user.name not configured. Please run:"
        echo "  git config --global user.name 'Your Name'"
    fi
    
    if ! git config user.email &> /dev/null; then
        print_warning "Git user.email not configured. Please run:"
        echo "  git config --global user.email 'your.email@redhat.com'"
    fi
    
    # Add upstream remote if it doesn't exist
    if ! git remote | grep -q upstream; then
        git remote add upstream "$RH_DEMOS_REPO"
        print_status "Added upstream remote"
    fi
    
    print_status "Git configuration completed"
}

# Create validation script
create_validation_script() {
    print_status "Creating validation script..."
    
    cat > "${WORKSPACE_DIR}/product-demos/scripts/enhanced/validate-rh-demo-env.sh" << 'EOF'
#!/bin/bash

echo "=== Red Hat Demo Environment Validation ==="

# Check Red Hat demo structure
echo "Checking Red Hat demo repository structure..."
required_dirs=("linux" "windows" "cloud" "network" "openshift" "satellite")
for dir in "${required_dirs[@]}"; do
    if [ -d "$dir" ]; then
        echo "  ✅ $dir/ directory found"
    else
        echo "  ❌ $dir/ directory missing"
    fi
done

# Check Ansible configuration
echo "Checking Ansible configuration..."
if [ -f "ansible.cfg" ]; then
    echo "  ✅ ansible.cfg found"
else
    echo "  ❌ ansible.cfg missing"
fi

# Check collections requirements
echo "Checking collections requirements..."
if [ -f "collections/requirements.yml" ]; then
    echo "  ✅ collections/requirements.yml found"
    echo "  Collections to be installed:"
    ansible-galaxy collection list --format json 2>/dev/null | jq -r '.[] | keys[]' | head -5 || echo "    Use: ansible-galaxy collection list"
else
    echo "  ❌ collections/requirements.yml missing"
fi

# Check enhanced tools
echo "Checking enhanced development tools..."
if [ -L ".cursor" ]; then
    echo "  ✅ Cursor IDE configuration linked"
else
    echo "  ❌ Cursor IDE configuration not linked"
fi

if [ -L ".pre-commit-config.yaml" ]; then
    echo "  ✅ Pre-commit configuration linked"
else
    echo "  ❌ Pre-commit configuration not linked"
fi

echo "=== Validation complete ==="
EOF

    chmod +x "${WORKSPACE_DIR}/product-demos/scripts/enhanced/validate-rh-demo-env.sh"
    print_status "Created validation script"
}

# Install required collections
install_collections() {
    print_status "Installing required Ansible collections..."
    
    cd "${WORKSPACE_DIR}/product-demos"
    
    if [ -f "collections/requirements.yml" ]; then
        ansible-galaxy collection install -r collections/requirements.yml
        print_status "Installed required collections"
    else
        print_warning "No collections/requirements.yml found, skipping collection installation"
    fi
}

# Create example workflow
create_example_workflow() {
    print_status "Creating example AI-assisted workflow..."
    
    cat > "${WORKSPACE_DIR}/product-demos/AI_WORKFLOW_EXAMPLE.md" << 'EOF'
# AI-Assisted Red Hat Demo Development Workflow

This document demonstrates how to use the AI-enhanced development environment for creating Red Hat demos.

## Quick Start Example

```bash
# Navigate to your demo workspace
cd ~/redhat-demo-workspace/product-demos

# Create a new demo (example: RHEL automation)
cursor linux/

# Use Claude/Cursor for:
# 1. Generate playbook templates
# 2. Create inventory files
# 3. Write documentation
# 4. Generate test scenarios
```

## AI-Assisted Development Tips

1. **Playbook Generation**: Use Claude to generate Ansible playbooks based on requirements
2. **Documentation**: Auto-generate README files for demo setup
3. **Test Creation**: Create test scenarios and validation scripts
4. **Code Review**: Use AI for code review and best practices validation
5. **Troubleshooting**: Get AI assistance for debugging and optimization

## Integration with Red Hat Standards

- Follow Red Hat Ansible automation best practices
- Use certified collections from Automation Hub
- Implement proper error handling and logging
- Include comprehensive documentation

## Contribution Workflow

1. Create feature branch
2. Develop with AI assistance
3. Run automated validation
4. Submit pull request to upstream
5. Collaborate with Red Hat team for review
EOF

    print_status "Created example workflow documentation"
}

# Run validation
run_validation() {
    print_status "Running environment validation..."
    
    if [ -f "${WORKSPACE_DIR}/product-demos/scripts/enhanced/validate-rh-demo-env.sh" ]; then
        bash "${WORKSPACE_DIR}/product-demos/scripts/enhanced/validate-rh-demo-env.sh"
    else
        print_error "Validation script not found"
    fi
}

# Main execution
main() {
    print_status "Starting Red Hat Product Demos integration setup..."
    
    check_prerequisites
    setup_workspace
    clone_rh_demos
    setup_enhanced_environment
    setup_git_config
    create_validation_script
    install_collections
    create_example_workflow
    run_validation
    
    echo ""
    echo -e "${GREEN}🎉 Red Hat Product Demos integration setup completed successfully!${NC}"
    echo ""
    echo "Next steps:"
    echo "1. Navigate to your workspace: cd ${WORKSPACE_DIR}/product-demos"
    echo "2. Open in Cursor IDE: cursor ."
    echo "3. Explore existing demos and start developing with AI assistance"
    echo ""
    echo "Workspace structure:"
    echo "  📁 ${WORKSPACE_DIR}/product-demos - Main Red Hat demos repository"
    echo "  🔧 ${WORKSPACE_DIR}/product-demos/.cursor - Cursor IDE configuration"
    echo "  🛠️  ${WORKSPACE_DIR}/product-demos/scripts/enhanced - Enhanced development tools"
    echo ""
    echo "Happy coding with AI assistance! 🚀"
}

# Check if script is being sourced or executed
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi 