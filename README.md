# spark-container

[![CircleCI CI/CD Pipeline](https://circleci.com/gh/cwilbar04/spark-container.svg?style=shield)](https://circleci.com/gh/cwilbar04/spark-container)

# Overview
This project contains a [Dockerfile](/client-mode/Dockerfile) for an image that conatins everything needed to use pyspark in a Jupyter Lab environment. This project also contains a [Project Creation Jupyter Notebook] to walk through deploying the Docker image to Google Container Registry and creating a Kubernetes Cluster, Kubernetes Workload running the Conatiner, and a LoadBalancer to access the Workload.  

The Docker container can also be tested locally by cloning the git repository, setting a GOOGLE_CLOUD_PROJECT environment variable, and utilizing the "make client_local_run" command. You will, however, need to manually create a service account JSON file in /var/secrets/google/sa.json in order to interact with Google BigQuery. Future enhancements will seek to make this less cumbersome and automatic.

# Getting Started
Follow the steps in the [Project Creation Workbook](Project Creation Workbook.ipynb) to create and deploy your own GCP Project with Spark Docker Container stored in Google Container Registry and Deployed to Google Kuberenetes Engine to run. This also creates a Load Balancer to access the container, Big Query Dataset to store data, and Google Cloud Storage Bucket to use when loading data to BigQuery. Use the Load Balancer link to luanch Jupyter Lab. Open the load_files/Data Load.ipynb notebook, change the project_id in the second cell to the project you created, and run all cells. This will load all of the small 5-core datasets from [Amazon Reviews](https://nijianmo.github.io/amazon/index.html) to the BigQuery Dataset. Feel free to explore different options for loading the data. Note that any changes made to the Jupyter Notebook will NOT be saved because there is not currently a persisted volume.


# Enable Docker to push to GCR
gcloud auth activate-service-account terraform-service-account@spark-container-dev.iam.gserviceaccount.com --key-file=./data_wrangling/sa.json

gcloud auth configure-docker

# Install Terraform
https://learn.hashicorp.com/tutorials/terraform/install-cli

