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

# Create GKE for GitLab
module "gke" {
  source                     = "terraform-google-modules/kubernetes-engine/google//modules/private-cluster"
  project_id                 = local.service_project_id
  name                       = "workspace-primary-gke"
  region                     = "asia-east1"
  zones                      = ["asia-east1-b"]
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

  node_pools = [
    {
      name               = "primary-webservice"
      machine_type       = "n1-highcpu-16"
      node_locations     = "asia-east1-b"
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
      service_account    = "primary-gke-sa@mgmt-service-project-358707.iam.gserviceaccount.com"
      preemptible        = false
      # initial_node_count = 2
      initial_node_count = 1
      enable_secure_boot = true
    },
    {
      name               = "primary-sidekiq"
      machine_type       = "n1-standard-4"
      node_locations     = "asia-east1-b"
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
      service_account    = "primary-gke-sa@mgmt-service-project-358707.iam.gserviceaccount.com"
      preemptible        = false
      # initial_node_count = 3
      initial_node_count = 1
      enable_secure_boot = true
    },
    {
      name               = "primary-others"
      machine_type       = "n1-standard-4"
      node_locations     = "asia-east1-b"
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
      service_account    = "primary-gke-sa@mgmt-service-project-358707.iam.gserviceaccount.com"
      preemptible        = false
      # initial_node_count = 1
      initial_node_count = 1
      enable_secure_boot = true
    },
    {
      name               = "kasm"
      machine_type       = "n1-standard-4"
      node_locations     = "asia-east1-b"
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
      service_account    = "primary-gke-sa@mgmt-service-project-358707.iam.gserviceaccount.com"
      preemptible        = false
      # initial_node_count = 1
      initial_node_count = 1
      enable_secure_boot = true
    },
    {
      name               = "gitlab-runner"
      machine_type       = "n1-standard-4"
      node_locations     = "asia-east1-b"
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
      service_account    = "primary-gke-sa@mgmt-service-project-358707.iam.gserviceaccount.com"
      preemptible        = false
      # initial_node_count = 1
      initial_node_count = 1
      enable_secure_boot = true
    }
  ]
}
