***
### Terraform-1

<details>
<summary>Вынесение переменных, форматирование кода, ключи проекта</summary>

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

</details>

***

### Terraform-2

<details>
<summary>Повышение переиспользуемости кода, модули</summary>

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

</details>

***

### Ansible-1

<details>
<summary>Работа со статическими инвентарными списками</summary>

В папке ansible можно найти инвентарный файл в трех форматах:
- ini
- yml
- json

- Спомощью [yaml-to-json-converter.py]() можно получить валидный json inventory из inventory-файла в форматe yaml
</details>

***

### Ansible-2

<details>
<summary>Компоновка списка заданий Ansible в файлы-сценарии </summary>

Импорт сценариев происходит спомощью перечисления в файле

sites.yml
```
---
- import_playbook: db.yml
- import_playbook: app.yml
- import_playbook: deploy.yml
```

Проверка плейбука
```
ansible-playbook sites.yml --ckeck
```

</details>

<details>
<summary>Работа с динамическими инвентарными списками</summary>
Пример вызова плейбука с динамическим инвентарным списком
```
ansible-playbook -i gce.py site.yml --check
```
для того, что бы инвентарный скрипт работал, необходимо получить токен и прописать в файле
gce.ini данные полученные из файла токена, который можно получить в настройках проекта gcp

```
[gce]
gce_service_account_email_address = client_email
gce_service_account_pem_file_path = /path_to_pem_file 
gce_project_id = project_id
```
добавлены ansible-provisioners в файлы сборки packer/app.json, packer/db.json
```
"provisioners": [
  {
    "type": "ansible",
    "playbook_file": "../ansible/packer_app.yml"
  }
```

</details>
