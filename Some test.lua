local req=(syn and syn.request) or http_request or request
if not req then return end

local Http=game:GetService("HttpService")
local PLACE_LOBBY=112311675882346
local where=(game.PlaceId==PLACE_LOBBY) and "Lobby" or "Server"

local function send_discord(Check,color)
    req({
        Url="https://discord.com/api/webhooks/1470795201730576467/NTZgcc3ZqHSVPzM9NEG8l0qluLy18PJ8IX5Juq2O7eiAu9H2m66YNcyS2wv60D2-A8lL",
        Method="POST",
        Headers={["Content-Type"]="application/json"},
        Body=Http:JSONEncode({
            username="Roblox Bot",
            embeds={{
                title="🥭 Some Town",
                color=color or 65280,
                fields={{
                    name="[👑] Player",
                    value="- "..game.Players.LocalPlayer.Name,
                    inline=true
                },{
                    name="[🎯] สถานะเซิฟเวอร์",
                    value="- อยู่ที่: "..where,
                    inline=true
                },{
                    name="[⚽️] กำลังทำอะไร",
                    value="- กำลัง : "..Check,
                    inline=true
                }},
                footer={text="Roblox Delta"},
                timestamp=os.date("!%Y-%m-%dT%H:%M:%SZ")
            }}
        })
    })
end

send_discord("เริ่มต้นการทำงาน!!!", 3447003)
local TimeEvent = {
    {hour = 11, min = 0},
    {hour = 17, min = 30},
    {hour = 22, min = 0},
    {hour = 3,  min = 0},
}

local BlackList = {
    [10317257154] = true,
    [10314125406] = true,
}

local function FindServerEvent()
    for _, v in pairs(game:GetService("ReplicatedStorage").Servers:GetChildren()) do
        if v:IsA("StringValue") then
            local __Online  = v:GetAttribute("Online")
            local __UserIds = v:GetAttribute("UserIds")
            local __JobId   = tostring(v.Value):match("^(%S+)")
            if __Online and __Online > 38 and __Online < 50 and __JobId then
                local blocked = false
                if typeof(__UserIds) == "table" then
                    for _, uid in ipairs(__UserIds) do
                        if BlackList[uid] then
                            print("❌ เจอ BlackList UID:", uid, "ในเซิร์ฟ", v.Name)
                            blocked = true
                            break
                        end
                    end
                else
                    print("⚠️ UserIds ไม่ใช่ table:", v.Name)
                end
                if not blocked then
                    print("✅ ลองเข้าเซิร์ฟ:", v.Name, __JobId)
                    game:GetService("ReplicatedStorage").func:InvokeServer("teleport", __JobId)
                    task.wait(1)
                else
                    print("⛔ ข้ามเซิร์ฟ:", v.Name)
                end
            else
                print("⏭ ข้าม (Online ไม่เข้าเงื่อนไข):", v.Name)
            end
        end
    end
end
if getconnections then 
    for _, v in next, getconnections(game:GetService("Players").LocalPlayer.Idled) do
        v:Disable()
    end
end
local script = false
local SendDis = false
local SendDis2 = false
task.spawn(function()
    while task.wait(1) do
        pcall(function()
        local __ThaiTime = os.date("!*t", os.time() + (7 * 60 * 60))
        local EndEvent = (__ThaiTime.hour * 60) + __ThaiTime.min
        for _, t in ipairs(TimeEvent) do
            local EventEnd = (t.hour * 60) + t.min
            local EventTimeEnd = EndEvent - EventEnd
            if EventTimeEnd >= 0 and EventTimeEnd <= 6 then
                if game.PlaceId == 112311675882346 then
                if not SendDis then
                    SendDis = true
                    send_discord("ถึงเวลาแล้ว!!!", 16711680)
                end
                    FindServerEvent()
                else
                    if workspace.Pop.Curfew:FindFirstChildWhichIsA("BasePart", true) then
                        if not script then
                            script = true
                            if not SendDis2 then
                            for _,v in ipairs(game:GetService("Players").LocalPlayer.PlayerGui.TopbarStandard.Holders.Left.Widget.IconButton:GetDescendants()) do
                            if (v:IsA("TextLabel") or v:IsA("TextButton")) and v.Text and v.Text:find("SERVER") then
                            SendDis2 = true
                            send_discord("เจอกิจกรรมแล้วที่เซิฟ:"..v.Text, 10181046)
                            end; end
                            end
                            loadstring(game:HttpGet("https://pastebin.com/raw/TxXsuFzu"))()
                            end
                        end
                    end
                end
            end
        end)
    end
end)
local SendDis3 = false
task.spawn(function()
    local CheckEventEnd = false
    while task.wait(1) do
        pcall(function()
            if game.PlaceId ~= 112311675882346 then
                local EventFolder = workspace.Pop.Curfew:FindFirstChildWhichIsA("BasePart", true)
                if EventFolder then
                    CheckEventEnd = true
                elseif CheckEventEnd then
                    if not SendDis3 then
                    for _,v in ipairs(game:GetService("Players").LocalPlayer.PlayerGui.TopbarStandard.Holders.Left.Widget.IconButton:GetDescendants()) do
                        if (v:IsA("TextLabel") or v:IsA("TextButton")) and v.Text and v.Text:find("SERVER") then
                            SendDis3 = true
                            send_discord("กำลังออกจากเซิฟเวอร์ :"..v.Text, 16744192)
                        end
                    end
                    end
                    task.wait(1)
                    game:Shutdown()
                end
            end
        end)
    end
end)


