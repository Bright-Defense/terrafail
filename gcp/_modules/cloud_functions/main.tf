# ---------------------------------------------------------------------
# Cloud Functions
# ---------------------------------------------------------------------
resource "google_cloudfunctions_function" "TerraFailCloudFunctions" {
  # Drata: Specify a Service Account in [google_cloudfunctions_function.service_account_email] to avoid using default Service Accounts
  name                          = "TerraFailCloudFunctions"
  description                   = "TerraFailCloudFunctions description"
  runtime                       = "nodejs20"
  available_memory_mb           = 128
  trigger_http                  = true
  entry_point                   = "helloGET"
  ingress_settings              = "ALLOW_INTERNAL_AND_GCLB"
  vpc_connector_egress_settings = "ALL_TRAFFIC"
}

resource "google_cloudfunctions_function_iam_binding" "TerraFailCloudFunctions_iam_binding" {
  project        = google_cloudfunctions_function.TerraFailCloudFunctions.project
  region         = google_cloudfunctions_function.TerraFailCloudFunctions.region
  cloud_function = google_cloudfunctions_function.TerraFailCloudFunctions.name
  role           = "roles/viewer"
  members = [
    "user@terrafail.com",
  ]
}

resource "google_cloudfunctions_function_iam_member" "TerraFailCloudFunctions_iam_member" {
  project        = google_cloudfunctions_function.TerraFailCloudFunctions.project
  region         = google_cloudfunctions_function.TerraFailCloudFunctions.region
  cloud_function = google_cloudfunctions_function.TerraFailCloudFunctions.name
  role           = "roles/viewer"
  member         = "user@terrafail.com"
}
