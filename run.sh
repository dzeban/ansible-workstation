#!/bin/bash

set -euo pipefail

apply() {
    local inventory=$1
    shift

    tags='all'
    while getopts "t:" opt; do
        case $opt in
            t) tags=${OPTARG} ;;
            *) usage; exit 1;;
        esac
    done

    ansible-playbook -i inventory/${inventory} -K site.yml --tags "${tags}"
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
    echo "Options for 'home' and 'work' commands:"
    echo "  -t <value>   ansible tags, comma separated. Default is 'all'"
    echo ""
    echo "Example usage:"
    echo "  $0 home                  # Apply configuration for home machine"
    echo "  $0 home -t packages      # Apply the home configuration, but only packages"
    echo ""
    echo "  $0 work                  # Apply configuration for work machine"
    echo "  $0 work -t dotfiles,ssh  # Apply the work configuration, but only dotfiles and ssh"
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
