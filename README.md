# DevOps Cloud Study — notas de teoria e laboratório

![Linux](https://img.shields.io/badge/Linux-FCC624?style=flat&logo=linux&logoColor=black)
![Git](https://img.shields.io/badge/Git-F05032?style=flat&logo=git&logoColor=white)
![Bash](https://img.shields.io/badge/Bash-4EAA25?style=flat&logo=gnubash&logoColor=white)
![Docker](https://img.shields.io/badge/Docker-2496ED?style=flat&logo=docker&logoColor=white)
![Kubernetes](https://img.shields.io/badge/Kubernetes-326CE5?style=flat&logo=kubernetes&logoColor=white)
![Terraform](https://img.shields.io/badge/Terraform-844FBA?style=flat&logo=terraform&logoColor=white)
![Ansible](https://img.shields.io/badge/Ansible-EE0000?style=flat&logo=ansible&logoColor=white)
![AWS](https://img.shields.io/badge/AWS-232F3E?style=flat&logo=amazonaws&logoColor=white)
![Azure](https://img.shields.io/badge/Azure-0078D4?style=flat&logo=microsoftazure&logoColor=white)
![Google Cloud](https://img.shields.io/badge/Google%20Cloud-4285F4?style=flat&logo=googlecloud&logoColor=white)
![GitHub Actions](https://img.shields.io/badge/GitHub%20Actions-2088FF?style=flat&logo=githubactions&logoColor=white)
![Jenkins](https://img.shields.io/badge/Jenkins-D24939?style=flat&logo=jenkins&logoColor=white)
![Helm](https://img.shields.io/badge/Helm-0F1689?style=flat&logo=helm&logoColor=white)
![Argo CD](https://img.shields.io/badge/Argo%20CD-EF7B4D?style=flat&logo=argo&logoColor=white)
![Prometheus](https://img.shields.io/badge/Prometheus-E6522C?style=flat&logo=prometheus&logoColor=white)
![Grafana](https://img.shields.io/badge/Grafana-F46800?style=flat&logo=grafana&logoColor=white)
![Elastic](https://img.shields.io/badge/ELK-005571?style=flat&logo=elastic&logoColor=white)
![Nginx](https://img.shields.io/badge/Nginx-009639?style=flat&logo=nginx&logoColor=white)
![Vault](https://img.shields.io/badge/Vault-FFEC6E?style=flat&logo=vault&logoColor=black)

Notas de estudo em Markdown. Cada assunto tem um arquivo de teoria e um de laboratório, todos na raiz. Não há aplicação, Docker Compose nem cluster neste repositório: os labs são comandos para rodar na sua máquina.

## Stack

Os temas cobertos, na ordem em que as notas se apoiam:

1. Fundamentos: Linux, Git, Bash
2. Containers: Docker, Kubernetes
3. Nuvem: AWS, Azure, Google Cloud
4. Infra como código e configuração: Terraform, Ansible
5. CI/CD e GitOps: GitHub Actions, Jenkins, Helm, Argo CD
6. Observabilidade: Prometheus, Grafana, ELK
7. Rede e segredo: Nginx, Vault

## Estrutura

Não existem as pastas `01-fundamentos/`, `pratica/` nem `teoria.md` solto. O par é `{assunto}-teoria.md` e `{assunto}-pratica.md`.

| Assunto | Teoria | Laboratório |
|---|---|---|
| Linux | `linux-teoria.md` | `linux-pratica.md` |
| Git | `git-teoria.md` | `git-pratica.md` |
| Bash | `bash-teoria.md` | `bash-pratica.md` |
| Docker | `docker-teoria.md` | `docker-pratica.md` |
| Kubernetes | `kubernetes-teoria.md` | `kubernetes-pratica.md` |
| AWS | `aws-teoria.md` | `aws-pratica.md` |
| Azure | `azure-teoria.md` | `azure-pratica.md` |
| Google Cloud | `gcp-teoria.md` | `gcp-pratica.md` |
| Terraform | `terraform-teoria.md` | `terraform-pratica.md` |
| Ansible | `ansible-teoria.md` | `ansible-pratica.md` |
| GitHub Actions | `github-actions-teoria.md` | `github-actions-pratica.md` |
| Jenkins | `jenkins-teoria.md` | `jenkins-pratica.md` |
| Helm | `helm-teoria.md` | `helm-pratica.md` |
| Argo CD | `argo-cd-teoria.md` | `argo-cd-pratica.md` |
| Prometheus | `prometheus-teoria.md` | `prometheus-pratica.md` |
| Grafana | `grafana-teoria.md` | `grafana-pratica.md` |
| ELK | `elk-stack-teoria.md` | `elk-stack-pratica.md` |
| Nginx | `nginx-teoria.md` | `nginx-pratica.md` |
| Vault | `vault-teoria.md` | `vault-pratica.md` |

`linux-teoria.md` explica o que a ferramenta é, conceitos (filesystem, permissão, processo, rede, pacote, log) e referências. `docker-pratica.md` tem objetivo, pré-requisito, labs numerados com comando, checklist e uma seção de troubleshooting para preencher.

## Como ler

```bash
git clone https://github.com/gabrielteramae/devops-cloud-study.git
cd devops-cloud-study
```

Abra a teoria do assunto e depois o laboratório correspondente. Os comandos do lab assumem a ferramenta instalada fora deste repo (por exemplo Docker Desktop em `docker-pratica.md`). Não há servidor para subir aqui.

---

© 2026 Gabriel Teramae Chan
