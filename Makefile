default:
	@echo 'Choose "work" or "home" target'

home:
	ansible-playbook -i inventory/home -K site.yml

work:
	ansible-playbook -i inventory/work -K site.yml

reqs: 
	python3 -m pip install --user --upgrade pipx
	pipx install --include-deps ansible
