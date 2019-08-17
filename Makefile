ANSIBLE_ARGS=
ANSIBLE_ROLES_PATH=./roles
ifdef TARGET_DEPLOYMENT_ENV
ANSIBLE_DEFAULTS = ops/ansible/defaults/$(TARGET_DEPLOYMENT_ENV).yml
ANSIBLE_VARS = ops/ansible/vars/$(TARGET_DEPLOYMENT_ENV).yml
ANSIBLE_ARGS := $(ANSIBLE_ARGS) -e deployment_env_name=$(TARGET_DEPLOYMENT_ENV)
endif
ifdef ANSIBLE_TAG
ANSIBLE_ARGS := $(ANSIBLE_ARGS) -t $(ANSIBLE_TAG)
endif
GIT_COMMIT_HASH=$(shell git rev-parse --short HEAD | tr -d '\n')
PYTHONPATH=""


.PHONY: all
export ANSIBLE_TAG
export ANSIBLE_ROLES_PATH
export TOWER_HOST
export TOWER_USERNAME
export TOWER_PASSWORD
export GOOGLE_APPLICATION_CREDENTIALS
export PYTHONPATH


env:
	@python3 -m venv env
	@source ./env/bin/activate;\
	pip3 install -r requirements.txt
	ansible-galaxy install -r ./roles/requirements.yml --force

clean:
	@rm -rf ./env
	@rm -rf ./roles/unimatrix-awx


_deploy:
ifeq (,$(wildcard env/bin/activate))
	make env
endif
	@source ./env/bin/activate;\
	ansible-playbook ops/ansible/main.yml $(ANSIBLE_ARGS)


_bootstrap:
ifeq (,$(wildcard env/bin/activate))
	make env
endif
	@source ./env/bin/activate;\
	ansible-playbook bootstrap/main.yml $(ANSIBLE_ARGS)


bootstrap-development:
	make _bootstrap TARGET_DEPLOYMENT_ENV=development


bootstrap-testing:
	make _bootstrap TARGET_DEPLOYMENT_ENV=testing


bootstrap-acceptance:
	make _bootstrap TARGET_DEPLOYMENT_ENV=acceptance


bootstrap-production:
	make _bootstrap TARGET_DEPLOYMENT_ENV=production


bootstrap-backup:
	make _bootstrap TARGET_DEPLOYMENT_ENV=backup


bootstrap-resilience:
	make _bootstrap TARGET_DEPLOYMENT_ENV=resilience


bootstrap-penetration:
	make _bootstrap TARGET_DEPLOYMENT_ENV=penetration


bootstrap-stress:
	make _bootstrap TARGET_DEPLOYMENT_ENV=stress


deploy-development:
	make _deploy TARGET_DEPLOYMENT_ENV=development


deploy-testing:
	make _deploy TARGET_DEPLOYMENT_ENV=testing


deploy-acceptance:
	make _deploy TARGET_DEPLOYMENT_ENV=acceptance


deploy-production:
	make _deploy TARGET_DEPLOYMENT_ENV=production


deploy-backup:
	make _deploy TARGET_DEPLOYMENT_ENV=backup


deploy-penetration:
	make _deploy TARGET_DEPLOYMENT_ENV=penetration


deploy-resilience:
	make _deploy TARGET_DEPLOYMENT_ENV=resilience


deploy-stress:
	make _deploy TARGET_DEPLOYMENT_ENV=stress
