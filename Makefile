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

data_wrangling_container_push:
	docker tag spark-notebook:latest cwilbar04/spark-notebook:latest
	docker push cwilbar04/spark-notebook:latest
	docker tag spark-notebook:latest gcr.io/spark-container-dev/spark-notebook:latest
	docker push gcr.io/spark-container-dev/spark-notebook:latest

data_wrangling_container_terraform:
	terraform -chdir=data_wrangling init
	terraform -chdir=data_wrangling apply -auto-approve

spark_notebook:
	-docker rm -f spark-notebook 
	-docker run -it --name spark-notebook --rm -p 8888:8888 -v $(CURDIR)/data_wrangling:/home/data spark-notebook
	# docker exec -u pitfox spark-notebook jupyter notebook --ip=0.0.0.0 --no-browser 

distributed_spark_build:
	docker build -t base distributed-spark\base
	docker build -t jupyterlab distributed-spark\jupyterlab
	docker build -t spark-base distributed-spark\spark-base
	docker build -t spark-master distributed-spark\spark-master
	docker build -t spark-worker distributed-spark\spark-worker

distributed_spark_compose:
	docker-compose -f distributed-spark/docker-compose.yml up



all: install lint test