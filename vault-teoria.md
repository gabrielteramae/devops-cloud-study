# Vault — Teoria

## O que é e por que importa

HashiCorp Vault é a ferramenta padrão de gerenciamento de segredos (secrets management) — senhas, tokens de API, certificados, chaves de criptografia. Em vez de espalhar segredos em arquivos `.env`, variáveis de ambiente hardcoded ou (pior) commitados no Git, Vault centraliza, criptografa, audita e controla o acesso a esses dados sensíveis.

## Conceitos-chave

### 1. Secrets Engines

Vault organiza segredos em "engines" plugáveis, cada uma com um propósito.

- **KV (Key-Value)**: armazenamento simples de pares chave-valor
- **Database**: gera credenciais de banco de dados **dinâmicas e temporárias**
- **PKI**: emite certificados TLS sob demanda
- **Transit**: criptografia como serviço (Vault criptografa/descriptografa sem armazenar o dado)

```bash
vault secrets enable -path=secret kv-v2
vault kv put secret/minha-app senha=super-secreta
vault kv get secret/minha-app
```

### 2. Segredos dinâmicos (diferencial principal)

Em vez de uma senha fixa de banco de dados que nunca muda, Vault pode gerar credenciais temporárias sob demanda, com TTL (tempo de vida) definido — reduzindo drasticamente o risco de vazamento de longo prazo.

```bash
vault read database/creds/minha-role
# retorna username/password válidos só por um período limitado
```

### 3. Autenticação (Auth Methods)

Vault suporta múltiplos métodos de autenticação: token, userpass, LDAP, AppRole (usado por aplicações/CI), Kubernetes (pods se autenticam via service account).

```bash
vault auth enable approle
vault write auth/approle/role/minha-app \
  token_policies="minha-policy" \
  token_ttl=1h
```

### 4. Policies

Definem, em HCL, o que uma identidade autenticada pode acessar.

```hcl
# minha-policy.hcl
path "secret/data/minha-app" {
  capabilities = ["read"]
}
```

```bash
vault policy write minha-policy minha-policy.hcl
```

### 5. Selamento (Seal/Unseal)

Ao iniciar, Vault fica "selado" (sealed) — dados criptografados e inacessíveis até que um número mínimo de "unseal keys" (esquema Shamir's Secret Sharing) seja fornecido. Garante que nenhuma pessoa sozinha consiga acessar tudo.

```bash
vault operator init
vault operator unseal
```

### 6. Audit logging

Vault registra todo acesso a segredos — essencial pra compliance e investigação de incidentes.

## Por que isso conecta com o resto do roadmap

- **Kubernetes**: pods podem se autenticar no Vault via service account e puxar segredos dinamicamente, em vez de usar Secrets estáticos do próprio K8s
- **CI/CD (GitHub Actions, Jenkins)**: pipelines buscam credenciais do Vault em vez de tê-las hardcoded como secrets estáticos
- **Terraform**: pode ler segredos do Vault durante o provisionamento (`data "vault_generic_secret"`)

## Referências para aprofundar
- developer.hashicorp.com/vault/docs
- learn.hashicorp.com — tutoriais guiados
