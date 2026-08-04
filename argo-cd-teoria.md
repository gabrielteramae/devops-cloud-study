# Argo CD — Teoria

## O que é e por que importa

Argo CD é uma ferramenta de **GitOps** para Kubernetes: em vez de rodar `kubectl apply` ou `helm upgrade` manualmente (ou via pipeline push-based), o Argo CD monitora continuamente um repositório Git e sincroniza automaticamente o estado do cluster com o que está declarado lá. O Git vira a única fonte da verdade.

## Push-based vs Pull-based deployment

- **Push-based** (ex: GitHub Actions rodando `kubectl apply`): o pipeline de CI empurra mudanças pro cluster — precisa de credenciais do cluster no CI
- **Pull-based (GitOps, Argo CD)**: um agente **dentro** do cluster observa o Git e puxa as mudanças — mais seguro (cluster não expõe credenciais pra fora) e sempre reflete o que está no Git

## Conceitos-chave

### 1. Application

Recurso central do Argo CD — define qual repositório Git observar, qual caminho/branch, e em qual cluster/namespace aplicar.

```yaml
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: minha-app
  namespace: argocd
spec:
  project: default
  source:
    repoURL: https://github.com/seu-usuario/seu-repo.git
    targetRevision: main
    path: manifests/
  destination:
    server: https://kubernetes.default.svc
    namespace: minha-app
  syncPolicy:
    automated:
      prune: true       # remove recursos que saíram do Git
      selfHeal: true     # reverte mudanças manuais feitas fora do Git
```

### 2. Sync

Ação de sincronizar o estado do cluster com o Git. Pode ser manual ou automática (`syncPolicy.automated`).

```bash
argocd app sync minha-app
argocd app get minha-app
```

### 3. Self-healing

Se alguém alterar um recurso manualmente no cluster (ex: `kubectl edit`), o Argo CD detecta a divergência do Git e reverte automaticamente — reforça o Git como única fonte da verdade.

### 4. Estados de sincronização

- **Synced**: cluster reflete exatamente o Git
- **OutOfSync**: há diferença entre Git e cluster
- **Healthy/Degraded**: status de saúde dos recursos (ex: Pods rodando corretamente)

### 5. App of Apps

Padrão onde uma Application do Argo CD gerencia outras Applications — útil pra organizar múltiplos microsserviços ou ambientes (dev/staging/prod) de forma escalável.

## Por que isso conecta com o resto do roadmap

- **Kubernetes** (módulo 02): Argo CD atua diretamente sobre os recursos já vistos (Deployment, Service, ConfigMap)
- **Helm**: Argo CD pode usar charts Helm como fonte dos manifests
- **Git** (módulo 01): o modelo GitOps depende inteiramente de disciplina de versionamento — branches, PRs e histórico bem cuidados

## Referências para aprofundar
- argo-cd.readthedocs.io
- OpenGitOps princípios (opengitops.dev)
