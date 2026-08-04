# Helm — Lab Prático

## Pré-requisitos
- Cluster Kubernetes local (Minikube, do módulo anterior)
- Helm instalado (`helm version`)

```bash
minikube start   # se ainda não estiver rodando
```

---

## Lab 1 — Instalar um chart público

```bash
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update

helm install meu-nginx bitnami/nginx
helm list
kubectl get pods
kubectl get svc
```

```bash
helm uninstall meu-nginx
```

---

## Lab 2 — Criar seu próprio chart

```bash
helm create meu-chart
cd meu-chart

# estrutura já vem pronta com deployment, service, etc.
helm install minha-app .
kubectl get pods
kubectl get svc
```

---

## Lab 3 — Customizando com values

Edite `values.yaml`:
```yaml
replicaCount: 3
image:
  repository: nginx
  tag: "latest"
service:
  type: ClusterIP
  port: 80
```

```bash
helm upgrade minha-app .
kubectl get pods -l app.kubernetes.io/instance=minha-app
```

Ou sobrescrevendo direto na linha de comando:
```bash
helm upgrade minha-app . --set replicaCount=5
kubectl get pods -l app.kubernetes.io/instance=minha-app
```

---

## Lab 4 — Rollback

```bash
helm history minha-app

# force uma "quebra" mudando pra uma imagem inexistente
helm upgrade minha-app . --set image.tag=versao-inexistente
kubectl get pods    # deve mostrar ImagePullBackOff

# reverter
helm rollback minha-app 1
kubectl get pods    # deve voltar ao normal
```

---

## Limpeza

```bash
helm uninstall minha-app
minikube stop
```

## Checklist de conclusão
- [ ] Instalei um chart público (Bitnami) no cluster
- [ ] Criei um chart próprio com `helm create`
- [ ] Customizei valores via `values.yaml` e `--set`
- [ ] Fiz upgrade, observei uma falha e fiz rollback

## Notas / Troubleshooting
> Preencha aqui problemas reais (ex: erro de sintaxe em template Go, values não sobrescrevendo como esperado, chart desatualizado no repo).
