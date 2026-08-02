# Bash — Lab Prático

## Objetivo
Escrever scripts reais usando variáveis, condicionais, loops e funções.

## Pré-requisitos
- Terminal Linux/macOS ou WSL

---

## Lab 1 — Script básico com variáveis e argumentos

Crie o arquivo `saudacao.sh`:

```bash
#!/bin/bash
set -euo pipefail

nome=${1:-"visitante"}
echo "Olá, $nome! Hoje é $(date +%Y-%m-%d)"
```

```bash
chmod +x saudacao.sh
./saudacao.sh Gabriel
./saudacao.sh   # testa o valor default
```

---

## Lab 2 — Verificador de espaço em disco

Crie `check-disco.sh`:

```bash
#!/bin/bash
set -euo pipefail

limite=80
uso=$(df / | tail -1 | awk '{print $5}' | tr -d '%')

if [ "$uso" -ge "$limite" ]; then
    echo "ALERTA: uso de disco em ${uso}%, acima do limite de ${limite}%"
    exit 1
else
    echo "OK: uso de disco em ${uso}%"
fi
```

```bash
chmod +x check-disco.sh
./check-disco.sh
echo "Código de saída: $?"
```

---

## Lab 3 — Backup automatizado com loop

Crie `backup.sh`:

```bash
#!/bin/bash
set -euo pipefail

origem="./dados"
destino="./backups"
data=$(date +%Y%m%d_%H%M%S)

mkdir -p "$origem" "$destino"
touch "$origem/arquivo1.txt" "$origem/arquivo2.txt"

for arquivo in "$origem"/*; do
    nome_base=$(basename "$arquivo")
    cp "$arquivo" "$destino/${nome_base%.txt}_${data}.txt"
    echo "Backup feito: $nome_base"
done
```

```bash
chmod +x backup.sh
./backup.sh
ls backups/
```

---

## Lab 4 — Função reutilizável + log estruturado

Crie `deploy-simulado.sh`:

```bash
#!/bin/bash
set -euo pipefail

log() {
    local nivel=$1
    local mensagem=$2
    echo "[$(date +%H:%M:%S)] [$nivel] $mensagem"
}

log "INFO" "Iniciando deploy simulado"

for etapa in "build" "test" "deploy"; do
    log "INFO" "Executando etapa: $etapa"
    sleep 1
done

log "INFO" "Deploy concluído com sucesso"
```

```bash
chmod +x deploy-simulado.sh
./deploy-simulado.sh
```

---

## Lab 5 — Lint com ShellCheck

```bash
# instalar (macOS)
brew install shellcheck

# rodar contra os scripts que você criou
shellcheck saudacao.sh check-disco.sh backup.sh deploy-simulado.sh
```

---

## Checklist de conclusão
- [ ] Criei um script com argumentos e valor default
- [ ] Criei um script com condicional baseado em comando externo (`df`)
- [ ] Criei um script com loop `for` processando arquivos
- [ ] Criei uma função reutilizável de log
- [ ] Rodei ShellCheck e corrigi os warnings apontados

## Notas / Troubleshooting
> Preencha aqui problemas reais (ex: erro de "permission denied" ao rodar script sem `chmod +x`, ou diferenças de comportamento do Bash entre macOS e Linux).
