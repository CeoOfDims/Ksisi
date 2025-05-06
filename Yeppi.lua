local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local player = Players.LocalPlayer

-- Fullbright
pcall(function()
    Lighting.Brightness = 2
    Lighting.ClockTime = 14
    Lighting.FogEnd = 100000
    Lighting.GlobalShadows = false
    Lighting.OutdoorAmbient = Color3.new(1, 1, 1)
end)

-- Anti-lag
for _, v in pairs(workspace:GetDescendants()) do
    if v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Smoke") or v:IsA("Fire") then
        v:Destroy()
    end
end

-- Set WalkSpeed sekali
spawn(function()
    local char = player.Character or player.CharacterAdded:Wait()
    local hum = char:WaitForChild("Humanoid")
    hum.WalkSpeed = 50
end)

-- Credit Text (kiri atas)
local credit = Instance.new("ScreenGui", game.CoreGui)
credit.Name = "CreditGui"

local creditLabel = Instance.new("TextLabel", credit)
creditLabel.Text = "made by CeoOfDims"
creditLabel.Size = UDim2.new(0, 200, 0, 30)
creditLabel.Position = UDim2.new(0, 10, 0, 10)
creditLabel.BackgroundTransparency = 1
creditLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
creditLabel.Font = Enum.Font.SourceSansBold
creditLabel.TextScaled = true

-- FPS Display
local fpsLabel = Instance.new("TextLabel", credit)
fpsLabel.Size = UDim2.new(0, 120, 0, 30)
fpsLabel.Position = UDim2.new(0, 10, 0, 40)
fpsLabel.BackgroundTransparency = 1
fpsLabel.Text = "FPS: 0"
fpsLabel.Font = Enum.Font.SourceSansBold
fpsLabel.TextScaled = true

-- Update FPS
spawn(function()
    local last = tick()
    local frames = 0

    while true do
        frames = frames + 1
        local now = tick()
        if now - last >= 1 then
            local fps = frames
            frames = 0
            last = now

            fpsLabel.Text = "FPS: " .. fps

            -- Warn coloring
            if fps < 30 then
                fpsLabel.TextColor3 = Color3.fromRGB(255, 0, 0) -- Merah
            elseif fps <= 50 then
                fpsLabel.TextColor3 = Color3.fromRGB(255, 255, 0) -- Kuning
            else
                fpsLabel.TextColor3 = Color3.fromRGB(0, 255, 0) -- Hijau
            end
        end
        RunService.RenderStepped:Wait()
    end
end)

-- ESP + Distance
local function updateDistance(label, target)
    RunService.RenderStepped:Connect(function()
        if target and target:IsDescendantOf(workspace) and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local dist = (player.Character.HumanoidRootPart.Position - target.Position).Magnitude
            label.Text = "the rake [" .. math.floor(dist) .. "m]"
        end
    end)
end

local function addESP(model)
    if model:FindFirstChild("HumanoidRootPart") and not model:FindFirstChild("ESP_GUI") then
        local esp = Instance.new("BillboardGui")
        esp.Name = "ESP_GUI"
        esp.Size = UDim2.new(0, 120, 0, 20)
        esp.Adornee = model.HumanoidRootPart
        esp.AlwaysOnTop = true
        esp.StudsOffset = Vector3.new(0, 3, 0)

        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, 0, 1, 0)
        label.Text = "the rake"
        label.TextColor3 = Color3.fromRGB(255, 0, 0)
        label.BackgroundTransparency = 1
        label.TextScaled = true
        label.Font = Enum.Font.SourceSansBold
        label.Parent = esp

        esp.Parent = model
        updateDistance(label, model.HumanoidRootPart)
    end
end

-- Cari testMom yang udah ada
for _, obj in pairs(workspace:GetDescendants()) do
    if obj:IsA("Model") and obj.Name == "testMom" and obj:FindFirstChild("HumanoidRootPart") then
        addESP(obj)
    end
end

-- Deteksi testMom baru
workspace.DescendantAdded:Connect(function(obj)
    if obj:IsA("Model") and obj.Name == "testMom" then
        obj.ChildAdded:Connect(function(child)
            if child.Name == "HumanoidRootPart" then
                wait(0.5)
                addESP(obj)
            end
        end)
    end
end)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local humanoid = char:WaitForChild("Humanoid")

-- Cegah reset WalkSpeed
RunService.RenderStepped:Connect(function()
    if humanoid and humanoid.WalkSpeed ~= 50 then
        humanoid.WalkSpeed = 50
    end
end)

-- Cegah script game yang coba ubah lagi pas character respawn
player.CharacterAdded:Connect(function(char)
    humanoid = char:WaitForChild("Humanoid")
    RunService.RenderStepped:Connect(function()
        if humanoid and humanoid.WalkSpeed ~= 50 then
            humanoid.WalkSpeed = 50
        end
    end)
end)
