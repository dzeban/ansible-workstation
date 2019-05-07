all:
	ansible-playbook -K site.yml

diff:
	ansible-playbook -D -K site.yml

checkdiff:
	ansible-playbook -CD -K site.yml
