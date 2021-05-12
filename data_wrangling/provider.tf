provider "google" {
  credentials = file("./sa.json")
  project     = ""
  region      = "us-central1"
  version     = "~> 2.5.0"
}