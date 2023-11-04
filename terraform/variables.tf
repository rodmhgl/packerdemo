variable "source_image_id" {
  type    = string
  default = null
}

variable "source_image_publisher" {
  type        = string
  description = "Value for the publisher field of the source image reference. Ignored if source_image_id is set."
  default     = "Canonical"
}

variable "source_image_offer" {
  type        = string
  description = "Value for the offer field of the source image reference. Ignored if source_image_id is set."
  default     = "0001-com-ubuntu-server-jammy"
}

variable "source_image_sku" {
  type        = string
  description = "Value for the sku field of the source image reference. Ignored if source_image_id is set."
  default     = "22_04-lts"
}

variable "source_image_version" {
  type        = string
  description = "Value for the version field of the source image reference. Ignored if source_image_id is set."
  default     = "latest"
}
