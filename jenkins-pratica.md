# Jenkins — Lab Prático

## Pré-requisitos
- Docker instalado (vamos rodar Jenkins em container, mais simples que instalar nativo)

---

## Lab 1 — Subir Jenkins localmente

```bash
docker run -d --name jenkins \
  -p 8080:8080 -p 50000:50000 \
  -v jenkins-dados:/var/jenkins_home \
  jenkins/jenkins:lts

# pegar senha inicial de admin
docker exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword
```

Acesse `http://localhost:8080`, cole a senha, instale os plugins sugeridos e crie um usuário admin.

---

## Lab 2 — Primeiro pipeline via interface

1. **New Item → Pipeline**, nome `lab-pipeline`
2. Na seção Pipeline, escolha "Pipeline script" e cole:

```groovy
pipeline {
    agent any
    stages {
        stage('Build') {
            steps {
                echo 'Build ok'
            }
        }
        stage('Test') {
            steps {
                echo 'Testes ok'
            }
        }
    }
}
```

3. Salve e clique em **Build Now**
4. Veja o resultado em **Console Output**

---

## Lab 3 — Jenkinsfile versionado no Git

Crie `Jenkinsfile` num repositório de teste:

```groovy
pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }
        stage('Build') {
            steps {
                sh 'echo "Simulando build"'
            }
        }
        stage('Test') {
            steps {
                sh 'echo "Simulando testes"'
            }
        }
    }

    post {
        success {
            echo 'Pipeline concluído com sucesso!'
        }
        failure {
            echo 'Pipeline falhou.'
        }
    }
}
```

No Jenkins: **New Item → Pipeline**, na seção Pipeline escolha "Pipeline script from SCM", aponte pro repositório Git e o caminho do `Jenkinsfile`.

---

## Lab 4 — Credenciais

1. **Manage Jenkins → Credentials → Add Credentials**
2. Adicione um "Username with password" (ex: simulando Docker Hub)
3. Use no pipeline:

```groovy
stage('Login simulado') {
    steps {
        withCredentials([usernamePassword(credentialsId: 'ID_DA_CREDENCIAL', usernameVariable: 'USER', passwordVariable: 'PASS')]) {
            sh 'echo "Logando como $USER"'
        }
    }
}
```

---

## Limpeza

```bash
docker stop jenkins
docker rm jenkins
docker volume rm jenkins-dados
```

## Checklist de conclusão
- [ ] Subi Jenkins localmente via Docker
- [ ] Criei e rodei um pipeline pela interface
- [ ] Versionei um Jenkinsfile num repositório Git e conectei ao Jenkins
- [ ] Usei credenciais gerenciadas em um pipeline

## Notas / Troubleshooting
> Preencha aqui problemas reais (ex: erro de permissão no volume Docker, plugin faltando, timeout de checkout do Git).
