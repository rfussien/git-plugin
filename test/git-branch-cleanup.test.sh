#!/usr/bin/env bash

source "${SCRIPTDIR:-src}/git-branch-cleanup"

# Mock git commands globally
git() {
    case "$1" in
        "rev-parse")
            if [ "$2" = "--is-inside-work-tree" ]; then
                return 0
            fi
            ;;
        "fetch")
            if [ "$2" = "--all" ] && [ "$3" = "--prune" ]; then
                echo "Fetched and pruned remote branches"
                return 0
            fi
            ;;
        "branch")
            if [ "$2" = "--no-color" ] && [ "$3" = "--merged" ]; then
                echo "  branch1"
                echo "  branch2"
                echo "* current"
                echo "  master"
                echo "  main"
                return 0
            elif [ "$2" = "-d" ]; then
                echo "Deleted branch $3"
                return 0
            fi
            ;;
        *)
            return 0
            ;;
    esac
}

# Test branch cleaning logic
test_clean_merged_branches() {
    local output
    output=$(clean_merged_branches 2>&1)
    [[ "$output" =~ "Deleted branch branch1" ]] || { echo "Branch1 deletion test failed"; return 1; }
    [[ "$output" =~ "Deleted branch branch2" ]] || { echo "Branch2 deletion test failed"; return 1; }
    [[ ! "$output" =~ "master" ]] || { echo "Protected branch test failed"; return 1; }
    return 0
}

# Test repository check
test_is_git_repository() {
    local output
    if ! output=$(is_git_repository 2>&1); then
        echo "Git repository check test failed"
        return 1
    fi
    return 0
}

# Test fetch and prune
test_fetch_and_prune() {
    local output
    output=$(fetch_and_prune 2>&1)
    if [[ ! "$output" =~ "Fetched and pruned remote branches" ]]; then
        echo "Fetch and prune test failed - unexpected output: $output"
        return 1
    fi
    return 0
}

# Run all tests
echo "Running git-branch-cleanup tests..."
test_results=0

echo "Testing git repository check..."
if ! test_is_git_repository; then
    test_results=1
fi

echo "Testing fetch and prune..."
if ! test_fetch_and_prune; then
    test_results=1
fi

echo "Testing branch cleanup..."
if ! test_clean_merged_branches; then
    test_results=1
fi

if [ $test_results -eq 0 ]; then
    echo "All tests passed successfully!"
    exit 0
else
    echo "Some tests failed!"
    exit 1
fi 