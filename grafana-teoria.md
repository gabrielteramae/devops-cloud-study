# Grafana — Teoria

## O que é e por que importa

Grafana é a plataforma de visualização e dashboards mais usada junto ao Prometheus (e a muitas outras fontes de dados). Enquanto Prometheus coleta e armazena métricas, Grafana transforma esses dados em gráficos, painéis e alertas visuais compreensíveis por qualquer pessoa do time — não só quem sabe PromQL.

## Conceitos-chave

### 1. Data Sources

Grafana se conecta a diversas fontes de dados: Prometheus, InfluxDB, Elasticsearch, MySQL, CloudWatch, etc. Um mesmo dashboard pode combinar painéis de fontes diferentes.

### 2. Dashboards e Panels

- **Dashboard**: coleção de painéis organizados numa tela
- **Panel**: visualização individual (gráfico de linha, gauge, tabela, heatmap) baseada em uma query

```promql
# exemplo de query num panel conectado ao Prometheus
rate(app_requisicoes_total[5m])
```

### 3. Variáveis de dashboard

Permitem tornar dashboards dinâmicos e reutilizáveis (ex: dropdown pra escolher qual servidor/ambiente visualizar).

```
Variável: $ambiente
Query: label_values(app_requisicoes_total, ambiente)
```

Uso na query do painel:
```promql
rate(app_requisicoes_total{ambiente="$ambiente"}[5m])
```

### 4. Alerting

Grafana também dispara alertas baseados em thresholds das queries, notificando por e-mail, Slack, PagerDuty, etc. — pode substituir ou complementar o Alertmanager do Prometheus.

### 5. Dashboards prontos (import)

A comunidade compartilha dashboards prontos via ID (grafana.com/dashboards) — muito comum importar um dashboard pronto pra `node_exporter` ou Kubernetes em vez de montar do zero.

```
Dashboard → Import → cole o ID (ex: 1860 para Node Exporter Full)
```

### 6. Organização

- **Organizations**: isolamento multi-tenant
- **Folders**: organizam dashboards por time/projeto
- **Permissions**: controle de quem pode ver/editar cada dashboard

## Por que isso conecta com o resto do roadmap

- **Prometheus**: a combinação Prometheus + Grafana é o par mais comum de observabilidade no ecossistema cloud-native
- **Kubernetes**: dashboards prontos existem especificamente pra visualizar saúde de clusters K8s
- **ELK Stack** (próximo módulo): Grafana também consegue consumir dados do Elasticsearch, complementando métricas com logs

## Referências para aprofundar
- grafana.com/docs
- grafana.com/dashboards — galeria de dashboards prontos
