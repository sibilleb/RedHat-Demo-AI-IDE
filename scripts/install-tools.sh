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

print_skip() {
    echo -e "${YELLOW}⏭️  $1${NC}"
}

# Configuration flags
FORCE_INSTALL=false
SKIP_PROMPTS=false

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --force)
            FORCE_INSTALL=true
            shift
            ;;
        --yes|-y)
            SKIP_PROMPTS=true
            shift
            ;;
        --help)
            echo "Red Hat Demo Environment - Tool Installation Script"
            echo ""
            echo "Usage: $0 [OPTIONS]"
            echo ""
            echo "Options:"
            echo "  --force               Force reinstall of tools even if they exist"
            echo "  --yes, -y            Skip prompts and install all tools"
            echo "  --help               Show this help message"
            echo ""
            exit 0
            ;;
        *)
            print_error "Unknown option $1. Use --help for usage information."
            ;;
    esac
done

# Function to ask user permission
ask_permission() {
    local tool_name="$1"
    local description="$2"
    
    if [[ "$SKIP_PROMPTS" == "true" ]]; then
        return 0
    fi
    
    echo -e "${YELLOW}Do you want to install ${tool_name}? ${description} (y/N)${NC}"
    read -r response
    if [[ "$response" =~ ^[Yy]$ ]]; then
        return 0
    else
        return 1
    fi
}

# Function to check if a command exists
command_exists() {
    command -v "$1" &> /dev/null
}

# Function to check if tool should be installed
should_install() {
    local tool_name="$1"
    local command_name="$2"
    local description="$3"
    
    if command_exists "$command_name" && [[ "$FORCE_INSTALL" != "true" ]]; then
        print_skip "$tool_name is already installed (found: $(which $command_name))"
        return 1
    fi
    
    if ask_permission "$tool_name" "$description"; then
        return 0
    else
        print_skip "Skipping $tool_name installation"
        return 1
    fi
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
    if [[ "$OS" == "macOS" ]] && should_install "Homebrew" "brew" "Package manager for macOS"; then
        print_info "Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        
        # Add to PATH for current session
        if [[ -f "/opt/homebrew/bin/brew" ]]; then
            eval "$(/opt/homebrew/bin/brew shellenv)"
        fi
        
        print_success "Homebrew installed"
    fi
}

# Update package manager
update_packages() {
    if ask_permission "Package Manager Update" "Update system packages"; then
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
        print_success "Package manager updated"
    fi
}

# Install basic development tools
install_basic_tools() {
    print_section "Installing Basic Development Tools"
    
    # Check individual tools
    local tools_to_install=()
    
    if should_install "Git" "git" "Version control system"; then
        tools_to_install+=("git")
    fi
    
    if should_install "curl" "curl" "HTTP client"; then
        tools_to_install+=("curl")
    fi
    
    if should_install "wget" "wget" "File downloader"; then
        tools_to_install+=("wget")
    fi
    
    if should_install "jq" "jq" "JSON processor"; then
        tools_to_install+=("jq")
    fi
    
    if should_install "yq" "yq" "YAML processor"; then
        tools_to_install+=("yq")
    fi
    
    if should_install "tree" "tree" "Directory listing tool"; then
        tools_to_install+=("tree")
    fi
    
    if should_install "watch" "watch" "Command monitoring tool"; then
        tools_to_install+=("watch")
    fi
    
    if should_install "htop" "htop" "System monitor"; then
        tools_to_install+=("htop")
    fi
    
    # Install selected tools
    if [[ ${#tools_to_install[@]} -gt 0 ]]; then
        case $PACKAGE_MANAGER in
            brew)
                brew install "${tools_to_install[@]}"
                ;;
            apt)
                # Add build-essential if not already installed
                if [[ ! $(dpkg -l | grep build-essential) ]]; then
                    tools_to_install+=("build-essential")
                fi
                sudo apt install -y "${tools_to_install[@]}"
                
                # Install yq separately if needed (not in default repos)
                if [[ " ${tools_to_install[*]} " =~ " yq " ]] && ! command_exists yq; then
                    sudo wget -qO /usr/local/bin/yq https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64
                    sudo chmod +x /usr/local/bin/yq
                fi
                ;;
            dnf)
                # Add development tools if not already installed
                if ! dnf group list installed | grep -q "Development Tools"; then
                    tools_to_install+=("gcc" "gcc-c++" "make")
                fi
                sudo dnf install -y "${tools_to_install[@]}"
                
                # Install yq separately if needed
                if [[ " ${tools_to_install[*]} " =~ " yq " ]] && ! command_exists yq; then
                    sudo wget -qO /usr/local/bin/yq https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64
                    sudo chmod +x /usr/local/bin/yq
                fi
                ;;
        esac
        print_success "Basic tools installed"
    fi
}

# Install Python and pip
install_python() {
    if should_install "Python 3" "python3" "Programming language and package manager"; then
        print_section "Setting up Python Environment"
        
        case $PACKAGE_MANAGER in
            brew)
                brew install python3
                # Install pipx for managing Python applications
                if ! command_exists pipx; then
                    brew install pipx
                    pipx ensurepath
                fi
                ;;
            apt)
                sudo apt install -y python3 python3-pip python3-venv python3-pipx
                ;;
            dnf)
                sudo dnf install -y python3 python3-pip python3-venv pipx
                ;;
        esac
        
        print_success "Python environment ready"
    fi
}

# Create or activate virtual environment for Python packages
setup_python_env() {
    local venv_path="$HOME/.venv/redhat-demo"
    
    if [[ ! -d "$venv_path" ]]; then
        print_info "Creating virtual environment at $venv_path"
        python3 -m venv "$venv_path" || {
            print_error "Failed to create virtual environment"
            return 1
        }
    fi
    
    # Activate virtual environment
    source "$venv_path/bin/activate" || {
        print_error "Failed to activate virtual environment"
        return 1
    }
    
    # Verify activation
    if [[ "$VIRTUAL_ENV" == "$venv_path" ]]; then
        print_info "Successfully activated virtual environment: $venv_path"
    else
        print_warning "Virtual environment may not be properly activated"
    fi
    
    # Upgrade pip in virtual environment
    python3 -m pip install --upgrade pip || {
        print_warning "Failed to upgrade pip in virtual environment"
    }
    
    # Add activation to shell profile
    local shell_profile=""
    if [[ "$SHELL" == *"zsh"* ]]; then
        shell_profile="$HOME/.zshrc"
    elif [[ "$SHELL" == *"bash"* ]]; then
        shell_profile="$HOME/.bashrc"
    fi
    
    if [[ -n "$shell_profile" ]] && [[ -f "$shell_profile" ]]; then
        if ! grep -q "alias redhat-demo-env" "$shell_profile"; then
            echo "" >> "$shell_profile"
            echo "# Red Hat Demo Environment" >> "$shell_profile"
            echo "alias redhat-demo-env='source $venv_path/bin/activate'" >> "$shell_profile"
            print_info "Added 'redhat-demo-env' alias to $shell_profile"
        fi
    fi
}

# Install Python packages safely
install_python_packages() {
    local packages=("$@")
    local expected_venv="$HOME/.venv/redhat-demo"
    
    # Check if we're already in a virtual environment
    if [[ -n "$VIRTUAL_ENV" ]]; then
        if [[ "$VIRTUAL_ENV" == "$expected_venv" ]]; then
            print_info "Already in Red Hat demo virtual environment: $VIRTUAL_ENV"
            print_info "Installing packages directly in current virtual environment"
            python3 -m pip install "${packages[@]}"
            return
        else
            print_info "Currently in different virtual environment: $VIRTUAL_ENV"
            print_info "Switching to Red Hat demo virtual environment"
            # Deactivate current and activate ours
            deactivate 2>/dev/null || true
            setup_python_env
            python3 -m pip install "${packages[@]}"
            return
        fi
    fi
    
    # Check for externally-managed environment or if we need virtual environment
    if python3 -m pip install --help 2>&1 | grep -q "externally-managed-environment" || \
       python3 -c "import sysconfig; print(sysconfig.get_path('purelib'))" 2>/dev/null | grep -q "/opt/homebrew\|/usr/local" || \
       ! python3 -m pip install --user --help >/dev/null 2>&1; then
        print_info "Detected externally-managed Python environment - using virtual environment"
        setup_python_env
        
        # Verify we're in the virtual environment
        if [[ "$VIRTUAL_ENV" != "" ]]; then
            print_info "Installing packages in virtual environment: $VIRTUAL_ENV"
        else
            print_warning "Virtual environment not activated, but continuing with installation"
        fi
        
        python3 -m pip install "${packages[@]}"
    else
        # Use --user flag for user-space installation
        print_info "Using --user installation for Python packages"
        python3 -m pip install --user "${packages[@]}"
    fi
}

# Install Ansible
install_ansible() {
    if should_install "Ansible" "ansible" "Automation platform tools"; then
        print_section "Installing Ansible Ecosystem"
        
        # Install via pip for consistent version across platforms
        install_python_packages ansible ansible-core ansible-lint ansible-navigator molecule "molecule-plugins[docker]" yamllint
        
        print_success "Ansible ecosystem installed"
    fi
}

# Install Terraform
install_terraform() {
    if should_install "Terraform" "terraform" "Infrastructure as Code tool"; then
        print_section "Installing Terraform and Vault"
        
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
    fi
}

# Install Terraform ecosystem tools
install_terraform_tools() {
    print_section "Installing Terraform Ecosystem Tools"
    
    local tf_tools_to_install=()
    
    if should_install "TFLint" "tflint" "Terraform linter"; then
        tf_tools_to_install+=("tflint")
    fi
    
    if should_install "Terragrunt" "terragrunt" "Terraform wrapper"; then
        tf_tools_to_install+=("terragrunt")
    fi
    
    if should_install "terraform-docs" "terraform-docs" "Documentation generator"; then
        tf_tools_to_install+=("terraform-docs")
    fi
    
    if should_install "Checkov" "checkov" "Security scanner"; then
        tf_tools_to_install+=("checkov")
    fi
    
    if [[ ${#tf_tools_to_install[@]} -gt 0 ]]; then
        case $PACKAGE_MANAGER in
            brew)
                # Install via brew
                local brew_tools=()
                for tool in "${tf_tools_to_install[@]}"; do
                    case $tool in
                        "checkov")
                            install_python_packages checkov
                            ;;
                        *)
                            brew_tools+=("$tool")
                            ;;
                    esac
                done
                if [[ ${#brew_tools[@]} -gt 0 ]]; then
                    brew install "${brew_tools[@]}"
                fi
                ;;
            *)
                # Install manually for Linux
                for tool in "${tf_tools_to_install[@]}"; do
                    case $tool in
                        "tflint")
                            curl -s https://raw.githubusercontent.com/terraform-linters/tflint/master/install_linux.sh | bash
                            ;;
                        "terragrunt")
                            curl -L https://github.com/gruntwork-io/terragrunt/releases/latest/download/terragrunt_linux_amd64 -o terragrunt
                            chmod +x terragrunt && sudo mv terragrunt /usr/local/bin/
                            ;;
                        "terraform-docs")
                            curl -sSLo ./terraform-docs.tar.gz https://terraform-docs.io/dl/v0.16.0/terraform-docs-v0.16.0-$(uname)-amd64.tar.gz
                            tar -xzf terraform-docs.tar.gz
                            chmod +x terraform-docs && sudo mv terraform-docs /usr/local/bin/
                            rm terraform-docs.tar.gz
                            ;;
                        "checkov")
                            install_python_packages checkov
                            ;;
                    esac
                done
                ;;
        esac
        print_success "Terraform ecosystem tools installed"
    fi
}

# Install AWS CLI
install_aws_cli() {
    if should_install "AWS CLI" "aws" "Amazon Web Services command line interface"; then
        print_section "Installing AWS CLI"
        
        case $PACKAGE_MANAGER in
            brew)
                brew install awscli
                ;;
            *)
                curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
                unzip awscliv2.zip
                sudo ./aws/install
                rm -rf awscliv2.zip aws/
                ;;
        esac
        
        print_success "AWS CLI installed"
    fi
}

# Install Container Tools
install_container_tools() {
    print_section "Installing Container Tools"
    
    if should_install "Podman" "podman" "Red Hat's container engine"; then
        case $PACKAGE_MANAGER in
            brew)
                brew install podman
                # Initialize podman machine for macOS
                if [[ "$OS" == "macOS" ]]; then
                    podman machine init || true
                    podman machine start || true
                fi
                ;;
            apt)
                sudo apt install -y podman
                ;;
            dnf)
                sudo dnf install -y podman
                ;;
        esac
        print_success "Podman installed"
    fi
    
    if should_install "Docker" "docker" "Container platform (alternative to Podman)"; then
        case $PACKAGE_MANAGER in
            brew)
                brew install --cask docker
                ;;
            apt)
                # Install Docker via official repository
                sudo apt install -y apt-transport-https ca-certificates gnupg lsb-release
                curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
                echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
                sudo apt update
                sudo apt install -y docker-ce docker-ce-cli containerd.io
                ;;
            dnf)
                sudo dnf install -y docker
                sudo systemctl enable docker
                sudo systemctl start docker
                ;;
        esac
        print_success "Docker installed"
    fi
}

# Install Kubernetes Tools
install_kubernetes_tools() {
    print_section "Installing Kubernetes Tools"
    
    if should_install "kubectl" "kubectl" "Kubernetes command line tool"; then
        case $PACKAGE_MANAGER in
            brew)
                brew install kubectl
                ;;
            *)
                curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
                chmod +x kubectl
                sudo mv kubectl /usr/local/bin/
                ;;
        esac
        print_success "kubectl installed"
    fi
    
    if should_install "Helm" "helm" "Kubernetes package manager"; then
        case $PACKAGE_MANAGER in
            brew)
                brew install helm
                ;;
            *)
                curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
                ;;
        esac
        print_success "Helm installed"
    fi
    
    if should_install "OpenShift CLI (oc)" "oc" "Red Hat OpenShift command line tool"; then
        case $PACKAGE_MANAGER in
            brew)
                brew install openshift-cli
                ;;
            *)
                curl -LO https://mirror.openshift.com/pub/openshift-v4/clients/ocp/stable/openshift-client-linux.tar.gz
                tar -xzf openshift-client-linux.tar.gz
                chmod +x oc kubectl
                sudo mv oc /usr/local/bin/
                rm openshift-client-linux.tar.gz
                ;;
        esac
        print_success "OpenShift CLI installed"
    fi
}

# Install Node.js
install_nodejs() {
    if should_install "Node.js" "node" "JavaScript runtime for MCP servers"; then
        print_section "Installing Node.js"
        
        case $PACKAGE_MANAGER in
            brew)
                brew install node
                ;;
            apt)
                curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
                sudo apt-get install -y nodejs
                ;;
            dnf)
                sudo dnf install -y nodejs npm
                ;;
        esac
        
        print_success "Node.js installed"
    fi
}

# Install Cursor IDE
install_cursor() {
    if should_install "Cursor IDE" "cursor" "AI-powered code editor"; then
        print_section "Installing Cursor IDE"
        
        case $OS in
            "macOS")
                # Download and install Cursor for macOS
                curl -L https://downloader.cursor.sh/darwin/x64 -o cursor.zip
                unzip cursor.zip
                sudo mv Cursor.app /Applications/
                rm cursor.zip
                
                # Create symlink for command line usage
                sudo ln -sf /Applications/Cursor.app/Contents/Resources/app/bin/cursor /usr/local/bin/cursor
                ;;
            *)
                # For Linux, download AppImage
                curl -L https://downloader.cursor.sh/linux/x64 -o cursor.AppImage
                chmod +x cursor.AppImage
                sudo mv cursor.AppImage /usr/local/bin/cursor
                ;;
        esac
        
        print_success "Cursor IDE installed"
    fi
}

# Install pre-commit and quality tools
install_quality_tools() {
    print_section "Installing Code Quality Tools"
    
    local quality_tools=()
    
    if should_install "pre-commit" "pre-commit" "Git hooks framework"; then
        quality_tools+=("pre-commit")
    fi
    
    if should_install "black" "black" "Python code formatter"; then
        quality_tools+=("black")
    fi
    
    if should_install "isort" "isort" "Python import sorter"; then
        quality_tools+=("isort")
    fi
    
    if should_install "flake8" "flake8" "Python linter"; then
        quality_tools+=("flake8")
    fi
    
    if should_install "pylint" "pylint" "Python static analyzer"; then
        quality_tools+=("pylint")
    fi
    
    if should_install "bandit" "bandit" "Python security linter"; then
        quality_tools+=("bandit")
    fi
    
    if [[ ${#quality_tools[@]} -gt 0 ]]; then
        install_python_packages "${quality_tools[@]}"
        print_success "Code quality tools installed"
    fi
    
    # Install shell-specific tools
    if should_install "shellcheck" "shellcheck" "Shell script analyzer"; then
        case $PACKAGE_MANAGER in
            brew)
                brew install shellcheck
                ;;
            apt)
                sudo apt install -y shellcheck
                ;;
            dnf)
                sudo dnf install -y ShellCheck
                ;;
        esac
        print_success "ShellCheck installed"
    fi
    
    if should_install "hadolint" "hadolint" "Dockerfile linter"; then
        case $PACKAGE_MANAGER in
            brew)
                brew install hadolint
                ;;
            *)
                wget https://github.com/hadolint/hadolint/releases/latest/download/hadolint-Linux-x86_64 -O hadolint
                chmod +x hadolint
                sudo mv hadolint /usr/local/bin/
                ;;
        esac
        print_success "Hadolint installed"
    fi
}

# Main installation function
main() {
    echo -e "${PURPLE}🔧 Red Hat Demo Environment - Tool Installation${NC}"
    echo -e "${PURPLE}===============================================${NC}"
    echo ""
    
    if [[ "$SKIP_PROMPTS" != "true" ]]; then
        echo -e "${YELLOW}This script will help you install development tools for the Red Hat demo environment.${NC}"
        echo -e "${YELLOW}You'll be asked for permission before installing each tool.${NC}"
        echo -e "${CYAN}Tools that are already installed will be skipped automatically.${NC}"
        echo ""
        echo -e "${YELLOW}Continue with installation? (y/N)${NC}"
        read -r response
        if [[ ! "$response" =~ ^[Yy]$ ]]; then
            print_info "Installation cancelled"
            exit 0
        fi
        echo ""
    fi
    
    # Detect OS and install tools
    detect_os
    
    # Install tools in logical order
    install_homebrew
    update_packages
    install_basic_tools
    install_python
    install_nodejs
    install_ansible
    install_terraform
    install_terraform_tools
    install_aws_cli
    install_container_tools
    install_kubernetes_tools
    install_cursor
    install_quality_tools
    
    echo ""
    print_success "Tool installation completed!"
    echo -e "${CYAN}Next steps:${NC}"
    
    # Check if virtual environment was created
    if [[ -d "$HOME/.venv/redhat-demo" ]]; then
        echo -e "${CYAN}📦 Virtual Environment Information:${NC}"
        echo -e "${CYAN}   Your system uses an externally-managed Python environment.${NC}"
        echo -e "${CYAN}   All Python packages were installed in a virtual environment at:${NC}"
        echo -e "${CYAN}   ~/.venv/redhat-demo${NC}"
        echo -e "${CYAN}   ${NC}"
        echo -e "${CYAN}   To activate the environment in new terminals:${NC}"
        echo -e "${CYAN}   source ~/.venv/redhat-demo/bin/activate${NC}"
        echo -e "${CYAN}   or use the alias: redhat-demo-env${NC}"
        echo -e "${CYAN}   ${NC}"
    fi
    
    echo -e "${CYAN}1. Configure your API keys in .cursor/mcp.json${NC}"
    echo -e "${CYAN}2. Run ./scripts/validate-environment.sh to verify setup${NC}"
    echo -e "${CYAN}3. Start developing with Cursor IDE${NC}"
}

# Run main function
main "$@" 