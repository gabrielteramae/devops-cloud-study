# Azure — Teoria

## O que é e por que importa em DevOps

Microsoft Azure é o segundo maior provedor de cloud do mundo, forte especialmente em ambientes corporativos que já usam stack Microsoft (Active Directory, .NET, Office 365) e em cargas de dados/analytics (Databricks, Synapse). Os conceitos centrais são muito parecidos com AWS — a diferença está principalmente na nomenclatura e na forma de organizar recursos.

## Conceitos-chave

### 1. Estrutura de organização

- **Tenant (Azure AD / Entra ID)**: identidade organizacional
- **Subscription**: unidade de cobrança e isolamento de recursos
- **Resource Group**: agrupamento lógico de recursos relacionados (ex: tudo de um projeto junto)
- **Resource**: o recurso em si (VM, banco, storage account, etc.)

Diferente da AWS (onde tudo fica meio "solto" na conta), Azure força você a organizar recursos dentro de Resource Groups — o que ajuda bastante em governança e cost tracking.

```bash
az account show
az group create --name meu-grupo --location brazilsouth
az group list --output table
```

### 2. Azure AD / Microsoft Entra ID (IAM)

- **Users/Groups**: identidades
- **Service Principals**: identidade usada por aplicações/automação (equivalente às Roles da AWS)
- **RBAC (Role-Based Access Control)**: atribui papéis (Owner, Contributor, Reader) a identidades em um escopo (subscription, resource group ou recurso)

```bash
az role assignment create \
  --assignee <object-id> \
  --role "Contributor" \
  --resource-group meu-grupo
```

### 3. Máquinas Virtuais

```bash
az vm create \
  --resource-group meu-grupo \
  --name minha-vm \
  --image Ubuntu2204 \
  --size Standard_B1s \
  --admin-username azureuser \
  --generate-ssh-keys

az vm list --output table
az vm deallocate --resource-group meu-grupo --name minha-vm
```

### 4. Storage Account

Equivalente ao S3 da AWS, mas mais versátil — engloba Blob Storage (objetos), File Shares, Queues e Tables num único recurso.

```bash
az storage account create \
  --name meustoragelab \
  --resource-group meu-grupo \
  --sku Standard_LRS

az storage container create \
  --account-name meustoragelab \
  --name meu-container
```

### 5. Azure Databricks (contexto do seu histórico no BMG)

Plataforma de analytics/data engineering rodando sobre Spark, com integração nativa a Storage Accounts e Azure AD. No contexto de ESG/risco de crédito, é comum usar Databricks pra pipelines de dados (ETL) alimentando modelos e dashboards (Power BI) — exatamente o tipo de arquitetura que você já operou profissionalmente.

### 6. Azure Functions

Equivalente ao Lambda da AWS — computação serverless.

### 7. AKS (Azure Kubernetes Service)

Kubernetes gerenciado na Azure — equivalente ao EKS da AWS.

### 8. IaC no Azure

- **ARM Templates / Bicep**: IaC nativo do Azure (Bicep é a evolução mais legível do ARM)
- **Terraform** (módulo 04): também amplamente usado, multi-cloud

## Comparação rápida AWS ↔ Azure

| AWS | Azure |
|---|---|
| IAM | Azure AD / Entra ID + RBAC |
| EC2 | Virtual Machines |
| S3 | Blob Storage (Storage Account) |
| Lambda | Azure Functions |
| EKS | AKS |
| VPC | Virtual Network (VNet) |
| CloudFormation | ARM Templates / Bicep |

## Por que isso conecta com o resto do roadmap

- **Terraform**: mesmo provider model se aplica ao Azure (`provider "azurerm"`)
- **Kubernetes**: AKS segue os mesmos conceitos do módulo 02
- **CI/CD**: Azure DevOps e GitHub Actions têm integração nativa com deploy pro Azure

## Referências para aprofundar
- learn.microsoft.com/azure
- Azure Free Account — créditos iniciais pra praticar
