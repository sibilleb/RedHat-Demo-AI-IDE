# Red Hat Demo Development Environment - AI-Assisted Automation with Cursor IDE

This repository provides a modern, AI-assisted development environment for creating and contributing to [Red Hat Product Demos](https://github.com/ansible/product-demos) using Cursor IDE, Claude AI, and agentic coding practices.

## 🎯 Project Overview

This development environment enhances the [official Red Hat product demos workflow](https://github.com/ansible/product-demos) by providing:

- **AI-Assisted Development**: Cursor IDE + Claude for intelligent code generation and review
- **Automated Best Practices**: MCP servers for real-time guidance and validation
- **Enhanced Productivity**: Streamlined workflows for demo creation and modification
- **Quality Assurance**: Automated linting, testing, and Red Hat standards compliance
- **Seamless Integration**: Direct workflow for contributing back to the main Red Hat demos repository

### 🔗 Integration with Red Hat Product Demos

This environment is designed to work **with** the [Red Hat Product Demos repository](https://github.com/ansible/product-demos), not replace it. Use this setup to:

1. **Fork and enhance** existing demos from the main repository
2. **Create new demos** using AI-assisted development practices  
3. **Contribute back** to the community repository with higher quality code
4. **Follow Red Hat standards** automatically through intelligent tooling

## 🏗️ Project Structure

```
ansible-dev-ide/
├── .cursor/                        # Cursor IDE configuration
│   ├── mcp.json                   # MCP servers configuration
│   └── rules/                     # Development rules and best practices
├── ansible/                       # Ansible automation content
│   ├── inventories/               # Environment-specific inventories
│   │   ├── dev/                   
│   │   ├── staging/               
│   │   └── prod/                  
│   ├── playbooks/                 # Ansible playbooks
│   │   ├── site.yml              # Main orchestration playbook
│   │   ├── aap-install.yml       # AAP installation
│   │   ├── openshift-deploy.yml  # OpenShift deployment
│   │   └── vault-setup.yml       # Vault configuration
│   ├── roles/                     # Ansible roles
│   │   ├── common/               # Common configuration
│   │   ├── aap/                  # Ansible Automation Platform
│   │   ├── openshift/            # OpenShift deployment
│   │   └── vault/                # HashiCorp Vault
│   ├── collections/               # Ansible collections
│   │   └── requirements.yml      # Collection dependencies
│   ├── group_vars/               # Group-specific variables
│   ├── host_vars/                # Host-specific variables
│   ├── ansible.cfg               # Ansible configuration
│   └── vault_pass.txt           # Vault password file (encrypted)
├── terraform/                     # Infrastructure as Code
│   ├── environments/              # Environment-specific configurations
│   │   ├── dev/                  
│   │   ├── staging/              
│   │   └── prod/                 
│   ├── modules/                   # Reusable Terraform modules
│   │   ├── vpc/                  # VPC module
│   │   ├── ec2/                  # EC2 instances
│   │   ├── rds/                  # Database instances
│   │   ├── eks/                  # EKS cluster (if needed)
│   │   └── vault/                # Vault infrastructure
│   ├── shared/                    # Shared resources
│   └── .terraform-version        # Terraform version constraint
├── eda/                          # Event-Driven Ansible
│   ├── rulebooks/                # EDA rulebooks
│   │   ├── infrastructure.yml    # Infrastructure events
│   │   ├── security.yml          # Security events
│   │   └── monitoring.yml        # Monitoring events
│   ├── decision-environments/    # Custom decision environments
│   └── execution-environments/   # Custom execution environments
├── vault/                        # HashiCorp Vault configuration
│   ├── policies/                 # Vault policies
│   ├── config/                   # Vault configuration files
│   └── scripts/                  # Vault setup scripts
├── openshift/                    # OpenShift manifests and configs
│   ├── operators/                # Operator configurations
│   ├── applications/             # Application deployments
│   ├── pipelines/                # Tekton pipelines
│   └── monitoring/               # Monitoring configurations
├── docs/                         # Documentation
│   ├── architecture/             # Architecture diagrams
│   ├── runbooks/                 # Operational runbooks
│   └── demos/                    # Demo scripts and guides
├── scripts/                      # Utility scripts
│   ├── setup/                    # Environment setup scripts
│   ├── deployment/               # Deployment automation
│   └── maintenance/              # Maintenance scripts
├── tests/                        # Testing configurations
│   ├── molecule/                 # Molecule testing for Ansible
│   ├── terraform/                # Terraform testing
│   └── integration/              # Integration tests
├── .github/                      # GitHub Actions workflows
│   └── workflows/                # CI/CD pipelines
├── .gitignore                    # Git ignore patterns
├── .pre-commit-config.yaml       # Pre-commit hooks
├── Makefile                      # Development automation
└── README.md                     # This file
```

## 🚀 Quick Start

### Prerequisites

- Follow the complete [Setup Guide](SETUP_GUIDE.md) for detailed environment configuration
- Access to [Red Hat Product Demos](https://github.com/ansible/product-demos) repository
- Red Hat Developer Account for registry access
- AWS CLI configured with appropriate credentials

### Enhanced Demo Development Workflow

1. **Setup the AI-assisted development environment:**
   ```bash
   # Follow the complete setup guide
   ./scripts/setup-enhanced-environment.sh
   ```

2. **Fork or work with Red Hat Product Demos:**
   ```bash
   # Clone the main Red Hat demos repository
   git clone https://github.com/ansible/product-demos.git product-demos
cd product-demos
   
   # Setup this enhanced environment for working with demos
   ln -s ../ansible-dev-ide/.cursor .cursor
   ln -s ../ansible-dev-ide/scripts scripts/enhanced
   ```

3. **Create or enhance a demo using AI assistance:**
   ```bash
   # Use Cursor IDE with Claude for intelligent development
   cursor product-demos/
   
   # Example: Enhance an existing demo
   # - Open existing demo in Cursor
   # - Use Claude for code suggestions and improvements
   # - Apply automated Red Hat best practices
   ```

4. **Contribute back to the main repository:**
   ```bash
   # Create feature branch
   git checkout -b feature/enhanced-demo-name
   
   # Commit improvements
   git add .
   git commit -m "Enhanced demo with AI-assisted improvements"
   
   # Push and create PR to main Red Hat demos repo
   git push origin feature/enhanced-demo-name
   ```

## 🛠️ AI-Enhanced Development Workflow

This environment enhances the standard Red Hat demo development process:

### Traditional Red Hat Demo Development
```
Edit demo → Manual testing → Submit PR → Review → Merge
```

### AI-Enhanced Development with This Environment
```
Edit with AI assistance → Automated validation → Enhanced testing → Intelligent PR → Review → Merge
```

#### Enhanced Workflow Steps:

1. **AI-Assisted Development:** Cursor + Claude provide intelligent code suggestions
2. **Real-time Validation:** MCP servers ensure Red Hat best practices compliance
3. **Automated Testing:** Enhanced testing with Molecule, Terratest, and custom validators
4. **Quality Gates:** Pre-commit hooks and automated code review
5. **Seamless Integration:** Direct workflow for contributing to [rh-product-demos](https://github.com/ansible/product-demos)

## 📋 Available Make Commands

```bash
make setup          # Initial project setup
make lint           # Run all linters (ansible-lint, tflint, etc.)
make test           # Run all tests
make deploy-dev     # Deploy to development environment
make deploy-staging # Deploy to staging environment
make deploy-prod    # Deploy to production environment
make clean          # Clean up temporary files
make docs           # Generate documentation
```

## 🔧 Technology Stack

- **Infrastructure:** Terraform, AWS, HashiCorp Vault
- **Automation:** Ansible Automation Platform, Event-Driven Ansible
- **Containers:** OpenShift, Podman, Docker
- **CI/CD:** GitHub Actions, Tekton Pipelines
- **Development:** Cursor IDE, Claude AI, MCP Servers
- **Testing:** Molecule, Terratest, pytest
- **Documentation:** Markdown, Draw.io

## 📚 Documentation

- [Architecture Overview](docs/architecture/README.md)
- [Deployment Guide](docs/runbooks/deployment.md)
- [Troubleshooting](docs/runbooks/troubleshooting.md)
- [Demo Scripts](docs/demos/README.md)

## 🤝 Contributing

Please read our [contributing guidelines](CONTRIBUTING.md) before submitting pull requests.

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🏷️ Tags

`ansible` `terraform` `openshift` `aws` `vault` `automation` `devops` `gitops` `infrastructure-as-code` `event-driven-ansible` 