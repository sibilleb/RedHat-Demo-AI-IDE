# Cursor Setup Prompts for Red Hat Demo AI Development Environment

This document contains the specific prompts to use in each phase of the setup process. Use these in order after completing the prerequisites.

---

## Prerequisites (Complete These First!)

### ✅ Accounts & API Keys Ready
- **GitHub Account** with both repositories forked
- **Anthropic API Key** for Claude AI ([get one here](https://console.anthropic.com))
- **GitHub Personal Access Token** (optional but recommended)
- **Cursor IDE** installed from [cursor.sh](https://cursor.sh)

### ✅ System Preparation
- **Command execution enabled** in Cursor settings
- **Claude 3.5 Sonnet** selected as your model (recommended)
- **Terminal access** available

---

## Phase 2 Prompt: Initial Repository Setup

**Use this after forking both repositories on GitHub:**

```
I want to set up my Red Hat demo development environment. I have already forked both repositories to my GitHub account.

My GitHub username is: [REPLACE-WITH-YOUR-ACTUAL-USERNAME]

Please help me:

1. Clone my forked repositories:
   - https://github.com/[YOUR-USERNAME]/RedHat-Demo-AI-IDE  
   - https://github.com/[YOUR-USERNAME]/product-demos

2. Set up proper git remotes:
   - origin: my forks (for pushing changes)
   - upstream: original repos (for pulling updates)

3. Create the basic directory structure and symlinks between repositories

4. Show me what manual steps I need to complete next

Please run the necessary git clone and setup commands for me.
```

---

## Phase 3 Prompt: Complete Environment Setup

**Use this after Phase 2 completes successfully:**

```
Now I need to complete the full development environment setup. Please reference the SETUP_GUIDE.md file in the RedHat-Demo-AI-IDE repository and help me:

1. Install all required CLI tools for my operating system:
   - Terraform, Ansible, HashiCorp Vault
   - AWS CLI, kubectl, Helm, OpenShift CLI (oc)  
   - Podman, jq, yq, tree, and development tools
   - Python packages: ansible-lint, molecule, yamllint, jinja2

2. Configure Cursor IDE integration:
   - Set up the .cursor configuration symlink
   - Copy and configure the MCP server template
   - Install recommended Cursor extensions if possible

3. Set up development workflow tools:
   - Pre-commit hooks for code quality
   - Validation scripts
   - Helper scripts for demo development

4. Guide me through the final manual configuration steps

My operating system is: [macOS/Linux/Windows - specify your OS]
I have access to: [AWS account yes/no] [Red Hat developer account yes/no]

Please install everything automatically using my system's package manager and let me know what I need to configure manually afterward.
```

---

## Phase 5 Prompt: Start Red Hat Demo Development

**Use this after completing API key configuration in Phase 4:**

```
I've completed the Red Hat demo environment setup. Now I want to start developing Red Hat demos with AI assistance. 

Please:
1. Explain the Red Hat demo repository structure in the product-demos directory
2. Show me how to create a new demo following Red Hat best practices  
3. Set up the development workflow for contributing back to the official repository
4. Guide me through creating my first AI-enhanced demo

I'm ready to start developing Red Hat automation demos!
```

---

## Alternative Prompts for Specific Tasks

### If You Want to Enhance an Existing Demo:

```
I want to enhance an existing Red Hat demo with AI assistance. Please:

1. Help me navigate the product-demos repository structure
2. Select an appropriate demo to enhance
3. Review the current demo and suggest improvements following Red Hat best practices
4. Guide me through implementing the enhancements
5. Show me how to validate and test the improvements
6. Help me create a proper pull request to contribute back

I'm particularly interested in: [linux/windows/cloud/network/openshift/satellite demos]
```

### If You Want to Create a Brand New Demo:

```
I want to create a completely new Red Hat demo from scratch. Please:

1. Help me understand the Red Hat demo standards and structure
2. Guide me through planning the demo (technology stack, use case, audience)
3. Set up the proper directory structure and files
4. Help me create the Ansible playbooks following Red Hat best practices
5. Generate appropriate documentation and README files
6. Set up testing and validation

The demo I want to create is about: [DESCRIBE YOUR DEMO IDEA]
Target audience: [beginner/intermediate/advanced]
Technology focus: [RHEL/OpenShift/Ansible/Satellite/etc.]
```

### If You Need to Troubleshoot Setup Issues:

```
I'm having issues with my Red Hat demo environment setup. Please:

1. Run diagnostic commands to check my environment
2. Identify what's missing or misconfigured
3. Help me fix any installation or configuration problems
4. Validate that everything is working properly
5. Show me how to test the environment

The specific issue I'm experiencing is: [DESCRIBE YOUR PROBLEM]
```

---

## Manual Configuration Steps (Phase 4)

After running the Phase 3 prompt, you'll need to manually configure API keys:

### 1. Open MCP Configuration
```bash
# Navigate to your workspace
cd my-redhat-demo-workspace
cursor .cursor/mcp.json
```

### 2. Add Your API Keys
Replace the placeholder values:
```json
{
  "mcpServers": {
    "taskmaster-ai": {
      "command": "npx",
      "args": ["-y", "task-master-ai", "mcp"],
      "env": {
        "ANTHROPIC_API_KEY": "your-actual-anthropic-key-here"
      }
    },
    "github": {
      "command": "npx", 
      "args": ["-y", "@modelcontextprotocol/server-github"],
      "env": {
        "GITHUB_PERSONAL_ACCESS_TOKEN": "your-github-token-here"
      }
    }
  }
}
```

### 3. Test Your Setup
```bash
./validate-environment.sh
```

---

## Expected Directory Structure After Setup

```
my-redhat-demo-workspace/
├── RedHat-Demo-AI-IDE/           # Your forked setup repository
│   ├── .cursor/                  # Cursor IDE configuration
│   ├── scripts/                  # Setup and automation scripts
│   └── SETUP_GUIDE.md           # Detailed manual setup guide
├── product-demos/                # Your forked Red Hat demos
│   ├── linux/                   # RHEL automation demos
│   ├── windows/                  # Windows Server demos
│   ├── cloud/                    # Infrastructure demos
│   └── ...                      # Other demo categories
├── .cursor -> RedHat-Demo-AI-IDE/.cursor  # Symlink for IDE config
├── validate-environment.sh       # Environment validation script
└── start-demo-development.sh     # Quick start script
```

---

## Important Notes

### ⚠️ Security Warnings
- **Never commit `.cursor/mcp.json`** - it contains your API keys
- **Only push to your forks** - never directly to official repositories
- **Create pull requests** from your fork to contribute back

### 🎯 Model Recommendations  
- **Claude 3.5 Sonnet** - Best for complex setup and development tasks
- **GPT-4** - Alternative if you prefer OpenAI models
- **Local models** - Possible with Ollama but not recommended for initial setup

### 🔧 Command Execution
- **Enable "Allow AI to run terminal commands"** in Cursor settings
- **Review commands** before they execute if you're cautious
- **Stop execution** at any time using Ctrl+C in the terminal

### 🆘 Getting Help
- **Reference SETUP_GUIDE.md** for detailed manual instructions
- **Ask follow-up questions** to Claude if any step fails
- **Check the troubleshooting section** in the main repository 