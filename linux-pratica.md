# Linux — Lab Prático

## Objetivo
Fixar na prática os conceitos de permissões, processos, rede e systemd.

## Pré-requisitos
- Uma VM ou WSL/container Linux (Ubuntu recomendado)
- Terminal com acesso sudo

---

## Lab 1 — Permissões e usuários

```bash
# Criar estrutura de teste
mkdir -p ~/lab-linux/permissoes && cd ~/lab-linux/permissoes
touch script.sh dados.txt

# Ver permissões atuais
ls -la

# Tornar script.sh executável apenas pelo dono
chmod 700 script.sh

# Dar leitura pra todos, escrita só pro dono em dados.txt
chmod 644 dados.txt

# Criar um grupo e mudar o dono do arquivo
sudo groupadd devops
sudo chown $USER:devops dados.txt
```

**Desafio:** explique em um comentário no arquivo por que `chmod 777` é geralmente uma má prática de segurança.

---

## Lab 2 — Processos e systemd

```bash
# Rodar um processo em background
sleep 300 &
jobs

# Ver o PID dele
ps aux | grep sleep

# Matar o processo
kill -15 <PID>   # SIGTERM (educado)
# se não morrer:
kill -9 <PID>    # SIGKILL (força)

# Criar um serviço systemd simples (exemplo)
sudo tee /etc/systemd/system/meu-teste.service <<EOF
[Unit]
Description=Serviço de teste

[Service]
ExecStart=/bin/sleep infinity
Restart=always

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl start meu-teste
sudo systemctl status meu-teste
sudo systemctl stop meu-teste
```

---

## Lab 3 — Rede básica

```bash
# Ver interfaces e IPs
ip a

# Ver portas escutando
ss -tulnp

# Testar conectividade
ping -c 4 8.8.8.8

# Ver resolução DNS
cat /etc/resolv.conf
nslookup github.com
```

---

## Lab 4 — Logs

```bash
# Ver últimos logs do sistema
journalctl -n 50

# Ver logs de um serviço específico
journalctl -u ssh -n 20

# Seguir logs em tempo real (como tail -f)
journalctl -f
```

---

## Checklist de conclusão
- [ ] Criei arquivos e ajustei permissões corretamente
- [ ] Criei e gerenciei um serviço systemd
- [ ] Consegui listar interfaces de rede e portas abertas
- [ ] Consultei logs via journalctl

## Notas / Troubleshooting
> Preencha aqui os problemas que encontrar durante a prática e como resolveu — no seu estilo de documentar issues reais.
