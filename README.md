# Red Hat Demo AI Development Environment

**AI-Enhanced Red Hat Demo Development with Cursor IDE + Claude**

This repository provides an AI-assisted development environment for creating and enhancing [Red Hat Product Demos](https://github.com/ansible/product-demos) using modern tools like Cursor IDE, Claude AI, Ansible Automation Platform, Terraform, OpenShift, and Event Driven Ansible.

## 🚀 Quick Start (Recommended)

### Option 1: AI-Assisted Setup with Cursor (Easiest)

1. **Create your project directory:**
   ```bash
   mkdir my-redhat-demo-workspace
   cd my-redhat-demo-workspace
   cursor .
   ```

2. **Paste this prompt into Cursor chat:**
   ```
   I want to set up an AI-enhanced Red Hat demo development environment. Please:

   1. Clone the setup repository: https://github.com/sibilleb/RedHat-Demo-AI-IDE
   2. Clone the official Red Hat demos: https://github.com/ansible/product-demos  
   3. Set up the directory structure for AI-enhanced development
   4. Install required CLI tools (terraform, ansible, vault, aws-cli, oc, helm, podman)
   5. Configure Cursor with the proper rules and MCP servers
   6. Create a sample MCP configuration template
   7. Set up the integration between this enhanced environment and the Red Hat demos
   8. Provide me with next steps to start developing demos with AI assistance

   My operating system is: [macOS/Linux/Windows]
   I have access to: [AWS account yes/no] [Red Hat developer account yes/no]
   ```

3. **Follow Claude's guided setup** - it will walk you through the entire process automatically.

### Option 2: Manual Setup

If you prefer manual setup, follow the detailed [Setup Guide](SETUP_GUIDE.md).

## 🎯 What This Environment Provides

### Enhanced Red Hat Demo Development
- **AI-Assisted Coding**: Cursor IDE + Claude for intelligent code generation
- **Automated Best Practices**: Real-time Red Hat standards compliance
- **Streamlined Workflow**: Direct integration with [Red Hat Product Demos](https://github.com/ansible/product-demos)
- **Quality Assurance**: Automated linting, testing, and validation

### Technology Stack Integration
- **Infrastructure**: Terraform + AWS
- **Automation**: Ansible Automation Platform + Event Driven Ansible  
- **Containers**: OpenShift + Podman
- **Security**: HashiCorp Vault + Red Hat Advanced Cluster Security
- **Templating**: Jinja2 for dynamic configurations
- **AI Tools**: Cursor IDE + Claude + MCP Servers

## 🏗️ How It Works

```
Traditional Red Hat Demo Development:
Edit demo → Manual testing → Submit PR → Review → Merge

AI-Enhanced Development:
AI-assisted editing → Auto-validation → Enhanced testing → Intelligent PR → Review → Merge
```

### Integration with Official Red Hat Demos

This environment **enhances** the [Red Hat Product Demos repository](https://github.com/ansible/product-demos), it doesn't replace it:

1. **Fork/Clone** existing demos from the main repository
2. **Enhance** them using AI-assisted development  
3. **Validate** automatically with Red Hat best practices
4. **Contribute back** to the community repository

## 📁 Project Structure After Setup

```
my-redhat-demo-workspace/
├── RedHat-Demo-AI-IDE/           # This setup repository
│   ├── .cursor/                  # Cursor IDE configuration
│   │   ├── rules/               # Red Hat development rules
│   │   └── mcp.json.template    # MCP server template
│   ├── scripts/                 # Setup and automation scripts
│   └── docs/                    # Documentation and guides
├── product-demos/                # Official Red Hat demos repository
│   ├── linux/                  # RHEL automation demos
│   ├── windows/                 # Windows Server demos
│   ├── cloud/                   # Infrastructure demos
│   ├── network/                 # Network automation
│   ├── openshift/               # OpenShift demos
│   └── satellite/               # Satellite demos
└── .cursor -> RedHat-Demo-AI-IDE/.cursor  # Symlink for IDE config
```

## 🔧 Available Commands (After Setup)

```bash
# Project management with TaskMaster AI
task-master list              # View current tasks
task-master next              # Find next task to work on
task-master add-task          # Add new development tasks

# Development workflow
make setup                    # Initial environment setup
make lint                     # Run all linters
make test                     # Execute tests
make deploy-dev              # Deploy to development environment

# Red Hat demo specific
./scripts/validate-rh-demo.sh    # Validate demo compliance
./scripts/enhance-demo.sh         # AI-enhance existing demo
./scripts/create-demo.sh          # Create new demo from template
```

## 📋 Prerequisites

- **System**: macOS, Linux, or Windows with WSL2 (16GB+ RAM recommended)
- **Access**: Red Hat Developer Account, AWS Account (optional), GitHub Account
- **Tools**: Git, Cursor IDE (or VS Code), Terminal access

## 🤝 Contributing to Red Hat Demos

### Enhanced Contribution Workflow

1. **Setup** this AI-enhanced environment (using the Cursor prompt above)
2. **Navigate** to the product-demos directory
3. **Create/Enhance** demos using AI assistance
4. **Validate** automatically with built-in quality checks
5. **Submit** improved demos back to the main repository

### Example: Enhancing an Existing Demo

```bash
# Navigate to demos and open in Cursor
cd product-demos/linux/existing-demo
cursor .

# Ask Claude to enhance the demo
# "Please review this demo and suggest improvements following Red Hat best practices"

# Validate changes
../../RedHat-Demo-AI-IDE/scripts/validate-rh-demo.sh

# Submit PR with enhancements
git checkout -b enhance/existing-demo
git commit -m "AI-enhanced demo with improved practices"
git push origin enhance/existing-demo
```

## 📚 Documentation

- **[Complete Setup Guide](SETUP_GUIDE.md)** - Detailed manual setup instructions
- **[Development Workflow](docs/DEVELOPMENT_WORKFLOW.md)** - AI-assisted development patterns
- **[Contributing Guidelines](CONTRIBUTING.md)** - How to contribute to Red Hat demos
- **[Troubleshooting](docs/TROUBLESHOOTING.md)** - Common issues and solutions

## 🆘 Getting Help

### For Environment Setup Issues
- Review the [Setup Guide](SETUP_GUIDE.md)
- Check [Troubleshooting](docs/TROUBLESHOOTING.md)
- Ask Claude in Cursor chat for assistance

### For Red Hat Demo Development
- [Red Hat Product Demos Documentation](https://github.com/ansible/product-demos)
- [Red Hat Customer Portal](https://access.redhat.com)
- [Ansible Documentation](https://docs.ansible.com)

## 🏷️ Tags

`ansible` `terraform` `openshift` `aws` `vault` `automation` `ai-assisted` `cursor-ide` `red-hat` `demos`

---

**Ready to start?** Create a directory, open it in Cursor, and paste the setup prompt above! 🚀 