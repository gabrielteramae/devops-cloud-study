# Helm — Teoria

## O que é e por que importa

Helm é o "gerenciador de pacotes do Kubernetes" — assim como `apt` instala pacotes no Linux, Helm instala aplicações inteiras (conjuntos de Deployments, Services, ConfigMaps, etc.) no cluster através de pacotes chamados **charts**. Resolve o problema de ter que escrever e manter dezenas de manifests YAML manualmente para aplicações complexas.

## Conceitos-chave

### 1. Chart

Pacote Helm — conjunto de arquivos templados que descrevem uma aplicação Kubernetes.

```
meu-chart/
├── Chart.yaml          # metadados (nome, versão)
├── values.yaml          # valores default configuráveis
├── templates/
│   ├── deployment.yaml
│   ├── service.yaml
│   └── configmap.yaml
└── charts/               # dependências (sub-charts)
```

### 2. Release

Uma instância instalada de um chart no cluster — você pode instalar o mesmo chart várias vezes com nomes de release diferentes (ex: `app-dev`, `app-staging`).

```bash
helm install minha-app ./meu-chart
helm list
helm uninstall minha-app
```

### 3. Values

Arquivo `values.yaml` define os valores default; você pode sobrescrever na instalação sem tocar nos templates.

```yaml
# values.yaml
replicaCount: 3
image:
  repository: minha-app
  tag: "1.0"
```

```bash
helm install minha-app ./meu-chart --set replicaCount=5
helm install minha-app ./meu-chart -f valores-producao.yaml
```

### 4. Templates (Go templates)

Os manifests usam a sintaxe de templates do Go pra injetar valores dinamicamente.

```yaml
# templates/deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: {{ .Release.Name }}-app
spec:
  replicas: {{ .Values.replicaCount }}
  template:
    spec:
      containers:
        - name: app
          image: "{{ .Values.image.repository }}:{{ .Values.image.tag }}"
```

### 5. Repositórios de charts

Assim como Docker Hub para imagens, existem repositórios públicos de charts prontos (ex: Bitnami) pra ferramentas comuns (Postgres, Redis, Prometheus).

```bash
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update
helm install meu-postgres bitnami/postgresql
```

### 6. Upgrade e Rollback

```bash
helm upgrade minha-app ./meu-chart --set replicaCount=10
helm history minha-app
helm rollback minha-app 1
```

## Por que isso conecta com o resto do roadmap

- **Kubernetes** (módulo 02): Helm opera diretamente sobre os conceitos de Deployment/Service/ConfigMap já vistos
- **Argo CD**: frequentemente usa charts Helm como fonte de manifests em fluxos GitOps
- **CI/CD**: pipelines usam `helm upgrade` como etapa de deploy

## Referências para aprofundar
- helm.sh/docs
- artifacthub.io — busca de charts públicos
