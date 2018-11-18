## Terraform-1
1. Переменная приватного ключа 
```
${file(var.private_key_path)}
```
2. Переменная зоны 
```
${var.zone}
```
3. Форматирование конфгурационных файлов (rewrite Terraform configuration files to a canonical format and style)
```
terraform fmt
```
* 
Добавить несколько ключей можно такой инструкцией
```
resource "google_compute_project_metadata_item" "add" {
  key   = "ssh-keys"
  value = "appuser1:${file(var.public_key_path)}appuser2:${file(var.public_key_path)}"
}
```
ключи добавленные вручную будут перезаписаны

8
## Terraform-2

1. В папке с модулями находятся файлы, ссылаясь на которые можно повысить переиспользуемсть кода
```
provider "google" {
  version = "~> 1.19"
  project = "${var.project}"
  region  = "${var.region}"
}

module "app" {
  source          = "modules/app"
  public_key_path = "${var.public_key_path}"
  zone            = "${var.zone}"
  app_disk_image  = "${var.app_disk_image}"
}

module "db" {
  source          = "modules/db"
  public_key_path = "${var.public_key_path}"
  zone            = "${var.zone}"
  db_disk_image   = "${var.db_disk_image}"
}

module "vpc" {
  source = "modules/vpc"
}
```
2. Работая с удаленными репозиториями, можно избежать многих неудобств использования локального backend
```
provider "google" {
  version = "1.4.0"
}

module "storage-bucket" {
  source  = "SweetOps/storage-bucket/google"
  version = "0.1.1"
  name    = ["storage-bucket-test", "storage-bucket-test2"]
}

output storage-bucket_url {
  value = "${module.storage-bucket.url}"
}
```
