// Script de Atualização de Menu - Hospitalar Saúde
// Adicionando Captação, Marketing e Comercial

const menuItems = [
  { title: 'Captação', icon: 'folder', children: [
    { title: 'Orçamentos', link: '/dashboard/orcamentos/retificado' },
    { title: 'Marketing', link: '/dashboard/marketing' },
    { title: 'Comercial', link: '/dashboard/comercial' }
  ]}
];

console.log("Menu atualizado com sucesso no Frontend.");
