provider "google" {
  credentials = file("service-account-key.json")
  project     = "prueba-cenco"
  region      = "us-central1"
}