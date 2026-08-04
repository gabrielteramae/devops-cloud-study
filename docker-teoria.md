# Docker — Teoria

## O que é e por que importa em DevOps

Docker é a plataforma que popularizou containers: empacotar uma aplicação com todas as suas dependências (bibliotecas, runtime, configs) em uma unidade isolada e portável. Resolve o clássico problema "funciona na minha máquina" e é a base sobre a qual Kubernetes opera.

## Container vs Máquina Virtual

| | VM | Container |
|---|---|---|
| Isolamento | Kernel próprio (hypervisor) | Compartilha kernel do host |
| Peso | Gigabytes | Megabytes |
| Boot | Minutos | Segundos/milissegundos |
| Uso típico | Isolar sistemas operacionais diferentes | Isolar aplicações no mesmo SO |

Containers usam recursos nativos do kernel Linux: **namespaces** (isolamento de processos, rede, filesystem) e **cgroups** (limite de CPU/memória) — por isso a base de Linux (módulo 01) é pré-requisito.

## Conceitos-chave

### 1. Imagem vs Container

- **Imagem**: template read-only, construído em camadas (layers)
- **Container**: instância em execução de uma imagem, com uma camada de escrita por cima

```bash
docker images              # lista imagens locais
docker ps                  # containers rodando
docker ps -a                # todos os containers (incluindo parados)
```

### 2. Dockerfile

Receita para construir uma imagem:

```dockerfile
FROM node:20-alpine
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
EXPOSE 3000
CMD ["node", "server.js"]
```

- `FROM` — imagem base
- `WORKDIR` — diretório de trabalho dentro do container
- `COPY`/`ADD` — copia arquivos do host pra imagem
- `RUN` — executa comando durante o **build**
- `CMD`/`ENTRYPOINT` — comando executado quando o container **inicia**
- `EXPOSE` — documenta a porta usada (não publica sozinha)

```bash
docker build -t minha-app:1.0 .
docker run -p 3000:3000 minha-app:1.0
```

### 3. Camadas e cache de build

Cada instrução do Dockerfile gera uma camada. Docker reaproveita camadas não alteradas em builds seguintes (cache) — por isso é boa prática copiar arquivos de dependências (`package.json`) antes do código-fonte, pra não invalidar o cache de instalação a cada mudança de código.

### 4. Volumes

Containers são efêmeros por padrão — dados somem quando o container é removido. Volumes persistem dados fora do ciclo de vida do container.

```bash
docker volume create meus-dados
docker run -v meus-dados:/app/dados minha-app:1.0

# bind mount (monta pasta do host direto)
docker run -v $(pwd)/src:/app/src minha-app:1.0
```

### 5. Redes

```bash
docker network create minha-rede
docker run --network minha-rede --name app1 minha-app:1.0
docker run --network minha-rede --name db postgres:16
# app1 consegue acessar "db" pelo nome (DNS interno do Docker)
```

### 6. Docker Compose

Orquestra múltiplos containers via YAML declarativo — útil pra ambientes de desenvolvimento com várias dependências (app + banco + cache):

```yaml
services:
  app:
    build: .
    ports:
      - "3000:3000"
    depends_on:
      - db
  db:
    image: postgres:16
    environment:
      POSTGRES_PASSWORD: senha
```

```bash
docker compose up -d
docker compose down
```

## Por que isso conecta com o resto do roadmap

- **Kubernetes**: orquestra containers Docker (ou compatíveis com OCI) em escala, resolvendo o que Compose faz sozinho e limitado
- **CI/CD**: pipelines constroem e publicam imagens Docker como parte do processo de deploy
- **Cloud**: AWS ECR/ECS, Azure Container Registry, GCP Artifact Registry são registries e runtimes de containers

## Referências para aprofundar
- Documentação oficial: docs.docker.com
- Docker Hub — repositório público de imagens
