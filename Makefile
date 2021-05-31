env_variables:
	set GOOGLE_CLOUD_PROJECT=spark-container-test

secret:
	kubectl create secret generic google-credentials \
  --from-file ./sa.json

install:
	pip install --upgrade pip &&\
		pip install -r requirements.txt

test:
	cd tests
	python -m pytest -vv

lint:
	python -m pylint --disable=R,C tests webapp

venv: 
	python -m venv ..\.venv
	@echo VirtualEnv created. Now run .\..\.venv\Scripts\activate

client_build:
	docker build -t client-mode-spark-notebook client-mode

client_push:
	docker tag client-mode-spark-notebook:latest cwilbar04/client-mode-spark-notebook:latest
	docker push cwilbar04/client-mode-spark-notebook:latest
	docker tag client-mode-spark-notebook:latest gcr.io/${GOOGLE_CLOUD_PROJECT}/client-mode-spark-notebook:latest
	docker push gcr.io/${GOOGLE_CLOUD_PROJECT}/client-mode-spark-notebook:latest

client_terraform:
	terraform -chdir=data_wrangling init
	terraform -chdir=data_wrangling apply -auto-approve

client_local_run:
	docker build -t client-mode-spark-notebook client-mode
	-docker rm -f client-mode-spark-notebook 
	docker run -it --name client-mode-spark-notebook --rm -p 8888:8888 -v $(CURDIR)/client-mode:/home/data client-mode-spark-notebook

cluster_standalone_build:
	docker build -t base cluster-mode-standalone\base
	docker build -t jupyterlab cluster-mode-standalone\jupyterlab
	docker build -t spark-base cluster-mode-standalone\spark-base
	docker build -t spark-master cluster-mode-standalone\spark-master
	docker build -t spark-worker cluster-mode-standalone\spark-worker

cluster_standalone_push:
	docker tag base:latest cwilbar04/spark-cluster-base:latest
	docker push cwilbar04/spark-cluster-base:latest
	docker tag jupyterlab:latest cwilbar04/spark-cluster-jupyterlab:latest
	docker push cwilbar04/spark-cluster-jupyterlab:latest
	docker tag spark-base:latest cwilbar04/spark-cluster-spark-base:latest
	docker push cwilbar04/spark-cluster-spark-base:latest
	docker tag spark-master:latest cwilbar04/spark-cluster-spark-master:latest
	docker push cwilbar04/spark-cluster-spark-master:latest
	docker tag spark-worker:latest cwilbar04/spark-cluster-spark-worker:latest
	docker push cwilbar04/spark-cluster-spark-worker:latest

cluster_standalone_compose:
	docker-compose -f cluster-mode-standalone/docker-compose.yml up

all: install lint test