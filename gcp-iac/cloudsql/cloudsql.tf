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

module "sql-gitlab-primary-db" {
  source            = "GoogleCloudPlatform/sql-db/google//modules/postgresql"
  name              = "gitlab-primary"
  project_id        = local.service_project_id
  zone              = "asia-east1-b"
  region            = "asia-east1"
  availability_type = "ZONAL"
  # availability_type = "REGIONAL" # For high availability
  database_version  = "POSTGRES_14"
  tier              = "db-g1-small"
  # tier              = "db-custom-2-7680"
  db_name           = "gitlab"

  deletion_protection = false

  ip_configuration = {
    allocated_ip_range  = "private-gitlab-db-primary",
    authorized_networks = [],
    ipv4_enabled        = false,
    private_network     = "projects/${local.host_project_id}/global/networks/${local.shared_vpc_name}",
    require_ssl         = true
  }
}

module "sql-praefect-primary-db" {
  source            = "GoogleCloudPlatform/sql-db/google//modules/postgresql"
  name              = "praefect-primary"
  project_id        = local.service_project_id
  zone              = "asia-east1-b"
  region            = "asia-east1"
  availability_type = "ZONAL"
  # availability_type = "REGIONAL" # For high availability
  database_version  = "POSTGRES_14"
  tier              = "db-f1-micro"
  # tier              = "db-custom-2-7680"
  db_name           = "praefect"

  deletion_protection = false

  ip_configuration = {
    allocated_ip_range  = "private-gitlab-db-primary",
    authorized_networks = [],
    ipv4_enabled        = false,
    private_network     = "projects/${local.host_project_id}/global/networks/${local.shared_vpc_name}",
    require_ssl         = true
  }
}

module "sql-kasm-db" {
  source            = "GoogleCloudPlatform/sql-db/google//modules/postgresql"
  name              = "kasm"
  project_id        = local.service_project_id
  zone              = "asia-east1-b"
  region            = "asia-east1"
  availability_type = "ZONAL"
  # availability_type = "REGIONAL" # For high availability
  database_version  = "POSTGRES_14"
  tier              = "db-g1-small"
  # tier              = "db-custom-2-7680"
  db_name           = "kasm"

  deletion_protection = false

  ip_configuration = {
    allocated_ip_range  = "private-kasm-db",
    authorized_networks = [],
    ipv4_enabled        = false,
    private_network     = "projects/${local.host_project_id}/global/networks/${local.shared_vpc_name}",
    require_ssl         = true
  }
}
