

// Set the bucket name
variable "bucket_name" {
    description = "bucket name"
}

// Create the GCS Bucket
resource "google_storage_bucket" "waficash-gke_bucket" {
  name          = var.bucket_name
  location      = "US"
  force_destroy = true

  // Enable Uniform bucket-level access
  uniform_bucket_level_access = true
}

// Add the necessary permissions for GCR
resource "google_storage_bucket_iam_member" "gcr_member" {
  bucket      = google_storage_bucket.waficash-gke_bucket.name
  role        = "roles/storage.objectAdmin"
  member      = "serviceAccount:service-${data.google_project.project.number}@containerregistry.iam.gserviceaccount.com"
}

// Fetch the project's metadata to get the project number
data "google_project" "project" {}

