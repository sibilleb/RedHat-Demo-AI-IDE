# Cursor Setup Prompt for Red Hat Demo AI Development Environment

Copy and paste this prompt into Cursor chat after creating your workspace directory:

---

## Setup Prompt for Cursor

```
I want to set up an AI-enhanced Red Hat demo development environment using the GitHub repository: https://github.com/sibilleb/RedHat-Demo-AI-IDE

**IMPORTANT**: I need to work with FORKED versions of repositories, not the originals, for proper contribution workflow.

Please help me:

1. **First, guide me through forking repositories on GitHub** (I'll do this step manually):
   - Fork https://github.com/sibilleb/RedHat-Demo-AI-IDE to my account
   - Fork https://github.com/ansible/product-demos to my account

2. **Clone MY FORKED repositories** (replace YOUR-USERNAME with my actual GitHub username):
   - Clone https://github.com/YOUR-USERNAME/RedHat-Demo-AI-IDE (the setup repo)
   - Clone https://github.com/YOUR-USERNAME/product-demos (my forked Red Hat demos)

3. **Set up proper git remotes for contribution workflow:**
   - origin: points to my forks (where I push changes)
   - upstream: points to original repos (where I pull updates)

2. **Install required CLI tools for my operating system:**
   - Terraform, Ansible, HashiCorp Vault
   - AWS CLI, kubectl, Helm, OpenShift CLI (oc)
   - Podman, jq, yq, tree
   - ansible-lint, molecule, yamllint
   - Jinja2 and templating tools (jinja2-cli, j2cli)
   - pre-commit, shellcheck, hadolint

3. **Set up the development environment:**
   - Create proper symlinks between repos for Cursor configuration
   - Copy MCP configuration template
   - Set up pre-commit hooks
   - Create helper scripts for development workflow

4. **Configure Cursor IDE integration:**
   - Link the .cursor configuration from RedHat-Demo-AI-IDE
   - Explain how to configure MCP servers with API keys
   - Set up the development workflow

5. **Create validation and startup scripts:**
   - Environment validation script
   - Demo development startup script
   - Integration testing script

6. **Provide next steps:**
   - How to configure API keys in MCP
   - How to start developing Red Hat demos with AI assistance
   - How to contribute back to the official Red Hat demos repository

**My system information:**
- Operating system: [macOS/Linux/Windows - please specify]
- GitHub username: [YOUR-USERNAME - replace with actual username]
- I have access to: [AWS account yes/no] [Red Hat developer account yes/no] [GitHub account yes/no]
- Preferred package manager: [homebrew/apt/other - will be auto-detected]

**IMPORTANT WORKFLOW NOTE**: 
When I develop demos, I will:
- Work in my forked repositories only
- Push changes to my forks (origin remote)
- Create pull requests from my forks to official repositories
- Never push directly to the official Red Hat repositories

Please execute the setup step by step and let me know what manual steps I need to complete afterward.
```

---

## After Setup Completion

Once Cursor completes the setup, you'll need to manually:

1. **Configure API keys** in `.cursor/mcp.json`:
   - Add your `ANTHROPIC_API_KEY` for Claude
   - Add your `GITHUB_PERSONAL_ACCESS_TOKEN`
   - Add additional AI provider keys as needed

2. **Test the environment:**
   ```bash
   ./validate-environment.sh
   ```

3. **Start developing:**
   ```bash
   ./start-demo-development.sh
   ```

## Expected Directory Structure After Setup

```
your-workspace/
├── RedHat-Demo-AI-IDE/           # Setup repository with tools
├── product-demos/                # Official Red Hat demos
├── .cursor/                      # Symlinked Cursor configuration
├── start-demo-development.sh     # Quick start script
├── validate-environment.sh       # Environment validation
└── .pre-commit-config.yaml      # Quality assurance hooks
```

## Quick Start Commands After Setup

```bash
# Validate everything is working
./validate-environment.sh

# Start developing demos
cd product-demos
cursor .

# Create a new demo with AI assistance
# Ask Claude: "Help me create a new RHEL automation demo following Red Hat best practices"
``` 