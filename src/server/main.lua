--// Statistic class.

local Statistic = {}

function Statistic:constructor()
    self.cache = {}
    self.bodypart = { ["head"] = true, ["body"] = true, ["limbs"] = true }
end

function Statistic:getPlayerData(playerID)
    if not self.cache[playerID] then 
        self.cache[playerID] = {}
    end
    return self.cache[playerID]
end

function Statistic:getPlayerStat(playerData, targetID)
    if not playerData[targetID] then 
        playerData[targetID] = {
            nick = "",
            caused = {
                damage = 0,
                weapon = 0,
                locations = { head = 0, body = 0, limbs = 0 }
            },
            received = {
                damage = 0,
                weapon = 0,
                locations = { head = 0, body = 0, limbs = 0 }
            }
        }
    end
    return playerData[targetID]
end

function Statistic:updatePlayerData(playerID, value)
    local playerData = self:getPlayerData(playerID)
    if not playerData then 
        return false 
    end

    local playerStat = self:getPlayerStat(playerData, value.id)
    if not playerStat then 
        return false 
    end

    local playerStatType = playerStat[value.type]
    if not playerStatType then 
        return false 
    end

    playerStat.nick = value.nick
    playerStatType.weapon = value.weapon
    playerStatType.damage = playerStatType.damage + value.damage
    playerStatType.locations[value.bodypart] = playerStatType.locations[value.bodypart] + 1
    return TriggerClientEvent("statistic:update", playerID, playerData)
end

function Statistic:onPlayerHit(playerID, data)
    if data.damageType ~= 3 then
        return false 
    end

    if data.weaponDamage <= 0 then
        return false 
    end

    local targetEntity = NetworkGetEntityFromNetworkId(data.hitGlobalId)
    if not IsPedAPlayer(targetEntity) then 
        return false 
    end

	local targetID = NetworkGetEntityOwner(targetEntity)
    if not targetID then
        return false 
    end

    local playerName = GetPlayerName(playerID)
    local targetName = GetPlayerName(targetID)
    local weaponName = GetWeaponModelFromHash(data.weaponType)
    self:updatePlayerData(playerID, {
        id = targetID, 
        nick = targetName, 
        type = "caused",
        damage = data.weaponDamage, 
        weapon = weaponName, 
        bodypart = "head"
    })

    self:updatePlayerData(targetID, { 
        id = playerID, 
        nick = playerName, 
        type = "received",
        damage = data.weaponDamage,
        weapon = weaponName, 
        bodypart = "head" 
    })
    return true
end

--// Custom events.

AddEventHandler("weaponDamageEvent", function(sender, data)
    return Statistic:onPlayerHit(sender, data)
end)

--// Fivem events.

AddEventHandler("onResourceStart", function(resourceName)
    if GetCurrentResourceName() ~= resourceName then
        return false
    end

    return Statistic:constructor()
end)