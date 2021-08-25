STEPS = configure build init apply

default: $(STEPS)

COMPOSE = docker-compose -f $(component).yml

$(STEPS):
	$(COMPOSE) run $@

