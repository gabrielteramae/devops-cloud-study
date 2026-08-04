# Azure — Lab Prático

## Objetivo
Praticar Resource Groups, RBAC, VM e Storage Account usando a Azure CLI.

## Pré-requisitos
- Conta Azure (Free Account)
- Azure CLI instalada (`az --version`)

```bash
az login
az account show
```

---

## Lab 1 — Resource Group

```bash
az group create --name rg-lab-devops --location brazilsouth
az group list --output table
```

---

## Lab 2 — Storage Account e Blob

```bash
az storage account create \
  --name labdevops$RANDOM \
  --resource-group rg-lab-devops \
  --location brazilsouth \
  --sku Standard_LRS

# guarde o nome gerado numa variável
STORAGE_NAME=$(az storage account list --resource-group rg-lab-devops --query "[0].name" -o tsv)

az storage container create \
  --account-name $STORAGE_NAME \
  --name meu-container \
  --auth-mode login

echo "conteudo de teste" > teste.txt

az storage blob upload \
  --account-name $STORAGE_NAME \
  --container-name meu-container \
  --name teste.txt \
  --file teste.txt \
  --auth-mode login

az storage blob list \
  --account-name $STORAGE_NAME \
  --container-name meu-container \
  --auth-mode login \
  --output table
```

---

## Lab 3 — Máquina Virtual (Free Tier: B1s)

```bash
az vm create \
  --resource-group rg-lab-devops \
  --name vm-lab \
  --image Ubuntu2204 \
  --size Standard_B1s \
  --admin-username azureuser \
  --generate-ssh-keys

az vm list --resource-group rg-lab-devops --output table

# testar SSH (use o IP público retornado)
az vm show --resource-group rg-lab-devops --name vm-lab --show-details --query publicIps -o tsv
```

**Importante:** desligue/delete ao final pra evitar custo:
```bash
az vm deallocate --resource-group rg-lab-devops --name vm-lab
```

---

## Lab 4 — RBAC: atribuir papel a um usuário

```bash
# obter seu próprio object-id (ou de outro usuário do tenant)
az ad signed-in-user show --query id -o tsv

az role assignment create \
  --assignee <object-id> \
  --role "Reader" \
  --resource-group rg-lab-devops

az role assignment list --resource-group rg-lab-devops --output table
```

---

## Limpeza final (remove tudo do resource group de uma vez)

```bash
az group delete --name rg-lab-devops --yes --no-wait
```

## Checklist de conclusão
- [ ] Criei um Resource Group
- [ ] Criei uma Storage Account e fiz upload de um blob
- [ ] Criei e depois desliguei uma VM Free Tier
- [ ] Atribuí um papel RBAC a um usuário em um Resource Group
- [ ] Removi todos os recursos ao final

## Notas / Troubleshooting
> Preencha aqui problemas reais (ex: erro de quota na região `brazilsouth`, autenticação `az login` expirando, diferença de sintaxe comparado com AWS CLI).
