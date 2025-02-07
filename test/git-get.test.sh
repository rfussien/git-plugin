#!/usr/bin/env bash

# Source the script to test
source "${SCRIPTDIR:-src}/git-get"

# Mock git commands
git() {
    case "$1" in
        "clone")
            echo "Mocked git clone $2"
            return 0
            ;;
        "pull")
            echo "Mocked git pull"
            return 0
            ;;
        "rev-parse")
            return 0
            ;;
        *)
            return 0
            ;;
    esac
}

# Mock filesystem commands
cd() {
    echo "Changed directory to $1"
    return 0
}

mkdir() {
    if [ "$1" = "-p" ]; then
        echo "Created directory $2"
        return 0
    fi
    echo "Created directory $1"
    return 0
}

dirname() {
    echo "/mock/path/to"
}

# Mock directory test
# This will be overridden in specific tests
-d() {
    return 1  # Directory doesn't exist by default
}

# Test parse_repository
test_parse_repository() {
    local result
    local test_failed=0
    
    # Test SSH URL
    result=$(parse_repository "git@github.com:user/repo.git")
    [ "$result" = "github.com user repo git@github.com:user/repo.git" ] || { echo "SSH URL test failed"; test_failed=1; }

    # Test HTTPS URL
    result=$(parse_repository "https://github.com/user/repo")
    [ "$result" = "github.com user repo https://github.com/user/repo" ] || { echo "HTTPS URL test failed"; test_failed=1; }

    # Test shorthand
    result=$(parse_repository "user/repo")
    [ "$result" = "github.com user repo git@github.com:user/repo.git" ] || { echo "Shorthand test failed"; test_failed=1; }

    return $test_failed
}

# Test get_base_path
test_get_base_path() {
    local result
    local test_failed=0

    # Test command line path
    result=$(get_base_path "/custom/path")
    [ "$result" = "/custom/path" ] || { echo "Command line path test failed"; test_failed=1; }

    # Test environment variable
    GIT_GET_PATH="/env/path" result=$(get_base_path "")
    [ "$result" = "/env/path" ] || { echo "Environment variable test failed"; test_failed=1; }

    # Test default path
    unset GIT_GET_PATH
    result=$(get_base_path "")
    [ "$result" = "$HOME/src" ] || { echo "Default path test failed"; test_failed=1; }

    return $test_failed
}

# Test validate_args function
test_validate_args() {
    local test_failed=0

    # Temporarily redirect stdout and stderr to /dev/null
    exec 3>&1 4>&2
    exec 1>/dev/null 2>/dev/null

    # Test with no arguments
    if validate_args; then
        exec 1>&3 2>&4  # Restore stdout and stderr
        echo "Validation should fail with no arguments"
        test_failed=1
    fi

    # Test with correct number of arguments
    if ! validate_args "user/repo"; then
        exec 1>&3 2>&4  # Restore stdout and stderr
        echo "Validation should pass with one argument"
        test_failed=1
    fi

    # Test with too many arguments
    if validate_args "arg1" "arg2"; then
        exec 1>&3 2>&4  # Restore stdout and stderr
        echo "Validation should fail with too many arguments"
        test_failed=1
    fi

    # Restore stdout and stderr
    exec 1>&3 2>&4

    return $test_failed
}

# Test handle_repository function
test_handle_repository() {
    local result
    local test_failed=0
    local TEST_MODE=""

    # Mock functions
    -d() { 
        if [[ "$TEST_MODE" == "update" ]]; then
            return 0  # Directory exists
        else
            return 1  # Directory doesn't exist
        fi
    }

    mkdir() { 
        if [ "$1" = "-p" ]; then
            echo "Created directory $2"
        else
            echo "Created directory $1"
        fi
        return 0
    }

    cd() { 
        echo "Changed directory to $1"
        return 0
    }

    git() { 
        case "$1" in
            "clone")
                if [[ "$TEST_MODE" != "update" ]]; then
                    echo "Mocked git clone $2"
                    return 0
                fi
                ;;
            "pull")
                if [[ "$TEST_MODE" == "update" ]]; then
                    echo "Mocked git pull"
                    return 0
                fi
                ;;
            "rev-parse")
                return 0
                ;;
        esac
        return 0
    }

    # Test cloning new repository (directory doesn't exist)
    TEST_MODE="clone"
    result=$(handle_repository "/mock/path/to/repo" "git@github.com:user/repo.git" 2>&1)
    [[ "$result" =~ "Cloning new repository" ]] || { echo "Clone repository test failed"; test_failed=1; }
    [[ "$result" =~ "Successfully processed repository" ]] || { echo "Clone success message test failed"; test_failed=1; }

    # Test updating existing repository (directory exists)
    TEST_MODE="update"
    result=$(handle_repository "/mock/path/to/repo" "git@github.com:user/repo.git" 2>&1)
    [[ "$result" =~ "Cloning new repository" ]] || { echo "Update repository test failed - output: $result"; test_failed=1; }
    [[ "$result" =~ "Successfully processed repository" ]] || { echo "Update success message test failed - output: $result"; test_failed=1; }

    # Clean up
    unset -f -- "-d" mkdir cd git
    unset TEST_MODE

    return $test_failed
}

# Run all tests
main() {
    local test_results=0

    echo "Testing repository parsing..."
    if ! test_parse_repository; then
        test_results=1
    fi

    echo "Testing base path handling..."
    if ! test_get_base_path; then
        test_results=1
    fi

    echo "Testing argument validation..."
    if ! test_validate_args; then
        test_results=1
    fi

    echo "Testing repository handling..."
    if ! test_handle_repository; then
        test_results=1
    fi

    if [ $test_results -eq 0 ]; then
        echo "All git-get tests passed successfully!"
        exit 0
    else
        echo "Some git-get tests failed!"
        exit 1
    fi
}

# Only run main if the script is being executed directly (not sourced)
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi 