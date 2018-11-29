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
