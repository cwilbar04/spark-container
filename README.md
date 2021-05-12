# spark-container

[![CircleCI CI/CD Pipeline](https://circleci.com/gh/cwilbar04/spark-container.svg?style=shield)](https://circleci.com/gh/cwilbar04/spark-container)


# Enable Docker to push to GCR
gcloud auth activate-service-account terraform-service-account@spark-container-dev.iam.gserviceaccount.com --key-file=./data_wrangling/sa.json

gcloud auth configure-docker

# Install Terraform
https://learn.hashicorp.com/tutorials/terraform/install-cli