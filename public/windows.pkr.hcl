# source "azure-arm" "windows" {
#   azure_tags = {
#     dept = "Engineering"
#     task = "Image deployment"
#   }
#   tenant_id                         = var.tenant_id
#   subscription_id                   = var.subscription_id
#   client_id                         = var.client_id
#   client_secret                     = var.client_secret
#   build_resource_group_name         = "myResourceGroup"
#   communicator                      = "winrm"
#   image_offer                       = "WindowsServer"
#   image_publisher                   = "MicrosoftWindowsServer"
#   image_sku                         = "2016-Datacenter"
#   managed_image_name                = "myPackerImageWindows"
#   managed_image_resource_group_name = "myResourceGroup"
#   os_type                           = "Windows"
#   vm_size                           = "Standard_D2_v2"
#   winrm_insecure                    = true
#   winrm_timeout                     = "5m"
#   winrm_use_ssl                     = true
#   winrm_username                    = "packer"
# }

# build {
#   sources = ["source.azure-arm.windows"]

#   provisioner "powershell" {
#     inline = ["Add-WindowsFeature Web-Server", "while ((Get-Service RdAgent).Status -ne 'Running') { Start-Sleep -s 5 }", "while ((Get-Service WindowsAzureGuestAgent).Status -ne 'Running') { Start-Sleep -s 5 }", "& $env:SystemRoot\\System32\\Sysprep\\Sysprep.exe /oobe /generalize /quiet /quit", "while($true) { $imageState = Get-ItemProperty HKLM:\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Setup\\State | Select ImageState; if($imageState.ImageState -ne 'IMAGE_STATE_GENERALIZE_RESEAL_TO_OOBE') { Write-Output $imageState.ImageState; Start-Sleep -s 10  } else { break } }"]
#   }

# }