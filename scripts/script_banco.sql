-- 1. Tabela de Clientes
CREATE TABLE cliente_tb (
    cliente_id INT GENERATED ALWAYS AS IDENTITY,
    razao_social VARCHAR(150) NOT NULL,
    cnpj_cpf VARCHAR(20) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL,
    telefone VARCHAR(20),
    endereco VARCHAR(200),
    cidade VARCHAR(100),
    pais VARCHAR(50) DEFAULT 'Brasil',
    data_cadastro TIMESTAMP WITH TIME ZONE DEFAULT NOW(),

    CONSTRAINT PK_Cliente PRIMARY KEY (cliente_id)
);

-- 2. Tabela de Veículos (Caminhões)
CREATE TABLE veiculo_tb (
    veiculo_id INT GENERATED ALWAYS AS IDENTITY,
    placa VARCHAR(10) NOT NULL UNIQUE,
    modelo VARCHAR(50) NOT NULL,
    nome_motorista VARCHAR(100),
    situacao VARCHAR(20) DEFAULT 'Ativo', -- 'Ativo' | 'Desativado' | 'Férias'

    CONSTRAINT PK_Veiculo PRIMARY KEY (veiculo_id)
);

-- 3. Tabela de Domínio de Status
CREATE TABLE status_pedido_tb (
    status_id INT GENERATED ALWAYS AS IDENTITY,
    nome_status VARCHAR(50) NOT NULL UNIQUE,
    descricao VARCHAR(255),

    CONSTRAINT PK_Status_Pedido PRIMARY KEY (status_id)
);

-- Inserindo os status padrão
INSERT INTO status_pedido_tb (nome_status, descricao) VALUES
('Aguardando liberacao', 'Pedido criado, aguardando documentacao ou veiculo'),
('Em carregamento', 'Carga sendo alocada no caminhao'),
('Em transporte', 'Veiculo em transito para o porto/destino'),
('Entregue', 'Carga entregue no destino final'),
('Atrasado', 'Alerta de atraso na logistica'),
('Cancelado', 'Pedido cancelado');

-- 4. Tabela de Pedidos
CREATE TABLE pedido_tb (
    pedido_id INT GENERATED ALWAYS AS IDENTITY,
    cliente_id INT NOT NULL,
    veiculo_id INT NULL,
    destino VARCHAR(150) NOT NULL,
    tamanho_container VARCHAR(10) NOT NULL, -- ex: '20ft', '40ft'
    peso_total_carga_kg DECIMAL(10, 2) NOT NULL,
    status_id INT NOT NULL DEFAULT 1,
    data_criacao TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    data_atualizacao TIMESTAMP WITH TIME ZONE DEFAULT NOW(),

    CONSTRAINT PK_Pedido PRIMARY KEY (pedido_id),
    CONSTRAINT FK_Pedido_Cliente FOREIGN KEY (cliente_id) REFERENCES cliente_tb(cliente_id),
    CONSTRAINT FK_Pedido_Veiculo FOREIGN KEY (veiculo_id) REFERENCES veiculo_tb(veiculo_id),
    CONSTRAINT FK_Pedido_Status FOREIGN KEY (status_id) REFERENCES status_pedido_tb(status_id)
);

-- 5. Tabela de Histórico / Logs
CREATE TABLE log_status_pedido_tb (
    log_id INT GENERATED ALWAYS AS IDENTITY,
    pedido_id INT NOT NULL,
    status_novo_id INT NOT NULL,
    data_hora_mudanca TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    observacao VARCHAR(255),

    CONSTRAINT PK_Log_Status_Pedido PRIMARY KEY (log_id),
    CONSTRAINT FK_Log_Pedido FOREIGN KEY (pedido_id) REFERENCES pedido_tb(pedido_id),
    CONSTRAINT FK_Log_Status FOREIGN KEY (status_novo_id) REFERENCES status_pedido_tb(status_id)
);