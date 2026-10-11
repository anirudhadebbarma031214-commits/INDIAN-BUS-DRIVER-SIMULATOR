-- INDIAN BUS DRIVER SIMULATOR — Main Menu
-- ANI STUDIO
-- Place this LocalScript in StarterPlayer > StarterPlayerScripts.
-- It builds a responsive menu with PLAY, CREDITS, and EXIT buttons.

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

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
    mapNote.Text = "SELECTED: " .. selectedRoute .. " • BUS SPAWN / DRIVING WILL BE CONNECTED NEXT"
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
