variable project {
  description = "project"
  default     = "shaped-totem-219816"
}

variable region {
  description = "Region"
  default     = "europe-west1"
}

variable private_key_path {
  description = ""
  default     = "~/.ssh/appuser"
}

variable public_key_path {
  description = "public_key_path"
  default     = "~/.ssh/appuser.pub"
}

variable disk_image {
  description = "image"
  default     = "reddit-base"
}

variable app_disk_image {
  description = "appimage"
  default     = "app-reddit-1542528383"
}

variable db_disk_image {
  description = "appimage"
  default     = "db-reddit-1542528658"
}

variable zone {
  description = "Zone"
  default     = "europe-west1-b"
}

variable instance_count {
  description = "instance count"
  default     = 1
}
