# Google Cloud (GCP) — Lab Prático

## Pré-requisitos
- Conta GCP (Free Tier com créditos iniciais)
- `gcloud` CLI instalada e autenticada

```bash
gcloud auth login
gcloud config set project SEU_PROJECT_ID
```

---

## Lab 1 — Cloud Storage

```bash
gcloud storage buckets create gs://lab-devops-$RANDOM --location=southamerica-east1

echo "teste" > arquivo.txt
gcloud storage cp arquivo.txt gs://SEU_BUCKET/
gcloud storage ls gs://SEU_BUCKET/

# limpeza
gcloud storage rm gs://SEU_BUCKET/arquivo.txt
gcloud storage buckets delete gs://SEU_BUCKET
```

---

## Lab 2 — Compute Engine (VM Free Tier: e2-micro)

```bash
gcloud compute instances create vm-lab \
  --zone=southamerica-east1-a \
  --machine-type=e2-micro \
  --image-family=ubuntu-2204-lts \
  --image-project=ubuntu-os-cloud

gcloud compute instances list

gcloud compute ssh vm-lab --zone=southamerica-east1-a

# limpeza (importante pra não gerar custo)
gcloud compute instances delete vm-lab --zone=southamerica-east1-a
```

---

## Lab 3 — IAM: Service Account

```bash
gcloud iam service-accounts create sa-lab-devops \
  --display-name="Service Account de Laboratório"

gcloud iam service-accounts list

gcloud projects add-iam-policy-binding SEU_PROJECT_ID \
  --member="serviceAccount:sa-lab-devops@SEU_PROJECT_ID.iam.gserviceaccount.com" \
  --role="roles/storage.objectViewer"
```

---

## Checklist de conclusão
- [ ] Criei e removi um bucket Cloud Storage
- [ ] Criei, acessei via SSH e removi uma VM Free Tier
- [ ] Criei uma Service Account e atribuí uma role a ela

## Notas / Troubleshooting
> Preencha aqui problemas reais (ex: erro de quota, permissão de API não habilitada no projeto).
