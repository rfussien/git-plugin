#!/usr/bin/env bash

source "${SCRIPTDIR:-src}/git-autocommit"

# Test branch name formatting
test_get_branch_name() {
    local test_failed=0

    # Mock git branch command
    git() {
        if [ "$1" = "branch" ] && [ "$2" = "--show-current" ]; then
            echo "feature-branch-name"
        fi
    }

    local result
    result=$(get_branch_name)
    [ "$result" = "feature branch name" ] || { echo "Branch name formatting test failed"; test_failed=1; }

    return $test_failed
}

# Test has_changes function
test_has_changes() {
    local test_failed=0

    # Test case 1: Changes exist
    # Mock git status command for changes
    git() {
        if [ "$1" = "status" ] && [ "$2" = "--porcelain" ]; then
            echo "M file.txt"
        fi
    }

    if ! has_changes; then
        echo "Has changes test failed - should detect changes"
        test_failed=1
    fi

    # Test case 2: No changes
    # Mock git status command for no changes
    git() {
        if [ "$1" = "status" ] && [ "$2" = "--porcelain" ]; then
            echo ""
        fi
    }

    if has_changes; then
        echo "No changes test failed - should detect no changes"
        test_failed=1
    fi

    return $test_failed
}

# Test check_main_branch function
test_check_main_branch() {
    local test_failed=0

    # Test main branch warning
    git() {
        if [ "$1" = "branch" ] && [ "$2" = "--show-current" ]; then
            echo "main"
        fi
    }

    # Simulate 'n' response
    read() {
        REPLY=""  # Simulate empty response (defaults to 'n')
        return 0
    }

    if check_main_branch; then
        echo "Main branch check test failed - should exit on 'n'"
        test_failed=1
    fi

    return $test_failed
}

# Test create_commit function
test_create_commit() {
    local test_failed=0

    # Mock git commands
    git() {
        case "$1" in
            "add")
                echo "Changes staged"
                return 0
                ;;
            "commit")
                if [[ "$3" =~ ^"feat: #test branch"$ ]]; then
                    echo "Created commit"
                    return 0
                fi
                return 1
                ;;
        esac
    }

    local output
    output=$(create_commit "feat" "test branch" 2>&1)
    [[ "$output" =~ "Successfully committed changes" ]] || { echo "Create commit test failed - output: $output"; test_failed=1; }

    return $test_failed
}

# Run all tests
main() {
    local test_results=0

    echo "Testing branch name formatting..."
    if ! test_get_branch_name; then
        test_results=1
    fi

    echo "Testing changes detection..."
    if ! test_has_changes; then
        test_results=1
    fi

    echo "Testing main branch check..."
    if ! test_check_main_branch; then
        test_results=1
    fi

    echo "Testing commit creation..."
    if ! test_create_commit; then
        test_results=1
    fi

    if [ $test_results -eq 0 ]; then
        echo "All git-autocommit tests passed successfully!"
        exit 0
    else
        echo "Some git-autocommit tests failed!"
        exit 1
    fi
}

# Only run main if the script is being executed directly (not sourced)
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi 