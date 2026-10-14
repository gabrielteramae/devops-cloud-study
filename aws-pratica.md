# AWS — Lab Prático

## Objetivo
Praticar IAM, S3, EC2 e uma função Lambda simples usando a AWS CLI.

## Pré-requisitos
- Conta AWS (Free Tier)
- AWS CLI instalada e configurada (`aws configure`)
- **Nunca use a conta root ou credenciais root pra isso** — crie um usuário IAM com permissões limitadas primeiro

```bash
aws --version
aws sts get-caller-identity   # confirma qual identidade está autenticada
```

---

## Lab 1 — IAM: criar usuário com permissões limitadas

O JSON deste lab está em `labs/aws/policy-s3-readonly.json`. Ele libera leitura em qualquer bucket. Para um lab de verdade, prefira `labs/aws/policy-s3-lab-prefix.json`, que só alcança buckets `lab-devops-*`.

```bash
cd labs/aws

aws iam create-user --user-name lab-devops

aws iam create-policy \
  --policy-name LabS3ReadOnly \
  --policy-document file://policy-s3-lab-prefix.json
```

```bash
aws iam attach-user-policy \
  --user-name lab-devops \
  --policy-arn arn:aws:iam::<SEU_ACCOUNT_ID>:policy/LabS3ReadOnly
```

---

## Lab 2 — S3: bucket e upload

```bash
aws s3 mb s3://lab-devops-<seu-nome-unico>

echo "conteudo de teste" > teste.txt
aws s3 cp teste.txt s3://lab-devops-<seu-nome-unico>/

aws s3 ls s3://lab-devops-<seu-nome-unico>/

# baixar de volta
aws s3 cp s3://lab-devops-<seu-nome-unico>/teste.txt teste-baixado.txt
```

**Cuidado:** delete o bucket ao final do lab pra não gerar custo.
```bash
aws s3 rm s3://lab-devops-<seu-nome-unico>/teste.txt
aws s3 rb s3://lab-devops-<seu-nome-unico>
```

---

## Lab 3 — EC2: instância t2.micro (Free Tier)

```bash
# listar AMIs disponíveis (Amazon Linux mais recente)
aws ec2 describe-images --owners amazon \
  --filters "Name=name,Values=al2023-ami-*-x86_64" \
  --query 'Images[*].[ImageId,Name]' --output table

# criar instância (ajuste ImageId conforme sua região)
aws ec2 run-instances \
  --image-id ami-XXXXXXXX \
  --instance-type t2.micro \
  --count 1

aws ec2 describe-instances --query 'Reservations[*].Instances[*].[InstanceId,State.Name]'
```

**Importante:** pare/termine a instância ao final:
```bash
aws ec2 terminate-instances --instance-ids i-XXXXXXXXXXXX
```

---

## Lab 4 — Billing alert (proteção contra custo inesperado)

O `labs/terraform` cria o budget se você passar o e-mail. Sem isso, nada de billing é criado.

```bash
cd labs/terraform
terraform apply -var="alerta_email=voce@exemplo.com"
```

Isso abre um budget mensal de US$ 5 e avisa em 80%. A API de budget responde em `us-east-1`. O console (Billing → Budgets) mostra o mesmo recurso.

## Checklist de conclusão
- [ ] Criei um usuário IAM com política restrita (não usei root)
- [ ] Criei, populei e removi um bucket S3
- [ ] Subi e terminei uma instância EC2 Free Tier
- [ ] Configurei um billing alert

## Notas / Troubleshooting
> Preencha aqui problemas reais (ex: erro de permissão IAM, região errada causando AMI não encontrada, esquecimento de terminar recurso gerando cobrança).
