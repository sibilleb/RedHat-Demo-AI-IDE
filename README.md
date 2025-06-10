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

   1. Help me fork these repositories on GitHub (I'll do this manually):
      - Fork https://github.com/sibilleb/RedHat-Demo-AI-IDE to my account
      - Fork https://github.com/ansible/product-demos to my account
   
   2. Clone MY FORKED versions (replace YOUR-USERNAME with my GitHub username):
      - Clone https://github.com/YOUR-USERNAME/RedHat-Demo-AI-IDE
      - Clone https://github.com/YOUR-USERNAME/product-demos
   
   3. Set up proper git remotes:
      - origin: points to my forks (for pushing changes)
      - upstream: points to official repos (for pulling updates)
   
   4. Set up the directory structure for AI-enhanced development
   5. Install required CLI tools (terraform, ansible, vault, aws-cli, oc, helm, podman)
   6. Configure Cursor with the proper rules and MCP servers
   7. Create a sample MCP configuration template
   8. Set up the integration between this enhanced environment and the Red Hat demos
   9. Provide me with next steps to start developing demos with AI assistance

   My operating system is: [macOS/Linux/Windows]
   My GitHub username is: [YOUR-USERNAME]
   I have access to: [AWS account yes/no] [Red Hat developer account yes/no]
   ```

3. **Follow Claude's guided setup** - it will walk you through the entire process automatically.

### Option 2: Manual Setup

1. **Fork both repositories on GitHub:**
   - Fork https://github.com/sibilleb/RedHat-Demo-AI-IDE to your account
   - Fork https://github.com/ansible/product-demos to your account

2. **Clone your forked repositories:**
   ```bash
   # Replace YOUR-USERNAME with your GitHub username
   git clone https://github.com/YOUR-USERNAME/RedHat-Demo-AI-IDE.git
   cd RedHat-Demo-AI-IDE
   
   # Set up upstream remote for pulling updates
   git remote add upstream https://github.com/sibilleb/RedHat-Demo-AI-IDE.git
   ```

3. **Follow the detailed [Setup Guide](SETUP_GUIDE.md)** for manual installation steps.

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
# Navigate to YOUR FORKED demos and open in Cursor
cd product-demos/linux/existing-demo
cursor .

# Ask Claude to enhance the demo
# "Please review this demo and suggest improvements following Red Hat best practices"

# Validate changes
../../RedHat-Demo-AI-IDE/scripts/validate-rh-demo.sh

# Create branch and commit to YOUR FORK
git checkout -b enhance/existing-demo
git add .
git commit -m "AI-enhanced demo with improved practices"
git push origin enhance/existing-demo

# Create PR from YOUR FORK to the OFFICIAL repository
# GitHub will prompt you to create a PR from your fork to ansible/product-demos
```

### Proper Git Workflow for Red Hat Demos

```bash
# 1. Make sure you're working with your fork
cd product-demos
git remote -v
# Should show:
# origin    https://github.com/YOUR-USERNAME/product-demos.git (your fork)
# upstream  https://github.com/ansible/product-demos.git (official)

# 2. Always pull latest changes from upstream before starting work
git fetch upstream
git checkout main
git merge upstream/main
git push origin main  # Update your fork

# 3. Create feature branch for your work
git checkout -b feature/my-awesome-demo

# 4. Develop with AI assistance in Cursor
# ... make changes ...

# 5. Push to YOUR FORK (origin)
git add .
git commit -m "Add awesome new demo with AI enhancements"
git push origin feature/my-awesome-demo

# 6. Create PR on GitHub from your fork to official repository
# Visit: https://github.com/ansible/product-demos
# GitHub will show a banner to create PR from your recently pushed branch
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