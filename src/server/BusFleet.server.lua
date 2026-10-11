-- Indian Bus Driver Simulator — procedural 3D bus fleet
-- Rojo location: src/server/BusFleet.server.lua
-- Builds original Roblox 3D bus models from Parts at runtime; no external assets required.

local Workspace = game:GetService("Workspace")
local fleetFolder = Workspace:FindFirstChild("BusFleet") or Instance.new("Folder")
fleetFolder.Name = "BusFleet"
fleetFolder.Parent = Workspace
fleetFolder:ClearAllChildren()

local depot = Workspace:FindFirstChild("BusDepot")
if not depot then
    depot = Instance.new("Part")
    depot.Name = "BusDepot"
    depot.Size = Vector3.new(180, 1, 130)
    depot.Position = Vector3.new(0, -0.15, 0)
    depot.Anchored = true
    depot.Material = Enum.Material.Concrete
    depot.Color = Color3.fromRGB(76, 83, 87)
    depot.Parent = Workspace
end

local function part(model, name, size, cf, color, material, shape)
    local p = Instance.new("Part")
    p.Name = name
    p.Size = size
    p.CFrame = cf
    p.Anchored = true
    p.CanCollide = true
    p.TopSurface = Enum.SurfaceType.Smooth
    p.BottomSurface = Enum.SurfaceType.Smooth
    p.Color = color
    p.Material = material or Enum.Material.SmoothPlastic
    if shape then p.Shape = shape end
    p.Parent = model
    return p
end

local function makeBus(def, index)
    local model = Instance.new("Model")
    model.Name = def.name
    model:SetAttribute("BusType", def.kind)
    model:SetAttribute("CanDrive", false) -- driving controls are a later gameplay step
    model.Parent = fleetFolder

    local x = -48 + ((index - 1) % 3) * 48
    local z = -25 + math.floor((index - 1) / 3) * 48
    local base = CFrame.new(x, 0, z)
    local body = def.body
    local dark = Color3.fromRGB(24, 33, 43)
    local glass = Color3.fromRGB(60, 133, 165)
    local rubber = Color3.fromRGB(18, 20, 23)
    local metal = Color3.fromRGB(175, 185, 190)

    -- Bus faces toward +Z. Main body and lower chassis.
    part(model, "LowerChassis", Vector3.new(10, 1.1, 22), base * CFrame.new(0, 2.1, 0), dark, Enum.Material.Metal)
    part(model, "MainBody", Vector3.new(9.5, 4.7, 21), base * CFrame.new(0, 4.6, 0), body, Enum.Material.Metal)
    part(model, "Roof", Vector3.new(9.65, 0.45, 21.2), base * CFrame.new(0, 7.15, 0), def.roof or body, Enum.Material.Metal)
    part(model, "FrontBumper", Vector3.new(9.7, 0.55, 0.6), base * CFrame.new(0, 2.45, 10.85), metal, Enum.Material.Metal)
    part(model, "RearBumper", Vector3.new(9.7, 0.45, 0.5), base * CFrame.new(0, 2.4, -10.8), metal, Enum.Material.Metal)

    -- Large front windscreen split into two panes.
    part(model, "FrontWindshieldLeft", Vector3.new(4.25, 1.75, 0.12), base * CFrame.new(-2.2, 5.95, 10.57), glass, Enum.Material.Glass)
    part(model, "FrontWindshieldRight", Vector3.new(4.25, 1.75, 0.12), base * CFrame.new(2.2, 5.95, 10.57), glass, Enum.Material.Glass)
    part(model, "DestinationBoard", Vector3.new(6.5, 0.55, 0.18), base * CFrame.new(0, 7.0, 10.62), Color3.fromRGB(15, 22, 20), Enum.Material.SmoothPlastic)

    -- Side passenger windows and window dividers on both sides.
    for _, side in ipairs({-1, 1}) do
        local sideName = side == -1 and "Left" or "Right"
        for i = 1, 5 do
            local zz = 7.6 - (i - 1) * 3.0
            part(model, sideName .. "Window" .. i, Vector3.new(0.12, 1.65, 2.45),
                base * CFrame.new(side * 4.82, 5.85, zz), glass, Enum.Material.Glass)
            part(model, sideName .. "WindowDivider" .. i, Vector3.new(0.18, 1.8, 0.12),
                base * CFrame.new(side * 4.9, 5.85, zz), metal, Enum.Material.Metal)
        end
        -- Side stripe, mirror and entry door.
        part(model, sideName .. "PaintStripe", Vector3.new(0.13, 0.38, 20.2),
            base * CFrame.new(side * 4.86, 3.75, 0), def.stripe, Enum.Material.SmoothPlastic)
        part(model, sideName .. "MirrorArm", Vector3.new(0.75, 0.12, 0.12),
            base * CFrame.new(side * 5.25, 5.5, 9.5), dark, Enum.Material.Metal)
        part(model, sideName .. "Mirror", Vector3.new(0.18, 0.65, 0.48),
            base * CFrame.new(side * 5.6, 5.55, 9.5), metal, Enum.Material.Metal)
    end

    -- Front grille, headlights, indicators, tail lamps.
    part(model, "FrontGrille", Vector3.new(3.0, 0.7, 0.12), base * CFrame.new(0, 3.05, 10.58), dark, Enum.Material.Metal)
    for _, side in ipairs({-1, 1}) do
        part(model, "Headlight" .. side, Vector3.new(1.15, 0.55, 0.18),
            base * CFrame.new(side * 3.45, 3.15, 10.62), Color3.fromRGB(255, 239, 175), Enum.Material.Neon)
        part(model, "Indicator" .. side, Vector3.new(0.45, 0.22, 0.18),
            base * CFrame.new(side * 4.1, 2.75, 10.62), Color3.fromRGB(255, 130, 30), Enum.Material.Neon)
        part(model, "TailLamp" .. side, Vector3.new(0.65, 0.7, 0.16),
            base * CFrame.new(side * 3.65, 3.15, -10.62), Color3.fromRGB(220, 40, 35), Enum.Material.Neon)
    end

    -- Six detailed wheels, with metallic hubs.
    for _, side in ipairs({-1, 1}) do
        for _, zz in ipairs({-7.1, 7.1}) do
            local wheel = part(model, "Wheel", Vector3.new(2.5, 2.5, 0.72),
                base * CFrame.new(side * 4.9, 1.55, zz) * CFrame.Angles(0, 0, math.rad(90)),
                rubber, Enum.Material.Rubber, Enum.PartType.Cylinder)
            wheel.CanCollide = true
            part(model, "WheelHub", Vector3.new(1.05, 1.05, 0.76),
                wheel.CFrame, metal, Enum.Material.Metal, Enum.PartType.Cylinder)
        end
    end

    -- Rear engine hatch, roof ventilation and interior seats visible through glazing.
    part(model, "RearEnginePanel", Vector3.new(5.8, 1.4, 0.16), base * CFrame.new(0, 4.2, -10.62), dark, Enum.Material.Metal)
    for i = 1, 4 do
        part(model, "RoofVent" .. i, Vector3.new(1.5, 0.12, 1.0),
            base * CFrame.new(0, 7.45, -6 + (i - 1) * 3.5), metal, Enum.Material.Metal)
    end
    for row = 1, 5 do
        local zz = 6.5 - row * 2.5
        for _, side in ipairs({-1, 1}) do
            part(model, "PassengerSeat", Vector3.new(2.0, 0.35, 1.0),
                base * CFrame.new(side * 1.8, 3.15, zz), def.seat or Color3.fromRGB(45, 80, 110), Enum.Material.Fabric)
            part(model, "SeatBack", Vector3.new(2.0, 1.15, 0.25),
                base * CFrame.new(side * 1.8, 3.8, zz - 0.38), def.seat or Color3.fromRGB(45, 80, 110), Enum.Material.Fabric)
        end
    end

    -- Route board label uses a surface GUI so each model is identifiable in-game.
    local board = Instance.new("BillboardGui")
    board.Name = "BusNameplate"
    board.Size = UDim2.fromOffset(230, 44)
    board.StudsOffset = Vector3.new(0, 5.2, 0)
    board.AlwaysOnTop = true
    board.Parent = body
    local label = Instance.new("TextLabel")
    label.Size = UDim2.fromScale(1, 1)
    label.BackgroundColor3 = Color3.fromRGB(10, 20, 30)
    label.BackgroundTransparency = 0.12
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextScaled = true
    label.Font = Enum.Font.GothamBold
    label.Text = def.name
    label.Parent = board

    model.PrimaryPart = body
    return model
end

local buses = {
    {name = "INDIA EXPRESS Coach", kind = "Luxury Coach", body = Color3.fromRGB(22, 65, 125), stripe = Color3.fromRGB(255, 190, 35), seat = Color3.fromRGB(45, 75, 120)},
    {name = "INTERCITY AC", kind = "AC Coach", body = Color3.fromRGB(220, 225, 230), roof = Color3.fromRGB(40, 75, 105), stripe = Color3.fromRGB(30, 135, 180), seat = Color3.fromRGB(45, 80, 110)},
    {name = "STATE TRANSPORT", kind = "State Bus", body = Color3.fromRGB(185, 40, 38), stripe = Color3.fromRGB(245, 210, 65), seat = Color3.fromRGB(110, 45, 35)},
    {name = "RURAL CONNECT", kind = "Rural Bus", body = Color3.fromRGB(40, 125, 65), stripe = Color3.fromRGB(245, 225, 145), seat = Color3.fromRGB(45, 95, 55)},
    {name = "CITY LINER", kind = "City Bus", body = Color3.fromRGB(240, 145, 25), stripe = Color3.fromRGB(245, 245, 245), seat = Color3.fromRGB(130, 70, 25)},
    {name = "NIGHT RIDER", kind = "Sleeper Coach", body = Color3.fromRGB(42, 35, 85), stripe = Color3.fromRGB(45, 190, 210), seat = Color3.fromRGB(50, 45, 100)},
}

for i, def in ipairs(buses) do
    makeBus(def, i)
end


-- Small roadside bus stop at the depot corner.
local stopFolder = Workspace:FindFirstChild("BusStopCorner") or Instance.new("Folder")
stopFolder.Name = "BusStopCorner"
stopFolder.Parent = Workspace
stopFolder:ClearAllChildren()

local stopBase = Vector3.new(73, 0, 43)
local function stopPart(name, size, offset, color, material)
    local p = Instance.new("Part")
    p.Name = name
    p.Size = size
    p.Position = stopBase + offset
    p.Anchored = true
    p.CanCollide = true
    p.Color = color
    p.Material = material or Enum.Material.SmoothPlastic
    p.TopSurface = Enum.SurfaceType.Smooth
    p.BottomSurface = Enum.SurfaceType.Smooth
    p.Parent = stopFolder
    return p
end

stopPart("Platform", Vector3.new(18, 0.35, 10), Vector3.new(0, 0.2, 0), Color3.fromRGB(130, 133, 125), Enum.Material.Concrete)
stopPart("ShelterRoof", Vector3.new(12, 0.5, 6), Vector3.new(0, 8, 0), Color3.fromRGB(28, 85, 68), Enum.Material.Metal)
for _, xOffset in ipairs({-5, 5}) do
    stopPart("ShelterPost", Vector3.new(0.35, 7.5, 0.35), Vector3.new(xOffset, 4, 0), Color3.fromRGB(175, 184, 180), Enum.Material.Metal)
end
stopPart("BenchSeat", Vector3.new(5, 0.35, 1), Vector3.new(0, 2, -1.2), Color3.fromRGB(115, 73, 42), Enum.Material.Wood)
stopPart("BenchBack", Vector3.new(5, 1.5, 0.25), Vector3.new(0, 2.8, -1.7), Color3.fromRGB(115, 73, 42), Enum.Material.Wood)
stopPart("SignPole", Vector3.new(0.25, 7, 0.25), Vector3.new(-7, 3.5, 1), Color3.fromRGB(175, 185, 190), Enum.Material.Metal)
local sign = stopPart("BusStopSign", Vector3.new(4.5, 2.2, 0.25), Vector3.new(-7, 6.4, 1), Color3.fromRGB(20, 110, 72), Enum.Material.Metal)
local signGui = Instance.new("SurfaceGui")
signGui.Face = Enum.NormalId.Front
signGui.CanvasSize = Vector2.new(450, 220)
signGui.Parent = sign
local signText = Instance.new("TextLabel")
signText.Size = UDim2.fromScale(1, 1)
signText.BackgroundTransparency = 1
signText.Text = "BUS STOP\nAGARTALA"
signText.TextColor3 = Color3.new(1, 1, 1)
signText.TextScaled = true
signText.Font = Enum.Font.GothamBlack
signText.Parent = signGui

local stopMarker = Instance.new("BillboardGui")
stopMarker.Name = "BusStopWorldMarker"
stopMarker.Size = UDim2.fromOffset(150, 35)
stopMarker.StudsOffset = Vector3.new(0, 10, 0)
stopMarker.AlwaysOnTop = true
stopMarker.Parent = sign
local stopLabel = Instance.new("TextLabel")
stopLabel.Size = UDim2.fromScale(1, 1)
stopLabel.BackgroundColor3 = Color3.fromRGB(15, 35, 29)
stopLabel.BackgroundTransparency = 0.1
stopLabel.Text = "BUS STOP"
stopLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
stopLabel.TextScaled = true
stopLabel.Font = Enum.Font.GothamBold
stopLabel.Parent = stopMarker

print("Indian Bus Driver Simulator: generated " .. #buses .. " buses and an Agartala corner bus stop")
