Aqui está o `README.md` completo e sem os números, prontinho para o seu repositório:

# 🚚 NexumLog - Monitoramento e Automação Logística

O **NexumLog** é um projeto de portfólio focado na simulação, monitoramento e automação de fluxos operacionais para uma empresa fictícia de transporte e logística internacional.

O objetivo principal é integrar **Supabase (PostgreSQL)**, **Python** e **n8n** para demonstrar um pipeline completo de dados: desde a modelagem relacional, passando pela população automatizada com dados sintéticos, até a automação de processos em tempo real.

---

## 🎯 Objetivos do Projeto

* **Modelagem de Dados Relacional:** Construção de tabelas otimizadas no Supabase com suporte a transações, chaves estrangeiras e relacionamentos.


* **População de Dados Automatizada:** Scripts Python utilizando a biblioteca `Faker` e a SDK `supabase-py` para simulação de clientes, frota de veículos e pedidos de exportação.
* **Automação de Workflows:** Integração do banco de dados com workflows no **n8n** via Webhooks e rotinas agendadas para disparo de alertas e atualizações de status.

---

## 🛠️ Tecnologias Utilizadas

* **[Supabase](https://supabase.com/?utm_source=gemini):** Banco de dados PostgreSQL gerenciado na nuvem.


* **[Python](https://www.python.org/?utm_source=gemini):** Linguagem utilizada para scripts de conexão, manipulação de dados e geração de dados sintéticos via `Faker`.
* **[n8n](https://n8n.io/?utm_source=gemini):** Plataforma de automação de fluxo de trabalho (*workflow automation*).
* **`supabase-py` & `python-dotenv`:** Bibliotecas para integração segura com as APIs do Supabase.

---

## 🗄️ Arquitetura do Banco de Dados

O banco foi construído no Supabase com base no arquivo `scripts/script_banco.sql` e contempla as seguintes tabelas:

1. **`cliente_tb`**: Armazena os dados dos clientes contratantes (Razão Social, CNPJ/CPF, e-mail, telefone, endereço).


2. **`veiculo_tb`**: Registro da frota de caminhões (placa, modelo, capacidade de carga em kg, motorista e situação).


3. **`status_pedido_tb`**: Tabela de domínio com os status do ciclo de vida da carga (*Aguardando liberação*, *Em carregamento*, *Em transporte*, *Entregue*, *Atrasado*, *Cancelado*).


4. **`pedido_tb`**: Registro principal das operações de transporte (cliente, veículo, destino, especificações do container, peso e status).


5. **`log_status_pedido_tb`**: Histórico de alterações de status para rastreamento e auditoria.



---

## 📁 Estrutura do Repositório

De acordo com a organização do projeto:

```text
nexumlog/
├── config/             # Arquivos de configuração da aplicação
├── database/           # Notebooks e rotinas de teste de conexão (ex: conexao.ipynb)
├── logs/               # Registros de execução e auditoria
├── n8n/                # Workflows e pipelines exportados do n8n
├── scripts/            # Scripts SQL para criação do banco de dados (script_banco.sql)
├── .env                # Variáveis de ambiente (ignorado no Git)
├── .gitignore          # Arquivo para ignorar credenciais e ambiente virtual
├── README.md           # Documentação do projeto
└── requirements.txt    # Dependências do projeto Python

```

---

## 🚀 Como Executar o Projeto

### 1. Clonar o Repositório e Configurar o Ambiente

```bash
git clone https://github.com/seu-usuario/nexumlog.git
cd nexumlog

python -m venv .venv
source .venv/bin/activate  # No Windows: .venv\Scripts\activate
pip install -r requirements.txt

```

### 2. Configurar Variáveis de Ambiente (`.env`)

Crie um arquivo `.env` na raiz do projeto com as credenciais obtidas no dashboard do Supabase:

```env
SUPABASE_URL=https://seu-projeto.supabase.co
SUPABASE_KEY=sua-chave-anon-publica

```

### 3. Criar a Estrutura no Supabase

Execute o conteúdo do arquivo `scripts/script_banco.sql` diretamente no **SQL Editor** do painel do Supabase para criar todas as tabelas e chaves estrangeiras.

### 4. Popular o Banco de Dados

Execute os scripts em Python para gerar clientes, veículos e pedidos de teste via `Faker`.