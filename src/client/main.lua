--// Statistic class.

local Statistic = {}

function Statistic:constructor()
    self.cache = {}
end

function Statistic:setCache(cache)
    self.cache = cache
end

function Statistic:drawNativeText(font, size, text, x, y)
    SetTextFont(font)
    SetTextScale(size, size)
    SetTextColour(241, 241, 241, 255)
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(""..text)
    DrawText(x, y)
end

function Statistic:render()
    DrawRect(0.165, 0.04, 0.3, 0.04, 31, 31, 31, 200)

    self:drawNativeText(4, 0.45, "Suas estatísticas", 0.13, 0.025)

    local posY = 0.12
    for _, value in pairs(self.cache) do 
        DrawRect(0.165, posY, 0.3, 0.08, 31, 31, 31, 200)

        self:drawNativeText(4, 0.8, value.caused.damage, 0.027, posY - 0.025)

        DrawRect(0.07, posY, 0.001, 0.08, 241, 241, 241, 255)

        self:drawNativeText(4, 0.3, "Cabeça: "..value.caused.locations.head, 0.08, posY - 0.03)

        self:drawNativeText(4, 0.3, "Corpo: "..value.caused.locations.body, 0.08, posY - 0.01)

        self:drawNativeText(4, 0.3, "Perna: "..value.caused.locations.limbs, 0.08, posY + 0.01)

        DrawRect(0.12, posY, 0.001, 0.08, 241, 241, 241, 255)

        self:drawNativeText(4, 0.5, value.nick, 0.13, posY - 0.02)

        self:drawNativeText(4, 0.3, value.received.weapon, 0.13, posY + 0.01)

        DrawRect(0.21, posY, 0.001, 0.08, 241, 241, 241, 255)

        self:drawNativeText(4, 0.3, "Cabeça: "..value.received.locations.head, 0.222, posY - 0.03)

        self:drawNativeText(4, 0.3, "Corpo: "..value.received.locations.body, 0.222, posY - 0.01)
        
        self:drawNativeText(4, 0.3, "Perna: "..value.received.locations.limbs, 0.222, posY + 0.01)
        
        DrawRect(0.265, posY, 0.001, 0.08, 241, 241, 241, 255)

        self:drawNativeText(4, 0.83, value.received.damage, 0.275, posY - 0.025)

        posY = posY + 0.085
    end
end

--// Global functions.

Citizen.CreateThread(function()
    while true do
        Statistic:render()
        Citizen.Wait(0)
    end
end)

--// Custom events.

RegisterNetEvent("statistic:update")
AddEventHandler("statistic:update", function(cache)
    return Statistic:setCache(cache)
end)

--// Fivem events.

AddEventHandler("onClientResourceStart", function(resourceName)
    if GetCurrentResourceName() ~= resourceName then
        return false
    end

    return Statistic:constructor()
end)