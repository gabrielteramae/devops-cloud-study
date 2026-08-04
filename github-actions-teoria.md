# GitHub Actions — Teoria

## O que é e por que importa

GitHub Actions é a plataforma de CI/CD nativa do GitHub — automatiza build, teste e deploy diretamente a partir de eventos no repositório (push, pull request, release). Como você já usa GitHub pra portfólio, é a ferramenta de CI/CD mais natural pra começar.

## Conceitos-chave

### 1. Workflow

Arquivo YAML em `.github/workflows/` que define uma automação.

```yaml
name: CI

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Rodar testes
        run: echo "rodando testes..."
```

### 2. Triggers (`on`)

Define quando o workflow roda: `push`, `pull_request`, `schedule` (cron), `workflow_dispatch` (manual), entre outros.

```yaml
on:
  push:
    branches: [main]
  schedule:
    - cron: '0 6 * * *'   # todo dia às 6h
  workflow_dispatch:        # botão "Run workflow" manual
```

### 3. Jobs e Steps

- **Job**: unidade de trabalho, roda em uma máquina virtual isolada (runner)
- **Step**: comando individual dentro de um job — pode ser um `run` (shell) ou um `uses` (Action reutilizável)

Jobs rodam em paralelo por padrão; use `needs` pra criar dependência sequencial.

```yaml
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - run: echo "testando"

  deploy:
    needs: test
    runs-on: ubuntu-latest
    steps:
      - run: echo "deploy só depois do test passar"
```

### 4. Actions reutilizáveis

Blocos prontos do Marketplace (`actions/checkout`, `actions/setup-node`, `docker/build-push-action`, etc.)

```yaml
- uses: actions/setup-python@v5
  with:
    python-version: '3.12'
```

### 5. Secrets

Valores sensíveis (tokens, senhas) armazenados no GitHub (Settings → Secrets) e injetados como variáveis de ambiente — nunca hardcoded no YAML.

```yaml
- name: Deploy
  env:
    AWS_ACCESS_KEY_ID: ${{ secrets.AWS_ACCESS_KEY_ID }}
  run: ./deploy.sh
```

### 6. Matrix builds

Roda o mesmo job com múltiplas combinações de configuração (ex: várias versões de linguagem).

```yaml
strategy:
  matrix:
    python-version: ['3.10', '3.11', '3.12']
steps:
  - uses: actions/setup-python@v5
    with:
      python-version: ${{ matrix.python-version }}
```

## Por que isso conecta com o resto do roadmap

- **Docker**: workflows constroem e publicam imagens (`docker/build-push-action`)
- **Terraform**: workflows rodam `terraform plan/apply` a partir de mudanças no repositório
- **Kubernetes**: workflows fazem deploy via `kubectl apply` ou Helm
- Seus repos atuais (route-tracker, transformador-de-arquivos) já têm espaço natural pra adicionar CI/CD

## Referências para aprofundar
- docs.github.com/actions
- GitHub Actions Marketplace
