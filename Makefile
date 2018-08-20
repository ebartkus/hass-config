PY_VERSION := 3

ENV = env

BIN := $(ENV)/bin
PIP := $(BIN)/pip
PY := $(BIN)/python
PYLINT := $(BIN)/pylint
PYTEST := $(BIN)/py.test
COVERAGE := $(BIN)/coverage


.PHONY: help init clean virtual

help:
	@echo "COMMANDS:"
	@echo "  clean          Remove all generated files."
	@echo "  setup          Setup development environment."
	@echo "  shell          Open ipython from the development environment."
	@echo "  test           Run tests."
	@echo ""
	@echo "VARIABLES:"
	@echo "  PY_VERSION    Version of python to use. 2 or 3"


clean:
	rm -rf $(ENV)
	rm -rf build
	rm -rf dist
	rm -rf *.egg
	rm -rf *.egg-info
	rm -rf .cache
	rm -rf .coverage
	find . -name \*.pyc -delete


setup: env/bin/activate
env/bin/activate: requirements.txt
	test -d $(ENV) || virtualenv -p python$(PY_VERSION)  $(ENV)
	$(PIP) install -Ur requirements.txt
	touch $(ENV)/bin/activate

shell: setup
	$(ENV)/bin/ipython

copysecrets:
	cp secrets_travis.yaml secrets.yaml

test: copysecrets
	$(BIN)/hass -c . --script check_config



