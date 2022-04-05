git_user ?= $(GIT_USER)
actor = $(git_user)
.PHONY: $(actor)

ALPINE_PACKAGES = pass abook gnupg restic #mutt calcurse # editor
VOLUMES = $(ALPINE_PACKAGES)
VOLUMES += $(actor)

passphrase ?= $(shell pass show $(project)/$(git_user))
restic_password ?= $(shell pass show $(project)/$(git_user)/restic)

data = '/root/.password-store /root/.abook /root/.gnupg /root/envsubst /root/.calcurse'
ENV_VARS = "GIT_USER=$(git_user)"
ENV_VARS += "\nPROJECT=$(project)"
ENV_VARS += "\nGIT_EMAIL=$(git_user)@$(project)"
ENV_VARS += "\nPASSPHRASE=$(passphrase)"
ENV_VARS += "\nRESTIC_PASSWORD=$(restic_password)"
ENV_VARS += "\nRESTIC_REPOSITORY=/usr/local/restic"
ENV_VARS += "\nDATA=$(data)"

$(project).env:
	@echo $(ENV_VARS) > $@

project = $(PROJECT)

run\:$(component):
	docker compose --env-file $(project).env --project-name $(project)-$(actor) run --rm $(component)


default: volumes alpine_packages
alpine_packages: $(ALPINE_PACKAGES)


volumes: $(VOLUMES)
	for volume in $?; do docker volume create --name $$volume; done

%.asc:
	docker run -v $(pwd):/work -v pass:/pass -it --rm -w /work alpine cp $@ ./

$(actor):
	docker run --rm -it -v $(PWD):/input -v envsubst:/envsubst alpine sh

$(ALPINE_PACKAGES):
	docker build -t $@ --build-arg pkg=$@ .
