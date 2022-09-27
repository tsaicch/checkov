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

module "instance_template_praefect" {
  source             = "terraform-google-modules/vm/google//modules/instance_template"
  project_id         = local.service_project_id
  subnetwork_project = local.host_project_id
  network            = local.shared_vpc_self_link
  subnetwork         = "gcp-mgmt-sub-mig"
  service_account = {
    email  = "gitlab-praefect@mgmt-service-project-358707.iam.gserviceaccount.com"
    scopes = ["cloud-platform"]
  }
  enable_shielded_vm   = true
  machine_type         = "n1-highcpu-2"
  disk_size_gb         = "50"
  name_prefix          = "praefect-template"
  region               = "asia-east1"
  source_image_family  = "cos-97-lts"
  source_image_project = "cos-cloud"
  tags                 = ["gitlab-praefect"]
}

module "mig_praefect" {
  source             = "terraform-google-modules/vm/google//modules/mig"
  project_id         = local.service_project_id
  network            = local.shared_vpc_self_link
  subnetwork_project = local.host_project_id
  subnetwork         = "gcp-mgmt-sub-mig"
  target_size        = 3
  hostname           = "mig-praefect"
  instance_template  = module.instance_template_praefect.self_link
  region             = "asia-east1"
}

module "instance_template_gitaly" {
  source             = "terraform-google-modules/vm/google//modules/instance_template"
  project_id         = local.service_project_id
  subnetwork_project = local.host_project_id
  network            = local.shared_vpc_self_link
  subnetwork         = "gcp-mgmt-sub-mig"
  service_account = {
    email  = "gitlab-gitaly@mgmt-service-project-358707.iam.gserviceaccount.com"
    scopes = ["cloud-platform"]
  }
  enable_shielded_vm = true
  # machine_type         = "n1-standard-4"
  machine_type         = "n1-standard-2"
  disk_size_gb         = "50"
  disk_type            = "pd-ssd"
  name_prefix          = "gitaly-template"
  region               = "asia-east1"
  source_image_family  = "cos-97-lts"
  source_image_project = "cos-cloud"
  tags                 = ["gitlab-gitaly"]
}

module "mig_gitaly" {
  source             = "terraform-google-modules/vm/google//modules/mig"
  project_id         = local.service_project_id
  network            = local.shared_vpc_self_link
  subnetwork_project = local.host_project_id
  subnetwork         = "gcp-mgmt-sub-mig"
  target_size        = 3
  hostname           = "mig-gitaly"
  instance_template  = module.instance_template_gitaly.self_link
  region             = "asia-east1"
}

module "instance_template_kasm_agent" {
  source             = "terraform-google-modules/vm/google//modules/instance_template"
  project_id         = local.service_project_id
  subnetwork_project = local.host_project_id
  network            = local.shared_vpc_self_link
  subnetwork         = "gcp-mgmt-sub-mig"
  service_account = {
    email  = "kasm-agent@mgmt-service-project-358707.iam.gserviceaccount.com"
    scopes = ["cloud-platform"]
  }
  enable_shielded_vm = true
  # machine_type         = "n1-standard-4"
  machine_type         = "n1-standard-2"
  disk_size_gb         = "50"
  disk_type            = "pd-ssd"
  name_prefix          = "kasm-agent-template"
  region               = "asia-east1"
  source_image_project = "mgmt-service-project-358707"
  source_image_family  = "kasm-agent"
  source_image         = "kasm-agent-111018142e"
  tags                 = ["kasm-agent"]
}

module "mig_kasm_agent" {
  source             = "terraform-google-modules/vm/google//modules/mig"
  project_id         = local.service_project_id
  network            = local.shared_vpc_self_link
  subnetwork_project = local.host_project_id
  subnetwork         = "gcp-mgmt-sub-mig"
  target_size        = 1
  hostname           = "mig-kasm-agent"
  instance_template  = module.instance_template_kasm_agent.self_link
  region             = "asia-east1"
}

