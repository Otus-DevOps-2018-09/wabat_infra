variable project {
  description = "project"
  default     = ""
}

variable db_disk_image {
  description = "image"
  default     = "db-reddit-1542528658"
}

variable public_key_path {
  description = "public_key_path"
  default     = "~/.ssh/appuser.pub"
}

variable zone {
  description = "Zone"
  default     = "europe-west1-b"
}

variable region {
  description = "Region"
  default     = "europe-west1"
}

variable instance_count {
  description = "instance count"
  default     = 1
}
