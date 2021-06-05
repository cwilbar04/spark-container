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
	docker tag client-mode-spark-notebook:latest gcr.io/${GOOGLE_CLOUD_PROJECT}/client-mode-spark-notebook:latest
	docker push gcr.io/${GOOGLE_CLOUD_PROJECT}/client-mode-spark-notebook:latest

client_local_run:
	docker build -t client-mode-spark-notebook client-mode
	-docker rm -f client-mode-spark-notebook 
	docker run -it --name client-mode-spark-notebook --rm -p 8888:8888 -v $(CURDIR)/client-mode:/home/data client-mode-spark-notebook

all: install lint test