terraform {
}

provider "google" {
  project     = "mgmt-service-project-358707"
  region      = "asia-east1"
  credentials = file("~/Downloads/mgmt-host-project-358707-739cf0cf4afe.json")
}

provider "google-beta" {
  project     = "mgmt-service-project-358707"
  region      = "asia-east1"
  credentials = file("~/Downloads/mgmt-host-project-358707-739cf0cf4afe.json")
}

locals {
  host_project_id      = "mgmt-host-project-358707"
  service_project_id   = "mgmt-service-project-358707"
  shared_vpc_name      = "shared-workspace"
  shared_vpc_self_link = "https://www.googleapis.com/compute/v1/projects/${local.host_project_id}/global/networks/${local.shared_vpc_name}"
}

module "gcs_buckets_gitlab_artifact" {
  source          = "terraform-google-modules/cloud-storage/google"
  version         = "~> 2.2"
  project_id      = local.service_project_id
  names           = ["gitlab-artifact"]
  prefix          = "primary"
  location        = "ASIA-EAST1"
  storage_class   = "REGIONAL"
  set_admin_roles = false
  versioning = {
    first = true
  }
}

module "gcs_buckets_gitlab_backup" {
  source          = "terraform-google-modules/cloud-storage/google"
  version         = "~> 2.2"
  project_id      = local.service_project_id
  names           = ["gitlab-backup"]
  prefix          = "primary"
  location        = "ASIA-EAST1"
  storage_class   = "REGIONAL"
  set_admin_roles = false
  versioning = {
    first = true
  }
}

module "gcs_buckets_gitlab_restore" {
  source          = "terraform-google-modules/cloud-storage/google"
  version         = "~> 2.2"
  project_id      = local.service_project_id
  names           = ["gitlab-restore"]
  prefix          = "primary"
  location        = "ASIA-EAST1"
  storage_class   = "REGIONAL"
  set_admin_roles = false
  versioning = {
    first = true
  }
}

module "gcs_buckets_gitlab_dependencyProxy" {
  source          = "terraform-google-modules/cloud-storage/google"
  version         = "~> 2.2"
  project_id      = local.service_project_id
  names           = ["gitlab-dependencyProxy"]
  prefix          = "primary"
  location        = "ASIA-EAST1"
  storage_class   = "REGIONAL"
  set_admin_roles = false
  versioning = {
    first = true
  }
}

module "gcs_buckets_gitlab_externalDiffs" {
  source          = "terraform-google-modules/cloud-storage/google"
  version         = "~> 2.2"
  project_id      = local.service_project_id
  names           = ["gitlab-externalDiffs"]
  prefix          = "primary"
  location        = "ASIA-EAST1"
  storage_class   = "REGIONAL"
  set_admin_roles = false
  versioning = {
    first = true
  }
}

module "gcs_buckets_gitlab_lfs" {
  source          = "terraform-google-modules/cloud-storage/google"
  version         = "~> 2.2"
  project_id      = local.service_project_id
  names           = ["gitlab-lfs"]
  prefix          = "primary"
  location        = "ASIA-EAST1"
  storage_class   = "REGIONAL"
  set_admin_roles = false
  versioning = {
    first = true
  }
}

module "gcs_buckets_gitlab_packages" {
  source          = "terraform-google-modules/cloud-storage/google"
  version         = "~> 2.2"
  project_id      = local.service_project_id
  names           = ["gitlab-packages"]
  prefix          = "primary"
  location        = "ASIA-EAST1"
  storage_class   = "REGIONAL"
  set_admin_roles = false
  versioning = {
    first = true
  }
}

module "gcs_buckets_gitlab_terraformState" {
  source          = "terraform-google-modules/cloud-storage/google"
  version         = "~> 2.2"
  project_id      = local.service_project_id
  names           = ["gitlab-terraformState"]
  prefix          = "primary"
  location        = "ASIA-EAST1"
  storage_class   = "REGIONAL"
  set_admin_roles = false
  versioning = {
    first = true
  }
}

module "gcs_buckets_gitlab_uploads" {
  source          = "terraform-google-modules/cloud-storage/google"
  version         = "~> 2.2"
  project_id      = local.service_project_id
  names           = ["gitlab-uploads"]
  prefix          = "primary"
  location        = "ASIA-EAST1"
  storage_class   = "REGIONAL"
  set_admin_roles = false
  versioning = {
    first = true
  }
}

module "gcs_buckets_gitlab_registry" {
  source          = "terraform-google-modules/cloud-storage/google"
  version         = "~> 2.2"
  project_id      = local.service_project_id
  names           = ["gitlab-registry"]
  prefix          = "primary"
  location        = "ASIA-EAST1"
  storage_class   = "REGIONAL"
  set_admin_roles = false
  versioning = {
    first = true
  }
}

module "gcs_buckets_kasm_bucket" {
  source          = "terraform-google-modules/cloud-storage/google"
  version         = "~> 2.2"
  project_id      = local.service_project_id
  names           = ["kasm-bucket"]
  prefix          = ""
  location        = "ASIA-EAST1"
  storage_class   = "REGIONAL"
  set_admin_roles = false
  versioning = {
    first = true
  }
}

