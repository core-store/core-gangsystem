local QBCore = exports[Config.core]:GetCoreObject()

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
RegisterNetEvent('core-gangsystem:client:notify', function(title, position, type)
    lib.notify({
        title = title,
        position = position,
        type = type
    })
end)

RegisterNetEvent('core-gangsystem:client:adminmenu', function()
    lib.registerContext({
        id = 'admin_menu',
        title = 'Create Gangs',
        options = {
            {
                title = 'View gangs',
                description = 'Click to view all gangs',
                menu = 'gangs_view',
                icon = 'users',
            },
            {
                title = 'Create Gang',
                description = 'Click to create a gang',
                onSelect = function()
                    Gangcreateinput()
                end,
                icon = 'plus'
            },

        }
    })
    lib.showContext('admin_menu')
    QBCore.Functions.TriggerCallback('core-gangsystem:getAllGangs', function(result)
        if result then
            local options = {}
            for k, v in pairs(result) do
                table.insert(options, {
                    title = v.gangname,
                    description = 'label:' .. " " .. v.label,
                    onSelect = function()
                        TriggerEvent('core-gangsystem:managegang', v.gangname, v.citizenid)
                    end,
                    icon = 'user-circle',
                })
            end
            lib.registerContext({
                id = 'gangs_view',
                title = 'Gangs',
                menu = 'admin_menu',
                options = options



            })
        end
    end)
end)
RegisterNetEvent('core-gangsystem:managegang', function(gang)
    lib.registerContext({
        id = 'gangs_view1',
        title = 'Manage Gangs',
        menu = 'gangs_view',
        options = {
            {
                title = 'Disable Gang',
                description = 'Click here to disable the gang',
                onSelect = function()
                    TriggerServerEvent('core-gangsystem:server:disableGang', gang)
                end,
                icon = 'minus-circle'
            },
            {
                title = 'Enable Gang',
                description = 'Click here to Enable the gang',
                onSelect = function()
                    TriggerServerEvent('core-gangsystem:server:EnableGang', gang)
                end,
                icon = 'check-square'
            },
            {
                title = 'Add Gang points',
                description = 'Click here to add gangpoints',
                onSelect = function()
                    TriggerEvent('core-gangsystem:client:addgangpoints', gang)
                end,
                icon = 'plus'
            },

        }

    })
    lib.showContext('gangs_view1')
end)
RegisterNetEvent('core-gangsystem:client:addgangpoints', function(gang)
    local input = lib.inputDialog('Add gangpoints to ' .. gang .. ' gang', {
        { type = 'number', label = 'Choose the number of points', icon = 'hashtag' },
    })
    if not input then return end
    TriggerServerEvent('core-gangsystem:addgangpoints', input[1], gang)
end)
function Gangcreateinput()
    local input = lib.inputDialog('Create Gang', { 'Gang Name', 'Gang Label', 'Gang leader(Player Id)' })
    if not input then return end

    local gangName = input[1]
    local gangLabel = input[2]
    local gangLeaderId = input[3]

    -- Check if any of the input fields are missing
    if not gangName or not gangLabel or not gangLeaderId or gangName == '' or gangLabel == '' or gangLeaderId == '' then
        lib.notify({
            title = 'All fields are required',
            position = 'top-center',
            type = 'error'
        })
        return
    end

    TriggerServerEvent('core-gangsystem:server:setgang', gangLeaderId, gangName, gangLabel)
end

RegisterNetEvent('core-gangsystem:client:gangmenu', function()
    local ply = QBCore.Functions.GetPlayerData()
    QBCore.Functions.TriggerCallback('core-gangsystem:server:getPlayerCountInGang', function(gangcount)
        QBCore.Functions.TriggerCallback('core-gangsystem:server:getgangpoints', function(gangpoints)
            if ply.gang.isboss then
                lib.registerContext({
                    id = 'gang_menu',
                    title = "Gang Menu",
                    options = {
                        {
                            title = 'View gang Members',
                            description = 'Click here to see all the members',
                            menu = 'members_menu',
                            icon = 'bars',
                        },
                        {
                            title = 'Invite Members',
                            description = 'Invite member to gang',
                            onSelect = function()
                                InviteMembers()
                            end,
                            icon = 'user-plus'
                        },

                        {
                            title = 'Details',
                            description = 'Details About the gang',
                            metadata = {
                                { label = 'Gang Points ', value = gangpoints },
                                { label = 'Members ',     value = gangcount },
                                { label = 'Gang Name ',   value = QBCore.Functions.GetPlayerData().gang.name },
                                { label = 'Gang grade ',  value = QBCore.Functions.GetPlayerData().gang.grade.name }

                            },
                            icon = 'info-circle'
                        },

                    }
                })
            else
                lib.registerContext({
                    id = 'gang_menu',
                    title = ply.gang.name,
                    options = {
                        {
                            title = 'Actions',
                            description = 'Actions',
                            menu = 'actions_menu',
                            icon = 'bars',
                        },
                        {
                            title = 'Details',
                            description = 'Details About the gang',
                            metadata = {
                                { label = 'Gang Points ', value = gangpoints },
                                { label = 'Gang Name ',   value = QBCore.Functions.GetPlayerData().gang.name },
                                { label = 'Gang grade ',  value = QBCore.Functions.GetPlayerData().gang.grade.name }

                            },
                            icon = 'info-circle'
                        },


                    }
                })
                local options1 = {}
                if _0xhas(Config.cuffs) then
                    table.insert(options1, {
                        title = 'Escort',
                        onSelect = function()
                            TriggerEvent(Config.escortevent)
                        end,
                        icon = 'circle',
                    })
                    table.insert(options1, {
                        title = 'Cuff/Uncuff',
                        onSelect = function()
                            TriggerEvent(Config.cuffevent)
                        end,
                        icon = 'angle-double-down'
                    })
                    table.insert(options1, {
                        title = 'Place In vehicle',
                        onSelect = function()
                            TriggerEvent(Config.putplayerevent)
                        end,
                        icon = 'car'
                    })
                    table.insert(options1, {
                        title = 'Place Out of vehicle',
                        onSelect = function()
                            TriggerEvent(Config.putplayeroutevent)
                        end,
                        icon = 'car'
                    })
                    table.insert(options1, {
                        title = 'Rob',
                        onSelect = function()
                            TriggerEvent(Config.robplayerevent)
                        end,
                        icon = 'user'
                    })
                end
                lib.registerContext({
                    id = 'actions_menu',
                    title = QBCore.Functions.GetPlayerData().gang.name,
                    options = options1


                })
            end
            local gangmembers = {}
            QBCore.Functions.TriggerCallback('core-gangsystem:server:getgangmembers', function(cb)
                for k, g in pairs(cb) do
                    table.insert(gangmembers, {
                        title = g.firstname .. " " .. g.lastname,
                        description = g.gange .. " " .. g.gradename,
                        event = "core-gangsystem:client:ManageMember",
                        args = {
                            player = g,                                   -- Use g.id to represent the player ID
                            work = QBCore.Functions.GetPlayerData().gang, -- Use g.nameg for the gang name
                        },
                        icon = 'fas fa-users',
                    })
                end
                lib.registerContext({
                    id = 'members_menu',
                    title = "Gang Members",
                    menu = 'gang_menu',
                    options = gangmembers
                })
            end, QBCore.Functions.GetPlayerData().gang.name)


            lib.showContext('gang_menu')
        end, ply.gang.name)
    end, ply.gang.name)
end)
function _0xhas(item)
    return QBCore.Functions.HasItem(item)
end

RegisterNetEvent('core-gangsystem:client:updategrade', function(data)
    TriggerServerEvent('core-gangsystem:server:updategrade', data)
end)

RegisterNetEvent('core-gangsystem:client:ManageMember', function(data)
    local ManageMembers = {}
    for k, v in pairs(QBCore.Shared.Gangs[data.work.name].grades) do
        table.insert(ManageMembers, {
            title = v.name,

            event = 'core-gangsystem:client:updategrade',
            args = {
                cid = data.player.id,
                grade = tonumber(k),
                gradename = v.name
            },
            icon = 'fas fa-users',
        })
    end
    table.insert(ManageMembers, {
        title = "Fire Member",

        event = 'core-gangsystem:client:firemember',
        args = {
            cid = data.player.id,

        },
        icon = 'fire',
    })
    lib.registerContext({
        id = 'grade_member',
        menu = 'members_menu',
        title = data.player.firstname .. " " .. data.player.lastname,
        options = ManageMembers
    })
    lib.showContext('grade_member')
end)
RegisterNetEvent('core-gangsystem:client:firemember', function(data)
    TriggerServerEvent('core-gangsystem:server:firemember', data)
end)
function InviteMembers()
    local input = lib.inputDialog('Invite a member', { 'PlayerId' })
    local playerData = QBCore.Functions.GetPlayerData()
    if not input then return end
    TriggerServerEvent('core-gangsystem:serversendinvite', input[1], playerData.gang.name)
end

RegisterNetEvent('core-gangsystem:client:setgang', function(PlayerId, gangname)
    local alert = lib.alertDialog({
        header = 'Gang Invitation',
        content = 'You received an invitation',
        centered = true,
        cancel = true
    })
    if alert == 'confirm' then
        TriggerServerEvent('core-gangsystem:setganga', PlayerId, gangname)
        lib.notify({
            title = 'You joined the gang',
            position = 'top-center',
            type = 'success'
        })
    else
        lib.notify({
            title = 'you rejected the offer',
            position = 'top-center',
            type = 'error'
        })
    end
end)
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
