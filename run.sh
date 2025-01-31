#!/bin/bash

set -euo pipefail

apply() {
    local inventory=$1
    shift

    ansible-playbook -i inventory/${inventory} -K site.yml "${@}"
}

reqs() {
    local distro=`awk -F= '$1=="ID" {print $2}' /etc/os-release`
    case "${distro}" in
        ubuntu)
            sudo apt install software-properties-common
            sudo add-apt-repository --yes --update ppa:ansible/ansible
            sudo apt install ansible
            ;;
        fedora)
            sudo dnf install ansible
            ;;
        *)
            echo "Unsupported distro ${distro}"
            ;;
    esac
}

usage() {
    echo "Usage: $0 <command> [options]"
    echo ""
    echo "Commands:"
    echo "  home      Apply home configuration"
    echo "  work      Apply work configuration"
    echo "  reqs      Install requirements (ansible)"
    echo ""
    echo "'home' and 'work' commands accept ansible-playbook options"
    echo ""
    echo "Example usage:"
    echo "  $0 home                  # Apply configuration for home machine"
    echo "  $0 home -t packages      # Apply the home configuration, but only packages tags"
    echo ""
    echo "  $0 work                      # Apply configuration for work machine"
    echo "  $0 work -vv -t dotfiles,ssh  # Apply the work configuration, but only dotfiles and ssh tags, be verbose"
    echo ""
    echo "  $0 reqs                  # Install requirements"
    echo ""
}

if [[ $# -lt 1 ]]; then
    usage
    exit 1
fi

command="$1"
shift

case "$command" in
    home|work) apply "${command}" "${@}" ;;
    reqs) reqs ;;
    *)
        echo "Unknown command: $command"
        usage
        exit 1
        ;;
esac
