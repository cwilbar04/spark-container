install:
	pip install --upgrade pip &&\
		pip install -r requirements.txt

test:
	cd tests
	python -m pytest -vv

lint:
	pylint --disable=R,C tests

venv_create: 
	python -m venv ..\.venv

venv_activate:
	.\..\.venv\Scripts\activate

venv: venv_create venv_activate

all: install lint test