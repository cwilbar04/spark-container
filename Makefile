install:
	pip install --upgrade pip &&\
		pip install -r requirements.txt

test:
	cd tests
	python -m pytest -vv

lint:
	python -m pylint --disable=R,C tests webapp

venv_create: 
	python -m venv ..\.venv

venv_activate:
	.\..\.venv\Scripts\activate

venv: venv_create venv_activate

spark_notebook:
	docker run -it --rm -p 8888:8888 -v ${pwd}/data_wrangling:/home/jovyan/work jupyter/pyspark-notebook

all: install lint test