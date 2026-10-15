# ansible-workstation

Bootstrap my workstation with Ansible

## Quickstart

* `make`

`make` applies the configuration for the current hostname, using group vars from
inventory.

Other invocations:

* `make packages dotfiles` - apply only the given roles
* `make HOST=slate` - apply the configuration of another host
* `make ARGS=-vv` - pass extra options to `ansible-playbook`
