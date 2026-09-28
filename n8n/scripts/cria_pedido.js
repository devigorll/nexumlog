// Este script cria um pedido aleatório com base nos IDs de clientes e veículos fornecidos pelo n8n. Ele seleciona aleatoriamente um cliente, um veículo, um destino, um tamanho de container, um peso total de carga e um status para o pedido.

const clientes_ids = $input.first().json.clientes_ids;
const veiculos_ids = $input.first().json.veiculos_ids;

const destinos_portos_br = [
    "Porto de Santos - SP",
    "Porto de Paranaguá - PR",
    "Porto de Itajaí - SC",
    "Porto de Rio Grande - RS",
    "Porto de Suape - PE",
    "Porto de Pecém - CE",
    "Porto de Itaqui - MA",
    "Porto de Chibatão (Manaus) - AM",
    "Porto de Tubarão (Vitória) - ES",
    "Porto de Aratu - BA"
];

const tamanhos_container = ["20ft", "40ft", "40ft HC"];

// Funções auxiliares para sorteio
const obter_item_aleatorio = (lista) => lista[Math.floor(Math.random() * lista.length)];
const obter_peso_aleatorio = (minimo, maximo) => parseFloat((Math.random() * (maximo - minimo) + minimo).toFixed(2));
const obter_status_aleatorio = () => Math.floor(Math.random() * 6) + 1;

// Retorna o objeto formatado no padrão esperado pelo n8n
return [{
    json: {
        cliente_id: obter_item_aleatorio(clientes_ids),
        veiculo_id: obter_item_aleatorio(veiculos_ids),
        destino: obter_item_aleatorio(destinos_portos_br),
        tamanho_container: obter_item_aleatorio(tamanhos_container),
        peso_total_carga_kg: obter_peso_aleatorio(10000.00, 35000.00),
        status_id: obter_status_aleatorio()
    }
}];