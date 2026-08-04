# Prometheus — Lab Prático

## Pré-requisitos
- Docker instalado

---

## Lab 1 — Subir Prometheus via Docker

Crie `prometheus.yml`:
```yaml
global:
  scrape_interval: 15s

scrape_configs:
  - job_name: 'prometheus'
    static_configs:
      - targets: ['localhost:9090']
```

```bash
docker run -d --name prometheus \
  -p 9090:9090 \
  -v $(pwd)/prometheus.yml:/etc/prometheus/prometheus.yml \
  prom/prometheus
```

Acesse `http://localhost:9090`.

---

## Lab 2 — Expor métricas de uma aplicação própria

Crie `app.py` (usa a lib `prometheus_client`):
```python
from prometheus_client import start_http_server, Counter
import random
import time

REQUISICOES = Counter('app_requisicoes_total', 'Total de requisições simuladas')

if __name__ == '__main__':
    start_http_server(8000)
    while True:
        REQUISICOES.inc()
        time.sleep(random.uniform(0.5, 2))
```

```bash
pip install prometheus_client --break-system-packages
python app.py
```

Em outro terminal, teste o endpoint de métricas:
```bash
curl localhost:8000
```

---

## Lab 3 — Adicionar o target ao Prometheus

Edite `prometheus.yml`:
```yaml
scrape_configs:
  - job_name: 'prometheus'
    static_configs:
      - targets: ['localhost:9090']
  - job_name: 'minha-app'
    static_configs:
      - targets: ['host.docker.internal:8000']
```

```bash
docker restart prometheus
```

No Prometheus (`http://localhost:9090`), vá em **Status → Targets** e confirme que `minha-app` está `UP`.

---

## Lab 4 — Consultas PromQL

No campo de query do Prometheus, teste:
```promql
app_requisicoes_total

rate(app_requisicoes_total[1m])

increase(app_requisicoes_total[5m])
```

---

## Lab 5 — node_exporter (métricas do sistema)

```bash
docker run -d --name node-exporter \
  -p 9100:9100 \
  prom/node-exporter
```

Adicione ao `prometheus.yml`:
```yaml
  - job_name: 'node'
    static_configs:
      - targets: ['host.docker.internal:9100']
```

```bash
docker restart prometheus
```

Consulte no Prometheus:
```promql
node_memory_MemAvailable_bytes
rate(node_cpu_seconds_total{mode="idle"}[5m])
```

---

## Limpeza

```bash
docker stop prometheus node-exporter
docker rm prometheus node-exporter
```

## Checklist de conclusão
- [ ] Subi Prometheus via Docker com config própria
- [ ] Expus métricas customizadas de uma aplicação Python
- [ ] Confirmei o target como `UP` no Prometheus
- [ ] Rodei consultas PromQL (`rate`, `increase`)
- [ ] Coletei métricas de sistema com `node_exporter`

## Notas / Troubleshooting
> Preencha aqui problemas reais (ex: `host.docker.internal` não resolvendo no Linux, target ficando `DOWN`, erro de sintaxe YAML no config).
