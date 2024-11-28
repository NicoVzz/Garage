--[[
    toxic fivem community
]]

local webhook = "https://discord.com/api/webhooks/1197411527238631515/IzRNINYMGhLPT2zcKs443Tb876Cuuk50S4eg3XT_mFYjNjMwhUB7axpxS7U2y_zJR1yg"

CreateThread(function()
    if Config.Framework == 'QBCore' then
        QBCore = exports['qb-core']:GetCoreObject()
        QBCore.Functions.CreateCallback("av_vehicleshop:getCategory", function(source,cb,category)
            local info = GetCategory(category)
            cb(info)
        end)
    elseif Config.Framework == 'ESX' then
        ESX = exports['es_extended']:getSharedObject()
        ESX.RegisterServerCallback("av_vehicleshop:getCategory", function(source,cb,category)
            local info = GetCategory(category)
            cb(info)
        end)
    else
        lib.callback.register('av_vehicleshop:getCategory', function(source, category)
            local info = GetCategory(category)
            return info
        end)
    end
end)

function getMoney(source,type,amount)
    if Config.Framework == "QBCore" then
        local Player = QBCore.Functions.GetPlayer(source)
        local money = Player.PlayerData.money[type]
        if money >= amount then
            return Player.Functions.RemoveMoney(type,amount)
        else
            return false
        end  
    elseif Config.Framework == "ESX" then
        local xPlayer = ESX.GetPlayerFromId(source)
        local money = xPlayer.getAccount(type).money
        if money >= amount then
            xPlayer.removeAccountMoney(type, amount)
            return true
        else
            return false
        end
    else
        -- Add your money check here:
    end
end

function getPermission(src, level)
    if Config.Framework == "QBCore" then
        if IsPlayerAceAllowed(src, level) or QBCore.Functions.HasPermission(src, level) then
            return true
        end
    elseif Config.Framework == "ESX" then
        local xPlayer = ESX.GetPlayerFromId(src)
        return xPlayer.getGroup() == level
    else
        print('Please add your own permissions check and return true/false, server/framework/_framework.lua line 47')
        return false
    end
end

function Discord(source, identifier, vehicle, price, plate)
    local name = GetPlayerName(source)
    local content = {
        {
            ["color"] = '5015295',
            ["title"] = "**AV Dealership**",
            ["description"] = "**Player:** "..name.."\n**Identifier:** "..identifier.."\n **Vehicle: **"..vehicle.."\n **Price: **"..price.."** \n **Plate: **"..plate.."**",
            ["footer"] = {
                ["text"] = os.date('%c'),
            },
        }
    }
    PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({ username = 'AV Dealership', embeds = content}), { ['Content-Type'] = 'application/json' })
end