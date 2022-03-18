actor = $(git_user)
.PHONY: $(actor)

ALPINE_PACKAGES = pass abook gnupg restic #mutt calcurse # editor

VOLUMES = $(ALPINE_PACKAGES)
VOLUMES += $(actor)
ENVIRONMENT_VARIABLES = "GIT_USER=$(git_user)\nGIT_EMAIL=$(git_email)\nPASSPHRASE=$(passphrase)\n"


default: volumes alpine_packages
alpine_packages: $(ALPINE_PACKAGES)


volumes: $(VOLUMES)
	for volume in $?; do docker volume create --name $$volume; done

%.env:
	@echo $(ENVIRONMENT_VARIABLES) > $@

%.asc:
	docker run -v $(pwd):/work -v pass:/pass -it --rm -w /work alpine cp $@ ./

$(actor):
	docker run --rm -it -v $(PWD):/input -v envsubst:/envsubst alpine sh

$(ALPINE_PACKAGES):
	docker build -t $@ --build-arg pkg=$@ .
