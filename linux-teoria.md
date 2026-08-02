# Linux — Teoria

## O que é e por que importa em DevOps

Linux é o sistema operacional base da esmagadora maioria dos servidores, containers e clusters Kubernetes em produção. Entender Linux profundamente é pré-requisito para tudo que vem depois no roadmap (Docker, Kubernetes, cloud, CI/CD) — todos rodam sobre ou interagem diretamente com um kernel Linux.

## Conceitos-chave

### 1. Sistema de arquivos (Filesystem Hierarchy Standard - FHS)

| Diretório | Função |
|---|---|
| `/etc` | Arquivos de configuração do sistema |
| `/var` | Dados variáveis (logs, cache, filas) |
| `/home` | Diretórios pessoais dos usuários |
| `/usr` | Programas e bibliotecas instalados |
| `/bin`, `/sbin` | Binários essenciais (usuário/sistema) |
| `/proc`, `/sys` | Interfaces virtuais para kernel e processos |
| `/opt` | Software de terceiros |
| `/tmp` | Arquivos temporários |

### 2. Permissões e usuários

- Cada arquivo tem dono (`owner`), grupo (`group`) e outros (`others`)
- Permissões: `r` (read=4), `w` (write=2), `x` (execute=1)
- `chmod 755 arquivo` — dono: rwx, grupo: r-x, outros: r-x
- `chown usuario:grupo arquivo` — muda dono/grupo
- Usuário `root` tem privilégios totais; `sudo` executa comandos como root pontualmente

### 3. Processos

- Todo processo tem um PID (Process ID) e um PPID (Parent PID)
- Estados: running, sleeping, stopped, zombie
- `systemd` é o init system moderno — gerencia serviços (`systemctl start/stop/enable`)
- Sinais: `SIGTERM` (15, pede pra terminar), `SIGKILL` (9, força), `SIGHUP` (1, reload)

### 4. Rede básica

- `ip a` / `ifconfig` — interfaces de rede
- `ss -tulnp` / `netstat` — portas abertas e conexões
- `/etc/hosts` — resolução de nomes local
- `/etc/resolv.conf` — configuração de DNS

### 5. Gerenciamento de pacotes

- Debian/Ubuntu: `apt` (`.deb`)
- RHEL/CentOS/Fedora: `yum`/`dnf` (`.rpm`)
- Universal: containers evitam esse problema empacotando tudo junto (ver Docker)

### 6. Logs

- `/var/log/syslog` ou `/var/log/messages` — logs gerais do sistema
- `journalctl` — logs do systemd (substituiu muito do syslog tradicional)
- Fundamental entender antes de ELK Stack (módulo 06)

## Por que isso conecta com o resto do roadmap

- **Docker/Kubernetes**: containers são processos Linux isolados por namespaces e cgroups — sem entender processos e permissões, K8s vira "caixa preta"
- **Bash**: é a ferramenta que você usa pra operar tudo isso no dia a dia
- **Cloud (AWS/Azure/GCP)**: instâncias de VM que você provisiona são, no fundo, servidores Linux
- **Ansible**: automatiza exatamente as tarefas administrativas descritas aqui

## Referências para aprofundar
- The Linux Command Line (livro, William Shotts) — gratuito online
- `man` pages de cada comando (`man chmod`, `man systemctl`, etc.)
