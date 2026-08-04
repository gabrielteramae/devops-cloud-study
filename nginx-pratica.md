# Nginx — Lab Prático

## Pré-requisitos
- Docker instalado

---

## Lab 1 — Servidor de arquivos estáticos

```bash
mkdir -p lab-nginx/site
echo "<h1>Ola do Nginx!</h1>" > lab-nginx/site/index.html

docker run -d --name nginx-static \
  -p 8080:80 \
  -v $(pwd)/lab-nginx/site:/usr/share/nginx/html:ro \
  nginx:latest

curl localhost:8080
```

---

## Lab 2 — Reverse proxy pra uma aplicação backend

Suba uma aplicação simples pra servir de backend:
```bash
docker run -d --name backend-app --network lab-net -p 3000:3000 \
  python:3.12-slim python -m http.server 3000
```

Crie a rede (se ainda não existir) e a config do Nginx:
```bash
docker network create lab-net 2>/dev/null || true
docker network connect lab-net backend-app 2>/dev/null || true
```

`nginx-proxy.conf`:
```nginx
server {
    listen 80;

    location / {
        proxy_pass http://backend-app:3000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }
}
```

```bash
docker run -d --name nginx-proxy \
  --network lab-net \
  -p 8081:80 \
  -v $(pwd)/nginx-proxy.conf:/etc/nginx/conf.d/default.conf:ro \
  nginx:latest

curl localhost:8081
```

---

## Lab 3 — Load balancing entre múltiplos backends

```bash
docker run -d --name app1 --network lab-net python:3.12-slim python -m http.server 3000
docker run -d --name app2 --network lab-net python:3.12-slim python -m http.server 3000
docker run -d --name app3 --network lab-net python:3.12-slim python -m http.server 3000
```

`nginx-lb.conf`:
```nginx
upstream backend {
    server app1:3000;
    server app2:3000;
    server app3:3000;
}

server {
    listen 80;
    location / {
        proxy_pass http://backend;
        add_header X-Upstream $upstream_addr;
    }
}
```

```bash
docker run -d --name nginx-lb \
  --network lab-net \
  -p 8082:80 \
  -v $(pwd)/nginx-lb.conf:/etc/nginx/conf.d/default.conf:ro \
  nginx:latest

# rode várias vezes e observe o header X-Upstream mudando
for i in 1 2 3 4 5 6; do curl -sI localhost:8082 | grep X-Upstream; done
```

---

## Lab 4 — Rate limiting

Adicione ao `nginx-lb.conf` (fora do bloco `server`, no nível `http` — em setup via Docker, crie um `nginx.conf` completo):

```nginx
limit_req_zone $binary_remote_addr zone=lab:10m rate=2r/s;

server {
    listen 80;
    location / {
        limit_req zone=lab burst=3;
        proxy_pass http://backend;
    }
}
```

```bash
# teste disparando várias requisições rápidas
for i in $(seq 1 10); do curl -s -o /dev/null -w "%{http_code}\n" localhost:8082; done
# algumas devem retornar 503 (limitadas)
```

---

## Limpeza

```bash
docker stop nginx-static nginx-proxy nginx-lb backend-app app1 app2 app3
docker rm nginx-static nginx-proxy nginx-lb backend-app app1 app2 app3
docker network rm lab-net
```

## Checklist de conclusão
- [ ] Servi conteúdo estático via Nginx
- [ ] Configurei reverse proxy pra uma aplicação backend
- [ ] Testei load balancing entre múltiplos backends
- [ ] Configurei e testei rate limiting

## Notas / Troubleshooting
> Preencha aqui problemas reais (ex: erro 502 Bad Gateway por rede Docker mal configurada, sintaxe errada no `.conf`, DNS interno do Docker não resolvendo nome do container).
