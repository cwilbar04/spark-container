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

client_build:
	docker build -t client-mode-spark-notebook client-mode

client_push:
	docker tag client-mode-spark-notebook:latest cwilbar04/client-mode-spark-notebook:latest
	docker push cwilbar04/client-mode-spark-notebook:latest
	docker tag client-mode-spark-notebook:latest gcr.io/${GOOGLE_CLOUD_PROJECT}/client-mode-spark-notebook:latest
	docker push gcr.io/${GOOGLE_CLOUD_PROJECT}//client-mode-spark-notebook:latest

client_terraform:
	terraform -chdir=data_wrangling init
	terraform -chdir=data_wrangling apply -auto-approve

client_local_run:
	-docker rm -f client-mode-spark-notebook 
	-docker run -it --name client-mode-spark-notebook --rm -p 8888:8888 -v $(CURDIR)/client-mode:/home/data client-mode-spark-notebook




distributed_spark_build:
	docker build -t base distributed-spark\base
	docker build -t jupyterlab distributed-spark\jupyterlab
	docker build -t spark-base distributed-spark\spark-base
	docker build -t spark-master distributed-spark\spark-master
	docker build -t spark-worker distributed-spark\spark-worker

distributed_spark_compose:
	docker-compose -f distributed-spark/docker-compose.yml up



all: install lint test