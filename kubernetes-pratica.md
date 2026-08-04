# Kubernetes — Lab Prático

## Objetivo
Subir um cluster local e praticar Pods, Deployments, Services, ConfigMaps e scaling.

## Pré-requisitos
- `kubectl` instalado
- Minikube ou Kind instalado (recomendo Minikube pra começar)

```bash
# instalar Minikube (macOS)
brew install minikube

minikube start
kubectl cluster-info
kubectl get nodes
```

---

## Lab 1 — Pod simples

```bash
kubectl run meu-pod --image=nginx:latest --port=80
kubectl get pods
kubectl describe pod meu-pod
kubectl logs meu-pod
kubectl exec -it meu-pod -- bash
# dentro do pod: ls /usr/share/nginx/html && exit
kubectl delete pod meu-pod
```

---

## Lab 2 — Deployment com múltiplas réplicas

Crie `deployment.yaml`:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
spec:
  replicas: 3
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
        - name: nginx
          image: nginx:latest
          ports:
            - containerPort: 80
```

```bash
kubectl apply -f deployment.yaml
kubectl get pods -l app=nginx
kubectl get deployments

# escalar
kubectl scale deployment nginx-deployment --replicas=5
kubectl get pods -l app=nginx

# simular falha: delete um pod e veja o Kubernetes recriar
kubectl delete pod <nome-de-um-pod>
kubectl get pods -l app=nginx -w
```

---

## Lab 3 — Expor com Service

Crie `service.yaml`:

```yaml
apiVersion: v1
kind: Service
metadata:
  name: nginx-service
spec:
  selector:
    app: nginx
  ports:
    - port: 80
      targetPort: 80
  type: NodePort
```

```bash
kubectl apply -f service.yaml
kubectl get services
minikube service nginx-service --url
# acesse a URL retornada no navegador ou curl
```

---

## Lab 4 — ConfigMap e variável de ambiente

```bash
kubectl create configmap app-config --from-literal=AMBIENTE=laboratorio
```

Crie `pod-com-config.yaml`:

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: pod-config
spec:
  containers:
    - name: app
      image: alpine
      command: ["sh", "-c", "echo Ambiente: $AMBIENTE && sleep 3600"]
      envFrom:
        - configMapRef:
            name: app-config
```

```bash
kubectl apply -f pod-com-config.yaml
kubectl logs pod-config
kubectl delete pod pod-config
```

---

## Lab 5 — Rollout e rollback

```bash
kubectl set image deployment/nginx-deployment nginx=nginx:1.25
kubectl rollout status deployment/nginx-deployment
kubectl rollout history deployment/nginx-deployment

# simular problema e reverter
kubectl rollout undo deployment/nginx-deployment
kubectl rollout status deployment/nginx-deployment
```

---

## Limpeza

```bash
kubectl delete -f deployment.yaml
kubectl delete -f service.yaml
minikube stop
```

---

## Checklist de conclusão
- [ ] Subi um cluster local com Minikube
- [ ] Criei e inspecionei um Pod isolado
- [ ] Criei um Deployment, escalei e observei recuperação automática de falha
- [ ] Expus uma aplicação via Service e acessei externamente
- [ ] Usei ConfigMap injetado como variável de ambiente
- [ ] Fiz rollout de nova versão e rollback

## Notas / Troubleshooting
> Preencha aqui problemas reais (ex: pod em `CrashLoopBackOff`, erro de imagem não encontrada, problema de rede no Minikube).
