terraform {
}

locals {
  project     = "playground-s-11-96a01031"
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

locals {
  host_project_id      = local.project
  service_project_id   = local.project
  shared_vpc_name      = "gke-vpc"
  regional_kms         = "projects/playground-s-11-96a01031/locations/us-central1/keyRings/global-key-ring/cryptoKeys/regional-key"
}

# Create Sa for gke node

resource "google_service_account" "gke_service_account" {
  account_id   = "primary-gke-sa"
  display_name = "primary-gke-sa"
}

data "google_service_account" "gke_service_account" {
  account_id = "primary-gke-sa"
}

# Create GKE for GitLab
module "gke" {
  source                     = "terraform-google-modules/kubernetes-engine/google//modules/private-cluster"
  project_id                 = local.service_project_id
  name                       = "workspace-primary-gke"
  region                     = local.region
  zones                      = ["us-central1-b"]
  network_project_id         = local.host_project_id
  network                    = local.shared_vpc_name
  subnetwork                 = "gcp-mgmt-sub-primary-gke"
  ip_range_pods              = "pod-cidr"
  ip_range_services          = "svc-cidr"
  http_load_balancing        = true
  network_policy             = true
  horizontal_pod_autoscaling = true
  filestore_csi_driver       = true
  remove_default_node_pool   = true
  enable_private_endpoint    = true
  enable_private_nodes       = true
  enable_shielded_nodes      = true
  master_ipv4_cidr_block     = "10.100.0.0/28"
  master_authorized_networks = [{ cidr_block = "10.10.0.0/24", display_name = "gcp-mgmt-sub-mig" }]

  database_encryption {
    state = "ENCRYPTED"
    key_name = local.regional_kms
  }

  node_pools = [
    {
      name               = "primary-webservice"
      machine_type       = "n1-highcpu-16"
      node_locations     = "us-central1-b"
      # min_count          = 2
      # max_count          = 3
      min_count          = 1
      max_count          = 1
      local_ssd_count    = 0
      spot               = false
      disk_size_gb       = 100
      disk_type          = "pd-standard"
      image_type         = "COS_CONTAINERD"
      enable_gcfs        = false
      enable_gvnic       = false
      auto_repair        = true
      auto_upgrade       = true
      service_account    = data.google_service_account.gke_service_account.email
      preemptible        = false
      # initial_node_count = 2
      initial_node_count = 1
      enable_secure_boot = true
    },
    {
      name               = "primary-sidekiq"
      machine_type       = "n1-standard-4"
      node_locations     = "us-central1-b"
      # min_count          = 3
      # max_count          = 4
      min_count          = 1
      max_count          = 1
      local_ssd_count    = 0
      spot               = false
      disk_size_gb       = 100
      disk_type          = "pd-standard"
      image_type         = "COS_CONTAINERD"
      enable_gcfs        = false
      enable_gvnic       = false
      auto_repair        = true
      auto_upgrade       = true
      service_account    = data.google_service_account.gke_service_account.email
      preemptible        = false
      # initial_node_count = 3
      initial_node_count = 1
      enable_secure_boot = true
    },
    {
      name               = "primary-others"
      machine_type       = "n1-standard-4"
      node_locations     = "us-central1-b"
      # min_count          = 1
      # max_count          = 2
      min_count          = 1
      max_count          = 1
      local_ssd_count    = 0
      spot               = false
      disk_size_gb       = 100
      disk_type          = "pd-standard"
      image_type         = "COS_CONTAINERD"
      enable_gcfs        = false
      enable_gvnic       = false
      auto_repair        = true
      auto_upgrade       = true
      service_account    = data.google_service_account.gke_service_account.email
      preemptible        = false
      # initial_node_count = 1
      initial_node_count = 1
      enable_secure_boot = true
    },
    {
      name               = "kasm"
      machine_type       = "n1-standard-4"
      node_locations     = "us-central1-b"
      # min_count          = 1
      # max_count          = 2
      min_count          = 1
      max_count          = 1
      local_ssd_count    = 0
      spot               = false
      disk_size_gb       = 100
      disk_type          = "pd-standard"
      image_type         = "COS_CONTAINERD"
      enable_gcfs        = false
      enable_gvnic       = false
      auto_repair        = true
      auto_upgrade       = true
      service_account    = data.google_service_account.gke_service_account.email
      preemptible        = false
      # initial_node_count = 1
      initial_node_count = 1
      enable_secure_boot = true
    },
    {
      name               = "gitlab-runner"
      machine_type       = "n1-standard-4"
      node_locations     = "us-central1-b"
      # min_count          = 1
      # max_count          = 2
      min_count          = 1
      max_count          = 1
      local_ssd_count    = 0
      spot               = false
      disk_size_gb       = 100
      disk_type          = "pd-standard"
      image_type         = "COS_CONTAINERD"
      enable_gcfs        = false
      enable_gvnic       = false
      auto_repair        = true
      auto_upgrade       = true
      service_account    = data.google_service_account.gke_service_account.email
      preemptible        = false
      # initial_node_count = 1
      initial_node_count = 1
      enable_secure_boot = true
    }
  ]

  node_pools_tags = {
    all = [
      "all-node-example",
    ]
    pool-01 = [
      "pool-01-example",
    ]
  }
}
