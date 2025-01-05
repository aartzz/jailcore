local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ClickGUI"
ScreenGui.Parent = game.CoreGui

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 600, 0, 400)
MainFrame.Position = UDim2.new(0.5, -300, 0.5, -200)
MainFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
MainFrame.Visible = false
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local WatermarkFrame = Instance.new("Frame")
WatermarkFrame.Name = "Watermark"
WatermarkFrame.Size = UDim2.new(0, 250, 0, 30)
WatermarkFrame.Position = UDim2.new(0, 10, 0, 10)
WatermarkFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
WatermarkFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
WatermarkFrame.BorderSizePixel = 2
WatermarkFrame.Parent = ScreenGui

local GreenBar = Instance.new("Frame")
GreenBar.Name = "GreenBar"
GreenBar.Size = UDim2.new(1, 0, 0, 3)
GreenBar.Position = UDim2.new(0, 0, 0, 0)
GreenBar.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
GreenBar.Parent = WatermarkFrame

local MainLabel = Instance.new("TextLabel")
MainLabel.Name = "MainLabel"
MainLabel.Size = UDim2.new(0, 100, 1, 0)
MainLabel.Position = UDim2.new(0, 5, 0, 0)
MainLabel.BackgroundTransparency = 1
MainLabel.Text = "JailCore"
MainLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
MainLabel.TextSize = 14
MainLabel.Font = Enum.Font.SourceSansBold
MainLabel.TextXAlignment = Enum.TextXAlignment.Left
MainLabel.Parent = WatermarkFrame

local TimeLabel = Instance.new("TextLabel")
TimeLabel.Name = "TimeLabel"
TimeLabel.Size = UDim2.new(0, 100, 1, 0)
TimeLabel.Position = UDim2.new(0, 110, 0, 0)
TimeLabel.BackgroundTransparency = 1
TimeLabel.Text = "00:00:00"
TimeLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TimeLabel.TextSize = 14
TimeLabel.Font = Enum.Font.SourceSans
TimeLabel.TextXAlignment = Enum.TextXAlignment.Left
TimeLabel.Parent = WatermarkFrame

local FpsLabel = Instance.new("TextLabel")
FpsLabel.Name = "FpsLabel"
FpsLabel.Size = UDim2.new(0, 50, 1, 0)
FpsLabel.Position = UDim2.new(0, 210, 0, 0)
FpsLabel.BackgroundTransparency = 1
FpsLabel.Text = "FPS: 60"
FpsLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
FpsLabel.TextSize = 14
FpsLabel.Font = Enum.Font.SourceSans
FpsLabel.TextXAlignment = Enum.TextXAlignment.Left
FpsLabel.Parent = WatermarkFrame

local CategoriesFrame = Instance.new("Frame")
CategoriesFrame.Name = "CategoriesFrame"
CategoriesFrame.Size = UDim2.new(0, 150, 1, 0)
CategoriesFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
CategoriesFrame.Parent = MainFrame

local ContentFrame = Instance.new("Frame")
ContentFrame.Name = "ContentFrame"
ContentFrame.Size = UDim2.new(1, -150, 1, 0)
ContentFrame.Position = UDim2.new(0, 150, 0, 0)
ContentFrame.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
ContentFrame.Parent = MainFrame

local function switchContent(categoryName)
    for _, child in pairs(ContentFrame:GetChildren()) do
        child.Visible = false
    end
    if ContentFrame:FindFirstChild(categoryName) then
        ContentFrame[categoryName].Visible = true
    end
end

local Categories = {"Combat", "Movement", "Visual"}

for i, category in ipairs(Categories) do
    local button = Instance.new("TextButton")
    button.Name = category .. "Button"
    button.Size = UDim2.new(1, 0, 0, 50)
    button.Position = UDim2.new(0, 0, 0, (i - 1) * 50)
    button.Text = category
    button.Parent = CategoriesFrame
    button.MouseButton1Click:Connect(function()
        switchContent(category)
    end)
    local content = Instance.new("Frame")
    content.Name = category
    content.Size = UDim2.new(1, 0, 1, 0)
    content.Visible = i == 1
    content.Parent = ContentFrame

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 0, 50)
    label.Text = category .. " Content"
    label.Parent = content
end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local UserInputService = game:GetService("UserInputService")

local isMoving = false

local espEnabled = false
local espObjects = {}

local function checkMovementInput()
    local keys = {Enum.KeyCode.W, Enum.KeyCode.A, Enum.KeyCode.S, Enum.KeyCode.D}
    for _, key in ipairs(keys) do
        if UserInputService:IsKeyDown(key) then
            return true
        end
    end
    return false
end

local function createEspForPlayer(player)
    local espBox = Drawing.new("Square")
    espBox.Color = Color3.new(1, 1, 1)
    espBox.Thickness = 2
    espBox.Filled = false
    espBox.Visible = false
    local healthBar = Drawing.new("Line")
    healthBar.Color = Color3.new(0, 1, 0)
    healthBar.Thickness = 3
    healthBar.Visible = false
    espObjects[player] = {
        Box = espBox,
        HealthBar = healthBar
    }
end

local function updateEspForPlayer(player)
    local character = player.Character
    local esp = espObjects[player]

    if not (character and character:FindFirstChild("HumanoidRootPart") and character:FindFirstChild("Humanoid")) then
        esp.Box.Visible = false
        esp.HealthBar.Visible = false
        return
    end
    local rootPart = character.HumanoidRootPart
    local humanoid = character.Humanoid
    local vector, onScreen = workspace.CurrentCamera:WorldToViewportPoint(rootPart.Position)
    if onScreen then
        local headPosition = workspace.CurrentCamera:WorldToViewportPoint(rootPart.Position + Vector3.new(0, 3, 0))
        local footPosition = workspace.CurrentCamera:WorldToViewportPoint(rootPart.Position - Vector3.new(0, 3, 0))
        local boxHeight = headPosition.Y - footPosition.Y
        local boxWidth = boxHeight / 2

        esp.Box.Size = Vector2.new(boxWidth, boxHeight)
        esp.Box.Position = Vector2.new(vector.X - boxWidth / 2, vector.Y - boxHeight / 2)
        esp.Box.Visible = true

        local healthPercent = humanoid.Health / humanoid.MaxHealth
        esp.HealthBar.From = Vector2.new(esp.Box.Position.X - 5, esp.Box.Position.Y + boxHeight)
        esp.HealthBar.To = Vector2.new(esp.Box.Position.X - 5, esp.Box.Position.Y + boxHeight - (boxHeight * healthPercent))
        esp.HealthBar.Visible = true
        esp.HealthBar.Color = Color3.new(1 - healthPercent, healthPercent, 0)
    else
        esp.Box.Visible = false
        esp.HealthBar.Visible = false
    end
end


local function toggleEsp()
    espEnabled = not espEnabled
    for _, player in pairs(Players:GetPlayers()) do
        if espEnabled then
            createEspForPlayer(player)
        else
            if espObjects[player] then
                espObjects[player].Box:Remove()
                espObjects[player].HealthBar:Remove()
                espObjects[player] = nil
            end
        end
    end
end

RunService.RenderStepped:Connect(function()
    if espEnabled then
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                updateEspForPlayer(player)
            end
        end
    end
end)

local bhopEnabled = false
local bhopSpeed = 80
local bhopConnection

local function bhopMethod()
    local character = LocalPlayer.Character
    if not character then return end

    local humanoid = character:FindFirstChildOfClass("Humanoid")
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if humanoid and rootPart and humanoid:GetState() == Enum.HumanoidStateType.Running then
        isMoving = checkMovementInput()
        if isMoving then
            local moveDirection = Vector3.new()

            -- Check which keys are pressed and adjust moveDirection accordingly
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                moveDirection = moveDirection + rootPart.CFrame.LookVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                moveDirection = moveDirection - rootPart.CFrame.LookVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                moveDirection = moveDirection - rootPart.CFrame.RightVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                moveDirection = moveDirection + rootPart.CFrame.RightVector
            end

            -- Normalize the direction to ensure consistent speed
            if moveDirection.Magnitude > 0 then
                moveDirection = moveDirection.Unit
            end

            rootPart.Velocity = Vector3.new(moveDirection.X * bhopSpeed, rootPart.Velocity.Y, moveDirection.Z * bhopSpeed)
        end
    end
end


local function onInputChanged(input, gameProcessed)
    if not gameProcessed and input.UserInputType == Enum.UserInputType.Keyboard then
        isMoving = checkMovementInput()
    end
end

local function toggleBHop()
    bhopEnabled = not bhopEnabled
    if bhopEnabled then
        bhopConnection = RunService.RenderStepped:Connect(bhopMethod)
    else
        if bhopConnection then
            bhopConnection:Disconnect()
            bhopConnection = nil
        end
    end
end

UserInputService.InputBegan:Connect(onInputChanged)
UserInputService.InputEnded:Connect(onInputChanged)

game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessed)
    if input.KeyCode == Enum.KeyCode.X and not gameProcessed then
        toggleBHop()
    end
end)

RunService.RenderStepped:Connect(function()
    if bhopEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local humanoidRootPart = LocalPlayer.Character.HumanoidRootPart
        local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
        if humanoidRootPart and humanoid then
            -- Check if the player is grounded
            if humanoid:GetState() == Enum.HumanoidStateType.Physics and humanoidRootPart.Velocity.Y == 0 then
                humanoid:ChangeState(Enum.HumanoidStateType.Physics)  -- Ensure it's in Physics mode
                humanoidRootPart.Velocity = Vector3.new(bhopSpeed, jumpSpeed, 0)  -- Apply velocity to simulate the bunny hop
            end
        end
    end
end)

local movementContent = ContentFrame:FindFirstChild("Movement")
if movementContent then
    local bhopLabel = Instance.new("TextLabel")
    bhopLabel.Size = UDim2.new(1, 0, 0, 30)
    bhopLabel.Position = UDim2.new(0, 0, 0, 60)
    bhopLabel.Text = "Bunny Hop Module"
    bhopLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    bhopLabel.BackgroundTransparency = 1
    bhopLabel.Parent = movementContent

    local enableBhopButton = Instance.new("TextButton")
    enableBhopButton.Size = UDim2.new(0, 100, 0, 30)
    enableBhopButton.Position = UDim2.new(0, 0, 0, 100)
    enableBhopButton.Text = "Enable BHop"
    enableBhopButton.Parent = movementContent

    enableBhopButton.MouseButton1Click:Connect(function()
        toggleBHop()
        enableBhopButton.Text = bhopEnabled and "Disable BHop" or "Enable BHop"
    end)
end

local visualContent = ContentFrame:FindFirstChild("Visual")
if visualContent then
    local espLabel = Instance.new("TextLabel")
    espLabel.Size = UDim2.new(1, 0, 0, 30)
    espLabel.Position = UDim2.new(0, 0, 0, 60)
    espLabel.Text = "ESP Module"
    espLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    espLabel.BackgroundTransparency = 1
    espLabel.Parent = visualContent

    local enableEspButton = Instance.new("TextButton")
    enableEspButton.Size = UDim2.new(0, 100, 0, 30)
    enableEspButton.Position = UDim2.new(0, 0, 0, 100)
    enableEspButton.Text = "Enable ESP"
    enableEspButton.Parent = visualContent

    enableEspButton.MouseButton1Click:Connect(function()
        toggleEsp()
        enableEspButton.Text = espEnabled and "Disable ESP" or "Enable ESP"
    end)
end

local function updateTimeAndFPS()
    local lastUpdate = tick()
    local frameCount = 0
    local fps = 0

    RunService.RenderStepped:Connect(function()
        frameCount = frameCount + 1
        if tick() - lastUpdate >= 1 then
            fps = frameCount
            frameCount = 0
            lastUpdate = tick()
        end
        TimeLabel.Text = os.date("%H:%M:%S")
        FpsLabel.Text = "FPS: " .. tostring(fps)
    end)
end

updateTimeAndFPS()

local function toggleGui()
    MainFrame.Visible = not MainFrame.Visible
end

game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessed)
    if input.KeyCode == Enum.KeyCode.P and not gameProcessed then
        toggleGui()
    end
end)
