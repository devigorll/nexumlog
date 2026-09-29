# 🚚 NexumLog - Automação, Monitoramento Logístico e Reports em Tempo Real

O **NexumLog** é uma solução de engenharia de dados e automação de processos focada no monitoramento operacional, simulação de fluxos de transporte e geração de relatórios de SLA e estoque para logística de exportação.

A arquitetura conecta um banco de dados relacional **PostgreSQL (Supabase)** a esteiras de automação no **n8n**, permitindo a geração contínua de pedidos simulados, o envio instantâneo de confirmações via Webhook e a distribuição de relatórios executivos (com dashboards e gráficos em QuickChart) formatados em HTML via e-mail.

---

## 🎯 Arquitetura da Solução

O ecossistema é composto por três esteiras operacionais integradas:

1. **Esteira Geradora (Simulação Operacional):**
   * **Schedule Trigger:** Dispara periodicamente a simulação de novos fretes.
   * **PostgreSQL Nodes:** Consulta os registros válidos de clientes e veículos no Supabase e insere novos registros na tabela `pedido_tb`.
   * **JavaScript Code Node (`cria_pedido.js`):** Executa a lógica de sorteio aleatório de destinos (portos e hubs logísticos), tipos de contêineres (`20ft`, `40ft`, `40ft HC`), peso da carga e status inicial.

2. **Esteira Notificadora (Event-Driven Notifications):**
   * **PostgreSQL Trigger (`trg_insere_log`):** Identifica novos pedidos e registra automaticamente o histórico na tabela `log_status_pedido_tb`.
   * **Webhook Integration:** Consome os eventos de inserção em tempo real.
   * **Disparo de Confirmação (`email_pedido.html`):** Realiza `JOIN` relacional e envia o e-mail transacional de confirmação do pedido para o cliente.

3. **Esteira de Analytics & Relatórios Executivos:**
   * **Relatório de SLA & Atrasos (`relatorio_atrasos.js` & `email_atrasos.html`):** Mapeia gargalos operacionais e pendências, gerando dinamicamente um gráfico de barras via **QuickChart.io** por estado de destino e listando os pedidos com SLA estourado.
   * **Relatório de Estoque & Ocupação (`relatorio_estoque.js` & `email_estoque.html`):** Consolida métricas de inventário, disponibilidade de contêineres e volume movimentado para suporte à tomada de decisão.

---

## 🛠️ Tecnologias Utilizadas

* **[Supabase](https://supabase.com/):** Banco de dados PostgreSQL gerenciado na nuvem (conexão via Transaction Pooler, porta `6543`).
* **[n8n](https://n8n.io/):** Plataforma de automação de workflows baseada em nós.
* **JavaScript (Node.js):** Lógica de geração de dados sintéticos, formatação de relatórios HTML e integração com QuickChart.
* **HTML5 & Inline CSS:** Templates de e-mails transacionais e analíticos responsivos.
* **PL/pgSQL:** Funções e Triggers para auditoria e log automático de status.
* **Python & Jupyter Notebooks:** População inicial do banco de dados com dados sintéticos via biblioteca `Faker`.
* **QuickChart API:** Geração dinâmica de gráficos estatísticos incorporados diretamente no corpo dos e-mails.

---

## 🗄️ Modelagem de Dados

O banco de dados relacional é composto por 5 tabelas principais:

1. **`cliente_tb`**: Cadastro de clientes contratantes (Razão Social, CNPJ/CPF, e-mail, telefone).
2. **`veiculo_tb`**: Frota cadastrada (placa, modelo, capacidade de carga).
3. **`status_pedido_tb`**: Tabela de domínio (*Aguardando liberação*, *Em carregamento*, *Em transporte*, *Entregue*, *Atrasado*, *Cancelado*).
4. **`pedido_tb`**: Registro central das operações de frete e especificações da carga.
5. **`log_status_pedido_tb`**: Tabela de auditoria para histórico de transições e controle de SLA.

---

## 📁 Estrutura do Repositório

```text
nexumlog/
├── .venv/                   # Ambiente virtual Python
├── config/                  # Arquivos de configuração do projeto
├── database/                # Scripts SQL estruturados
│   ├── DDL/
│   │   └── estrutura_banco.sql       # Criação do schema e tabelas
│   ├── queries/
│   │   ├── busca_cliente_veiculo.sql # Query de apoio para o gerador de pedidos
│   │   ├── consulta_atrasos.sql      # Consulta analítica de pedidos com SLA estourado
│   │   ├── consulta_estoque.sql      # Consulta de posições e volumetria de estoque
│   │   └── insere_novo_pedido.sql    # Query com JOIN relacional para e-mail transacional
│   └── triggers/
│       └── trg_insere_log.sql        # Trigger e Função PL/pgSQL de auditoria
├── logs/                    # Logs de execução e auditoria local
├── n8n/                     # Artefatos da automação no n8n
│   ├── html/
│   │   ├── email_atrasos.html        # Template HTML do relatório de atrasos com gráfico
│   │   ├── email_estoque.html        # Template HTML do relatório executivo de estoque
│   │   └── email_pedido.html         # Template HTML de confirmação de novo pedido
│   ├── scripts/
│   │   ├── cria_pedido.js            # Lógica JS de sorteio e geração de payloads
│   │   ├── relatorio_atrasos.js      # Formatação do relatório de atrasos e URL do QuickChart
│   │   └── relatorio_estoque.js      # Formatação dos KPIs e tabelas de estoque
│   └── workflows/
│       └── nexumlog_workflow.json    # Export completo dos workflows para importação no n8n
├── notebooks/
│   ├── inserindo_valores.ipynb       # Notebook complementar de testes de inserção
│   └── popula_banco.ipynb            # Notebook Python de carga inicial via Faker
├── .env                     # Variáveis de ambiente (ignorado no Git)
├── .gitignore               # Regras de exclusão do Git
├── README.md                # Documentação técnica do projeto
└── requirements.txt         # Dependências Python do projeto