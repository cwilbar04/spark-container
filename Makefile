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

data_wrangling_container_build:
	docker build -t spark-notebook data_wrangling

spark_notebook:
	-docker rm -f spark-notebook 
	docker run -it --name spark-notebook --rm -d -p 8888:8888 -v $(CURDIR)/data_wrangling:/home/pitfox/data spark-notebook
	docker exec -u pitfox spark-notebook jupyter notebook --ip=0.0.0.0 --no-browser 

all: install lint test