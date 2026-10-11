-- Keyboard + touchscreen controls for Indian Bus Driver Simulator.
-- Place in StarterPlayer > StarterPlayerScripts through Rojo.
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local remote = ReplicatedStorage:WaitForChild("BusDriveInput")
local gui = player:WaitForChild("PlayerGui"):WaitForChild("IndianBusDriverMenu")

local controls = {forward = false, reverse = false, left = false, right = false}
local lastSend = 0

local controlGui = Instance.new("ScreenGui")
controlGui.Name = "BusDrivingControls"
controlGui.ResetOnSpawn = false
controlGui.IgnoreGuiInset = true
controlGui.Parent = player:WaitForChild("PlayerGui")

local panel = Instance.new("Frame")
panel.Name = "TouchControls"
panel.AnchorPoint = Vector2.new(0.5, 1)
panel.Position = UDim2.new(0.5, 0, 0.97, 0)
panel.Size = UDim2.fromOffset(244, 142)
panel.BackgroundTransparency = 1
panel.Visible = false
panel.Parent = controlGui

local function makeControl(name, text, position, size, controlKey, color)
    local button = Instance.new("TextButton")
    button.Name = name
    button.Position = position
    button.Size = size
    button.BackgroundColor3 = color or Color3.fromRGB(16, 40, 53)
    button.BackgroundTransparency = 0.08
    button.BorderSizePixel = 0
    button.AutoButtonColor = true
    button.Font = Enum.Font.GothamBlack
    button.Text = text
    button.TextColor3 = Color3.new(1, 1, 1)
    button.TextScaled = true
    button.Parent = panel
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = button
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(70, 190, 220)
    stroke.Transparency = 0.2
    stroke.Parent = button

    local function setHeld(value)
        controls[controlKey] = value
    end
    button.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            setHeld(true)
        end
    end)
    button.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            setHeld(false)
        end
    end)
    button.MouseLeave:Connect(function()
        if not UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
            setHeld(false)
        end
    end)
    return button
end

makeControl("Left", "◀", UDim2.fromOffset(0, 48), UDim2.fromOffset(66, 52), "left")
makeControl("Right", "▶", UDim2.fromOffset(74, 48), UDim2.fromOffset(66, 52), "right")
makeControl("Forward", "▲", UDim2.fromOffset(148, 0), UDim2.fromOffset(70, 66), "forward", Color3.fromRGB(20, 125, 85))
makeControl("Reverse", "▼", UDim2.fromOffset(148, 74), UDim2.fromOffset(70, 60), "reverse", Color3.fromRGB(115, 65, 38))

local function seatedInBus()
    local character = player.Character
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    local seat = humanoid and humanoid.SeatPart
    return seat and seat:IsA("VehicleSeat") and seat.Name == "DriverSeat"
end

UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    if input.KeyCode == Enum.KeyCode.W or input.KeyCode == Enum.KeyCode.Up then controls.forward = true end
    if input.KeyCode == Enum.KeyCode.S or input.KeyCode == Enum.KeyCode.Down then controls.reverse = true end
    if input.KeyCode == Enum.KeyCode.A or input.KeyCode == Enum.KeyCode.Left then controls.left = true end
    if input.KeyCode == Enum.KeyCode.D or input.KeyCode == Enum.KeyCode.Right then controls.right = true end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.W or input.KeyCode == Enum.KeyCode.Up then controls.forward = false end
    if input.KeyCode == Enum.KeyCode.S or input.KeyCode == Enum.KeyCode.Down then controls.reverse = false end
    if input.KeyCode == Enum.KeyCode.A or input.KeyCode == Enum.KeyCode.Left then controls.left = false end
    if input.KeyCode == Enum.KeyCode.D or input.KeyCode == Enum.KeyCode.Right then controls.right = false end
end)

RunService.RenderStepped:Connect(function()
    local driving = seatedInBus()
    panel.Visible = driving and UserInputService.TouchEnabled
    if UserInputService.TouchEnabled then
        panel.Size = UDim2.fromOffset(244, 142)
    end
    if not driving then
        controls.forward, controls.reverse, controls.left, controls.right = false, false, false, false
        return
    end
    local now = os.clock()
    if now - lastSend >= 0.08 then
        lastSend = now
        local throttle = (controls.forward and 1 or 0) - (controls.reverse and 1 or 0)
        local steer = (controls.right and 1 or 0) - (controls.left and 1 or 0)
        remote:FireServer(throttle, steer)
    end
end)

print("BusControls: WASD / arrow keys and touch controls loaded")
