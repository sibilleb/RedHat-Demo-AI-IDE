#!/bin/bash

# Red Hat Demo Environment Validation Script
# Validates tools, API keys, and configuration

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m' # No Color

# Counters
CHECKS_PASSED=0
CHECKS_FAILED=0
CHECKS_WARNED=0

print_header() {
    echo -e \"${PURPLE}🔍 Red Hat Demo Environment Validation${NC}\"
    echo -e \"${PURPLE}=======================================${NC}\"
    echo \"\"
}

print_section() {
    echo -e \"${BLUE}📋 $1${NC}\"
    echo -e \"${BLUE}$(printf '%.0s─' {1..50})${NC}\"
}

check_pass() {
    echo -e \"${GREEN}✅ $1${NC}\"
    ((CHECKS_PASSED++))
}

check_fail() {
    echo -e \"${RED}❌ $1${NC}\"
    ((CHECKS_FAILED++))
}

check_warn() {
    echo -e \"${YELLOW}⚠️  $1${NC}\"
    ((CHECKS_WARNED++))
}

check_info() {
    echo -e \"${CYAN}ℹ️  $1${NC}\"
}

# Check if command exists
command_exists() {
    command -v \"$1\" >/dev/null 2>&1
}

# Check API key in MCP configuration
check_mcp_api_key() {
    local service=\"$1\"
    local key_name=\"$2\"
    
    if [[ -f \".cursor/mcp.json\" ]]; then
        if grep -q \"$key_name\" \".cursor/mcp.json\" && ! grep -q \"YOUR_.*_HERE\" \".cursor/mcp.json\"; then
            check_pass \"$service API key configured\"
            return 0
        else
            check_fail \"$service API key missing or contains placeholder\"
            return 1
        fi
    else
        check_fail \"MCP configuration file not found\"
        return 1
    fi
}

print_header

# Check 1: Core Development Tools
print_section \"Core Development Tools\"

if command_exists git; then
    GIT_VERSION=\$(git --version)
    check_pass \"Git: \$GIT_VERSION\"
else
    check_fail \"Git not installed\"
fi

if command_exists python3; then
    PYTHON_VERSION=\$(python3 --version)
    check_pass \"Python: \$PYTHON_VERSION\"
else
    check_fail \"Python 3 not installed\"
fi

if command_exists node; then
    NODE_VERSION=\$(node --version)
    check_pass \"Node.js: \$NODE_VERSION\"
else
    check_fail \"Node.js not installed\"
fi

if command_exists curl; then
    check_pass \"curl available\"
else
    check_fail \"curl not installed\"
fi

echo \"\"

# Check 2: Infrastructure Tools
print_section \"Infrastructure & Automation Tools\"

if command_exists terraform; then
    TERRAFORM_VERSION=\$(terraform version | head -n1)
    check_pass \"Terraform: \$TERRAFORM_VERSION\"
else
    check_fail \"Terraform not installed\"
fi

if command_exists ansible; then
    ANSIBLE_VERSION=\$(ansible --version | head -n1)
    check_pass \"Ansible: \$ANSIBLE_VERSION\"
else
    check_fail \"Ansible not installed\"
fi

if command_exists vault; then
    VAULT_VERSION=\$(vault version | head -n1)
    check_pass \"Vault: \$VAULT_VERSION\"
else
    check_warn \"HashiCorp Vault not installed (optional)\"
fi

if command_exists aws; then
    AWS_VERSION=\$(aws --version 2>&1)
    check_pass \"AWS CLI: \$AWS_VERSION\"
else
    check_fail \"AWS CLI not installed\"
fi

echo \"\"

# Check 3: Container & Kubernetes Tools
print_section \"Container & Kubernetes Tools\"

if command_exists kubectl; then
    KUBECTL_VERSION=\$(kubectl version --client --short 2>/dev/null || echo \"kubectl client\")
    check_pass \"kubectl: \$KUBECTL_VERSION\"
else
    check_warn \"kubectl not installed (optional for Kubernetes demos)\"
fi

if command_exists oc; then
    OC_VERSION=\$(oc version --client 2>/dev/null | head -n1 || echo \"OpenShift CLI\")
    check_pass \"OpenShift CLI: \$OC_VERSION\"
else
    check_warn \"OpenShift CLI not installed (optional for OpenShift demos)\"
fi

if command_exists podman; then
    PODMAN_VERSION=\$(podman --version)
    check_pass \"Podman: \$PODMAN_VERSION\"
elif command_exists docker; then
    DOCKER_VERSION=\$(docker --version)
    check_pass \"Docker: \$DOCKER_VERSION\"
else
    check_warn \"No container engine (Podman/Docker) found\"
fi

if command_exists helm; then
    HELM_VERSION=\$(helm version --short)
    check_pass \"Helm: \$HELM_VERSION\"
else
    check_warn \"Helm not installed (optional for Kubernetes demos)\"
fi

echo \"\"

# Check 4: Development Quality Tools
print_section \"Development & Quality Tools\"

if command_exists pre-commit; then
    check_pass \"pre-commit hooks available\"
else
    check_warn \"pre-commit not installed\"
fi

if command_exists ansible-lint; then
    check_pass \"ansible-lint available\"
else
    check_warn \"ansible-lint not installed\"
fi

if command_exists yamllint; then
    check_pass \"yamllint available\"
else
    check_warn \"yamllint not installed\"
fi

if command_exists jq; then
    check_pass \"jq JSON processor available\"
else
    check_warn \"jq not installed\"
fi

if command_exists shellcheck; then
    check_pass \"shellcheck available\"
else
    check_warn \"shellcheck not installed\"
fi

echo \"\"

# Check 5: Repository Configuration
print_section \"Repository Configuration\"

if [[ -d \".git\" ]]; then
    check_pass \"Git repository initialized\"
    
    # Check remotes
    if git remote -v | grep -q \"origin\"; then
        ORIGIN_URL=\$(git remote get-url origin)
        check_pass \"Origin remote configured: \$ORIGIN_URL\"
    else
        check_fail \"Origin remote not configured\"
    fi
    
    if git remote -v | grep -q \"upstream\"; then
        UPSTREAM_URL=\$(git remote get-url upstream)
        check_pass \"Upstream remote configured: \$UPSTREAM_URL\"
    else
        check_warn \"Upstream remote not configured\"
    fi
else
    check_fail \"Not in a git repository\"
fi

# Check workspace structure
if [[ -d \".cursor\" ]]; then
    check_pass \"Cursor configuration directory exists\"
else
    check_fail \"Cursor configuration not found\"
fi

if [[ -f \".editorconfig\" ]]; then
    check_pass \"Editor configuration file exists\"
else
    check_warn \"Editor configuration not found\"
fi

if [[ -f \".pre-commit-config.yaml\" ]]; then
    check_pass \"Pre-commit configuration exists\"
else
    check_warn \"Pre-commit configuration not found\"
fi

echo \"\"

# Check 6: MCP Configuration
print_section \"MCP Server Configuration\"

if [[ -f \".cursor/mcp.json\" ]]; then
    check_pass \"MCP configuration file exists\"
    
    # Check for placeholder values
    if grep -q \"YOUR_.*_HERE\" \".cursor/mcp.json\"; then
        check_fail \"MCP configuration contains placeholder values - API keys not configured\"
        check_info \"Edit .cursor/mcp.json and replace placeholders with actual API keys\"
    else
        check_pass \"MCP configuration appears to have real API keys\"
    fi
    
    # Count configured servers
    SERVER_COUNT=\$(jq '.mcpServers | length' \".cursor/mcp.json\" 2>/dev/null || echo \"0\")
    check_pass \"MCP servers configured: \$SERVER_COUNT\"
    
else
    check_fail \"MCP configuration file not found\"
    check_info \"Copy .cursor/mcp.json.template to .cursor/mcp.json and configure API keys\"
fi

echo \"\"

# Check 7: API Key Validation (basic checks)
print_section \"API Key Validation\"

if [[ -f \".cursor/mcp.json\" ]]; then
    # GitHub Personal Access Token
    if grep -q \"GITHUB_PERSONAL_ACCESS_TOKEN\" \".cursor/mcp.json\" && ! grep -q \"YOUR_GITHUB_PERSONAL_ACCESS_TOKEN_HERE\" \".cursor/mcp.json\"; then
        check_pass \"GitHub Personal Access Token configured\"
    else
        check_fail \"GitHub Personal Access Token not configured\"
    fi
    
    # AWS credentials
    if grep -q \"AWS_ACCESS_KEY_ID\" \".cursor/mcp.json\" && ! grep -q \"YOUR_AWS_ACCESS_KEY_ID_HERE\" \".cursor/mcp.json\"; then
        check_pass \"AWS credentials configured\"
    else
        check_fail \"AWS credentials not configured\"
    fi
    
    # Anthropic API key (optional but recommended)
    if grep -q \"ANTHROPIC_API_KEY\" \".cursor/mcp.json\" && ! grep -q \"YOUR_ANTHROPIC_API_KEY_HERE\" \".cursor/mcp.json\"; then
        check_pass \"Anthropic API key configured\"
    else
        check_warn \"Anthropic API key not configured (optional but recommended for Claude AI)\"
    fi
    
    # Ansible Tower (optional)
    if grep -q \"ANSIBLE_TOWER_HOST\" \".cursor/mcp.json\" && ! grep -q \"YOUR_ANSIBLE_TOWER_HOST_HERE\" \".cursor/mcp.json\"; then
        check_pass \"Ansible Tower configuration found\"
    else
        check_warn \"Ansible Tower not configured (optional for AAP integration)\"
    fi
    
    # Terraform Cloud (optional)
    if grep -q \"TERRAFORM_CLOUD_TOKEN\" \".cursor/mcp.json\" && ! grep -q \"YOUR_TERRAFORM_CLOUD_TOKEN_HERE\" \".cursor/mcp.json\"; then
        check_pass \"Terraform Cloud token configured\"
    else
        check_warn \"Terraform Cloud token not configured (optional)\"
    fi
else
    check_fail \"Cannot validate API keys - MCP configuration missing\"
fi

echo \"\"

# Check 8: Python Environment
print_section \"Python Environment\"

if command_exists python3; then
    if python3 -c \"import ansible\" 2>/dev/null; then
        ANSIBLE_VERSION=\$(python3 -c \"import ansible; print(ansible.__version__)\" 2>/dev/null)
        check_pass \"Ansible Python module: \$ANSIBLE_VERSION\"
    else
        check_fail \"Ansible Python module not installed\"
    fi
    
    if python3 -c \"import jinja2\" 2>/dev/null; then
        check_pass \"Jinja2 templating available\"
    else
        check_warn \"Jinja2 not installed\"
    fi
    
    if python3 -c \"import yaml\" 2>/dev/null; then
        check_pass \"PyYAML available\"
    else
        check_warn \"PyYAML not installed\"
    fi
fi

echo \"\"

# Final Summary
print_section \"Validation Summary\"

TOTAL_CHECKS=\$((CHECKS_PASSED + CHECKS_FAILED + CHECKS_WARNED))

echo -e \"${GREEN}✅ Passed: \$CHECKS_PASSED${NC}\"
echo -e \"${RED}❌ Failed: \$CHECKS_FAILED${NC}\"
echo -e \"${YELLOW}⚠️  Warnings: \$CHECKS_WARNED${NC}\"
echo -e \"${BLUE}📊 Total Checks: \$TOTAL_CHECKS${NC}\"
echo \"\"

if [[ \$CHECKS_FAILED -eq 0 ]]; then
    echo -e \"${GREEN}🎉 Environment validation completed successfully!${NC}\"
    echo -e \"${CYAN}You're ready to start developing Red Hat demos with AI assistance.${NC}\"
    echo \"\"
    echo -e \"${WHITE}Next steps:${NC}\"
    echo -e \"${WHITE}1. Open Cursor IDE: ${CYAN}cursor .${NC}\"
    echo -e \"${WHITE}2. Test MCP integration in Cursor${NC}\"
    echo -e \"${WHITE}3. Start developing demos!${NC}\"
    exit 0
else
    echo -e \"${RED}❌ Environment validation failed with \$CHECKS_FAILED critical issues.${NC}\"
    echo \"\"
    echo -e \"${WHITE}Required actions:${NC}\"
    if [[ \$CHECKS_FAILED -gt 0 ]]; then
        echo -e \"${WHITE}1. Install missing tools (see failed checks above)${NC}\"
        echo -e \"${WHITE}2. Configure missing API keys in .cursor/mcp.json${NC}\"
        echo -e \"${WHITE}3. Re-run this validation script${NC}\"
    fi
    echo \"\"
    echo -e \"${CYAN}📖 For help: https://github.com/sibilleb/RedHat-Demo-AI-IDE/blob/main/SETUP_GUIDE.md${NC}\"
    exit 1
fi 