--// Game object.

local Games = {
    data = {} 
}

--// Statistic class.

local Statistic = {}

function Statistic:constructor()
    self.allow_bodypart = {
        ['head'] = true,
        ['body'] = true,
        ['limbs'] = true,
    }

    self.allow_weapons = {
        ['Assault Rifle'] = true,
        ['Carbine Rifle'] = true,
        ['Heavy Sniper Mk II'] = true,
    }
    return true
end

--// replace this value with a function that returns the player's data in the match.
function Statistic:getPlayerDataFromElement(element)
    return { game_id = 'matchmaking-01', type = 'attackers' id = 1, nick = 'zFelpszada', group = 'group:1', leader = true }
end

function Statistic:getPlayerStat(data)
    local game = Games.data[data.game_id]
    if not game then 
        return false
    end

    if not game.rounds.data[game.rounds.current] then 
        game.rounds.data[game.rounds.current] = {}
    end

    if not game.rounds.data[game.rounds.current][data.id] then 
        game.rounds.data[game.rounds.current][data.id] = {}
    end
    return game.rounds.data[game.rounds.current][data.id]
end

function Statistic:updatePlayerData(player, data, type, target)
    local playerStat = self:getPlayerStat(data)
    if not playerStat[target.id] then 
        playerStat[target.id] = {
            nick = target.nick,
            caused = {
                hit = 0,
                damage = 0,
                weapon = '',
                hit_locations = {
                    head = 0, 
                    body = 0, 
                    limbs = 0
                }
            },
            received = {
                hit = 0,
                damage = 0,
                weapon = '',
                hit_locations = {
                    head = 0, 
                    body = 0, 
                    limbs = 0
                }
            }
        }
    end

    if not playerStat[target.id][type] then 
        return false 
    end

    playerStat[target.id][type].weapon = target.weapon
    playerStat[target.id][type].hit = playerStat[target.id][type].hit + 1
    playerStat[target.id][type].damage = playerStat[target.id][type].damage + target.damage
    playerStat[target.id][type].hit_locations[target.bodypart] = playerStat[target.id][type].hit_locations[target.bodypart] + 1
    TriggerClientEvent('statistic:update', player, playerStat)
    return true
end

function Statistic:onPlayerHit(player, enemy, damage, weapon, bodypart)
    damage = tonumber(damage)
    if not damage or damage < 0 then 
        return false
    end

    if not self.allow_weapons[weapon] then 
        return false 
    end

    if not self.allow_bodypart[bodypart] then 
        return false 
    end

    local playerData = self:getPlayerDataFromElement(player)
    if not playerData then
        return false 
    end

    local enemyData = self:getPlayerDataFromElement(enemy)
    if not enemyData then
        return false 
    end

    if playerData.game_id ~= enemyData.game_id then 
        return false 
    end

    self:updatePlayerData(player, playerData, 'caused', { 
        id = enemyData.id, 
        nick = enemyData.nick, 
        damage = damage, 
        weapon = weapon, 
        bodypart = bodypart
    })

    self:updatePlayerData(enemy, enemyData, 'received', { 
        id = playerData.id, 
        nick = playerData.nick, 
        damage = damage,
        weapon = weapon, 
        bodypart = bodypart 
    })
    return true
end

--// Custom events.

AddEventHandler('your-event-damage', function(enemy, damage, weapon, bodypart)
    return Statistic:onPlayerHit(source, enemy, damage, weapon, bodypart)
end)

--// Fivem events.

AddEventHandler('onResourceStart', function(resourceName)
    if GetCurrentResourceName() ~= resourceName then
        return false
    end

    return Statistic:constructor()
end)

--// Test functions.

RegisterCommand('test', function(player)
    Games.data = {
        ['matchmaking-01'] = {
            players = {
                data = {
                    attackers = {
                        [1] = {
                            nick = 'zFelpszada',
                            group = 'group:1',
                            leader = true
                        },
                        [2] = {
                            nick = 'BlazeGamer',
                            group = 'group:4',
                            leader = false
                        },
                        [3] = {
                            nick = 'SpeedRacer',
                            group = 'group:4',
                            leader = false
                        },
                        [4] = {
                            nick = 'ShadowNinja',
                            group = 'group:4',
                            leader = true
                        },
                        [5] = {
                            nick = 'PhoenixFire',
                            group = 'group:4',
                            leader = false
                        }
                    },
                    defenders = {
                        [6] = {
                            nick = 'ThunderBolt',
                            group = 'group:6',
                            leader = true
                        },
                        [7] = {
                            nick = 'GhostRider',
                            group = 'group:6',
                            leader = false
                        },
                        [8] = {
                            nick = 'NeonSpectre',
                            group = 'group:9',
                            leader = false
                        },
                        [9] = {
                            nick = 'DriftKing',
                            group = 'group:9',
                            leader = true
                        },
                        [10] = {
                            nick = 'MidnightWolf',
                            group = 'group:10',
                            leader = true
                        },
                    }
                }
            },
            rounds = {
                current = 1,
                data = {
                    [1] = {
                        [1] = {
                            [6] = {
                                nick = 'ThunderBolt',
                                caused = {
                                    hit = 1,
                                    damage = 100,
                                    weapon = 'Assault Rifle',
                                    hit_locations = {
                                        head = 1, 
                                        body = 0, 
                                        limbs = 0
                                    }
                                },
                                received = {
                                    hit = 0,
                                    damage = 0,
                                    weapon = '',
                                    hit_locations = {
                                        head = 0, 
                                        body = 0, 
                                        limbs = 0
                                    }
                                }
                            },
                            [9] = {
                                nick = 'DriftKing',
                                caused = {
                                    hit = 0,
                                    damage = 0,
                                    weapon = '',
                                    hit_locations = {
                                        head = 0, 
                                        body = 0, 
                                        limbs = 0
                                    }
                                },
                                received = {
                                    hit = 4,
                                    damage = 127,
                                    weapon = 'Carbine Rifle',
                                    hit_locations = {
                                        head = 0, 
                                        body = 3, 
                                        limbs = 1
                                    }
                                }
                            }
                        },
                        [6] = {
                            [1] = {
                                nick = 'zFelpszada',
                                caused = {
                                    hit = 0,
                                    damage = 0,
                                    weapon = '',
                                    hit_locations = {
                                        head = 0, 
                                        body = 0, 
                                        limbs = 0
                                    }
                                },
                                received = {
                                    hit = 1,
                                    damage = 100,
                                    weapon = 'Assault Rifle',
                                    hit_locations = {
                                        head = 1, 
                                        body = 0, 
                                        limbs = 0
                                    }
                                }
                            }
                        },
                        [9] = {
                            [1] = {
                                nick = 'zFelpszada',
                                caused = {
                                    hit = 4,
                                    damage = 127,
                                    weapon = 'Carbine Rifle',
                                    hit_locations = {
                                        head = 0, 
                                        body = 3, 
                                        limbs = 1
                                    }
                                },
                                received = {
                                    hit = 0,
                                    damage = 0,
                                    weapon = '',
                                    hit_locations = {
                                        head = 0, 
                                        body = 0, 
                                        limbs = 0
                                    }
                                }
                            },
                        }
                    }
                }
            }
        }
    }

    return TriggerClientEvent('statistic:update', player, Games.data['matchmaking-01'].rounds.data[1][1])
end)