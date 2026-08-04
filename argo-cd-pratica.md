# Argo CD — Lab Prático

## Pré-requisitos
- Cluster Kubernetes local (Minikube)
- `kubectl` configurado

```bash
minikube start
```

---

## Lab 1 — Instalar Argo CD no cluster

```bash
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# aguarde os pods ficarem prontos
kubectl get pods -n argocd -w
```

---

## Lab 2 — Acessar a interface

```bash
# senha inicial do admin
kubectl -n argocd get secret argocd-initial-admin-secret \
  -o jsonpath="{.data.password}" | base64 -d

# port-forward pra acessar localmente
kubectl port-forward svc/argocd-server -n argocd 8080:443
```

Acesse `https://localhost:8080` (usuário `admin`, senha do comando acima).

Ou via CLI:
```bash
argocd login localhost:8080
```

---

## Lab 3 — Criar uma Application apontando pra um repo Git

Use um repositório público de exemplo pra praticar primeiro (ex: o repositório de exemplos do próprio Argo CD):

```bash
argocd app create guestbook \
  --repo https://github.com/argoproj/argocd-example-apps.git \
  --path guestbook \
  --dest-server https://kubernetes.default.svc \
  --dest-namespace default

argocd app get guestbook
argocd app sync guestbook

kubectl get pods -n default
```

---

## Lab 4 — Testar self-healing

```bash
# mude manualmente o número de réplicas
kubectl scale deployment guestbook-ui --replicas=5 -n default

# observe o Argo CD detectar OutOfSync e reverter (se syncPolicy automated + selfHeal estiver ativo)
argocd app get guestbook
```

Pra habilitar sync automático:
```bash
argocd app set guestbook --sync-policy automated --self-heal
```

---

## Lab 5 — Aplicar num repositório seu

Crie manifests simples (ex: o Deployment/Service do módulo Kubernetes) num repositório GitHub próprio, depois:

```bash
argocd app create minha-app \
  --repo https://github.com/SEU_USUARIO/SEU_REPO.git \
  --path caminho/dos/manifests \
  --dest-server https://kubernetes.default.svc \
  --dest-namespace default

argocd app sync minha-app
```

Faça uma mudança no repositório (ex: mude `replicas`), commit, push, e observe o Argo CD detectar `OutOfSync` e sincronizar.

---

## Limpeza

```bash
argocd app delete guestbook
kubectl delete namespace argocd
minikube stop
```

## Checklist de conclusão
- [ ] Instalei o Argo CD no cluster local
- [ ] Acessei a interface web e fiz login
- [ ] Criei uma Application a partir de um repositório Git
- [ ] Testei self-healing revertendo uma mudança manual
- [ ] Apliquei GitOps num repositório próprio, com mudança commitada refletindo no cluster

## Notas / Troubleshooting
> Preencha aqui problemas reais (ex: certificado self-signed bloqueando login CLI, port-forward caindo, sync travado em Progressing).
