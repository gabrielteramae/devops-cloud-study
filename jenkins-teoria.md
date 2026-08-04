# Jenkins — Teoria

## O que é e por que importa

Jenkins é a ferramenta de CI/CD open-source mais tradicional e ainda extremamente usada em empresas grandes/corporativas, especialmente as que rodam infraestrutura própria (on-premise) ou têm pipelines legados. Diferente do GitHub Actions (SaaS, integrado ao GitHub), Jenkins é auto-hospedado e altamente extensível via plugins.

## Conceitos-chave

### 1. Arquitetura

- **Controller (master)**: coordena os jobs, interface web, agendamento
- **Agents (workers)**: máquinas que executam os builds de fato — permite escalar e isolar cargas de trabalho

### 2. Job / Pipeline

- **Freestyle job**: configuração via interface gráfica (mais antigo, menos versionável)
- **Pipeline**: definido em código (`Jenkinsfile`), versionado no Git — abordagem moderna recomendada

### 3. Jenkinsfile (Declarative Pipeline)

```groovy
pipeline {
    agent any

    stages {
        stage('Build') {
            steps {
                echo 'Compilando aplicação...'
                sh 'echo build ok'
            }
        }
        stage('Test') {
            steps {
                echo 'Rodando testes...'
                sh 'echo testes ok'
            }
        }
        stage('Deploy') {
            steps {
                echo 'Fazendo deploy...'
            }
        }
    }
}
```

### 4. Stages e Steps

- **Stage**: fase lógica do pipeline (Build, Test, Deploy) — aparece visualmente no painel do Jenkins
- **Step**: comando individual dentro de um stage

### 5. Triggers

```groovy
triggers {
    pollSCM('H/5 * * * *')   // verifica mudanças no repo a cada 5 min
}
```
Também pode ser configurado via webhook do Git (mais eficiente que polling).

### 6. Credentials

Jenkins tem um sistema de gerenciamento de credenciais (tokens, senhas, chaves SSH) armazenadas de forma criptografada e referenciadas no pipeline sem expor o valor.

```groovy
withCredentials([usernamePassword(credentialsId: 'docker-hub', usernameVariable: 'USER', passwordVariable: 'PASS')]) {
    sh 'docker login -u $USER -p $PASS'
}
```

### 7. Plugins

Jenkins tem um ecossistema enorme de plugins (Docker, Kubernetes, Slack notifications, SonarQube, etc.) — é uma das razões da sua popularidade em ambientes corporativos com necessidades muito específicas.

## Jenkins vs GitHub Actions

| | Jenkins | GitHub Actions |
|---|---|---|
| Hospedagem | Self-hosted (você mantém) | SaaS (GitHub mantém) |
| Configuração | Jenkinsfile (Groovy) | YAML |
| Ecossistema | Plugins extensos | Marketplace de Actions |
| Uso comum | Empresas grandes, legado, on-premise | Projetos open-source, startups, GitHub-native |

## Por que isso conecta com o resto do roadmap

- **Docker**: pipelines Jenkins frequentemente rodam dentro de containers Docker como agents
- **Kubernetes**: Jenkins pode rodar como pods dinâmicos em um cluster (Jenkins Kubernetes plugin)
- **Terraform/Ansible**: pipelines Jenkins orquestram IaC da mesma forma que GitHub Actions

## Referências para aprofundar
- jenkins.io/doc
- Jenkins Pipeline Syntax reference (embutido na própria interface do Jenkins)
