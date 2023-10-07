provider "google" {
  credentials = file("prueba-cenco-42fe19a389f5.json")
  project     = "prueba-cenco"
  region      = "us-central1" # Change to your desired region
}