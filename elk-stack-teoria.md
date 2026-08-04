# ELK Stack — Teoria

## O que é e por que importa

ELK é a sigla para **Elasticsearch, Logstash e Kibana** — uma stack de centralização, processamento e visualização de logs. Enquanto Prometheus/Grafana lidam com métricas numéricas, ELK lida com logs (texto não estruturado ou semi-estruturado), essenciais pra debugar problemas e investigar incidentes. Muitas stacks modernas usam **Filebeat** no lugar do Logstash pra coleta, formando o que também é chamado de "Elastic Stack".

## Componentes

### 1. Elasticsearch

Banco de dados de busca e análise distribuído — armazena e indexa os logs, permitindo buscas full-text rápidas mesmo em grandes volumes.

```bash
# exemplo de busca via API REST
curl -X GET "localhost:9200/logs-*/_search?q=erro"
```

### 2. Logstash (ou Filebeat)

- **Logstash**: pipeline de processamento — coleta, transforma (parse, filtro, enriquecimento) e envia logs pro Elasticsearch
- **Filebeat**: agente leve que só coleta e encaminha logs (mais usado hoje em dia por ser mais leve que Logstash)

```yaml
# logstash.conf (exemplo simples)
input {
  file {
    path => "/var/log/app/*.log"
  }
}
filter {
  grok {
    match => { "message" => "%{TIMESTAMP_ISO8601:timestamp} %{LOGLEVEL:nivel} %{GREEDYDATA:mensagem}" }
  }
}
output {
  elasticsearch {
    hosts => ["localhost:9200"]
  }
}
```

### 3. Kibana

Interface de visualização — dashboards, buscas interativas e exploração de logs armazenados no Elasticsearch (papel equivalente ao Grafana, mas nativo do ecossistema Elastic e mais voltado a logs/documentos).

### 4. Index

No Elasticsearch, dados são organizados em **índices** (parecido com "tabelas" em bancos relacionais, mas otimizado pra busca). É comum ter um índice por dia (`logs-2026.08.04`) pra facilitar retenção e performance.

### 5. Query DSL

Elasticsearch tem sua própria linguagem de consulta em JSON:

```json
{
  "query": {
    "bool": {
      "must": [
        { "match": { "nivel": "ERROR" } },
        { "range": { "timestamp": { "gte": "now-1h" } } }
      ]
    }
  }
}
```

## Por que isso conecta com o resto do roadmap

- **Linux** (módulo 01): logs de sistema (`journalctl`, `/var/log`) são exatamente o tipo de dado que Filebeat/Logstash coletam
- **Kubernetes**: em clusters, logs de containers são efêmeros — ELK centraliza e persiste esses logs fora dos pods
- **Prometheus/Grafana**: métricas (o que aconteceu numericamente) e logs (o que aconteceu em detalhe/contexto) se complementam na observabilidade completa de um sistema

## Referências para aprofundar
- elastic.co/guide
- Elastic Cloud (versão gerenciada, útil pra testar sem infra própria)
