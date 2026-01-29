output "vm_external_ips" {
  value = {
    for idx, vm in yandex_compute_instance.vm :
    vm.name => vm.network_interface[0].nat_ip_address
  }
  description = "Внешние IP-адреса ВМ для подключения"
}

output "vm_internal_ips" {
  value = {
    for idx, vm in yandex_compute_instance.vm :
    vm.name => vm.network_interface[0].ip_address
  }
  description = "Внутренние IP-адреса ВМ"
}

output "vm_fqdns" {
  value = {
    for idx, vm in yandex_compute_instance.vm :
    vm.name => vm.fqdn
  }
  description = "Внутренние FQDN ВМ"
}

output "ssh_connection_commands" {
  value = [
    for vm in yandex_compute_instance.vm :
    "ssh ${var.vm_ssh_user}@${vm.network_interface[0].nat_ip_address} -i ${replace(var.ssh_public_key_path, ".pub", "")}"
  ]
  description = "Команды для подключения по SSH"
}

output "configuration_summary" {
  value = <<-EOT
  Создано ${var.vm_count} ВМ в зоне ${var.default_zone}

  Параметры ВМ:
  - Платформа: ${var.vm_platform_id}
  - Ресурсы: ${var.vm_cores} vCPU, ${var.vm_memory_gb} ГБ RAM
  - Диск: ${var.vm_boot_disk_size_gb} ГБ (${var.vm_disk_type})
  - Тип: ${var.vm_preemptible ? "Прерываемая" : "Обычная"}
  - Публичный IP: ${var.vm_enable_nat ? "Да" : "Нет"}

  Имена ВМ: ${join(", ", local.vm_names)}
  EOT
}