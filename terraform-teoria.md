# Terraform — Teoria

## O que é e por que importa

Terraform (HashiCorp) é a ferramenta de Infraestrutura como Código (IaC) mais usada do mercado, multi-cloud — o mesmo código (com ajustes de provider) pode provisionar recursos na AWS, Azure, GCP, ou até serviços SaaS. Em vez de clicar no console pra criar recursos, você declara o estado desejado em arquivos `.tf` versionados no Git.

## Conceitos-chave

### 1. Provider
Plugin que conecta Terraform a uma plataforma (AWS, Azure, GCP, Kubernetes, etc.)

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
```

### 2. Resource
Bloco que declara um recurso a ser criado.

```hcl
resource "aws_s3_bucket" "meu_bucket" {
  bucket = "meu-bucket-terraform-lab"
}
```

### 3. Variables e Outputs

```hcl
variable "ambiente" {
  description = "Ambiente de deploy"
  type        = string
  default     = "dev"
}

output "bucket_arn" {
  value = aws_s3_bucket.meu_bucket.arn
}
```

### 4. State

Terraform mantém um arquivo de estado (`terraform.tfstate`) que mapeia os recursos declarados aos recursos reais na cloud. É crítico — perder o state ou tê-lo desincronizado causa sérios problemas. Em times, o state deve ficar em backend remoto (ex: S3 + DynamoDB pra lock).

### 5. Fluxo de trabalho

```bash
terraform init      # baixa providers e configura backend
terraform plan       # mostra o que será criado/alterado/destruído
terraform apply      # aplica as mudanças
terraform destroy    # remove tudo que foi criado
```

`terraform plan` é essencial — sempre revisar antes de aplicar, especialmente em produção.

### 6. Módulos

Blocos reutilizáveis de configuração — permitem empacotar um conjunto de recursos (ex: "VPC padrão da empresa") e reutilizar em múltiplos projetos.

```hcl
module "vpc" {
  source = "./modules/vpc"
  cidr   = "10.0.0.0/16"
}
```

### 7. Idempotência e drift

Terraform é idempotente: aplicar o mesmo código várias vezes resulta no mesmo estado final. "Drift" acontece quando alguém muda um recurso manualmente fora do Terraform — `terraform plan` detecta essa divergência.

## Por que isso conecta com o resto do roadmap

- **AWS/Azure/GCP** (módulo 03): Terraform provisiona recursos em qualquer um deles
- **Kubernetes**: o provider `kubernetes` do Terraform pode criar recursos K8s; também é comum usar Terraform pra provisionar o próprio cluster (EKS/AKS/GKE)
- **CI/CD**: pipelines rodam `terraform plan/apply` automaticamente a partir de mudanças no Git — a base do conceito de GitOps de infraestrutura

## Referências para aprofundar
- registry.terraform.io — catálogo de providers e módulos
- developer.hashicorp.com/terraform/docs
