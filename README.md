# 🔫 Resource de Estatísticas de Combate para FiveM

## Descrição

Este resource fornece um sistema de estatísticas de combate para FiveM, permitindo que os jogadores acompanhem e exibam informações detalhadas sobre seu desempenho em combate, como dano causado e recebido, partes específicas do corpo atingidas e uso de armas.
## Funcionalidades

- Acompanhar dano causado e recebido.
- Estatísticas detalhadas para partes específicas do corpo (cabeça, corpo e pernas).
- Exibir estatísticas em tempo real no lado do cliente.
## Instalação

1. Baixe ou clone este repositório para o diretório `resources` do seu servidor FiveM.

## Documentação

#### Client-side (src/client/main.lua)

##### Classe "Statistic"

- `constructor()`: Inicializa o cache para as estatísticas.
- `setCache(cache)`: Atualiza o cache com novos dados.
- `drawNativeText(font, size, text, x, y)`: Função auxiliar para desenhar texto na tela.
- `render()`: Renderiza a exibição das estatísticas na tela.

##### Funções Globais

- Thread principal para renderizar continuamente as estatísticas.

##### Eventos personalizados

- `"statistic:update"` para atualizar o cache das estatísticas.

##### Eventos do FiveM

- `"onClientResourceStart"` para inicializar a classe "Statistic".

#### Server-side (src/server/main.lua)

##### Classe "Statistic"

- `constructor()`: Inicializa o cache para as estatísticas e o mapeamento das partes do corpo.
- `getPlayerData(playerID)`: Recupera ou inicializa os dados do jogador.
- `getPlayerStat(playerData, targetID)`: Recupera ou inicializa as estatísticas do jogador alvo.
- `updatePlayerData(playerID, value)`: Atualiza as estatísticas do jogador com novos dados.
- `onPlayerHit(playerID, data)`: Processa eventos de acerto de jogador e atualiza as estatísticas conforme necessário.

##### Eventos do FiveM

- `"weaponDamageEvent"` para processar dano de arma e atualizar estatísticas.

- `"onResourceStart"` para inicializar a classe "Statistic".