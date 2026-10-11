-- Procedural 3D Agartala-inspired city map for Indian Bus Driver Simulator.
-- Lightweight, mobile-friendly Parts only. Landmark layout is inspired by the city, not a surveyed 1:1 map.
local Workspace = game:GetService("Workspace")

local existing = Workspace:FindFirstChild("Agartala3DMap")
if existing then existing:Destroy() end
local map = Instance.new("Folder")
map.Name = "Agartala3DMap"
map.Parent = Workspace

local function makePart(name, size, cf, color, material, parent, anchored)
    local p = Instance.new("Part")
    p.Name = name
    p.Size = size
    p.CFrame = cf
    p.Anchored = anchored ~= false
    p.CanCollide = true
    p.TopSurface = Enum.SurfaceType.Smooth
    p.BottomSurface = Enum.SurfaceType.Smooth
    p.Color = color
    p.Material = material or Enum.Material.SmoothPlastic
    p.Parent = parent or map
    return p
end

local grass = Color3.fromRGB(83, 133, 78)
local roadColor = Color3.fromRGB(43, 48, 53)
local sidewalkColor = Color3.fromRGB(155, 155, 142)
local cream = Color3.fromRGB(220, 207, 174)
local white = Color3.fromRGB(226, 226, 213)
local teal = Color3.fromRGB(47, 119, 112)
local terracotta = Color3.fromRGB(165, 89, 62)

-- Wide ground plane and city blocks.
makePart("CityGround", Vector3.new(1400, 4, 1400), CFrame.new(0, -2.5, 0), grass, Enum.Material.Grass)
makePart("CityBase", Vector3.new(950, 0.3, 950), CFrame.new(0, -0.25, 0), Color3.fromRGB(103, 145, 88), Enum.Material.Grass)

local function roadSegment(name, a, b, width)
    local mid = (a + b) / 2
    local delta = b - a
    local length = Vector3.new(delta.X, 0, delta.Z).Magnitude
    local angle = math.atan2(delta.X, delta.Z)
    makePart(name, Vector3.new(width, 0.25, length), CFrame.new(mid.X, 0.05, mid.Z) * CFrame.Angles(0, angle, 0), roadColor, Enum.Material.Asphalt)
    -- broken white centre markings, spaced for a readable low-poly/mobile road.
    local count = math.floor(length / 22)
    for i = 1, count do
        local t = i / (count + 1)
        local point = a:Lerp(b, t)
        makePart(name .. "_LaneMark", Vector3.new(0.35, 0.28, 6), CFrame.new(point.X, 0.21, point.Z) * CFrame.Angles(0, angle, 0), Color3.fromRGB(235, 225, 185), Enum.Material.SmoothPlastic)
    end
end

-- City ring and arterial roads radiating from central Agartala.
roadSegment("CentralCityRoad", Vector3.new(-440, 0, 0), Vector3.new(440, 0, 0), 24)
roadSegment("NorthSouthRoad", Vector3.new(0, 0, -440), Vector3.new(0, 0, 440), 24)
roadSegment("NorthwestRoad", Vector3.new(-380, 0, -300), Vector3.new(360, 0, 330), 18)
roadSegment("SouthwestRoad", Vector3.new(-360, 0, 340), Vector3.new(350, 0, -330), 18)
roadSegment("WestMarketRoad", Vector3.new(-440, 0, -115), Vector3.new(80, 0, -115), 14)
roadSegment("AirportRoad", Vector3.new(0, 0, -20), Vector3.new(350, 0, -340), 18)
roadSegment("RailwayRoad", Vector3.new(-20, 0, 20), Vector3.new(-340, 0, 280), 16)
roadSegment("UdaipurHighway", Vector3.new(0, 0, 0), Vector3.new(20, 0, 440), 20)

-- Sidewalk strips along main roads.
for _, z in ipairs({-14, 14}) do
    makePart("CentralSidewalk", Vector3.new(880, 0.35, 3), CFrame.new(0, 0.28, z), sidewalkColor, Enum.Material.Concrete)
end
for _, x in ipairs({-14, 14}) do
    makePart("NorthSouthSidewalk", Vector3.new(3, 0.35, 880), CFrame.new(x, 0.28, 0), sidewalkColor, Enum.Material.Concrete)
end

local function signBoard(name, text, position, color)
    local board = makePart(name, Vector3.new(18, 5, 0.5), CFrame.new(position), color or Color3.fromRGB(20, 91, 67), Enum.Material.Metal)
    local gui = Instance.new("SurfaceGui")
    gui.Face = Enum.NormalId.Front
    gui.CanvasSize = Vector2.new(600, 170)
    gui.Parent = board
    local label = Instance.new("TextLabel")
    label.Size = UDim2.fromScale(1, 1)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.new(1, 1, 1)
    label.TextScaled = true
    label.Font = Enum.Font.GothamBlack
    label.Parent = gui
    return board
end

local function building(name, position, width, height, depth, wallColor, roofColor, labelText)
    local x, y, z = position.X, position.Y, position.Z
    local model = Instance.new("Model")
    model.Name = name
    model.Parent = map
    local body = makePart("Building", Vector3.new(width, height, depth), CFrame.new(x, y + height / 2, z), wallColor, Enum.Material.Concrete, model)
    makePart("Roof", Vector3.new(width + 1, 1, depth + 1), CFrame.new(x, y + height + 0.5, z), roofColor, Enum.Material.Metal, model)
    makePart("Entrance", Vector3.new(math.max(3, width * 0.16), math.min(7, height * 0.48), 0.35), CFrame.new(x, y + math.min(3.5, height * 0.25), z + depth / 2 + 0.2), Color3.fromRGB(67, 47, 34), Enum.Material.Wood, model)
    for windowX = -1, 1 do
        if width > 12 then
            makePart("FrontWindow", Vector3.new(3, 3, 0.25), CFrame.new(x + windowX * width * 0.28, y + height * 0.62, z + depth / 2 + 0.22), Color3.fromRGB(95, 173, 196), Enum.Material.Glass, model)
        end
    end
    local sign = makePart("LocationSign", Vector3.new(math.min(width - 1, 22), 2, 0.35), CFrame.new(x, y + height * 0.82, z + depth / 2 + 0.28), Color3.fromRGB(21, 61, 76), Enum.Material.SmoothPlastic, model)
    local sg = Instance.new("SurfaceGui")
    sg.Face = Enum.NormalId.Front
    sg.CanvasSize = Vector2.new(440, 100)
    sg.Parent = sign
    local tx = Instance.new("TextLabel")
    tx.Size = UDim2.fromScale(1, 1)
    tx.BackgroundTransparency = 1
    tx.Text = labelText or name
    tx.TextColor3 = Color3.new(1, 1, 1)
    tx.TextScaled = true
    tx.Font = Enum.Font.GothamBold
    tx.Parent = sg
    model.PrimaryPart = body
    return model
end

-- Central city / market blocks.
for i = 1, 7 do
    local x = -260 + (i - 1) * 75
    building("AgartalaShop_" .. i, Vector3.new(x, 0, -155), 28, 13 + (i % 3) * 3, 24, i % 2 == 0 and cream or terracotta, teal, "AGARTALA MARKET")
    building("CityShop_" .. i, Vector3.new(x, 0, 155), 28, 12 + (i % 4) * 2, 22, i % 2 == 0 and white or cream, terracotta, "LOCAL SHOP")
end

-- Landmark: Ujjayanta Palace-inspired symmetrical white domed civic landmark.
local palace = Instance.new("Model")
palace.Name = "UjjayantaPalaceLandmark"
palace.Parent = map
makePart("PalaceMain", Vector3.new(68, 24, 30), CFrame.new(-90, 12, -250), white, Enum.Material.Marble, palace)
makePart("PalaceWingLeft", Vector3.new(24, 16, 26), CFrame.new(-137, 8, -250), cream, Enum.Material.Marble, palace)
makePart("PalaceWingRight", Vector3.new(24, 16, 26), CFrame.new(-43, 8, -250), cream, Enum.Material.Marble, palace)
for _, x in ipairs({-125, -90, -55}) do
    local dome = makePart("PalaceDome", Vector3.new(12, 10, 12), CFrame.new(x, 29, -250), Color3.fromRGB(226, 225, 209), Enum.Material.Marble, palace)
    dome.Shape = Enum.PartType.Ball
end
signBoard("PalaceSign", "UJJAYANTA PALACE", Vector3.new(-90, 7, -220), Color3.fromRGB(47, 87, 104))

-- Landmark: railway station terminal and platforms.
building("AgartalaRailwayStation", Vector3.new(-285, 0, 250), 72, 18, 30, cream, Color3.fromRGB(46, 76, 105), "AGARTALA RAILWAY STATION")
for i = 1, 3 do
    makePart("RailPlatform", Vector3.new(90, 0.45, 7), CFrame.new(-285, 0.2, 280 + i * 12), sidewalkColor, Enum.Material.Concrete)
    makePart("RailTrackBed", Vector3.new(90, 0.25, 3), CFrame.new(-285, 0.12, 286 + i * 12), Color3.fromRGB(72, 70, 64), Enum.Material.Metal)
end
signBoard("RailwayDirectionSign", "RAILWAY STATION", Vector3.new(-285, 7, 229))

-- Landmark: airport terminal and runway.
building("MaharajaBirBikramAirport", Vector3.new(330, 0, -360), 90, 18, 38, white, Color3.fromRGB(50, 92, 119), "MAHARAJA BIR BIKRAM AIRPORT")
makePart("AirportRunway", Vector3.new(38, 0.3, 210), CFrame.new(420, 0.08, -360), Color3.fromRGB(55, 58, 61), Enum.Material.Asphalt)
for i = 1, 11 do
    makePart("RunwayMarking", Vector3.new(1.2, 0.36, 9), CFrame.new(420, 0.27, -455 + i * 18), white, Enum.Material.SmoothPlastic)
end
signBoard("AirportSign", "AGARTALA AIRPORT", Vector3.new(330, 7, -335))

-- Badarghat residential area and Udaipur highway destination.
for i = 1, 6 do
    local x = -310 + (i - 1) * 48
    building("BadarghatHome_" .. i, Vector3.new(x, 0, 20), 24, 10 + (i % 2) * 3, 22, i % 2 == 0 and cream or white, terracotta, "BADARGHAT")
end
building("UdaipurTownHall", Vector3.new(70, 0, 370), 50, 16, 30, cream, teal, "UDAIPUR • TRIPURA")
signBoard("UdaipurHighwaySign", "UDAIPUR  →", Vector3.new(35, 6, 330), Color3.fromRGB(20, 110, 72))

-- Simple low-cost roadside trees.
local function tree(x, z, scale)
    makePart("TreeTrunk", Vector3.new(2 * scale, 7 * scale, 2 * scale), CFrame.new(x, 3.5 * scale, z), Color3.fromRGB(104, 72, 45), Enum.Material.Wood)
    local crown = makePart("TreeCanopy", Vector3.new(9 * scale, 9 * scale, 9 * scale), CFrame.new(x, 9 * scale, z), Color3.fromRGB(41, 111, 55), Enum.Material.Grass)
    crown.Shape = Enum.PartType.Ball
end
for i = 1, 34 do
    local x = -410 + (i * 31) % 820
    tree(x, -28, 0.8 + (i % 3) * 0.12)
    if i % 2 == 0 then tree(x, 30, 0.8) end
end

signBoard("AgartalaCityEntry", "AGARTALA • TRIPURA", Vector3.new(-5, 8, -28), Color3.fromRGB(20, 110, 72))
print("Agartala3DMap: generated mobile-friendly 3D city roads, shops, trees and landmark areas")
