# 🚚 NexumLog - Automação e Monitoramento Logístico em Tempo Real

O **NexumLog** é um projeto de engenharia e automação de dados focado no monitoramento e simulação de rotas operacionais para logística de transporte e exportação.

A solução conecta um banco de dados relacional **PostgreSQL (Supabase)** a uma esteira dupla de automação no **n8n**, permitindo a geração contínua de pedidos de transporte simulados e o disparo automático de notificações por e-mail em tempo real via Webhooks e Triggers de banco de dados.

---

## 🎯 Arquitetura da Solução

O ecossistema opera através de duas esteiras conectadas em segundo plano:

1. **Esteira Geradora (Simulação Operacional):**
   * **Schedule Trigger:** Dispara periodicamente (ex: a cada 5 minutos).
   * **PostgreSQL Nodes:** Consulta os IDs válidos de clientes e veículos no Supabase e insere um novo pedido simulado na tabela `pedido_tb`.
   * **JavaScript Code Node:** Executa a lógica de sorteio aleatório de destinos (portos brasileiros), tipos de contêineres (`20ft`, `40ft`, `40ft HC`), peso da carga e status inicial.

2. **Esteira Notificadora (Event-Driven Notifications):**
   * **PostgreSQL Trigger (`trg_insere_log`):** Identifica novos registros na tabela `pedido_tb` e gera automaticamente o histórico na `log_status_pedido_tb`.
   * **Webhook Integration:** Consome os eventos de inserção gerados pelo Supabase.
   * **Enriquecimento & Disparo:** Realiza o `JOIN` relacional entre as tabelas de pedidos, clientes, veículos e status para compor e enviar um e-mail formatado via **Gmail**.

---

## 🛠️ Tecnologias Utilizadas

* **[Supabase](https://supabase.com/):** Banco de dados PostgreSQL gerenciado na nuvem (conexão via Transaction Pooler, porta `6543`).
* **[n8n](https://n8n.io/):** Plataforma de automação de workflows baseada em nós.
* **JavaScript (Node.js):** Lógica de geração e sorteio de dados sintéticos dentro do n8n (`snake_case`).
* **PL/pgSQL:** Funções e Triggers automatizadas para auditoria e logs de alterações no banco de dados.
* **Python / Jupyter Notebooks:** Carga inicial e população do banco com dados sintéticos (`Faker`).

---

## 🗄️ Modelagem de Dados

O banco de dados relacional é composto por 5 tabelas principais:

1. **`cliente_tb`**: Cadastro dos clientes contratantes (Razão Social, CNPJ/CPF, e-mail, telefone).
2. **`veiculo_tb`**: Frota de caminhões cadastrada (placa, modelo, capacidade de carga).
3. **`status_pedido_tb`**: Tabela de domínio (*Aguardando liberação*, *Em carregamento*, *Em transporte*, *Entregue*, *Atrasado*, *Cancelado*).
4. **`pedido_tb`**: Registro central dos fretes e especificações da carga.
5. **`log_status_pedido_tb`**: Tabela de auditoria para histórico e controle de SLA de atualizações.

---

## 📁 Estrutura do Repositório

```text
nexumlog/
├── .venv/                   # Ambiente virtual Python
├── config/                  # Arquivos de configuração do projeto
├── database/                # Scripts SQL estruturados
│   ├── DDL/
│   │   └── estrutura_banco.sql       # Criação de schemas e tabelas
│   ├── queries/
│   │   ├── busca_cliente_veiculo.sql # Query de IDs para o gerador n8n
│   │   └── insere_novo_pedido.sql    # Query de consulta com JOIN para e-mail
│   └── triggers/
│       └── trg_insere_log.sql        # Função PL/pgSQL e Trigger de auditoria
├── logs/                    # Logs de execução e auditoria local
├── n8n/                     # Artefatos da automação no n8n
│   ├── scripts/
│   │   └── cria_pedido.js            # Lógica JS de sorteio e formatação de dados
│   └── workflows/
│       └── nexumlog_workflow.json    # Export completo do fluxo para importação
├── notebooks/
│   └── popula_banco.ipynb   # Notebook Python para carga inicial via Faker
├── .env                     # Variáveis de ambiente (ignorado no Git)
├── .gitignore               # Regras de exclusão do Git
├── README.md                # Documentação técnica do projeto
└── requirements.txt         # Dependências Python