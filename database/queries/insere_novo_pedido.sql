-- Este script insere um novo pedido na tabela pedido_tb com os valores fornecidos em formato JSON vindo do cria_pedido.js . Ele utiliza placeholders para os valores que serão substituídos pelos dados reais no momento da execução.

INSERT INTO public.pedido_tb (
    cliente_id, 
    veiculo_id, 
    destino, 
    tamanho_container, 
    peso_total_carga_kg, 
    status_id
) VALUES (
    {{ $json.cliente_id }},
    {{ $json.veiculo_id }},
    '{{ $json.destino }}',
    '{{ $json.tamanho_container }}',
    {{ $json.peso_total_carga_kg }},
    {{ $json.status_id }}
)
RETURNING *;