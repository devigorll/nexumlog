// Este arquivo contém um script para gerar um relatório de pedidos atrasados, incluindo a contagem total
//  de pedidos atrasados, a criação de um gráfico de barras utilizando a biblioteca QuickChart e a montagem de uma 
// tabela HTML com os detalhes dos pedidos. O script processa os dados de entrada, ordena-os e cria configurações de gráficos que são então convertidas em URLs para visualização.

const item = $input.first().json;

// 1. Tratamento do Total de Pedidos Atrasados
const totalAtrasados = item.total_pedidos_atrasados || 0;

// 2. Montagem do Gráfico QuickChart em Azul
const dadosGrafico = (item.grafico_atrasados_estado || []).sort((a, b) => b.total_atrasados - a.total_atrasados);
const estados = dadosGrafico.map(i => i.destino);
const totais = dadosGrafico.map(i => i.total_atrasados);

const configGrafico = {
  type: 'bar',
  data: {
    labels: estados,
    datasets: [{
      label: 'Atrasos',
      backgroundColor: '#0d6efd', // Azul corporativo
      borderRadius: 6,
      data: totais
    }]
  },
  options: {
    plugins: {
      legend: { 
        display: true,
        position: 'top',
        labels: { font: { family: 'Arial', size: 12, weight: 'bold' } }
      },
      datalabels: {
        anchor: 'end',
        align: 'top',
        color: '#0d6efd', // Números em azul
        font: { weight: 'bold', size: 12 }
      }
    },
    scales: {
      x: { grid: { display: false } },
      y: { grid: { color: '#f0f0f0' }, beginAtZero: true }
    }
  }
};

// 3. Montagem Dinâmica do HTML da Tabela
const listaPedidos = item.tabela_pedidos_atrasados || [];
let linhasTabelaHtml = '';

if (listaPedidos.length === 0) {
  linhasTabelaHtml = `
    <tr>
      <td colspan="5" style="padding: 12px; text-align: center; color: #28a745; font-weight: bold;">
        Nenhum pedido atrasado no momento! 🎉
      </td>
    </tr>`;
} else {
  linhasTabelaHtml = listaPedidos.map((pedido, index) => {
    const bgCor = index % 2 === 0 ? '#ffffff' : '#f8f9fa';
    return `<tr style="background-color: ${bgCor}; border-bottom: 1px solid #e9ecef;"><td style="padding: 10px 12px; font-weight: bold; color: #333;">#${pedido.pedido_id}</td><td style="padding: 10px 12px; color: #495057;">${pedido.razao_social}</td><td style="padding: 10px 12px; color: #495057; text-align: center;">${pedido.destino}</td><td style="padding: 10px 12px; text-align: center; color: #495057;">${pedido.tamanho_container || 'N/A'}</td><td style="padding: 10px 12px; text-align: center; color: #dc3545; font-weight: 500;">${pedido.data_criacao}</td></tr>`;
  }).join('');
}

// 4. Retorno Estruturado para o n8n
return [{
  json: {
    ...item,
    total_pedidos_atrasados: totalAtrasados,
    url_grafico_atrasados: `https://quickchart.io/chart?bkg=white&w=600&h=280&c=${encodeURIComponent(JSON.stringify(configGrafico))}`,
    tabela_pedidos_html: linhasTabelaHtml
  }
}];