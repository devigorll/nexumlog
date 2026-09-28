-- Este script busca os IDs de todos os clientes e veículos cadastrados no banco de dados e foi utilizado no n8n para inserir novos pedidos.

SELECT 
    (SELECT json_agg(cliente_id) FROM public.cliente_tb) AS clientes_ids,
    (SELECT json_agg(veiculo_id) FROM public.veiculo_tb) AS veiculos_ids;