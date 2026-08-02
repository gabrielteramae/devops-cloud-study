# Git — Teoria

## O que é e por que importa em DevOps

Git é o sistema de controle de versão distribuído usado por praticamente toda a indústria de software. Em DevOps, Git é a base de tudo: pipelines de CI/CD disparam a partir de eventos Git (push, merge, tag), infraestrutura como código (Terraform, Ansible) é versionada em Git, e ferramentas de GitOps (Argo CD) usam o Git como fonte única da verdade do estado desejado do sistema.

## Conceitos-chave

### 1. Repositório e working directory

- **Working directory**: seus arquivos no disco
- **Staging area (index)**: onde você prepara o que vai entrar no próximo commit
- **Repositório (.git)**: histórico completo, versionado localmente

```bash
git init                  # cria repositório novo
git status                # mostra estado atual (modificado, staged, etc.)
git add arquivo.txt        # move pra staging area
git commit -m "mensagem"  # grava snapshot no histórico
```

### 2. Branches

- Branch é um ponteiro móvel para um commit
- `main`/`master` costuma ser a branch principal (produção)
- Branches de feature isolam trabalho em desenvolvimento sem afetar o código estável

```bash
git branch nome-da-branch       # cria
git checkout nome-da-branch     # muda pra ela
git checkout -b nome-da-branch  # cria e muda de uma vez
git switch nome-da-branch       # forma moderna de trocar de branch
```

### 3. Merge vs Rebase

- **Merge**: junta o histórico de duas branches criando um commit de merge (preserva histórico real)
- **Rebase**: reescreve o histórico da branch aplicando os commits sobre outra base (histórico linear, mas reescreve commits — cuidado em branches compartilhadas)

```bash
git merge outra-branch
git rebase main
```

### 4. Remoto (origin)

- `origin` é o nome padrão do repositório remoto (ex: GitHub)
- `push` envia commits locais pro remoto; `pull` traz e integra commits do remoto

```bash
git remote add origin <url>
git push -u origin main    # -u define upstream (próximos pushes não precisam repetir origin main)
git pull origin main
git fetch                 # baixa mudanças sem integrar automaticamente
```

### 5. Conflitos

Acontecem quando duas branches alteram a mesma linha do mesmo arquivo de formas diferentes. Git marca o conflito no arquivo com `<<<<<<<`, `=======`, `>>>>>>>` e espera resolução manual antes de finalizar o merge/rebase.

### 6. Desfazer mudanças

```bash
git restore arquivo.txt          # descarta mudança não commitada
git reset --soft HEAD~1          # desfaz último commit, mantém mudanças staged
git reset --hard HEAD~1          # desfaz último commit e descarta tudo (cuidado!)
git revert <hash>                # cria um novo commit que desfaz outro (seguro em histórico compartilhado)
```

### 7. `.gitignore`

Arquivo que lista o que o Git deve ignorar (ex: `node_modules/`, `.env`, `venv/`). Essencial pra não versionar segredos ou arquivos gerados.

## Por que isso conecta com o resto do roadmap

- **CI/CD (GitHub Actions, Jenkins)**: pipelines são disparados por eventos Git
- **GitOps (Argo CD)**: o estado do cluster Kubernetes é definido a partir de um repositório Git
- **Terraform/Ansible**: infraestrutura como código só funciona bem com versionamento Git disciplinado
- **Colaboração em equipe**: pull requests, code review e branch strategies (Git Flow, trunk-based) são padrão em qualquer time DevOps

## Referências para aprofundar
- Pro Git Book (gratuito, git-scm.com/book)
- `git log --graph --oneline --all` — ótimo pra visualizar histórico de branches
