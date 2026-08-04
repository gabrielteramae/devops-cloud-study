# Nginx — Teoria

## O que é e por que importa

Nginx é um dos servidores web mais usados do mundo, atuando como servidor HTTP, **reverse proxy**, **load balancer** e terminador de TLS/SSL. Em arquiteturas DevOps, Nginx costuma ficar na "porta de entrada" do tráfego, distribuindo requisições entre múltiplas instâncias de uma aplicação e lidando com aspectos como cache, compressão e segurança.

## Conceitos-chave

### 1. Servidor web (static content)

```nginx
server {
    listen 80;
    server_name meusite.com;
    root /var/www/html;
    index index.html;
}
```

### 2. Reverse Proxy

Nginx recebe a requisição do cliente e a encaminha pra um servidor backend (que pode estar rodando em outra porta/máquina), retornando a resposta como se fosse ele mesmo o servidor de origem.

```nginx
server {
    listen 80;
    server_name meuapp.com;

    location / {
        proxy_pass http://localhost:3000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }
}
```

### 3. Load Balancer

Distribui requisições entre múltiplas instâncias backend (upstream), aumentando disponibilidade e capacidade.

```nginx
upstream backend {
    server 10.0.0.1:3000;
    server 10.0.0.2:3000;
    server 10.0.0.3:3000;
}

server {
    listen 80;
    location / {
        proxy_pass http://backend;
    }
}
```

**Algoritmos de balanceamento comuns:**
- Round-robin (padrão)
- `least_conn` — envia pra quem tem menos conexões ativas
- `ip_hash` — mesma IP sempre vai pro mesmo backend (sticky sessions)

### 4. TLS/SSL (HTTPS)

```nginx
server {
    listen 443 ssl;
    server_name meusite.com;

    ssl_certificate /etc/nginx/ssl/cert.pem;
    ssl_certificate_key /etc/nginx/ssl/key.pem;

    location / {
        proxy_pass http://localhost:3000;
    }
}
```

Certificados gratuitos e automatizados costumam vir do **Let's Encrypt** (via Certbot).

### 5. Ingress Controller (Kubernetes)

Nginx é uma das implementações mais comuns de Ingress Controller no Kubernetes — roteando tráfego externo pra Services internos com base em hostname/path.

### 6. Configurações comuns

- **Gzip**: compressão de resposta pra reduzir banda
- **Cache**: `proxy_cache` reduz carga no backend
- **Rate limiting**: `limit_req` protege contra abuso/DDoS básico

```nginx
limit_req_zone $binary_remote_addr zone=geral:10m rate=10r/s;

server {
    location / {
        limit_req zone=geral burst=20;
        proxy_pass http://backend;
    }
}
```

## Por que isso conecta com o resto do roadmap

- **Docker/Kubernetes**: Nginx roda como container/Ingress Controller na entrada de aplicações containerizadas
- **Cloud**: complementa ou substitui load balancers gerenciados (ALB, Azure Load Balancer) em setups auto-hospedados

## Referências para aprofundar
- nginx.org/en/docs
- nginx.com — guias de reverse proxy e load balancing
