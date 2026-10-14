# Terraform — Lab Prático

## Pré-requisitos
- Terraform instalado (`terraform -version`)
- Credenciais AWS configuradas (`aws configure`) — ou adapte pro provider que preferir

---

## Lab 1 — Primeiro recurso (S3 bucket)

Os arquivos já estão em `labs/terraform`. O bucket bloqueia acesso público, cifra com AES256 e aceita `terraform destroy` mesmo com objeto dentro (`force_destroy`).

```bash
cd labs/terraform
terraform init
terraform plan
terraform apply
```

O `main.tf` do lab, sem o bloqueio público e a cifra que o repositório acrescenta:

```hcl
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "sa-east-1"
}

resource "aws_s3_bucket" "lab" {
  bucket = "lab-terraform-${random_id.sufixo.hex}"
}

resource "random_id" "sufixo" {
  byte_length = 4
}

output "nome_bucket" {
  value = aws_s3_bucket.lab.bucket
}
```

O bloco acima é o mínimo do lab. No repositório, `labs/terraform` já inclui variável, tag, módulo, bloqueio público e cifra. Use os comandos do começo desta seção, não uma pasta `lab-terraform`.

---

## Lab 2 — Variáveis

`labs/terraform/variables.tf` já tem `ambiente` (padrão `dev`) e `alerta_email`. O mínimo do lab:

```hcl
variable "ambiente" {
  type    = string
  default = "dev"
}
```

Adicione tags ao bucket em `main.tf`:

```hcl
resource "aws_s3_bucket" "lab" {
  bucket = "lab-terraform-${random_id.sufixo.hex}"
  tags = {
    Ambiente = var.ambiente
  }
}
```

```bash
terraform plan -var="ambiente=staging"
terraform apply -var="ambiente=staging"
```

---

## Lab 3 — Detectando drift

```bash
# mude algo manualmente pelo console AWS (ex: adicione uma tag no bucket)
# depois rode:
terraform plan
# Terraform vai mostrar a diferença entre o state e o real
```

---

## Lab 4 — Módulo simples

O módulo já está em `labs/terraform/modules/bucket-lab` e o `main.tf` chama `bucket_extra`. O mínimo do lab:

```hcl
variable "nome_bucket" {
  type = string
}

resource "aws_s3_bucket" "este" {
  bucket = var.nome_bucket
}

output "arn" {
  value = aws_s3_bucket.este.arn
}
```

No `main.tf` raiz:

```hcl
module "bucket_extra" {
  source      = "./modules/bucket-lab"
  nome_bucket = "lab-terraform-modulo-${random_id.sufixo.hex}"
}
```

```bash
terraform init   # reinicializa pra reconhecer o módulo
terraform apply
```

---

## Limpeza (importante!)

```bash
terraform destroy
```

## Checklist de conclusão
- [ ] Criei um recurso simples e apliquei com `terraform apply`
- [ ] Usei variáveis pra parametrizar o recurso
- [ ] Observei drift entre state e recurso real
- [ ] Criei e usei um módulo reutilizável
- [ ] Rodei `terraform destroy` ao final

## Notas / Troubleshooting
> Preencha aqui problemas reais (ex: erro de lock de state, credenciais expiradas, conflito de nome de bucket já existente globalmente).
