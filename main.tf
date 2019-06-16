variable "project_id" {
  type = "string"
}

provider "google" {
  project = var.project_id
  region = "us-central1"
  zone = "us-central1-c"
}

resource "google_compute_instance" "vm_instance" {
  name = "log-access-analytics"
  machine_type = "n1-standard-4"
  tags = ["http"]

  network_interface {
    network = "default"
    access_config {
    }
  }

  boot_disk {
    initialize_params {
      image = "log-access-analytics"
    }
  }
}

resource "google_compute_firewall" "allow_http" {
  name = "http"
  network = "default"

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports = [
      "80",
      "8080",
      "8082",
      "8084"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags = ["http"]
}

terraform {
  backend "gcs" {
    bucket  = "tf-state-laaa"
    prefix  = "terraform/state"
  }
}

data "terraform_remote_state" "state" {
  backend = "gcs"
  config = {
    bucket = "tf-state-laaa"
    prefix  = "terraform/state"
  }
}

output "ip" {
  value = google_compute_instance.vm_instance.network_interface[0].access_config[0].nat_ip
}