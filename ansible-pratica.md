# Ansible — Lab Prático

## Pré-requisitos
- Ansible instalado no controlador (`ansible --version`)
- Uma ou mais máquinas alvo com acesso SSH (pode usar containers Docker ou VMs locais/Vagrant)

```bash
# Ansible se conecta via SSH — teste manualmente antes:
ssh usuario@ip-do-servidor
```

---

## Lab 1 — Inventory e ping

Crie `inventory.ini`:
```ini
[web]
servidor1 ansible_host=SEU_IP ansible_user=SEU_USUARIO
```

```bash
ansible -i inventory.ini web -m ping
```

---

## Lab 2 — Primeiro playbook (instalar Nginx)

Crie `playbook.yml`:
```yaml
---
- name: Configurar servidor web
  hosts: web
  become: yes
  tasks:
    - name: Atualizar cache do apt
      apt:
        update_cache: yes

    - name: Instalar Nginx
      apt:
        name: nginx
        state: present

    - name: Garantir Nginx rodando
      service:
        name: nginx
        state: started
        enabled: yes
```

```bash
ansible-playbook -i inventory.ini playbook.yml

# rode de novo — deve mostrar "changed=0" (idempotência)
ansible-playbook -i inventory.ini playbook.yml
```

---

## Lab 3 — Template dinâmico

Crie `templates/index.html.j2`:
```jinja
<h1>Servidor: {{ inventory_hostname }}</h1>
<p>Ambiente: {{ ambiente }}</p>
```

Adicione ao playbook:
```yaml
    - name: Aplicar página customizada
      template:
        src: templates/index.html.j2
        dest: /var/www/html/index.html
      vars:
        ambiente: laboratorio
      notify: Reiniciar nginx

  handlers:
    - name: Reiniciar nginx
      service:
        name: nginx
        state: restarted
```

```bash
ansible-playbook -i inventory.ini playbook.yml
curl http://SEU_IP
```

---

## Lab 4 — Organizando em Role

```bash
ansible-galaxy init roles/webserver
```

Mova as tasks pra `roles/webserver/tasks/main.yml` e o template pra `roles/webserver/templates/`. Novo `playbook.yml`:

```yaml
---
- name: Configurar via role
  hosts: web
  become: yes
  roles:
    - webserver
```

```bash
ansible-playbook -i inventory.ini playbook.yml
```

## Checklist de conclusão
- [ ] Testei conectividade com `ansible -m ping`
- [ ] Rodei um playbook idempotente (segunda execução sem mudanças)
- [ ] Usei template Jinja2 pra gerar arquivo de configuração
- [ ] Organizei o playbook em uma Role reutilizável

## Notas / Troubleshooting
> Preencha aqui problemas reais (ex: erro de chave SSH, `become` pedindo senha de sudo, diferença de módulo `apt` vs `yum` conforme a distro alvo).
