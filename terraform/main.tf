provider "google" {
  version = "~> 1.19"
  project = "${var.project}"
  region  = "${var.region}"
}

resource "google_compute_project_metadata_item" "add" {
  key   = "ssh-keys"
  value = "appuser1:${file(var.public_key_path)}appuser2:${file(var.public_key_path)}"
}

resource "google_compute_instance" "app" {
  name         = "reddit-app"
  machine_type = "g1-small"
  zone         = "${var.zone}"
  tags         = ["reddit-app"]

  # определение загрузочного диска
  boot_disk {
    initialize_params {
      image = "reddit-base"
    }
  }

  metadata {
    ssh-keys = "appuser:${file(var.public_key_path)}"
  }

  tags = ["reddit-app"]

  network_interface {
    # сеть, к которой присоединить данный интерфейс
    network       = "default"
    access_config = {}
  }

  connection {
    type  = "ssh"
    user  = "appuser"
    agent = false

    #key used for deploy-scripts
    private_key = "${file(var.private_key_path)}"
  }

  provisioner "file" {
    source      = "files/puma.service"
    destination = "/tmp/puma.service"
  }

  provisioner "remote-exec" {
    script = "files/deploy.sh"
  }
}

resource "google_compute_firewall" "firewall_puma" {
  name    = "allow-puma-default"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["9292"]
  }

  # Каким адресам разрешаем доступ   
  source_ranges = ["0.0.0.0/0"]

  # Правило применимо для инстансов с перечисленными тэгами   
  target_tags = ["reddit-app"]
}