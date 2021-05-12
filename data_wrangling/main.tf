# Configure GCP project
provider "google" {
  project = "spark-container-dev"
}
# Deploy image to Cloud Run
resource "google_cloud_run_service" "spark-standalone-notebook" {
  name     = "spark-standalone-notebook"
  location = "us-central1"
  template {
    spec {
      containers {
        image = "gcr.io/spark-container-dev/spark-notebook"
      }
    }
  }
  traffic {
    percent         = 100
    latest_revision = true
  }
}

# Enable public access on Cloud Run service
resource "google_cloud_run_service_iam_member" "allUsers" {
  location    = google_cloud_run_service.spark-standalone-notebook.location
  project     = google_cloud_run_service.spark-standalone-notebook.project
  service     = google_cloud_run_service.spark-standalone-notebook.name
  role     = "roles/run.invoker"
  member   = "allUsers"
}
# Return service URL
output "url" {
  value = "google_cloud_run_service.spark-standalone-notebook.status[0].url"
}
