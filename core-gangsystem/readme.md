1-run the sql

2-go to qb-core/server/commands: replace setgang command with this
QBCore.Commands.Add('setgang', Lang:t("command.setgang.help"),
{ { name = Lang:t("command.setgang.params.id.name"), help = Lang:t("command.setgang.params.id.help") },
{ name = Lang:t("command.setgang.params.gang.name"), help = Lang:t("command.setgang.params.gang.help") },
{ name = Lang:t("command.setgang.params.grade.name"), help = Lang:t("command.setgang.params.grade.help") } },
true, function(source, args)
local Player = QBCore.Functions.GetPlayer(tonumber(args[1]))
local sqlCheck = [[SELECT gangname
        FROM core_gangmembers
        WHERE citizenid = ?]]

        local valuesCheck = { Player.PlayerData.citizenid }
        if Player then
            exports.oxmysql:execute(sqlCheck, valuesCheck, function(result)
                if result[1] then
                    exports.oxmysql:execute('UPDATE core_gangmembers SET gangname = ? WHERE citizenid = ?',
                        { tostring(args[2]), Player.PlayerData.citizenid })
                    Player.Functions.SetGang(tostring(args[2]), tonumber(args[3]))
                else
                    exports.oxmysql:insert(
                        'INSERT INTO core_gangmembers (citizenid, license, firstname, lastname, gangname) VALUES (?, ?, ?, ?, ?)',
                        { Player.PlayerData.citizenid, Player.PlayerData.license, Player.PlayerData.charinfo.firstname,
                            Player.PlayerData.charinfo.lastname, tostring(args[2]) })

                    Player.Functions.SetGang(tostring(args[2]), tonumber(args[3]))
                end
            end)
        else
            TriggerClientEvent('QBCore:Notify', source, Lang:t('error.not_online'), 'error')
        end
    end, 'admin')

and thats Note the gangs must me in your shared and thanks for buying this script
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