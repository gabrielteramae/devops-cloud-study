# GitHub Actions — Lab Prático

## Pré-requisitos
- Um repositório no GitHub (pode ser o próprio `devops-cloud-study` ou um novo)

---

## Lab 1 — Primeiro workflow

Crie `.github/workflows/ci.yml`:

```yaml
name: CI Básico

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  hello:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Diz olá
        run: echo "Workflow rodando no commit ${{ github.sha }}"
```

Commit e push — depois vá na aba **Actions** do repositório no GitHub e veja o workflow rodar.

---

## Lab 2 — Rodando testes de um projeto Python

Crie `.github/workflows/test.yml`:

```yaml
name: Testes Python

on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Configurar Python
        uses: actions/setup-python@v5
        with:
          python-version: '3.12'

      - name: Instalar dependências
        run: |
          pip install pytest
          pip install -r requirements.txt || echo "sem requirements.txt"

      - name: Rodar testes
        run: pytest || echo "sem testes ainda"
```

---

## Lab 3 — Matrix build

```yaml
name: Testes Multi-versão

on: [push]

jobs:
  test:
    runs-on: ubuntu-latest
    strategy:
      matrix:
        python-version: ['3.10', '3.11', '3.12']
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-python@v5
        with:
          python-version: ${{ matrix.python-version }}
      - run: python --version
```

---

## Lab 4 — Build e push de imagem Docker (requer Docker Hub ou GHCR)

Adicione o secret `DOCKERHUB_TOKEN` em Settings → Secrets do repo, depois:

```yaml
name: Build e Push Docker

on:
  push:
    branches: [main]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Login no Docker Hub
        uses: docker/login-action@v3
        with:
          username: ${{ secrets.DOCKERHUB_USERNAME }}
          password: ${{ secrets.DOCKERHUB_TOKEN }}

      - name: Build e push
        uses: docker/build-push-action@v5
        with:
          context: .
          push: true
          tags: seu-usuario/sua-imagem:latest
```

---

## Lab 5 — Job condicional e dependência (`needs`)

```yaml
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - run: echo "rodando testes"

  deploy:
    needs: test
    if: github.ref == 'refs/heads/main'
    runs-on: ubuntu-latest
    steps:
      - run: echo "deploy só na branch main, e só se test passar"
```

## Checklist de conclusão
- [ ] Criei e rodei um workflow básico disparado por push
- [ ] Rodei testes automatizados de um projeto real
- [ ] Testei matrix build com múltiplas versões
- [ ] Usei secrets pra autenticar em um serviço externo
- [ ] Criei dependência entre jobs com `needs`

## Notas / Troubleshooting
> Preencha aqui problemas reais (ex: erro de permissão de token, workflow não disparando por branch errada, secret não configurado).
