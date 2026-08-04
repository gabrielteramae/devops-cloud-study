# Ansible — Teoria

## O que é e por que importa

Ansible é uma ferramenta de automação de configuração (Configuration Management) — enquanto Terraform provisiona infraestrutura ("criar a VM"), Ansible configura o que roda dentro dela ("instalar Nginx, configurar usuários, aplicar patches"). É agentless: não precisa instalar nada no servidor-alvo, só acesso SSH.

## Conceitos-chave

### 1. Inventory

Lista de hosts que o Ansible vai gerenciar.

```ini
# inventory.ini
[web]
servidor1 ansible_host=192.168.1.10
servidor2 ansible_host=192.168.1.11

[db]
servidor3 ansible_host=192.168.1.20
```

### 2. Playbook

Arquivo YAML declarativo com uma sequência de tarefas.

```yaml
---
- name: Configurar servidores web
  hosts: web
  become: yes
  tasks:
    - name: Instalar Nginx
      apt:
        name: nginx
        state: present
        update_cache: yes

    - name: Garantir que Nginx está rodando
      service:
        name: nginx
        state: started
        enabled: yes
```

```bash
ansible-playbook -i inventory.ini playbook.yml
```

### 3. Módulos

Cada tarefa usa um módulo (`apt`, `service`, `copy`, `template`, `user`, etc.) que abstrai a ação, tornando o playbook idempotente — rodar duas vezes produz o mesmo resultado, sem efeitos colaterais.

### 4. Variáveis

```yaml
vars:
  pacote: nginx
tasks:
  - name: Instalar pacote
    apt:
      name: "{{ pacote }}"
      state: present
```

### 5. Templates (Jinja2)

Permitem gerar arquivos de configuração dinamicamente.

```jinja
# templates/nginx.conf.j2
server {
    listen 80;
    server_name {{ dominio }};
}
```

```yaml
- name: Aplicar config do Nginx
  template:
    src: templates/nginx.conf.j2
    dest: /etc/nginx/sites-available/default
```

### 6. Roles

Estrutura padronizada pra organizar playbooks complexos em componentes reutilizáveis (tasks, handlers, templates, vars separados por papel — ex: role "webserver", role "database").

### 7. Handlers

Tarefas que só rodam quando notificadas (ex: reiniciar serviço apenas se a configuração mudou).

```yaml
tasks:
  - name: Copiar config
    template:
      src: nginx.conf.j2
      dest: /etc/nginx/nginx.conf
    notify: Reiniciar nginx

handlers:
  - name: Reiniciar nginx
    service:
      name: nginx
      state: restarted
```

## Por que isso conecta com o resto do roadmap

- **Terraform**: fluxo comum é Terraform provisionar a infraestrutura e Ansible configurar o que roda nela
- **Linux/Bash** (módulo 01): Ansible executa, nos bastidores, muitas das mesmas operações que você faria manualmente via SSH e shell
- **CI/CD**: pipelines podem rodar playbooks Ansible como parte do processo de deploy

## Referências para aprofundar
- docs.ansible.com
- Ansible Galaxy — repositório de roles reutilizáveis
