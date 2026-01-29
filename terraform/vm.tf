resource "yandex_compute_instance" "vm" {
  count = var.vm_count

  name        = local.vm_names[count.index]
  hostname    = local.vm_hostnames[count.index]
  platform_id = var.vm_platform_id
  zone        = var.default_zone

  # Ресурсы ВМ
  resources {
    cores         = var.vm_cores
    memory        = var.vm_memory_gb
    core_fraction = var.vm_core_fraction
  }

  # Прерываемость
  scheduling_policy {
    preemptible = var.vm_preemptible
  }

  # Загрузочный диск
  boot_disk {
    initialize_params {
      image_id = var.vm_image_id
      type     = var.vm_disk_type
      size     = var.vm_boot_disk_size_gb
    }
  }

  # Сетевое подключение
  network_interface {
    subnet_id = yandex_vpc_subnet.main.id
    nat       = var.vm_enable_nat
  }

  # SSH доступ
  metadata = {
    ssh-keys = "${var.vm_ssh_user}:${local.ssh_public_key}"
  }

  allow_stopping_for_update = var.allow_stopping_for_update
}