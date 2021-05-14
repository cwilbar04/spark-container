provider "google" {
  credentials = file("./sa.json")
  project     = "spark-container-test"
  region      = "us-central1"
}