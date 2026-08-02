# Git — Lab Prático

## Objetivo
Praticar branches, merge, conflitos e recuperação de mudanças.

## Pré-requisitos
- Git instalado (`git --version` pra confirmar)
- Uma conta no GitHub (você já tem)

---

## Lab 1 — Fluxo básico

```bash
mkdir ~/lab-git && cd ~/lab-git
git init
echo "primeira linha" > arquivo.txt
git add arquivo.txt
git commit -m "primeiro commit"
git log --oneline
```

---

## Lab 2 — Branches e merge

```bash
# cria uma branch de feature
git checkout -b feature/nova-funcionalidade
echo "segunda linha" >> arquivo.txt
git add arquivo.txt
git commit -m "adiciona segunda linha"

# volta pra main e faz merge
git checkout main
git merge feature/nova-funcionalidade

git log --oneline --graph --all
```

---

## Lab 3 — Provocando e resolvendo um conflito

```bash
# na main, muda uma linha
git checkout main
echo "linha da main" > conflito.txt
git add conflito.txt
git commit -m "versão da main"

# cria uma branch a partir de um ponto anterior e muda a mesma linha
git checkout -b feature/conflito HEAD~1
echo "linha da feature" > conflito.txt
git add conflito.txt
git commit -m "versão da feature"

# tenta merge de volta na main
git checkout main
git merge feature/conflito
# Git vai acusar conflito em conflito.txt

# abra o arquivo, resolva manualmente removendo os marcadores <<<<<<< ======= >>>>>>>
cat conflito.txt

# depois de resolver:
git add conflito.txt
git commit -m "resolve conflito"
```

---

## Lab 4 — Desfazendo mudanças

```bash
# desfazer mudança não commitada
echo "rascunho" >> arquivo.txt
git restore arquivo.txt
cat arquivo.txt   # deve estar sem "rascunho"

# desfazer um commit já feito, mas de forma segura (revert)
git log --oneline
git revert <hash-do-commit>
```

---

## Lab 5 — Push pro GitHub

```bash
# crie um repo vazio no GitHub antes (sem README)
git remote add origin https://github.com/SEU_USUARIO/lab-git.git
git branch -M main
git push -u origin main
```

---

## Checklist de conclusão
- [ ] Criei commits e naveguei pelo histórico com `git log`
- [ ] Criei uma branch, fiz mudanças e dei merge na main
- [ ] Provoquei e resolvi um conflito manualmente
- [ ] Testei `restore` e `revert`
- [ ] Fiz push de um repositório local pro GitHub

## Notas / Troubleshooting
> Preencha aqui problemas reais que encontrar (ex: já teve um caso de repo com LICENSE exigindo `--allow-unrelated-histories` — documenta esse tipo de coisa aqui).
