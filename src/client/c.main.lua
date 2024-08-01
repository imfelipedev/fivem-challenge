--// Statistic class.

local Statistic = {}

function Statistic:constructor()
    self.cache = {}
    return true
end

Citizen.CreateThread(function()
    while true do

        DrawRect(0.165, 0.04, 0.3, 0.04, 31, 31, 31, 200)

        SetTextFont(4)
        SetTextScale(0.45, 0.45)
        SetTextColour(241, 241, 241, 255)
        SetTextOutline()
        SetTextEntry("STRING")
        AddTextComponentString("Suas estatísticas")
        DrawText(0.13, 0.025)

        local posY = 0.12
        for _, value in pairs(Statistic.cache) do 
            DrawRect(0.165, posY, 0.3, 0.08, 31, 31, 31, 200)

            --// Your damage

            SetTextFont(4)
            SetTextScale(0.8, 0.8)
            SetTextColour(241, 241, 241, 255)
            SetTextOutline()
            SetTextEntry("STRING")
            AddTextComponentString(""..value.caused.damage)
            DrawText(0.027, posY - 0.025)

            DrawRect(0.07, posY, 0.001, 0.08, 241, 241, 241, 255)

            SetTextFont(4)
            SetTextScale(0.3, 0.3)
            SetTextColour(241, 241, 241, 255)
            SetTextOutline()
            SetTextEntry("STRING")
            AddTextComponentString("Cabeça: "..value.caused.hit_locations.head)
            DrawText(0.08, posY - 0.03)

            SetTextFont(4)
            SetTextScale(0.3, 0.3)
            SetTextColour(241, 241, 241, 255)
            SetTextOutline()
            SetTextEntry("STRING")
            AddTextComponentString("Corpo: "..value.caused.hit_locations.body)
            DrawText(0.08, posY - 0.01)

            SetTextFont(4)
            SetTextScale(0.3, 0.3)
            SetTextColour(241, 241, 241, 255)
            SetTextOutline()
            SetTextEntry("STRING")
            AddTextComponentString("Perna: "..value.caused.hit_locations.limbs)
            DrawText(0.08, posY + 0.01)

            DrawRect(0.12, posY, 0.001, 0.08, 241, 241, 241, 255)

            --// Enemy

            SetTextFont(4)
            SetTextScale(0.5, 0.5)
            SetTextColour(241, 241, 241, 255)
            SetTextOutline()
            SetTextEntry("STRING")
            AddTextComponentString(value.nick)
            DrawText(0.13, posY - 0.02)

            SetTextFont(4)
            SetTextScale(0.3, 0.3)
            SetTextColour(241, 241, 241, 255)
            SetTextOutline()
            SetTextEntry("STRING")
            AddTextComponentString(value.received.weapon)
            DrawText(0.13, posY + 0.01)

            --// Receive damage.

            DrawRect(0.21, posY, 0.001, 0.08, 241, 241, 241, 255)

            SetTextFont(4)
            SetTextScale(0.3, 0.3)
            SetTextColour(241, 241, 241, 255)
            SetTextOutline()
            SetTextEntry("STRING")
            AddTextComponentString("Cabeça: "..value.received.hit_locations.head)
            DrawText(0.222, posY - 0.03)

            SetTextFont(4)
            SetTextScale(0.3, 0.3)
            SetTextColour(241, 241, 241, 255)
            SetTextOutline()
            SetTextEntry("STRING")
            AddTextComponentString("Corpo: "..value.received.hit_locations.body)
            DrawText(0.222, posY - 0.01)

            SetTextFont(4)
            SetTextScale(0.3, 0.3)
            SetTextColour(241, 241, 241, 255)
            SetTextOutline()
            SetTextEntry("STRING")
            AddTextComponentString("Perna: "..value.received.hit_locations.limbs)
            DrawText(0.222, posY + 0.01)

            DrawRect(0.265, posY, 0.001, 0.08, 241, 241, 241, 255)

            SetTextFont(4)
            SetTextScale(0.8, 0.8)
            SetTextColour(241, 241, 241, 255)
            SetTextOutline()
            SetTextEntry("STRING")
            AddTextComponentString(""..value.received.damage)
            DrawText(0.275, posY - 0.025)

            posY = posY + 0.085
        end


        Citizen.Wait(0)
    end
end)

--// Custom events.

RegisterNetEvent('statistic:update')
AddEventHandler('statistic:update', function(data)
    Statistic.cache = data
end)

--// Fivem events.

AddEventHandler('onClientResourceStart', function(resourceName)
    if GetCurrentResourceName() ~= resourceName then
        return false
    end

    return Statistic:constructor()
end)