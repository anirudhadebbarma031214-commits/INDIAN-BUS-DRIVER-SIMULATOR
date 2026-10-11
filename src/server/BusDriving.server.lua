-- Server-authoritative basic bus driving for Indian Bus Driver Simulator.
-- Bus models are moved by PivotTo so the generated anchored body parts travel together.
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local remote = ReplicatedStorage:FindFirstChild("BusDriveInput")
if not remote then
    remote = Instance.new("RemoteEvent")
    remote.Name = "BusDriveInput"
    remote.Parent = ReplicatedStorage
end

local fleet = Workspace:WaitForChild("BusFleet")
local inputs = {}
local activeDrivers = {}

local MAX_FORWARD_SPEED = 34
local MAX_REVERSE_SPEED = 12
local ACCELERATION = 22
local BRAKING = 34
local TURN_RATE = math.rad(48)

local function getBusForSeat(seat)
    if not seat or not seat:IsA("VehicleSeat") or seat.Name ~= "DriverSeat" then
        return nil
    end
    local model = seat:FindFirstAncestorOfClass("Model")
    if model and model.Parent == fleet and model:GetAttribute("CanDrive") == true then
        return model
    end
    return nil
end

local function stopDriver(player)
    inputs[player] = nil
    activeDrivers[player] = nil
end

local function setupBus(model)
    local seat = model:FindFirstChild("DriverSeat")
    local body = model:FindFirstChild("MainBody")
    local prompt = body and body:FindFirstChild("DriveBusPrompt")
    if not seat or not prompt then return end

    if model:GetAttribute("FuelPercent") == nil then model:SetAttribute("FuelPercent", 100) end
    if model:GetAttribute("DamagePercent") == nil then model:SetAttribute("DamagePercent", 0) end

    prompt.Triggered:Connect(function(player)
        local character = player.Character
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        if not humanoid or humanoid.Health <= 0 then return end
        if seat.Occupant and seat.Occupant ~= humanoid then return end

        -- Keep one driver per bus and one bus per player.
        for otherPlayer, otherModel in pairs(activeDrivers) do
            if otherPlayer == player or otherModel == model then
                local otherSeat = otherModel:FindFirstChild("DriverSeat")
                if otherSeat and otherSeat.Occupant then otherSeat.Occupant.Sit = false end
                stopDriver(otherPlayer)
            end
        end

        local root = character:FindFirstChild("HumanoidRootPart")
        if root then
            root.CFrame = seat.CFrame * CFrame.new(0, 2.5, 0)
            task.wait(0.1)
        end
        seat:Sit(humanoid)
        task.wait(0.15)
        if seat.Occupant == humanoid then
            activeDrivers[player] = model
            inputs[player] = {throttle = 0, steer = 0}
        end
    end)

    seat:GetPropertyChangedSignal("Occupant"):Connect(function()
        local occupant = seat.Occupant
        if not occupant then
            for player, drivenModel in pairs(activeDrivers) do
                if drivenModel == model then stopDriver(player) end
            end
        end
    end)
end

for _, model in ipairs(fleet:GetChildren()) do setupBus(model) end
fleet.ChildAdded:Connect(function(model)
    task.wait()
    setupBus(model)
end)

remote.OnServerEvent:Connect(function(player, throttle, steer)
    local model = activeDrivers[player]
    if not model or not model.Parent then return end
    local seat = model:FindFirstChild("DriverSeat")
    local character = player.Character
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    if not seat or not humanoid or seat.Occupant ~= humanoid then
        stopDriver(player)
        return
    end
    if typeof(throttle) ~= "number" or typeof(steer) ~= "number" then return end
    inputs[player] = {
        throttle = math.clamp(throttle, -1, 1),
        steer = math.clamp(steer, -1, 1),
    }
end)

Players.PlayerRemoving:Connect(stopDriver)

local speedByBus = {}
RunService.Heartbeat:Connect(function(dt)
    for player, model in pairs(activeDrivers) do
        local input = inputs[player]
        local seat = model and model:FindFirstChild("DriverSeat")
        local character = player.Character
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        if not model or not model.Parent or not seat or not humanoid or seat.Occupant ~= humanoid then
            stopDriver(player)
            continue
        end
        local fuel = math.clamp(tonumber(model:GetAttribute("FuelPercent")) or 100, 0, 100)
        local damage = math.clamp(tonumber(model:GetAttribute("DamagePercent")) or 0, 0, 100)
        local throttle = input and input.throttle or 0
        local steer = input and input.steer or 0
        if fuel <= 0 or damage >= 100 then throttle = 0 end

        local speed = speedByBus[model] or 0
        local target = throttle >= 0 and throttle * MAX_FORWARD_SPEED or throttle * MAX_REVERSE_SPEED
        local rate = math.abs(target) < math.abs(speed) and BRAKING or ACCELERATION
        if speed < target then speed = math.min(target, speed + rate * dt)
        elseif speed > target then speed = math.max(target, speed - rate * dt) end
        speedByBus[model] = speed

        local pivot = model:GetPivot()
        local turnScale = math.clamp(math.abs(speed) / 7, 0, 1)
        local turn = -steer * TURN_RATE * turnScale * dt
        local rotated = pivot * CFrame.Angles(0, turn, 0)
        local distance = speed * dt
        model:PivotTo(rotated * CFrame.new(0, 0, distance))

        if math.abs(speed) > 1 and throttle > 0 then
            model:SetAttribute("FuelPercent", math.max(0, fuel - dt * 0.012 * (1 + math.abs(speed) / 18)))
        end
        -- Prevent a bus from being driven indefinitely through a completely damaged state.
        if damage >= 100 then speedByBus[model] = 0 end
    end
end)

print("BusDriving: drive prompts and server-side bus movement ready")
