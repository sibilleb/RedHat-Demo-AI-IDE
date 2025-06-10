# Red Hat Demo Development Environment Setup Guide

## Overview

This guide provides two paths for setting up an AI-enhanced Red Hat demo development environment:

**🤖 Path 1: AI-Assisted Setup (Recommended)** - Let Claude do the work for you  
**📚 Path 2: Manual Setup** - Step-by-step instructions for manual configuration

## 🚀 Path 1: AI-Assisted Setup (Easiest)

**For most users, this is the recommended approach.**

### Quick Start Steps

1. **Create your workspace:**
   ```bash
   mkdir my-redhat-demo-workspace
   cd my-redhat-demo-workspace
   cursor .
   ```

2. **Copy and paste the setup prompt from [CURSOR_SETUP_PROMPT.md](CURSOR_SETUP_PROMPT.md) into Cursor chat**

3. **Let Claude set up everything automatically** - it will:
   - Clone both repositories (this setup repo + official Red Hat demos)
   - Install all required CLI tools for your OS
   - Configure Cursor IDE with proper rules and MCP servers
   - Set up the development workflow
   - Create helper scripts

4. **Complete the manual steps** Claude tells you about (mainly adding API keys)

**That's it!** Skip to [Phase 6: Final Configuration](#phase-6-final-configuration) once Claude finishes.

---

## 📚 Path 2: Manual Setup

If you prefer to understand and execute each step manually, continue with the detailed guide below.

### Objectives

- **Enhance Red Hat Demo Development**: Work with [Red Hat Product Demos](https://github.com/ansible/product-demos) using AI assistance
- **AI-Assisted Coding**: Leverage Cursor IDE and Claude for intelligent code generation and review
- **Automated Best Practices**: Ensure compliance with Red Hat coding standards through automated tooling
- **Seamless Integration**: Maintain compatibility with existing Red Hat demo workflows

### Target Audience

- Red Hat Sales Engineers and Solutions Architects
- Red Hat Product Teams and Partners
- DevOps Teams wanting AI-assisted development practices

## Prerequisites

### System Requirements
- macOS, Linux, or Windows with WSL2
- Minimum 16GB RAM (32GB recommended)
- 50GB available disk space
- Internet connection for downloading tools and dependencies

### Access Requirements
- **Red Hat Demo Access**: Access to [demo.redhat.com](https://demo.redhat.com) (for Red Hat Associates and Partners)
- **GitHub Access**: Permission to fork and contribute to [rh-product-demos](https://github.com/ansible/product-demos)
- **Red Hat Developer Account**: For accessing Red Hat registries and Automation Hub
- **AWS Account**: Administrative privileges for cloud infrastructure provisioning
- **HashiCorp Cloud Platform**: Optional, for Vault Cloud integration

### Development Tools
- Git (latest version)
- Docker Desktop or Podman
- Terminal/shell access (zsh/bash recommended)
- Cursor IDE or VS Code

## Phase 1: Core CLI Tools Installation

### Essential Infrastructure Tools

```bash
# Package managers (choose based on your OS)
# macOS (Homebrew)
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Linux (Ubuntu/Debian)
sudo apt update && sudo apt upgrade -y

# Install core infrastructure tools
# Terraform
brew install terraform
# OR for Linux:
# wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
# echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
# sudo apt update && sudo apt install terraform

# Ansible (latest)
pip3 install ansible ansible-core
# OR
brew install ansible

# HashiCorp Vault
brew install vault
# OR for Linux: use the same HashiCorp repository as Terraform

# AWS CLI v2
curl "https://awscli.amazonaws.com/AWSCLIV2.pkg" -o "AWSCLIV2.pkg" && sudo installer -pkg AWSCLIV2.pkg -target /
# OR for Linux:
# curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
# unzip awscliv2.zip && sudo ./aws/install

# Kubernetes tools
brew install kubernetes-cli helm
# OR for Linux:
# curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
# chmod +x kubectl && sudo mv kubectl /usr/local/bin/
```

### Red Hat and OpenShift Tools

```bash
# OpenShift CLI
brew install openshift-cli
# OR download from: https://console.redhat.com/openshift/downloads

# Podman (Red Hat's container engine)
brew install podman
# OR for Linux:
# sudo apt install podman

# Initialize Podman machine (macOS/Windows)
podman machine init
podman machine start
```

### Development Ecosystem Tools

```bash
# Terraform ecosystem
brew install tflint terragrunt terraform-docs checkov
# OR for Linux, install individually:
# curl -s https://raw.githubusercontent.com/terraform-linters/tflint/master/install_linux.sh | bash
# curl -L https://github.com/gruntwork-io/terragrunt/releases/download/v0.50.0/terragrunt_linux_amd64 -o terragrunt
# chmod +x terragrunt && sudo mv terragrunt /usr/local/bin/

# Ansible ecosystem
pip3 install ansible-lint molecule molecule-plugins[docker] yamllint
pip3 install ansible-navigator ansible-runner

# Template engines and Python tools
pip3 install jinja2 jinja2-cli j2cli
pip3 install cookiecutter  # For project templating

# Security and validation tools
pip3 install pre-commit
brew install hadolint shellcheck
# OR for Linux:
# sudo apt install shellcheck
# wget https://github.com/hadolint/hadolint/releases/latest/download/hadolint-Linux-x86_64 -O hadolint
# chmod +x hadolint && sudo mv hadolint /usr/local/bin/

# Utilities
brew install jq yq tree watch htop
# OR for Linux:
# sudo apt install jq tree watch htop
# pip3 install yq

### Jinja2 Integration for Red Hat Ecosystem

Jinja2 is a critical component for the Red Hat demo environment, providing powerful templating capabilities:

```bash
# Install Jinja2 ecosystem (if not already installed above)
pip3 install jinja2 jinja2-cli j2cli

# Additional templating tools for complex scenarios
pip3 install cookiecutter  # Project template generation
pip3 install ansible-templating-tools  # Extended Ansible templating utilities

# Verify Jinja2 installation
python3 -c "import jinja2; print(f'Jinja2 {jinja2.__version__} installed successfully')"

# Test CLI templating
echo "Environment: {{ env | default('development') }}" | j2 -D env=production
```

**Why Jinja2 is Essential for This Environment:**
- **Ansible Templates**: Dynamic configuration files, inventory generation, and playbook customization
- **Terraform Integration**: Variable templating and dynamic resource configuration
- **Event Driven Ansible**: Dynamic rulebook generation based on environment conditions
- **OpenShift/Kubernetes**: YAML manifest templating for different environments
- **Documentation**: Dynamic documentation generation with environment-specific details

**Common Use Cases in Red Hat Ecosystem:**
- Generating environment-specific Ansible inventories
- Creating dynamic Kubernetes/OpenShift manifests
- Templating Terraform variable files
- Building configuration files for different deployment targets
- Automating documentation updates
```

### Container and Virtualization Tools

```bash
# Docker Desktop (alternative to Podman)
# Download from: https://www.docker.com/products/docker-desktop/

# Vagrant (for local testing environments)
brew install vagrant
# OR download from: https://www.vagrantup.com/downloads

# VirtualBox (Vagrant provider)
brew install --cask virtualbox
# OR download from: https://www.virtualbox.org/wiki/Downloads
```

## Phase 2: Cursor IDE Configuration

### Required Extensions

Install the following extensions in Cursor IDE:

```json
{
  "recommendations": [
    "HashiCorp.terraform",
    "redhat.ansible",
    "redhat.vscode-commons",
    "redhat.vscode-yaml",
    "ms-vscode.vscode-json",
    "eamodio.gitlens",
    "ms-vscode.vscode-docker",
    "ms-kubernetes-tools.vscode-kubernetes-tools",
    "redhat.vscode-openshift-connector",
    "esbenp.prettier-vscode",
    "streetsidesoftware.code-spell-checker",
    "yzhang.markdown-all-in-one",
    "ms-python.python",
    "ms-python.pylint",
    "timonwong.shellcheck"
  ]
}
```

### MCP Server Configuration

Update your `.cursor/mcp.json` configuration:

```json
{
  "mcpServers": {
    "taskmaster-ai": {
      "command": "npx",
      "args": ["-y", "task-master-ai", "mcp"],
      "env": {
        "ANTHROPIC_API_KEY": "your-anthropic-key",
        "PERPLEXITY_API_KEY": "your-perplexity-key"
      }
    },
    "github": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-github"],
      "env": {
        "GITHUB_PERSONAL_ACCESS_TOKEN": "your-github-token"
      }
    },
    "filesystem": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-filesystem", "/path/to/your/project"]
    },
    "kubernetes": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-kubernetes"]
    }
  }
}
```

### Cursor Rules Setup

Ensure you have comprehensive cursor rules for:
- Ansible best practices (including Jinja2 templating)
- Terraform standards
- AWS CLI usage
- Kubernetes/OpenShift patterns
- Docker/container practices
- Security guidelines
- Python development (for custom modules and plugins)

### MCP (Model Context Protocol) Configuration

Configure the MCP servers for enhanced AI capabilities:

1. **Copy the MCP template:**
   ```bash
   cp .cursor/mcp.json.template .cursor/mcp.json
   ```

2. **Add your API keys to `.cursor/mcp.json`:**
   - `ANTHROPIC_API_KEY`: For Claude AI integration
   - `OPENAI_API_KEY`: For OpenAI models (if using)
   - `PERPLEXITY_API_KEY`: For research capabilities
   - `GITHUB_PERSONAL_ACCESS_TOKEN`: For GitHub integration
   - Additional keys as needed for your preferred AI providers

3. **Verify MCP configuration:**
   - The `.cursor/mcp.json` file is ignored by git (contains secrets)
   - The template file `.cursor/mcp.json.template` is committed for reference
   - TaskMaster AI and GitHub MCP servers will be available in Cursor

## Phase 3: Project Structure Setup

### Directory Structure Creation

```bash
# Create the main project structure
mkdir -p ansible-dev-ide/{ansible,terraform,eda,vault,openshift,docs,tests,.github}

# Ansible structure
mkdir -p ansible-dev-ide/ansible/{inventories,playbooks,roles,collections,group_vars,host_vars}
mkdir -p ansible-dev-ide/ansible/inventories/{production,staging,development}

# Terraform structure  
mkdir -p ansible-dev-ide/terraform/{environments,modules,shared}
mkdir -p ansible-dev-ide/terraform/environments/{dev,staging,prod}
mkdir -p ansible-dev-ide/terraform/modules/{networking,compute,storage,security}

# EDA structure
mkdir -p ansible-dev-ide/eda/{rulebooks,decision-environments,execution-environments,plugins}

# Vault structure
mkdir -p ansible-dev-ide/vault/{policies,config,scripts,secrets}

# OpenShift structure
mkdir -p ansible-dev-ide/openshift/{operators,applications,pipelines,manifests}

# Documentation structure
mkdir -p ansible-dev-ide/docs/{architecture,runbooks,demos,api}

# Testing structure
mkdir -p ansible-dev-ide/tests/{molecule,terraform,integration,unit}

# CI/CD structure
mkdir -p ansible-dev-ide/.github/{workflows,templates}
```

### Initial Configuration Files

```bash
# Navigate to project root
cd ansible-dev-ide

# Create Ansible configuration
cat > ansible/ansible.cfg << 'EOF'
[defaults]
inventory = inventories/
host_key_checking = False
retry_files_enabled = False
stdout_callback = yaml
callback_whitelist = timer, profile_tasks
gather_facts = smart
fact_caching = jsonfile
fact_caching_connection = /tmp/facts_cache
fact_caching_timeout = 3600
pipelining = True
forks = 20

[ssh_connection]
ssh_args = -o ControlMaster=auto -o ControlPersist=60s -o UserKnownHostsFile=/dev/null -o IdentitiesOnly=yes
control_path_dir = /tmp/.ansible-%%C
control_path = %(control_path_dir)s/%%h-%%r
EOF

# Create Terraform configuration
cat > terraform/.terraformrc << 'EOF'
provider_installation {
  filesystem_mirror {
    path    = "/tmp/terraform/providers"
    include = ["registry.terraform.io/*/*"]
  }
  direct {
    exclude = ["registry.terraform.io/*/*"]
  }
}
EOF

# Create pre-commit configuration
cat > .pre-commit-config.yaml << 'EOF'
repos:
  - repo: https://github.com/pre-commit/pre-commit-hooks
    rev: v4.4.0
    hooks:
      - id: trailing-whitespace
      - id: end-of-file-fixer
      - id: check-yaml
      - id: check-json
      - id: check-merge-conflict
      
  - repo: https://github.com/ansible/ansible-lint
    rev: v6.22.1
    hooks:
      - id: ansible-lint
        
  - repo: https://github.com/antonbabenko/pre-commit-terraform
    rev: v1.83.5
    hooks:
      - id: terraform_fmt
      - id: terraform_validate
      - id: terraform_tflint
      
  - repo: https://github.com/koalaman/shellcheck-precommit
    rev: v0.9.0
    hooks:
      - id: shellcheck
EOF
```

## Phase 4: Environment Configuration

### AWS Configuration

```bash
# Configure AWS CLI
aws configure
# Enter your AWS Access Key ID, Secret Access Key, Default region, and Output format

# Verify AWS configuration
aws sts get-caller-identity
aws ec2 describe-regions --output table
```

### Red Hat Authentication

```bash
# Login to Red Hat Container Registry
podman login registry.redhat.io
# Use your Red Hat Developer credentials

# Login to Ansible Galaxy
ansible-galaxy collection install -r requirements.yml
```

### Git Configuration

```bash
# Initialize Git repository
git init
git add .
git commit -m "Initial project structure"

# Install pre-commit hooks
pre-commit install
```

### Validation Scripts

Create validation scripts to verify the setup:

```bash
# Create validation script
cat > scripts/validate-setup.sh << 'EOF'
#!/bin/bash

echo "=== Validating Development Environment Setup ==="

# Check CLI tools
echo "Checking CLI tools..."
terraform version
ansible --version
vault version
aws --version
oc version --client
kubectl version --client
helm version

# Check Ansible collections
echo "Checking Ansible collections..."
ansible-galaxy collection list

# Check Jinja2 and templating tools
echo "Checking Jinja2..."
python3 -c "import jinja2; print(f'Jinja2 version: {jinja2.__version__}')"
j2 --version 2>/dev/null || echo "j2cli not found"

# Check Terraform providers
echo "Checking Terraform..."
cd terraform/environments/dev
terraform init -backend=false
terraform providers

# Check container tools
echo "Checking container tools..."
podman version
docker --version 2>/dev/null || echo "Docker not installed (using Podman)"

echo "=== Setup validation complete ==="
EOF

chmod +x scripts/validate-setup.sh
```

## Phase 5: Final Configuration

**This section applies to both AI-assisted and manual setup paths.**

### Configure MCP Server API Keys

Edit `.cursor/mcp.json` and add your API keys:

```json
{
  "mcpServers": {
    "taskmaster-ai": {
      "env": {
        "ANTHROPIC_API_KEY": "your-claude-api-key-here"
      }
    },
    "github": {
      "env": {
        "GITHUB_PERSONAL_ACCESS_TOKEN": "your-github-token-here"  
      }
    }
  }
}
```

### Validate Your Environment

```bash
# Run the validation script (created by setup)
./validate-environment.sh

# Should show all tools installed and repositories present
```

### Start Developing

```bash
# Quick start for Red Hat demo development
./start-demo-development.sh

# Or manually navigate
cd product-demos
cursor .
```

---

## Phase 6: Red Hat Product Demos Integration (Manual Setup Only)

**Note: If you used AI-assisted setup, this is already configured.**

### Setting Up the Red Hat Demos Repository

```bash
# Create a workspace directory for Red Hat demo development
mkdir -p ~/redhat-demo-workspace
cd ~/redhat-demo-workspace

# Clone the official Red Hat product demos repository
git clone https://github.com/ansible/product-demos.git product-demos
cd product-demos

# Fork the repository on GitHub if you plan to contribute
# Then add your fork as a remote
git remote add fork https://github.com/YOUR-USERNAME/product-demos.git

# Setup the enhanced development environment
ln -s ../ansible-dev-ide/.cursor .cursor
ln -s ../ansible-dev-ide/.pre-commit-config.yaml .pre-commit-config.yaml
ln -s ../ansible-dev-ide/scripts/enhanced scripts/enhanced

# Install pre-commit hooks for quality assurance
pre-commit install

# Verify the setup follows Red Hat demo standards
./scripts/enhanced/validate-rh-demo-env.sh
```

### Understanding the Red Hat Demos Structure

The [rh-product-demos repository](https://github.com/ansible/product-demos) follows this structure:
- `linux/` - RHEL and Linux automation demos
- `windows/` - Windows Server automation demos  
- `cloud/` - Infrastructure and cloud provisioning
- `network/` - Network automation demos
- `openshift/` - OpenShift automation demos
- `satellite/` - Red Hat Satellite Server demos

### Creating a Custom Demo with AI Assistance

```bash
# Navigate to the appropriate demo category
cd product-demos/linux  # or windows/, cloud/, etc.

# Create a new demo using AI assistance
mkdir my-custom-demo
cd my-custom-demo

# Use Cursor IDE with Claude for intelligent development
cursor .

# Follow the established patterns from existing demos
# - Copy structure from similar demos
# - Use AI to generate playbooks following Red Hat best practices
# - Leverage existing roles and collections
```

### Integration with Automation Hub

```bash
# Ensure your demos use official Red Hat collections
# Add to collections/requirements.yml:
cat >> collections/requirements.yml << 'EOF'
collections:
  - name: redhat.satellite
    version: ">=3.0.0"
  - name: redhat.insights
    version: ">=1.0.0"
  - name: ansible.posix
    version: ">=1.3.0"
EOF

# Install collections using your Automation Hub credential
ansible-galaxy collection install -r collections/requirements.yml
```

## Phase 6: TaskMaster Integration for Demo Management

### TaskMaster Integration

```bash
# Initialize TaskMaster for project management
npx task-master-ai init --name="Red Hat Demo Environment" \
  --description="Comprehensive Red Hat ecosystem demo with AAP, Terraform, and OpenShift" \
  --version="0.1.0" \
  --yes

# Create initial PRD
cp .taskmaster/templates/example_prd.txt .taskmaster/docs/prd.txt
# Edit the PRD to match your project requirements

# Parse PRD to generate initial tasks
npx task-master-ai parse-prd .taskmaster/docs/prd.txt --num-tasks=15 --research
```

### Documentation Setup

```bash
# Create comprehensive README
cat > README.md << 'EOF'
# Red Hat Demo Environment

A comprehensive demonstration environment showcasing modern Red Hat ecosystem technologies including Ansible Automation Platform, Terraform, HashiCorp Vault, OpenShift, and Event Driven Ansible on AWS.

## Quick Start

1. Follow the [Setup Guide](SETUP_GUIDE.md) to configure your development environment
2. Review the [Architecture Documentation](docs/architecture/README.md)
3. Execute the validation scripts: `./scripts/validate-setup.sh`
4. Start with the demos in the [demos](docs/demos/) directory

## Technology Stack

- **Infrastructure**: Terraform, AWS
- **Automation**: Ansible Automation Platform, Event Driven Ansible
- **Templating**: Jinja2 (for dynamic configuration and playbooks)
- **Security**: HashiCorp Vault, Red Hat Advanced Cluster Security
- **Containers**: OpenShift, Podman
- **CI/CD**: GitHub Actions, Tekton Pipelines
- **Monitoring**: Prometheus, Grafana

## Project Management

This project uses TaskMaster AI for project management. View tasks with:
```bash
npx task-master-ai list
npx task-master-ai next
```

## Contributing

Please read our [Contributing Guidelines](CONTRIBUTING.md) before submitting pull requests.
EOF
```

## Verification and Testing

### Run Validation

```bash
# Execute the validation script
./scripts/validate-setup.sh

# Test Ansible connectivity
ansible localhost -m ping

# Test Terraform initialization
cd terraform/environments/dev && terraform init && cd -

# Test container operations
podman run --rm hello-world

# Test Jinja2 templating
echo "Testing Jinja2 templating..."
echo "Hello {{ name }}!" | j2 --name="Red Hat Demo" || echo "Using Python fallback"
python3 -c "from jinja2 import Template; print(Template('Hello {{ name }}!').render(name='Red Hat Demo'))"
```

### Environment Health Check

```bash
# Create health check script
cat > scripts/health-check.sh << 'EOF'
#!/bin/bash

echo "=== Environment Health Check ==="

# Check disk space
echo "Disk space:"
df -h

# Check memory
echo "Memory usage:"
free -h 2>/dev/null || vm_stat

# Check running services
echo "Container services:"
podman ps -a

# Check network connectivity
echo "Network connectivity:"
ping -c 3 google.com
aws sts get-caller-identity

echo "=== Health check complete ==="
EOF

chmod +x scripts/health-check.sh
./scripts/health-check.sh
```

## Next Steps

After completing this setup:

1. **Setup Red Hat Demo Integration**: Run `./scripts/setup-rh-demo-integration.sh` to integrate with the official Red Hat product demos
2. **Start Demo Development**: Navigate to `~/redhat-demo-workspace/product-demos` and open in Cursor IDE
3. **Explore Existing Demos**: Review demos in `linux/`, `windows/`, `cloud/`, `network/`, `openshift/`, and `satellite/` directories
4. **Create Your First AI-Assisted Demo**: Follow the AI-assisted workflow documentation
5. **Contribute Back**: Use the enhanced environment to create pull requests to the main Red Hat demos repository

### Red Hat Demo Development Workflow

```bash
# Quick start after setup
cd ~/redhat-demo-workspace/product-demos
cursor .

# Create a new demo with AI assistance
cd linux  # or appropriate category
mkdir my-custom-demo
cd my-custom-demo
cursor .
# Use Claude to generate demo content following Red Hat patterns

# Contribute back to the community
git checkout -b feature/my-custom-demo
git add .
git commit -m "Add enhanced demo with AI assistance"
git push fork feature/my-custom-demo
# Create PR via GitHub
```

## Troubleshooting

### Common Issues

**Terraform Provider Issues**:
```bash
terraform providers lock -platform=darwin_amd64 -platform=linux_amd64
```

**Ansible Collection Issues**:
```bash
ansible-galaxy collection install --force -r requirements.yml
```

**Container Permission Issues**:
```bash
# For Podman on macOS
podman machine stop
podman machine start
```

**AWS CLI Issues**:
```bash
aws configure list
aws sts get-caller-identity
```

### Getting Help

- Red Hat Customer Portal: https://access.redhat.com
- Ansible Documentation: https://docs.ansible.com
- Terraform Documentation: https://developer.hashicorp.com/terraform
- OpenShift Documentation: https://docs.openshift.com

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- Red Hat Community for excellent documentation and tools
- HashiCorp for robust infrastructure tools
- The open-source community for continuous innovation

---

## Summary

This setup guide provides an AI-enhanced development environment for working with the [Red Hat Product Demos repository](https://github.com/ansible/product-demos). The key value proposition is:

**Traditional Red Hat Demo Development:**
- Manual coding and testing
- Standard IDE experience
- Manual best practices enforcement

**AI-Enhanced Development with This Environment:**
- Cursor IDE + Claude for intelligent code generation
- Automated Red Hat standards compliance
- Real-time validation and suggestions
- Seamless integration with existing Red Hat workflows

### Key Benefits for Red Hat Teams

1. **Faster Demo Creation**: AI assistance accelerates development
2. **Higher Quality**: Automated validation ensures Red Hat standards
3. **Better Consistency**: AI learns from existing demo patterns
4. **Easier Contributions**: Streamlined workflow for contributing back
5. **Knowledge Transfer**: Modern development practices for the entire team

### Integration Points

- **Direct integration** with [rh-product-demos](https://github.com/ansible/product-demos)
- **Compatible** with [demo.redhat.com](https://demo.redhat.com) environments
- **Supports** existing Red Hat collection and automation hub workflows
- **Enhances** current contribution processes

---

**Setup completed on**: $(date)
**Environment version**: 2.0.0 (AI-Enhanced)
**Maintained by**: Red Hat Solutions Architecture Team  
**Integration with**: [Red Hat Product Demos](https://github.com/ansible/product-demos) 