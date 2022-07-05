--[[ june 17 update log:
+ Switched To Orion UI
+ Fixed Silent Aim
+ Fixed Invisible
+ Fixed No Gun Bob
+ Added CTRL+Click TP
+ Added Dead FOV
+ Added FOV Follows Recoil
]]
DarkHub_Client = {SavedSettings = false}
if isfolder and makefolder and not isfolder('DarkHub') then
    makefolder('DarkHub')
    DarkHub_Client.SaveSettings = true
    if isfile('DarkHub/DarkHub_'..tostring(Game.PlaceId)..'.DARKHUB') then
        DarkHub_Client.SavedSettings = true
        DarkHub_Client.GameSettings = game:GetService('HttpService'):JSONDecode(readfile('DarkHub/DarkHub_'..tostring(Game.PlaceId)..'.DARKHUB'))
    end
elseif isfolder('DarkHub') then
    DarkHub_Client.SaveSettings = true
    if isfile('DarkHub/DarkHub_'..tostring(Game.PlaceId)..'.DARKHUB') then
        DarkHub_Client.SavedSettings = true
        DarkHub_Client.GameSettings = game:GetService('HttpService'):JSONDecode(readfile('DarkHub/DarkHub_'..tostring(Game.PlaceId)..'.DARKHUB'))
    end
else
    DarkHub_Client.SaveSettings = false
end

--Client Values that will save basicly
IsUpToDate = pcall(function()
    Client = {
        Toggles = {
            SilentAim = DarkHub_Client.SavedSettings and DarkHub_Client.GameSettings.Toggles.SilentAim or false,
            VisibleCheck = DarkHub_Client.SavedSettings and DarkHub_Client.GameSettings.Toggles.VisibleCheck or false,
            Head = DarkHub_Client.SavedSettings and DarkHub_Client.GameSettings.Toggles.Head or false,
            UseFov = DarkHub_Client.SavedSettings and DarkHub_Client.GameSettings.Toggles.UseFov or false,
            UseDeadFov = DarkHub_Client.SavedSettings and DarkHub_Client.GameSettings.Toggles.UseDeadFov or false,
            FollowRecoil = DarkHub_Client.SavedSettings and DarkHub_Client.GameSettings.Toggles.FollowRecoil or false,
            NoRecoil = DarkHub_Client.SavedSettings and DarkHub_Client.GameSettings.Toggles.NoRecoil or false,
            NoSpread = DarkHub_Client.SavedSettings and DarkHub_Client.GameSettings.Toggles.NoSpread or false,
            SmallCrosshair = DarkHub_Client.SavedSettings and DarkHub_Client.GameSettings.Toggles.SmallCrosshair or false,
            NoSway = DarkHub_Client.SavedSettings and DarkHub_Client.GameSettings.Toggles.NoSway or false,
            NoBob = DarkHub_Client.SavedSettings and DarkHub_Client.GameSettings.Toggles.NoBob or false,
            NoCamBob = DarkHub_Client.SavedSettings and DarkHub_Client.GameSettings.Toggles.NoCamBob or false,
            Boxes = DarkHub_Client.SavedSettings and DarkHub_Client.GameSettings.Toggles.Boxes or false,
            Tracers = DarkHub_Client.SavedSettings and DarkHub_Client.GameSettings.Toggles.Tracers or false,
            Skeleton = DarkHub_Client.SavedSettings and DarkHub_Client.GameSettings.Toggles.Skeleton or false,
            Invisible = DarkHub_Client.SavedSettings and DarkHub_Client.GameSettings.Toggles.Invisible or false,
            ClickTp = DarkHub_Client.SavedSettings and DarkHub_Client.GameSettings.Toggles.ClickTp or false
        },
        Values = {
            Fov = DarkHub_Client.SavedSettings and DarkHub_Client.GameSettings.Values.Fov or 500,
            DeadFov = DarkHub_Client.SavedSettings and DarkHub_Client.GameSettings.Values.DeadFov or 50,
            WalkSpeed = DarkHub_Client.SavedSettings and DarkHub_Client.GameSettings.Values.WalkSpeed or 0,
            JumpPower = DarkHub_Client.SavedSettings and DarkHub_Client.GameSettings.Values.JumpPower or 0
        }
    }
end)

if not IsUpToDate and DarkHub_Client.SavedSettings and isfile('DarkHub/DarkHub_'..tostring(Game.PlaceId)..'.DARKHUB') then
    delfile('DarkHub/DarkHub_'..tostring(Game.PlaceId)..'.DARKHUB')
    game.Players.LocalPlayer:Kick('DarkHub Settings Out Of Date - Issue Fixed | Restart DarkHub to Continue')
end

local orion = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()
local window = orion:MakeWindow({Name = "Darkhub Phantom Forces", HidePremium = false})
local Aimbot = window:MakeTab({
    Name = "Combat",
})
local GunMods = window:MakeTab({
    Name = "Gun Mods",
})
local Esp = window:MakeTab({
    Name = "Esp",
})
local Misc = window:MakeTab({
    Name = "Miscellaneous",
})
local FovCircle = Drawing.new("Circle")
FovCircle.Visible = Client.Toggles.UseFov
FovCircle.Radius = Client.Values.Fov
FovCircle.Color = Color3.new(1, 1, 1)
FovCircle.Thickness = 1
FovCircle.Position = Vector2.new(workspace.Camera.ViewportSize.X * 0.5, workspace.Camera.ViewportSize.Y * 0.5)

local DeadFovCircle = Drawing.new("Circle")
DeadFovCircle.Visible = Client.Toggles.UseDeadFov
DeadFovCircle.Radius = Client.Values.DeadFov
DeadFovCircle.Color = Color3.new(1, 1, 1)
DeadFovCircle.Thickness = 1
DeadFovCircle.Position = Vector2.new(workspace.Camera.ViewportSize.X * 0.5, workspace.Camera.ViewportSize.Y * 0.5)

local whitelistedcharacters = "abcdefghijklmnopqrstuvwxyz"


local funcs, tables = (function()
    function CountTable(t)
        local c = 0
        for _ in next, t do c = c + 1 end
        return c
    end
    
    local FunctionsToObtain = { {
        name = "breakwindow";
    }; {
        name = "muzzleflash";
    }; {
        name = "setspectate";
    }; {
        name = "setmovementmode";
    }; {
        name = "setsprint";
    }; {
        name = "controllerstep";
    }; {
        name = "step";
        storage_name = "camera_step";
        script_check = function(source)
            return source:find("camera")
        end
    }; {
        name = "loadgun";
    }; {
        name = "getbodyparts";
    }; {
        name = "new";
        storage_name = "particle_new";
        script_check = function(source)
            return source:find("particle")
        end
    }}
    
    function FunctionCheck(Function)
        for i, FunctionInfo in next, FunctionsToObtain do
            local FFunctionInfo = getinfo(Function)
    
            local FunctionName  = FunctionInfo.name 
            local FFunctionName = FFunctionInfo.name
    
    
            if FunctionName == FFunctionName then
    
                local ScriptCheck = FunctionInfo.script_check
                local StorageName = FunctionInfo.storage_name
    
                if ScriptCheck then
                    local IsValidScript = ScriptCheck(FFunctionInfo.source)
                    if IsValidScript then
                        return StorageName or FunctionName
                    end
                    return false
                end
    
                return StorageName or FunctionName
            end
        end
    end
    
    local ObtainedFunctions = {}
    
    for i,v in next, getgc() do
        if type(v) == "function" and islclosure(v) and not is_synapse_function(v) then
            local valid_name = FunctionCheck(v)
            if valid_name then
                ObtainedFunctions[valid_name] = v
            end
        end
    end
    
    local ObtainedAllFunctions = #FunctionsToObtain == CountTable(ObtainedFunctions)
    
    
    ObtainedFunctions["fromaxisangle"]  = debug.getupvalue(ObtainedFunctions.camera_step, 11)
    ObtainedFunctions["gunbob"]         = debug.getupvalue(ObtainedFunctions.loadgun, 58)
    ObtainedFunctions["gunsway"]        = debug.getupvalue(ObtainedFunctions.loadgun, 59)
    local ObtainedTables = {} do
        ObtainedTables["network"]           = debug.getupvalue(ObtainedFunctions.breakwindow, 1)
        ObtainedTables["char"]              = debug.getupvalue(ObtainedFunctions.muzzleflash, 2)
        ObtainedTables["replication"]       = debug.getupvalue(ObtainedFunctions.setspectate, 1)
        ObtainedTables["hud"]               = debug.getupvalue(ObtainedFunctions.setmovementmode, 10)
        ObtainedTables["gamelogic"]         = debug.getupvalue(ObtainedFunctions.setsprint, 1)
        ObtainedTables["input"]             = debug.getupvalue(ObtainedFunctions.controllerstep, 2)
        ObtainedTables["gunrequire"]        = debug.getupvalue(ObtainedFunctions.loadgun, 2)
        ObtainedTables["chartable"]         = debug.getupvalue(ObtainedFunctions.getbodyparts, 1)
    end

    for i,v in next, getgc(true) do
        if type(v) == "table" and rawget(v, "step") == ObtainedFunctions.camera_step then
            ObtainedTables["camera"] = v
        end
    end

    return ObtainedFunctions, ObtainedTables
end)()


local physicsignore = {workspace.Players, workspace.Camera, workspace.Ignore}
local userinputservice = game:GetService("UserInputService")
local runservice = game:GetService("RunService")
local workspace = game:GetService("Workspace")
local players = game:GetService("Players")
local localplayer = players.LocalPlayer
local mouse = localplayer:GetMouse()
local rendertime = tick()
local playeresp = {}
local v3 = Vector3.new()
local newcf = CFrame.new()
local dot = v3.Dot
local accel = Vector3.new(0, -workspace.Gravity, 0)
local badtick, add, reset = tick(), 0, true



--Framework under this along with ui elements

Aimbot:AddToggle({Name = "Silent Aim", Default = Client.Toggles.SilentAim, Callback = function(boolean)
    Client.Toggles.SilentAim = boolean  
    writefile('DarkHub/DarkHub_'..tostring(Game.PlaceId)..'.DARKHUB',game:GetService('HttpService'):JSONEncode({['Toggles'] = Client.Toggles,['Values'] = Client.Values}))    
end})

Aimbot:AddToggle({Name = "Visible Check", Default = Client.Toggles.VisibleCheck, Callback = function(boolean)
    Client.Toggles.VisibleCheck = boolean
    writefile('DarkHub/DarkHub_'..tostring(Game.PlaceId)..'.DARKHUB',game:GetService('HttpService'):JSONEncode({['Toggles'] = Client.Toggles,['Values'] = Client.Values}))    
end})

Aimbot:AddToggle({Name = "Head Shots Only", Default = Client.Toggles.Head, Callback = function(boolean)
    Client.Toggles.Head = boolean
    writefile('DarkHub/DarkHub_'..tostring(Game.PlaceId)..'.DARKHUB',game:GetService('HttpService'):JSONEncode({['Toggles'] = Client.Toggles,['Values'] = Client.Values}))    
end})

Aimbot:AddToggle({Name = "Use Fov", Default = Client.Toggles.UseFov, Callback = function(boolean)
    Client.Toggles.UseFov = boolean
    FovCircle.Visible = boolean
    writefile('DarkHub/DarkHub_'..tostring(Game.PlaceId)..'.DARKHUB',game:GetService('HttpService'):JSONEncode({['Toggles'] = Client.Toggles,['Values'] = Client.Values}))    
end})

Aimbot:AddToggle({Name = "Use Dead Fov", Default = Client.Toggles.UseDeadFov, Callback = function(boolean)
    Client.Toggles.UseDeadFov = boolean
    DeadFovCircle.Visible = boolean
    writefile('DarkHub/DarkHub_'..tostring(Game.PlaceId)..'.DARKHUB',game:GetService('HttpService'):JSONEncode({['Toggles'] = Client.Toggles,['Values'] = Client.Values}))    
end})

Aimbot:AddToggle({Name = "Fov Follows Recoil", Default = Client.Toggles.FollowRecoil, Callback = function(boolean)
    Client.Toggles.FollowRecoil = boolean
    writefile('DarkHub/DarkHub_'..tostring(Game.PlaceId)..'.DARKHUB',game:GetService('HttpService'):JSONEncode({['Toggles'] = Client.Toggles,['Values'] = Client.Values}))    
end})

Aimbot:AddSlider({Name = "Fov", Min = 1, Max = 1000, Default = 500, Color = Color3.fromRGB(255,255,255), Increment = 1, ValueName = "°", Callback = function(number)
    Client.Values.Fov = number
    FovCircle.Radius = number
    writefile('DarkHub/DarkHub_'..tostring(Game.PlaceId)..'.DARKHUB',game:GetService('HttpService'):JSONEncode({['Toggles'] = Client.Toggles,['Values'] = Client.Values}))    
end})

Aimbot:AddSlider({Name = "Dead Fov", Min = 1, Max = 1000, Default = 50, Color = Color3.fromRGB(255,255,255), Increment = 1, ValueName = "°", Callback = function(number)
    Client.Values.DeadFov = number
    DeadFovCircle.Radius = number
    writefile('DarkHub/DarkHub_'..tostring(Game.PlaceId)..'.DARKHUB',game:GetService('HttpService'):JSONEncode({['Toggles'] = Client.Toggles,['Values'] = Client.Values}))    
end})

GunMods:AddToggle({Name = "No Recoil", Default = Client.Toggles.NoRecoil, Callback = function(boolean)
    Client.Toggles.NoRecoil = boolean
    writefile('DarkHub/DarkHub_'..tostring(Game.PlaceId)..'.DARKHUB',game:GetService('HttpService'):JSONEncode({['Toggles'] = Client.Toggles,['Values'] = Client.Values}))    
end})

GunMods:AddToggle({Name = "No Spread", Default = Client.Toggles.NoSpread, Callback = function(boolean)
    Client.Toggles.NoSpread = boolean
    writefile('DarkHub/DarkHub_'..tostring(Game.PlaceId)..'.DARKHUB',game:GetService('HttpService'):JSONEncode({['Toggles'] = Client.Toggles,['Values'] = Client.Values}))    
end})

GunMods:AddToggle({Name = "Small Crosshair", Default = Client.Toggles.SmallCrosshair, Callback = function(boolean)
    Client.Toggles.SmallCrosshair = boolean
    writefile('DarkHub/DarkHub_'..tostring(Game.PlaceId)..'.DARKHUB',game:GetService('HttpService'):JSONEncode({['Toggles'] = Client.Toggles,['Values'] = Client.Values}))    
end})

GunMods:AddToggle({Name = "No Sway", Default = Client.Toggles.NoSway, Callback = function(boolean)
    Client.Toggles.NoSway = boolean
    writefile('DarkHub/DarkHub_'..tostring(Game.PlaceId)..'.DARKHUB',game:GetService('HttpService'):JSONEncode({['Toggles'] = Client.Toggles,['Values'] = Client.Values}))    
end})

GunMods:AddToggle({Name = "No Bob", Default = Client.Toggles.NoBob, Callback = function(boolean)
    Client.Toggles.NoBob = boolean
    writefile('DarkHub/DarkHub_'..tostring(Game.PlaceId)..'.DARKHUB',game:GetService('HttpService'):JSONEncode({['Toggles'] = Client.Toggles,['Values'] = Client.Values}))    
end})

GunMods:AddToggle({Name = "No Camera Bob", Default = Client.Toggles.NoCamBob, Callback = function(boolean)
    Client.Toggles.NoCamBob = boolean
    writefile('DarkHub/DarkHub_'..tostring(Game.PlaceId)..'.DARKHUB',game:GetService('HttpService'):JSONEncode({['Toggles'] = Client.Toggles,['Values'] = Client.Values}))    
end})

Esp:AddToggle({Name = "Box Esp", Default = Client.Toggles.Boxes, Callback = function(boolean)
    Client.Toggles.Boxes = boolean
    writefile('DarkHub/DarkHub_'..tostring(Game.PlaceId)..'.DARKHUB',game:GetService('HttpService'):JSONEncode({['Toggles'] = Client.Toggles,['Values'] = Client.Values}))    
end})

Esp:AddToggle({Name = "Tracer Esp", Default = Client.Toggles.Tracers, Callback = function(boolean)
    Client.Toggles.Tracers = boolean
    writefile('DarkHub/DarkHub_'..tostring(Game.PlaceId)..'.DARKHUB',game:GetService('HttpService'):JSONEncode({['Toggles'] = Client.Toggles,['Values'] = Client.Values}))    
end})

Esp:AddToggle({Name = "Skeleton Esp", Default = Client.Toggles.Skeleton, Callback = function(boolean)
    Client.Toggles.Skeleton = boolean
    writefile('DarkHub/DarkHub_'..tostring(Game.PlaceId)..'.DARKHUB',game:GetService('HttpService'):JSONEncode({['Toggles'] = Client.Toggles,['Values'] = Client.Values}))    
end})

Misc:AddSlider({Name = "Walk Speed", Min = 0, Max = 100, Default = 0, Color = Color3.fromRGB(255,255,255), Increment = 1, ValueName = "", Callback = function(number)
    Client.Values.WalkSpeed = number

    if tables.char.alive then
        tables.char:setbasewalkspeed(tables.gamelogic.currentgun.data.walkspeed + number)
    end
    writefile('DarkHub/DarkHub_'..tostring(Game.PlaceId)..'.DARKHUB',game:GetService('HttpService'):JSONEncode({['Toggles'] = Client.Toggles,['Values'] = Client.Values}))    
end})

Misc:AddSlider({Name = "Jump Power", Min = 0, Max = 100, Default = 0, Color = Color3.fromRGB(255,255,255), Increment = 1, ValueName = "", Callback = function(number)
    Client.Values.JumpPower = number
    writefile('DarkHub/DarkHub_'..tostring(Game.PlaceId)..'.DARKHUB',game:GetService('HttpService'):JSONEncode({['Toggles'] = Client.Toggles,['Values'] = Client.Values}))    
end})

local Gravity = workspace.Gravity
Misc:AddSlider({Name = "Gravity", Min = 0, Max = 100, Default = 0, Color = Color3.fromRGB(255,255,255), Increment = 1, ValueName = "", Callback = function(number)
    workspace.Gravity = (Gravity * 0.01) * (100 - number)
    writefile('DarkHub/DarkHub_'..tostring(Game.PlaceId)..'.DARKHUB',game:GetService('HttpService'):JSONEncode({['Toggles'] = Client.Toggles,['Values'] = Client.Values}))    
end})


--[[
Misc:AddToggle({Name = "Invisible", Default = Client.Toggles.Invisible, Callback = function(boolean)
    Client.Toggles.Invisible = boolean
    reset = true
    writefile('DarkHub/DarkHub_'..tostring(Game.PlaceId)..'.DARKHUB',game:GetService('HttpService'):JSONEncode({['Toggles'] = Client.Toggles,['Values'] = Client.Values}))    
end})

Misc:AddToggle({Name = "Ctrl+Click Teleport", Default = Client.Toggles.ClickTp, Callback = function(boolean)
    Client.Toggles.ClickTp = boolean
    writefile('DarkHub/DarkHub_'..tostring(Game.PlaceId)..'.DARKHUB',game:GetService('HttpService'):JSONEncode({['Toggles'] = Client.Toggles,['Values'] = Client.Values}))    
end})
]]
function trajectory(o, a, t, s, e)
    local f = -a
    local ld = t - o
    local a = dot(f, f)
    local b = 4 * dot(ld, ld)
    local k = (4 * (dot(f, ld) + s * s)) / (2 * a)
    local v = (k * k - b / a) ^ 0.5
    local t, t0 = k - v, k + v

    if not (t > 0) then
        t = t0
    end

    t = t ^ 0.5
    return f * t / 2 + (e or v3) + ld / t, t
end

function isvisible(o, t)
    local dist = (o - t).Magnitude
    local part = workspace:FindPartOnRayWithIgnoreList(Ray.new(o, (t - o).Unit * dist), physicsignore)

    return part == nil or part.Transparency ~= 0
end

function getclosest()
    local closest, pos, maxdist = nil, nil, Client.Toggles.UseFov and Client.Values.Fov or math.huge

    for i, v in pairs(tables.chartable) do
        if i.Team ~= localplayer.Team and v.head then
            local screenpos, visible = workspace.Camera:WorldToViewportPoint(v.head.Position)
            local distance = (FovCircle.Position - Vector2.new(screenpos.X, screenpos.Y)).Magnitude

            if visible and (not Client.Toggles.VisibleCheck or isvisible(tables.camera.cframe.Position, v.head.Position)) and distance < maxdist and (not Client.Toggles.UseDeadFov or distance > Client.Values.DeadFov) then
                closest = i
                pos = v[Client.Toggles.Head and "head" or "torso"].Position
                maxdist = distance
            end
        end
    end

    return closest, pos
end

local old; old = hookfunction(funcs.particle_new, function(data)
    if tables.gamelogic.currentgun and tables.gamelogic.currentgun.barrel and Client.Toggles.SilentAim and tables.gamelogic.currentgun and (data.visualorigin == tables.gamelogic.currentgun.barrel.Position or data.visualorigin == tables.gamelogic.currentgun.aimsightdata[1].sightpart.Position) then
        local closest, pos = getclosest()

        if closest then
            data.velocity = trajectory(data.visualorigin, accel, pos, tables.gamelogic.currentgun.data.bulletspeed)
            data.position = data.visualorigin + data.velocity.Unit
        end
    end

    return old(data)
end)



local old_send = tables.network.send 
tables.network.send = function(self, name, ...)
    local args = {...}

    if name == "newbullets" then
        if Client.Toggles.SilentAim then
            local closest, pos = getclosest()

            if closest and tables.gamelogic.currentgun then
                local velocity = trajectory(args[1].firepos, accel, pos, tables.gamelogic.currentgun.data.bulletspeed)
                
                for i = 1, #args[1].bullets do
                    args[1].bullets[i][1] = velocity
                end
            end
        end
    elseif name == "falldamage" then
        return
    end
--[[elseif name == "spawn" and Client.Toggles.Invisible then
        reset = true
    elseif name == "ping" and Client.Toggles.Invisible then
       --reset = true
       return
    elseif name == "repupdate" and Client.Toggles.Invisible then
        if reset or args[3] - badtick > 3 then
            badtick = args[3]
            reset = false
            add = 0
        end
       
        args[1] = args[1] + Vector3.new(tables.camera.cframe.LookVector.X * add * 0.01, -add, tables.camera.cframe.LookVector.Z * add * 0.01) * 5000
        args[2] = Vector2.new(0, args[2].Y)
        args[3] = badtick + add
        add = add + 0.0000025
    end
]]
    return old_send(self, name, unpack(args))
end

local old; old = hookfunction(tables.char.jump, function(self, power)
    return old(self, power + Client.Values.JumpPower)
end)


local old; old = hookfunction(tables.char.setbasewalkspeed, function(self, speed)
    return old(self, speed + Client.Values.WalkSpeed)
end)

function addesp(player)
    playeresp[player] = {
        visible = false,
        all = {},
        boxoutline = Drawing.new("Square"),
        box = Drawing.new("Square"),
        tracer = Drawing.new("Line"),
        skeleton = {
            head = Drawing.new("Line"),
            secondhead = Drawing.new("Line"),
            torso = Drawing.new("Line"),
            leftupperarm = Drawing.new("Line"),
            leftlowerarm = Drawing.new("Line"),
            rightupperarm = Drawing.new("Line"),
            rightlowerarm = Drawing.new("Line"),
            leftupperleg = Drawing.new("Line"),
            leftlowerleg = Drawing.new("Line"),
            rightupperleg = Drawing.new("Line"),
            rightlowerleg = Drawing.new("Line")
        }
    }

    table.insert(playeresp[player].all, playeresp[player].box)
    table.insert(playeresp[player].all, playeresp[player].boxoutline)
    table.insert(playeresp[player].all, playeresp[player].tracer)
    for i, v in pairs(playeresp[player].skeleton) do
        table.insert(playeresp[player].all, v)
    end

    for i, v in pairs(playeresp[player].all) do
        v.Visible = false
        v.Color = Color3.new(1, 1, 1)
        pcall(function()
            v.Thickness = 1
            v.Filled = false
        end)
    end
    playeresp[player].tracer.Color = Color3.new(1, 0, 0)
    playeresp[player].tracer.From = Vector2.new(workspace.Camera.ViewportSize.X * 0.5, 0)
    playeresp[player].boxoutline.Color = Color3.new(0, 0, 0)
    playeresp[player].boxoutline.Thickness = 3
end

function removeesp(player)
    playeresp[player].box:Remove()
    playeresp[player].tracer:Remove()
    for i, v in pairs(playeresp[player].skeleton) do
        v:Remove()
    end
    playeresp[player] = nil
end

for i, v in pairs(players:GetPlayers()) do
    if v ~= localplayer then
        addesp(v)
    end
end

players.PlayerAdded:Connect(addesp)
players.PlayerRemoving:Connect(removeesp)

function getscreenpos(position)
    local screenpos, onscreen = workspace.Camera:WorldToViewportPoint(position)

    return Vector2.new(screenpos.X, screenpos.Y), onscreen
end

function getpartends(part)
    local cf, s = part.CFrame, part.Size
    return getscreenpos(cf * Vector3.new(0, s.Y * 0.5, 0)), getscreenpos(cf * Vector3.new(0, -s.Y * 0.5, 0))
end

runservice.RenderStepped:Connect(function()
    local time = tick()

    if time - rendertime > 0.02 then
        rendertime = time

        if Client.Toggles.UseFov or Client.Toggles.UseDeadFov then
            FovCircle.Radius = (tables.char.alive and tables.char.unaimedfov / workspace.Camera.FieldOfView or 1) * Client.Values.Fov
            DeadFovCircle.Radius = (tables.char.alive and tables.char.unaimedfov / workspace.Camera.FieldOfView or 1) * Client.Values.DeadFov

            if Client.Toggles.FollowRecoil and tables.gamelogic.currentgun and tables.gamelogic.currentgun.barrel then
                local barrel = gamelogic.currentgun.barrel.CFrame
                local _, pos = workspace:FindPartOnRayWithIgnoreList(Ray.new(barrel.Position, barrel.LookVector * 100), physicsignore)
                FovCircle.Position = getscreenpos(pos)
            else
                FovCircle.Position = workspace.Camera.ViewportSize * 0.5
            end

            DeadFovCircle.Position = FovCircle.Position
        end

        for player, drawings in pairs(playeresp) do
            local char = tables.chartable[player]

            if player.Team ~= localplayer.Team and char and char.head then
                local headpos, onscreen = getscreenpos(char.head.Position)
                local torsopos = getscreenpos(char.torso.Position)

                if onscreen then
                    if not drawings.visible then
                        drawings.visible = true
    
                        drawings.box.Visible = Client.Toggles.Boxes
                        drawings.boxoutline.Visible = Client.Toggles.Boxes
                        drawings.tracer.Visible = Client.Toggles.Tracers
    
                        if Client.Toggles.Skeleton then
                            for i, v in pairs(drawings.skeleton) do
                                v.Visible = true
                            end
                        end
                    end

                    if Client.Toggles.Tracers then
                        drawings.tracer.To = headpos
                    end

                    if Client.Toggles.Boxes then
                        drawings.box.Size = Vector2.new((torsopos.Y - headpos.Y) * 3, (torsopos.Y - headpos.Y) * 4)
                        drawings.box.Position = torsopos - drawings.box.Size * 0.5
                        drawings.boxoutline.Size = drawings.box.Size
                        drawings.boxoutline.Position = drawings.box.Position
                    end

                    if Client.Toggles.Skeleton then
                        local torsotop, torsobottom = getpartends(char.torso)
                        local rarmtop, rarmbottom = getpartends(char.rarm)
                        local larmtop, larmbottom = getpartends(char.larm)
                        local rlegtop, rlegbottom = getpartends(char.rleg)
                        local llegtop, llegbottom = getpartends(char.lleg)
                        local rarm = getscreenpos(char.rarm.Position)
                        local larm = getscreenpos(char.larm.Position)
                        local rleg = getscreenpos(char.rleg.Position)
                        local lleg = getscreenpos(char.lleg.Position)
                        local endpoint = getscreenpos(char.torso.CFrame * Vector3.new(0, -char.torso.Size.Y * 0.5, -1))

                        drawings.skeleton.head.From = headpos
                        drawings.skeleton.head.To = torsotop
                        drawings.skeleton.secondhead.From = torsobottom
                        drawings.skeleton.secondhead.To = endpoint
                        drawings.skeleton.torso.From = torsobottom
                        drawings.skeleton.torso.To = torsotop
                        drawings.skeleton.leftupperarm.From = torsotop
                        drawings.skeleton.leftupperarm.To = larm
                        drawings.skeleton.leftlowerarm.From = larmbottom
                        drawings.skeleton.leftlowerarm.To = larm
                        drawings.skeleton.rightupperarm.From = torsotop
                        drawings.skeleton.rightupperarm.To = rarm
                        drawings.skeleton.rightlowerarm.From = rarmbottom
                        drawings.skeleton.rightlowerarm.To = rarm
                        drawings.skeleton.leftupperleg.From = torsobottom
                        drawings.skeleton.leftupperleg.To = lleg
                        drawings.skeleton.leftlowerleg.From = llegbottom
                        drawings.skeleton.leftlowerleg.To = lleg
                        drawings.skeleton.rightupperleg.From = torsobottom
                        drawings.skeleton.rightupperleg.To = rleg
                        drawings.skeleton.rightlowerleg.From = rlegbottom
                        drawings.skeleton.rightlowerleg.To = rleg
                    end
                elseif drawings.visible then
                    drawings.visible = false
                    drawings.box.Visible = false
                    drawings.boxoutline.Visible = false
                    drawings.tracer.Visible = false
                    
                    for i, v in pairs(drawings.skeleton) do
                        v.Visible = false
                    end
                end
            elseif drawings.visible then
                drawings.visible = false
                drawings.box.Visible = false
                drawings.boxoutline.Visible = false
                drawings.tracer.Visible = false
                
                for i, v in pairs(drawings.skeleton) do
                    v.Visible = false
                end
            end
        end
    end
end)

--[[
mouse.Button1Down:Connect(function()
    if Client.Toggles.ClickTp and tables.char.rootpart and (userinputservice:IsKeyDown(Enum.KeyCode.RightControl) or userinputservice:IsKeyDown(Enum.KeyCode.LeftControl)) then
        local camframe = tables.camera.cframe
        local localpos = camframe.Position
        local _, pos = workspace:FindPartOnRayWithIgnoreList(Ray.new(localpos, (camframe * Vector3.new(0, 0, -500)) - localpos), physicsignore)
        local dist = (localpos - pos).Magnitude - 0.1
        local cframe = CFrame.new(localpos, pos)

        for i = 1, math.floor(dist / 9.9) do
            tables.network:send("repupdate", cframe * Vector3.new(0, 0, -9.9 * i), Vector2.new(tables.camera.angles.X, tables.camera.angles.Y), tables.network:getTime())
        end

        tables.char.rootpart.Position = pos
    end
end)]]

local old; old = hookfunction(tables.gunrequire.getWeaponData, function(...)
    local data = old(...)

    setreadonly(data, false)

    if Client.Toggles.NoRecoil then
        data["aimcamkickspeed"] = 9999999
        data["camkickspeed"] = 9999999
        data["modelkickspeed"] = 9999999
    end

    if Client.Toggles.NoSpread then
        data["hipfirespreadrecover"] = 9999999
        data["hipfirespread"] = 9999999
    end

    if Client.Toggles.SmallCrosshair then
        data["crosssize"] = 1
        data["crossexpansion"] = 0
    end

    setreadonly(data, true)
        
    return data
end)

debug.setupvalue(funcs.camera_step, 11, function(...)
    return Client.Toggles.NoCamBob and newcf or funcs.fromaxisangle(...)
end)

debug.setupvalue(funcs.loadgun, 58, function(...)
    return Client.Toggles.NoBob and newcf or funcs.gunbob(...)
end)

debug.setupvalue(funcs.loadgun, 59, function(...)
    return Client.Toggles.NoSway and newcf or funcs.gunsway(...)
end)
