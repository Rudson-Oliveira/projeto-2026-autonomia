<template>
  <nav class="menu-captacao">
    <!-- Menu Principal -->
    <div class="menu-container">
      <div class="menu-header">
        <h2>📊 Módulo de Captação</h2>
      </div>

      <!-- Submenu Orçamentos -->
      <div class="menu-section">
        <div class="menu-item" @click="toggleSubmenu('orcamentos')" :class="{ active: activeSubmenu === 'orcamentos' }">
          <span class="menu-icon">📋</span>
          <span class="menu-label">Orçamentos</span>
          <span class="menu-toggle">{{ activeSubmenu === 'orcamentos' ? '▼' : '▶' }}</span>
        </div>
        <transition name="slide">
          <div v-if="activeSubmenu === 'orcamentos'" class="submenu">
            <router-link to="/captacao/orcamentos/novo" class="submenu-item">
              <span class="submenu-icon">➕</span> Novo Orçamento
            </router-link>
            <router-link to="/captacao/orcamentos/listar" class="submenu-item">
              <span class="submenu-icon">📑</span> Listar Orçamentos
            </router-link>
            <router-link to="/captacao/orcamentos/analise" class="submenu-item">
              <span class="submenu-icon">📊</span> Análise de Vulnerabilidade
            </router-link>
            <router-link to="/captacao/orcamentos/margens" class="submenu-item">
              <span class="submenu-icon">💰</span> Gestão de Margens
            </router-link>
            <router-link to="/captacao/orcamentos/importar" class="submenu-item">
              <span class="submenu-icon">📥</span> Importar Orçamentos
            </router-link>
          </div>
        </transition>
      </div>

      <!-- Submenu Marketing -->
      <div class="menu-section">
        <div class="menu-item" @click="toggleSubmenu('marketing')" :class="{ active: activeSubmenu === 'marketing' }">
          <span class="menu-icon">📢</span>
          <span class="menu-label">Marketing</span>
          <span class="menu-toggle">{{ activeSubmenu === 'marketing' ? '▼' : '▶' }}</span>
        </div>
        <transition name="slide">
          <div v-if="activeSubmenu === 'marketing'" class="submenu">
            <router-link to="/captacao/marketing/campanhas" class="submenu-item">
              <span class="submenu-icon">🎯</span> Campanhas
            </router-link>
            <router-link to="/captacao/marketing/aniversarios" class="submenu-item">
              <span class="submenu-icon">🎂</span> Disparo Aniversário
            </router-link>
            <router-link to="/captacao/marketing/engajamento" class="submenu-item">
              <span class="submenu-icon">💬</span> Engajamento Familiar
            </router-link>
            <router-link to="/captacao/marketing/tendencias" class="submenu-item">
              <span class="submenu-icon">📈</span> Tendências de Assistência
            </router-link>
            <router-link to="/captacao/marketing/satisfacao" class="submenu-item">
              <span class="submenu-icon">⭐</span> Pesquisa de Satisfação
            </router-link>
          </div>
        </transition>
      </div>

      <!-- Submenu Comercial -->
      <div class="menu-section">
        <div class="menu-item" @click="toggleSubmenu('comercial')" :class="{ active: activeSubmenu === 'comercial' }">
          <span class="menu-icon">💼</span>
          <span class="menu-label">Comercial</span>
          <span class="menu-toggle">{{ activeSubmenu === 'comercial' ? '▼' : '▶' }}</span>
        </div>
        <transition name="slide">
          <div v-if="activeSubmenu === 'comercial'" class="submenu">
            <router-link to="/captacao/comercial/propostas" class="submenu-item">
              <span class="submenu-icon">📄</span> Propostas Comerciais
            </router-link>
            <router-link to="/captacao/comercial/convênios" class="submenu-item">
              <span class="submenu-icon">🏥</span> Gestão de Convênios
            </router-link>
            <router-link to="/captacao/comercial/tabelas-preco" class="submenu-item">
              <span class="submenu-icon">💵</span> Tabelas de Preço
            </router-link>
            <router-link to="/captacao/comercial/negociacoes" class="submenu-item">
              <span class="submenu-icon">🤝</span> Negociações
            </router-link>
            <router-link to="/captacao/comercial/rede-apoio" class="submenu-item">
              <span class="submenu-icon">🌐</span> Rede de Apoio
            </router-link>
          </div>
        </transition>
      </div>

      <!-- Submenu Análise e Inteligência -->
      <div class="menu-section">
        <div class="menu-item" @click="toggleSubmenu('inteligencia')" :class="{ active: activeSubmenu === 'inteligencia' }">
          <span class="menu-icon">🧠</span>
          <span class="menu-label">Análise & IA</span>
          <span class="menu-toggle">{{ activeSubmenu === 'inteligencia' ? '▼' : '▶' }}</span>
        </div>
        <transition name="slide">
          <div v-if="activeSubmenu === 'inteligencia'" class="submenu">
            <router-link to="/captacao/inteligencia/perfil-comportamental" class="submenu-item">
              <span class="submenu-icon">👤</span> Perfil Comportamental
            </router-link>
            <router-link to="/captacao/inteligencia/vulnerabilidades" class="submenu-item">
              <span class="submenu-icon">⚠️</span> Vulnerabilidades
            </router-link>
            <router-link to="/captacao/inteligencia/recomendacoes" class="submenu-item">
              <span class="submenu-icon">💡</span> Recomendações IA
            </router-link>
            <router-link to="/captacao/inteligencia/relatorios" class="submenu-item">
              <span class="submenu-icon">📊</span> Relatórios Inteligentes
            </router-link>
          </div>
        </transition>
      </div>
    </div>

    <!-- Painel Lateral de Atalhos Rápidos -->
    <div class="quick-actions">
      <h3>⚡ Atalhos Rápidos</h3>
      <button @click="navigateTo('/captacao/orcamentos/novo')" class="quick-action-btn novo-orcamento">
        <span class="icon">➕</span> Novo Orçamento
      </button>
      <button @click="navigateTo('/captacao/orcamentos/analise')" class="quick-action-btn analise">
        <span class="icon">📊</span> Análise de Risco
      </button>
      <button @click="navigateTo('/captacao/comercial/tabelas-preco')" class="quick-action-btn tabelas">
        <span class="icon">💰</span> Tabelas de Preço
      </button>
      <button @click="navigateTo('/captacao/inteligencia/recomendacoes')" class="quick-action-btn ia">
        <span class="icon">🧠</span> Recomendações IA
      </button>
    </div>
  </nav>
</template>

<script>
export default {
  name: 'MenuCaptacao',
  data() {
    return {
      activeSubmenu: 'orcamentos'
    };
  },
  methods: {
    toggleSubmenu(submenu) {
      this.activeSubmenu = this.activeSubmenu === submenu ? null : submenu;
    },
    navigateTo(route) {
      this.$router.push(route);
    }
  }
};
</script>

<style scoped>
:root {
  --verde-turquesa: #59C2C9;
  --azul-intenso: #1A3688;
  --cinza-claro: #f5f5f5;
  --cinza-escuro: #333;
  --branco: #ffffff;
  --sombra: 0 2px 8px rgba(0, 0, 0, 0.1);
}

.menu-captacao {
  background-color: var(--branco);
  border-right: 2px solid var(--verde-turquesa);
  min-height: 100vh;
  padding: 20px;
  box-shadow: var(--sombra);
}

.menu-container {
  margin-bottom: 30px;
}

.menu-header {
  margin-bottom: 25px;
  padding-bottom: 15px;
  border-bottom: 2px solid var(--verde-turquesa);
}

.menu-header h2 {
  color: var(--azul-intenso);
  margin: 0;
  font-size: 20px;
}

.menu-section {
  margin-bottom: 10px;
}

.menu-item {
  display: flex;
  align-items: center;
  padding: 12px 15px;
  cursor: pointer;
  border-radius: 5px;
  transition: all 0.3s ease;
  user-select: none;
}

.menu-item:hover {
  background-color: var(--cinza-claro);
  color: var(--verde-turquesa);
}

.menu-item.active {
  background-color: rgba(89, 194, 201, 0.1);
  color: var(--verde-turquesa);
  font-weight: 600;
}

.menu-icon {
  font-size: 18px;
  margin-right: 12px;
}

.menu-label {
  flex: 1;
  font-weight: 500;
  color: var(--cinza-escuro);
}

.menu-item.active .menu-label {
  color: var(--verde-turquesa);
}

.menu-toggle {
  font-size: 12px;
  color: #999;
  transition: transform 0.3s ease;
}

.submenu {
  background-color: var(--cinza-claro);
  border-left: 3px solid var(--verde-turquesa);
  margin-left: 10px;
  border-radius: 0 5px 5px 0;
  overflow: hidden;
}

.submenu-item {
  display: flex;
  align-items: center;
  padding: 10px 15px 10px 25px;
  text-decoration: none;
  color: var(--cinza-escuro);
  transition: all 0.3s ease;
  border-left: 3px solid transparent;
  font-size: 14px;
}

.submenu-item:hover {
  background-color: rgba(89, 194, 201, 0.1);
  color: var(--verde-turquesa);
  border-left-color: var(--verde-turquesa);
  padding-left: 30px;
}

.submenu-item.router-link-active {
  background-color: rgba(89, 194, 201, 0.2);
  color: var(--verde-turquesa);
  border-left-color: var(--verde-turquesa);
  font-weight: 600;
}

.submenu-icon {
  margin-right: 10px;
  font-size: 16px;
}

/* Transição do Submenu */
.slide-enter-active,
.slide-leave-active {
  transition: all 0.3s ease;
}

.slide-enter-from {
  opacity: 0;
  max-height: 0;
}

.slide-leave-to {
  opacity: 0;
  max-height: 0;
}

.slide-enter-to,
.slide-leave-from {
  opacity: 1;
  max-height: 500px;
}

/* Atalhos Rápidos */
.quick-actions {
  background-color: var(--cinza-claro);
  border-radius: 8px;
  padding: 15px;
  border-left: 4px solid var(--verde-turquesa);
}

.quick-actions h3 {
  color: var(--azul-intenso);
  margin: 0 0 15px 0;
  font-size: 14px;
}

.quick-action-btn {
  display: flex;
  align-items: center;
  justify-content: center;
  width: 100%;
  padding: 10px;
  margin-bottom: 8px;
  border: none;
  border-radius: 5px;
  cursor: pointer;
  font-size: 13px;
  font-weight: 500;
  transition: all 0.3s ease;
  color: var(--branco);
}

.quick-action-btn:last-child {
  margin-bottom: 0;
}

.quick-action-btn .icon {
  margin-right: 8px;
  font-size: 16px;
}

.novo-orcamento {
  background-color: var(--verde-turquesa);
}

.novo-orcamento:hover {
  background-color: #47a0a6;
  transform: translateX(5px);
}

.analise {
  background-color: var(--azul-intenso);
}

.analise:hover {
  background-color: #0d1f47;
  transform: translateX(5px);
}

.tabelas {
  background-color: #f39c12;
}

.tabelas:hover {
  background-color: #d68910;
  transform: translateX(5px);
}

.ia {
  background-color: #9b59b6;
}

.ia:hover {
  background-color: #8e44ad;
  transform: translateX(5px);
}

/* Responsivo */
@media (max-width: 768px) {
  .menu-captacao {
    padding: 15px;
    border-right: none;
    border-bottom: 2px solid var(--verde-turquesa);
  }

  .menu-header h2 {
    font-size: 18px;
  }

  .menu-item {
    padding: 10px 12px;
  }

  .menu-icon {
    font-size: 16px;
    margin-right: 10px;
  }

  .submenu-item {
    padding: 8px 12px 8px 20px;
    font-size: 13px;
  }

  .quick-action-btn {
    font-size: 12px;
    padding: 8px;
  }
}
</style>
