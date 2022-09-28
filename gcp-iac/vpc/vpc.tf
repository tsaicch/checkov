terraform {
}

locals {
  project     = "playground-s-11-5df34e0c"
  region      = "us-central1"
}

provider "google" {
  project     = local.project
  region      = local.region
}

provider "google-beta" {
  project     = local.project
  region      = local.region
}

resource "google_compute_network" "vpc_network" {
  name = "gke-vpc"
}

resource "google_compute_subnetwork" "gcp-mgmt-sub-primary-gke" {
  name = "gcp-mgmt-sub-primary-gke"
  ip_cidr_range = "10.2.0.0/16"
  region = local.region
  network = google_compute_network.vpc_network.name
  secondary_ip_range { 
    range_name = "pod-cidr" 
    ip_cidr_range = "192.168.10.0/24" 
  }
  secondary_ip_range { 
    range_name = "svc-cidr" 
    ip_cidr_range = "192.168.20.0/24" 
  }
}
