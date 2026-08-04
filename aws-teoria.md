# AWS — Teoria

## O que é e por que importa em DevOps

AWS (Amazon Web Services) é o maior provedor de cloud computing do mundo. Em DevOps, cloud providers substituem a necessidade de comprar e manter servidores físicos — você provisiona infraestrutura sob demanda, paga pelo uso e automatiza tudo via API/CLI/IaC (Terraform, módulo 04).

## Conceitos-chave

### 1. Regiões e Zonas de Disponibilidade (AZs)

- **Região**: área geográfica (ex: `us-east-1`, `sa-east-1` em São Paulo)
- **AZ**: datacenter isolado dentro de uma região — distribuir recursos entre AZs garante alta disponibilidade

### 2. IAM (Identity and Access Management)

Controla quem pode fazer o quê na conta AWS.

- **Users**: identidades individuais
- **Groups**: coleções de usuários com as mesmas permissões
- **Roles**: identidade temporária assumida por serviços (ex: uma função Lambda assume uma Role pra acessar S3)
- **Policies**: documentos JSON que definem permissões (allow/deny em ações e recursos)

**Boa prática crítica**: nunca usar a conta root pra trabalho do dia a dia, e nunca commitar Access Keys no código (erro comum e sério).

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "s3:GetObject",
      "Resource": "arn:aws:s3:::meu-bucket/*"
    }
  ]
}
```

### 3. EC2 (Elastic Compute Cloud)

Máquinas virtuais sob demanda.

- **AMI (Amazon Machine Image)**: template usado pra criar a instância
- **Instance Type**: define CPU/memória (ex: `t3.micro`, `m5.large`)
- **Security Group**: firewall virtual da instância (regras de entrada/saída)

```bash
aws ec2 describe-instances
aws ec2 start-instances --instance-ids i-0123456789abcdef0
```

### 4. S3 (Simple Storage Service)

Armazenamento de objetos (arquivos), altamente durável e escalável — não é um filesystem tradicional.

```bash
aws s3 mb s3://meu-bucket-exemplo
aws s3 cp arquivo.txt s3://meu-bucket-exemplo/
aws s3 ls s3://meu-bucket-exemplo/
```

### 5. VPC (Virtual Private Cloud)

Rede virtual isolada onde seus recursos rodam.

- **Subnets**: subdivisões da VPC — públicas (com rota pra internet) ou privadas
- **Route Tables**: definem para onde o tráfego de cada subnet vai
- **Internet Gateway**: permite tráfego entre a VPC e a internet
- **NAT Gateway**: permite que recursos em subnet privada acessem a internet sem serem acessíveis de fora

### 6. Lambda

Computação serverless — código executado sob demanda, sem gerenciar servidor, cobrado por execução.

```bash
aws lambda invoke --function-name minha-funcao saida.json
```

### 7. RDS

Banco de dados relacional gerenciado (Postgres, MySQL, etc.) — AWS cuida de backup, patch e replicação.

### 8. IaC na AWS

- **CloudFormation**: IaC nativo da AWS (JSON/YAML)
- **AWS SAM**: framework pra serverless sobre CloudFormation
- **Terraform** (módulo 04): alternativa multi-cloud, muito usada no mercado

## Custos — cuidado

AWS cobra por uso; recursos esquecidos rodando (EC2 ligada, NAT Gateway ocioso) geram custo. Sempre configurar **billing alerts** e revisar o **Cost Explorer**.

## Por que isso conecta com o resto do roadmap

- **Terraform**: provisiona recursos AWS de forma declarativa e versionada
- **Kubernetes**: EKS é o Kubernetes gerenciado da AWS
- **CI/CD**: pipelines fazem deploy de artefatos pra EC2/ECS/Lambda/S3

## Referências para aprofundar
- AWS Free Tier — pra praticar sem custo (com atenção aos limites)
- docs.aws.amazon.com
