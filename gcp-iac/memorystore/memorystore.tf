terraform {
}

provider "google" {
  project     = "	mgmt-service-project-358707"
  region      = "asia-east1"
  credentials = file("~/Downloads/mgmt-host-project-358707-739cf0cf4afe.json")
}

provider "google-beta" {
  project     = "	mgmt-service-project-358707"
  region      = "asia-east1"
  credentials = file("~/Downloads/mgmt-host-project-358707-739cf0cf4afe.json")
}

locals {
  host_project_id      = "mgmt-host-project-358707"
  service_project_id   = "mgmt-service-project-358707"
  shared_vpc_name      = "shared-workspace"
  shared_vpc_self_link = "https://www.googleapis.com/compute/v1/projects/${local.host_project_id}/global/networks/${local.shared_vpc_name}"
}

resource "google_redis_instance" "gitlab-primary" {
  project = local.service_project_id
  region  = "asia-east1"

  name = "gitlab-primary"
  tier = "BASIC"
  # tier = "STANDARD_HA"
  memory_size_gb = "1"

  location_id = "asia-east1-b"

  connect_mode            = "PRIVATE_SERVICE_ACCESS"
  authorized_network      = "projects/${local.host_project_id}/global/networks/${local.shared_vpc_name}"
  reserved_ip_range       = "private-gitlab-redis-primary"
  redis_version           = "REDIS_4_0"
  transit_encryption_mode = "SERVER_AUTHENTICATION"

  # customer_managed_key = TODO
}

resource "google_redis_instance" "kasm" {
  project = local.service_project_id
  region  = "asia-east1"

  name = "kasm"
  tier = "BASIC"
  # tier = "STANDARD_HA"
  memory_size_gb = "1"

  location_id = "asia-east1-b"

  connect_mode            = "PRIVATE_SERVICE_ACCESS"
  auth_enabled            = true
  authorized_network      = "projects/${local.host_project_id}/global/networks/${local.shared_vpc_name}"
  reserved_ip_range       = "private-kasm-redis"
  redis_version           = "REDIS_4_0"
  transit_encryption_mode = "DISABLED"

  # customer_managed_key = TODO
}

