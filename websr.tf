terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "3.5.0"
    }
  }
}

provider "google" {
  credentials = file("~/DevOps/websr_apache.json")

  project = "carbide-network-318418"
  region  = "europe-west4"
  zone    = "europe-west4-a"
}

resource "google_compute_network" "vpc_network" {
  name = "terraform-network"
}

resource "google_compute_instance" "vm_instance" {
  name         = "web-server"
  machine_type = "e2-small"

  tags = ["http-server", "https-server"]
  
   metadata = {
   ssh-keys = "dm:${file("~/.ssh/web_rsa.pub")}"
 }
  boot_disk {
    initialize_params {
      image = "ubuntu-2004-focal-v20210720"
    }
  }

  metadata_startup_script = file("~/my_project/websr1.sh")
  
  network_interface {
    network = "default"
    access_config {
    }
  }
}
