# Vault — Lab Prático

## Pré-requisitos
- Docker instalado (rodaremos em modo "dev" — nunca use modo dev em produção)

---

## Lab 1 — Subir Vault em modo dev

```bash
docker run -d --name vault \
  -p 8200:8200 \
  -e 'VAULT_DEV_ROOT_TOKEN_ID=meu-token-dev' \
  --cap-add=IPC_LOCK \
  hashicorp/vault

export VAULT_ADDR='http://127.0.0.1:8200'
export VAULT_TOKEN='meu-token-dev'

docker exec -e VAULT_ADDR=$VAULT_ADDR -e VAULT_TOKEN=$VAULT_TOKEN vault vault status
```

---

## Lab 2 — Secrets Engine KV

```bash
docker exec -e VAULT_ADDR=$VAULT_ADDR -e VAULT_TOKEN=$VAULT_TOKEN vault \
  vault kv put secret/minha-app usuario=admin senha=senha-super-secreta

docker exec -e VAULT_ADDR=$VAULT_ADDR -e VAULT_TOKEN=$VAULT_TOKEN vault \
  vault kv get secret/minha-app

docker exec -e VAULT_ADDR=$VAULT_ADDR -e VAULT_TOKEN=$VAULT_TOKEN vault \
  vault kv get -field=senha secret/minha-app
```

---

## Lab 3 — Policy e token com permissão limitada

Crie `minha-policy.hcl`:
```hcl
path "secret/data/minha-app" {
  capabilities = ["read"]
}
```

```bash
docker cp minha-policy.hcl vault:/tmp/minha-policy.hcl

docker exec -e VAULT_ADDR=$VAULT_ADDR -e VAULT_TOKEN=$VAULT_TOKEN vault \
  vault policy write minha-policy /tmp/minha-policy.hcl

# criar token com essa policy
docker exec -e VAULT_ADDR=$VAULT_ADDR -e VAULT_TOKEN=$VAULT_TOKEN vault \
  vault token create -policy=minha-policy
```

Copie o token gerado e teste com ele (deve conseguir ler, mas não escrever):
```bash
export VAULT_TOKEN_LIMITADO=<token-gerado>

docker exec -e VAULT_ADDR=$VAULT_ADDR -e VAULT_TOKEN=$VAULT_TOKEN_LIMITADO vault \
  vault kv get secret/minha-app

# isso deve falhar (sem permissão de escrita):
docker exec -e VAULT_ADDR=$VAULT_ADDR -e VAULT_TOKEN=$VAULT_TOKEN_LIMITADO vault \
  vault kv put secret/minha-app usuario=hacker
```

---

## Lab 4 — Versionamento de segredos (KV v2)

```bash
docker exec -e VAULT_ADDR=$VAULT_ADDR -e VAULT_TOKEN=$VAULT_TOKEN vault \
  vault kv put secret/minha-app usuario=admin senha=nova-senha-v2

# ver histórico de versões
docker exec -e VAULT_ADDR=$VAULT_ADDR -e VAULT_TOKEN=$VAULT_TOKEN vault \
  vault kv metadata get secret/minha-app

# recuperar versão anterior
docker exec -e VAULT_ADDR=$VAULT_ADDR -e VAULT_TOKEN=$VAULT_TOKEN vault \
  vault kv get -version=1 secret/minha-app
```

---

## Limpeza

```bash
docker stop vault
docker rm vault
```

## Checklist de conclusão
- [ ] Subi Vault em modo dev e confirmei status
- [ ] Armazenei e li um segredo via KV engine
- [ ] Criei uma policy restrita e testei um token limitado por ela
- [ ] Naveguei pelo versionamento de segredos (KV v2)

## Notas / Troubleshooting
> Preencha aqui problemas reais (ex: token expirado, engine não habilitada no path esperado, diferença de sintaxe entre KV v1 e v2).
