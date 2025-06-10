# Red Hat Demo AI Development Environment

**AI-Enhanced Red Hat Demo Development with Cursor IDE + Claude**

This repository provides an AI-assisted development environment for creating and enhancing [Red Hat Product Demos](https://github.com/ansible/product-demos) using modern tools like Cursor IDE, Claude AI, Ansible Automation Platform, Terraform, OpenShift, and Event Driven Ansible.

## ⚠️ **CRITICAL: Read Before Starting**

### 🔑 **MANDATORY Prerequisites Checklist**

**The setup WILL FAIL without these credentials. Prepare them first:**

| **Status** | **Required Item** | **Where to Get** | **Purpose** |
|------------|------------------|------------------|-------------|
| ✅ **MANDATORY** | GitHub Username | Your GitHub account | Repository forking/cloning |
| ✅ **MANDATORY** | GitHub Personal Access Token | [GitHub Settings → Tokens](https://github.com/settings/tokens) | MCP GitHub integration |
| ✅ **MANDATORY** | AWS Access Key + Secret | [AWS Console → IAM](https://console.aws.amazon.com/iam/) | All AWS MCP servers |
| ⚠️ **Recommended** | Anthropic API Key | [Anthropic Console](https://console.anthropic.com/) | Claude AI in Cursor |

### 💻 **System Requirements**
- **OS**: macOS, Linux, or Windows WSL2
- **RAM**: 16GB minimum (32GB recommended) 
- **Storage**: 50GB available space

📖 **[→ Complete Prerequisites Guide](SETUP_GUIDE.md#⚠️-important-complete-prerequisites-checklist)**

---

## 🚀 Quick Start Guide

---

## 🔄 Step-by-Step Setup Process

### Phase 1: Fork the Repositories (Manual)

**⚠️ Important: You MUST fork first to contribute properly!**

1. **Go to GitHub and fork these repositories:**
   - Visit https://github.com/sibilleb/RedHat-Demo-AI-IDE
   - Click "Fork" in the top right
   - Visit https://github.com/ansible/product-demos  
   - Click "Fork" in the top right

2. **Note your GitHub username** - you'll need it in the next steps

### Phase 2: Initial Setup (AI-Assisted)

1. **Create your workspace:**
   ```bash
   mkdir my-redhat-demo-workspace
   cd my-redhat-demo-workspace
   cursor .
   ```

2. **In Cursor, enable command execution:**
   - Go to Settings (Cmd/Ctrl + ,)
   - Search for "terminal" 
   - Enable "Allow AI to run terminal commands"
   - ⚠️ **This allows Claude to install tools and run setup commands for you**

3. **Select your AI model:**
   - Click the model selector in Cursor
   - Choose **Claude 3.5 Sonnet** (recommended) or your preferred model
   - This will be used for the automated setup

4. **Paste this setup prompt:**
   ```
   I want to set up my Red Hat demo development environment. I have already forked both repositories to my GitHub account.

   My GitHub username is: [REPLACE-WITH-YOUR-USERNAME]

   Please help me:

   1. Clone my forked repositories:
      - https://github.com/[YOUR-USERNAME]/RedHat-Demo-AI-IDE  
      - https://github.com/[YOUR-USERNAME]/product-demos

   2. Set up proper git remotes:
      - origin: my forks (for pushing changes)
      - upstream: original repos (for pulling updates)

   3. Create the basic directory structure and symlinks

   4. Show me what manual steps I need to complete next

   Please run the necessary git clone and setup commands for me.
   ```

### Phase 3: Complete Environment Setup (AI-Assisted)

After Phase 2 completes, paste this prompt:

```
Now I need to complete the full development environment setup. Please reference the SETUP_GUIDE.md file in the RedHat-Demo-AI-IDE repository and help me:

1. Install all required CLI tools for my operating system:
   - Terraform, Ansible, HashiCorp Vault
   - AWS CLI, kubectl, Helm, OpenShift CLI (oc)  
   - Podman, jq, yq, tree, and development tools
   - Python packages: ansible-lint, molecule, yamllint, jinja2

2. Configure Cursor IDE integration:
   - Set up the .cursor configuration symlink
   - Copy and configure the comprehensive MCP server template (10 servers)
  - See [MCP_SERVERS.md](./docs/MCP_SERVERS.md) for detailed server information
   - Install recommended Cursor extensions

3. Set up development workflow tools:
   - Pre-commit hooks for code quality
   - Validation scripts
   - Helper scripts for demo development

4. Guide me through the final manual configuration steps

My operating system is: [macOS/Linux/Windows]
I have access to: [AWS account yes/no] [Red Hat developer account yes/no]

Please install everything automatically using my system's package manager and let me know what I need to configure manually afterward.
```

### Phase 4: API Key Configuration (Manual)

1. **Open the MCP configuration file:**
   ```bash
   # This file was created in Phase 3
   cursor .cursor/mcp.json
   ```

2. **Add your API keys:**
   ```json
   {
     "mcpServers": {
       "taskmaster-ai": {
         "env": {
           "ANTHROPIC_API_KEY": "your-actual-anthropic-key-here"
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

3. **Test your setup:**
   ```bash
   ./validate-environment.sh
   ```

### Phase 5: Start Developing (AI-Assisted)

```bash
cd product-demos
cursor .
```

**Final setup prompt:**
```
I've completed the Red Hat demo environment setup. Now I want to start developing Red Hat demos with AI assistance. 

Please:
1. Explain the Red Hat demo repository structure
2. Show me how to create a new demo following Red Hat best practices  
3. Set up the development workflow for contributing back to the official repository
4. Guide me through creating my first AI-enhanced demo

I'm ready to start developing Red Hat automation demos!
```

---

## ⚡ Alternative: Manual Setup

If you prefer manual setup without AI assistance:

1. **Fork both repositories** (same as Phase 1 above)
2. **Follow the detailed [Setup Guide](SETUP_GUIDE.md)** step by step
3. **Manual installation** of all tools and configuration

---

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
- **AI Tools**: Cursor IDE + Claude + 10 Essential MCP Servers (Ansible, AWS, Terraform, K8s, etc.)

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
├── RedHat-Demo-AI-IDE/           # This setup repository (your fork)
│   ├── .cursor/                  # Cursor IDE configuration
│   │   ├── rules/               # Red Hat development rules
│   │   └── mcp.json.template    # MCP server template
│   ├── scripts/                 # Setup and automation scripts
│   └── docs/                    # Documentation and guides
├── product-demos/                # Red Hat demos repository (your fork)
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

## 🤝 Contributing to Red Hat Demos

### Enhanced Contribution Workflow

1. **Setup** this AI-enhanced environment (using the phases above)
2. **Navigate** to the product-demos directory
3. **Create/Enhance** demos using AI assistance
4. **Validate** automatically with built-in quality checks
5. **Submit** improved demos back to the main repository

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
- **[MCP Servers Guide](docs/MCP_SERVERS.md)** - Comprehensive 11-server MCP configuration
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

**Ready to start?** Begin with Phase 1 above - fork the repositories, then follow each phase in order! 🚀 