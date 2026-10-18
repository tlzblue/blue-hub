-- Blue Hub | Brookhaven Edition (Delta Mobile/PC Fully Loaded)

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

-- Asynchronous safe loader hook for mobile memory frames
if not game:IsLoaded() then game.Loaded:Wait() end
repeat task.wait(0.1) until Players.LocalPlayer and Players.LocalPlayer:FindFirstChild("PlayerGui")

local player = Players.LocalPlayer
local targetGuiParent = player:WaitForChild("PlayerGui")

-- Configuration
local HUB_NAME = "Blue Hub"
local BLUE = Color3.fromRGB(20, 115, 255)
local DARK = Color3.fromRGB(10, 17, 32)
local PANEL = Color3.fromRGB(17, 29, 50)
local WHITE = Color3.fromRGB(240, 246, 255)

local currentSpeedValue = 16
local currentJumpValue = 50
local currentCarSpeed = 45
local carJumpBoost = 0
local carFlyActive = false

-- Flexible Key Validation Logic (Requires prefix "Blue-" followed by any text characters)
local function verifyGeneratedKey(inputKey)
    local cleanKey = tostring(inputKey):match("^%s*(.-)%s*$") or ""
    if #cleanKey < 6 then
        return false, "Key is too short!"
    end
    
    local prefix = cleanKey:sub(1, 5):lower()
    local payload = cleanKey:sub(6)
    
    if prefix == "blue-" and #payload > 0 then
        return true, "Success"
    else
        return false, "Invalid key! Must start with 'Blue-'"
    end
end

-- Clean up any existing instances from previous executions
if targetGuiParent:FindFirstChild("BlueHub") then
    targetGuiParent:FindFirstChild("BlueHub"):Destroy()
end

local gui = Instance.new("ScreenGui")
gui.Name = "BlueHub"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.Parent = targetGuiParent

local function create(className, properties, parent)
    local object = Instance.new(className)
    for property, value in pairs(properties) do
        object[property] = value
    end
    object.Parent = parent
    return object
end

local function round(object, radius)
    create("UICorner", {
        CornerRadius = UDim.new(0, radius)
    }, object)
end

local function makeButton(parent, text, position, size)
    local button = create("TextButton", {
        Text = text,
        Position = position,
        Size = size,
        BackgroundColor3 = BLUE,
        TextColor3 = WHITE,
        Font = Enum.Font.GothamSemibold,
        TextSize = 11,
        AutoButtonColor = true
    }, parent)
    round(button, 6)
    return button
end

-- Key screen layout optimized for mobile screens
local keyFrame = create("Frame", {
    Size = UDim2.fromOffset(260, 170),
    Position = UDim2.new(0.5, -130, 0.4, -85),
    BackgroundColor3 = DARK,
    BorderSizePixel = 0
}, gui)
round(keyFrame, 10)

create("UIStroke", {
    Color = BLUE,
    Thickness = 1.2
}, keyFrame)

local logo = create("TextLabel", {
    Size = UDim2.fromOffset(36, 36),
    Position = UDim2.fromOffset(15, 12),
    BackgroundColor3 = BLUE,
    Text = "B",
    TextColor3 = WHITE,
    Font = Enum.Font.GothamBlack,
    TextSize = 22
}, keyFrame)
round(logo, 8)

create("TextLabel", {
    Position = UDim2.fromOffset(60, 12),
    Size = UDim2.new(1, -75, 0, 22),
    BackgroundTransparency = 1,
    Text = HUB_NAME,
    TextColor3 = WHITE,
    Font = Enum.Font.GothamBold,
    TextSize = 18,
    TextXAlignment = Enum.TextXAlignment.Left
}, keyFrame)

local keyInput = create("TextBox", {
    Position = UDim2.fromOffset(15, 58),
    Size = UDim2.new(1, -30, 0, 35),
    BackgroundColor3 = PANEL,
    Text = "",
    PlaceholderText = "Enter key here...",
    PlaceholderColor3 = Color3.fromRGB(140, 155, 180),
    TextColor3 = WHITE,
    Font = Enum.Font.Gotham,
    TextSize = 12,
    ClearTextOnFocus = false
}, keyFrame)
round(keyInput, 6)

local unlock = makeButton(
    keyFrame,
    "UNLOCK BLUE HUB",
    UDim2.fromOffset(15, 105),
    UDim2.new(1, -30, 0, 35)
)

local status = create("TextLabel", {
    Position = UDim2.fromOffset(15, 146),
    Size = UDim2.new(1, -30, 0, 18),
    BackgroundTransparency = 1,
    Text = "Any key works as long as it starts with Blue-",
    TextColor3 = Color3.fromRGB(150, 185, 235),
    Font = Enum.Font.Gotham,
    TextSize = 10
}, keyFrame)

-- Main hub panel window frame
local hub = create("Frame", {
    Size = UDim2.fromOffset(360, 220),
    Position = UDim2.new(0.5, -180, 0.4, -110),
    BackgroundColor3 = DARK,
    BorderSizePixel = 0,
    Visible = false
}, gui)
round(hub, 10)

create("UIStroke", {
    Color = BLUE,
    Thickness = 1.2
}, hub)

local header = create("Frame", {
    Size = UDim2.new(1, 0, 0, 40),
    BackgroundColor3 = PANEL,
    BorderSizePixel = 0
}, hub)
round(header, 10)

local headerLogo = create("TextLabel", {
    Position = UDim2.fromOffset(12, 6),
    Size = UDim2.fromOffset(28, 28),
    BackgroundColor3 = BLUE,
    Text = "B",
    TextColor3 = WHITE,
    Font = Enum.Font.GothamBlack,
    TextSize = 18
}, header)
round(headerLogo, 6)

create("TextLabel", {
    Position = UDim2.fromOffset(48, 6),
    Size = UDim2.fromOffset(200, 20),
    BackgroundTransparency = 1,
    Text = HUB_NAME,
    TextColor3 = WHITE,
    Font = Enum.Font.GothamBold,
    TextSize = 16,
    TextXAlignment = Enum.TextXAlignment.Left
}, header)

local close = makeButton(
    header, "X",
    UDim2.new(1, -35, 0, 6),
    UDim2.fromOffset(28, 28)
)

close.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

-- Mobile Quick-Toggle Minimizer Icon Overlay
local openMobileToggle = makeButton(
    gui, "B",
    UDim2.new(0, 10, 0, 10),
    UDim2.fromOffset(35, 35)
)
openMobileToggle.Visible = false

openMobileToggle.MouseButton1Click:Connect(function()
    if hub.Visible or keyFrame.Visible then
        hub.Visible, keyFrame.Visible = false, false
    else
        hub.Visible = true
    end
end)

-- Layout Panel Navigation Elements
local sidebar = create("Frame", {
    Position = UDim2.fromOffset(0, 40),
    Size = UDimOffset(90, 180),
    BackgroundColor3 = PANEL,
    BorderSizePixel = 0
}, hub)
sidebar.Size = UDim2.fromOffset(90, 180) -- Safety validation override line

local containerLayout = create("ScrollingFrame", {
    Position = UDim2.fromOffset(100, 48),
    Size = UDim2.new(1, -110, 1, -56),
    BackgroundTransparency = 1,
    CanvasSize = UDim2.new(0, 0, 0, 260),
    ScrollBarThickness = 2,
    ScrollBarImageColor3 = BLUE
}, hub)

local listLayout = create("UIListLayout", {
    Padding = UDim.new(0, 5),
    SortOrder = Enum.SortOrder.LayoutOrder
}, containerLayout)

-- Loaded Movement Speed Systems Runtime Controls Loop
task.spawn(function()
    while task.wait(0.4) do
        if not gui or not gui.Parent then break end
        local char = player.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.WalkSpeed = currentSpeedValue
            hum.JumpPower = currentJumpValue
            hum.UseJumpPower = true
            
            -- Core loop verification scanning for vehicle driving models
            if hum.SeatPart and hum.SeatPart:IsA("VehicleSeat") then
                local vehicleSeat = hum.SeatPart
                vehicleSeat.MaxSpeed = currentCarSpeed
                
                if carJumpBoost > 0 and UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                    vehicleSeat.AssemblyLinearVelocity = vehicleSeat.AssemblyLinearVelocity + Vector3.new(0, carJumpBoost, 0)
                end
                
                if carFlyActive then
                    vehicleSeat.AssemblyLinearVelocity = Vector3.new(vehicleSeat.AssemblyLinearVelocity.X, 1.5, vehicleSeat.AssemblyLinearVelocity.Z) + (hum.MoveDirection * currentCarSpeed)
                end
            end
        end
    end
end)

-- Tab Menu Framework UI Elements Reset
local function clearContainer()
    for _, child in pairs(containerLayout:GetChildren()) do
        if child:IsA("TextButton") then
            child:Destroy()
        end
    end
end

local function addFeature(text, callback)
    makeButton(containerLayout, text, UDim2.new(0,0,0,0), UDim2.new(1, -4, 0, 30), callback)
end

-- Menu Sections Initialization Elements
local function showMovementTab()
    clearContainer()
    addFeature("Speed Boost (Fast)", function() currentSpeedValue = 60 end)
    addFeature("Super Sonic Speed", function() currentSpeedValue = 150 end)
    addFeature("Normal Speed", function() currentSpeedValue = 16 end)
    addFeature("High Jump", function() currentJumpValue = 120 end)
end

local function showTeleportTab()
    clearContainer()
    local function teleportTo(cframe)
        local char = player.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            char.HumanoidRootPart.CFrame = cframe
        end
    end
    addFeature("Teleport to Spawn", function() teleportTo(CFrame.new(0, 5, 0)) end)
    addFeature("Teleport to Bank", function() teleportTo(CFrame.new(-22, 4, 32)) end)
end

local function showVehicleTab()
    clearContainer()
    addFeature("Car Velocity: 100", function() currentCarSpeed = 100 carFlyActive = false end)
    addFeature("Car Velocity: 250", function() currentCarSpeed = 250 carFlyActive = false end)
    addFeature("Car Flight System", function() currentCarSpeed = 75 carFlyActive = not carFlyActive end)
    addFeature("Car Springs Boost", function() carJumpBoost = 45 end)
    addFeature("Reset All Vehicles", function() currentCarSpeed = 45 carJumpBoost = 0 carFlyActive = false end)
end

-- Setup navigation sidebar buttons
local moveTabBtn = makeButton(sidebar, "Movement", UDim2.fromOffset(6, 10), UDim2.fromOffset(78, 24))
local teleTabBtn = makeButton(sidebar, "Teleports", UDim2.fromOffset(6, 38), UDim2.fromOffset(78, 24))
local vehTabBtn = makeButton(sidebar, "Vehicles", UDim2.fromOffset(6, 66), UDim2.fromOffset(78, 24))

moveTabBtn.MouseButton1Click:Connect(showMovementTab)
teleTabBtn.MouseButton1Click:Connect(showTeleportTab)
vehTabBtn.MouseButton1Click:Connect(showVehicleTab)

-- Key Submission handler execution connection
Use code with caution.
unlock.MouseButton1Click:Connect(function()
local input = keyInput.Text
local success, errMsg = verifyGeneratedKey(input)
if success then
status.Text = "Access Granted! Loading..."
status.TextColor3 = Color3.fromRGB(50, 220, 110)
task.wait(0.5)
keyFrame.Visible = false
hub.Visible = true
openMobileToggle.Visible = true
showMovementTab()
else
status.Text = errMsg
status.TextColor3 = Color3.fromRGB(255, 75, 75)
end
end)
-- Touch Drag Interface Module for Mobile Devices
local function makeDraggable(frame)
local dragging, dragInput, dragStart, startPos
frame.InputBegan:Connect(function(input)
if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
dragging = true
dragStart = input.Position
startPos = frame.Position
input.Changed:Connect(function()
if input.UserInputState == Enum.UserInputState.End then dragging = false end
end)
end
end)
frame.InputChanged:Connect(function(input)
if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end
end)
UserInputService.InputChanged:Connect(function(input)
if input == dragInput and dragging then
local delta = input.Position - dragStart
frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end
end)
end
makeDraggable(keyFrame)
makeDraggable(hub)
makeDraggable(openMobileToggle)
