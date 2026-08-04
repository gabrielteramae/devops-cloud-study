# Grafana — Lab Prático

## Pré-requisitos
- Prometheus rodando (do lab anterior) com a aplicação de métricas ativa
- Docker instalado

---

## Lab 1 — Subir Grafana

```bash
docker run -d --name grafana -p 3000:3000 grafana/grafana
```

Acesse `http://localhost:3000` (usuário `admin`, senha `admin` — vai pedir troca no primeiro login).

---

## Lab 2 — Conectar ao Prometheus

1. **Connections → Data sources → Add data source**
2. Escolha **Prometheus**
3. URL: `http://host.docker.internal:9090` (ou o IP do container Prometheus)
4. **Save & Test** — deve confirmar conexão bem-sucedida

---

## Lab 3 — Criar seu primeiro dashboard

1. **Dashboards → New → New Dashboard → Add visualization**
2. Escolha o data source Prometheus
3. Na query, use:
```promql
rate(app_requisicoes_total[1m])
```
4. Escolha o tipo de visualização (Time series funciona bem)
5. Salve o dashboard com o nome "Lab Grafana"

---

## Lab 4 — Importar dashboard pronto

1. **Dashboards → New → Import**
2. Cole o ID `1860` (Node Exporter Full) — requer que o `node_exporter` esteja rodando e configurado no Prometheus (lab anterior)
3. Selecione o data source Prometheus e clique em **Import**
4. Explore os painéis de CPU, memória e disco já prontos

---

## Lab 5 — Variável de dashboard

1. No dashboard criado no Lab 3, vá em **Settings → Variables → Add variable**
2. Nome: `job`, Type: Query, Query: `label_values(job)`
3. Na query do painel, use a variável:
```promql
rate(app_requisicoes_total{job="$job"}[1m])
```
4. Teste trocando o valor da variável no topo do dashboard

---

## Lab 6 — Alerta simples

1. No painel criado, vá em **Alert → Create alert rule**
2. Condição: `WHEN avg() OF query(A,5m,now) IS ABOVE 10`
3. Configure um contact point (ex: e-mail, se disponível) ou deixe sem notificação real pra só entender o fluxo

---

## Limpeza

```bash
docker stop grafana
docker rm grafana
```

## Checklist de conclusão
- [ ] Subi Grafana e conectei ao Prometheus como data source
- [ ] Criei um dashboard próprio com pelo menos um painel
- [ ] Importei um dashboard pronto da comunidade
- [ ] Adicionei uma variável dinâmica ao dashboard
- [ ] Configurei uma regra de alerta básica

## Notas / Troubleshooting
> Preencha aqui problemas reais (ex: `host.docker.internal` não resolvendo, dashboard importado sem dados por falta de métricas correspondentes, permissão de data source).
