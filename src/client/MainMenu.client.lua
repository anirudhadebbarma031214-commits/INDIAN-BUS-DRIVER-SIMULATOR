-- INDIAN BUS DRIVER SIMULATOR — Main Menu
-- ANI STUDIO
-- Place this LocalScript in StarterPlayer > StarterPlayerScripts.
-- It builds a responsive menu with PLAY, CREDITS, and EXIT buttons.

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local oldGui = playerGui:FindFirstChild("IndianBusDriverMenu")
if oldGui then
    oldGui:Destroy()
end

local gui = Instance.new("ScreenGui")
gui.Name = "IndianBusDriverMenu"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.Parent = playerGui

local background = Instance.new("Frame")
background.Name = "Background"
background.Size = UDim2.fromScale(1, 1)
background.BackgroundColor3 = Color3.fromRGB(9, 15, 24)
background.BorderSizePixel = 0
background.Parent = gui

local gradient = Instance.new("UIGradient")
gradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(9, 15, 24)),
    ColorSequenceKeypoint.new(0.55, Color3.fromRGB(17, 38, 54)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(91, 43, 20)),
})
gradient.Rotation = 25
gradient.Parent = background

local accent = Instance.new("Frame")
accent.Name = "AccentLine"
accent.Size = UDim2.new(0.16, 0, 0, 5)
accent.Position = UDim2.new(0.08, 0, 0.2, 0)
accent.BackgroundColor3 = Color3.fromRGB(255, 153, 51)
accent.BorderSizePixel = 0
accent.Parent = background

local title = Instance.new("TextLabel")
title.Name = "GameTitle"
title.BackgroundTransparency = 1
title.Position = UDim2.new(0.08, 0, 0.23, 0)
title.Size = UDim2.new(0.84, 0, 0.17, 0)
title.Font = Enum.Font.GothamBlack
title.Text = "INDIAN BUS DRIVER\nSIMULATOR"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextScaled = true
title.TextXAlignment = Enum.TextXAlignment.Left
title.TextYAlignment = Enum.TextYAlignment.Center
title.Parent = background

local titleConstraint = Instance.new("UITextSizeConstraint")
titleConstraint.MinTextSize = 24
titleConstraint.MaxTextSize = 56
titleConstraint.Parent = title

local subtitle = Instance.new("TextLabel")
subtitle.BackgroundTransparency = 1
subtitle.Position = UDim2.new(0.085, 0, 0.405, 0)
subtitle.Size = UDim2.new(0.8, 0, 0.045, 0)
subtitle.Font = Enum.Font.GothamMedium
subtitle.Text = "YOUR ROUTE. YOUR COUNTRY. YOUR JOURNEY."
subtitle.TextColor3 = Color3.fromRGB(210, 220, 230)
subtitle.TextScaled = true
subtitle.TextXAlignment = Enum.TextXAlignment.Left
subtitle.Parent = background

local subtitleConstraint = Instance.new("UITextSizeConstraint")
subtitleConstraint.MinTextSize = 10
subtitleConstraint.MaxTextSize = 18
subtitleConstraint.Parent = subtitle

local buttonHolder = Instance.new("Frame")
buttonHolder.Name = "MenuButtons"
buttonHolder.BackgroundTransparency = 1
buttonHolder.Position = UDim2.new(0.08, 0, 0.51, 0)
buttonHolder.Size = UDim2.new(0.38, 0, 0.34, 0)
buttonHolder.Parent = background

local list = Instance.new("UIListLayout")
list.Padding = UDim.new(0, 10)
list.SortOrder = Enum.SortOrder.LayoutOrder
list.Parent = buttonHolder

local function makeButton(name, text, order, color)
    local button = Instance.new("TextButton")
    button.Name = name
    button.LayoutOrder = order
    button.Size = UDim2.new(1, 0, 0, 48)
    button.BackgroundColor3 = color
    button.BorderSizePixel = 0
    button.AutoButtonColor = false
    button.Font = Enum.Font.GothamBold
    button.Text = text
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextSize = 18
    button.Parent = buttonHolder

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = button

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(255, 255, 255)
    stroke.Transparency = 0.82
    stroke.Thickness = 1
    stroke.Parent = button

    button.MouseEnter:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.15), {
            BackgroundColor3 = color:Lerp(Color3.new(1, 1, 1), 0.14)
        }):Play()
    end)
    button.MouseLeave:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.15), {
            BackgroundColor3 = color
        }):Play()
    end)

    return button
end

local playButton = makeButton("PlayButton", "▶   PLAY", 1, Color3.fromRGB(20, 125, 85))
local creditsButton = makeButton("CreditsButton", "★   CREDITS", 2, Color3.fromRGB(36, 62, 82))
local exitButton = makeButton("ExitButton", "✕   EXIT", 3, Color3.fromRGB(115, 48, 43))

local footer = Instance.new("TextLabel")
footer.BackgroundTransparency = 1
footer.AnchorPoint = Vector2.new(0, 1)
footer.Position = UDim2.new(0.08, 0, 0.96, 0)
footer.Size = UDim2.new(0.84, 0, 0.035, 0)
footer.Font = Enum.Font.Gotham
footer.Text = "A GAME BY ANI STUDIO"
footer.TextColor3 = Color3.fromRGB(190, 200, 210)
footer.TextSize = 13
footer.TextXAlignment = Enum.TextXAlignment.Left
footer.Parent = background

local function makeDialog(name, heading, message, buttonText)
    local panel = Instance.new("Frame")
    panel.Name = name
    panel.AnchorPoint = Vector2.new(0.5, 0.5)
    panel.Position = UDim2.fromScale(0.5, 0.5)
    panel.Size = UDim2.new(0.82, 0, 0, 220)
    panel.BackgroundColor3 = Color3.fromRGB(15, 25, 36)
    panel.BorderSizePixel = 0
    panel.Visible = false
    panel.ZIndex = 5
    panel.Parent = background

    local sizeLimit = Instance.new("UISizeConstraint")
    sizeLimit.MaxSize = Vector2.new(460, 260)
    sizeLimit.MinSize = Vector2.new(260, 200)
    sizeLimit.Parent = panel

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 14)
    corner.Parent = panel

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(255, 153, 51)
    stroke.Thickness = 2
    stroke.Parent = panel

    local head = Instance.new("TextLabel")
    head.BackgroundTransparency = 1
    head.Position = UDim2.new(0.06, 0, 0.08, 0)
    head.Size = UDim2.new(0.88, 0, 0.2, 0)
    head.Font = Enum.Font.GothamBlack
    head.Text = heading
    head.TextColor3 = Color3.new(1, 1, 1)
    head.TextScaled = true
    head.ZIndex = 6
    head.Parent = panel

    local body = Instance.new("TextLabel")
    body.BackgroundTransparency = 1
    body.Position = UDim2.new(0.08, 0, 0.32, 0)
    body.Size = UDim2.new(0.84, 0, 0.38, 0)
    body.Font = Enum.Font.Gotham
    body.Text = message
    body.TextColor3 = Color3.fromRGB(215, 225, 235)
    body.TextWrapped = true
    body.TextScaled = true
    body.ZIndex = 6
    body.Parent = panel

    local action = Instance.new("TextButton")
    action.Name = "CloseButton"
    action.AnchorPoint = Vector2.new(0.5, 1)
    action.Position = UDim2.new(0.5, 0, 0.91, 0)
    action.Size = UDim2.new(0.7, 0, 0, 38)
    action.BackgroundColor3 = Color3.fromRGB(20, 125, 85)
    action.BorderSizePixel = 0
    action.Font = Enum.Font.GothamBold
    action.Text = buttonText
    action.TextColor3 = Color3.new(1, 1, 1)
    action.TextSize = 16
    action.ZIndex = 6
    action.Parent = panel

    local actionCorner = Instance.new("UICorner")
    actionCorner.CornerRadius = UDim.new(0, 8)
    actionCorner.Parent = action

    action.Activated:Connect(function()
        panel.Visible = false
    end)

    return panel
end

local creditsDialog = makeDialog(
    "CreditsDialog",
    "CREDITS",
    "INDIAN BUS DRIVER SIMULATOR\nCreated by ANI STUDIO\nThank you for playing!",
    "BACK TO MENU"
)

local exitDialog = makeDialog(
    "ExitDialog",
    "LEAVE GAME?",
    "Roblox experiences cannot close the Roblox app with a script. Use the Roblox menu to leave this experience.",
    "GOT IT"
)



-- COOL LIVE SPEEDOMETER HUD (km/h), styled like a modern Indian coach dashboard.
local speedHud = Instance.new("Frame")
speedHud.Name = "BusSpeedometer"
speedHud.AnchorPoint = Vector2.new(1, 1)
speedHud.Position = UDim2.new(0.98, 0, 0.97, 0)
speedHud.Size = UDim2.fromOffset(245, 142)
speedHud.BackgroundColor3 = Color3.fromRGB(7, 15, 24)
speedHud.BackgroundTransparency = 0.08
speedHud.BorderSizePixel = 0
speedHud.Visible = false
speedHud.ZIndex = 40
speedHud.Parent = gui
local speedCorner = Instance.new("UICorner")
speedCorner.CornerRadius = UDim.new(0, 16)
speedCorner.Parent = speedHud
local speedStroke = Instance.new("UIStroke")
speedStroke.Color = Color3.fromRGB(48, 190, 220)
speedStroke.Thickness = 2
speedStroke.Transparency = 0.1
speedStroke.Parent = speedHud

local speedTitle = Instance.new("TextLabel")
speedTitle.BackgroundTransparency = 1
speedTitle.Position = UDim2.new(0.06, 0, 0.05, 0)
speedTitle.Size = UDim2.new(0.88, 0, 0.17, 0)
speedTitle.Font = Enum.Font.GothamBlack
speedTitle.Text = "ANI  •  BUS DASH"
speedTitle.TextColor3 = Color3.fromRGB(130, 225, 255)
speedTitle.TextScaled = true
speedTitle.TextXAlignment = Enum.TextXAlignment.Left
speedTitle.ZIndex = 41
speedTitle.Parent = speedHud

local speedValue = Instance.new("TextLabel")
speedValue.Name = "SpeedValue"
speedValue.BackgroundTransparency = 1
speedValue.Position = UDim2.new(0.05, 0, 0.2, 0)
speedValue.Size = UDim2.new(0.62, 0, 0.56, 0)
speedValue.Font = Enum.Font.GothamBlack
speedValue.Text = "0"
speedValue.TextColor3 = Color3.fromRGB(255, 255, 255)
speedValue.TextScaled = true
speedValue.TextXAlignment = Enum.TextXAlignment.Left
speedValue.ZIndex = 41
speedValue.Parent = speedHud

local speedUnit = Instance.new("TextLabel")
speedUnit.BackgroundTransparency = 1
speedUnit.Position = UDim2.new(0.55, 0, 0.47, 0)
speedUnit.Size = UDim2.new(0.35, 0, 0.2, 0)
speedUnit.Font = Enum.Font.GothamBold
speedUnit.Text = "km/h"
speedUnit.TextColor3 = Color3.fromRGB(150, 175, 190)
speedUnit.TextScaled = true
speedUnit.TextXAlignment = Enum.TextXAlignment.Left
speedUnit.ZIndex = 41
speedUnit.Parent = speedHud

local speedBarBack = Instance.new("Frame")
speedBarBack.Position = UDim2.new(0.06, 0, 0.79, 0)
speedBarBack.Size = UDim2.new(0.88, 0, 0, 9)
speedBarBack.BackgroundColor3 = Color3.fromRGB(30, 48, 61)
speedBarBack.BorderSizePixel = 0
speedBarBack.ZIndex = 41
speedBarBack.Parent = speedHud
local speedBarBackCorner = Instance.new("UICorner")
speedBarBackCorner.CornerRadius = UDim.new(1, 0)
speedBarBackCorner.Parent = speedBarBack

local speedBar = Instance.new("Frame")
speedBar.Name = "SpeedFill"
speedBar.Size = UDim2.new(0, 0, 1, 0)
speedBar.BackgroundColor3 = Color3.fromRGB(55, 220, 170)
speedBar.BorderSizePixel = 0
speedBar.ZIndex = 42
speedBar.Parent = speedBarBack
local speedBarCorner = Instance.new("UICorner")
speedBarCorner.CornerRadius = UDim.new(1, 0)
speedBarCorner.Parent = speedBar

local speedStatus = Instance.new("TextLabel")
speedStatus.BackgroundTransparency = 1
speedStatus.Position = UDim2.new(0.06, 0, 0.87, 0)
speedStatus.Size = UDim2.new(0.88, 0, 0.1, 0)
speedStatus.Font = Enum.Font.GothamBold
speedStatus.Text = "READY  •  LIMIT 80"
speedStatus.TextColor3 = Color3.fromRGB(130, 225, 180)
speedStatus.TextScaled = true
speedStatus.TextXAlignment = Enum.TextXAlignment.Left
speedStatus.ZIndex = 41
speedStatus.Parent = speedHud

local MAX_SPEED_KMH = 120
local lastSpeed = 0
RunService.RenderStepped:Connect(function(dt)
    if not speedHud.Visible then return end
    local character = player.Character
    local root = character and character:FindFirstChild("HumanoidRootPart")
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    local studsPerSecond = 0
    if root then
        local velocity = root.AssemblyLinearVelocity
        studsPerSecond = Vector3.new(velocity.X, 0, velocity.Z).Magnitude
    elseif humanoid then
        studsPerSecond = humanoid.MoveDirection.Magnitude * humanoid.WalkSpeed
    end
    local kmh = math.floor(studsPerSecond * 1.008 + 0.5)
    lastSpeed = kmh
    speedValue.Text = tostring(kmh)
    speedBar:TweenSize(UDim2.new(math.clamp(kmh / MAX_SPEED_KMH, 0, 1), 0, 1, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, math.max(dt, 0.05), true)
    if kmh >= 80 then
        speedBar.BackgroundColor3 = Color3.fromRGB(255, 75, 70)
        speedStroke.Color = Color3.fromRGB(255, 90, 75)
        speedStatus.Text = "SLOW DOWN  •  LIMIT 80"
        speedStatus.TextColor3 = Color3.fromRGB(255, 100, 90)
    elseif kmh >= 55 then
        speedBar.BackgroundColor3 = Color3.fromRGB(255, 185, 65)
        speedStroke.Color = Color3.fromRGB(255, 185, 65)
        speedStatus.Text = "CRUISING  •  LIMIT 80"
        speedStatus.TextColor3 = Color3.fromRGB(255, 200, 110)
    else
        speedBar.BackgroundColor3 = Color3.fromRGB(55, 220, 170)
        speedStroke.Color = Color3.fromRGB(48, 190, 220)
        speedStatus.Text = "CITY DRIVE  •  LIMIT 80"
        speedStatus.TextColor3 = Color3.fromRGB(130, 225, 180)
    end
end)


-- LEFT-SIDE IN-GAME VEHICLE STATUS: fuel/petrol and vehicle damage.
-- Reads FuelPercent and DamagePercent attributes from the bus model when available.
local vehicleStatus = Instance.new("Frame")
vehicleStatus.Name = "VehicleStatusSidebar"
vehicleStatus.AnchorPoint = Vector2.new(0, 0.5)
vehicleStatus.Position = UDim2.new(0.025, 0, 0.52, 0)
vehicleStatus.Size = UDim2.fromOffset(208, 184)
vehicleStatus.BackgroundColor3 = Color3.fromRGB(7, 15, 24)
vehicleStatus.BackgroundTransparency = 0.08
vehicleStatus.BorderSizePixel = 0
vehicleStatus.Visible = false
vehicleStatus.ZIndex = 40
vehicleStatus.Parent = gui
local vehicleStatusCorner = Instance.new("UICorner")
vehicleStatusCorner.CornerRadius = UDim.new(0, 14)
vehicleStatusCorner.Parent = vehicleStatus
local vehicleStatusStroke = Instance.new("UIStroke")
vehicleStatusStroke.Color = Color3.fromRGB(48, 190, 220)
vehicleStatusStroke.Thickness = 1.5
vehicleStatusStroke.Parent = vehicleStatus

local statusHeading = Instance.new("TextLabel")
statusHeading.BackgroundTransparency = 1
statusHeading.Position = UDim2.new(0.07, 0, 0.04, 0)
statusHeading.Size = UDim2.new(0.86, 0, 0.14, 0)
statusHeading.Font = Enum.Font.GothamBlack
statusHeading.Text = "VEHICLE STATUS"
statusHeading.TextColor3 = Color3.fromRGB(235, 245, 250)
statusHeading.TextScaled = true
statusHeading.TextXAlignment = Enum.TextXAlignment.Left
statusHeading.ZIndex = 41
statusHeading.Parent = vehicleStatus

local function makeStatusMeter(name, labelText, iconText, top, fillColor)
    local label = Instance.new("TextLabel")
    label.Name = name .. "Label"
    label.BackgroundTransparency = 1
    label.Position = UDim2.new(0.07, 0, top, 0)
    label.Size = UDim2.new(0.86, 0, 0.13, 0)
    label.Font = Enum.Font.GothamBold
    label.Text = iconText .. "  " .. labelText
    label.TextColor3 = Color3.fromRGB(210, 225, 235)
    label.TextSize = 13
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.ZIndex = 41
    label.Parent = vehicleStatus

    local value = Instance.new("TextLabel")
    value.Name = name .. "Value"
    value.BackgroundTransparency = 1
    value.AnchorPoint = Vector2.new(1, 0)
    value.Position = UDim2.new(0.93, 0, top, 0)
    value.Size = UDim2.new(0.28, 0, 0.13, 0)
    value.Font = Enum.Font.GothamBlack
    value.Text = "--"
    value.TextColor3 = fillColor
    value.TextSize = 14
    value.TextXAlignment = Enum.TextXAlignment.Right
    value.ZIndex = 41
    value.Parent = vehicleStatus

    local back = Instance.new("Frame")
    back.Name = name .. "BarBack"
    back.Position = UDim2.new(0.07, 0, top + 0.15, 0)
    back.Size = UDim2.new(0.86, 0, 0, 9)
    back.BackgroundColor3 = Color3.fromRGB(31, 47, 58)
    back.BorderSizePixel = 0
    back.ZIndex = 41
    back.Parent = vehicleStatus
    local backCorner = Instance.new("UICorner")
    backCorner.CornerRadius = UDim.new(1, 0)
    backCorner.Parent = back

    local fill = Instance.new("Frame")
    fill.Name = name .. "Fill"
    fill.Size = UDim2.new(1, 0, 1, 0)
    fill.BackgroundColor3 = fillColor
    fill.BorderSizePixel = 0
    fill.ZIndex = 42
    fill.Parent = back
    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(1, 0)
    fillCorner.Parent = fill
    return value, fill
end

local fuelValue, fuelFill = makeStatusMeter("Fuel", "PETROL", "⛽", 0.23, Color3.fromRGB(65, 220, 145))
local damageValue, damageFill = makeStatusMeter("Damage", "DAMAGE", "🔧", 0.57, Color3.fromRGB(255, 170, 65))
local vehicleHint = Instance.new("TextLabel")
vehicleHint.BackgroundTransparency = 1
vehicleHint.Position = UDim2.new(0.07, 0, 0.88, 0)
vehicleHint.Size = UDim2.new(0.86, 0, 0.08, 0)
vehicleHint.Font = Enum.Font.Gotham
vehicleHint.Text = "ENTER A BUS TO MONITOR"
vehicleHint.TextColor3 = Color3.fromRGB(145, 170, 185)
vehicleHint.TextScaled = true
vehicleHint.TextXAlignment = Enum.TextXAlignment.Left
vehicleHint.ZIndex = 41
vehicleHint.Parent = vehicleStatus

local fuelCache = setmetatable({}, {__mode = "k"})
local damageCache = setmetatable({}, {__mode = "k"})
local impactCooldown = setmetatable({}, {__mode = "k"})
local trackedVehicle = nil
local lastVehicleSpeed = 0
local function findSeatedVehicle()
    local character = player.Character
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    local seatPart = humanoid and humanoid.SeatPart
    if not seatPart or not seatPart:IsA("VehicleSeat") then return nil, nil end
    local model = seatPart:FindFirstAncestorOfClass("Model")
    return model, seatPart
end

local function getPercent(model, attributeName, cache, defaultValue)
    local attribute = model:GetAttribute(attributeName)
    if typeof(attribute) == "number" then
        cache[model] = math.clamp(attribute, 0, 100)
    elseif cache[model] == nil then
        cache[model] = defaultValue
    end
    return math.clamp(cache[model], 0, 100)
end

local function updateVehicleStatus()
    if not vehicleStatus.Visible then return end
    local model, seat = findSeatedVehicle()
    trackedVehicle = model
    if not model or not seat then
        fuelValue.Text = "--"
        damageValue.Text = "--"
        fuelFill.Size = UDim2.new(0, 0, 1, 0)
        damageFill.Size = UDim2.new(0, 0, 1, 0)
        vehicleHint.Text = "ENTER A BUS TO MONITOR"
        vehicleHint.TextColor3 = Color3.fromRGB(145, 170, 185)
        lastVehicleSpeed = 0
        return
    end

    local fuel = getPercent(model, "FuelPercent", fuelCache, 100)
    local damage = getPercent(model, "DamagePercent", damageCache, 0)
    local velocity = seat.AssemblyLinearVelocity
    local speed = Vector3.new(velocity.X, 0, velocity.Z).Magnitude

    -- Consume a little fuel while the bus is moving under throttle.
    if seat.ThrottleFloat > 0 and speed > 1 and model:GetAttribute("FuelPercent") == nil then
        fuel = math.max(0, fuel - 0.025)
        fuelCache[model] = fuel
    end

    -- Approximate collision damage after a sharp speed drop; real vehicle damage
    -- can override this by setting the model's DamagePercent attribute.
    local previousSpeed = lastVehicleSpeed
    if model:GetAttribute("DamagePercent") == nil and previousSpeed - speed > 24 and speed > 5 then
        local now = os.clock()
        if not impactCooldown[model] or now - impactCooldown[model] > 1.5 then
            damage = math.min(100, damage + math.clamp((previousSpeed - speed) * 0.45, 2, 18))
            damageCache[model] = damage
            impactCooldown[model] = now
        end
    end
    lastVehicleSpeed = speed

    fuelValue.Text = string.format("%d%%", math.floor(fuel + 0.5))
    damageValue.Text = string.format("%d%%", math.floor(damage + 0.5))
    fuelFill.Size = UDim2.new(fuel / 100, 0, 1, 0)
    damageFill.Size = UDim2.new(damage / 100, 0, 1, 0)
    fuelFill.BackgroundColor3 = fuel <= 20 and Color3.fromRGB(255, 75, 70) or Color3.fromRGB(65, 220, 145)
    damageFill.BackgroundColor3 = damage >= 65 and Color3.fromRGB(255, 75, 70) or Color3.fromRGB(255, 170, 65)
    damageValue.TextColor3 = damage >= 65 and Color3.fromRGB(255, 85, 75) or Color3.fromRGB(255, 190, 100)
    if fuel <= 20 then
        vehicleHint.Text = "LOW PETROL • REFUEL SOON"
        vehicleHint.TextColor3 = Color3.fromRGB(255, 100, 90)
    elseif damage >= 65 then
        vehicleHint.Text = "HIGH DAMAGE • DRIVE CAREFULLY"
        vehicleHint.TextColor3 = Color3.fromRGB(255, 100, 90)
    else
        vehicleHint.Text = model.Name:upper()
        vehicleHint.TextColor3 = Color3.fromRGB(145, 210, 190)
    end
end

RunService.RenderStepped:Connect(updateVehicleStatus)

-- CORNER MINIMAP: player marker plus a live pointer toward the Agartala bus stop.
local miniMap = Instance.new("Frame")
miniMap.Name = "CornerDirectionMap"
miniMap.AnchorPoint = Vector2.new(1, 0)
miniMap.Position = UDim2.new(0.98, 0, 0.03, 0)
miniMap.Size = UDim2.fromOffset(220, 190)
miniMap.BackgroundColor3 = Color3.fromRGB(8, 20, 28)
miniMap.BorderSizePixel = 0
miniMap.Visible = false
miniMap.ZIndex = 30
miniMap.Parent = gui
local miniCorner = Instance.new("UICorner")
miniCorner.CornerRadius = UDim.new(0, 12)
miniCorner.Parent = miniMap
local miniStroke = Instance.new("UIStroke")
miniStroke.Color = Color3.fromRGB(255, 166, 64)
miniStroke.Thickness = 2
miniStroke.Parent = miniMap

local miniTitle = Instance.new("TextLabel")
miniTitle.BackgroundTransparency = 1
miniTitle.Position = UDim2.new(0.05, 0, 0.03, 0)
miniTitle.Size = UDim2.new(0.9, 0, 0.16, 0)
miniTitle.Font = Enum.Font.GothamBlack
miniTitle.Text = "MINI MAP  /  AGARTALA"
miniTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
miniTitle.TextScaled = true
miniTitle.ZIndex = 31
miniTitle.Parent = miniMap

local miniRoad = Instance.new("Frame")
miniRoad.AnchorPoint = Vector2.new(0.5, 0.5)
miniRoad.Position = UDim2.new(0.5, 0, 0.58, 0)
miniRoad.Size = UDim2.new(0.88, 0, 0, 5)
miniRoad.Rotation = -24
miniRoad.BackgroundColor3 = Color3.fromRGB(110, 132, 126)
miniRoad.BorderSizePixel = 0
miniRoad.ZIndex = 31
miniRoad.Parent = miniMap

local miniRoad2 = Instance.new("Frame")
miniRoad2.AnchorPoint = Vector2.new(0.5, 0.5)
miniRoad2.Position = UDim2.new(0.55, 0, 0.56, 0)
miniRoad2.Size = UDim2.new(0.78, 0, 0, 4)
miniRoad2.Rotation = 60
miniRoad2.BackgroundColor3 = Color3.fromRGB(85, 108, 105)
miniRoad2.BorderSizePixel = 0
miniRoad2.ZIndex = 31
miniRoad2.Parent = miniMap

local stopDot = Instance.new("Frame")
stopDot.Name = "BusStopMarker"
stopDot.AnchorPoint = Vector2.new(0.5, 0.5)
stopDot.Position = UDim2.new(0.78, 0, 0.39, 0)
stopDot.Size = UDim2.fromOffset(12, 12)
stopDot.BackgroundColor3 = Color3.fromRGB(255, 166, 64)
stopDot.BorderSizePixel = 0
stopDot.ZIndex = 34
stopDot.Parent = miniMap
local stopDotCorner = Instance.new("UICorner")
stopDotCorner.CornerRadius = UDim.new(1, 0)
stopDotCorner.Parent = stopDot

local stopText = Instance.new("TextLabel")
stopText.BackgroundTransparency = 1
stopText.Position = UDim2.new(0.48, 0, 0.29, 0)
stopText.Size = UDim2.new(0.48, 0, 0.09, 0)
stopText.Font = Enum.Font.GothamBold
stopText.Text = "BUS STOP"
stopText.TextColor3 = Color3.fromRGB(255, 190, 95)
stopText.TextScaled = true
stopText.ZIndex = 34
stopText.Parent = miniMap

local playerDot = Instance.new("Frame")
playerDot.Name = "PlayerPosition"
playerDot.AnchorPoint = Vector2.new(0.5, 0.5)
playerDot.Position = UDim2.new(0.2, 0, 0.72, 0)
playerDot.Size = UDim2.fromOffset(12, 12)
playerDot.BackgroundColor3 = Color3.fromRGB(80, 210, 255)
playerDot.BorderSizePixel = 0
playerDot.ZIndex = 35
playerDot.Parent = miniMap
local playerDotCorner = Instance.new("UICorner")
playerDotCorner.CornerRadius = UDim.new(1, 0)
playerDotCorner.Parent = playerDot

local directionArrow = Instance.new("TextLabel")
directionArrow.Name = "DirectionPointer"
directionArrow.AnchorPoint = Vector2.new(0.5, 0.5)
directionArrow.Position = playerDot.Position
directionArrow.Size = UDim2.fromOffset(34, 28)
directionArrow.BackgroundTransparency = 1
directionArrow.Font = Enum.Font.GothamBlack
directionArrow.Text = ">"
directionArrow.TextColor3 = Color3.fromRGB(80, 210, 255)
directionArrow.TextSize = 28
directionArrow.ZIndex = 36
directionArrow.Parent = miniMap

local directionText = Instance.new("TextLabel")
directionText.Name = "DirectionHint"
directionText.AnchorPoint = Vector2.new(0.5, 1)
directionText.Position = UDim2.new(0.5, 0, 0.98, 0)
directionText.Size = UDim2.new(0.92, 0, 0.16, 0)
directionText.BackgroundTransparency = 1
directionText.Font = Enum.Font.GothamBold
directionText.Text = "ARROW POINTS TO BUS STOP"
directionText.TextColor3 = Color3.fromRGB(220, 235, 240)
directionText.TextScaled = true
directionText.ZIndex = 35
directionText.Parent = miniMap

local busStopWorldPosition = Vector3.new(73, 0, 43)
local function compassDirection(deltaX, deltaZ)
    if math.abs(deltaX) > math.abs(deltaZ) then
        return deltaX > 0 and "EAST" or "WEST"
    elseif math.abs(deltaZ) > 0.5 then
        return deltaZ > 0 and "SOUTH" or "NORTH"
    end
    return "HERE"
end

RunService.RenderStepped:Connect(function()
    if not miniMap.Visible then return end
    local character = player.Character
    local root = character and character:FindFirstChild("HumanoidRootPart")
    if not root then return end

    -- The map covers the depot area; player dot follows their world position.
    local px = math.clamp((root.Position.X + 90) / 180, 0.08, 0.92)
    local py = math.clamp((root.Position.Z + 65) / 130, 0.22, 0.82)
    playerDot.Position = UDim2.new(px, 0, py, 0)

    local dx = busStopWorldPosition.X - root.Position.X
    local dz = busStopWorldPosition.Z - root.Position.Z
    local mapDx = dx / 180 * 150
    local mapDy = dz / 130 * 105
    directionArrow.Position = UDim2.new(px, mapDx, py, mapDy)
    directionArrow.Rotation = math.deg(math.atan2(mapDy, mapDx))
    directionText.Text = "BUS STOP: " .. compassDirection(dx, dz)
end)

-- ROUTE SELECTOR: a clickable schematic map, built directly in Roblox UI.
-- This is a stylized route diagram, not a live GPS map. Driving/spawning will be wired in later.
local routePanel = Instance.new("Frame")
routePanel.Name = "RouteSelectPanel"
routePanel.Size = UDim2.fromScale(1, 1)
routePanel.BackgroundColor3 = Color3.fromRGB(7, 13, 21)
routePanel.BorderSizePixel = 0
routePanel.Visible = false
routePanel.ZIndex = 10
routePanel.Parent = gui

local routeTitle = Instance.new("TextLabel")
routeTitle.BackgroundTransparency = 1
routeTitle.Position = UDim2.new(0.05, 0, 0.035, 0)
routeTitle.Size = UDim2.new(0.72, 0, 0.09, 0)
routeTitle.Font = Enum.Font.GothamBlack
routeTitle.Text = "SELECT YOUR ROUTE"
routeTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
routeTitle.TextScaled = true
routeTitle.TextXAlignment = Enum.TextXAlignment.Left
routeTitle.ZIndex = 11
routeTitle.Parent = routePanel

local routeSubtitle = Instance.new("TextLabel")
routeSubtitle.BackgroundTransparency = 1
routeSubtitle.Position = UDim2.new(0.05, 0, 0.12, 0)
routeSubtitle.Size = UDim2.new(0.88, 0, 0.045, 0)
routeSubtitle.Font = Enum.Font.Gotham
routeSubtitle.Text = "TRIPURA • INDIA  /  CHOOSE A DESTINATION"
routeSubtitle.TextColor3 = Color3.fromRGB(255, 174, 80)
routeSubtitle.TextScaled = true
routeSubtitle.TextXAlignment = Enum.TextXAlignment.Left
routeSubtitle.ZIndex = 11
routeSubtitle.Parent = routePanel

local map = Instance.new("Frame")
map.Name = "StylizedRouteMap"
map.Position = UDim2.new(0.05, 0, 0.21, 0)
map.Size = UDim2.new(0.53, 0, 0.62, 0)
map.BackgroundColor3 = Color3.fromRGB(17, 35, 43)
map.BorderSizePixel = 0
map.ClipsDescendants = true
map.ZIndex = 11
map.Parent = routePanel
local mapCorner = Instance.new("UICorner")
mapCorner.CornerRadius = UDim.new(0, 14)
mapCorner.Parent = map
local mapStroke = Instance.new("UIStroke")
mapStroke.Color = Color3.fromRGB(68, 115, 111)
mapStroke.Thickness = 2
mapStroke.Parent = map

-- Faint grid and winding roads make this a readable schematic map.
for i = 1, 7 do
    local line = Instance.new("Frame")
    line.BackgroundColor3 = Color3.fromRGB(46, 75, 78)
    line.BackgroundTransparency = 0.45
    line.BorderSizePixel = 0
    line.Size = UDim2.new(1, 0, 0, 1)
    line.Position = UDim2.new(0, 0, i / 8, 0)
    line.ZIndex = 11
    line.Parent = map
end
for i = 1, 7 do
    local line = Instance.new("Frame")
    line.BackgroundColor3 = Color3.fromRGB(46, 75, 78)
    line.BackgroundTransparency = 0.45
    line.BorderSizePixel = 0
    line.Size = UDim2.new(0, 1, 1, 0)
    line.Position = UDim2.new(i / 8, 0, 0, 0)
    line.ZIndex = 11
    line.Parent = map
end

local function road(name, pos, size, rotation, color, thickness)
    local r = Instance.new("Frame")
    r.Name = name
    r.AnchorPoint = Vector2.new(0.5, 0.5)
    r.Position = pos
    r.Size = size
    r.Rotation = rotation
    r.BackgroundColor3 = color
    r.BorderSizePixel = 0
    r.ZIndex = 12
    r.Parent = map
    if thickness then r.Size = UDim2.new(size.X.Scale, size.X.Offset, 0, thickness) end
    return r
end
local roadColor = Color3.fromRGB(133, 157, 147)
road("MainHighway", UDim2.fromScale(0.48, 0.52), UDim2.fromScale(1.1, 0), -32, roadColor, 5)
road("NorthRoad", UDim2.fromScale(0.55, 0.32), UDim2.fromScale(0.75, 0), 24, roadColor, 4)
road("SouthRoad", UDim2.fromScale(0.43, 0.7), UDim2.fromScale(0.72, 0), 15, roadColor, 4)
road("CityRingRoad", UDim2.fromScale(0.31, 0.48), UDim2.fromScale(0.27, 0), -8, Color3.fromRGB(255, 166, 64), 5)

local mapTag = Instance.new("TextLabel")
mapTag.BackgroundTransparency = 1
mapTag.Position = UDim2.new(0.04, 0, 0.04, 0)
mapTag.Size = UDim2.new(0.65, 0, 0.08, 0)
mapTag.Font = Enum.Font.GothamBold
mapTag.Text = "TRIPURA ROAD NETWORK"
mapTag.TextColor3 = Color3.fromRGB(201, 224, 215)
mapTag.TextScaled = true
mapTag.TextXAlignment = Enum.TextXAlignment.Left
mapTag.ZIndex = 13
mapTag.Parent = map

local locations = {
    {name = "AGARTALA", pos = UDim2.fromScale(0.31, 0.48), color = Color3.fromRGB(255, 166, 64)},
    {name = "UDAIPUR", pos = UDim2.fromScale(0.45, 0.72), color = Color3.fromRGB(91, 205, 154)},
    {name = "DHARMANAGAR", pos = UDim2.fromScale(0.66, 0.2), color = Color3.fromRGB(91, 205, 154)},
    {name = "GUWAHATI", pos = UDim2.fromScale(0.84, 0.42), color = Color3.fromRGB(91, 205, 154)}
}
for _, location in ipairs(locations) do
    local dot = Instance.new("Frame")
    dot.AnchorPoint = Vector2.new(0.5, 0.5)
    dot.Position = location.pos
    dot.Size = UDim2.fromOffset(13, 13)
    dot.BackgroundColor3 = location.color
    dot.BorderSizePixel = 0
    dot.ZIndex = 14
    dot.Parent = map
    local dotCorner = Instance.new("UICorner")
    dotCorner.CornerRadius = UDim.new(1, 0)
    dotCorner.Parent = dot
    local label = Instance.new("TextLabel")
    label.BackgroundColor3 = Color3.fromRGB(8, 18, 24)
    label.BackgroundTransparency = 0.1
    label.BorderSizePixel = 0
    label.Position = UDim2.new(location.pos.X.Scale, 10, location.pos.Y.Scale, -11)
    label.Size = UDim2.fromOffset(120, 23)
    label.Font = Enum.Font.GothamBold
    label.Text = location.name
    label.TextColor3 = Color3.fromRGB(245, 248, 245)
    label.TextSize = 10
    label.ZIndex = 14
    label.Parent = map
end

local routeOptions = Instance.new("Frame")
routeOptions.Name = "RouteOptions"
routeOptions.BackgroundTransparency = 1
routeOptions.Position = UDim2.new(0.62, 0, 0.21, 0)
routeOptions.Size = UDim2.new(0.33, 0, 0.62, 0)
routeOptions.ZIndex = 11
routeOptions.Parent = routePanel
local routeList = Instance.new("UIListLayout")
routeList.Padding = UDim.new(0, 9)
routeList.SortOrder = Enum.SortOrder.LayoutOrder
routeList.Parent = routeOptions

local selectedRoute = "Agartala City Loop"
local selectedLabel = Instance.new("TextLabel")
selectedLabel.Name = "SelectedRoute"
selectedLabel.BackgroundTransparency = 1
selectedLabel.Size = UDim2.new(1, 0, 0, 32)
selectedLabel.Font = Enum.Font.GothamBold
selectedLabel.Text = "SELECTED: " .. selectedRoute
selectedLabel.TextColor3 = Color3.fromRGB(255, 190, 95)
selectedLabel.TextScaled = true
selectedLabel.TextWrapped = true
selectedLabel.LayoutOrder = 0
selectedLabel.ZIndex = 12
selectedLabel.Parent = routeOptions

local function makeRouteButton(routeName, description, order)
    local button = Instance.new("TextButton")
    button.Name = routeName:gsub("%W", "") .. "RouteButton"
    button.LayoutOrder = order
    button.Size = UDim2.new(1, 0, 0, 61)
    button.BackgroundColor3 = Color3.fromRGB(25, 43, 54)
    button.BorderSizePixel = 0
    button.AutoButtonColor = true
    button.Font = Enum.Font.GothamBold
    button.Text = routeName .. "\n" .. description
    button.TextColor3 = Color3.fromRGB(245, 248, 250)
    button.TextSize = 14
    button.TextWrapped = true
    button.ZIndex = 12
    button.Parent = routeOptions
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 9)
    c.Parent = button
    button.Activated:Connect(function()
        selectedRoute = routeName
        selectedLabel.Text = "SELECTED: " .. selectedRoute
        for _, child in ipairs(routeOptions:GetChildren()) do
            if child:IsA("TextButton") then
                child.BackgroundColor3 = Color3.fromRGB(25, 43, 54)
            end
        end
        button.BackgroundColor3 = Color3.fromRGB(20, 125, 85)
    end)
    return button
end

makeRouteButton("Agartala City Loop", "City roads • Short", 1)
makeRouteButton("Agartala to Udaipur", "Tripura highway • Medium", 2)
makeRouteButton("Agartala to Dharmanagar", "North Tripura • Long", 3)
makeRouteButton("Agartala to Guwahati", "Interstate highway • Long", 4)

local mapNote = Instance.new("TextLabel")
mapNote.BackgroundTransparency = 1
mapNote.AnchorPoint = Vector2.new(0.5, 1)
mapNote.Position = UDim2.new(0.5, 0, 0.96, 0)
mapNote.Size = UDim2.new(0.9, 0, 0.06, 0)
mapNote.Font = Enum.Font.Gotham
mapNote.Text = "SCHEMATIC MAP • ROUTE CHOICE UI READY • DRIVING NOT CONNECTED YET"
mapNote.TextColor3 = Color3.fromRGB(160, 180, 190)
mapNote.TextScaled = true
mapNote.ZIndex = 12
mapNote.Parent = routePanel

local backButton = Instance.new("TextButton")
backButton.Name = "BackToMenuButton"
backButton.Position = UDim2.new(0.05, 0, 0.86, 0)
backButton.Size = UDim2.new(0.2, 0, 0.07, 0)
backButton.BackgroundColor3 = Color3.fromRGB(55, 65, 75)
backButton.BorderSizePixel = 0
backButton.Font = Enum.Font.GothamBold
backButton.Text = "← BACK"
backButton.TextColor3 = Color3.new(1, 1, 1)
backButton.TextSize = 16
backButton.ZIndex = 12
backButton.Parent = routePanel
local backCorner = Instance.new("UICorner")
backCorner.CornerRadius = UDim.new(0, 8)
backCorner.Parent = backButton
backButton.Activated:Connect(function()
    routePanel.Visible = false
    background.Visible = true
end)

local confirmRoute = Instance.new("TextButton")
confirmRoute.Name = "ConfirmRouteButton"
confirmRoute.Position = UDim2.new(0.62, 0, 0.86, 0)
confirmRoute.Size = UDim2.new(0.33, 0, 0.07, 0)
confirmRoute.BackgroundColor3 = Color3.fromRGB(20, 125, 85)
confirmRoute.BorderSizePixel = 0
confirmRoute.Font = Enum.Font.GothamBold
confirmRoute.Text = "CONFIRM ROUTE  →"
confirmRoute.TextColor3 = Color3.new(1, 1, 1)
confirmRoute.TextScaled = true
confirmRoute.ZIndex = 12
confirmRoute.Parent = routePanel
local confirmCorner = Instance.new("UICorner")
confirmCorner.CornerRadius = UDim.new(0, 8)
confirmCorner.Parent = confirmRoute
confirmRoute.Activated:Connect(function()
    selectedLabel.Text = "ROUTE SAVED: " .. selectedRoute
    mapNote.Text = "SELECTED: " .. selectedRoute .. " • BUS STOP DIRECTION MAP ENABLED"
    routePanel.Visible = false
    background.Visible = false
    miniMap.Visible = true
    speedHud.Visible = true
    vehicleStatus.Visible = true
end)

playButton.Activated:Connect(function()
    background.Visible = false
    routePanel.Visible = true
end)

creditsButton.Activated:Connect(function()
    creditsDialog.Visible = true
end)

exitButton.Activated:Connect(function()
    exitDialog.Visible = true
end)

-- Scale the menu buttons for phones and smaller screens.
local function updateLayout()
    local camera = workspace.CurrentCamera
    if not camera then return end
    local viewport = camera.ViewportSize
    if viewport.X < 700 then
        buttonHolder.Position = UDim2.new(0.08, 0, 0.53, 0)
        buttonHolder.Size = UDim2.new(0.72, 0, 0.32, 0)
        for _, child in ipairs(buttonHolder:GetChildren()) do
            if child:IsA("TextButton") then
                child.Size = UDim2.new(1, 0, 0, 42)
                child.TextSize = 16
            end
        end
    else
        buttonHolder.Position = UDim2.new(0.08, 0, 0.51, 0)
        buttonHolder.Size = UDim2.new(0.38, 0, 0.34, 0)
        for _, child in ipairs(buttonHolder:GetChildren()) do
            if child:IsA("TextButton") then
                child.Size = UDim2.new(1, 0, 0, 48)
                child.TextSize = 18
            end
        end
    end
end

if workspace.CurrentCamera then
    workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(updateLayout)
end
updateLayout()
