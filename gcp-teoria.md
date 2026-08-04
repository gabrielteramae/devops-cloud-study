# Google Cloud (GCP) — Teoria

## O que é e por que importa

GCP é o terceiro grande provedor de cloud, forte em dados/analytics (BigQuery), machine learning e Kubernetes (o próprio Kubernetes nasceu no Google). Os conceitos centrais seguem o mesmo padrão de AWS/Azure, com nomenclatura própria.

## Conceitos-chave

### 1. Estrutura de organização
- **Organization**: nível mais alto (empresa)
- **Project**: unidade de cobrança e isolamento (equivalente a Subscription/Account)
- **Resources**: VMs, buckets, etc., dentro de um Project

```bash
gcloud config set project meu-projeto
gcloud projects list
```

### 2. IAM
- **Members**: usuários, grupos, service accounts
- **Roles**: conjunto de permissões (predefined, custom ou basic: Owner/Editor/Viewer)
- **Service Accounts**: identidade pra aplicações/automação (equivalente a Role da AWS / Service Principal do Azure)

```bash
gcloud projects add-iam-policy-binding meu-projeto \
  --member="user:email@exemplo.com" \
  --role="roles/viewer"
```

### 3. Compute Engine (VMs)
```bash
gcloud compute instances create minha-vm \
  --zone=southamerica-east1-a \
  --machine-type=e2-micro \
  --image-family=ubuntu-2204-lts \
  --image-project=ubuntu-os-cloud
```

### 4. Cloud Storage (equivalente a S3/Blob Storage)
```bash
gcloud storage buckets create gs://meu-bucket-exemplo --location=southamerica-east1
gcloud storage cp arquivo.txt gs://meu-bucket-exemplo/
gcloud storage ls gs://meu-bucket-exemplo/
```

### 5. GKE (Google Kubernetes Engine)
Kubernetes gerenciado — geralmente considerado o mais maduro entre os três grandes clouds, já que o Google criou o Kubernetes.

### 6. Cloud Functions
Equivalente serverless ao Lambda/Azure Functions.

### 7. BigQuery
Data warehouse serverless, muito usado em analytics em larga escala — diferencial forte do GCP frente aos concorrentes.

## Comparação rápida entre os três clouds

| Conceito | AWS | Azure | GCP |
|---|---|---|---|
| Unidade de cobrança | Account | Subscription | Project |
| VM | EC2 | Virtual Machines | Compute Engine |
| Object Storage | S3 | Blob Storage | Cloud Storage |
| Serverless | Lambda | Functions | Cloud Functions |
| Kubernetes gerenciado | EKS | AKS | GKE |
| IaC nativo | CloudFormation | ARM/Bicep | Deployment Manager |

## Por que isso conecta com o resto do roadmap
- **Terraform**: provider `google` segue o mesmo padrão declarativo
- **Kubernetes**: GKE é referência de implementação madura
- Ter noção dos três clouds facilita decisões multi-cloud e conversas técnicas em qualquer empresa

## Referências para aprofundar
- cloud.google.com/docs
- Google Cloud Free Tier
