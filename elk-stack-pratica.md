# ELK Stack — Lab Prático

## Pré-requisitos
- Docker e Docker Compose instalados
- Atenção: Elasticsearch consome bastante memória — reserve ao menos 4GB livres

---

## Lab 1 — Subir a stack completa com Docker Compose

Crie `docker-compose.yml`:

```yaml
services:
  elasticsearch:
    image: docker.elastic.co/elasticsearch/elasticsearch:8.15.0
    environment:
      - discovery.type=single-node
      - xpack.security.enabled=false
      - "ES_JAVA_OPTS=-Xms512m -Xmx512m"
    ports:
      - "9200:9200"

  kibana:
    image: docker.elastic.co/kibana/kibana:8.15.0
    ports:
      - "5601:5601"
    environment:
      - ELASTICSEARCH_HOSTS=http://elasticsearch:9200
    depends_on:
      - elasticsearch
```

```bash
docker compose up -d
# aguarde ~1 minuto pro Elasticsearch subir completamente
curl localhost:9200
```

Acesse Kibana em `http://localhost:5601`.

---

## Lab 2 — Indexar documentos manualmente (sem Logstash, direto na API)

```bash
curl -X POST "localhost:9200/logs-lab/_doc" -H 'Content-Type: application/json' -d '{
  "timestamp": "2026-08-04T10:00:00",
  "nivel": "ERROR",
  "mensagem": "Falha ao conectar no banco de dados"
}'

curl -X POST "localhost:9200/logs-lab/_doc" -H 'Content-Type: application/json' -d '{
  "timestamp": "2026-08-04T10:05:00",
  "nivel": "INFO",
  "mensagem": "Aplicação iniciada com sucesso"
}'
```

---

## Lab 3 — Buscar via API

```bash
curl -X GET "localhost:9200/logs-lab/_search?q=nivel:ERROR&pretty"
```

---

## Lab 4 — Explorar no Kibana

1. Em Kibana, vá em **Stack Management → Index Patterns**
2. Crie um index pattern `logs-lab*`
3. Vá em **Discover** e explore os documentos indexados
4. Filtre por `nivel: ERROR`

---

## Lab 5 — Filebeat coletando logs de arquivo (opcional, mais avançado)

Crie um arquivo de log de teste:
```bash
mkdir -p logs-teste
echo "$(date -Iseconds) ERROR Falha simulada no lab" >> logs-teste/app.log
```

Adicione ao `docker-compose.yml`:
```yaml
  filebeat:
    image: docker.elastic.co/beats/filebeat:8.15.0
    user: root
    volumes:
      - ./filebeat.yml:/usr/share/filebeat/filebeat.yml:ro
      - ./logs-teste:/logs-teste:ro
    depends_on:
      - elasticsearch
```

`filebeat.yml`:
```yaml
filebeat.inputs:
  - type: filestream
    paths:
      - /logs-teste/*.log

output.elasticsearch:
  hosts: ["elasticsearch:9200"]
```

```bash
docker compose up -d filebeat
# depois de alguns segundos, verifique no Kibana se um índice "filebeat-*" apareceu
```

---

## Limpeza

```bash
docker compose down -v
```

## Checklist de conclusão
- [ ] Subi Elasticsearch e Kibana via Docker Compose
- [ ] Indexei documentos manualmente via API REST
- [ ] Fiz buscas filtradas via API
- [ ] Explorei os dados visualmente no Kibana com um index pattern
- [ ] (Opcional) Coletei logs de arquivo real com Filebeat

## Notas / Troubleshooting
> Preencha aqui problemas reais (ex: Elasticsearch não subindo por falta de memória, erro de mapping de campos, Kibana demorando pra conectar).
