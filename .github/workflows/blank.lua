
statusLink = "" -- Link for bot status
statusLinkBot = false -- Set true if set bot off using discord

blacklistTile = false
blacklist = {
    {x = -1, y = -1},
    {x = 0, y = -1},
    {x = 1, y = -1}
}

itmSeed = itmId + 1 -- Item seed / Dont edit

delayHarvest = 130
delayPlant = 130
delayPunch = 150
delayPlace = 150

tileNumber = 3 -- Customable from 1 to 5
customTile = false -- Set true if custom breaking pos
customX = 0 -- Custom breaking pos x
customY = 0 -- Custom breaking pos y

separatePlant = false -- Set true if separate harvest and plant
dontPlant = false -- Set true if store all seed and dont plant any
buyAfterPNB = true -- Set true if buying and storing pack after each pnb
root = false -- Set true if farming root
looping = true -- Set false if not looping

pack = "WL" -- Pack name to display on webhook
packList = {242, 1796} -- List of pack id
packName = "world_lock" -- Pack name in store
minimumGem = 200000 -- Minimum gems to buy pack
packPrice = 2000 -- Pack price
packLimit = 200 -- Limit of buying pack before bp full

joinWorldAfterStore = false -- Set true if join random world after each rotation
worldToJoin = {"world1","world2","world3","world4","world5","world6","world7","world8","world9"} -- List of world to join after finishing 1 world
joinDelay = 5000 -- World join delay

restartTimer = false -- Set true if restart time of farm after looping
customShow = false -- Set true if showing only custom amount of world
showList = 3 -- Number of custom worlds to be shown

goods = {98, 18, 32, 6336, 1796, 9640, itmId, itmSeed} -- Item whitelist (don't edit)

items = {
    {name = "World Lock", id = 242, emote = "<:world_lock:1011929928519925820>"},
    {name = "Pepper Tree", id = 4584, emote = "<:pepper_tree:1011930020836544522>"},
    {name = "Pepper Tree Seed", id = 4585, emote = "<:pepper_tree_seed:1011930051744374805>"},
    {name = "Diamond Lock", id = 1796, emote = ":large_blue_diamond:"}
} -- List of item info

------------------ Dont Touch ------------------
list = {}
tree = {}
waktu = {}
worlds = {}
fossil = {}
tileBreak = {}
onlen = os.time()
loop = 0
hiik = 0
profit = 0
listNow = 1
strWaktu = ""
t = os.time()
iddcs = Bot[getBot().name:upper()].iddc
start = Bot[getBot().name:upper()].startFrom
stop = #Bot[getBot().name:upper()].worldList
doorFarm = Bot[getBot().name:upper()].doorFarm
messageId = Bot[getBot().name:upper()].messageId
worldList = Bot[getBot().name:upper()].worldList
totalList = #Bot[getBot().name:upper()].worldList
webhookLink = Bot[getBot().name:upper()].webhookLink
upgradeBackpack = Bot[getBot().name:upper()].upgradeBackpack
gm1 = "0"
gm2 = "0"
gm3 = "0"
gm4 = "0"
gm5 = "0"


for i = start,#worldList do
    table.insert(worlds,worldList[i])
end

if looping then
    for i = 1,start - 1 do
        table.insert(worlds,worldList[i])
    end
end

for _,pack in pairs(packList) do
    table.insert(goods,pack)
end

for i = math.floor(tileNumber/2),1,-1 do
    i = i * -1
    table.insert(tileBreak,i)
end
for i = 0, math.ceil(tileNumber/2) - 1 do
    table.insert(tileBreak,i)
end

if (showList - 1) >= #worldList then
    customShow = false
end

if dontPlant then
    separatePlant = false
end

function includesNumber(table, number)
    for _,num in pairs(table) do
        if num == number then
            return true
        end
    end
    return false
end

function bl(world)
    blist = {}
    fossil[world] = 0
    for _,tile in pairs(getTiles()) do
        if tile.fg == 6 then
            doorX = tile.x
            doorY = tile.y
        elseif tile.fg == 3918 then
            fossil[world] = fossil[world] + 1
        end
    end
    if blacklistTile then
        for _,tile in pairs(blacklist) do
            table.insert(blist,{x = doorX + tile.x, y = doorY + tile.y})
        end
    end
end

function tilePunch(x,y)
    for _,num in pairs(tileBreak) do
        if getTile(x - 1,y + num).fg ~= 0 or getTile(x - 1,y + num).bg ~= 0 then
            return true
        end
    end
    return false
end

function tilePlace(x,y)
    for _,num in pairs(tileBreak) do
        if getTile(x - 1,y + num).fg == 0 and getTile(x - 1,y + num).bg == 0 then
            return true
        end
    end
    return false
end

function check(x,y)
    for _,tile in pairs(blist) do
        if x == tile.x and y == tile.y then
            return false
        end
    end
    return true
end

function warp(world,id)
    cok = 0
    while getBot().world ~= world:upper() and not nuked do
        while getBot().status ~= "Online" do
            sleep(1000)
            reconnect(world,id)
            sleep(1000)
        end
        sleep(5000)
        sendPacket(3,"action|join_request\nname|"..world:upper().."\ninvitedWorld|0")
        sleep(10000)
        if cok == 20 then
            nuked = true
        else
            cok = cok + 1
        end
    end
    if id ~= "" and not nuked then
        while getTile(math.floor(getBot().x / 32),math.floor(getBot().y / 32)).fg == 6 and not nuked do
            while getBot().status ~= "Online" do
                sleep(1000)
                reconnect(world,id)
                sleep(1000)
            end
            sleep(3000)
            sendPacket(3,"action|join_request\nname|"..world:upper().."|"..id:upper().."\ninvitedWorld|0")
            sleep(1000)
        end
    end
end

function waktuWorld()
    strWaktu = ""
    if customShow then
        for i = showList,1,-1 do
            newList = listNow - i
            if newList <= 0 then
                newList = newList + totalList
            end
            strWaktu = strWaktu.."\n"..worldList[newList]:upper().." ( "..(waktu[worldList[newList]] or "?").." | "..(tree[worldList[newList]] or "?").." )"
        end
    else
        for _,world in pairs(worldList) do
            strWaktu = strWaktu.."\n"..world:upper().." ( "..(waktu[world] or "?").." | "..(tree[world] or "?").." )"
        end
    end
end

function botInfo(info)
    te = os.time() - t
    sleep(1000)
    ontb = os.time() - onlen
    fossill = fossil[getBot().world] or 0
    local text = [[
        $webHookUrl = "]]..webhookLink..[[/messages/]]..messageId..[["
        $CPU = Get-WmiObject Win32_Processor | Measure-Object -Property LoadPercentage -Average | Select -ExpandProperty Average
        $CompObject =  Get-WmiObject -Class WIN32_OperatingSystem
        $Memory = ((($CompObject.TotalVisibleMemorySize - $CompObject.FreePhysicalMemory)*100)/ $CompObject.TotalVisibleMemorySize)
        $RAM = [math]::Round($Memory, 0)
        $thumbnailObject = @{
            url = "https://uploads-ssl.webflow.com/5e9567ba9b481d3b77facfda/5e996510531fea863b027d2d_Artboard%203%20copy%2019%404x-8-p-500.png"
        }
        $footerObject = @{
            text = "]]..(os.date("!%a %b %d at %H:%M", os.time() + 7 * 60 * 60))..[["
        }
        $fieldArray = @(
            @{
                name = "<:pickaxe:1011931845065183313> Bot Info"
                value = "]]..info..[[  |  Seed:]]..findItem(itmSeed)..[[  Block:]]..findItem(itmId)..[["
                inline = "false"
            }
            @{
                name = "<:birth_certificate:1011929949076193291> Bot Name"
                value = "]]..getBot().name..[["
                inline = "true"
            }
            @{
                name = "<:heart_monitor:1012587208902987776> Bot Status"
                value = "]]..getBot().status..[["
                inline = "true"
            }
            @{
                name = "<:globe:1011929997679796254> World Name"
                value = "]]..getBot().world..[["
                inline = "true"
            }
            @{
                name = "<:growtopia_scroll:1011972982261944444> World Order ( ]]..loop..[[ Loops)"
                value = "]]..start..[[ / ]]..stop..[["
                inline = "true"
            }
            @{
                name = "<:guest_book:1012588503466528869> Bot Profit"
                value = "]]..profit..[[ ]]..pack..[["
                inline = "true"
            }
            @{
                name = "<:CPU:994981162588053565> CPU & RAM"
                value = "$CPU% | $RAM%"
                inline = "true"
            }
            @{
                name = "<:change_of_address:1012566655995490354> World List"
                value = "]]..strWaktu..[["
                inline = "false"
            }
            @{
                name = "<:growtopia_clock:1011929976628596746> Bot Uptime"
                value = "]]..math.floor(ontb/86400)..[[ Days ]]..math.floor(ontb%86400/3600)..[[ Hours ]]..math.floor(ontb%86400%3600/60)..[[ Minutes"
                inline = "true"
            }
            @{
                name = ":person_running: Bot Running"
                value = "]]..math.floor(te/86400)..[[ Days ]]..math.floor(te%86400/3600)..[[ Hours ]]..math.floor(te%86400%3600/60)..[[ Minutes"
                inline = "true"
            }
        )
        $embedObject = @{
            title = "<:exclamation_sign:1011934940096630794>  ]]..rdpnam..[[ - ]]..Bot[getBot().name:upper()].slot..[["
            color = "9999999"
            thumbnail = $thumbnailObject
            footer = $footerObject
            fields = $fieldArray
        }
        $embedArray = @($embedObject)
        $payload = @{
            embeds = $embedArray
        }
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
        Invoke-RestMethod -Uri $webHookUrl -Body ($payload | ConvertTo-Json -Depth 4) -Method Patch -ContentType 'application/json'
    ]]
    local file = io.popen("powershell -command -", "w")
    file:write(text)
    file:close()
end

function packInfo(link,id,desc)
    local text = [[
        $webHookUrl = "]]..link..[[/messages/]]..id..[["
        $footerObject = @{
            text = "]]..(os.date("!%a %b %d at %H:%M", os.time() + 7 * 60 * 60))..[["
        }
        $fieldArray = @(
            @{
                name = "]]..getBot().world..[["
                value = "]]..desc..[["
                inline = "false"
            }
        )
        $embedObject = @{
            title = "<:globe:1011929997679796254> ]]..rdpnam..[["
            color = "111111"
            thumbnail = $thumbnailObject
            footer = $footerObject
            fields = $fieldArray
        }
        $embedArray = @($embedObject)
        $payload = @{
            embeds = $embedArray
        }
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
        Invoke-RestMethod -Uri $webHookUrl -Body ($payload | ConvertTo-Json -Depth 4) -Method Patch -ContentType 'application/json'
    ]]
    local file = io.popen("powershell -command -", "w")
    file:write(text)
    file:close()
end

function reconInfo()
    onkah = " "
    if getBot().status ~= "Online" then
        onkah = "@everyone"
    end
    local text = [[
        $webHookUrl = "]]..webhookOffline..[["
        $payload = @{
            content = "]]..getBot().name..[[  ]]..rdpnam..[[ - ]]..Bot[getBot().name:upper()].slot..[[ status  ]]..getBot().status..[[ ]]..onkah..[["
        }
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
        Invoke-RestMethod -Uri $webHookUrl -Body ($payload | ConvertTo-Json -Depth 4) -Method Post -ContentType 'application/json'
    ]]
    local file = io.popen("powershell -command -", "w")
    file:write(text)
    file:close()
end

function reconnin(zzc)
    local text = [[
        $webHookUrl = "]]..webhookOffline..[["
        $payload = @{
            content = "]]..getBot().name..[[  ]]..rdpnam..[[ - ]]..Bot[getBot().name:upper()].slot..[[  ]]..zzc..[["
        }
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
        Invoke-RestMethod -Uri $webHookUrl -Body ($payload | ConvertTo-Json -Depth 4) -Method Post -ContentType 'application/json'
    ]]
    local file = io.popen("powershell -command -", "w")
    file:write(text)
    file:close()
end

function reconnect(world,id,x,y)
    if getBot().status ~= "Online" then
        onlen = os.time()
        botInfo("Reconnecting")
        sleep(1000)
        reconInfo()
        sleep(1000)
        while true do
            sleep(5000)
            while getBot().status == "Online" and getBot().world ~= world:upper() do
                sendPacket(3,"action|join_request\nname|"..world:upper().."\ninvitedWorld|0")
                sleep(10000)
            end
            if getBot().status == "Online" and getBot().world == world:upper() then
                if id ~= "" then
                    while getTile(math.floor(getBot().x / 32),math.floor(getBot().y / 32)).fg == 6 do
                        sendPacket(3,"action|join_request\nname|"..world:upper().."|"..id:upper().."\ninvitedWorld|0")
                        sleep(1000)
                    end
                end
                if x and y and getBot().status == "Online" and getBot().world == world:upper() then
                    while math.floor(getBot().x / 32) ~= x or math.floor(getBot().y / 32) ~= y do
                        findPath(x,y)
                        sleep(100)
                    end
                end
                if getBot().status == "Online" and getBot().world == world:upper() then
                    if x and y then
                        if getBot().status == "Online" and math.floor(getBot().x / 32) == x and math.floor(getBot().y / 32) == y then
                            break
                        end
                    elseif getBot().status == "Online" then
                        break
                    end
                end
            end
        end
        huun()
        sleep(1000)
        reconInfo()
        sleep(1000)
        botInfo("Farming")
        sleep(100)
        recon = false
    end
end

function round(n)
    return n % 1 > 0.5 and math.ceil(n) or math.floor(n)
end

function tileDrop1(x,y,num)
    local count = 0
    local stack = 0
    for _,obj in pairs(getObjects()) do
        if round(obj.x / 32) == x and math.floor(obj.y / 32) == y then
            count = count + obj.count
            stack = stack + 1
        end
    end
    if stack < 20 and count <= (4000 - num) then
        return true
    end
    return false
end

function tileDrop2(x,y,num)
    local count = 0
    local stack = 0
    for _,obj in pairs(getObjects()) do
        if round(obj.x / 32) == x and math.floor(obj.y / 32) == y then
            count = count + obj.count
            stack = stack + 1
        end
    end
    if count <= (4000 - num) then
        return true
    end
    return false
end

function storePack()
    for _,pack in pairs(packList) do
        for _,tile in pairs(getTiles()) do
            if tile.fg == patokanPack or tile.bg == patokanPack then
                if tileDrop1(tile.x,tile.y,findItem(pack)) then
                    while math.floor(getBot().x / 32) ~= (tile.x - 1) or math.floor(getBot().y / 32) ~= tile.y do
                        findPath(tile.x - 1,tile.y)
                        sleep(1000)
                        reconnect(storagePack,doorPack,tile.x - 1,tile.y)
                    end
                    while findItem(pack) > 0 and tileDrop1(tile.x,tile.y,findItem(pack)) do
                        sendPacket(2,"action|drop\n|itemID|"..pack)
                        sendPacket(2,"action|dialog_return\ndialog_name|drop_item\nitemID|"..pack.."|\ncount|"..findItem(pack))
                        sleep(2000)
                        reconnect(storagePack,doorPack,tile.x - 1,tile.y)
                    end
                end
            end
            if findItem(pack) == 0 then
                break
            end
        end
    end
end

function itemInfos(ids)
    local result = {name = "null", id = ids, emote = "null"}
    for _,item in pairs(items) do
        if item.id == ids then
            result.name = item.name
            result.emote = item.emote
            return result
        end
    end
    return result
end

function infoPack()
    local store = {}
    for _,obj in pairs(getObjects()) do
        if store[obj.id] then
            store[obj.id].count = store[obj.id].count + obj.count
        else
            store[obj.id] = {id = obj.id, count = obj.count}
        end
    end
    local str = ""
    for _,object in pairs(store) do
        str = str.."\n"..itemInfos(object.id).emote.." "..itemInfos(object.id).name.." : x"..object.count
    end
    return str
end

function join()
    botInfo("Clearing World Logs")
    sleep(100)
    for _,wurld in pairs(worldToJoin) do
        warp(wurld,"")
        sleep(joinDelay)
        reconnect(wurld,"")
    end
end

function storeSeed(world)
    botInfo("Storing Seed")
    sleep(100)
    collectSet(false,3)
    sleep(100)
    warp(storageSeed,doorSeed)
    sleep(100)
    for _,tile in pairs(getTiles()) do
        if tile.fg == patokanSeed or tile.bg == patokanSeed then
            if tileDrop2(tile.x,tile.y,100) then
                while math.floor(getBot().x / 32) ~= (tile.x - 1) or math.floor(getBot().y / 32) ~= tile.y do
                    findPath(tile.x - 1,tile.y)
                    sleep(1000)
                    reconnect(storageSeed,doorSeed,tile.x - 1,tile.y)
                end
                while findItem(itmSeed) >= 100 and tileDrop2(tile.x,tile.y,100) do
                    sendPacket(2,"action|drop\n|itemID|"..itmSeed)
                    sendPacket(2,"action|dialog_return\ndialog_name|drop_item\nitemID|"..itmSeed.."|\ncount|100")
                    sleep(500)
                    reconnect(storageSeed,doorSeed,tile.x - 1,tile.y)
                end
            end
            if findItem(itmSeed) < 100 then
                break
            end
        end
    end
    packInfo(webhookLinkSeed,messageIdSeed,infoPack())
    sleep(100)
    if joinWorldAfterStore then
        join()
        sleep(100)
    end
    warp(world,doorFarm)
    sleep(100)
    collectSet(true,3)
    sleep(100)
    botInfo("Farming")
    sleep(100)
end

function buy()
    botInfo("Buying and Storing Pack")
    sleep(100)
    collectSet(false,3)
    sleep(100)
    warp(storagePack,doorPack)
    sleep(100)
    while findItem(112) >= packPrice do
        for i = 1, packLimit do
            gems = findItem(112)
            sendPacket(2,"action|buy\nitem|"..packName)
            sleep(1000)
            if findItem(242) >= 100 then
                wear(242)
                sleep(100)
            end
            profit = profit + 1
            if findItem(112) < packPrice then
                break
            end
        end
        storePack()
        sleep(100)
        reconnect(storagePack,doorPack)
    end
    packInfo(webhookLinkPack,messageIdPack,infoPack())
    sleep(100)
    if joinWorldAfterStore then
        join()
        sleep(100)
    end
end

function clear()
    for _,item in pairs(getInventory()) do
        if not includesNumber(goods, item.id) then
            sendPacket(2, "action|trash\n|itemID|"..item.id)
            sendPacket(2, "action|dialog_return\ndialog_name|trash_item\nitemID|"..item.id.."|\ncount|"..item.count) 
            sleep(500)
        end
    end
end

function take(world)
    botInfo("Taking Seed")
    sleep(100)
    while findItem(itmSeed) == 0 do
        collectSet(false,3)
        sleep(100)
        warp(storageSeed,doorSeed)
        sleep(100)
        for _,obj in pairs(getObjects()) do
            if obj.id == itmSeed then
                findPath(round(obj.x / 32),math.floor(obj.y / 32))
                sleep(1000)
                collect(2)
                sleep(1000)
            end
            if findItem(itmSeed) == 200 then
                sendPacket(2,"action|drop\n|itemID|"..itmSeed)
                sendPacket(2,"action|dialog_return\ndialog_name|drop_item\nitemID|"..itmSeed.."|\ncount|100")
                break
            end
        end
        packInfo(webhookLinkSeed,messageIdSeed,infoPack())
        sleep(100)
        if joinWorldAfterStore then
            join()
            sleep(100)
        end
        warp(world,doorFarm)
        sleep(100)
        collectSet(true,3)
        sleep(100)
    end
end

function plant(world)
    for _,tile in pairs(getTiles()) do
        if findItem(itmSeed) == 0 and not dontPlant then
            take(world)
            sleep(100)
            botInfo("Farming")
            sleep(100)
        end
        if itemInfo(tile.fg).collisionType ~= 0 and tile.y ~= 0 and getTile(tile.x,tile.y - 1).fg == 0 then
            if not blacklistTile or check(tile.x,tile.y) then
                findPath(tile.x,tile.y - 1)
                while getTile(tile.x,tile.y - 1).fg == 0 and itemInfo(getTile(tile.x,tile.y).fg).collisionType ~= 0 do
                    place(itmSeed,0,0)
                    sleep(delayPlant)
                    reconnect(world,doorFarm,tile.x,tile.y - 1)
                end
            end
        end
    end
    if findItem(itmSeed) >= 100 then
        storeSeed(world)
        sleep(100)
    end
end

function pnb(world)
    if findItem(itmId) >= tileNumber then
        if not customTile then
            ex = 1
            ye = math.floor(getBot().y / 32)
            if ye > 40 then
                ye = ye - 10
            elseif ye < 11 then
                ye = ye + 10
            end
            if getTile(ex,ye).fg ~= 0 and getTile(ex,ye).fg ~= itmSeed then
                ye = ye - 1
            end
        else
            ex = customX
            ye = customY
        end
        while math.floor(getBot().x / 32) ~= ex or math.floor(getBot().y / 32) ~= ye do
            findPath(ex,ye)
            sleep(100)
        end
        if tileNumber > 1 then
            while findItem(itmId) >= tileNumber and findItem(itmSeed) < 190 do
                while tilePlace(ex,ye) do
                    for _,i in pairs(tileBreak) do
                        if getTile(ex - 1,ye + i).fg == 0 and getTile(ex - 1,ye + i).bg == 0 then
                            place(itmId,-1,i)
                            sleep(delayPlace)
                            reconnect(world,doorFarm,ex,ye)
                        end
                    end
                end
                while tilePunch(ex,ye) do
                    for _,i in pairs(tileBreak) do
                        if getTile(ex - 1,ye + i).fg ~= 0 or getTile(ex - 1,ye + i).bg ~= 0 then
                            punch(-1,i)
                            sleep(delayPunch)
                            reconnect(world,doorFarm,ex,ye)
                        end
                    end
                end
                reconnect(world,doorFarm,ex,ye)
            end
        else
            while findItem(itmId) > 0 and findItem(itmSeed) < 190 do
                while getTile(ex - 1,ye).fg == 0 and getTile(ex - 1,ye).bg == 0 do
                    place(itmId,-1,0)
                    sleep(delayPlace)
                    reconnect(world,doorFarm,ex,ye)
                end
                while getTile(ex - 1,ye).fg ~= 0 or getTile(ex - 1,ye).bg ~= 0 do
                    punch(-1,0)
                    sleep(delayPunch)
                    reconnect(world,doorFarm,ex,ye)
                end
            end
        end
        clear()
        sleep(100)
        if buyAfterPNB and findItem(112) >= minimumGem then
            buy()
            sleep(100)
            warp(world,doorFarm)
            sleep(100)
            collectSet(true,3)
            sleep(100)
            botInfo("Farming")
            sleep(100)
        end
    end
end

function harvest(world)
    botInfo("Farming")
    sleep(100)
    tree[world] = 0
    if dontPlant then
        for _,tile in pairs(getTiles()) do
            if getTile(tile.x,tile.y - 1).ready and getTile(tile.x,tile.y - 1).fg == itmSeed then
                if not blacklistTile or check(tile.x,tile.y) then
                    tree[world] = tree[world] + 1
                    findPath(tile.x,tile.y - 1)
                    while getTile(tile.x,tile.y - 1).fg == itmSeed do
                        punch(0,0)
                        sleep(delayHarvest)
                        reconnect(world,doorFarm,tile.x,tile.y - 1)
                    end
                    if root then
                        while getTile(tile.x, tile.y).fg == (itmId + 4) and itemInfo(getTile(tile.x, tile.y).fg).collisionType ~= 0 do
                            punch(0, 1)
                            sleep(delayHarvest)
                            reconnect(world,doorFarm,tile.x,tile.y - 1)
                        end
                        clear()
                        sleep(100)
                    end
                end
            end
            if findItem(itmId) >= 190 then
                pnb(world)
                sleep(100)
                if findItem(itmSeed) >= 190 then
                    storeSeed(world)
                    sleep(100)
                end
            end
        end
    elseif not separatePlant then
        for _,tile in pairs(getTiles()) do
            if findItem(itmSeed) == 0 then
                take(world)
                sleep(100)
                botInfo("Farming")
                sleep(100)
            end
            if getTile(tile.x,tile.y - 1).ready or (itemInfo(tile.fg).collisionType ~= 0 and tile.y ~= 0 and getTile(tile.x,tile.y - 1).fg == 0) then
                if not blacklistTile or check(tile.x,tile.y) then
                    tree[world] = tree[world] + 1
                    findPath(tile.x,tile.y - 1)
                    while getTile(tile.x,tile.y - 1).fg == itmSeed do
                        punch(0,0)
                        sleep(delayHarvest)
                        reconnect(world,doorFarm,tile.x,tile.y - 1)
                    end
                    if root then
                        while getTile(tile.x, tile.y).fg == (itmId + 4) and itemInfo(getTile(tile.x, tile.y).fg).collisionType ~= 0 do
                            punch(0, 1)
                            sleep(delayHarvest)
                            reconnect(world,doorFarm,tile.x,tile.y - 1)
                        end
                        clear()
                        sleep(100)
                    end
                    while getTile(tile.x,tile.y - 1).fg == 0 and itemInfo(getTile(tile.x, tile.y).fg).collisionType ~= 0 do
                        place(itmSeed,0,0)
                        sleep(delayPlant)
                        reconnect(world,doorFarm,tile.x,tile.y - 1)
                    end
                end
            end
            if findItem(itmId) >= 190 then
                pnb(world)
                sleep(100)
                if findItem(itmSeed) >= 190 then
                    storeSeed(world)
                    sleep(100)
                end
            end
        end
    else
        for _,tile in pairs(getTiles()) do
            if getTile(tile.x,tile.y - 1).ready then
                if not blacklistTile or check(tile.x,tile.y) then
                    tree[world] = tree[world] + 1
                    findPath(tile.x,tile.y - 1)
                    while getTile(tile.x,tile.y - 1).fg == itmSeed do
                        punch(0,0)
                        sleep(delayHarvest)
                        reconnect(world,doorFarm,tile.x,tile.y - 1)
                    end
                    if root then
                        while getTile(tile.x, tile.y).fg == (itmId + 4) and getTile(tile.x, tile.y).flags ~= 0 do
                            punch(0, 1)
                            sleep(delayHarvest)
                            reconnect(world,doorFarm,tile.x,tile.y - 1)
                        end
                        clear()
                        sleep(100)
                    end
                end
            end
            if findItem(itmId) >= 190 then
                pnb(world)
                sleep(100)
                plant(world)
                sleep(100)
            end
        end
    end
    pnb(world)
    sleep(100)
    if separatePlant then
        plant(world)
        sleep(100)
    end
    if findItem(112) >= minimumGem then
        buy()
        sleep(100)
    end
end

function huun()
    if getBot().status == "Online" then
        hii = ":green_circle:"
       end
    if getBot().status ~= "Online" then
        hii = ":red_circle:"
    end
    local ggh = [[
    $CPU = Get-WmiObject Win32_Processor | Measure-Object -Property LoadPercentage -Average | Select -ExpandProperty Average
        $webHookUrl = "]]..cekdcs..[[/messages/]]..iddcs..[["
        $payload = @{
            content = "]]..rdpnam..[[ - ]]..Bot[getBot().name:upper()].slot..[[ ]]..hii..[[ ]]..hiik..[[ ]]..(os.date("!%H:%M", os.time() + 7 * 60 * 60))..[[ | ]]..gm2..[[   ]]..gm3..[[   ]]..gm4..[[  | $CPU%"
        }
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
        Invoke-RestMethod -Uri $webHookUrl -Body ($payload | ConvertTo-Json -Depth 4) -Method Patch -ContentType 'application/json'
    ]]
    local file = io.popen("powershell -command -", "w")
    file:write(ggh)
    file:close()
end

function whgoo(hii)
    local text = [[
        $webHookUrl = "]]..webhookOffline..[["
        $payload = @{
            content = "]]..rdpnam..[[ - ]]..Bot[getBot().name:upper()].slot..[[ ]]..hii..[[ ]]..(os.date("!%H:%M", os.time() + 7 * 60 * 60))..[["
        }
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
        Invoke-RestMethod -Uri $webHookUrl -Body ($payload | ConvertTo-Json -Depth 4) -Method Post -ContentType 'application/json'
    ]]
    local file = io.popen("powershell -command -", "w")
    file:write(text)
    file:close()
end

function hiku()
    if getBot().status ~= "Online" then
            hiik = hiik + 2
        end
    if getBot().status == "Online" then
            hiik = 0
        end
    end

local thread = createThread(function()
    local i = 0
    while true do
        sleep(60000)
        gm1 = findItem(112)
        sleep(500)
        huun()
        sleep(1000)
        hiku()
        sleep(120000)
        gm2 = findItem(112) - gm1
        sleep(500)
        huun()
        sleep(1000)
        hiku()
        sleep(120000)
        gm3 = findItem(112) - gm1
        sleep(500)
        huun()
        sleep(1000)
        hiku()
        sleep(120000)
        gm4 = findItem(112) - gm1
        sleep(500)
        huun()
        sleep(1000)
        hiku()
        sleep(60000)
    end
  end)

thread:resume()
sleep(5000)
while true do
    whgoo("Start")
    sleep(2000)
    for index,world in pairs(worlds) do
    waktuWorld()
    sleep(100)
    ontb = os.time() - onlen
    ontbs = math.floor(ontb%86400/3600)
    if ontbs >= 6 then
        disconnect()
        onlen = os.time()
    end
    sleep(200)
    while true do
        sleep(5000)
        if getBot().status == "Online" then
            break
        end
    end
        sleep(10000)
        warp(world,doorFarm)
        sleep(100)
        if not nuked then
            if findItem(itmSeed) == 0 and not dontPlant then
                take(world)
                sleep(100)
            end
            collectSet(true,3)
            sleep(100)
            bl(world)
            sleep(100)
            botInfo("Starting "..world)
            sleep(100)
            tt = os.time()
            harvest(world)
            sleep(100)
            tt = os.time() - tt
            botInfo("Finished "..world)
            sleep(100)
            waktu[world] = math.floor(tt/3600).." Hours "..math.floor(tt%3600/60).." Minutes"
            sleep(100)
            if joinWorldAfterStore then
                join()
                sleep(100)
            end
        else
            waktu[world] = "NUKED"
            tree[world] = "NUKED"
            nuked = false
            sleep(5000)
        end
        if start < stop then
            start = start + 1
        else
            if restartTimer then
                waktu = {}
                tree = {}
            end
            start = 1
            loop = loop + 1
        end
    end
    if not looping then
        waktuWorld()
        sleep(100)
        botInfo("Finished All World, Removing Bot!")
        sleep(100)
        removeBot(getBot().name)
        break
    end
end
