# Docker — Lab Prático

## Objetivo
Construir, rodar e orquestrar containers na prática, incluindo persistência e rede.

## Pré-requisitos
- Docker Desktop instalado (`docker --version` pra confirmar)

---

## Lab 1 — Rodar um container simples

```bash
docker run hello-world
docker run -it ubuntu bash
# dentro do container:
cat /etc/os-release
exit
```

---

## Lab 2 — Construir sua própria imagem

Crie uma pasta `lab-docker` com dois arquivos:

`app.py`:
```python
from http.server import HTTPServer, BaseHTTPRequestHandler

class Handler(BaseHTTPRequestHandler):
    def do_GET(self):
        self.send_response(200)
        self.end_headers()
        self.wfile.write(b"Ola do container Docker!")

HTTPServer(("0.0.0.0", 8000), Handler).serve_forever()
```

`Dockerfile`:
```dockerfile
FROM python:3.12-slim
WORKDIR /app
COPY app.py .
EXPOSE 8000
CMD ["python", "app.py"]
```

```bash
cd lab-docker
docker build -t minha-primeira-imagem:1.0 .
docker run -d -p 8000:8000 --name meu-app minha-primeira-imagem:1.0

curl localhost:8000
docker logs meu-app
docker stop meu-app
docker rm meu-app
```

---

## Lab 3 — Volumes (persistência)

```bash
docker volume create dados-teste
docker run -v dados-teste:/dados --name c1 alpine sh -c "echo 'persistido' > /dados/arquivo.txt"
docker rm c1

# novo container, mesmo volume — dado deve estar lá
docker run -v dados-teste:/dados alpine cat /dados/arquivo.txt
```

---

## Lab 4 — Rede entre containers

```bash
docker network create rede-lab

docker run -d --name meu-db --network rede-lab \
  -e POSTGRES_PASSWORD=senha123 postgres:16

docker run -it --network rede-lab alpine sh
# dentro do container:
apk add --no-cache bind-tools
nslookup meu-db
exit
```

---

## Lab 5 — Docker Compose

Crie `docker-compose.yml` na mesma pasta do Lab 2:

```yaml
services:
  app:
    build: .
    ports:
      - "8000:8000"
    depends_on:
      - db
  db:
    image: postgres:16
    environment:
      POSTGRES_PASSWORD: senha123
    volumes:
      - dados-postgres:/var/lib/postgresql/data

volumes:
  dados-postgres:
```

```bash
docker compose up -d
docker compose ps
curl localhost:8000
docker compose down
```

---

## Checklist de conclusão
- [ ] Rodei um container interativo e explorei o filesystem
- [ ] Construí uma imagem própria a partir de um Dockerfile
- [ ] Testei persistência de dados com volumes
- [ ] Conectei dois containers pela mesma rede Docker
- [ ] Subi um ambiente multi-container com Docker Compose

## Notas / Troubleshooting
> Preencha aqui problemas reais (ex: porta já em uso, permissão negada no volume, cache de build não invalidando quando deveria).
