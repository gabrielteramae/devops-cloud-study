# Prometheus — Teoria

## O que é e por que importa

Prometheus é o sistema de monitoramento e alerta open-source padrão do ecossistema cloud-native (projeto da CNCF, mesma organização do Kubernetes). Ele coleta métricas numéricas ao longo do tempo (time series) de aplicações e infraestrutura, permitindo observar saúde e performance do sistema.

## Conceitos-chave

### 1. Modelo Pull

Diferente de muitas ferramentas que recebem dados enviados por agentes (push), Prometheus **puxa (scrape)** métricas periodicamente de endpoints HTTP expostos pelas aplicações (geralmente em `/metrics`).

```yaml
# prometheus.yml
scrape_configs:
  - job_name: 'minha-app'
    scrape_interval: 15s
    static_configs:
      - targets: ['localhost:8000']
```

### 2. Tipos de métricas

| Tipo | Uso |
|---|---|
| **Counter** | Valor que só aumenta (ex: total de requisições) |
| **Gauge** | Valor que sobe e desce (ex: uso de memória) |
| **Histogram** | Distribui observações em buckets (ex: latência de requisições) |
| **Summary** | Similar ao histogram, com quantis calculados no cliente |

### 3. PromQL

Linguagem de consulta do Prometheus.

```promql
# taxa de requisições por segundo nos últimos 5 minutos
rate(http_requests_total[5m])

# uso médio de CPU
avg(rate(process_cpu_seconds_total[5m]))

# alerta: mais de 5% de erros 5xx
sum(rate(http_requests_total{status=~"5.."}[5m]))
  / sum(rate(http_requests_total[5m])) > 0.05
```

### 4. Exporters

Como nem toda aplicação expõe métricas nativamente no formato Prometheus, existem **exporters** — processos auxiliares que traduzem métricas de sistemas de terceiros (ex: `node_exporter` para métricas de SO, `postgres_exporter` pra banco).

### 5. Alertmanager

Componente separado que recebe alertas disparados por regras do Prometheus e os roteia (email, Slack, PagerDuty) com deduplicação e agrupamento.

```yaml
groups:
  - name: alertas-basicos
    rules:
      - alert: AltoUsoDisco
        expr: node_filesystem_avail_bytes / node_filesystem_size_bytes < 0.1
        for: 5m
        labels:
          severidade: critico
        annotations:
          summary: "Menos de 10% de disco disponível"
```

## Por que isso conecta com o resto do roadmap

- **Kubernetes**: Prometheus é o padrão de monitoramento de clusters K8s (via `kube-state-metrics` e `node_exporter`)
- **Grafana** (próximo módulo): visualiza os dados coletados pelo Prometheus em dashboards
- **Docker**: containers podem expor métricas próprias que o Prometheus coleta

## Referências para aprofundar
- prometheus.io/docs
- PromQL cheat sheet (promlabs.com)
