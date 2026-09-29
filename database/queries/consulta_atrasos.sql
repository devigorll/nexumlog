-- Este arquivo contém consultas SQL para obter informações sobre pedidos atrasados, incluindo o 
-- total geral de pedidos atrasados, dados para gráficos e uma lista detalhada para exibição em tabelas usados no n8n.

SELECT 
  -- 1. Total Geral de Pedidos Atrasados
  (
    SELECT COUNT(*) 
    FROM pedido_tb AS p
    INNER JOIN status_pedido_tb AS s ON p.status_id = s.status_id
    WHERE s.nome_status = 'Atrasado'
  ) AS total_pedidos_atrasados,

  -- 2. Dados para o Gráfico (Pedidos Atrasados por Estado)
  (
    SELECT json_agg(t_estado) FROM (
      SELECT 
        TRIM(SPLIT_PART(p.destino, '-', 2)) AS destino, 
        COUNT(*) AS total_atrasados
      FROM pedido_tb AS p
      INNER JOIN status_pedido_tb AS s ON p.status_id = s.status_id
      WHERE s.nome_status = 'Atrasado'
      GROUP BY TRIM(SPLIT_PART(p.destino, '-', 2))
      ORDER BY total_atrasados DESC
    ) t_estado
  ) AS grafico_atrasados_estado,

  -- 3. Lista para a Tabela de Pedidos Atrasados
  (
    SELECT json_agg(t_pedidos) FROM (
      SELECT 
        p.pedido_id,
        p.destino,
        c.razao_social,
        p.tamanho_container,
        TO_CHAR(p.data_criacao, 'DD/MM/YYYY') AS data_criacao
      FROM pedido_tb AS p
      INNER JOIN status_pedido_tb AS s ON p.status_id = s.status_id
      INNER JOIN cliente_tb AS c ON p.cliente_id = c.cliente_id
      WHERE s.nome_status = 'Atrasado'
      ORDER BY p.data_criacao ASC
    ) t_pedidos
  ) AS tabela_pedidos_atrasados;