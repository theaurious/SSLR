--[[
    SSLR SCRIPTS — v1.8.1
    Auto Farm + Settings + Discord + User Footer
]]

local Players     = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui   = LocalPlayer:WaitForChild("PlayerGui")
local UIS         = game:GetService("UserInputService")
local RS          = game:GetService("ReplicatedStorage")
local WS          = game:GetService("Workspace")
local RunService  = game:GetService("RunService")
local Tween       = game:GetService("TweenService")
local Lighting    = game:GetService("Lighting")
local CoreGui     = game:GetService("CoreGui")
local TeamsSvc    = game:GetService("Teams")
local PathfindingService = game:GetService("PathfindingService")
local VirtualUser = game:GetService("VirtualUser")
local HttpService = game:GetService("HttpService")

local unpack = table.unpack or unpack
local isMobile = UIS.TouchEnabled and not UIS.KeyboardEnabled
local ICON_SIZE = 60

local figure, figStroke, letterStroke, innerGlow, dot

local ThemeList = {
    Rose        = { accent = Color3.fromRGB(220, 38, 38),  panel = Color3.fromRGB(28,18,22),  bg = Color3.fromRGB(14,10,12) },
    Dark        = { accent = Color3.fromRGB(80, 80, 100),  panel = Color3.fromRGB(18,18,24),  bg = Color3.fromRGB(10,10,14) },
    Light       = { accent = Color3.fromRGB(120,150,220),  panel = Color3.fromRGB(240,240,245), bg = Color3.fromRGB(220,220,230) },
    Indigo      = { accent = Color3.fromRGB(99, 102, 241), panel = Color3.fromRGB(20,20,35),  bg = Color3.fromRGB(12,12,22) },
    Sky         = { accent = Color3.fromRGB(56, 189, 248), panel = Color3.fromRGB(15,25,35),  bg = Color3.fromRGB(8,15,22) },
    Crimson     = { accent = Color3.fromRGB(220, 20, 60),  panel = Color3.fromRGB(30,10,15),  bg = Color3.fromRGB(15,5,8) },
    Amber       = { accent = Color3.fromRGB(245, 158, 11), panel = Color3.fromRGB(30,22,10),  bg = Color3.fromRGB(15,12,6) },
    Emerald     = { accent = Color3.fromRGB(16, 185, 129), panel = Color3.fromRGB(10,28,22),  bg = Color3.fromRGB(5,15,12) },
    Violet      = { accent = Color3.fromRGB(139, 92, 246), panel = Color3.fromRGB(22,15,35),  bg = Color3.fromRGB(12,8,20) },
    Red         = { accent = Color3.fromRGB(239, 68, 68),  panel = Color3.fromRGB(28,12,12),  bg = Color3.fromRGB(15,6,6) },
    MonokaiPro  = { accent = Color3.fromRGB(255, 216, 102),panel = Color3.fromRGB(45,45,45),  bg = Color3.fromRGB(30,30,30) },
    Midnight    = { accent = Color3.fromRGB(100, 100, 180),panel = Color3.fromRGB(15,15,30),  bg = Color3.fromRGB(8,8,18) },
    Rainbow     = { accent = Color3.fromRGB(255, 100, 200),panel = Color3.fromRGB(25,15,35),  bg = Color3.fromRGB(12,8,18) },
    CottonCandy = { accent = Color3.fromRGB(255, 150, 200),panel = Color3.fromRGB(35,25,40),  bg = Color3.fromRGB(20,12,25) },
    Mellow      = { accent = Color3.fromRGB(180, 150, 120),panel = Color3.fromRGB(30,25,20),  bg = Color3.fromRGB(18,15,12) },
    Plant       = { accent = Color3.fromRGB(80, 180, 100), panel = Color3.fromRGB(15,25,18),  bg = Color3.fromRGB(8,15,10) },
    LunarAbyss  = { accent = Color3.fromRGB(140, 130, 200),panel = Color3.fromRGB(18,15,30),  bg = Color3.fromRGB(10,8,18) },
}

local T = {}
local function applyTheme(name)
    local th = ThemeList[name] or ThemeList.Rose
    T.bg      = th.bg or Color3.fromRGB(10,10,14)
    T.panel   = th.panel or Color3.fromRGB(18,18,24)
    T.sidebar = th.bg or Color3.fromRGB(8,8,12)
    T.elem    = Color3.fromRGB(24,24,30)
    T.elemHov = Color3.fromRGB(38,38,48)
    T.accent  = th.accent or Color3.fromRGB(220,38,38)
    T.accentD = th.accent and Color3.new(th.accent.R*0.7, th.accent.G*0.7, th.accent.B*0.7) or Color3.fromRGB(153,27,27)
    T.text    = Color3.fromRGB(255,255,255)
    T.textDim = Color3.fromRGB(160,160,176)
    T.border  = Color3.fromRGB(45,45,55)
    T.gold    = Color3.fromRGB(255,200,60)
    T.green   = Color3.fromRGB(30,120,60)
    T.blue    = Color3.fromRGB(60,130,220)
end
applyTheme("Rose")

local S = { Stamina = true, Prompts = true, OrigStamina = nil, OrigPrompts = {}, AntiLag = false }

local ESPcfg = {
    Enabled = true,
    Cham = true, Name = false, Box = false,
    Tracer = false, Distance = false, Gun = false, Health = false,
    TeamColor = true, FriendsTag = true, NPC = false,
    EnemyColor  = Color3.fromRGB(255,60,60),
    TeamColorV  = Color3.fromRGB(60,200,60),
    FriendColor = Color3.fromRGB(80,160,255),
    NPCColor    = Color3.fromRGB(255,200,60),
    FillTransparency = 0.6, OutlineTransparency = 0.1,
    MaxDistance = 1000,
}
local Aimbot = {
    TeamCheck = true, WallCheck = true, FriendsCheck = true,
    FOV = 150, MaxDistance = 250, Smoothness = 0.28,
    PCEnabled = false, MobileEnabled = false,
    ShowFOV = true, TargetPart = "Head", NPCEnabled = false,
}
local SilentAim = {
    Enabled = false, NearestPart = false, HitChance = 100,
    FOV = 150, MaxDistance = 500,
    WallCheck = true, TeamCheck = true, FriendsCheck = true,
    ForceFieldCheck = false, ShowFOV = true, TargetPart = "Head",
    TargetEntities = { Player = true, Npc = false },
    TargetTeams = {}, IgnorePlayers = {}, Target = nil,
}

local Farm = {
    AutoClean = false, AutoDeposit = false,
    AntiAfk = true, DepositTarget = 50000,
    PuddleEarned = 0, TotalCryptoProfit = 0,
    UIRefs = {},
}
local CryptoTargets = {
    BTC  = { buyAt = 2000, sellAt = 8000, avgBuy = 0, lastPrice = 0 },
    ETH  = { buyAt = 500,  sellAt = 900,  avgBuy = 0, lastPrice = 0 },
    DOGE = { buyAt = 250,  sellAt = 500,  avgBuy = 0, lastPrice = 0 },
}
local AutoCrypto = { BTC = false, ETH = false, DOGE = false }

local UIState = {
    Keybind = Enum.KeyCode.H,
    SelectedTheme = "Rose",
    BackgroundID = "",
    SelectedBackground = "Main",
    ConfigName = "default",
    SelectedConfig = "--",
    AutoLoadConfig = "None",
    MobileButtonColor = Color3.fromRGB(139, 92, 246),
}
local UI_OPEN = false

local AntiLagSave = {}
local function enableAntiLag()
    AntiLagSave.Lighting = {
        GlobalShadows = Lighting.GlobalShadows, Brightness = Lighting.Brightness,
        FogEnd = Lighting.FogEnd, FogStart = Lighting.FogStart,
        Ambient = Lighting.Ambient, OutdoorAmbient = Lighting.OutdoorAmbient,
        ShadowSoftness = Lighting.ShadowSoftness,
    }
    AntiLagSave.Effects = {}
    for _, c in ipairs(Lighting:GetChildren()) do
        if c:IsA("PostEffect") or c:IsA("Atmosphere") or c:IsA("Sky") then
            table.insert(AntiLagSave.Effects, { obj = c, parent = c.Parent })
            c.Parent = nil
        end
    end
    Lighting.GlobalShadows = false; Lighting.Brightness = 2
    Lighting.FogEnd = 100000; Lighting.FogStart = 100000
    Lighting.Ambient = Color3.fromRGB(178,178,178)
    Lighting.OutdoorAmbient = Color3.fromRGB(178,178,178)
    pcall(function() settings().Rendering.QualityLevel = 1 end)
end
local function disableAntiLag()
    if AntiLagSave.Lighting then
        for k, v in pairs(AntiLagSave.Lighting) do pcall(function() Lighting[k] = v end) end
    end
    if AntiLagSave.Effects then
        for _, info in ipairs(AntiLagSave.Effects) do
            if info.obj then pcall(function() info.obj.Parent = info.parent or Lighting end) end
        end
    end
    pcall(function() settings().Rendering.QualityLevel = 10 end)
    AntiLagSave = {}
end

task.spawn(function()
    while task.wait(0.5) do
        local data = LocalPlayer:FindFirstChild("Data")
        local st = data and data:FindFirstChild("Stamina")
        if st and (st:IsA("NumberValue") or st:IsA("IntValue")) then
            if S.Stamina then
                if S.OrigStamina == nil then S.OrigStamina = st.Value end
                if st.Value ~= 100000 then st.Value = 100000 end
            elseif S.OrigStamina ~= nil and st.Value ~= S.OrigStamina then
                st.Value = S.OrigStamina
            end
        end
    end
end)
task.spawn(function()
    while task.wait(1) do
        if LocalPlayer:GetAttribute("__OwnsPermGuard") ~= true then
            LocalPlayer:SetAttribute("__OwnsPermGuard", true)
        end
        if LocalPlayer:GetAttribute("OwnsPolicePass") ~= true then
            LocalPlayer:SetAttribute("OwnsPolicePass", true)
        end
    end
end)

if getgenv().__SSLR_AntiAfk then pcall(function() getgenv().__SSLR_AntiAfk:Disconnect() end) end
getgenv().__SSLR_AntiAfk = LocalPlayer.Idled:Connect(function()
    if Farm.AntiAfk then
        pcall(function()
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new())
        end)
    end
end)

for _, p in pairs(WS:GetDescendants()) do
    if p:IsA("ProximityPrompt") then
        S.OrigPrompts[p] = p.HoldDuration
        if S.Prompts then p.HoldDuration = 0.05 end
    end
end
WS.DescendantAdded:Connect(function(p)
    if p:IsA("ProximityPrompt") then
        task.defer(function()
            S.OrigPrompts[p] = p.HoldDuration
            if S.Prompts then p.HoldDuration = 0.05 end
        end)
    end
end)
local function applyPromptState()
    for p, orig in pairs(S.OrigPrompts) do
        if p and p.Parent then p.HoldDuration = S.Prompts and 0.05 or orig end
    end
end

do
    local old = CoreGui:FindFirstChild("SSLR_ESP_Overlay"); if old then old:Destroy() end
    local oldP = PlayerGui:FindFirstChild("SSLR_ESP_Overlay"); if oldP then oldP:Destroy() end
    local oldW = WS:FindFirstChild("SSLR_ESP_World"); if oldW then oldW:Destroy() end
    if WS.CurrentCamera then
        local oldC = WS.CurrentCamera:FindFirstChild("SSLR_ESP_World")
        if oldC then oldC:Destroy() end
    end
end

local espGui = Instance.new("ScreenGui")
espGui.Name = "SSLR_ESP_Overlay"; espGui.ResetOnSpawn = false
espGui.IgnoreGuiInset = true
espGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
espGui.DisplayOrder = 10
pcall(function() espGui.Parent = CoreGui end)
if not espGui.Parent then espGui.Parent = PlayerGui end

local espWorld = Instance.new("Folder")
espWorld.Name = "SSLR_ESP_World"
pcall(function() espWorld.Parent = WS.CurrentCamera end)
if not espWorld.Parent then espWorld.Parent = WS end

local espCache, npcCache = {}, {}

local function destroyEsp(key)
    local c = espCache[key]; if not c then return end
    for _, k in ipairs({"Highlight","Box","Name","Distance","Gun","Health","Tracer"}) do
        if c[k] then c[k]:Destroy() end
    end
    espCache[key] = nil
end

local function getOrCreateEsp(key)
    if espCache[key] then return espCache[key] end
    local h = Instance.new("Highlight")
    h.Name = "SSLR_ESP_HL"
    h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    h.FillTransparency = 1; h.OutlineTransparency = 1
    h.Enabled = false; h.Parent = espWorld
    local box = Instance.new("Frame")
    box.BackgroundTransparency = 1; box.BorderSizePixel = 0
    box.Visible = false; box.ZIndex = 5; box.Parent = espGui
    local boxStroke = Instance.new("UIStroke")
    boxStroke.Thickness = 1.5; boxStroke.Transparency = 0; boxStroke.Parent = box
    local function mkLabel(font, size, color)
        local l = Instance.new("TextLabel")
        l.BackgroundTransparency = 1; l.Font = font; l.TextSize = size
        l.TextColor3 = color; l.TextStrokeTransparency = 0.2
        l.TextStrokeColor3 = Color3.new(0,0,0)
        l.Size = UDim2.new(0, 240, 0, size + 2)
        l.AnchorPoint = Vector2.new(0.5, 0)
        l.Visible = false; l.ZIndex = 10; l.Parent = espGui
        return l
    end
    local nameLbl = mkLabel(Enum.Font.GothamBold, 13, Color3.new(1,1,1))
    local distLbl = mkLabel(Enum.Font.Gotham, 11, Color3.fromRGB(220,220,220))
    local gunLbl  = mkLabel(Enum.Font.Gotham, 11, Color3.fromRGB(255,200,60))
    local hlthLbl = mkLabel(Enum.Font.GothamBold, 11, Color3.fromRGB(120,255,120))
    local tracer = Instance.new("Frame")
    tracer.BackgroundColor3 = Color3.new(1,1,1); tracer.BorderSizePixel = 0
    tracer.Size = UDim2.new(0,0,0,1.5)
    tracer.AnchorPoint = Vector2.new(0, 0.5)
    tracer.Visible = false; tracer.ZIndex = 4; tracer.Parent = espGui
    espCache[key] = {
        Highlight = h, Box = box, BoxStroke = boxStroke,
        Name = nameLbl, Distance = distLbl, Gun = gunLbl, Health = hlthLbl,
        Tracer = tracer,
    }
    return espCache[key]
end

local function espColorFor(key, isNPC)
    if isNPC then return ESPcfg.NPCColor end
    if typeof(key) == "Instance" and key:IsA("Player") then
        if ESPcfg.FriendsTag then
            local ok, fr = pcall(function() return LocalPlayer:IsFriendsWith(key.UserId) end)
            if ok and fr then return ESPcfg.FriendColor end
        end
        if ESPcfg.TeamColor and key.Team and LocalPlayer.Team
           and key.Team == LocalPlayer.Team then return ESPcfg.TeamColorV end
    end
    return ESPcfg.EnemyColor
end
local function hideEspElements(c)
    c.Highlight.Enabled = false; c.Box.Visible = false
    c.Name.Visible = false; c.Distance.Visible = false
    c.Gun.Visible = false; c.Health.Visible = false; c.Tracer.Visible = false
end
local function updateEspElement(key, char, isNPC, cam, vp)
    local c = espCache[key]; if not c then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not ESPcfg.Enabled or not hum or hum.Health <= 0
       or hum:GetState() == Enum.HumanoidStateType.Dead then
        hideEspElements(c); return
    end
    local ok, cf, sz = pcall(function()
        local c0, s0 = char:GetBoundingBox(); return c0, s0
    end)
    if not ok or not cf then hideEspElements(c) return end
    local topPos = cf.Position + Vector3.new(0, sz.Y/2, 0)
    local botPos = cf.Position - Vector3.new(0, sz.Y/2, 0)
    local topScreen, topOn = cam:WorldToViewportPoint(topPos)
    local botScreen, botOn = cam:WorldToViewportPoint(botPos)
    local dist = (cam.CFrame.Position - cf.Position).Magnitude
    if dist > ESPcfg.MaxDistance or not topOn or not botOn
       or topScreen.Z <= 0 or botScreen.Z <= 0 then
        hideEspElements(c); return
    end
    local color = espColorFor(key, isNPC)
    local hx, hy, fy = topScreen.X, topScreen.Y, botScreen.Y
    if ESPcfg.Cham then
        c.Highlight.Adornee = char
        c.Highlight.FillColor = color; c.Highlight.OutlineColor = color
        c.Highlight.FillTransparency = ESPcfg.FillTransparency
        c.Highlight.OutlineTransparency = ESPcfg.OutlineTransparency
        c.Highlight.Enabled = true
    else c.Highlight.Enabled = false end
    if ESPcfg.Box then
        local height = fy - hy
        if height > 4 then
            local width = height * 0.55
            c.Box.Position = UDim2.new(0, hx - width/2, 0, hy)
            c.Box.Size = UDim2.new(0, width, 0, height)
            c.BoxStroke.Color = color; c.Box.Visible = true
        else c.Box.Visible = false end
    else c.Box.Visible = false end
    if ESPcfg.Name then
        local txt = isNPC and ("[NPC] " .. char.Name) or key.Name
        if not isNPC and ESPcfg.FriendsTag then
            local okf, fr = pcall(function() return LocalPlayer:IsFriendsWith(key.UserId) end)
            if okf and fr then txt = "[Friend] " .. txt end
        end
        c.Name.Text = txt; c.Name.TextColor3 = color
        c.Name.Position = UDim2.new(0, hx, 0, hy - 16); c.Name.Visible = true
    else c.Name.Visible = false end
    if ESPcfg.Distance then
        c.Distance.Text = string.format("[%d m]", math.floor(dist))
        c.Distance.TextColor3 = color
        c.Distance.Position = UDim2.new(0, hx, 0, hy - 30); c.Distance.Visible = true
    else c.Distance.Visible = false end
    if ESPcfg.Gun then
        local tool = char:FindFirstChildOfClass("Tool")
        if tool then
            c.Gun.Text = tool.Name; c.Gun.TextColor3 = color
            c.Gun.Position = UDim2.new(0, hx, 0, fy + 2); c.Gun.Visible = true
        else c.Gun.Visible = false end
    else c.Gun.Visible = false end
    if ESPcfg.Health then
        local hpPct = math.clamp(hum.Health / math.max(hum.MaxHealth, 1), 0, 1)
        c.Health.Text = string.format("%d HP", math.floor(hum.Health))
        c.Health.TextColor3 = Color3.new(1 - hpPct, hpPct, 0.15)
        c.Health.Position = UDim2.new(0, hx, 0, fy + 16); c.Health.Visible = true
    else c.Health.Visible = false end
    if ESPcfg.Tracer then
        local ox, oy = vp.X/2, vp.Y
        local dx, dy = hx - ox, hy - oy
        local len = math.sqrt(dx*dx + dy*dy)
        if len > 3 then
            c.Tracer.Position = UDim2.new(0, ox, 0, oy)
            c.Tracer.Size = UDim2.new(0, len, 0, 1.5)
            c.Tracer.Rotation = math.deg(math.atan2(dy, dx))
            c.Tracer.BackgroundColor3 = color; c.Tracer.Visible = true
        else c.Tracer.Visible = false end
    else c.Tracer.Visible = false end
end
RunService.RenderStepped:Connect(function()
    local cam = WS.CurrentCamera; if not cam then return end
    local vp = cam.ViewportSize
    local seen = {}
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character then
            seen[plr] = true
            getOrCreateEsp(plr)
            updateEspElement(plr, plr.Character, false, cam, vp)
        end
    end
    if ESPcfg.NPC then
        for _, m in ipairs(npcCache) do
            if m.Parent then
                seen[m] = true
                getOrCreateEsp(m)
                updateEspElement(m, m, true, cam, vp)
            end
        end
    end
    for k in pairs(espCache) do if not seen[k] then destroyEsp(k) end end
end)

local function scanNPCs()
    local list = {}
    for _, obj in ipairs(WS:GetDescendants()) do
        if obj:IsA("Humanoid") and obj.Health > 0
           and obj:GetState() ~= Enum.HumanoidStateType.Dead then
            local model = obj.Parent
            if model and model:IsA("Model")
               and model ~= LocalPlayer.Character
               and not Players:GetPlayerFromCharacter(model) then
                table.insert(list, model)
            end
        end
    end
    return list
end
task.spawn(function()
    while task.wait(2) do
        if ESPcfg.NPC or Aimbot.NPCEnabled or SilentAim.TargetEntities.Npc then
            local ok, res = pcall(scanNPCs)
            if ok then npcCache = res end
        else npcCache = {} end
    end
end)

local RemotesFolder = RS:FindFirstChild("Remotes")
local function findRemote(name)
    if RemotesFolder then
        local d = RemotesFolder:FindFirstChild(name)
        if d and (d:IsA("RemoteEvent") or d:IsA("RemoteFunction")) then return d end
    end
    for _, obj in ipairs(RS:GetDescendants()) do
        if obj.Name == name and (obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction")) then
            return obj
        end
    end
    return nil
end
local GunBuyRemote  = findRemote("GunBuy")
local BuyRemote     = findRemote("Buy")
local ATmRemote     = findRemote("ATM") or findRemote("BankAction") or findRemote("Bank")
local PhoneRemote   = findRemote("Phone")
local StorageRemote = findRemote("Storage") or findRemote("Safe")

local function fireRemote(remote, ...)
    if not remote then return false end
    local args = { ... }
    if remote:IsA("RemoteFunction") then
        return pcall(function() remote:InvokeServer(unpack(args)) end)
    end
    return pcall(function() remote:FireServer(unpack(args)) end)
end
local function buyGun(n, p) fireRemote(GunBuyRemote, n, p) end
local function buyStuff(n, p) fireRemote(BuyRemote, n, p) end
local function atmDeposit(a)
    a = tonumber(a); if not a or a <= 0 then return end
    fireRemote(ATmRemote, "Deposit", a)
end
local function atmWithdraw(a)
    a = tonumber(a); if not a or a <= 0 then return end
    fireRemote(ATmRemote, "Withdraw", a)
end
local function storageDeposit(i) fireRemote(StorageRemote, "Deposit", i) end
local function storageWithdraw(i) fireRemote(StorageRemote, "Grab", i) end
local function sendMoney(tp, amount)
    if not PhoneRemote or not tp then return end
    local amt = math.clamp(tonumber(amount) or 0, 1, 100000)
    fireRemote(PhoneRemote, "SendMoney", tp.Name, amt)
end

local function cmd(text)
    local r = RS:FindFirstChild("Remotes")
    local cr = r and r:FindFirstChild("ControllerRemote")
    if cr then pcall(function() cr:FireServer(text) end) end
end
local function revert(gun)
    local r = RS:FindFirstChild("Remotes")
    local rr = r and r:FindFirstChild("RevertSpawn")
    if rr then pcall(function() rr:FireServer(gun) end) end
end
local function spawnNamed(name)
    local r = RS:FindFirstChild("Remotes")
    local cr = r and r:FindFirstChild("ControllerRemote")
    if cr then pcall(function() cr:FireServer("/sg " .. name, "Spawn") end) end
end
local function doGive()
    local r = RS:FindFirstChild("Remotes")
    local handTo = r and r:FindFirstChild("HandTo"); if not handTo then return end
    local char = LocalPlayer.Character; if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    local hum  = char:FindFirstChildOfClass("Humanoid")
    local tool = char:FindFirstChildOfClass("Tool")
    if not root or not hum or not tool then return end
    local hit = WS:FindPartOnRay(Ray.new(root.Position, root.CFrame.LookVector*60), char)
    if not hit then return end
    local target = hit.Parent
    if not target:FindFirstChild("Humanoid") then target = hit.Parent.Parent end
    if not target or not target:FindFirstChild("Humanoid") then return end
    local tRoot = target:FindFirstChild("HumanoidRootPart"); if not tRoot then return end
    if (root.Position - tRoot.Position).Magnitude >= 7 then return end
    hum:UnequipTools(); task.wait(0.25)
    handTo:FireServer(target, LocalPlayer, tool)
end

local function getMapFolders()
    local map = WS:FindFirstChild("Map")
    if not map then return nil, nil end
    local jobs = map:FindFirstChild("Jobs")
    local cleanNpc = jobs and jobs:FindFirstChild("CleanNPC")
    local cleanFolder = cleanNpc and cleanNpc:FindFirstChild("Clean")
    local atmsFolder = map:FindFirstChild("ATMs")
    return cleanFolder, atmsFolder
end

local function walkTo(targetPosition)
    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not (hum and hrp and hum.Health > 0) then return false end
    local path = PathfindingService:CreatePath({AgentRadius=2, AgentHeight=5, AgentCanJump=true})
    local ok = pcall(function() path:ComputeAsync(hrp.Position, targetPosition) end)
    if not ok or path.Status ~= Enum.PathStatus.Success then return false end
    for _, wp in ipairs(path:GetWaypoints()) do
        if hum.Health <= 0 or not LocalPlayer.Character then return false end
        hum:MoveTo(wp.Position)
        local t = 0
        while t < 20 and (hrp.Position - wp.Position).Magnitude > 4 do
            if hum.Health <= 0 then return false end
            task.wait(0.1); t = t + 1
        end
    end
    return true
end

local function firePrompt(prompt)
    if not prompt then return false end
    local ok = pcall(function() fireproximityprompt(prompt) end)
    if ok then return true end
    pcall(function()
        prompt:InputHoldBegin(); task.wait(0.1); prompt:InputHoldEnd()
    end)
    return false
end

local function getClosestPuddle()
    local cleanFolder = getMapFolders()
    if not cleanFolder then return nil end
    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil end
    local closest, shortestDist = nil, math.huge
    for _, v in pairs(cleanFolder:GetChildren()) do
        if v:IsA("BasePart") then
            local prompt = v:FindFirstChildOfClass("ProximityPrompt")
            if prompt and prompt.Enabled then
                local dist = (hrp.Position - v.Position).Magnitude
                if dist < shortestDist then shortestDist = dist; closest = v end
            end
        end
    end
    return closest
end

local function getClosestATM()
    local _, atmsFolder = getMapFolders()
    if not atmsFolder then return nil end
    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil end
    local closest, shortestDist = nil, math.huge
    for _, atm in pairs(atmsFolder:GetChildren()) do
        if atm.Name == "ATM" then
            local build = atm:FindFirstChild("ATM Build")
            local funcPart = build and build:FindFirstChild("Func")
            if funcPart then
                local dist = (hrp.Position - funcPart.Position).Magnitude
                if dist < shortestDist then shortestDist = dist; closest = funcPart end
            end
        end
    end
    return closest
end

local function getMoneyValue()
    local data = LocalPlayer:FindFirstChild("Data")
    if not data then return 0 end
    local m = data:FindFirstChild("Money") or data:FindFirstChild("Cash")
    return m and m.Value or 0
end

local function performDeposit(forceAll)
    local currentMoney = getMoneyValue()
    local amountToDeposit = forceAll and currentMoney or Farm.DepositTarget
    if currentMoney < amountToDeposit or amountToDeposit <= 0 then return false end
    local r = RS:FindFirstChild("Remotes")
    local atmRemote = (r and r:FindFirstChild("ATM")) or ATmRemote
    if atmRemote then
        local ok = pcall(function() atmRemote:FireServer("Deposit", amountToDeposit) end)
        if ok then return true end
    end
    local atmPart = getClosestATM()
    if not atmPart then return false end
    if not walkTo(atmPart.Position) then return false end
    task.wait(0.5)
    if atmRemote then
        pcall(function() atmRemote:FireServer("Deposit", amountToDeposit) end)
    end
    return true
end

local function getPhoneMisc()
    return RS:FindFirstChild("Misc") and RS.Misc:FindFirstChild("Phone")
end
local function getCryptoPriceObj(coin)
    local pm = getPhoneMisc(); if not pm then return nil end
    if coin == "BTC" then return pm:FindFirstChild("Crypto") or pm:FindFirstChild("BTC") end
    return pm:FindFirstChild(coin)
end
local function getCryptoHoldingObj(coin)
    local data = LocalPlayer:FindFirstChild("Data"); if not data then return nil end
    if coin == "BTC" then return data:FindFirstChild("Crypto") or data:FindFirstChild("BTC") end
    return data:FindFirstChild(coin)
end
local function getRemoteKey(coin)
    if coin == "BTC" then return "Crypto" end
    return coin
end
local function fireCryptoRemote(coin, action, price)
    if not PhoneRemote then return false end
    return pcall(function()
        PhoneRemote:FireServer(getRemoteKey(coin), action, price)
    end)
end

local function handleCryptoCoin(coin)
    local cfg = CryptoTargets[coin]; if not cfg then return end
    local priceObj = getCryptoPriceObj(coin)
    local holdObj  = getCryptoHoldingObj(coin)
    local bankObj  = LocalPlayer:FindFirstChild("Data") and LocalPlayer.Data:FindFirstChild("Bank")
    if not (priceObj and holdObj) then return end
    local price = priceObj.Value
    local owned = holdObj.Value
    local bank  = bankObj and bankObj.Value or 0

    local refs = Farm.UIRefs
    if refs[coin .. "_price"] then refs[coin .. "_price"].Text = coin .. ": $" .. tostring(price) end
    if refs[coin .. "_wallet"] then refs[coin .. "_wallet"].Text = "Wallet: " .. tostring(owned) .. " " .. coin end

    if price == cfg.lastPrice then return end
    cfg.lastPrice = price

    if owned > 0 and cfg.avgBuy == 0 then cfg.avgBuy = price
    elseif owned == 0 then cfg.avgBuy = 0 end

    if not AutoCrypto[coin] then return end

    if price <= cfg.buyAt and bank >= price and owned < 100 then
        local maxAfford = math.floor(bank / price)
        local space = 100 - owned
        local amount = math.min(maxAfford, space)
        if amount > 0 then
            for _ = 1, amount do fireCryptoRemote(coin, "Purchase", price); task.wait(0.1) end
            if owned == 0 then cfg.avgBuy = price
            else cfg.avgBuy = ((cfg.avgBuy * owned) + (price * amount)) / (owned + amount) end
        end
    end

    if owned > 0 and price >= cfg.sellAt then
        local profit = (price - (cfg.avgBuy > 0 and cfg.avgBuy or price)) * owned
        Farm.TotalCryptoProfit = Farm.TotalCryptoProfit + math.max(profit, 0)
        for _ = 1, owned do fireCryptoRemote(coin, "Sell", price); task.wait(0.1) end
        cfg.avgBuy = 0
    end
end

local function forceSellCoin(coin)
    local priceObj = getCryptoPriceObj(coin)
    local holdObj  = getCryptoHoldingObj(coin)
    if not (priceObj and holdObj) then return end
    local price, owned = priceObj.Value, holdObj.Value
    if owned <= 0 then return end
    for _ = 1, owned do fireCryptoRemote(coin, "Sell", price); task.wait(0.1) end
end

task.spawn(function()
    while task.wait(0.5) do
        pcall(function()
            handleCryptoCoin("BTC"); handleCryptoCoin("ETH"); handleCryptoCoin("DOGE")
        end)

        local refs = Farm.UIRefs
        if refs.cryptoProfit then refs.cryptoProfit.Text = "Crypto Profit: $" .. tostring(math.floor(Farm.TotalCryptoProfit)) end
        if refs.puddleEarned then refs.puddleEarned.Text = "Puddle Earned: $" .. tostring(math.floor(Farm.PuddleEarned)) end

        local char = LocalPlayer.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        local hrp = char and char:FindFirstChild("HumanoidRootPart")

        if hum and hrp and hum.Health > 0 then
            local currentMoney = getMoneyValue()
            if Farm.AutoDeposit and currentMoney >= Farm.DepositTarget then
                pcall(performDeposit, false); task.wait(1)
            elseif Farm.AutoClean then
                local targetPuddle = getClosestPuddle()
                if targetPuddle then
                    local before = getMoneyValue()
                    local reached = walkTo(targetPuddle.Position)
                    if reached then
                        task.wait(0.5)
                        local prompt = targetPuddle:FindFirstChildOfClass("ProximityPrompt")
                        if prompt and prompt.Enabled then
                            firePrompt(prompt)
                            local timeout = 0
                            while targetPuddle.Parent and prompt.Enabled and timeout < 40 do
                                if hum.Health <= 0 then break end
                                task.wait(0.25); timeout = timeout + 1
                                if timeout % 4 == 0 then firePrompt(prompt) end
                            end
                            task.wait(0.5)
                            local after = getMoneyValue()
                            local earned = after - before
                            if earned > 0 then Farm.PuddleEarned = Farm.PuddleEarned + earned end
                        end
                    end
                end
            end
        end
    end
end)

local function isSameTeam(plr)
    if not Aimbot.TeamCheck then return false end
    if not plr.Team or not LocalPlayer.Team then return false end
    return plr.Team == LocalPlayer.Team
end
local function isFriend(plr)
    if not Aimbot.FriendsCheck then return false end
    local ok, r = pcall(function() return LocalPlayer:IsFriendsWith(plr.UserId) end)
    return ok and r
end
local function isWallBetween(fromPos, toPos, targetChar)
    local p = RaycastParams.new()
    p.FilterType = Enum.RaycastFilterType.Exclude
    p.FilterDescendantsInstances = { LocalPlayer.Character }
    p.IgnoreWater = true
    local r = WS:Raycast(fromPos, toPos - fromPos, p)
    if not r then return false end
    if r.Instance:IsDescendantOf(targetChar) then return false end
    return true
end
local function getTargetPart(char)
    local mode = Aimbot.TargetPart
    if mode == "Head" then return char:FindFirstChild("Head") or char:FindFirstChild("HumanoidRootPart")
    elseif mode == "Torso" then return char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso") or char:FindFirstChild("HumanoidRootPart")
    else
        if math.random() < 0.7 then return char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso") or char:FindFirstChild("HumanoidRootPart") end
        return char:FindFirstChild("Head") or char:FindFirstChild("HumanoidRootPart")
    end
end
local function findAimbotTarget()
    local camera = WS.CurrentCamera; if not camera then return nil end
    local vp = camera.ViewportSize
    local center = Vector2.new(vp.X/2, vp.Y/2)
    local origin = camera.CFrame.Position
    local bestTarget, bestDist = nil, math.huge
    local function consider(char)
        if not char or not char.Parent then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hum or hum.Health <= 0 or hum:GetState() == Enum.HumanoidStateType.Dead then return end
        local part = getTargetPart(char); if not part then return end
        local d = (origin - part.Position).Magnitude
        if d > Aimbot.MaxDistance then return end
        local sp, on = camera:WorldToViewportPoint(part.Position)
        if not on or sp.Z <= 0 then return end
        local pix = (Vector2.new(sp.X, sp.Y) - center).Magnitude
        if pix > Aimbot.FOV then return end
        if Aimbot.WallCheck and isWallBetween(origin, part.Position, char) then return end
        if pix < bestDist then bestDist = pix; bestTarget = part end
    end
    for _, plr in pairs(Players:GetPlayers()) do
        if plr == LocalPlayer then continue end
        if isSameTeam(plr) then continue end
        if isFriend(plr) then continue end
        consider(plr.Character)
    end
    if Aimbot.NPCEnabled then
        for _, npc in ipairs(npcCache) do consider(npc) end
    end
    return bestTarget
end
local function aimAt(target)
    local camera = WS.CurrentCamera
    if not camera or not target then return end
    local desired = CFrame.new(camera.CFrame.Position, target.Position)
    camera.CFrame = camera.CFrame:Lerp(desired, 1 - math.clamp(Aimbot.Smoothness, 0, 1))
end
RunService:BindToRenderStep("SSLR_Aimbot", Enum.RenderPriority.Camera.Value + 1, function()
    if Aimbot.PCEnabled or Aimbot.MobileEnabled then
        local t = findAimbotTarget(); if t then aimAt(t) end
    end
end)

local function siIsIgnored(name)
    for _, n in ipairs(SilentAim.IgnorePlayers) do if n == name then return true end end
    return false
end
local function siIsTargetTeam(plr)
    if #SilentAim.TargetTeams == 0 then return true end
    if not plr.Team then return false end
    for _, n in ipairs(SilentAim.TargetTeams) do if n == plr.Team.Name then return true end end
    return false
end
local function siGetPart(char, nearest, camera, center)
    if nearest or SilentAim.TargetPart == "Random" then
        local parts = {}
        for _, n in ipairs({ "Head","HumanoidRootPart","UpperTorso","LowerTorso","Torso","RightArm","LeftArm","RightLeg","LeftLeg" }) do
            local p = char:FindFirstChild(n); if p then table.insert(parts, p) end
        end
        if #parts == 0 then return nil end
        if nearest then
            local best, bd = nil, math.huge
            for _, p in ipairs(parts) do
                local sp, on = camera:WorldToViewportPoint(p.Position)
                if on then local d = (center - Vector2.new(sp.X, sp.Y)).Magnitude; if d < bd then bd = d; best = p end end
            end
            return best
        end
        return parts[math.random(1, #parts)]
    end
    local p = char:FindFirstChild(SilentAim.TargetPart)
    return p or char:FindFirstChild("HumanoidRootPart")
end
local function siFindTarget(nearest)
    local camera = WS.CurrentCamera; if not camera then return nil end
    local vp = camera.ViewportSize
    local center = Vector2.new(vp.X/2, vp.Y/2)
    local origin = camera.CFrame.Position
    local candidates = {}
    if SilentAim.TargetEntities.Player then
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr == LocalPlayer then continue end
            if SilentAim.TeamCheck and plr.Team and LocalPlayer.Team and plr.Team == LocalPlayer.Team then continue end
            if SilentAim.FriendsCheck then
                local ok, fr = pcall(function() return LocalPlayer:IsFriendsWith(plr.UserId) end)
                if ok and fr then continue end
            end
            if siIsIgnored(plr.Name) then continue end
            if not siIsTargetTeam(plr) then continue end
            if plr.Character then table.insert(candidates, plr.Character) end
        end
    end
    if SilentAim.TargetEntities.Npc then
        for _, npc in ipairs(npcCache) do table.insert(candidates, npc) end
    end
    local best, bd = nil, math.huge
    for _, char in ipairs(candidates) do
        if SilentAim.ForceFieldCheck and char:FindFirstChildOfClass("ForceField") then continue end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hum or hum.Health <= 0 or hum:GetState() == Enum.HumanoidStateType.Dead then continue end
        local part = siGetPart(char, nearest, camera, center); if not part then continue end
        local d = (origin - part.Position).Magnitude
        if d > SilentAim.MaxDistance then continue end
        local sp, on = camera:WorldToViewportPoint(part.Position)
        if not on or sp.Z <= 0 then continue end
        local pix = (Vector2.new(sp.X, sp.Y) - center).Magnitude
        if pix > SilentAim.FOV then continue end
        if SilentAim.WallCheck then
            local p = RaycastParams.new()
            p.FilterType = Enum.RaycastFilterType.Exclude
            p.FilterDescendantsInstances = { LocalPlayer.Character, char }
            p.IgnoreWater = true
            local hit = WS:Raycast(origin, part.Position - origin, p)
            if hit and not hit.Instance:IsDescendantOf(char) then continue end
        end
        if pix < bd then bd = pix; best = part end
    end
    return best
end
RunService.Heartbeat:Connect(function()
    if SilentAim.Enabled then
        local ok, t = pcall(siFindTarget, SilentAim.NearestPart)
        SilentAim.Target = ok and t or nil
    else SilentAim.Target = nil end
end)
pcall(function()
    local oldNamecall
    oldNamecall = hookmetamethod(game, "__namecall", newcclosure(function(...)
        local method = getnamecallmethod()
        local args = { ... }
        if SilentAim.Enabled and not checkcaller() and method == "Raycast" and args[1] == WS
           and SilentAim.Target and SilentAim.Target.Parent then
            if math.random(1, 100) <= SilentAim.HitChance then
                local origin = args[2]
                args[3] = (SilentAim.Target.Position - origin).Unit * 1000
                return oldNamecall(unpack(args))
            end
        end
        return oldNamecall(...)
    end))
end)

do
    local old = CoreGui:FindFirstChild("SSLR_SilentFOV"); if old then old:Destroy() end
    local oldP = PlayerGui:FindFirstChild("SSLR_SilentFOV"); if oldP then oldP:Destroy() end
end
local siGui = Instance.new("ScreenGui")
siGui.Name = "SSLR_SilentFOV"; siGui.ResetOnSpawn = false
siGui.IgnoreGuiInset = true
siGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
siGui.DisplayOrder = 2147483645
pcall(function() siGui.Parent = CoreGui end)
if not siGui.Parent then siGui.Parent = PlayerGui end
local siCircle = Instance.new("Frame")
siCircle.AnchorPoint = Vector2.new(0.5, 0.5)
siCircle.Position = UDim2.new(0.5, 0, 0.5, 0)
siCircle.Size = UDim2.new(0, SilentAim.FOV*2, 0, SilentAim.FOV*2)
siCircle.BackgroundTransparency = 1; siCircle.BorderSizePixel = 0
siCircle.ZIndex = 99998; siCircle.Visible = false; siCircle.Parent = siGui
local siCorner = Instance.new("UICorner"); siCorner.CornerRadius = UDim.new(1,0); siCorner.Parent = siCircle
local siStroke = Instance.new("UIStroke")
siStroke.Color = Color3.fromRGB(255,80,80); siStroke.Thickness = 2
siStroke.Transparency = 0.1; siStroke.Parent = siCircle
local function refreshSilentFOV()
    siCircle.Size = UDim2.new(0, SilentAim.FOV*2, 0, SilentAim.FOV*2)
    siCircle.Visible = SilentAim.Enabled and SilentAim.ShowFOV
end
refreshSilentFOV()

do
    local old = CoreGui:FindFirstChild("SSLR_FOV"); if old then old:Destroy() end
    local oldP = PlayerGui:FindFirstChild("SSLR_FOV"); if oldP then oldP:Destroy() end
end
local fovGui = Instance.new("ScreenGui")
fovGui.Name = "SSLR_FOV"; fovGui.ResetOnSpawn = false
fovGui.IgnoreGuiInset = true
fovGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
fovGui.DisplayOrder = 2147483647
pcall(function() fovGui.Parent = CoreGui end)
if not fovGui.Parent then fovGui.Parent = PlayerGui end
local fovCircle = Instance.new("Frame")
fovCircle.AnchorPoint = Vector2.new(0.5, 0.5)
fovCircle.Position = UDim2.new(0.5, 0, 0.5, 0)
fovCircle.Size = UDim2.new(0, Aimbot.FOV*2, 0, Aimbot.FOV*2)
fovCircle.BackgroundTransparency = 1; fovCircle.BorderSizePixel = 0
fovCircle.Visible = false; fovCircle.ZIndex = 99999; fovCircle.Parent = fovGui
local fovCorner = Instance.new("UICorner"); fovCorner.CornerRadius = UDim.new(1,0); fovCorner.Parent = fovCircle
local fovStroke = Instance.new("UIStroke")
fovStroke.Color = Color3.fromRGB(255,255,255); fovStroke.Thickness = 2; fovStroke.Parent = fovCircle
local function refreshFOVCircle()
    fovCircle.Size = UDim2.new(0, Aimbot.FOV*2, 0, Aimbot.FOV*2)
    fovCircle.Visible = (Aimbot.PCEnabled or Aimbot.MobileEnabled) and Aimbot.ShowFOV
end
refreshFOVCircle()

do
    local old = CoreGui:FindFirstChild("SSLRUI"); if old then old:Destroy() end
    local oldP = PlayerGui:FindFirstChild("SSLRUI"); if oldP then oldP:Destroy() end
end
local gui = Instance.new("ScreenGui")
gui.Name = "SSLRUI"; gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.IgnoreGuiInset = true; gui.DisplayOrder = 50
pcall(function() gui.Parent = CoreGui end)
if not gui.Parent then gui.Parent = PlayerGui end

local DEFAULT_W = isMobile and 500 or 680
local DEFAULT_H = isMobile and 340 or 460
local win = Instance.new("Frame")
win.Name = "Window"; win.AnchorPoint = Vector2.new(0.5, 0.5)
win.Position = UDim2.new(0.5, 0, 0.5, 0)
win.Size = UDim2.new(0, DEFAULT_W, 0, DEFAULT_H)
win.BackgroundColor3 = T.bg; win.BackgroundTransparency = 0.7
win.BorderSizePixel = 0; win.Active = true
win.ClipsDescendants = true; win.Visible = false; win.Parent = gui
local winCorner = Instance.new("UICorner"); winCorner.CornerRadius = UDim.new(0,10); winCorner.Parent = win
local winBorder = Instance.new("UIStroke")
winBorder.Color = T.border; winBorder.Thickness = 1
winBorder.Transparency = 0.5; winBorder.Parent = win

local galaxy = Instance.new("Frame")
galaxy.Size = UDim2.new(1,0,1,0)
galaxy.BackgroundColor3 = Color3.fromRGB(5,5,10)
galaxy.BackgroundTransparency = 0.85; galaxy.BorderSizePixel = 0
galaxy.ZIndex = 0; galaxy.ClipsDescendants = true; galaxy.Parent = win
local galaxyCorner = Instance.new("UICorner"); galaxyCorner.CornerRadius = UDim.new(0,10); galaxyCorner.Parent = galaxy
local nebulas, stars = {}, {}
for i = 1, 3 do
    local neb = Instance.new("Frame")
    local size = math.random(220, 380)
    neb.Size = UDim2.new(0, size, 0, size)
    neb.Position = UDim2.new(math.random()*0.6, 0, math.random()*0.6, 0)
    neb.BackgroundColor3 = i == 1 and Color3.fromRGB(120,0,90)
        or i == 2 and Color3.fromRGB(80,0,120) or Color3.fromRGB(60,0,40)
    neb.BackgroundTransparency = 0.95; neb.BorderSizePixel = 0
    neb.ZIndex = 1; neb.Parent = galaxy
    local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(1,0); c.Parent = neb
    table.insert(nebulas, { frame = neb, speedX = (math.random()-0.5)*0.03, speedY = (math.random()-0.5)*0.03 })
end
for i = 1, 60 do
    local s = Instance.new("Frame")
    local sz = math.random(2, 4)
    s.Size = UDim2.new(0, sz, 0, sz)
    s.Position = UDim2.new(math.random(), 0, math.random(), 0)
    s.BackgroundColor3 = Color3.new(1,1,1)
    s.BackgroundTransparency = math.random(30, 80) / 100
    s.BorderSizePixel = 0; s.ZIndex = 2; s.Parent = galaxy
    local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(1,0); c.Parent = s
    table.insert(stars, { frame = s, speed = math.random(15, 40) / 12000, phase = math.random()*math.pi*2 })
end
RunService.RenderStepped:Connect(function(dt)
    if not UI_OPEN then return end
    for _, s in ipairs(stars) do
        if s.frame and s.frame.Parent then
            local y = s.frame.Position.Y.Scale + s.speed*dt*60
            if y > 1 then y = 0 end
            s.frame.Position = UDim2.new(s.frame.Position.X.Scale, 0, y, 0)
            s.phase = s.phase + dt*2
            s.frame.BackgroundTransparency = 0.3 + ((math.sin(s.phase)+1)/2)*0.5
        end
    end
    for _, n in ipairs(nebulas) do
        if n.frame and n.frame.Parent then
            local nx = n.frame.Position.X.Scale + n.speedX*dt
            local ny = n.frame.Position.Y.Scale + n.speedY*dt
            if nx < -0.3 or nx > 0.9 then n.speedX = -n.speedX end
            if ny < -0.3 or ny > 0.9 then n.speedY = -n.speedY end
            n.frame.Position = UDim2.new(nx, 0, ny, 0)
        end
    end
end)

local header = Instance.new("Frame")
header.Size = UDim2.new(1,0,0,42)
header.BackgroundColor3 = T.panel; header.BackgroundTransparency = 0.5
header.BorderSizePixel = 0; header.Active = true; header.ZIndex = 5; header.Parent = win
local headerCorner = Instance.new("UICorner"); headerCorner.CornerRadius = UDim.new(0,10); headerCorner.Parent = header
local headerCover = Instance.new("Frame")
headerCover.Size = UDim2.new(1,0,0,8); headerCover.Position = UDim2.new(0,0,1,-8)
headerCover.BackgroundColor3 = T.panel; headerCover.BackgroundTransparency = 0.5
headerCover.BorderSizePixel = 0; headerCover.ZIndex = 6; headerCover.Parent = header
local title = Instance.new("TextLabel")
title.Text = "SSLR"; title.Size = UDim2.new(0,100,0,24)
title.Position = UDim2.new(0,16,0,9)
title.BackgroundTransparency = 1; title.TextColor3 = T.text
title.Font = Enum.Font.GothamBold; title.TextSize = 16
title.TextXAlignment = Enum.TextXAlignment.Left; title.ZIndex = 7; title.Parent = header
local subtitle = Instance.new("TextLabel")
subtitle.Text = "v1.8.1"; subtitle.Size = UDim2.new(0,60,0,24)
subtitle.Position = UDim2.new(0,78,0,9)
subtitle.BackgroundTransparency = 1; subtitle.TextColor3 = T.textDim
subtitle.Font = Enum.Font.Gotham; subtitle.TextSize = 12
subtitle.TextXAlignment = Enum.TextXAlignment.Left; subtitle.ZIndex = 7; subtitle.Parent = header
local minBtn = Instance.new("TextButton")
minBtn.Text = "—"; minBtn.Size = UDim2.new(0,28,0,28)
minBtn.Position = UDim2.new(1,-70,0,7)
minBtn.BackgroundColor3 = T.elem; minBtn.TextColor3 = T.text
minBtn.Font = Enum.Font.GothamBold; minBtn.TextSize = 14
minBtn.AutoButtonColor = false; minBtn.ZIndex = 7; minBtn.Parent = header
local minCorner = Instance.new("UICorner"); minCorner.CornerRadius = UDim.new(0,6); minCorner.Parent = minBtn
local closeBtn = Instance.new("TextButton")
closeBtn.Text = "✕"; closeBtn.Size = UDim2.new(0,28,0,28)
closeBtn.Position = UDim2.new(1,-36,0,7)
closeBtn.BackgroundColor3 = T.elem; closeBtn.TextColor3 = T.text
closeBtn.Font = Enum.Font.GothamBold; closeBtn.TextSize = 12
closeBtn.AutoButtonColor = false; closeBtn.ZIndex = 7; closeBtn.Parent = header
local closeCorner = Instance.new("UICorner"); closeCorner.CornerRadius = UDim.new(0,6); closeCorner.Parent = closeBtn

local sidebar = Instance.new("Frame")
sidebar.Size = UDim2.new(0,150,1,-100); sidebar.Position = UDim2.new(0,8,0,50)
sidebar.BackgroundColor3 = T.sidebar; sidebar.BackgroundTransparency = 0.6
sidebar.BorderSizePixel = 0; sidebar.ZIndex = 5; sidebar.Parent = win
local sideCorner = Instance.new("UICorner"); sideCorner.CornerRadius = UDim.new(0,8); sideCorner.Parent = sidebar
local sideLayout = Instance.new("UIListLayout")
sideLayout.Padding = UDim.new(0,4)
sideLayout.SortOrder = Enum.SortOrder.LayoutOrder
sideLayout.Parent = sidebar
local sidePad = Instance.new("UIPadding")
sidePad.PaddingTop = UDim.new(0,8); sidePad.PaddingLeft = UDim.new(0,6)
sidePad.PaddingRight = UDim.new(0,6); sidePad.Parent = sidebar

local userFooter = Instance.new("Frame")
userFooter.Size = UDim2.new(0,150,0,44)
userFooter.Position = UDim2.new(0,8,1,-48)
userFooter.BackgroundColor3 = T.sidebar; userFooter.BackgroundTransparency = 0.3
userFooter.BorderSizePixel = 0; userFooter.ZIndex = 8; userFooter.Parent = win
local ufCorner = Instance.new("UICorner"); ufCorner.CornerRadius = UDim.new(0,8); ufCorner.Parent = userFooter
local ufStroke = Instance.new("UIStroke"); ufStroke.Color = T.accent; ufStroke.Thickness = 1; ufStroke.Transparency = 0.5; ufStroke.Parent = userFooter

local ufAvatar = Instance.new("ImageLabel")
ufAvatar.Size = UDim2.new(0,30,0,30)
ufAvatar.Position = UDim2.new(0,7,0.5,-15)
ufAvatar.BackgroundColor3 = T.elem
ufAvatar.BorderSizePixel = 0; ufAvatar.ZIndex = 9; ufAvatar.Parent = userFooter
local ufAvatarCorner = Instance.new("UICorner"); ufAvatarCorner.CornerRadius = UDim.new(1,0); ufAvatarCorner.Parent = ufAvatar
pcall(function()
    ufAvatar.Image = Players:GetUserThumbnailAsync(LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100)
end)

local ufName = Instance.new("TextLabel")
ufName.Text = LocalPlayer.DisplayName or LocalPlayer.Name
ufName.Size = UDim2.new(1,-46,0,16)
ufName.Position = UDim2.new(0,42,0,6)
ufName.BackgroundTransparency = 1
ufName.TextColor3 = T.text
ufName.Font = Enum.Font.GothamBold; ufName.TextSize = 11
ufName.TextXAlignment = Enum.TextXAlignment.Left
ufName.TextTruncate = Enum.TextTruncate.AtEnd
ufName.ZIndex = 9; ufName.Parent = userFooter

local ufSub = Instance.new("TextLabel")
ufSub.Text = "@" .. LocalPlayer.Name
ufSub.Size = UDim2.new(1,-46,0,14)
ufSub.Position = UDim2.new(0,42,0,22)
ufSub.BackgroundTransparency = 1
ufSub.TextColor3 = T.textDim
ufSub.Font = Enum.Font.Gotham; ufSub.TextSize = 10
ufSub.TextXAlignment = Enum.TextXAlignment.Left
ufSub.TextTruncate = Enum.TextTruncate.AtEnd
ufSub.ZIndex = 9; ufSub.Parent = userFooter

local content = Instance.new("Frame")
content.Size = UDim2.new(1,-166,1,-100); content.Position = UDim2.new(0,158,0,50)
content.BackgroundTransparency = 1; content.ZIndex = 5; content.Parent = win

local tabs, activeTab = {}, nil
local function switchTab(name)
    for n, t in pairs(tabs) do
        if n == name then
            t.frame.Visible = true
            t.btn.BackgroundColor3 = T.elem; t.btn.TextColor3 = T.text
            t.bar.BackgroundColor3 = T.accent
        else
            t.frame.Visible = false
            t.btn.BackgroundColor3 = T.sidebar; t.btn.TextColor3 = T.textDim
            t.bar.BackgroundColor3 = T.sidebar
        end
    end
    activeTab = name
end
local function newTab(name)
    local btn = Instance.new("TextButton")
    btn.Text = "   " .. name; btn.Size = UDim2.new(1,0,0,32)
    btn.BackgroundColor3 = T.sidebar; btn.BackgroundTransparency = 0.2
    btn.TextColor3 = T.textDim; btn.Font = Enum.Font.GothamMedium
    btn.TextSize = 12; btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.AutoButtonColor = false; btn.Parent = sidebar
    local bc = Instance.new("UICorner"); bc.CornerRadius = UDim.new(0,6); bc.Parent = btn
    local bar = Instance.new("Frame")
    bar.Size = UDim2.new(0,3,0.6,0); bar.Position = UDim2.new(0,0,0.2,0)
    bar.BackgroundColor3 = T.sidebar; bar.BorderSizePixel = 0; bar.Parent = btn
    local barC = Instance.new("UICorner"); barC.CornerRadius = UDim.new(0,2); barC.Parent = bar
    local frame = Instance.new("ScrollingFrame")
    frame.Size = UDim2.new(1,0,1,0)
    frame.BackgroundTransparency = 1; frame.BorderSizePixel = 0
    frame.ScrollBarThickness = 3; frame.ScrollBarImageColor3 = T.accent
    frame.CanvasSize = UDim2.new(0,0,0,0)
    frame.AutomaticCanvasSize = Enum.AutomaticSize.Y
    frame.Visible = false; frame.ZIndex = 6; frame.Parent = content
    local fl = Instance.new("UIListLayout")
    fl.Padding = UDim.new(0,6)
    fl.SortOrder = Enum.SortOrder.LayoutOrder
    fl.Parent = frame
    local fp = Instance.new("UIPadding")
    fp.PaddingTop = UDim.new(0,8); fp.PaddingBottom = UDim.new(0,12)
    fp.PaddingRight = UDim.new(0,6); fp.Parent = frame
    btn.MouseEnter:Connect(function() if activeTab ~= name then btn.BackgroundColor3 = T.elem end end)
    btn.MouseLeave:Connect(function() if activeTab ~= name then btn.BackgroundColor3 = T.sidebar end end)
    btn.MouseButton1Click:Connect(function() switchTab(name) end)
    tabs[name] = { btn = btn, frame = frame, bar = bar }
    return frame
end

local __order = setmetatable({}, { __mode = "k" })
local function nextOrder(parent)
    local n = (__order[parent] or 0) + 1
    __order[parent] = n
    return n
end

local function spacer(parent, height)
    local f = Instance.new("Frame")
    f.LayoutOrder = nextOrder(parent)
    f.Size = UDim2.new(1, 0, 0, height or 8)
    f.BackgroundTransparency = 1; f.Parent = parent
    return f
end

local function section(parent, text, color)
    local f = Instance.new("Frame")
    f.LayoutOrder = nextOrder(parent)
    f.Size = UDim2.new(1, 0, 0, 22)
    f.BackgroundTransparency = 1; f.Parent = parent
    local lbl = Instance.new("TextLabel")
    lbl.Text = text:upper(); lbl.Size = UDim2.new(1, 0, 1, 0)
    lbl.BackgroundTransparency = 1; lbl.TextColor3 = color or T.textDim
    lbl.Font = Enum.Font.GothamBold; lbl.TextSize = 11
    lbl.TextXAlignment = Enum.TextXAlignment.Left; lbl.Parent = f
    return f
end

local function divider(parent, text, color)
    local lbl = Instance.new("TextLabel")
    lbl.LayoutOrder = nextOrder(parent)
    lbl.Text = text
    lbl.Size = UDim2.new(1, 0, 0, 38)
    lbl.BackgroundColor3 = color or T.accent
    lbl.BackgroundTransparency = 0.72
    lbl.TextColor3 = T.text
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 14
    lbl.BorderSizePixel = 0; lbl.Parent = parent
    local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0,8); c.Parent = lbl
    local s = Instance.new("UIStroke")
    s.Color = color or T.accent; s.Thickness = 1.5
    s.Transparency = 0.25; s.Parent = lbl
    return lbl
end

local function infoLabel(parent, text, color)
    local lbl = Instance.new("TextLabel")
    lbl.LayoutOrder = nextOrder(parent)
    lbl.Text = text
    lbl.Size = UDim2.new(1, 0, 0, 26)
    lbl.BackgroundColor3 = T.elem
    lbl.BackgroundTransparency = 0.5
    lbl.TextColor3 = color or T.text
    lbl.Font = Enum.Font.GothamBold; lbl.TextSize = 12
    lbl.BorderSizePixel = 0; lbl.Parent = parent
    local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0,6); c.Parent = lbl
    local s = Instance.new("UIStroke"); s.Color = T.border; s.Thickness = 1; s.Parent = lbl
    return lbl
end

local function button(parent, label, desc, cb, isPremium)
    local b = Instance.new("TextButton")
    b.LayoutOrder = nextOrder(parent)
    b.Text = ""; b.Size = UDim2.new(1, 0, 0, desc and 48 or 34)
    b.BackgroundColor3 = T.elem; b.BackgroundTransparency = 0.4
    b.AutoButtonColor = false; b.Parent = parent
    local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0,6); c.Parent = b
    local s = Instance.new("UIStroke"); s.Color = isPremium and T.gold or T.border
    s.Thickness = 1; s.Parent = b
    local lbl = Instance.new("TextLabel")
    lbl.Text = label; lbl.Size = UDim2.new(1,-16,0,16)
    lbl.Position = UDim2.new(0,12,0, desc and 6 or 9)
    lbl.BackgroundTransparency = 1
    lbl.TextColor3 = isPremium and T.gold or T.text
    lbl.Font = Enum.Font.GothamMedium; lbl.TextSize = 13
    lbl.TextXAlignment = Enum.TextXAlignment.Left; lbl.Parent = b
    if desc then
        local d = Instance.new("TextLabel")
        d.Text = desc; d.Size = UDim2.new(1,-16,0,14)
        d.Position = UDim2.new(0,12,0,26)
        d.BackgroundTransparency = 1; d.TextColor3 = T.textDim
        d.Font = Enum.Font.Gotham; d.TextSize = 11
        d.TextXAlignment = Enum.TextXAlignment.Left; d.Parent = b
    end
    b.MouseEnter:Connect(function() b.BackgroundColor3 = T.elemHov; s.Color = T.accent end)
    b.MouseLeave:Connect(function() b.BackgroundColor3 = T.elem; s.Color = isPremium and T.gold or T.border end)
    b.MouseButton1Click:Connect(function()
        b.BackgroundColor3 = T.accentD; task.wait(0.08)
        b.BackgroundColor3 = T.elemHov; pcall(cb)
    end)
    return b
end

local function toggle(parent, label, default, cb)
    local f = Instance.new("TextButton")
    f.LayoutOrder = nextOrder(parent)
    f.Text = ""; f.Size = UDim2.new(1, 0, 0, 36)
    f.BackgroundColor3 = T.elem; f.BackgroundTransparency = 0.4
    f.AutoButtonColor = false; f.Parent = parent
    local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0,6); c.Parent = f
    local s = Instance.new("UIStroke"); s.Color = T.border; s.Thickness = 1; s.Parent = f
    local lbl = Instance.new("TextLabel")
    lbl.Text = label; lbl.Size = UDim2.new(1,-60,1,0)
    lbl.Position = UDim2.new(0,12,0,0)
    lbl.BackgroundTransparency = 1; lbl.TextColor3 = T.text
    lbl.Font = Enum.Font.GothamMedium; lbl.TextSize = 13
    lbl.TextXAlignment = Enum.TextXAlignment.Left; lbl.Parent = f
    local sw = Instance.new("Frame")
    sw.Size = UDim2.new(0,36,0,20); sw.Position = UDim2.new(1,-46,0.5,-10)
    sw.BackgroundColor3 = default and T.accent or Color3.fromRGB(50,50,60)
    sw.BorderSizePixel = 0; sw.Parent = f
    local sc = Instance.new("UICorner"); sc.CornerRadius = UDim.new(1,0); sc.Parent = sw
    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0,14,0,14)
    knob.Position = default and UDim2.new(1,-17,0.5,-7) or UDim2.new(0,3,0.5,-7)
    knob.BackgroundColor3 = Color3.new(1,1,1); knob.BorderSizePixel = 0; knob.Parent = sw
    local kc = Instance.new("UICorner"); kc.CornerRadius = UDim.new(1,0); kc.Parent = knob
    local state = default
    f.MouseEnter:Connect(function() s.Color = T.accent; f.BackgroundColor3 = T.elemHov end)
    f.MouseLeave:Connect(function() s.Color = T.border; f.BackgroundColor3 = T.elem end)
    f.MouseButton1Click:Connect(function()
        state = not state
        Tween:Create(sw, TweenInfo.new(0.15), { BackgroundColor3 = state and T.accent or Color3.fromRGB(50,50,60) }):Play()
        Tween:Create(knob, TweenInfo.new(0.15), { Position = state and UDim2.new(1,-17,0.5,-7) or UDim2.new(0,3,0.5,-7) }):Play()
        if cb then pcall(cb, state) end
    end)
    return f
end

local function slider(parent, label, minVal, maxVal, default, decimals, onChange)
    local holder = Instance.new("Frame")
    holder.LayoutOrder = nextOrder(parent)
    holder.Size = UDim2.new(1, 0, 0, 44)
    holder.BackgroundColor3 = T.elem; holder.BackgroundTransparency = 0.4
    holder.BorderSizePixel = 0; holder.Parent = parent
    local hc = Instance.new("UICorner"); hc.CornerRadius = UDim.new(0,6); hc.Parent = holder
    local hs = Instance.new("UIStroke"); hs.Color = T.border; hs.Thickness = 1; hs.Parent = holder
    local lbl = Instance.new("TextLabel")
    lbl.Text = label; lbl.Size = UDim2.new(0.6,0,0,18)
    lbl.Position = UDim2.new(0,12,0,4)
    lbl.BackgroundTransparency = 1; lbl.TextColor3 = T.text
    lbl.Font = Enum.Font.GothamMedium; lbl.TextSize = 12
    lbl.TextXAlignment = Enum.TextXAlignment.Left; lbl.Parent = holder
    local valLbl = Instance.new("TextLabel")
    valLbl.Text = string.format("%."..decimals.."f", default)
    valLbl.Size = UDim2.new(0.35,-12,0,18); valLbl.Position = UDim2.new(0.65,0,0,4)
    valLbl.BackgroundTransparency = 1; valLbl.TextColor3 = T.accent
    valLbl.Font = Enum.Font.GothamBold; valLbl.TextSize = 12
    valLbl.TextXAlignment = Enum.TextXAlignment.Right; valLbl.Parent = holder
    local track = Instance.new("Frame")
    track.Size = UDim2.new(1,-24,0,6); track.Position = UDim2.new(0,12,1,-14)
    track.BackgroundColor3 = Color3.fromRGB(40,40,50); track.BorderSizePixel = 0; track.Parent = holder
    local tc = Instance.new("UICorner"); tc.CornerRadius = UDim.new(1,0); tc.Parent = track
    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((default-minVal)/(maxVal-minVal), 0, 1, 0)
    fill.BackgroundColor3 = T.accent; fill.BorderSizePixel = 0; fill.Parent = track
    local fc = Instance.new("UICorner"); fc.CornerRadius = UDim.new(1,0); fc.Parent = fill
    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0,14,0,14); knob.AnchorPoint = Vector2.new(0.5, 0.5)
    knob.Position = UDim2.new((default-minVal)/(maxVal-minVal), 0, 0.5, 0)
    knob.BackgroundColor3 = Color3.new(1,1,1); knob.BorderSizePixel = 0
    knob.ZIndex = 2; knob.Parent = track
    local kc = Instance.new("UICorner"); kc.CornerRadius = UDim.new(1,0); kc.Parent = knob
    local kstroke = Instance.new("UIStroke")
    kstroke.Color = T.accent; kstroke.Thickness = 2; kstroke.Parent = knob
    local dragging = false
    local function setValue(v)
        v = math.clamp(v, minVal, maxVal)
        local a = (v-minVal)/(maxVal-minVal)
        fill.Size = UDim2.new(a, 0, 1, 0)
        knob.Position = UDim2.new(a, 0, 0.5, 0)
        valLbl.Text = string.format("%."..decimals.."f", v)
        if onChange then pcall(onChange, v) end
    end
    local function updateFromInput(input)
        local rel = (input.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X
        setValue(minVal + (maxVal-minVal) * math.clamp(rel, 0, 1))
    end
    track.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true; updateFromInput(input)
        end
    end)
    UIS.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            updateFromInput(input)
        end
    end)
    UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    setValue(default)
    return holder
end

local function textInput(parent, placeholder, defaultText, onSubmit)
    local holder = Instance.new("Frame")
    holder.LayoutOrder = nextOrder(parent)
    holder.Size = UDim2.new(1,0,0,40)
    holder.BackgroundColor3 = T.elem; holder.BackgroundTransparency = 0.4
    holder.BorderSizePixel = 0; holder.Parent = parent
    local hc = Instance.new("UICorner"); hc.CornerRadius = UDim.new(0,6); hc.Parent = holder
    local hs = Instance.new("UIStroke"); hs.Color = T.border; hs.Thickness = 1; hs.Parent = holder
    local box = Instance.new("TextBox")
    box.Size = UDim2.new(1,-90,1,-8); box.Position = UDim2.new(0,6,0,4)
    box.BackgroundTransparency = 1; box.Text = defaultText or ""
    box.PlaceholderText = placeholder or "Enter..."
    box.PlaceholderColor3 = T.textDim; box.TextColor3 = T.text
    box.Font = Enum.Font.GothamMedium; box.TextSize = 13
    box.TextXAlignment = Enum.TextXAlignment.Left
    box.ClearTextOnFocus = false; box.Parent = holder
    local submit = Instance.new("TextButton")
    submit.Text = "Set"; submit.Size = UDim2.new(0,78,1,-8)
    submit.Position = UDim2.new(1,-84,0,4)
    submit.BackgroundColor3 = T.accent; submit.BackgroundTransparency = 0.15
    submit.TextColor3 = T.text; submit.Font = Enum.Font.GothamBold
    submit.TextSize = 13; submit.AutoButtonColor = false; submit.Parent = holder
    local sc = Instance.new("UICorner"); sc.CornerRadius = UDim.new(0,5); sc.Parent = submit
    local function submitNow()
        local t = box.Text
        if t and t ~= "" then pcall(onSubmit, t) end
    end
    submit.MouseButton1Click:Connect(function()
        submit.BackgroundColor3 = T.accentD; task.wait(0.08)
        submit.BackgroundColor3 = T.accent; submitNow()
    end)
    box.FocusLost:Connect(function(enter) if enter then submitNow() end end)
    return holder
end

local function dropdown(parent, label, options, default, onChange)
    local holder = Instance.new("TextButton")
    holder.LayoutOrder = nextOrder(parent)
    holder.Text = ""; holder.Size = UDim2.new(1,0,0,36)
    holder.BackgroundColor3 = T.elem; holder.BackgroundTransparency = 0.4
    holder.AutoButtonColor = false; holder.Parent = parent
    local hc = Instance.new("UICorner"); hc.CornerRadius = UDim.new(0,6); hc.Parent = holder
    local hs = Instance.new("UIStroke"); hs.Color = T.border; hs.Thickness = 1; hs.Parent = holder
    local lbl = Instance.new("TextLabel")
    lbl.Text = label; lbl.Size = UDim2.new(0.5,0,1,0); lbl.Position = UDim2.new(0,12,0,0)
    lbl.BackgroundTransparency = 1; lbl.TextColor3 = T.text
    lbl.Font = Enum.Font.GothamMedium; lbl.TextSize = 13
    lbl.TextXAlignment = Enum.TextXAlignment.Left; lbl.Parent = holder
    local cur = Instance.new("TextLabel")
    cur.Text = default; cur.Size = UDim2.new(0.45,-32,1,0); cur.Position = UDim2.new(0.5,0,0,0)
    cur.BackgroundTransparency = 1; cur.TextColor3 = T.accent
    cur.Font = Enum.Font.GothamBold; cur.TextSize = 13
    cur.TextXAlignment = Enum.TextXAlignment.Right; cur.Parent = holder
    local arrow = Instance.new("TextLabel")
    arrow.Text = "v"; arrow.Size = UDim2.new(0,16,1,0); arrow.Position = UDim2.new(1,-22,0,0)
    arrow.BackgroundTransparency = 1; arrow.TextColor3 = T.textDim
    arrow.Font = Enum.Font.GothamBold; arrow.TextSize = 10; arrow.Parent = holder

    local popup = Instance.new("ScrollingFrame")
    popup.Size = UDim2.new(0, 220, 0, 160)
    popup.BackgroundColor3 = Color3.fromRGB(20,10,14)
    popup.BorderSizePixel = 0
    popup.ScrollBarThickness = 3; popup.ScrollBarImageColor3 = T.accent
    popup.CanvasSize = UDim2.new(0,0,0,0)
    popup.AutomaticCanvasSize = Enum.AutomaticSize.Y
    popup.Visible = false; popup.ZIndex = 100; popup.Parent = gui
    local popCorner = Instance.new("UICorner"); popCorner.CornerRadius = UDim.new(0,8); popCorner.Parent = popup
    local popStroke = Instance.new("UIStroke"); popStroke.Color = T.accent; popStroke.Thickness = 1; popStroke.Transparency = 0.4; popStroke.Parent = popup
    local popLay = Instance.new("UIListLayout")
    popLay.Padding = UDim.new(0,2); popLay.SortOrder = Enum.SortOrder.LayoutOrder; popLay.Parent = popup

    local open = false
    local function refreshPopup()
        for _, c in ipairs(popup:GetChildren()) do
            if c:IsA("TextButton") then c:Destroy() end
        end
        for i, opt in ipairs(options) do
            local b = Instance.new("TextButton")
            b.LayoutOrder = i
            b.Text = opt; b.Size = UDim2.new(1,-6,0,26)
            b.BackgroundColor3 = (opt == cur.Text) and T.accent or Color3.fromRGB(30,15,20)
            b.BackgroundTransparency = 0.4
            b.TextColor3 = T.text; b.Font = Enum.Font.GothamMedium
            b.TextSize = 12; b.TextXAlignment = Enum.TextXAlignment.Left
            b.AutoButtonColor = false; b.Parent = popup
            local bcp = Instance.new("UICorner"); bcp.CornerRadius = UDim.new(0,4); bcp.Parent = b
            local bpad = Instance.new("UIPadding"); bpad.PaddingLeft = UDim.new(0,8); bpad.Parent = b
            b.MouseEnter:Connect(function() b.BackgroundColor3 = T.accent end)
            b.MouseLeave:Connect(function() b.BackgroundColor3 = (opt == cur.Text) and T.accent or Color3.fromRGB(30,15,20) end)
            b.MouseButton1Click:Connect(function()
                cur.Text = opt
                popup.Visible = false; open = false
                if onChange then pcall(onChange, opt) end
                refreshPopup()
            end)
        end
    end
    refreshPopup()

    holder.MouseButton1Click:Connect(function()
        open = not open
        if open then
            local absPos = holder.AbsolutePosition
            local absSize = holder.AbsoluteSize
            popup.Position = UDim2.new(0, absPos.X, 0, absPos.Y + absSize.Y + 4)
            popup.Size = UDim2.new(0, math.max(absSize.X, 220), 0, math.min(#options * 28 + 8, 200))
            popup.Visible = true
        else
            popup.Visible = false
        end
    end)

    local api = { setValue = function(v) cur.Text = v; refreshPopup() end, refresh = refreshPopup }
    return holder, api
end

local function multiSelect(parent, getItems, isSelected, onToggle)
    local holder = Instance.new("Frame")
    holder.LayoutOrder = nextOrder(parent)
    holder.Size = UDim2.new(1,0,0,130)
    holder.BackgroundColor3 = T.elem; holder.BackgroundTransparency = 0.4
    holder.BorderSizePixel = 0; holder.Parent = parent
    local hc = Instance.new("UICorner"); hc.CornerRadius = UDim.new(0,6); hc.Parent = holder
    local hs = Instance.new("UIStroke"); hs.Color = T.border; hs.Thickness = 1; hs.Parent = holder
    local scroll = Instance.new("ScrollingFrame")
    scroll.Size = UDim2.new(1,-8,1,-8); scroll.Position = UDim2.new(0,4,0,4)
    scroll.BackgroundTransparency = 1; scroll.BorderSizePixel = 0
    scroll.ScrollBarThickness = 3; scroll.ScrollBarImageColor3 = T.accent
    scroll.CanvasSize = UDim2.new(0,0,0,0)
    scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    scroll.Parent = holder
    local lay = Instance.new("UIListLayout")
    lay.Padding = UDim.new(0,3); lay.SortOrder = Enum.SortOrder.LayoutOrder; lay.Parent = scroll
    local api = { refresh = nil }
    local function refresh()
        for _, c in ipairs(scroll:GetChildren()) do
            if c:IsA("TextButton") or c:IsA("TextLabel") then c:Destroy() end
        end
        local items = getItems()
        if #items == 0 then
            local lbl = Instance.new("TextLabel")
            lbl.LayoutOrder = 1
            lbl.Text = "No items"; lbl.Size = UDim2.new(1,0,0,24)
            lbl.BackgroundTransparency = 1; lbl.TextColor3 = T.textDim
            lbl.Font = Enum.Font.Gotham; lbl.TextSize = 12; lbl.Parent = scroll
            return
        end
        for i, name in ipairs(items) do
            local sel = isSelected(name)
            local b = Instance.new("TextButton")
            b.LayoutOrder = i
            b.Text = (sel and "[X]  " or "     ") .. name
            b.Size = UDim2.new(1,-4,0,26)
            b.BackgroundColor3 = sel and T.accent or Color3.fromRGB(30,30,40)
            b.BackgroundTransparency = sel and 0.3 or 0.2
            b.TextColor3 = T.text; b.Font = Enum.Font.GothamMedium
            b.TextSize = 12; b.TextXAlignment = Enum.TextXAlignment.Left
            b.AutoButtonColor = false; b.Parent = scroll
            local bc = Instance.new("UICorner"); bc.CornerRadius = UDim.new(0,4); bc.Parent = b
            b.MouseButton1Click:Connect(function() onToggle(name); refresh() end)
        end
    end
    api.refresh = refresh; refresh(); return api
end

local function partSelector(parent, opts)
    opts = opts or {}
    local options = opts.options or { "Head", "Torso", "Random" }
    local getVal = opts.get or function() return Aimbot.TargetPart end
    local setVal = opts.set or function(v) Aimbot.TargetPart = v end
    local b = Instance.new("TextButton")
    b.LayoutOrder = nextOrder(parent)
    b.Text = ""; b.Size = UDim2.new(1,0,0,36)
    b.BackgroundColor3 = T.elem; b.BackgroundTransparency = 0.4
    b.AutoButtonColor = false; b.Parent = parent
    local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0,6); c.Parent = b
    local s = Instance.new("UIStroke"); s.Color = T.border; s.Thickness = 1; s.Parent = b
    local lbl = Instance.new("TextLabel")
    lbl.Text = opts.label or "Target Part"
    lbl.Size = UDim2.new(0.5,0,1,0); lbl.Position = UDim2.new(0,12,0,0)
    lbl.BackgroundTransparency = 1; lbl.TextColor3 = T.text
    lbl.Font = Enum.Font.GothamMedium; lbl.TextSize = 13
    lbl.TextXAlignment = Enum.TextXAlignment.Left; lbl.Parent = b
    local val = Instance.new("TextLabel")
    val.Text = getVal(); val.Size = UDim2.new(0.45,-12,1,0); val.Position = UDim2.new(0.5,0,0,0)
    val.BackgroundTransparency = 1; val.TextColor3 = T.accent
    val.Font = Enum.Font.GothamBold; val.TextSize = 13
    val.TextXAlignment = Enum.TextXAlignment.Right; val.Parent = b
    b.MouseButton1Click:Connect(function()
        local cur = getVal(); local idx = 1
        for i, v in ipairs(options) do if v == cur then idx = i; break end end
        idx = idx + 1; if idx > #options then idx = 1 end
        setVal(options[idx]); val.Text = options[idx]
    end)
    return b
end

local PRESET_COLORS = {
    { name = "Red",    c = Color3.fromRGB(255, 60, 60)  },
    { name = "Orange", c = Color3.fromRGB(255, 140, 50) },
    { name = "Yellow", c = Color3.fromRGB(255, 210, 60) },
    { name = "Green",  c = Color3.fromRGB(60, 200, 60)  },
    { name = "Cyan",   c = Color3.fromRGB(60, 200, 200) },
    { name = "Blue",   c = Color3.fromRGB(80, 160, 255) },
    { name = "Purple", c = Color3.fromRGB(170, 80, 220) },
    { name = "Pink",   c = Color3.fromRGB(255, 100, 180)},
    { name = "White",  c = Color3.fromRGB(255, 255, 255)},
    { name = "Gray",   c = Color3.fromRGB(140, 140, 140)},
}
local function colorSelector(parent, label, getColor, setColor)
    local holder = Instance.new("Frame")
    holder.LayoutOrder = nextOrder(parent)
    holder.Size = UDim2.new(1, 0, 0, 96)
    holder.BackgroundColor3 = T.elem; holder.BackgroundTransparency = 0.4
    holder.BorderSizePixel = 0; holder.Parent = parent
    local hc = Instance.new("UICorner"); hc.CornerRadius = UDim.new(0,6); hc.Parent = holder
    local hs = Instance.new("UIStroke"); hs.Color = T.border; hs.Thickness = 1; hs.Parent = holder
    local lbl = Instance.new("TextLabel")
    lbl.Text = label; lbl.Size = UDim2.new(1, -60, 0, 18)
    lbl.Position = UDim2.new(0, 12, 0, 6)
    lbl.BackgroundTransparency = 1; lbl.TextColor3 = T.text
    lbl.Font = Enum.Font.GothamBold; lbl.TextSize = 12
    lbl.TextXAlignment = Enum.TextXAlignment.Left; lbl.Parent = holder
    local currentSw = Instance.new("Frame")
    currentSw.Size = UDim2.new(0, 18, 0, 18); currentSw.Position = UDim2.new(1, -30, 0, 6)
    currentSw.BackgroundColor3 = getColor(); currentSw.BorderSizePixel = 0; currentSw.Parent = holder
    local csc = Instance.new("UICorner"); csc.CornerRadius = UDim.new(0,4); csc.Parent = currentSw
    local css = Instance.new("UIStroke"); css.Color = T.border; css.Thickness = 1; css.Parent = currentSw
    local grid = Instance.new("Frame")
    grid.Size = UDim2.new(1, -20, 0, 56); grid.Position = UDim2.new(0, 10, 0, 30)
    grid.BackgroundTransparency = 1; grid.Parent = holder
    local gl = Instance.new("UIGridLayout")
    gl.CellSize = UDim2.new(0, 26, 0, 26); gl.CellPadding = UDim2.new(0, 6, 0, 6)
    gl.SortOrder = Enum.SortOrder.LayoutOrder; gl.Parent = grid
    local swatches = {}
    local function refreshSelection()
        local cur = getColor(); currentSw.BackgroundColor3 = cur
        for _, info in ipairs(swatches) do
            if info.color == cur then
                info.stroke.Color = Color3.fromRGB(255,255,255)
                info.stroke.Thickness = 3; info.stroke.Transparency = 0
            else
                info.stroke.Color = Color3.fromRGB(0,0,0)
                info.stroke.Thickness = 1; info.stroke.Transparency = 0.4
            end
        end
    end
    for i, preset in ipairs(PRESET_COLORS) do
        local sw = Instance.new("TextButton")
        sw.Text = ""; sw.LayoutOrder = i
        sw.BackgroundColor3 = preset.c; sw.AutoButtonColor = false; sw.Parent = grid
        local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0,4); c.Parent = sw
        local s = Instance.new("UIStroke")
        s.Color = Color3.fromRGB(0,0,0); s.Thickness = 1; s.Transparency = 0.4; s.Parent = sw
        table.insert(swatches, { color = preset.c, stroke = s })
        sw.MouseButton1Click:Connect(function() setColor(preset.c); refreshSelection() end)
    end
    refreshSelection()
    return holder
end

local function bankPanel(parent)
    local holder = Instance.new("Frame")
    holder.LayoutOrder = nextOrder(parent)
    holder.Size = UDim2.new(1,0,0,78)
    holder.BackgroundColor3 = T.elem; holder.BackgroundTransparency = 0.4
    holder.BorderSizePixel = 0; holder.Parent = parent
    local hc = Instance.new("UICorner"); hc.CornerRadius = UDim.new(0,6); hc.Parent = holder
    local hs = Instance.new("UIStroke"); hs.Color = T.border; hs.Thickness = 1; hs.Parent = holder
    local box = Instance.new("TextBox")
    box.Size = UDim2.new(1,-12,0,32); box.Position = UDim2.new(0,6,0,6)
    box.BackgroundColor3 = Color3.fromRGB(15,15,20); box.BackgroundTransparency = 0.3
    box.Text = ""; box.PlaceholderText = "Enter amount..."
    box.PlaceholderColor3 = T.textDim; box.TextColor3 = T.text
    box.Font = Enum.Font.GothamMedium; box.TextSize = 14
    box.TextXAlignment = Enum.TextXAlignment.Center
    box.ClearTextOnFocus = false; box.Parent = holder
    local bc = Instance.new("UICorner"); bc.CornerRadius = UDim.new(0,5); bc.Parent = box
    local bs = Instance.new("UIStroke"); bs.Color = T.border; bs.Thickness = 1; bs.Parent = box
    local deposit = Instance.new("TextButton")
    deposit.Text = "Deposit"; deposit.Size = UDim2.new(0.5,-9,0,30); deposit.Position = UDim2.new(0,6,1,-36)
    deposit.BackgroundColor3 = T.green; deposit.BackgroundTransparency = 0.1
    deposit.TextColor3 = Color3.new(1,1,1); deposit.Font = Enum.Font.GothamBold
    deposit.TextSize = 13; deposit.AutoButtonColor = false; deposit.Parent = holder
    local dc = Instance.new("UICorner"); dc.CornerRadius = UDim.new(0,5); dc.Parent = deposit
    local withdraw = Instance.new("TextButton")
    withdraw.Text = "Withdraw"; withdraw.Size = UDim2.new(0.5,-9,0,30); withdraw.Position = UDim2.new(0.5,3,1,-36)
    withdraw.BackgroundColor3 = Color3.fromRGB(120,30,30); withdraw.BackgroundTransparency = 0.1
    withdraw.TextColor3 = Color3.new(1,1,1); withdraw.Font = Enum.Font.GothamBold
    withdraw.TextSize = 13; withdraw.AutoButtonColor = false; withdraw.Parent = holder
    local wc = Instance.new("UICorner"); wc.CornerRadius = UDim.new(0,5); wc.Parent = withdraw
    deposit.MouseButton1Click:Connect(function() atmDeposit(box.Text) end)
    withdraw.MouseButton1Click:Connect(function() atmWithdraw(box.Text) end)
end

local function sendMoneyPanel(parent)
    local listHolder = Instance.new("Frame")
    listHolder.LayoutOrder = nextOrder(parent)
    listHolder.Size = UDim2.new(1,0,0,110)
    listHolder.BackgroundColor3 = T.elem; listHolder.BackgroundTransparency = 0.4
    listHolder.BorderSizePixel = 0; listHolder.Parent = parent
    local lhc = Instance.new("UICorner"); lhc.CornerRadius = UDim.new(0,6); lhc.Parent = listHolder
    local lhs = Instance.new("UIStroke"); lhs.Color = T.border; lhs.Thickness = 1; lhs.Parent = listHolder
    local scroll = Instance.new("ScrollingFrame")
    scroll.Size = UDim2.new(1,-8,1,-8); scroll.Position = UDim2.new(0,4,0,4)
    scroll.BackgroundTransparency = 1; scroll.BorderSizePixel = 0
    scroll.ScrollBarThickness = 3; scroll.ScrollBarImageColor3 = T.accent
    scroll.CanvasSize = UDim2.new(0,0,0,0)
    scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    scroll.Parent = listHolder
    local sLay = Instance.new("UIListLayout")
    sLay.Padding = UDim.new(0,3); sLay.SortOrder = Enum.SortOrder.LayoutOrder; sLay.Parent = scroll
    local selectedPlayer = nil
    local selLbl = Instance.new("TextLabel")
    selLbl.LayoutOrder = nextOrder(parent)
    selLbl.Text = "Selected: none"; selLbl.Size = UDim2.new(1,0,0,20)
    selLbl.BackgroundTransparency = 1; selLbl.TextColor3 = T.accent
    selLbl.Font = Enum.Font.GothamBold; selLbl.TextSize = 11
    selLbl.TextXAlignment = Enum.TextXAlignment.Left; selLbl.Parent = parent
    local row = Instance.new("Frame")
    row.LayoutOrder = nextOrder(parent)
    row.Size = UDim2.new(1,0,0,40); row.BackgroundColor3 = T.elem
    row.BackgroundTransparency = 0.4; row.BorderSizePixel = 0; row.Parent = parent
    local rowc = Instance.new("UICorner"); rowc.CornerRadius = UDim.new(0,6); rowc.Parent = row
    local rows = Instance.new("UIStroke"); rows.Color = T.border; rows.Thickness = 1; rows.Parent = row
    local box = Instance.new("TextBox")
    box.Size = UDim2.new(1,-100,1,-8); box.Position = UDim2.new(0,6,0,4)
    box.BackgroundTransparency = 1; box.Text = ""
    box.PlaceholderText = "Amount (max 100000)..."
    box.PlaceholderColor3 = T.textDim; box.TextColor3 = T.text
    box.Font = Enum.Font.GothamMedium; box.TextSize = 13
    box.TextXAlignment = Enum.TextXAlignment.Left
    box.ClearTextOnFocus = false; box.Parent = row
    local sendBtn = Instance.new("TextButton")
    sendBtn.Text = "Send"; sendBtn.Size = UDim2.new(0,88,1,-8); sendBtn.Position = UDim2.new(1,-94,0,4)
    sendBtn.BackgroundColor3 = T.green; sendBtn.BackgroundTransparency = 0.1
    sendBtn.TextColor3 = Color3.new(1,1,1); sendBtn.Font = Enum.Font.GothamBold
    sendBtn.TextSize = 13; sendBtn.AutoButtonColor = false; sendBtn.Parent = row
    local sc = Instance.new("UICorner"); sc.CornerRadius = UDim.new(0,5); sc.Parent = sendBtn
    local function refreshList()
        for _, child in ipairs(scroll:GetChildren()) do
            if child:IsA("TextButton") then child:Destroy() end
        end
        for i, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer then
                local b = Instance.new("TextButton")
                b.LayoutOrder = i
                b.Text = plr.Name; b.Size = UDim2.new(1,-4,0,28)
                b.BackgroundColor3 = Color3.fromRGB(30,30,40); b.BackgroundTransparency = 0.2
                b.TextColor3 = T.text; b.Font = Enum.Font.GothamMedium
                b.TextSize = 12; b.AutoButtonColor = false; b.Parent = scroll
                local bc2 = Instance.new("UICorner"); bc2.CornerRadius = UDim.new(0,4); bc2.Parent = b
                b.MouseButton1Click:Connect(function()
                    selectedPlayer = plr
                    selLbl.Text = "Selected: " .. plr.Name
                    for _, other in ipairs(scroll:GetChildren()) do
                        if other:IsA("TextButton") then other.BackgroundColor3 = Color3.fromRGB(30,30,40) end
                    end
                    b.BackgroundColor3 = T.accent
                end)
            end
        end
    end
    refreshList()
    Players.PlayerAdded:Connect(function() task.wait(0.5); refreshList() end)
    Players.PlayerRemoving:Connect(function() task.wait(0.5); refreshList() end)
    local function doSend()
        if not selectedPlayer then selLbl.Text = "Select a player first!" return end
        local amt = tonumber(box.Text)
        if not amt or amt <= 0 then selLbl.Text = "Enter a valid amount!" return end
        amt = math.clamp(amt, 1, 100000)
        sendMoney(selectedPlayer, amt)
        selLbl.Text = "Sent $" .. amt .. " to " .. selectedPlayer.Name
    end
    sendBtn.MouseButton1Click:Connect(doSend)
end

local function safePanel(parent)
    local backpackLbl = Instance.new("TextLabel")
    backpackLbl.LayoutOrder = nextOrder(parent)
    backpackLbl.Text = "YOUR TOOLS (tap to deposit)"
    backpackLbl.Size = UDim2.new(1,0,0,20)
    backpackLbl.BackgroundTransparency = 1; backpackLbl.TextColor3 = T.accent
    backpackLbl.Font = Enum.Font.GothamBold; backpackLbl.TextSize = 11
    backpackLbl.TextXAlignment = Enum.TextXAlignment.Left; backpackLbl.Parent = parent
    local backpackHolder = Instance.new("Frame")
    backpackHolder.LayoutOrder = nextOrder(parent)
    backpackHolder.Size = UDim2.new(1,0,0,30)
    backpackHolder.AutomaticSize = Enum.AutomaticSize.Y
    backpackHolder.BackgroundColor3 = T.elem; backpackHolder.BackgroundTransparency = 0.4
    backpackHolder.BorderSizePixel = 0; backpackHolder.Parent = parent
    local bhc = Instance.new("UICorner"); bhc.CornerRadius = UDim.new(0,6); bhc.Parent = backpackHolder
    local bhs = Instance.new("UIStroke"); bhs.Color = T.border; bhs.Thickness = 1; bhs.Parent = backpackHolder
    local bLay = Instance.new("UIListLayout")
    bLay.Padding = UDim.new(0,4); bLay.SortOrder = Enum.SortOrder.LayoutOrder; bLay.Parent = backpackHolder
    local bPad = Instance.new("UIPadding")
    bPad.PaddingTop = UDim.new(0,6); bPad.PaddingBottom = UDim.new(0,6)
    bPad.PaddingLeft = UDim.new(0,6); bPad.PaddingRight = UDim.new(0,6); bPad.Parent = backpackHolder

    local safeLbl = Instance.new("TextLabel")
    safeLbl.LayoutOrder = nextOrder(parent)
    safeLbl.Text = "SAFE CONTENTS (tap to grab)"
    safeLbl.Size = UDim2.new(1,0,0,20)
    safeLbl.BackgroundTransparency = 1; safeLbl.TextColor3 = T.accent
    safeLbl.Font = Enum.Font.GothamBold; safeLbl.TextSize = 11
    safeLbl.TextXAlignment = Enum.TextXAlignment.Left; safeLbl.Parent = parent
    local safeHolder = Instance.new("Frame")
    safeHolder.LayoutOrder = nextOrder(parent)
    safeHolder.Size = UDim2.new(1,0,0,30)
    safeHolder.AutomaticSize = Enum.AutomaticSize.Y
    safeHolder.BackgroundColor3 = T.elem; safeHolder.BackgroundTransparency = 0.4
    safeHolder.BorderSizePixel = 0; safeHolder.Parent = parent
    local shc = Instance.new("UICorner"); shc.CornerRadius = UDim.new(0,6); shc.Parent = safeHolder
    local shs = Instance.new("UIStroke"); shs.Color = T.border; shs.Thickness = 1; shs.Parent = safeHolder
    local sLay = Instance.new("UIListLayout")
    sLay.Padding = UDim.new(0,4); sLay.SortOrder = Enum.SortOrder.LayoutOrder; sLay.Parent = safeHolder
    local sPad = Instance.new("UIPadding")
    sPad.PaddingTop = UDim.new(0,6); sPad.PaddingBottom = UDim.new(0,6)
    sPad.PaddingLeft = UDim.new(0,6); sPad.PaddingRight = UDim.new(0,6); sPad.Parent = safeHolder

    local lastB, lastS = "", ""
    local function getBackpackItems()
        local items, seen = {}, {}
        local bp = LocalPlayer:FindFirstChild("Backpack")
        if bp then
            for _, t in ipairs(bp:GetChildren()) do
                if t:IsA("Tool") and not seen[t.Name] then seen[t.Name] = true; table.insert(items, t.Name) end
            end
        end
        local char = LocalPlayer.Character
        if char then
            for _, t in ipairs(char:GetChildren()) do
                if t:IsA("Tool") and not seen[t.Name] then seen[t.Name] = true; table.insert(items, t.Name) end
            end
        end
        table.sort(items); return items
    end
    local function getSafeItems()
        local items = {}
        local data = LocalPlayer:FindFirstChild("Data"); if not data then return items end
        local safe = data:FindFirstChild("SafeItems"); if not safe then return items end
        if safe:IsA("StringValue") then
            for name in string.gmatch(safe.Value, "[^,]+") do
                local t = name:gsub("^%s*(.-)%s*$", "%1")
                if t ~= "" then table.insert(items, t) end
            end
        else
            for _, c in ipairs(safe:GetChildren()) do table.insert(items, c.Name) end
        end
        table.sort(items); return items
    end
    local function refreshBackpack(force)
        local items = getBackpackItems()
        local sig = table.concat(items, "|")
        if not force and sig == lastB then return end
        lastB = sig
        for _, child in ipairs(backpackHolder:GetChildren()) do
            if child:IsA("TextButton") or child:IsA("TextLabel") then child:Destroy() end
        end
        if #items == 0 then
            local lbl = Instance.new("TextLabel")
            lbl.LayoutOrder = 1
            lbl.Text = "No tools in backpack"; lbl.Size = UDim2.new(1,0,0,24)
            lbl.BackgroundTransparency = 1; lbl.TextColor3 = T.textDim
            lbl.Font = Enum.Font.Gotham; lbl.TextSize = 12; lbl.Parent = backpackHolder
            return
        end
        for i, name in ipairs(items) do
            local b = Instance.new("TextButton")
            b.LayoutOrder = i
            b.Text = name .. "  ->  Deposit"; b.Size = UDim2.new(1,0,0,30)
            b.BackgroundColor3 = T.elem; b.BackgroundTransparency = 0.3
            b.TextColor3 = T.text; b.Font = Enum.Font.GothamMedium
            b.TextSize = 12; b.AutoButtonColor = false; b.Parent = backpackHolder
            local bc = Instance.new("UICorner"); bc.CornerRadius = UDim.new(0,5); bc.Parent = b
            b.MouseButton1Click:Connect(function()
                storageDeposit(name); task.wait(0.3); refreshBackpack(true); refreshSafe(true)
            end)
        end
    end
    local function refreshSafe(force)
        local items = getSafeItems()
        local sig = table.concat(items, "|")
        if not force and sig == lastS then return end
        lastS = sig
        for _, child in ipairs(safeHolder:GetChildren()) do
            if child:IsA("TextButton") or child:IsA("TextLabel") then child:Destroy() end
        end
        if #items == 0 then
            local lbl = Instance.new("TextLabel")
            lbl.LayoutOrder = 1
            lbl.Text = "Safe is empty"; lbl.Size = UDim2.new(1,0,0,24)
            lbl.BackgroundTransparency = 1; lbl.TextColor3 = T.textDim
            lbl.Font = Enum.Font.Gotham; lbl.TextSize = 12; lbl.Parent = safeHolder
            return
        end
        for i, name in ipairs(items) do
            local b = Instance.new("TextButton")
            b.LayoutOrder = i
            b.Text = name .. "  ->  Grab"; b.Size = UDim2.new(1,0,0,30)
            b.BackgroundColor3 = T.elem; b.BackgroundTransparency = 0.3
            b.TextColor3 = T.text; b.Font = Enum.Font.GothamMedium
            b.TextSize = 12; b.AutoButtonColor = false; b.Parent = safeHolder
            local bc = Instance.new("UICorner"); bc.CornerRadius = UDim.new(0,5); bc.Parent = b
            b.MouseButton1Click:Connect(function()
                storageWithdraw(name); task.wait(0.3); refreshSafe(true); refreshBackpack(true)
            end)
        end
    end
    refreshBackpack(); refreshSafe()
    task.spawn(function()
        while parent.Parent do task.wait(0.5); pcall(refreshBackpack); pcall(refreshSafe) end
    end)
end

local function getTeamNames()
    local names = {}
    pcall(function() for _, t in ipairs(TeamsSvc:GetTeams()) do table.insert(names, t.Name) end end)
    table.sort(names); return names
end
local function getOtherPlayerNames()
    local names = {}
    for _, p in ipairs(Players:GetPlayers()) do if p ~= LocalPlayer then table.insert(names, p.Name) end end
    table.sort(names); return names
end
local function inList(list, n) for _, x in ipairs(list) do if x == n then return true end end return false end
local function toggleInList(list, n)
    for i, x in ipairs(list) do if x == n then table.remove(list, i); return end end
    table.insert(list, n)
end

local farmTab = newTab("Auto Farm")
divider(farmTab, "FARM DASHBOARD", T.accent)
spacer(farmTab, 6)
Farm.UIRefs.BTC_price   = infoLabel(farmTab, "BTC: $...", T.gold)
Farm.UIRefs.BTC_wallet  = infoLabel(farmTab, "Wallet: 0 BTC", T.text)
Farm.UIRefs.ETH_price   = infoLabel(farmTab, "ETH: $...", T.blue)
Farm.UIRefs.ETH_wallet  = infoLabel(farmTab, "Wallet: 0 ETH", T.text)
Farm.UIRefs.DOGE_price  = infoLabel(farmTab, "DOGE: $...", T.text)
Farm.UIRefs.DOGE_wallet = infoLabel(farmTab, "Wallet: 0 DOGE", T.text)
Farm.UIRefs.puddleEarned = infoLabel(farmTab, "Puddle Earned: $0", Color3.fromRGB(85,255,127))
Farm.UIRefs.cryptoProfit = infoLabel(farmTab, "Crypto Profit: $0", Color3.fromRGB(85,255,127))

spacer(farmTab, 20)
divider(farmTab, "PUDDLE FARM", T.green)
spacer(farmTab, 8)
toggle(farmTab, "Auto Clean Puddles", false, function(v) Farm.AutoClean = v end)

spacer(farmTab, 18)
divider(farmTab, "AUTO DEPOSIT", T.blue)
spacer(farmTab, 8)
toggle(farmTab, "Auto Deposit", false, function(v) Farm.AutoDeposit = v end)
slider(farmTab, "Deposit Threshold ($)", 1000, 200000, Farm.DepositTarget, 0,
    function(v) Farm.DepositTarget = math.floor(v) end)
button(farmTab, "Force Deposit All Now", "Deposits entire cash balance",
    function() task.spawn(function() performDeposit(true) end) end)

spacer(farmTab, 18)
divider(farmTab, "SMART CRYPTO AI", T.gold)
spacer(farmTab, 8)
toggle(farmTab, "Auto BTC (buy <= $2000 / sell >= $8000)", false, function(v) AutoCrypto.BTC = v end)
toggle(farmTab, "Auto ETH (buy <= $500 / sell >= $900)",   false, function(v) AutoCrypto.ETH = v end)
toggle(farmTab, "Auto DOGE (buy <= $250 / sell >= $500)",  false, function(v) AutoCrypto.DOGE = v end)
spacer(farmTab, 8)
button(farmTab, "Force Sell All BTC",  "Sells every BTC",  function() task.spawn(function() forceSellCoin("BTC") end) end)
button(farmTab, "Force Sell All ETH",  "Sells every ETH",  function() task.spawn(function() forceSellCoin("ETH") end) end)
button(farmTab, "Force Sell All DOGE", "Sells every DOGE", function() task.spawn(function() forceSellCoin("DOGE") end) end)

spacer(farmTab, 18)
divider(farmTab, "FARM MISC", T.textDim)
spacer(farmTab, 8)
toggle(farmTab, "Anti-AFK", true, function(v) Farm.AntiAfk = v end)

local gunsTab = newTab("Guns")
divider(gunsTab, "WEAPONS", T.accent)
spacer(gunsTab, 6)
button(gunsTab, "Spawn ARPDrum", "*Requires ARPDrum Spawner Gamepass", function() spawnNamed("ARPDrum") end)
spacer(gunsTab, 16)
divider(gunsTab, "REVERT SPAWN", T.accent)
spacer(gunsTab, 6)
textInput(gunsTab, "Enter gun name", "", function(gunName) revert(gunName) end)

local shoppingTab = newTab("Shopping")
divider(shoppingTab, "FREE GUNS", T.accent)
spacer(shoppingTab, 10)
button(shoppingTab, "Makarov",     "$1000",  function() buyGun("Makarov", 1000) end)
button(shoppingTab, "Glock17",     "$1200",  function() buyGun("Glock17", 1200) end)
button(shoppingTab, "Tec-9",       "$3500",  function() buyGun("Tec-9", 3500) end)
button(shoppingTab, "Mac",         "$3000",  function() buyGun("Mac", 3000) end)
button(shoppingTab, "UMP",         "$4800",  function() buyGun("UMP", 4800) end)
button(shoppingTab, "Shotgun",     "$5000",  function() buyGun("Shotgun", 5000) end)
button(shoppingTab, "Glock19X",    "$5000",  function() buyGun("Glock19X", 5000) end)
button(shoppingTab, "AUG",         "$5000",  function() buyGun("AUG", 5000) end)
button(shoppingTab, "Draco",       "$5200",  function() buyGun("Draco", 5200) end)
button(shoppingTab, "GlockSwitch", "$5400",  function() buyGun("GlockSwitch", 5400) end)
button(shoppingTab, "HoneyBadger", "$5500",  function() buyGun("HoneyBadger", 5500) end)
button(shoppingTab, "AK-47",       "$6500",  function() buyGun("AK-47", 6500) end)
button(shoppingTab, "Vector",      "$7000",  function() buyGun("Vector", 7000) end)
button(shoppingTab, "MP5",         "$7500",  function() buyGun("MP5", 7500) end)
button(shoppingTab, "TSR-15",      "$8000",  function() buyGun("TSR-15", 8000) end)
button(shoppingTab, "Scar-17",     "$9000",  function() buyGun("Scar-17", 9000) end)
spacer(shoppingTab, 26)
divider(shoppingTab, "PREMIUM GUNS", T.gold)
spacer(shoppingTab, 10)
button(shoppingTab, "M&P9",       "*Premium - $2500",  function() buyGun("M&P9", 2500) end, true)
button(shoppingTab, "Thompson",   "*Premium - $4000",  function() buyGun("Thompson", 4000) end, true)
button(shoppingTab, "Spas",       "*Premium - $4500",  function() buyGun("Spas", 4500) end, true)
button(shoppingTab, "Micro Uzi",  "*Premium - $7500",  function() buyGun("Micro Uzi", 7500) end, true)
button(shoppingTab, "G36",        "*Premium - $8500",  function() buyGun("G36", 8500) end, true)
button(shoppingTab, "AK-12",      "*Premium - $9000",  function() buyGun("AK-12", 9000) end, true)
button(shoppingTab, "Famans",     "*Premium - $9000",  function() buyGun("Famans", 9000) end, true)
button(shoppingTab, "Perun",      "*Premium - $9500",  function() buyGun("Perun", 9500) end, true)
button(shoppingTab, "M27D",       "*Premium - $10000", function() buyGun("M27D", 10000) end, true)
spacer(shoppingTab, 26)
divider(shoppingTab, "AMMO", T.accent)
spacer(shoppingTab, 10)
button(shoppingTab, "Pistol Ammo",  "$50",  function() buyGun("Pistol Ammo", 50) end)
button(shoppingTab, "Rifle Ammo",   "$100", function() buyGun("Rifle Ammo", 100) end)
button(shoppingTab, "Smg Ammo",     "$100", function() buyGun("Smg Ammo", 100) end)
button(shoppingTab, "Shotgun Ammo", "$100", function() buyGun("Shotgun Ammo", 100) end)
spacer(shoppingTab, 26)
divider(shoppingTab, "UTILITY", T.accent)
spacer(shoppingTab, 10)
button(shoppingTab, "DuffleBag", "$500",  function() buyStuff("DuffleBag", 500) end)
button(shoppingTab, "MentosBag", "$300",  function() buyStuff("MentosBag", 300) end)
button(shoppingTab, "C4",        "$2000", function() buyStuff("C4", 2000) end)
button(shoppingTab, "LockPick",  "$500",  function() buyStuff("LockPick", 500) end)

local combatTab = newTab("Combat")
spacer(combatTab, 4)
divider(combatTab, "SILENT AIM", T.accent)
spacer(combatTab, 10)
section(combatTab, "Master")
toggle(combatTab, "Enable Silent Aim", false, function(v) SilentAim.Enabled = v; refreshSilentFOV() end)
toggle(combatTab, "Nearest Part", false, function(v) SilentAim.NearestPart = v end)
toggle(combatTab, "Show Silent FOV Circle", true, function(v) SilentAim.ShowFOV = v; refreshSilentFOV() end)
spacer(combatTab, 8)
section(combatTab, "Checks")
toggle(combatTab, "Team Check", true, function(v) SilentAim.TeamCheck = v end)
toggle(combatTab, "Wall Check", true, function(v) SilentAim.WallCheck = v end)
toggle(combatTab, "Friends Check", true, function(v) SilentAim.FriendsCheck = v end)
toggle(combatTab, "ForceField Check", false, function(v) SilentAim.ForceFieldCheck = v end)
spacer(combatTab, 8)
section(combatTab, "Target")
partSelector(combatTab, {
    label = "Silent Target Part",
    options = { "Head", "Torso", "HumanoidRootPart", "Random" },
    get = function() return SilentAim.TargetPart end,
    set = function(v) SilentAim.TargetPart = v end,
})
toggle(combatTab, "Target Players", true, function(v) SilentAim.TargetEntities.Player = v end)
toggle(combatTab, "Target NPCs", false, function(v) SilentAim.TargetEntities.Npc = v end)
spacer(combatTab, 8)
section(combatTab, "Target Teams (empty = all)")
local teamList = multiSelect(combatTab, getTeamNames,
    function(n) return inList(SilentAim.TargetTeams, n) end,
    function(n) toggleInList(SilentAim.TargetTeams, n) end)
spacer(combatTab, 8)
section(combatTab, "Ignore Players")
local ignoreList = multiSelect(combatTab, getOtherPlayerNames,
    function(n) return inList(SilentAim.IgnorePlayers, n) end,
    function(n) toggleInList(SilentAim.IgnorePlayers, n) end)
Players.PlayerAdded:Connect(function() task.wait(0.5); ignoreList.refresh() end)
Players.PlayerRemoving:Connect(function() task.wait(0.5); ignoreList.refresh() end)
spacer(combatTab, 8)
section(combatTab, "Tuning")
slider(combatTab, "Hit Chance (%)", 0, 100, SilentAim.HitChance, 0, function(v) SilentAim.HitChance = v end)
slider(combatTab, "Silent FOV Radius", 30, 500, SilentAim.FOV, 0, function(v) SilentAim.FOV = v; refreshSilentFOV() end)
slider(combatTab, "Max Distance", 50, 1000, SilentAim.MaxDistance, 0, function(v) SilentAim.MaxDistance = v end)

spacer(combatTab, 34)
divider(combatTab, "AIMBOT", T.blue)
spacer(combatTab, 10)
section(combatTab, "Master")
toggle(combatTab, "Enable PC Aimbot", false, function(v) Aimbot.PCEnabled = v; refreshFOVCircle() end)
toggle(combatTab, "Enable Mobile Aimbot", false, function(v) Aimbot.MobileEnabled = v; refreshFOVCircle() end)
toggle(combatTab, "Show FOV Circle (White)", true, function(v) Aimbot.ShowFOV = v; refreshFOVCircle() end)
spacer(combatTab, 8)
section(combatTab, "Checks")
toggle(combatTab, "Team Check", true, function(v) Aimbot.TeamCheck = v end)
toggle(combatTab, "Wall Check", true, function(v) Aimbot.WallCheck = v end)
toggle(combatTab, "Friends Check", true, function(v) Aimbot.FriendsCheck = v end)
spacer(combatTab, 8)
section(combatTab, "Target")
partSelector(combatTab, {
    label = "Aimbot Target Part",
    options = { "Head", "Torso", "Random" },
    get = function() return Aimbot.TargetPart end,
    set = function(v) Aimbot.TargetPart = v end,
})
toggle(combatTab, "Target NPCs", false, function(v) Aimbot.NPCEnabled = v end)
spacer(combatTab, 8)
section(combatTab, "Tuning")
slider(combatTab, "FOV Radius", 30, 500, Aimbot.FOV, 0, function(v) Aimbot.FOV = v; refreshFOVCircle() end)
slider(combatTab, "Max Distance", 50, 1000, Aimbot.MaxDistance, 0, function(v) Aimbot.MaxDistance = v end)
slider(combatTab, "Smoothness", 0, 0.9, Aimbot.Smoothness, 2, function(v) Aimbot.Smoothness = v end)

local espTab = newTab("ESP")
spacer(espTab, 4)
divider(espTab, "ESP SUITE", T.accent)
spacer(espTab, 10)
section(espTab, "Master")
toggle(espTab, "Enable ESP", true, function(v) ESPcfg.Enabled = v end)
spacer(espTab, 8)
section(espTab, "Visual Elements")
toggle(espTab, "Cham ESP", true,   function(v) ESPcfg.Cham = v end)
toggle(espTab, "Name ESP", false,  function(v) ESPcfg.Name = v end)
toggle(espTab, "Box ESP", false,   function(v) ESPcfg.Box = v end)
toggle(espTab, "Tracers ESP", false, function(v) ESPcfg.Tracer = v end)
toggle(espTab, "Distance ESP", false, function(v) ESPcfg.Distance = v end)
toggle(espTab, "Gun ESP (held tool)", false, function(v) ESPcfg.Gun = v end)
toggle(espTab, "Health ESP", false, function(v) ESPcfg.Health = v end)
spacer(espTab, 8)
section(espTab, "Target Categories")
toggle(espTab, "Team Color (allies green)", true, function(v) ESPcfg.TeamColor = v end)
toggle(espTab, "Friends Highlight + Tag", true, function(v) ESPcfg.FriendsTag = v end)
toggle(espTab, "NPC ESP", false, function(v) ESPcfg.NPC = v end)
spacer(espTab, 22)
divider(espTab, "COLORS - TAP TO SELECT", T.blue)
spacer(espTab, 10)
colorSelector(espTab, "Enemy Color",  function() return ESPcfg.EnemyColor end, function(c) ESPcfg.EnemyColor = c end)
colorSelector(espTab, "Team Color (allies)", function() return ESPcfg.TeamColorV end, function(c) ESPcfg.TeamColorV = c end)
colorSelector(espTab, "Friend Color", function() return ESPcfg.FriendColor end, function(c) ESPcfg.FriendColor = c end)
colorSelector(espTab, "NPC Color",    function() return ESPcfg.NPCColor end,    function(c) ESPcfg.NPCColor = c end)
spacer(espTab, 22)
divider(espTab, "CHAM SETTINGS", T.accent)
spacer(espTab, 10)
section(espTab, "Transparency")
slider(espTab, "Fill Transparency", 0, 1, ESPcfg.FillTransparency, 2, function(v) ESPcfg.FillTransparency = v end)
slider(espTab, "Outline Transparency", 0, 1, ESPcfg.OutlineTransparency, 2, function(v) ESPcfg.OutlineTransparency = v end)
spacer(espTab, 8)
section(espTab, "Range")
slider(espTab, "Max Distance (studs)", 100, 2000, ESPcfg.MaxDistance, 0, function(v) ESPcfg.MaxDistance = v end)

local othersTab = newTab("Others")
divider(othersTab, "ACTIONS", T.accent)
spacer(othersTab, 8)
button(othersTab, "Give", "Hand held tool to player in front", doGive)
button(othersTab, "Sign In", "Need PD Gamepass", function() cmd("/signin") end)
button(othersTab, "Sign Out", "Need PD Gamepass", function() cmd("/signout") end)
button(othersTab, "Drop", "Drops your held tool", function() cmd("/drop") end)
button(othersTab, "Respawn", "Respawn your character", function() cmd("/respawn") end)
button(othersTab, "Gloves", "Equip gloves", function() cmd("/gloves") end)
spacer(othersTab, 22)
divider(othersTab, "VEHICLES - PD REQUIRED", T.blue)
spacer(othersTab, 8)
button(othersTab, "Spawn PD", "Need PD Gamepass", function() cmd("/spawn pd") end)
button(othersTab, "Spawn PD2", "Need PD Gamepass", function() cmd("/spawn pd2") end)
button(othersTab, "Spawn Swatcar", "Need PD Gamepass", function() cmd("/spawn swatcar") end)
button(othersTab, "Spawn CID", "Need PD Gamepass", function() cmd("/spawn cid") end)
button(othersTab, "Spawn CID2", "Need PD Gamepass", function() cmd("/spawn cid2") end)
button(othersTab, "Spawn SogSuv", "Need PD Gamepass", function() cmd("/spawn sogsuv") end)
button(othersTab, "Spawn PDBoat", "Need PD Gamepass", function() cmd("/spawn pdboot") end)

local miscTab = newTab("Misc")
divider(miscTab, "FEATURES", T.accent)
spacer(miscTab, 8)
toggle(miscTab, "Infinite Stamina", true, function(v)
    S.Stamina = v
    if not v and S.OrigStamina ~= nil then
        local data = LocalPlayer:FindFirstChild("Data")
        local st = data and data:FindFirstChild("Stamina")
        if st then st.Value = S.OrigStamina end
    end
end)
toggle(miscTab, "Fast Prompts", true, function(v) S.Prompts = v; applyPromptState() end)
spacer(miscTab, 22)
divider(miscTab, "ATM - DEPOSIT / WITHDRAW", T.accent)
spacer(miscTab, 8)
bankPanel(miscTab)
spacer(miscTab, 22)
divider(miscTab, "SEND MONEY (MAX 100K)", T.green)
spacer(miscTab, 8)
sendMoneyPanel(miscTab)
spacer(miscTab, 22)
divider(miscTab, "SAFE - DEPOSIT / GRAB", T.accent)
spacer(miscTab, 8)
safePanel(miscTab)
spacer(miscTab, 22)
divider(miscTab, "PERFORMANCE", T.blue)
spacer(miscTab, 8)
toggle(miscTab, "Anti-Lag / FPS Boost", false, function(v)
    S.AntiLag = v
    if v then pcall(enableAntiLag) else pcall(disableAntiLag) end
end)

local settingsTab = newTab("Settings")
divider(settingsTab, "MOBILE BUTTON STYLE", T.accent)
spacer(settingsTab, 6)
colorSelector(settingsTab, "Mobile Button Icon Color",
    function() return UIState.MobileButtonColor end,
    function(c)
        UIState.MobileButtonColor = c
        if figStroke then figStroke.Color = c end
        if letterStroke then letterStroke.Color = c end
        if innerGlow then innerGlow.BackgroundColor3 = c end
        if dot then dot.BackgroundColor3 = c end
    end)

spacer(settingsTab, 18)
divider(settingsTab, "THEME / BACKGROUND", T.accent)
spacer(settingsTab, 8)

local themeOptions = {}
for k in pairs(ThemeList) do table.insert(themeOptions, k) end
table.sort(themeOptions)

dropdown(settingsTab, "Select Theme", themeOptions, "Rose", function(v)
    UIState.SelectedTheme = v
end)

button(settingsTab, "Apply Theme", "Applies selected theme", function()
    applyTheme(UIState.SelectedTheme)
    win.BackgroundColor3 = T.bg
    header.BackgroundColor3 = T.panel
    headerCover.BackgroundColor3 = T.panel
    sidebar.BackgroundColor3 = T.sidebar
    winBorder.Color = T.border
    minBtn.BackgroundColor3 = T.elem
    closeBtn.BackgroundColor3 = T.elem
    userFooter.BackgroundColor3 = T.sidebar
    ufStroke.Color = T.accent
    switchTab(activeTab or "Auto Farm")
end)

dropdown(settingsTab, "Select Background", { "Main" }, "Main", function(v)
    UIState.SelectedBackground = v
end)

textInput(settingsTab, "Background ID / URL", "", function(v)
    UIState.BackgroundID = v
end)

button(settingsTab, "Apply Background", "Load custom background", function()
    if UIState.BackgroundID and UIState.BackgroundID ~= "" then
        galaxy.BackgroundColor3 = Color3.fromRGB(0,0,0)
        galaxy.BackgroundTransparency = 0.3
        local bgImg = galaxy:FindFirstChild("CustomBG") or Instance.new("ImageLabel")
        bgImg.Name = "CustomBG"
        bgImg.Size = UDim2.new(1,0,1,0)
        bgImg.BackgroundTransparency = 1
        bgImg.Image = UIState.BackgroundID
        bgImg.ScaleType = Enum.ScaleType.Crop
        bgImg.ZIndex = 0
        bgImg.Parent = galaxy
    end
end)

spacer(settingsTab, 18)
divider(settingsTab, "KEYBIND", T.blue)
spacer(settingsTab, 8)

local keybindBtn = Instance.new("TextButton")
keybindBtn.LayoutOrder = nextOrder(settingsTab)
keybindBtn.Text = ""; keybindBtn.Size = UDim2.new(1,0,0,36)
keybindBtn.BackgroundColor3 = T.elem; keybindBtn.BackgroundTransparency = 0.4
keybindBtn.AutoButtonColor = false; keybindBtn.Parent = settingsTab
local kbCorner = Instance.new("UICorner"); kbCorner.CornerRadius = UDim.new(0,6); kbCorner.Parent = keybindBtn
local kbStroke = Instance.new("UIStroke"); kbStroke.Color = T.border; kbStroke.Thickness = 1; kbStroke.Parent = keybindBtn
local kbLbl = Instance.new("TextLabel")
kbLbl.Text = "Keybind"; kbLbl.Size = UDim2.new(0.5,0,1,0); kbLbl.Position = UDim2.new(0,12,0,0)
kbLbl.BackgroundTransparency = 1; kbLbl.TextColor3 = T.text
kbLbl.Font = Enum.Font.GothamMedium; kbLbl.TextSize = 13
kbLbl.TextXAlignment = Enum.TextXAlignment.Left; kbLbl.Parent = keybindBtn
local kbVal = Instance.new("TextLabel")
kbVal.Text = tostring(UIState.Keybind):gsub("Enum.KeyCode.","")
kbVal.Size = UDim2.new(0.4,-12,1,0); kbVal.Position = UDim2.new(0.5,0,0,0)
kbVal.BackgroundTransparency = 1; kbVal.TextColor3 = T.accent
kbVal.Font = Enum.Font.GothamBold; kbVal.TextSize = 13
kbVal.TextXAlignment = Enum.TextXAlignment.Right; kbVal.Parent = keybindBtn

local listeningKey = false
keybindBtn.MouseButton1Click:Connect(function()
    listeningKey = not listeningKey
    if listeningKey then
        kbVal.Text = "..."; kbVal.TextColor3 = T.gold
    else
        kbVal.Text = tostring(UIState.Keybind):gsub("Enum.KeyCode.","")
        kbVal.TextColor3 = T.accent
    end
end)
UIS.InputBegan:Connect(function(input, processed)
    if processed or not listeningKey then return end
    if input.UserInputType == Enum.UserInputType.Keyboard then
        UIState.Keybind = input.KeyCode
        kbVal.Text = tostring(input.KeyCode):gsub("Enum.KeyCode.","")
        kbVal.TextColor3 = T.accent
        listeningKey = false
    end
end)

spacer(settingsTab, 18)
divider(settingsTab, "CONFIGS", T.gold)
spacer(settingsTab, 8)

textInput(settingsTab, "Config Name", UIState.ConfigName, function(v) UIState.ConfigName = v end)

local savedConfigs = { "--" }
local function refreshConfigList()
    pcall(function()
        if not listfiles then return end
        local files = listfiles("SSLR_Configs") or {}
        savedConfigs = { "--" }
        for _, f in ipairs(files) do
            local name = f:match("([^/\\]+)%.json$")
            if name then table.insert(savedConfigs, name) end
        end
    end)
end

local configDropdownHolder, configDropdown = dropdown(settingsTab, "Selected Config", savedConfigs, "--", function(v)
    UIState.SelectedConfig = v
end)

dropdown(settingsTab, "Auto Load Config", { "None" }, "None", function(v)
    UIState.AutoLoadConfig = v
end)

button(settingsTab, "Save Config", "Saves current settings", function()
    pcall(function()
        if not (writefile and isfolder) then return end
        if not isfolder("SSLR_Configs") then makefolder("SSLR_Configs") end
        local cfgData = {
            theme = UIState.SelectedTheme,
            background = UIState.BackgroundID,
            keybind = tostring(UIState.Keybind),
            mobileColor = tostring(UIState.MobileButtonColor),
            esp = ESPcfg, aimbot = Aimbot, silent = { Enabled = SilentAim.Enabled },
            farm = { AutoClean = Farm.AutoClean, AutoDeposit = Farm.AutoDeposit, DepositTarget = Farm.DepositTarget },
            crypto = { BTC = AutoCrypto.BTC, ETH = AutoCrypto.ETH, DOGE = AutoCrypto.DOGE },
        }
        writefile("SSLR_Configs/" .. UIState.ConfigName .. ".json", HttpService:JSONEncode(cfgData))
        refreshConfigList()
    end)
end)

button(settingsTab, "Load Selected Config", "Loads the config", function()
    pcall(function()
        if not (readfile and isfile) then return end
        local path = "SSLR_Configs/" .. UIState.SelectedConfig .. ".json"
        if not isfile(path) then return end
        local cfg = HttpService:JSONDecode(readfile(path))
        if cfg.theme then UIState.SelectedTheme = cfg.theme; applyTheme(cfg.theme) end
        if cfg.background then UIState.BackgroundID = cfg.background end
        if cfg.esp then for k, v in pairs(cfg.esp) do ESPcfg[k] = v end end
        if cfg.aimbot then for k, v in pairs(cfg.aimbot) do Aimbot[k] = v end end
        if cfg.farm then
            Farm.AutoClean = cfg.farm.AutoClean or false
            Farm.AutoDeposit = cfg.farm.AutoDeposit or false
            Farm.DepositTarget = cfg.farm.DepositTarget or 50000
        end
        if cfg.crypto then
            AutoCrypto.BTC = cfg.crypto.BTC or false
            AutoCrypto.ETH = cfg.crypto.ETH or false
            AutoCrypto.DOGE = cfg.crypto.DOGE or false
        end
    end)
end)

button(settingsTab, "Delete Selected Config", "Deletes the config", function()
    pcall(function()
        if not delfile then return end
        if UIState.SelectedConfig == "--" then return end
        delfile("SSLR_Configs/" .. UIState.SelectedConfig .. ".json")
        refreshConfigList()
    end)
end)

button(settingsTab, "Refresh Config List", "Rescans configs folder", function()
    refreshConfigList()
end)

spacer(settingsTab, 18)
divider(settingsTab, "USER", T.accent)
spacer(settingsTab, 6)
infoLabel(settingsTab, "Display Name: " .. (LocalPlayer.DisplayName or LocalPlayer.Name), T.text)
infoLabel(settingsTab, "Username: @" .. LocalPlayer.Name, T.text)
infoLabel(settingsTab, "User ID: " .. tostring(LocalPlayer.UserId), T.text)

local discordTab = newTab("Discord")
divider(discordTab, "COMMUNITY", T.blue)
spacer(discordTab, 6)

local card = Instance.new("Frame")
card.LayoutOrder = nextOrder(discordTab)
card.Size = UDim2.new(1, 0, 0, 90)
card.BackgroundColor3 = T.elem
card.BackgroundTransparency = 0.4
card.BorderSizePixel = 0
card.Parent = discordTab
local cardCorner = Instance.new("UICorner"); cardCorner.CornerRadius = UDim.new(0,8); cardCorner.Parent = card
local cardStroke = Instance.new("UIStroke"); cardStroke.Color = T.accent; cardStroke.Thickness = 1; cardStroke.Transparency = 0.4; cardStroke.Parent = card

local cardAvatar = Instance.new("ImageLabel")
cardAvatar.Size = UDim2.new(0, 56, 0, 56)
cardAvatar.Position = UDim2.new(0, 12, 0.5, -28)
cardAvatar.BackgroundColor3 = T.bg
cardAvatar.BorderSizePixel = 0
cardAvatar.Parent = card
local cardAvatarCorner = Instance.new("UICorner"); cardAvatarCorner.CornerRadius = UDim.new(0, 10); cardAvatarCorner.Parent = cardAvatar
pcall(function()
    cardAvatar.Image = Players:GetUserThumbnailAsync(LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100)
end)

local cardName = Instance.new("TextLabel")
cardName.Text = "SSLR Community"
cardName.Size = UDim2.new(1, -80, 0, 20)
cardName.Position = UDim2.new(0, 78, 0, 12)
cardName.BackgroundTransparency = 1
cardName.TextColor3 = T.text
cardName.Font = Enum.Font.GothamBold; cardName.TextSize = 14
cardName.TextXAlignment = Enum.TextXAlignment.Left
cardName.Parent = card

local cardLive = Instance.new("TextLabel")
cardLive.Text = "LIVE"
cardLive.Size = UDim2.new(0, 44, 0, 16)
cardLive.Position = UDim2.new(1, -56, 0, 14)
cardLive.BackgroundColor3 = Color3.fromRGB(80, 200, 100)
cardLive.BackgroundTransparency = 0.2
cardLive.TextColor3 = Color3.new(1,1,1)
cardLive.Font = Enum.Font.GothamBold; cardLive.TextSize = 10
cardLive.BorderSizePixel = 0
cardLive.Parent = card
local liveCorner = Instance.new("UICorner"); liveCorner.CornerRadius = UDim.new(0,4); liveCorner.Parent = cardLive

local cardSub = Instance.new("TextLabel")
cardSub.Text = "Members: 59397   |   Online: 2481"
cardSub.Size = UDim2.new(1, -80, 0, 16)
cardSub.Position = UDim2.new(0, 78, 0, 34)
cardSub.BackgroundTransparency = 1
cardSub.TextColor3 = T.textDim
cardSub.Font = Enum.Font.Gotham; cardSub.TextSize = 11
cardSub.TextXAlignment = Enum.TextXAlignment.Left
cardSub.Parent = card

local cardInvite = Instance.new("TextLabel")
cardInvite.Text = "discord.gg/sslr"
cardInvite.Size = UDim2.new(1, -80, 0, 16)
cardInvite.Position = UDim2.new(0, 78, 0, 52)
cardInvite.BackgroundTransparency = 1
cardInvite.TextColor3 = T.accent
cardInvite.Font = Enum.Font.GothamBold; cardInvite.TextSize = 11
cardInvite.TextXAlignment = Enum.TextXAlignment.Left
cardInvite.Parent = card

spacer(discordTab, 10)
button(discordTab, "Copy Discord Invite", "Copies invite link", function()
    if setclipboard then setclipboard("discord.gg/sslr") end
end)
button(discordTab, "Refresh Discord Info", "Refetches community info", function() end)
button(discordTab, "Open Discord", "Attempts to open invite", function()
    pcall(function() request({ Url = "https://discord.gg/sslr", Method = "GET" }) end)
end)

local dragging, dragStart, startPos = false, nil, nil
header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
       or input.UserInputType == Enum.UserInputType.Touch then
        local mx, my = input.Position.X, input.Position.Y
        local mAbs = minBtn.AbsolutePosition
        local cAbs = closeBtn.AbsolutePosition
        if mx >= mAbs.X and mx <= mAbs.X + 28 and my >= mAbs.Y and my <= mAbs.Y + 28 then return end
        if mx >= cAbs.X and mx <= cAbs.X + 28 and my >= cAbs.Y and my <= cAbs.Y + 28 then return end
        dragging = true; dragStart = input.Position; startPos = win.Position
    end
end)
UIS.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement
       or input.UserInputType == Enum.UserInputType.Touch) then
        local d = input.Position - dragStart
        win.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X,
                                 startPos.Y.Scale, startPos.Y.Offset + d.Y)
    end
end)
UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
       or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

local resizer = Instance.new("TextButton")
resizer.Text = ""; resizer.Size = UDim2.new(0,16,0,16)
resizer.Position = UDim2.new(1,-20,1,-20)
resizer.BackgroundColor3 = T.accent; resizer.BackgroundTransparency = 0.4
resizer.BorderSizePixel = 0; resizer.AutoButtonColor = false
resizer.ZIndex = 10; resizer.Parent = win
local rc = Instance.new("UICorner"); rc.CornerRadius = UDim.new(0,4); rc.Parent = resizer
local resizing, resizeStart, startSize = false, nil, nil
resizer.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
       or input.UserInputType == Enum.UserInputType.Touch then
        resizing = true; resizeStart = input.Position; startSize = win.AbsoluteSize
    end
end)
UIS.InputChanged:Connect(function(input)
    if resizing and (input.UserInputType == Enum.UserInputType.MouseMovement
       or input.UserInputType == Enum.UserInputType.Touch) then
        local d = input.Position - resizeStart
        local w = math.clamp(startSize.X + d.X, 420, 1200)
        local h = math.clamp(startSize.Y + d.Y, 300, 800)
        win.Size = UDim2.new(0, w, 0, h)
    end
end)
UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
       or input.UserInputType == Enum.UserInputType.Touch then
        resizing = false
    end
end)

figure = Instance.new("ImageButton")
figure.Name = "ToggleIcon"
figure.Size = UDim2.new(0, ICON_SIZE, 0, ICON_SIZE)
figure.Position = UDim2.new(1, -(ICON_SIZE + 20), 1, -(ICON_SIZE + 20))
figure.BackgroundColor3 = Color3.fromRGB(20,20,26)
figure.BackgroundTransparency = 0.1
figure.BorderSizePixel = 0; figure.AutoButtonColor = false
figure.ZIndex = 20; figure.Parent = gui
local figCorner = Instance.new("UICorner"); figCorner.CornerRadius = UDim.new(0,12); figCorner.Parent = figure
figStroke = Instance.new("UIStroke"); figStroke.Color = UIState.MobileButtonColor; figStroke.Thickness = 2; figStroke.Parent = figure
innerGlow = Instance.new("Frame")
innerGlow.Size = UDim2.new(0.8,0,0.8,0); innerGlow.Position = UDim2.new(0.1,0,0.1,0)
innerGlow.BackgroundColor3 = UIState.MobileButtonColor; innerGlow.BackgroundTransparency = 0.85
innerGlow.BorderSizePixel = 0; innerGlow.ZIndex = 21; innerGlow.Parent = figure
local glowCorner = Instance.new("UICorner"); glowCorner.CornerRadius = UDim.new(1,0); glowCorner.Parent = innerGlow
local iconLetter = Instance.new("TextLabel")
iconLetter.Text = "S"; iconLetter.Size = UDim2.new(1,0,1,0)
iconLetter.BackgroundTransparency = 1
iconLetter.TextColor3 = Color3.fromRGB(255,255,255)
iconLetter.Font = Enum.Font.GothamBlack; iconLetter.TextSize = 32
iconLetter.ZIndex = 22; iconLetter.Parent = figure
letterStroke = Instance.new("UIStroke")
letterStroke.Color = UIState.MobileButtonColor; letterStroke.Thickness = 1.5; letterStroke.Parent = iconLetter
dot = Instance.new("Frame")
dot.Size = UDim2.new(0,10,0,10); dot.Position = UDim2.new(1,-14,0,4)
dot.BackgroundColor3 = UIState.MobileButtonColor; dot.BorderSizePixel = 0
dot.ZIndex = 23; dot.Parent = figure
local dotCorner = Instance.new("UICorner"); dotCorner.CornerRadius = UDim.new(1,0); dotCorner.Parent = dot

local figDragging, figStart, figStartPos, figMoved = false, nil, nil, false
figure.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
       or input.UserInputType == Enum.UserInputType.Touch then
        figDragging = true; figMoved = false
        figStart = input.Position; figStartPos = figure.Position
    end
end)
UIS.InputChanged:Connect(function(input)
    if figDragging and (input.UserInputType == Enum.UserInputType.MouseMovement
       or input.UserInputType == Enum.UserInputType.Touch) then
        local d = input.Position - figStart
        if math.abs(d.X) > 6 or math.abs(d.Y) > 6 then figMoved = true end
        figure.Position = UDim2.new(figStartPos.X.Scale, figStartPos.X.Offset + d.X,
                                    figStartPos.Y.Scale, figStartPos.Y.Offset + d.Y)
    end
end)
UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
       or input.UserInputType == Enum.UserInputType.Touch then
        if figDragging and not figMoved then
            win.Visible = not win.Visible
            UI_OPEN = win.Visible
        end
        figDragging = false
    end
end)

minBtn.MouseButton1Click:Connect(function() win.Visible = false; UI_OPEN = false end)
closeBtn.MouseButton1Click:Connect(function()
    gui:Destroy(); fovGui:Destroy(); siGui:Destroy(); espGui:Destroy()
    if espWorld then espWorld:Destroy() end
end)
UIS.InputBegan:Connect(function(input, processed)
    if processed then return end
    if input.KeyCode == UIState.Keybind then
        win.Visible = not win.Visible
        UI_OPEN = win.Visible
    end
end)

win.Visible = true
UI_OPEN = true
switchTab("Auto Farm")

print("[SSLR] Loaded v1.8.1")
