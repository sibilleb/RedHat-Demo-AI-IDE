# Red Hat Demo AI-Enhanced Development Environment Setup Guide

## Overview

This guide provides **two paths** for setting up an AI-enhanced Red Hat demo development environment featuring Ansible Automation Platform, Terraform, HashiCorp Vault, OpenShift, and Event Driven Ansible integration:

- **🚀 One-Click Automated Setup**: 3 commands, 5 minutes (Recommended)
- **📖 Manual Setup**: Detailed step-by-step instructions for learning and customization

## ⚠️ **IMPORTANT: Complete Prerequisites Checklist**

**Before starting any setup**, you **MUST** prepare the following credentials and accounts. The setup will fail without these:

### 🔑 **Required API Keys & Tokens**

| **Service** | **Required** | **How to Get** | **Purpose** |
|-------------|-------------|----------------|-------------|
| **GitHub Personal Access Token** | ✅ **MANDATORY** | [GitHub > Settings > Developer settings > Personal access tokens](https://github.com/settings/tokens) | Repository access, forking, cloning |
| **AWS Access Key ID + Secret** | ✅ **MANDATORY** | [AWS Console > IAM > Users > Security credentials](https://console.aws.amazon.com/iam/) | All AWS MCP servers, Terraform, infrastructure |
| **Anthropic API Key** | ⚠️ **Recommended** | [Anthropic Console](https://console.anthropic.com/) | Claude AI integration in Cursor |
| **GitHub Username** | ✅ **MANDATORY** | Your GitHub username | Repository forking and configuration |

### 🏢 **Optional Enterprise Credentials** 

| **Service** | **Required** | **How to Get** | **Purpose** |
|-------------|-------------|----------------|-------------|
| **Ansible Tower/AWX Host** | 🔧 Optional | Your organization's AAP instance | Ansible Automation Platform integration |
| **Ansible Tower Username/Password** | 🔧 Optional | Your AAP credentials | AAP authentication |
| **Terraform Cloud Token** | 🔧 Optional | [Terraform Cloud](https://app.terraform.io/app/settings/tokens) | Terraform Cloud integration |
| **Kubeconfig Path** | 🔧 Optional | Your Kubernetes cluster config | Kubernetes MCP server |

### 💻 **System Requirements**

- **OS**: macOS, Linux, or Windows WSL2
- **RAM**: 16GB minimum (32GB recommended)
- **Storage**: 50GB available space
- **Network**: Stable internet connection

### 🏗️ **Account Access Required**

- **GitHub Account** with ability to fork repositories
- **AWS Account** with administrative permissions
- **Red Hat Developer Account** (for registry access)
- **Cursor IDE License** (free tier available)

---

## 🚀 Option 1: One-Click Automated Setup (Recommended)

**Perfect for**: Getting started quickly, production use, teams wanting consistency

### Quick Start (3 Commands)

**⚠️ WARNING: Have your GitHub username and API keys ready before starting!**

```bash
# 1. Create workspace and get setup script
mkdir my-redhat-demo-workspace && cd my-redhat-demo-workspace
curl -sSL https://raw.githubusercontent.com/sibilleb/RedHat-Demo-AI-IDE/main/scripts/one-click-setup.sh -o setup.sh

# 2. Run automated setup (replace YOUR_GITHUB_USERNAME)
chmod +x setup.sh
./setup.sh --username YOUR_GITHUB_USERNAME

# 3. Add API keys and start developing
./scripts/start-demo-development.sh
```

### What the Automation Does

The one-click setup automatically:

1. **Creates workspace structure**
2. **Forks and clones repositories** with proper git remotes
3. **Installs all CLI tools** (Terraform, Ansible, AWS CLI, Kubernetes tools, etc.)
4. **Configures Cursor IDE** with extensions and settings
5. **Sets up pre-commit hooks** and development tools
6. **Creates helper scripts** for common tasks
7. **Prepares comprehensive MCP configuration** with 10 essential servers:
   - Ansible Automation Platform integration
   - AWS Labs suite (Documentation, EKS, ECS, CDK, Cost Analysis)  
   - HashiCorp Terraform official server
   - GitHub official server
   - Kubernetes management server
   - Docker operations server
8. **Validates the environment** and reports any issues

⏭️ **After automation completes**: Skip to [Final Configuration](#final-configuration) section.

---

## 📖 Option 2: Manual Setup (Educational)

**Perfect for**: Learning the process, custom environments, troubleshooting, understanding each step

### Target Audience
- Red Hat Sales Engineers and Solutions Architects
- Red Hat Product Teams and Partners
- DevOps Teams wanting AI-assisted development practices

### Manual Setup Steps

#### Step 1: Install Core Development Tools

**Git and Basic Tools:**
```bash
# Verify Git is installed (required for all workflows)
git --version

# macOS: Install Homebrew if not present
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Linux (Ubuntu/Debian): Update package manager
sudo apt update && sudo apt upgrade -y

# Basic utilities
# macOS:
brew install curl wget jq yq tree watch htop
# Linux:
sudo apt install curl wget jq tree watch htop -y
pip3 install yq
```

**Python Environment:**
```bash
# Install Python 3.9+ and pip
# macOS:
brew install python
# Linux:
sudo apt install python3 python3-pip python3-venv -y

# Create virtual environment (recommended)
python3 -m venv ~/.venv/redhat-demo
source ~/.venv/redhat-demo/bin/activate

# Add to your shell profile (.bashrc, .zshrc):
echo 'alias demo-env="source ~/.venv/redhat-demo/bin/activate"' >> ~/.zshrc
```

#### Step 2: Install Infrastructure Tools

**Terraform:**
```bash
# macOS:
brew install terraform

# Linux:
wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install terraform
```

**Ansible Ecosystem:**
```bash
# Install Ansible core and automation platform tools
pip3 install ansible ansible-core ansible-navigator ansible-runner

# Install Ansible ecosystem tools
pip3 install ansible-lint molecule molecule-plugins[docker] yamllint

# Install collections (do this in your project directory later)
ansible-galaxy collection install ansible.posix community.general community.crypto
```

**HashiCorp Vault:**
```bash
# macOS:
brew install vault

# Linux: (uses same HashiCorp repository as Terraform)
sudo apt install vault
```

**AWS CLI:**
```bash
# macOS:
brew install awscli

# Linux:
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip && sudo ./aws/install
rm -rf awscliv2.zip aws/
```

#### Step 3: Install Container and Kubernetes Tools

**Container Tools:**
```bash
# Podman (Red Hat's container engine)
# macOS:
brew install podman
podman machine init
podman machine start

# Linux:
sudo apt install podman -y

# Docker (alternative)
# Download Docker Desktop from: https://www.docker.com/products/docker-desktop/
```

**Kubernetes Tools:**
```bash
# kubectl and Helm
# macOS:
brew install kubectl helm

# Linux:
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x kubectl && sudo mv kubectl /usr/local/bin/

# Helm
curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
```

**OpenShift CLI:**
```bash
# macOS:
brew install openshift-cli

# Linux:
# Download from: https://console.redhat.com/openshift/downloads
# Or use the mirror:
curl -LO https://mirror.openshift.com/pub/openshift-v4/clients/ocp/stable/openshift-client-linux.tar.gz
tar -xzf openshift-client-linux.tar.gz
chmod +x oc kubectl && sudo mv oc kubectl /usr/local/bin/
```

#### Step 4: Install Development and Quality Tools

**Terraform Ecosystem:**
```bash
# macOS:
brew install tflint terragrunt terraform-docs checkov

# Linux:
# TFLint
curl -s https://raw.githubusercontent.com/terraform-linters/tflint/master/install_linux.sh | bash

# Terragrunt
curl -L https://github.com/gruntwork-io/terragrunt/releases/latest/download/terragrunt_linux_amd64 -o terragrunt
chmod +x terragrunt && sudo mv terragrunt /usr/local/bin/

# Terraform-docs
curl -sSLo ./terraform-docs.tar.gz https://terraform-docs.io/dl/v0.16.0/terraform-docs-v0.16.0-$(uname)-amd64.tar.gz
tar -xzf terraform-docs.tar.gz
chmod +x terraform-docs && sudo mv terraform-docs /usr/local/bin/

# Checkov
pip3 install checkov
```

**Code Quality Tools:**
```bash
# Pre-commit framework
pip3 install pre-commit

# Linting tools
# macOS:
brew install hadolint shellcheck
# Linux:
sudo apt install shellcheck -y
wget https://github.com/hadolint/hadolint/releases/latest/download/hadolint-Linux-x86_64 -O hadolint
chmod +x hadolint && sudo mv hadolint /usr/local/bin/

# Python tools
pip3 install black isort flake8 pylint bandit safety
```

**Template and Documentation Tools:**
```bash
# Jinja2 templating (critical for Ansible)
pip3 install jinja2 jinja2-cli j2cli

# Project templating
pip3 install cookiecutter

# Node.js for MCP servers and additional tooling
# macOS:
brew install node
# Linux:
curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
sudo apt-get install -y nodejs
```

#### Step 5: Create Workspace and Fork Repositories

**Create your development workspace:**
```bash
# Create a dedicated workspace directory
mkdir my-redhat-demo-workspace
cd my-redhat-demo-workspace
```

**Fork the repositories:**
1. Go to [https://github.com/sibilleb/RedHat-Demo-AI-IDE](https://github.com/sibilleb/RedHat-Demo-AI-IDE)
2. Click **Fork** to create your copy
3. Go to [https://github.com/ansible/product-demos](https://github.com/ansible/product-demos)  
4. Click **Fork** to create your copy

**Clone your forks:**
```bash
# Clone the setup repository (replace YOUR_USERNAME)
git clone https://github.com/YOUR_USERNAME/RedHat-Demo-AI-IDE.git
cd RedHat-Demo-AI-IDE

# Set up git remotes
git remote add upstream https://github.com/sibilleb/RedHat-Demo-AI-IDE.git
git remote set-url origin https://github.com/YOUR_USERNAME/RedHat-Demo-AI-IDE.git

# Clone the demos repository  
cd ..
git clone https://github.com/YOUR_USERNAME/product-demos.git
cd product-demos

# Set up git remotes
git remote add upstream https://github.com/ansible/product-demos.git
git remote set-url origin https://github.com/YOUR_USERNAME/product-demos.git
```

#### Step 6: Configure Cursor IDE

**Install Cursor IDE:**
1. Download from [https://cursor.sh/](https://cursor.sh/)
2. Install and launch the application
3. Open Settings (⌘ + ,)
4. Search for "terminal"
5. Enable "Allow AI to run terminal commands"
6. Select Claude 3.5 Sonnet as your AI model

**Initial Setup Prompt:**
```
I want to set up my Red Hat demo development environment. I have already forked both repositories to my GitHub account.

My GitHub username is: [REPLACE-WITH-YOUR-USERNAME]

Please:

1. Clone my forked repositories:
   - https://github.com/[YOUR-USERNAME]/RedHat-Demo-AI-IDE  
   - https://github.com/[YOUR-USERNAME]/product-demos

2. Set up proper git remotes:
   - origin: my forks (for pushing changes)
   - upstream: original repos (for pulling updates)

3. Create the basic directory structure and symlinks
```

**Environment Setup Prompt:**
```
Now I need to complete the full development environment setup. Please:

1. Install all required CLI tools for my operating system:
   - Terraform, Ansible, HashiCorp Vault
   - AWS CLI, kubectl, Helm, OpenShift CLI (oc)  
   - Podman, jq, yq, tree, and development tools
   - Python packages: ansible-lint, molecule, yamllint, jinja2

2. Configure Cursor IDE integration:
   - Set up the .cursor configuration symlink
   - Copy and configure the comprehensive MCP server template (10 servers)
   - Install recommended Cursor extensions

3. Set up development workflow tools:
   - Pre-commit hooks for code quality
   - Validation scripts
   - Helper scripts for demo development

My operating system is: [macOS/Linux/Windows]
I have access to: [AWS account yes/no] [Red Hat developer account yes/no]
```

**Development Start Prompt:**
```
I've completed the Red Hat demo environment setup. Please:

1. Create a new demo directory in the appropriate category (linux/cloud/network/etc.)
2. Set up the standard Red Hat demo structure following official guidelines
3. Configure the demo's automation framework with Ansible best practices
```

#### Step 7: Set Up MCP Configuration

**Configure MCP for AI Integration:**

> 📖 **For detailed information about all 10 MCP servers**, see [MCP_SERVERS.md](./docs/MCP_SERVERS.md)

```bash
# Copy MCP template to active configuration
cp .cursor/mcp.json.template .cursor/mcp.json

# Edit the configuration with your API keys
# This is where you'll add all the credentials from the prerequisites checklist
nano .cursor/mcp.json
```

**⚠️ REQUIRED: Add your API keys to `.cursor/mcp.json`:**

Replace these placeholders with your actual credentials:
- `YOUR_GITHUB_PERSONAL_ACCESS_TOKEN_HERE`
- `YOUR_AWS_ACCESS_KEY_ID_HERE` 
- `YOUR_AWS_SECRET_ACCESS_KEY_HERE`
- `YOUR_ANSIBLE_TOWER_HOST_HERE` (if using AAP)
- `YOUR_ANSIBLE_TOWER_USERNAME_HERE` (if using AAP)
- `YOUR_ANSIBLE_TOWER_PASSWORD_HERE` (if using AAP)
- `YOUR_TERRAFORM_CLOUD_TOKEN_HERE` (if using Terraform Cloud)
- `YOUR_KUBECONFIG_PATH_HERE` (if using Kubernetes)

#### Step 8: Set Up Development Environment

**Configure Python environment:**
```bash
# Create project-specific virtual environment
python3 -m venv venv
source venv/bin/activate

# Install Python dependencies
pip install -r requirements.txt
```

**Install Ansible collections:**
```bash
# Install required Ansible collections
ansible-galaxy collection install -r requirements.yml
```

**Configure pre-commit hooks:**
```bash
# Install pre-commit hooks
pre-commit install

# Test hooks (optional)
pre-commit run --all-files
```

#### Step 9: Validate Environment

**Run validation script:**
```bash
# Make validation script executable and run it
chmod +x scripts/validate-environment.sh
./scripts/validate-environment.sh
```

This will check:
- All required tools are installed
- API keys are configured
- Git repositories are properly set up
- Cursor IDE configuration is correct

---

## 🔧 Final Configuration

**Both setup paths lead here. Complete these final steps:**

### 1. **Add Your API Keys** 

Edit `.cursor/mcp.json` and replace all `YOUR_*_HERE` placeholders with actual values from the prerequisites checklist.

### 2. **Configure Cursor AI Model**

In Cursor IDE:
1. Open **Settings** (⌘ + ,)
2. Search for **"AI Model"**
3. Select **Claude 3.5 Sonnet** (recommended)
4. Enter your **Anthropic API key**

### 3. **Test the Environment**

```bash
# Run the validation script
./scripts/validate-environment.sh

# Start development environment
./scripts/start-demo-development.sh
```

### 4. **Verify MCP Servers**

In Cursor IDE:
1. Open **Command Palette** (⌘ + Shift + P)
2. Type **"MCP"** 
3. Verify you see 10 MCP servers connected
4. Test AI integration with a simple prompt

## 🎯 You're Ready!

Your AI-enhanced Red Hat demo development environment is now configured with:

- ✅ **Complete toolchain** (Terraform, Ansible, AWS CLI, Kubernetes, etc.)
- ✅ **AI integration** (Cursor + Claude + 10 MCP servers)
- ✅ **Development workflow** (pre-commit hooks, linting, formatting)
- ✅ **Red Hat demo repositories** (forked and properly configured)

**Next Steps:**
1. **Explore the demos**: `cd product-demos && ls`
2. **Start with Ansible**: Try the Ansible Automation Platform demos
3. **AI Assistance**: Use Claude in Cursor for code generation and troubleshooting
4. **Customize**: Adapt the environment for your specific use cases

## 🆘 Troubleshooting

**Common Issues:**

- **"GitHub clone failed"**: Check your GitHub username and SSH key configuration
- **"MCP servers not connecting"**: Verify API keys in `.cursor/mcp.json`
- **"Tool not found"**: Re-run the installation steps for missing tools
- **"Permission denied"**: Check file permissions and run with proper user privileges

**Getting Help:**
- Check [docs/TROUBLESHOOTING.md](./docs/TROUBLESHOOTING.md)
- Review logs in `~/.cursor/logs/`
- Open an issue in the [GitHub repository](https://github.com/sibilleb/RedHat-Demo-AI-IDE/issues)

## Security Considerations

**Secrets Management:**
- Never commit API keys or credentials to git
- Use `.env` files or MCP configuration for sensitive data
- The `.cursor/mcp.json` file is gitignored for security
- Use HashiCorp Vault for production secrets

**Container Security:**
- Images are scanned for vulnerabilities via pre-commit hooks
- Run containers as non-root when possible
- Use Red Hat Universal Base Images (UBI) for production

**Access Control:**
- Use separate accounts for development and production
- Follow principle of least privilege
- Enable MFA on all cloud accounts

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- **Red Hat Community** for excellent documentation and tools
- **HashiCorp** for robust infrastructure tools
- **Ansible Community** for automation excellence
- **Open Source Community** for continuous innovation

---

## Summary

This setup guide provides two paths to create an AI-enhanced development environment for Red Hat demo development:

### One-Click Setup Benefits
- **5-minute setup** from zero to productive development
- **Consistent environment** across all team members
- **Best practices** automatically configured
- **Production-ready** configuration

### Manual Setup Benefits
- **Complete understanding** of all components
- **Customization opportunities** for specific needs
- **Learning experience** for the technology stack
- **Troubleshooting knowledge** for complex environments

### Key Value Propositions

**Traditional Red Hat Demo Development:**
- Manual coding and testing
- Standard IDE experience
- Manual best practices enforcement
- Individual knowledge silos

**AI-Enhanced Development with This Environment:**
- Cursor IDE + Claude for intelligent code generation
- Automated Red Hat standards compliance
- Real-time validation and suggestions
- Shared AI knowledge across team
- Seamless integration with existing workflows

### For Red Hat Teams

1. **Faster Demo Creation**: AI assistance accelerates development by 3-5x
2. **Higher Quality**: Automated validation ensures Red Hat standards compliance
3. **Better Consistency**: AI learns from existing demo patterns and enforces them
4. **Easier Contributions**: Streamlined workflow for contributing back to official repos
5. **Knowledge Transfer**: Modern development practices shared across entire team
6. **Reduced Onboarding**: New team members productive in hours instead of days

### Integration Points

- **Direct integration** with [ansible/product-demos](https://github.com/ansible/product-demos)
- **Compatible** with [demo.redhat.com](https://demo.redhat.com) environments
- **Supports** existing Red Hat collections and Automation Hub workflows
- **Enhances** current contribution processes without disrupting them

---

**Environment Version**: 2.0.0 (AI-Enhanced)  
**Compatible with**: Red Hat Product Demos Repository  
**Maintained by**: Red Hat Solutions Architecture Community  
**Setup completed**: $(date) 