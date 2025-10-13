packer {
  required_plugins {
    qemu = {
      version = ">= 1.1.4"
      source  = "github.com/hashicorp/qemu"
    }
  }
}

variable "iso_url" {
  type = string
}

variable "iso_checksum" {
  type = string
}

variable "version_short" {
  type = string
}

source "qemu" "ubuntu" {
  iso_url      = var.iso_url
  iso_checksum = var.iso_checksum
  output_directory = "output"
  shutdown_command = "echo 'ubuntu' | sudo -S poweroff"
  disk_size    = "10000M"
  format       = "qcow2"
  accelerator  = "kvm"
  http_directory = "http"
  ssh_username = "ubuntu"
  ssh_password = "ubuntu"
  ssh_timeout  = "20m"
  vm_name      = "ubuntu-${var.version_short}-x86_64-v3.qcow2"
  net_device   = "virtio-net"
  disk_interface = "virtio"
  memory       = 2048
  cpus         = 2
  efi_boot     = true
  efi_firmware_code = "/usr/share/OVMF/OVMF_CODE.fd"
  efi_firmware_vars = "/usr/share/OVMF/OVMF_VARS.fd"
  boot_wait    = "5s"
  boot_command = [
    "c<wait>",
    "linux /casper/vmlinuz --- autoinstall ds=nocloud-net\\;s=http://{{ .HTTPIP }}:{{ .HTTPPort }}/",
    "<enter><wait>",
    "initrd /casper/initrd",
    "<enter><wait>",
    "boot",
    "<enter>"
  ]
  qemuargs = [
    ["-cpu", "x86-64-v3"]
  ]
}

build {
  sources = ["source.qemu.ubuntu"]
}
