## wabat_infra [![Build Status](https://travis-ci.com/Otus-DevOps-2018-09/wabat_infra.svg?branch=master)](https://travis-ci.com/Otus-DevOps-2018-09/wabat_infra)

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

- Спомощью [yaml-to-json-converter.py](https://github.com/Otus-DevOps-2018-09/wabat_infra/blob/master/ansible/yaml-to-json-converter.py) можно получить валидный json inventory из inventory-файла в форматe yaml
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


***
### Ansible-3

<details>
<summary>role structure</summary>

```
roles/
    common/               # this hierarchy represents a "role"
        tasks/            #
            main.yml      #  <-- tasks file can include smaller files if warranted
        handlers/         #
            main.yml      #  <-- handlers file
        meta/             #
        templates/        #  <-- files for use with the template resource
            ntp.conf.j2   #  <------- templates end in .j2
        files/            #
            bar.txt       #  <-- files for use with the copy resource
            foo.sh        #  <-- script files for use with the script resource
        vars/             #
            main.yml      #  <-- variables associated with this role
        defaults/         #
            main.yml      #  <-- default lower priority variables for this role
            main.yml      #  <-- role dependencies
        library/          # roles can also include custom modules
        module_utils/     # roles can also include custom module_utils
        lookup_plugins/   # or other types of plugins, like lookup in this case

    webtier/              # same kind of structure as "common" was above, done for the webtier role
    monitoring/           # ""
    fooapp/ 
```

</details>

<details>
<summary>enviroments</summary>

This layout gives you more flexibility for larger environments, as well as a total separation of inventory variables between different environments. The downside is that it is harder to maintain, because there are more files.

Using debug for environment variables checkout in task list for current enviroment

```
# tasks file for app
- name: Show info about the env this host belongs to
  debug:
    msg: "This host is in {{ env }} environment!!!"
```

</details>


Установка ролей через зависимости.
Файл ansible/enviroments/prod/requirements.yml

```
- src: jdauphant.nginx
  version: v2.21.1
```

Настройка тестов для проверки и валидации конфигураций packer и terraform 
файл [.travis.yml] (https://github.com/Otus-DevOps-2018-09/wabat_infra/blob/master/.travis.yml)

***
### Ansible-4

<details>
<summary>Разработка ролей с Vagrant</summary>

описание конфигурации находится в файле vagrant

переопределение переменных секция ansible.extra_vars имеет высший приоритет

импорт роли nginx отсуществляется через файл app.yml

#### тестирование

ansible/requirements.txt

ansible>=2.4
molecule>=2.6
testinfra>=1.10
python-vagrant>=0.5.15

инициализация проекта molecule

```
molecule init scenario --scenario-name default -r db -d vagrant
```

сами тесты molecule/default/tests/test_default.py
описание тестовой машины находится molecule/default/molecule.yml
подключние к машине molecule login -h instance
посмотреть описание к tesinfra модулям https://testinfra.readthedocs.io/en/latest/modules.html

</details>
