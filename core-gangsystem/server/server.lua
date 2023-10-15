--[[
https://discord.gg/k8XNJbD4T7
https://discord.gg/k8XNJbD4T7
https://discord.gg/k8XNJbD4T7
https://discord.gg/k8XNJbD4T7
https://discord.gg/k8XNJbD4T7
https://discord.gg/k8XNJbD4T7
https://discord.gg/k8XNJbD4T7

    cccccccccccccccc        ooooooooooo        rrrrr   rrrrrrrrr            eeeeeeeeeeee
  cc:::::::::::::::c      oo:::::::::::oo      r::::rrr:::::::::r         ee::::::::::::ee
 c:::::::::::::::::c     o:::::::::::::::o     r:::::::::::::::::r       e::::::eeeee:::::ee
c:::::::cccccc:::::c     o:::::ooooo:::::o     rr::::::rrrrr::::::r     e::::::e     e:::::e
c::::::c     ccccccc     o::::o     o::::o      r:::::r     r:::::r     e:::::::eeeee::::::e
c:::::c                  o::::o     o::::o      r:::::r     rrrrrrr     e:::::::::::::::::e
c:::::c                  o::::o     o::::o      r:::::r                 e::::::eeeeeeeeeee
c::::::c     ccccccc     o::::o     o::::o      r:::::r                 e:::::::e
c:::::::cccccc:::::c     o:::::ooooo:::::o      r:::::r                 e::::::::e
 c:::::::::::::::::c     o:::::::::::::::o      r:::::r                  e::::::::eeeeeeee
  cc:::::::::::::::c      oo:::::::::::oo       r:::::r                   ee:::::::::::::e
    cccccccccccccccc        ooooooooooo         rrrrrrr                     eeeeeeeeeeeeee



]]

local QBCore = exports[Config.core]:GetCoreObject()
QBCore.Commands.Add('gangmenu', 'Gang menu', {}, false, function(source, args)
    local xPlayer = QBCore.Functions.GetPlayer(source)

    local sqlCheck = [[
        SELECT gangname,enabled
        FROM core_gangsystem
        WHERE citizenid = ?
    ]]

    local valuesCheck = { xPlayer.PlayerData.citizenid }

    exports.oxmysql:execute(sqlCheck, valuesCheck, function(result)
        if result[1] then
            if result[1].enabled then
                TriggerClientEvent('core-gangsystem:client:gangmenu', source)
            else
                TriggerClientEvent('core-gangsystem:client:notify', xPlayer.PlayerData.source,
                    'your gang have been disabled.',
                    'top-center',
                    'error')
            end
        else
            TriggerClientEvent('core-gangsystem:client:notify', xPlayer.PlayerData.source,
                'You are not a member of any gang.',
                'top-center',
                'error')
        end
    end)
end)
RegisterNetEvent('core-gangsystem:server:firemember', function(data)
    local xPlayer = QBCore.Functions.GetPlayer(source)
    local ply = QBCore.Functions.GetPlayerByCitizenId(data.cid)
    if ply.PlayerData.gang.isboss then
        return TriggerClientEvent('core-gangsystem:client:notify', xPlayer.PlayerData.source,
            'You cant fire the leader',
            'top-center',
            'error')
    end
    if ply then
        ply.Functions.SetGang("none", 0)
        local deleteQuery = "DELETE FROM core_gangmembers WHERE citizenid = @id"
        MySQL.Async.execute(deleteQuery, { ["@id"] = data.cid }, function()
            TriggerClientEvent('core-gangsystem:client:notify', xPlayer.PlayerData.source,
                'You fired ' .. ply.PlayerData.charinfo.firstname .. " from your gang",
                'top-center',
                'success')
        end)
    else
        TriggerClientEvent('core-gangsystem:client:notify', xPlayer.PlayerData.source,
            'The player aint online',
            'top-center',
            'error')
    end
end)
RegisterNetEvent('core-gangsystem:addgangpoints', function(points, gang)
    local xPlayer = QBCore.Functions.GetPlayer(source)
    local sqlQuery = [[
        UPDATE core_gangsystem
        SET gangpoints=?
        WHERE gangname = ?
    ]]
    exports.oxmysql:execute(sqlQuery, { points, gang }, function()
        TriggerClientEvent('core-gangsystem:client:notify', xPlayer.PlayerData.source,
            gang .. " gang has received " .. points .. " points.",
            'top-center',
            'inform')
    end)
end)
QBCore.Commands.Add('admingangmenu', 'Manage gangs', {}, false, function(source, args)
    TriggerClientEvent('core-gangsystem:client:adminmenu', source)
end, "admin")



QBCore.Functions.CreateCallback('core-gangsystem:getAllGangs', function(source, cb)
    local sqlQuery = [[
        SELECT *
        FROM core_gangsystem
    ]]

    exports.oxmysql:execute(sqlQuery, {}, function(result)
        if result then
            cb(result)
        else
            cb(nil)
        end
    end)
end)

RegisterServerEvent('core-gangsystem:server:disableGang')
AddEventHandler('core-gangsystem:server:disableGang', function(gangName)
    local xPlayer = QBCore.Functions.GetPlayer(source)

    -- Check if the gang is already disabled
    local sqlCheckQuery = "SELECT enabled FROM core_gangsystem WHERE gangname = @gangName"

    exports.oxmysql:execute(sqlCheckQuery, { ["@gangName"] = gangName }, function(result)
        if not result[1].enabled then
            -- Gang is already disabled
            TriggerClientEvent('core-gangsystem:client:notify', xPlayer.PlayerData.source,
                'The ' .. gangName .. ' gang is already disabled.',
                'top-center',
                'error')
        else
            -- Gang is not disabled, proceed to disable it
            local sqlUpdateQuery = "UPDATE core_gangsystem SET enabled = 0 WHERE gangname = @gangName"

            MySQL.Async.execute(sqlUpdateQuery, { ["@gangName"] = gangName }, function()
                TriggerClientEvent('core-gangsystem:client:notify', xPlayer.PlayerData.source,
                    'You have disabled the ' .. gangName .. ' gang.',
                    'top-center',
                    'success')
            end)
        end
    end)
end)
RegisterServerEvent('core-gangsystem:server:EnableGang')
AddEventHandler('core-gangsystem:server:EnableGang', function(gangName)
    local xPlayer = QBCore.Functions.GetPlayer(source)
    -- Check if the gang is already disabled
    local sqlCheckQuery = "SELECT enabled FROM core_gangsystem WHERE gangname = @gangName"

    exports.oxmysql:execute(sqlCheckQuery, { ["@gangName"] = gangName }, function(result)
        if not result[1].enabled then
            local sqlQuery = "UPDATE core_gangsystem SET enabled = 1 WHERE gangname = @gangName"
            MySQL.Async.execute(sqlQuery, { ["@gangName"] = gangName }, function()
                TriggerClientEvent('core-gangsystem:client:notify', xPlayer.PlayerData.source,
                    'You have enabled the ' .. gangName .. " gang.",
                    'top-center',
                    'success')
            end)
        else
            TriggerClientEvent('core-gangsystem:client:notify', xPlayer.PlayerData.source,
                'The ' .. gangName .. ' gang is already enabled',
                'top-center',
                'error')
        end
    end)
end)
RegisterNetEvent('core-gangsystem:server:setgang', function(playerid, gangname, label)
    local xPlayer = QBCore.Functions.GetPlayer(tonumber(playerid))
    local sqlCheck1 = [[
        SELECT gangname
        FROM core_gangmembers
        WHERE citizenid = ?
    ]]
    local valuesCheck1 = { xPlayer.PlayerData.citizenid }
    exports.oxmysql:execute(sqlCheck1, valuesCheck1, function(result)
        if result[1] then
            TriggerClientEvent('core-gangsystem:client:notify', xPlayer.PlayerData.source,
                'You are already in a gang',
                'top-center',
                'error')
        else
            exports.oxmysql:insert(
                'INSERT INTO core_gangmembers (citizenid, license, firstname, lastname, gangname) VALUES (?, ?, ?, ?, ?)',
                { xPlayer.PlayerData.citizenid, xPlayer.PlayerData.license, xPlayer.PlayerData.charinfo.firstname,
                    xPlayer.PlayerData.charinfo.lastname, gangname })

            xPlayer.Functions.SetGang(gangname, 0)
        end
    end)
    local sqlCheck = [[
        SELECT gangname
        FROM core_gangsystem
        WHERE citizenid = ?
    ]]

    local valuesCheck = { xPlayer.PlayerData.citizenid }

    exports.oxmysql:execute(sqlCheck, valuesCheck, function(result)
        if result[1] then
            TriggerClientEvent('core-gangsystem:client:notify', xPlayer.PlayerData.source,
                'You are already in a gang',
                'top-center',
                'error')
        else
            exports['qb-core']:AddGang(gangname, {
                label = label,
                grades = {
                    ['0'] = {
                        name = 'Recruit'
                    },
                    ['1'] = {
                        name = 'Enforcer'
                    },
                    ['2'] = {
                        name = 'Shot Caller'
                    },
                    ['3'] = {
                        name = 'Boss',
                        isboss = true
                    },
                }
            })

            Wait(500)

            local sqlInsert = [[
                INSERT INTO core_gangsystem (citizenid, license, firstname, lastname, gangname, label, enabled)
                VALUES (?, ?, ?, ?, ?, ?, ?)
            ]]

            local valuesInsert = { xPlayer.PlayerData.citizenid, xPlayer.PlayerData.license,
                xPlayer.PlayerData.charinfo.firstname, xPlayer.PlayerData.charinfo.lastname, gangname, label, 1 }

            exports.oxmysql:execute(sqlInsert, valuesInsert, function()
                -- Handle the insertion result if needed
            end)

            xPlayer.Functions.SetGang(gangname, 3)
            TriggerClientEvent('core-gangsystem:client:notify', xPlayer.PlayerData.source, 'Your gang has been created',
                'top-center',
                'success')
        end
    end)
end)




RegisterNetEvent('core-gangsystem:serversendinvite', function(playerid, gangname)
    local src = source
    local playerPed = GetPlayerPed(src)
    local targetPed = GetPlayerPed(playerid)
    local playerCoords = GetEntityCoords(playerPed)
    local targetCoords = GetEntityCoords(targetPed)
    print(playerCoords)
    print(targetCoords)
    local xPlayer = QBCore.Functions.GetPlayer(tonumber(playerid))
    if #(playerCoords - targetCoords) < 2.5 then
        if xPlayer ~= nil then
            TriggerClientEvent('core-gangsystem:client:setgang', xPlayer.PlayerData.source, playerid, gangname)
        else
            TriggerClientEvent('core-gangsystem:client:notify', source,
                'Player aint online',
                'top-center',
                'error')
        end
    else
        TriggerClientEvent('core-gangsystem:client:notify', source,
            'No one nearby',
            'top-center',
            'error')
    end
end)
QBCore.Functions.CreateCallback('core-gangsystem:server:getPlayerCountInGang', function(source, cb, gangName)
    local sqlQuery = [[
        SELECT COUNT(*) as count
        FROM core_gangmembers
        WHERE gangname = ?
    ]]

    exports.oxmysql:execute(sqlQuery, { gangName }, function(result)
        if result[1] then
            local playerCount = result[1].count
            cb(playerCount)
        else
            cb(0)
        end
    end)
end)
RegisterNetEvent('core-gangsystem:setganga', function(playerid, gangname)
    local xPlayer = QBCore.Functions.GetPlayer(tonumber(playerid))

    local sqlCheck = [[
        SELECT gangname
        FROM core_gangmembers
        WHERE citizenid = ?
    ]]

    local valuesCheck = { xPlayer.PlayerData.citizenid }

    exports.oxmysql:execute(sqlCheck, valuesCheck, function(result)
        if result[1] then
            TriggerClientEvent('core-gangsystem:client:notify', xPlayer.PlayerData.source,
                'You are already in a gang',
                'top-center',
                'error')
        else
            exports.oxmysql:insert(
                'INSERT INTO core_gangmembers (citizenid, license, firstname, lastname, gangname) VALUES (?, ?, ?, ?, ?)',
                { xPlayer.PlayerData.citizenid, xPlayer.PlayerData.license, xPlayer.PlayerData.charinfo.firstname,
                    xPlayer.PlayerData.charinfo.lastname, gangname })

            xPlayer.Functions.SetGang(gangname, 0)
        end
    end)
end)
QBCore.Functions.CreateCallback("core-gangsystem:server:getgangpoints", function(source, cb, gangname)
    local sqlCheck = [[
        SELECT gangpoints
        FROM core_gangsystem
        WHERE gangname = ?
    ]]
    local valuesCheck = { gangname }

    exports.oxmysql:execute(sqlCheck, valuesCheck, function(result)
        if result[1] then
            cb(result[1].gangpoints)
        end
    end)
end)
QBCore.Functions.CreateCallback("core-gangsystem:server:getgangmembers", function(source, cb, gangname)
    local sqlCheck = [[
        SELECT firstname, lastname,citizenid
        FROM core_gangmembers
        WHERE gangname = ?
    ]]

    local valuesCheck = { gangname }

    exports.oxmysql:execute(sqlCheck, valuesCheck, function(result)
        local gangMembers = {}

        if result then
            for _, data in pairs(result) do
                local o = QBCore.Functions.GetPlayerByCitizenId(data.citizenid)
                if o then
                    table.insert(gangMembers, {
                        firstname = "✔️" .. data.firstname,
                        lastname = data.lastname,
                        gange = o.PlayerData.gang.name,
                        gradename = o.PlayerData.gang.grade.name,
                        id = data.citizenid
                    })
                else
                    table.insert(gangMembers, {
                        firstname = "❌" .. data.firstname,
                        lastname = data.lastname,
                        gange = gangname,
                        gradename = "",
                        id = data.citizenid
                    })
                end
                print(data.firstname)
            end
        end

        cb(gangMembers)
    end)
end)
RegisterNetEvent('core-gangsystem:server:updategrade', function(data)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local Employee = QBCore.Functions.GetPlayerByCitizenId(data.cid)
    print(data.cid)

    if data.grade > Player.PlayerData.gang.grade.level then
        TriggerClientEvent('QBCore:Notify', src, "You cannot promote to this rank!", "error")
        return
    end

    if Employee then
        if Employee.Functions.SetGang(Player.PlayerData.gang.name, data.grade) then
            TriggerClientEvent('QBCore:Notify', src, "Successfully promoted!", "success")
            TriggerClientEvent('QBCore:Notify', Employee.PlayerData.source,
                "You have been promoted to " .. data.gradename .. ".", "success")
        else
            TriggerClientEvent('QBCore:Notify', src, "Grade does not exist.", "error")
        end
    else
        TriggerClientEvent('QBCore:Notify', src, "Civilian is not in city.", "error")
    end
end)

RegisterNetEvent('core-gangsystem:server:changeplayergrade', function(gangname, citizenid, k)
    local xPlayer = QBCore.Functions.GetPlayerByCitizenId(citizenid)
    TriggerClientEvent('QBCore:Notify', xPlayer.PlayerData.source, "dadaa", "error", 70000)
    xPlayer.Functions.SetGang(gangname, k)
end)
