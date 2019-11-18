default:
	@echo 'Choose "work" or "home" target'

home:
	ansible-playbook -i inventory/home -K site.yml

work:
	ansible-playbook -i inventory/work -K site.yml
