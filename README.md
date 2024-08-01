# 🚩 Sistema de estatísticas de combate.

> Revise suas estatísticas de 'trocação' após cada rodada para obter uma visão detalhada do seu desempenho.

## Instalação

1. Faça o clone do projeto.
2. Coloque em sua pasta de "resources".

## Configuração

1. Substitua a variável de teste na linha 28 da função getPlayerDataFromElement pela função que você usa para obter os dados do jogador na rodada.

```lua
function Statistic:getPlayerDataFromElement(element)
    return { game_id = 'matchmaking-01', type = 'attackers' id = 1, nick = 'zFelpszada', group = 'group:1', leader = true }
end
```

2. Substitua o evento "your-event-damage" pelo evento que você utiliza para registrar dano.

```lua
AddEventHandler('your-event-damage', function(enemy, damage, weapon, bodypart)
    return Statistic:onPlayerHit(source, enemy, damage, weapon, bodypart)
end)
```

## Funcionalidades

-   Comando de teste:
    -   Utilize o comando "test" no console (f8).
