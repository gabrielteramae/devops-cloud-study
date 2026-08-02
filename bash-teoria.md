# Bash — Teoria

## O que é e por que importa em DevOps

Bash é a shell mais usada em sistemas Linux e a linguagem de facto para automação de tarefas de sistema, scripts de CI/CD, provisionamento e "cola" entre outras ferramentas (Docker, kubectl, Terraform, AWS CLI). Praticamente todo pipeline de CI/CD (GitHub Actions, Jenkins) executa passos como comandos de shell nos bastidores.

## Conceitos-chave

### 1. Variáveis

```bash
NOME="Gabriel"
echo "Olá, $NOME"          # interpolação de variável
echo "Olá, ${NOME}!"       # forma explícita, evita ambiguidade

# variáveis de ambiente
export AMBIENTE=producao
echo $AMBIENTE
```

### 2. Argumentos e variáveis especiais

```bash
#!/bin/bash
echo "Script: $0"
echo "Primeiro argumento: $1"
echo "Todos os argumentos: $@"
echo "Quantidade de argumentos: $#"
echo "Código de saída do último comando: $?"
```

### 3. Condicionais

```bash
if [ "$AMBIENTE" == "producao" ]; then
    echo "Cuidado, é produção!"
elif [ "$AMBIENTE" == "staging" ]; then
    echo "Ambiente de staging"
else
    echo "Ambiente desconhecido"
fi

# testes comuns
[ -f arquivo.txt ]   # arquivo existe?
[ -d pasta ]         # diretório existe?
[ -z "$VAR" ]        # string vazia?
[ "$A" -eq "$B" ]    # comparação numérica
```

### 4. Loops

```bash
# for
for i in 1 2 3; do
    echo "Número: $i"
done

# while
contador=0
while [ $contador -lt 5 ]; do
    echo "Contador: $contador"
    contador=$((contador + 1))
done

# iterando sobre arquivos
for arquivo in *.log; do
    echo "Processando $arquivo"
done
```

### 5. Funções

```bash
saudacao() {
    local nome=$1
    echo "Olá, $nome!"
}

saudacao "Mundo"
```

### 6. Pipes e redirecionamento

```bash
comando1 | comando2      # saída de comando1 vira entrada de comando2
comando > arquivo.txt     # redireciona saída pra arquivo (sobrescreve)
comando >> arquivo.txt    # redireciona saída pra arquivo (concatena)
comando 2> erros.log      # redireciona stderr
comando &> tudo.log       # redireciona stdout e stderr juntos
```

### 7. Boas práticas em scripts

```bash
#!/bin/bash
set -euo pipefail
# -e: para o script se qualquer comando falhar
# -u: erro se usar variável não definida
# -o pipefail: erro se qualquer comando de um pipe falhar (não só o último)
```

## Por que isso conecta com o resto do roadmap

- **CI/CD**: steps de pipelines (GitHub Actions, Jenkins) rodam scripts shell
- **Docker**: `Dockerfile` usa comandos shell (`RUN`, `CMD`, `ENTRYPOINT`)
- **Kubernetes**: scripts de deploy e automação usam `kubectl` combinado com Bash
- **Ansible**: embora use YAML declarativo, entender shell ajuda a debugar módulos `shell`/`command`
- **Cloud CLIs (aws, az, gcloud)**: automação de infraestrutura via scripts

## Referências para aprofundar
- ShellCheck (shellcheck.net) — linter essencial pra scripts Bash
- `man bash` — documentação completa
