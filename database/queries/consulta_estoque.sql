-- Este arquivo contém consultas SQL para obter informações sobre pedidos, incluindo a quantidade 
-- de pedidos por estado e a quantidade de pedidos por status utilizados no N8N.

SELECT 
  (
    SELECT json_agg(t_estado) FROM (
      SELECT 
          TRIM(SPLIT_PART(p.destino, '-', 2)) AS destino, 
          COUNT(*) AS total_pedidos
      FROM pedido_tb AS p
      GROUP BY 
          TRIM(SPLIT_PART(p.destino, '-', 2))
      ORDER BY total_pedidos DESC -- Ordenação decrescente por total
    ) t_estado
  ) AS pedidos_por_estado,

  (
    SELECT json_agg(t_status) FROM (
      SELECT  
          s.nome_status,
          COUNT(*) AS total
      FROM pedido_tb AS p
      INNER JOIN status_pedido_tb AS s
          ON p.status_id = s.status_id
      GROUP BY 
          s.nome_status
      ORDER BY total DESC -- Ordenação decrescente por total
    ) t_status
  ) AS total_por_status;