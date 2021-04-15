# Configure GCP project
provider "google" {
  project = "spark-container-dev"
}
# Deploy image to Cloud Run
resource "google_cloud_run_service" "mywebapp" {
  name     = "mywebapp"
  location = "us-central1"
  template {
    spec {
      containers {
        image = "gcr.io/spark-container-dev/webapp"
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
  location    = google_cloud_run_service.mywebapp.location
  project     = google_cloud_run_service.mywebapp.project
  service     = google_cloud_run_service.mywebapp.name
  role     = "roles/run.invoker"
  member   = "allUsers"
}
# Return service URL
output "url" {
  value = "google_cloud_run_service.mywebapp.status[0].url"
}
