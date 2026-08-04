# Kubernetes — Teoria

## O que é e por que importa em DevOps

Kubernetes (K8s) é a plataforma de orquestração de containers padrão da indústria. Enquanto Docker roda um container isolado, Kubernetes gerencia centenas ou milhares deles em produção: reinicia containers que falham, distribui carga, escala automaticamente, faz rollout/rollback de novas versões e gerencia configuração e segredos de forma declarativa.

## Arquitetura básica

- **Control Plane**: cérebro do cluster (API Server, Scheduler, Controller Manager, etcd)
- **Nodes (Worker Nodes)**: máquinas onde os containers de fato rodam
- **kubelet**: agente em cada node que garante que os containers descritos estão rodando
- **kube-proxy**: gerencia regras de rede em cada node

Você interage com o cluster via `kubectl`, que fala com o API Server.

## Conceitos-chave

### 1. Pod

Menor unidade implantável no Kubernetes — um ou mais containers que compartilham rede e armazenamento.

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: meu-pod
spec:
  containers:
    - name: app
      image: nginx:latest
      ports:
        - containerPort: 80
```

```bash
kubectl apply -f pod.yaml
kubectl get pods
kubectl describe pod meu-pod
kubectl logs meu-pod
kubectl delete pod meu-pod
```

### 2. Deployment

Gerencia um conjunto de Pods idênticos (ReplicaSet por trás), garantindo réplicas desejadas, rollout gradual e rollback.

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: minha-app
spec:
  replicas: 3
  selector:
    matchLabels:
      app: minha-app
  template:
    metadata:
      labels:
        app: minha-app
    spec:
      containers:
        - name: app
          image: minha-app:1.0
          ports:
            - containerPort: 8000
```

```bash
kubectl apply -f deployment.yaml
kubectl get deployments
kubectl scale deployment minha-app --replicas=5
kubectl rollout status deployment minha-app
kubectl rollout undo deployment minha-app
```

### 3. Service

Expõe um conjunto de Pods como um endpoint estável (Pods têm IP efêmero, Services não).

| Tipo | Uso |
|---|---|
| `ClusterIP` (padrão) | Acesso interno ao cluster |
| `NodePort` | Expõe em uma porta fixa de cada node |
| `LoadBalancer` | Provisiona load balancer do cloud provider |

```yaml
apiVersion: v1
kind: Service
metadata:
  name: minha-app-service
spec:
  selector:
    app: minha-app
  ports:
    - port: 80
      targetPort: 8000
  type: ClusterIP
```

### 4. ConfigMap e Secret

Separam configuração e dados sensíveis da imagem do container.

```bash
kubectl create configmap minha-config --from-literal=AMBIENTE=producao
kubectl create secret generic minha-secret --from-literal=SENHA=super-secreta
```

### 5. Namespace

Isola recursos logicamente dentro do mesmo cluster (ex: `dev`, `staging`, `prod`).

```bash
kubectl create namespace dev
kubectl get pods -n dev
```

### 6. Ingress

Gerencia acesso HTTP/HTTPS externo, roteando por hostname/path pra diferentes Services (geralmente precisa de um Ingress Controller como Nginx).

## Por que isso conecta com o resto do roadmap

- **Helm** (módulo 05): empacota manifests Kubernetes complexos em "charts" reutilizáveis
- **Argo CD** (módulo 05): aplica GitOps sobre Kubernetes — o Git vira fonte da verdade do estado do cluster
- **Prometheus/Grafana** (módulo 06): monitoramento nativo de clusters Kubernetes
- **Terraform** (módulo 04): provisiona a infraestrutura do próprio cluster (ex: EKS, AKS, GKE)

## Referências para aprofundar
- kubernetes.io/docs — documentação oficial
- Minikube ou Kind — pra rodar cluster localmente nos labs
