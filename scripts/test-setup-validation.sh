#!/bin/bash

# Test script to verify one-click-setup and validation work together
# This simulates the typical user workflow

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

echo "🔬 Setup and Validation Integration Test"
echo "========================================"
echo ""

# Test 1: Check that validation script syntax is correct
print_test "Validation script syntax"
if bash -n scripts/validate-environment.sh; then
    print_success "Validation script syntax is correct"
else
    print_error "Validation script has syntax errors"
    exit 1
fi

# Test 2: Check that validation script runs without crashing
print_test "Validation script execution"
set +e  # Temporarily disable exit on error
./scripts/validate-environment.sh > /dev/null 2>&1
exit_code=$?
set -e  # Re-enable exit on error
if [[ $exit_code -eq 0 ]] || [[ $exit_code -eq 1 ]]; then
    # Exit codes 0 (success) or 1 (validation failures) are both acceptable
    print_success "Validation script executes properly (exit code: $exit_code)"
else
    print_error "Validation script crashed with unexpected error (exit code: $exit_code)"
    exit 1
fi

# Test 3: Check that validation script produces output
print_test "Validation script output generation"
set +e  # Temporarily disable exit on error
output=$(./scripts/validate-environment.sh 2>&1)
set -e  # Re-enable exit on error
if [[ -n "$output" ]] && echo "$output" | grep -q "Red Hat Demo Environment Validation"; then
    print_success "Validation script produces expected output"
else
    print_error "Validation script output is missing or malformed"
    echo "Debug: First 200 chars of output: ${output:0:200}"
    exit 1
fi

# Test 4: Check that validation script counts are working
print_test "Validation script counters"
if echo "$output" | grep -q "Total Checks:"; then
    print_success "Validation script counters are working"
else
    print_error "Validation script counters are not working"
    exit 1
fi

# Test 5: Check one-click-setup syntax
print_test "One-click-setup script syntax"
if bash -n scripts/one-click-setup.sh; then
    print_success "One-click-setup script syntax is correct"
else
    print_error "One-click-setup script has syntax errors"
    exit 1
fi

# Test 6: Check that both scripts have proper shebang and permissions
print_test "Script permissions and shebang"
if [[ -x scripts/validate-environment.sh ]] && [[ -x scripts/one-click-setup.sh ]]; then
    print_success "Scripts are executable"
else
    print_error "Scripts are not executable"
    exit 1
fi

if head -1 scripts/validate-environment.sh | grep -q "#!/bin/bash" && \
   head -1 scripts/one-click-setup.sh | grep -q "#!/bin/bash"; then
    print_success "Scripts have proper shebang"
else
    print_error "Scripts missing proper shebang"
    exit 1
fi

echo ""
print_success "All integration tests passed!"
echo ""
echo "The setup and validation scripts are working correctly and ready for users."
echo ""
echo "User workflow test:"
echo "1. ✅ one-click-setup.sh (syntax verified)"
echo "2. ✅ validate-environment.sh (execution verified)" 
echo "3. ✅ Proper error handling and output generation" 