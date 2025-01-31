golang
======

Install Go language toolchain.

By default, it's installed in ~/soft/go. 
`PATH` variable is not updated.

Role Variables
--------------

	golang_version: "latest"
	golang_platform: linux
	golang_arch: amd64

Example Playbook
----------------

Including an example of how to use your role (for instance, with variables passed in as parameters) is always nice for users too:

    - hosts: servers
      roles:
         - { role: alexdzyoba.golang 

License
-------

BSD

Author Information
------------------

Alex Dzyoba <alex@dzyoba.com>, https://alex.dzyoba.com
