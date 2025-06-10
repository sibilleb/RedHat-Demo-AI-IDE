#!/bin/bash

# Comprehensive CLI Tools Installation for Red Hat Demo Environment
# Supports macOS, Linux (Ubuntu/Debian, RHEL/CentOS/Fedora)

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

print_info() {
    echo -e "${CYAN}ℹ️  $1${NC}"
}

print_section() {
    echo -e "${PURPLE}=== $1 ===${NC}"
}

# Detect Operating System
detect_os() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        OS="macOS"
        PACKAGE_MANAGER="brew"
    elif [[ -f /etc/os-release ]]; then
        . /etc/os-release
        case $ID in
            ubuntu|debian)
                OS="Ubuntu/Debian"
                PACKAGE_MANAGER="apt"
                ;;
            rhel|centos|fedora|rocky|almalinux)
                OS="RHEL/CentOS/Fedora"
                PACKAGE_MANAGER="dnf"
                ;;
            *)
                OS="Linux"
                PACKAGE_MANAGER="unknown"
                ;;
        esac
    else
        OS="Unknown"
        PACKAGE_MANAGER="unknown"
    fi
    
    print_info "Detected OS: $OS"
    print_info "Package Manager: $PACKAGE_MANAGER"
}

# Install Homebrew on macOS
install_homebrew() {
    if ! command -v brew &> /dev/null; then
        print_info "Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        
        # Add to PATH for current session
        if [[ -f "/opt/homebrew/bin/brew" ]]; then
            eval "$(/opt/homebrew/bin/brew shellenv)"
        fi
        
        print_success "Homebrew installed"
    else
        print_info "Homebrew already installed"
    fi
}

# Update package manager
update_packages() {
    print_section "Updating Package Manager"
    
    case $PACKAGE_MANAGER in
        brew)
            brew update
            ;;
        apt)
            sudo apt update && sudo apt upgrade -y
            ;;
        dnf)
            sudo dnf update -y
            ;;
        *)
            print_warning "Unknown package manager, skipping update"
            ;;
    esac
}

# Install basic development tools
install_basic_tools() {
    print_section "Installing Basic Development Tools"
    
    case $PACKAGE_MANAGER in
        brew)
            brew install git curl wget jq yq tree watch htop
            ;;
        apt)
            sudo apt install -y git curl wget jq tree watch htop build-essential
            # Install yq separately (not in default repos)
            if ! command -v yq &> /dev/null; then
                sudo wget -qO /usr/local/bin/yq https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64
                sudo chmod +x /usr/local/bin/yq
            fi
            ;;
        dnf)
            sudo dnf install -y git curl wget jq tree watch htop gcc gcc-c++ make
            # Install yq separately
            if ! command -v yq &> /dev/null; then
                sudo wget -qO /usr/local/bin/yq https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64
                sudo chmod +x /usr/local/bin/yq
            fi
            ;;
    esac
    
    print_success "Basic tools installed"
}

# Install Python and pip
install_python() {
    print_section "Setting up Python Environment"
    
    case $PACKAGE_MANAGER in
        brew)
            brew install python3
            ;;
        apt)
            sudo apt install -y python3 python3-pip python3-venv
            ;;
        dnf)
            sudo dnf install -y python3 python3-pip python3-venv
            ;;
    esac
    
    # Upgrade pip
    python3 -m pip install --upgrade pip
    print_success "Python environment ready"
}

# Install Ansible
install_ansible() {
    print_section "Installing Ansible Ecosystem"
    
    # Install via pip for consistent version across platforms
    python3 -m pip install --user ansible ansible-core ansible-lint ansible-navigator molecule molecule-plugins[docker] yamllint
    
    print_success "Ansible ecosystem installed"
}

# Install Terraform
install_terraform() {
    print_section "Installing Terraform"
    
    case $PACKAGE_MANAGER in
        brew)
            brew tap hashicorp/tap
            brew install hashicorp/tap/terraform hashicorp/tap/vault
            ;;
        apt)
            # Add HashiCorp official repository
            wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
            echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
            sudo apt update
            sudo apt install -y terraform vault
            ;;
        dnf)
            # Add HashiCorp repository
            sudo dnf config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo
            sudo dnf install -y terraform vault
            ;;
    esac
    
    print_success "Terraform and Vault installed"
}

# Install Terraform ecosystem tools
install_terraform_tools() {
    print_section "Installing Terraform Ecosystem Tools"
    
    case $PACKAGE_MANAGER in
        brew)
            brew install tflint terragrunt terraform-docs checkov
            ;;
        *)
            # Install tflint
            if ! command -v tflint &> /dev/null; then
                curl -s https://raw.githubusercontent.com/terraform-linters/tflint/master/install_linux.sh | bash
            fi
            
            # Install terragrunt
            if ! command -v terragrunt &> /dev/null; then
                TERRAGRUNT_VERSION=$(curl -s https://api.github.com/repos/gruntwork-io/terragrunt/releases/latest | grep '"tag_name"' | sed -E 's/.*"([^"]+)".*/\1/')
                curl -L "https://github.com/gruntwork-io/terragrunt/releases/download/${TERRAGRUNT_VERSION}/terragrunt_linux_amd64" -o terragrunt
                chmod +x terragrunt
                sudo mv terragrunt /usr/local/bin/
            fi
            
            # Install terraform-docs
            if ! command -v terraform-docs &> /dev/null; then
                TFDOCS_VERSION=$(curl -s https://api.github.com/repos/terraform-docs/terraform-docs/releases/latest | grep '"tag_name"' | sed -E 's/.*"([^"]+)".*/\1/')
                curl -Lo terraform-docs.tar.gz "https://github.com/terraform-docs/terraform-docs/releases/download/${TFDOCS_VERSION}/terraform-docs-${TFDOCS_VERSION}-linux-amd64.tar.gz"
                tar -xzf terraform-docs.tar.gz
                chmod +x terraform-docs
                sudo mv terraform-docs /usr/local/bin/
                rm terraform-docs.tar.gz
            fi
            ;;
    esac
    
    print_success "Terraform ecosystem tools installed"
}

# Install AWS CLI
install_aws_cli() {
    print_section "Installing AWS CLI"
    
    if ! command -v aws &> /dev/null; then
        case $OS in
            "macOS")
                curl "https://awscli.amazonaws.com/AWSCLIV2.pkg" -o "AWSCLIV2.pkg"
                sudo installer -pkg AWSCLIV2.pkg -target /
                rm AWSCLIV2.pkg
                ;;
            *)
                curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
                unzip awscliv2.zip
                sudo ./aws/install
                rm -rf awscliv2.zip aws/
                ;;
        esac
        print_success "AWS CLI installed"
    else
        print_info "AWS CLI already installed"
    fi
}

# Install Kubernetes tools
install_kubernetes_tools() {
    print_section "Installing Kubernetes Tools"
    
    case $PACKAGE_MANAGER in
        brew)
            brew install kubernetes-cli helm
            ;;
        *)
            # Install kubectl
            if ! command -v kubectl &> /dev/null; then
                curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
                chmod +x kubectl
                sudo mv kubectl /usr/local/bin/
            fi
            
            # Install helm
            if ! command -v helm &> /dev/null; then
                curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
            fi
            ;;
    esac
    
    print_success "Kubernetes tools installed"
}

# Install OpenShift CLI
install_openshift_cli() {
    print_section "Installing OpenShift CLI"
    
    case $PACKAGE_MANAGER in
        brew)
            brew install openshift-cli
            ;;
        *)
            if ! command -v oc &> /dev/null; then
                # Download and install oc
                OC_VERSION=$(curl -s https://api.github.com/repos/openshift/oc/releases/latest | grep '"tag_name"' | sed -E 's/.*"([^"]+)".*/\1/')
                curl -L "https://github.com/openshift/oc/releases/download/${OC_VERSION}/openshift-client-linux.tar.gz" -o oc.tar.gz
                tar -xzf oc.tar.gz
                sudo mv oc /usr/local/bin/
                rm oc.tar.gz kubectl || true  # kubectl might be included, remove if present
            fi
            ;;
    esac
    
    print_success "OpenShift CLI installed"
}

# Install container tools
install_container_tools() {
    print_section "Installing Container Tools"
    
    case $PACKAGE_MANAGER in
        brew)
            brew install podman docker
            ;;
        apt)
            sudo apt install -y podman
            # Docker installation for Ubuntu
            if ! command -v docker &> /dev/null; then
                curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
                sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
                sudo apt update
                sudo apt install -y docker-ce docker-ce-cli containerd.io
            fi
            ;;
        dnf)
            sudo dnf install -y podman docker
            ;;
    esac
    
    print_success "Container tools installed"
}

# Install development and quality tools
install_dev_tools() {
    print_section "Installing Development and Quality Tools"
    
    case $PACKAGE_MANAGER in
        brew)
            brew install shellcheck hadolint pre-commit
            ;;
        apt)
            sudo apt install -y shellcheck
            ;;
        dnf)
            sudo dnf install -y ShellCheck
            ;;
    esac
    
    # Install hadolint
    if ! command -v hadolint &> /dev/null; then
        case $OS in
            "macOS")
                brew install hadolint
                ;;
            *)
                wget https://github.com/hadolint/hadolint/releases/latest/download/hadolint-Linux-x86_64 -O hadolint
                chmod +x hadolint
                sudo mv hadolint /usr/local/bin/
                ;;
        esac
    fi
    
    # Install Python tools via pip
    python3 -m pip install --user pre-commit black isort flake8 jinja2 jinja2-cli j2cli
    
    print_success "Development tools installed"
}

# Install Node.js for MCP servers
install_nodejs() {
    print_section "Installing Node.js for MCP Servers"
    
    case $PACKAGE_MANAGER in
        brew)
            brew install node
            ;;
        apt)
            # Install Node.js via NodeSource repository
            curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
            sudo apt install -y nodejs
            ;;
        dnf)
            sudo dnf install -y nodejs npm
            ;;
    esac
    
    print_success "Node.js installed"
}

# Main installation function
main() {
    echo -e "${PURPLE}🔧 Red Hat Demo Environment - Tool Installation${NC}"
    echo -e "${PURPLE}===============================================${NC}"
    echo ""
    
    detect_os
    
    # Install package manager if needed (macOS)
    if [[ "$OS" == "macOS" ]]; then
        install_homebrew
    fi
    
    # Update packages
    update_packages
    
    # Install tools in order of dependency
    install_basic_tools
    install_python
    install_nodejs
    install_ansible
    install_terraform
    install_terraform_tools
    install_aws_cli
    install_kubernetes_tools
    install_openshift_cli
    install_container_tools
    install_dev_tools
    
    echo ""
    echo -e "${GREEN}🎉 Tool Installation Complete!${NC}"
    echo ""
    echo -e "${CYAN}Installed tools:${NC}"
    echo -e "${WHITE}- Git, curl, wget, jq, yq, tree, watch, htop${NC}"
    echo -e "${WHITE}- Python 3 with pip and essential packages${NC}"
    echo -e "${WHITE}- Ansible ecosystem (core, lint, navigator, molecule)${NC}"
    echo -e "${WHITE}- Terraform ecosystem (terraform, vault, tflint, terragrunt, terraform-docs)${NC}"
    echo -e "${WHITE}- AWS CLI v2${NC}"
    echo -e "${WHITE}- Kubernetes tools (kubectl, helm)${NC}"
    echo -e "${WHITE}- OpenShift CLI (oc)${NC}"
    echo -e "${WHITE}- Container tools (podman, docker)${NC}"
    echo -e "${WHITE}- Development tools (shellcheck, hadolint, pre-commit, black, etc.)${NC}"
    echo -e "${WHITE}- Node.js for MCP servers${NC}"
    echo ""
    echo -e "${YELLOW}Next steps:${NC}"
    echo -e "${WHITE}1. Restart your terminal or run: source ~/.bashrc (or ~/.zshrc)${NC}"
    echo -e "${WHITE}2. Verify installations with: ./validate-environment.sh${NC}"
    echo -e "${WHITE}3. Configure tools as needed (aws configure, etc.)${NC}"
}

# Run main function
main "$@" 