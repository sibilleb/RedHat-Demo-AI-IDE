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

## 🚀 Installation Options

### Option 1: One-Click Automated Setup (Recommended)

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

**What happens during setup:**
- **Interactive Tool Installation**: You'll be asked if you want to install development tools
- **Smart Detection**: Tools already installed on your system are automatically skipped
- **Your Choice**: Choose between interactive mode (ask for each tool) or install all tools
- **Respects Your Environment**: Won't interfere with existing Python, Node.js, or other setups
- **Virtual Environment Support**: Automatically handles externally-managed Python environments (Homebrew, system Python)
- **Includes Cursor IDE**: Automatically installs and configures Cursor IDE for AI-assisted development

**Installation modes available:**
1. **Interactive** (Recommended): Ask permission for each tool individually
2. **Install All**: Install all tools without prompts (`--yes` flag)
3. **Skip Tools**: Skip tool installation entirely (`--skip-tools` flag)

For detailed information about what the one-click setup does, see the [Setup Guide](SETUP_GUIDE.md#🚀-option-1-one-click-automated-setup-recommended).

### Option 2: Manual Setup

If you prefer to understand each step or need more control over the setup process, follow our [Manual Setup Guide](SETUP_GUIDE.md#📖-option-2-manual-setup-educational).

**Manual tool installation options:**
```bash
# Interactive installation (ask for each tool)
./scripts/install-tools.sh

# Install all tools without prompts
./scripts/install-tools.sh --yes

# Force reinstall even if tools exist
./scripts/install-tools.sh --force

# Get help and see all options
./scripts/install-tools.sh --help
```

## 📁 Project Structure

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

## 🤝 Contributing to Red Hat Demos

### Enhanced Contribution Workflow

1. **Setup** this AI-enhanced environment (using one of the installation options above)
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
```

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- **Red Hat Community** for excellent documentation and tools
- **HashiCorp** for robust infrastructure tools
- **Ansible Community** for automation excellence
- **Open Source Community** for continuous innovation