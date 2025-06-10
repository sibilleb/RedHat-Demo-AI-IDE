#!/bin/bash

# Quick Start Script for Red Hat Demo Development
# Opens the demos repository in Cursor IDE with optimal settings

set -e

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m'

echo -e "${PURPLE}🚀 Starting Red Hat Demo Development Environment${NC}"
echo -e "${PURPLE}==============================================${NC}"

# Check if we're in the right directory structure
if [[ -d "product-demos" ]]; then
    DEMOS_DIR="product-demos"
elif [[ -d "../product-demos" ]]; then
    cd ..
    DEMOS_DIR="product-demos"
else
    echo -e "${YELLOW}⚠️  Product demos directory not found!${NC}"
    echo -e "${CYAN}Please make sure you're in your workspace directory that contains 'product-demos'.${NC}"
    exit 1
fi

echo -e "${CYAN}📁 Found demos directory: ${DEMOS_DIR}${NC}"

# Ensure git repositories are up to date
echo -e "${BLUE}🔄 Checking for upstream updates...${NC}"

cd "$DEMOS_DIR"

# Fetch from upstream
if git remote | grep -q "upstream"; then
    echo -e "${CYAN}Fetching latest changes from upstream...${NC}"
    git fetch upstream
    
    # Show status
    BEHIND=$(git rev-list --count HEAD..upstream/main 2>/dev/null || echo "0")
    if [[ "$BEHIND" -gt 0 ]]; then
        echo -e "${YELLOW}⚠️  Your fork is ${BEHIND} commits behind upstream.${NC}"
        echo -e "${CYAN}💡 Consider running: git merge upstream/main${NC}"
    else
        echo -e "${GREEN}✅ Your fork is up to date with upstream${NC}"
    fi
else
    echo -e "${YELLOW}⚠️  Upstream remote not configured. Setting it up...${NC}"
    git remote add upstream https://github.com/ansible/product-demos.git
    git fetch upstream
fi

# Create a development branch if on main
CURRENT_BRANCH=$(git branch --show-current)
if [[ "$CURRENT_BRANCH" == "main" ]]; then
    echo -e "${YELLOW}💡 You're on the main branch. Consider creating a feature branch:${NC}"
    echo -e "${CYAN}   git checkout -b feature/my-demo-enhancement${NC}"
fi

# Check if .cursor configuration exists
if [[ ! -d ".cursor" ]]; then
    echo -e "${YELLOW}⚠️  Cursor configuration not found. Creating symlink...${NC}"
    if [[ -d "../RedHat-Demo-AI-IDE/.cursor" ]]; then
        ln -sf "../RedHat-Demo-AI-IDE/.cursor" ".cursor"
        echo -e "${GREEN}✅ Cursor configuration linked${NC}"
    else
        echo -e "${YELLOW}⚠️  Setup repository not found. Please run the one-click setup first.${NC}"
    fi
fi

# Validate environment quickly
echo -e "${BLUE}🔍 Quick environment check...${NC}"

MISSING_TOOLS=()

# Check essential tools
for tool in ansible terraform aws kubectl oc helm; do
    if ! command -v "$tool" &> /dev/null; then
        MISSING_TOOLS+=("$tool")
    fi
done

if [[ ${#MISSING_TOOLS[@]} -eq 0 ]]; then
    echo -e "${GREEN}✅ All essential tools are available${NC}"
else
    echo -e "${YELLOW}⚠️  Missing tools: ${MISSING_TOOLS[*]}${NC}"
    echo -e "${CYAN}💡 Run the setup script to install missing tools${NC}"
fi

# Check for API keys in MCP configuration
if [[ -f ".cursor/mcp.json" ]]; then
    if grep -q "your-.*-api-key-here" ".cursor/mcp.json"; then
        echo -e "${YELLOW}⚠️  API keys not configured in .cursor/mcp.json${NC}"
        echo -e "${CYAN}💡 Add your API keys for AI assistance${NC}"
    else
        echo -e "${GREEN}✅ MCP configuration appears to be set up${NC}"
    fi
else
    echo -e "${YELLOW}⚠️  MCP configuration not found${NC}"
fi

# Offer to open in Cursor
echo ""
echo -e "${PURPLE}🎯 Ready to start development!${NC}"
echo ""
echo -e "${CYAN}📋 Current status:${NC}"
echo -e "${CYAN}   Directory: $(pwd)${NC}"
echo -e "${CYAN}   Branch: ${CURRENT_BRANCH}${NC}"
echo -e "${CYAN}   Remote: $(git remote -v | grep origin | head -1 | awk '{print $2}')${NC}"
echo ""

# Launch Cursor
if command -v cursor &> /dev/null; then
    echo -e "${GREEN}🚀 Opening demos repository in Cursor IDE...${NC}"
    cursor .
else
    echo -e "${YELLOW}⚠️  Cursor IDE not found in PATH${NC}"
    echo -e "${CYAN}💡 Install Cursor from https://cursor.sh or open this directory manually${NC}"
    echo -e "${CYAN}📁 Directory to open: $(pwd)${NC}"
fi

echo ""
echo -e "${GREEN}✨ Happy demo development! ✨${NC}"
echo ""
echo -e "${CYAN}🔧 Useful commands while developing:${NC}"
echo -e "${CYAN}   ansible-lint playbooks/              # Lint Ansible playbooks${NC}"
echo -e "${CYAN}   terraform fmt terraform/             # Format Terraform files${NC}"
echo -e "${CYAN}   pre-commit run --all-files           # Run all quality checks${NC}"
echo -e "${CYAN}   git checkout -b feature/my-demo      # Create feature branch${NC}"
echo ""
echo -e "${CYAN}💬 Ask Claude in Cursor:${NC}"
echo -e "${CYAN}   \"Review this demo and suggest Red Hat best practices\"${NC}"
echo -e "${CYAN}   \"Help me enhance this Ansible playbook\"${NC}"
echo -e "${CYAN}   \"Create Terraform for this AWS demo\"${NC}" 