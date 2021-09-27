default:
    @just --list

_run inventory tags:
    ansible-playbook -i inventory/{{inventory}} -K site.yml --tags {{tags}}

home tags='all':
    just _run home {{tags}}

work tags='all':
    just _run work {{tags}}

reqs:
    python3 -m pip install --user --upgrade pipx
    pipx install --include-deps ansible

