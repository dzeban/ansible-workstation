# Parse roles dir to create per role target
comma := ,
empty :=
space := $(empty) $(empty)

ROLES     := $(notdir $(patsubst %/,%,$(wildcard roles/*/)))
RUN_ROLES := $(subst $(space),$(comma),$(filter $(ROLES),$(MAKECMDGOALS)))

# Inventory groups hosts by hostname, so the run applies the configuration
# of the current machine. Override with "make HOST=<name>".
HOST ?= $(shell hostname -s)

DISTRO := $(shell . /etc/os-release && echo $$ID)

PLAYBOOK := ansible-playbook -i inventory -l $(HOST) -K $(ARGS)

# The redirect forces make to run a shell, "command" is a shell builtin.
ANSIBLE_INSTALLED := $(shell command -v ansible-playbook 2>/dev/null)

.PHONY: all reqs _reqs-fedora _reqs-ubuntu _apply $(ROLES)

all: reqs
	$(PLAYBOOK) site.yml

# All role goals share one playbook run with the joined role list, so
# "make a b" asks for the sudo password once and gathers facts once.
# role.yml applies roles by name, so a new role needs no site.yml entry.
$(ROLES): _apply
	@:

_apply: reqs
	$(PLAYBOOK) role.yml -e run_roles=$(RUN_ROLES)

# Install ansible only if it is missing, so every apply can depend on
# reqs without a package manager run.
reqs: $(if $(ANSIBLE_INSTALLED),,_reqs-$(DISTRO))

_reqs-fedora:
	sudo dnf install ansible

_reqs-ubuntu:
	sudo apt install software-properties-common
	sudo add-apt-repository --yes --update ppa:ansible/ansible
	sudo apt install ansible

# Explicit reqs-<distro> rules take precedence, so this matches only
# distros without a rule.
_reqs-%:
	$(error Unsupported distro "$*")
