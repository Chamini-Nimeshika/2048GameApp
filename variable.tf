variable "localIp" {
  description = "defining local ip of my pc"
  type        = string
}

variable "container_image" {
  description = "Image the VM runs on the first boot"
  type        = string
}

variable "github_repo" {
  description = "GitHub repo allowed to deploy, as owner/name, capitalized exactly like the URL"
  type        = string
}