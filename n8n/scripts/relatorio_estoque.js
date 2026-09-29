// Este arquivo contém um script para gerar gráficos de pedidos por estado e por status, utilizando a biblioteca QuickChart. O script processa os dados de entrada, ordena-os e cria configurações de gráficos que são então convertidas em URLs para visualização.

const item = $input.first().json;

// 1. Dados do Gráfico por Estado (Ordenado Decrescente)
const pedidosEstado = (item.pedidos_por_estado || []).sort((a, b) => b.total_pedidos - a.total_pedidos);
const estados = pedidosEstado.map(i => i.destino);
const totalPorEstado = pedidosEstado.map(i => i.total_pedidos);

const configEstado = {
  type: 'bar',
  data: {
    labels: estados,
    datasets: [{
      label: 'Pedidos', // Legenda reativada
      backgroundColor: '#0d6efd',
      borderRadius: 6,
      data: totalPorEstado
    }]
  },
  options: {
    plugins: {
      legend: { 
        display: true, // Habilita a legenda
        position: 'top',
        labels: { font: { family: 'Arial', size: 12, weight: 'bold' } }
      },
      datalabels: {
        anchor: 'end',
        align: 'top',
        color: '#0d6efd',
        font: { weight: 'bold', size: 12 }
      }
    },
    scales: {
      x: { grid: { display: false } },
      y: { grid: { color: '#f0f0f0' }, beginAtZero: true }
    }
  }
};

// 2. Dados do Gráfico de Status (Ordenado Decrescente)
const pedidosStatus = (item.total_por_status || []).sort((a, b) => b.total - a.total);
const statusLabels = pedidosStatus.map(i => i.nome_status);
const totalPorStatus = pedidosStatus.map(i => i.total);

const configStatus = {
  type: 'bar',
  data: {
    labels: statusLabels,
    datasets: [{
      label: 'Total', // Legenda reativada
      backgroundColor: '#20c997',
      borderRadius: 6,
      data: totalPorStatus
    }]
  },
  options: {
    plugins: {
      legend: { 
        display: true, // Habilita a legenda
        position: 'top',
        labels: { font: { family: 'Arial', size: 12, weight: 'bold' } }
      },
      datalabels: {
        anchor: 'end',
        align: 'top',
        color: '#20c997',
        font: { weight: 'bold', size: 12 }
      }
    },
    scales: {
      x: { grid: { display: false } },
      y: { grid: { color: '#f0f0f0' }, beginAtZero: true }
    }
  }
};

// URLs com gráficos grandes e com legendas ativas
return [{
  json: {
    ...item,
    url_grafico_estado: `https://quickchart.io/chart?bkg=white&w=600&h=280&c=${encodeURIComponent(JSON.stringify(configEstado))}`,
    url_grafico_status: `https://quickchart.io/chart?bkg=white&w=600&h=280&c=${encodeURIComponent(JSON.stringify(configStatus))}`
  }
}];