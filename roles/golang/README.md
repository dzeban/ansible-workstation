golang
======

Install Go language toolchain.

By default, it's installed in ~/go. 
`PATH` variable is not updated.

Role Variables
--------------

	golang_version: 1.10
	golang_platform: linux
	golang_arch: amd64
	golang_install_dir: "{{ ansible_user_dir }}/go"

Example Playbook
----------------

Including an example of how to use your role (for instance, with variables passed in as parameters) is always nice for users too:

    - hosts: servers
      roles:
         - { role: alexdzyoba.golang, golang_version: 1.9 }

License
-------

BSD

Author Information
------------------

Alex Dzyoba <alex@dzyoba.com>, https://alex.dzyoba.com
