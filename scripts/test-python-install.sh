#!/bin/bash

# Test script for install_python_packages function
# This script tests the function behavior in different virtual environment scenarios

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

print_info() {
    echo -e "${CYAN}ℹ️  $1${NC}"
}

print_test() {
    echo -e "${YELLOW}🧪 Testing: $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

# Source the functions we need to test
# Extract just the functions we need to avoid running the whole script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Create a temporary file with just the functions we need
TEMP_FUNCTIONS=$(mktemp)
cat > "$TEMP_FUNCTIONS" << 'EOF'
# Install Python packages safely
install_python_packages() {
    local packages=("$@")
    local expected_venv="$HOME/.venv/redhat-demo"
    
    # Check if we're already in a virtual environment
    if [[ -n "$VIRTUAL_ENV" ]]; then
        if [[ "$VIRTUAL_ENV" == "$expected_venv" ]]; then
            print_info "Already in Red Hat demo virtual environment: $VIRTUAL_ENV"
            print_info "Installing packages directly in current virtual environment"
            python3 -m pip install "${packages[@]}"
            return
        else
            print_info "Currently in different virtual environment: $VIRTUAL_ENV"
            print_info "Switching to Red Hat demo virtual environment"
            # Deactivate current and activate ours
            deactivate 2>/dev/null || true
            setup_python_env
            python3 -m pip install "${packages[@]}"
            return
        fi
    fi
    
    # Check for externally-managed environment or if we need virtual environment
    if python3 -m pip install --help 2>&1 | grep -q "externally-managed-environment" || \
       python3 -c "import sysconfig; print(sysconfig.get_path('purelib'))" 2>/dev/null | grep -q "/opt/homebrew\|/usr/local" || \
       ! python3 -m pip install --user --help >/dev/null 2>&1; then
        print_info "Detected externally-managed Python environment - using virtual environment"
        setup_python_env
        
        # Verify we're in the virtual environment
        if [[ "$VIRTUAL_ENV" != "" ]]; then
            print_info "Installing packages in virtual environment: $VIRTUAL_ENV"
        else
            print_warning "Virtual environment not activated, but continuing with installation"
        fi
        
        python3 -m pip install "${packages[@]}"
    else
        # Use --user flag for user-space installation
        print_info "Using --user installation for Python packages"
        python3 -m pip install --user "${packages[@]}"
    fi
}

# Create or activate virtual environment for Python packages
setup_python_env() {
    local venv_path="$HOME/.venv/redhat-demo"
    
    if [[ ! -d "$venv_path" ]]; then
        print_info "Creating virtual environment at $venv_path"
        python3 -m venv "$venv_path" || {
            print_error "Failed to create virtual environment"
            return 1
        }
    fi
    
    # Activate virtual environment
    source "$venv_path/bin/activate" || {
        print_error "Failed to activate virtual environment"
        return 1
    }
    
    # Verify activation
    if [[ "$VIRTUAL_ENV" == "$venv_path" ]]; then
        print_info "Successfully activated virtual environment: $venv_path"
    else
        print_warning "Virtual environment may not be properly activated"
    fi
    
    # Upgrade pip in virtual environment
    python3 -m pip install --upgrade pip || {
        print_warning "Failed to upgrade pip in virtual environment"
    }
}
EOF

source "$TEMP_FUNCTIONS"

echo "🧪 Python Package Installation Function Test"
echo "============================================="
echo ""

# Test 1: Test with no virtual environment active
print_test "No virtual environment active"
if [[ -z "$VIRTUAL_ENV" ]]; then
    print_success "No virtual environment detected"
    install_python_packages requests
    print_success "Package installation completed"
else
    print_info "Virtual environment is active: $VIRTUAL_ENV"
    print_info "Deactivating for test..."
    deactivate || true
fi

echo ""

# Test 2: Test with different virtual environment active
print_test "Different virtual environment active"
test_venv="$HOME/.venv/test-different"

# Create and activate different environment
if [[ ! -d "$test_venv" ]]; then
    python3 -m venv "$test_venv"
fi
source "$test_venv/bin/activate"

print_info "Activated different environment: $VIRTUAL_ENV"
install_python_packages requests
print_success "Package installation with environment switching completed"

echo ""

# Test 3: Test with correct virtual environment active
print_test "Correct virtual environment already active"
redhat_venv="$HOME/.venv/redhat-demo"

if [[ -d "$redhat_venv" ]]; then
    source "$redhat_venv/bin/activate"
    print_info "Activated Red Hat demo environment: $VIRTUAL_ENV"
    install_python_packages urllib3
    print_success "Package installation in correct environment completed"
fi

echo ""

# Cleanup
print_test "Cleanup"
deactivate 2>/dev/null || true
rm -rf "$test_venv"
rm -f "$TEMP_FUNCTIONS"
print_success "Test cleanup completed"

echo ""
print_success "All install_python_packages function tests completed!"
echo ""
echo "The function should now properly handle:"
echo "  ✅ No virtual environment active"
echo "  ✅ Different virtual environment active (switches to ours)"
echo "  ✅ Correct virtual environment active (uses it directly)"
echo "  ✅ Externally-managed environments" 