variable project {
  description = "project"
  default     = ""
}

variable app_disk_image {
  description = "image"
  default     = "app-reddit-1542528383"
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
