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

playButton.Activated:Connect(function()
    -- Temporary menu action until the bus stand and gameplay are connected.
    local notice = makeDialog(
        "ComingSoonDialog",
        "READY TO DRIVE?",
        "The menu is ready! The bus stand, bus selection, and driving gameplay will be connected in the next development steps.",
        "BACK TO MENU"
    )
    notice.Visible = true
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
