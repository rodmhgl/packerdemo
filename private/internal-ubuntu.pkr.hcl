# This will attempt to build an image within a internal-only subnet
# Should time out during "Waiting for SSH to become available" step
packer {
  required_plugins {
    azure = {
      source  = "github.com/hashicorp/azure"
      version = "~> 1"
    }
  }
}

variable "tenant_id" {
  type = string
}

variable "subscription_id" {
  type = string
}

variable "client_id" {
  type = string
}

variable "client_secret" {
  type = string
}

source "azure-arm" "linux" {
  azure_tags = {
    dept = "Engineering"
    task = "Image deployment"
  }
  build_resource_group_name         = "rg-packer-playground"
  virtual_network_name              = "this-network"
  tenant_id                         = var.tenant_id
  subscription_id                   = var.subscription_id
  client_id                         = var.client_id
  client_secret                     = var.client_secret
  image_offer                       = "0001-com-ubuntu-server-jammy"
  image_publisher                   = "canonical"
  image_sku                         = "22_04-lts"
  managed_image_name                = "myPackerImage-internal-laptop"
  virtual_network_subnet_name       = "sn-packer-builders"
  virtual_network_resource_group_name = "rg-packer-playground"
  managed_image_resource_group_name = "myResourceGroup"
  os_type                           = "Linux"
  vm_size                           = "Standard_DS2_v2"
}

build {
  sources = ["source.azure-arm.linux"]

  provisioner "shell" {
    execute_command = "chmod +x {{ .Path }}; {{ .Vars }} sudo -E sh '{{ .Path }}'"
    inline          = [
        "apt-get update",
        "apt-get upgrade -y",
        "apt-get -y install nginx",
        "curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -",
        "sudo apt-add-repository \"deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main\"",
        "sudo apt-get update && sudo apt-get install packer",
        "/usr/sbin/waagent -force -deprovision+user && export HISTSIZE=0 && sync"
        ]
    inline_shebang  = "/bin/sh -x"
  }

}