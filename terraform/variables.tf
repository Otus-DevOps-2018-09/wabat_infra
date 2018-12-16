variable project {
  description = "Project ID"
}

variable region {
  description = "Region"
  default     = "europe-west1"
}

variable zone {
  default = "europe-west1-b"
}

variable public_key_path {
  description = "public_key_path"
  default     = "~/.ssh/appuser.pub"
}
