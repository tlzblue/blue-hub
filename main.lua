-- Blue Hub | Brookhaven Edition (Delta Mobile/PC Fully Loaded)

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local targetGuiParent = game:GetService("CoreGui") or player:WaitForChild("PlayerGui")

-- Configuration
local HUB_NAME = "Blue Hub"
local BROOKHAVEN_PLACE_ID = 4924922222

local BLUE = Color3.fromRGB(20, 115, 255)
local DARK = Color3.fromRGB(10, 17, 32)
local PANEL = Color3.fromRGB(17, 29, 50)
local WHITE = Color3.fromRGB(240, 246, 255)

-- Flexible Key Validation Logic (Requires prefix "Blue-" followed by any text characters)
local function verifyGeneratedKey(inputKey)
    -- Remove trailing/leading whitespaces safely
    local cleanKey = tostring(inputKey):match("^%s*(.-)%s*$")
    
    if #cleanKey < 6 then
        return false, "Key is too short!"
    end
    
    -- Extract the first 5 characters and check if they equal "blue-"
    local prefix = cleanKey:sub(1, 5):lower()
    local payload = cleanKey:sub(6)
    
    if prefix == "blue-" and #payload > 0 then
        return true, "Success"
    else
        return false, "Invalid key! Must start with 'Blue-'"
    end
end

-- Teleport check optimized for executor injection environments
if game.PlaceId ~= BROOKHAVEN_PLACE_ID and game.GameId ~= 1550091392 then
    warn(HUB_NAME .. ": This hub is built for Brookhaven only.")
    return
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
        TextSize = 13,
        AutoButtonColor = true
    }, parent)

    round(button, 8)
    return button
end

-- Key screen
local keyFrame = create("Frame", {
    Size = UDim2.fromOffset(340, 225),
    Position = UDim2.new(0.5, -170, 0.5, -112),
    BackgroundColor3 = DARK,
    BorderSizePixel = 0
}, gui)
round(keyFrame, 14)

create("UIStroke", {
    Color = BLUE,
    Thickness = 1.5
}, keyFrame)

local logo = create("TextLabel", {
    Size = UDim2.fromOffset(46, 46),
    Position = UDim2.fromOffset(18, 16),
    BackgroundColor3 = BLUE,
    Text = "B",
    TextColor3 = WHITE,
    Font = Enum.Font.GothamBlack,
    TextSize = 30
}, keyFrame)
round(logo, 12)

create("TextLabel", {
    Position = UDim2.fromOffset(76, 16),
    Size = UDim2.new(1, -90, 0, 27),
    BackgroundTransparency = 1,
    Text = HUB_NAME,
    TextColor3 = WHITE,
    Font = Enum.Font.GothamBold,
    TextSize = 22,
    TextXAlignment = Enum.TextXAlignment.Left
}, keyFrame)

create("TextLabel", {
    Position = UDim2.fromOffset(77, 43),
    Size = UDim2.new(1, -90, 0, 20),
    BackgroundTransparency = 1,
    Text = "BROOKHAVEN EDITION",
    TextColor3 = Color3.fromRGB(120, 175, 255),
    Font = Enum.Font.Gotham,
    TextSize = 11,
    TextXAlignment = Enum.TextXAlignment.Left
}, keyFrame)

local keyInput = create("TextBox", {
    Position = UDim2.fromOffset(20, 83),
    Size = UDim2.new(1, -40, 0, 42),
    BackgroundColor3 = PANEL,
    Text = "",
    PlaceholderText = "Enter key (Starts with Blue-)...",
    PlaceholderColor3 = Color3.fromRGB(140, 155, 180),
    TextColor3 = WHITE,
    Font = Enum.Font.Gotham,
    TextSize = 14,
    ClearTextOnFocus = false
}, keyFrame)
round(keyInput, 8)

local unlock = makeButton(
    keyFrame,
    "UNLOCK BLUE HUB",
    UDim2.fromOffset(20, 137),
    UDim2.new(1, -40, 0, 40)
)

local status = create("TextLabel", {
    Position = UDim2.fromOffset(15, 182),
    Size = UDim2.new(1, -30, 0, 25),
    BackgroundTransparency = 1,
    Text = "Any key works as long as it starts with Blue-",
    TextColor3 = Color3.fromRGB(150, 185, 235),
    Font = Enum.Font.Gotham,
    TextSize = 11
}, keyFrame)

-- Main hub panel window frame
local hub = create("Frame", {
    Size = UDim2.fromOffset(500, 360),
    Position = UDim2.new(0.5, -250, 0.5, -180),
    BackgroundColor3 = DARK,
    BorderSizePixel = 0,
    Visible = false
}, gui)
round(hub, 14)

create("UIStroke", {
    Color = BLUE,
    Thickness = 1.5
}, hub)

local header = create("Frame", {
    Size = UDim2.new(1, 0, 0, 65),
    BackgroundColor3 = PANEL,
    BorderSizePixel = 0
}, hub)
round(header, 14)

local headerCover = create("Frame", {
    Position = UDim2.new(0, 0, 1, -14),
    Size = UDim2.new(1, 0, 0, 14),
    BackgroundColor3 = PANEL,
    BorderSizePixel = 0
}, header)

local headerLogo = create("TextLabel", {
    Position = UDim2.fromOffset(15, 10),
    Size = UDim2.fromOffset(42, 42),
    BackgroundColor3 = BLUE,
    Text = "B",
    TextColor3 = WHITE,
    Font = Enum.Font.GothamBlack,
    TextSize = 27
}, header)
round(headerLogo, 10)

create("TextLabel", {
    Position = UDim2.fromOffset(68, 10),
    Size = UDim2.fromOffset(260, 27),
    BackgroundTransparency = 1,
    Text = HUB_NAME,
    TextColor3 = WHITE,
    Font = Enum.Font.GothamBold,
    TextSize = 21,
    TextXAlignment = Enum.TextXAlignment.Left
}, header)

create("TextLabel", {
    Position = UDim2.fromOffset(69, 36),
    Size = UDim2.fromOffset(260, 17),
    BackgroundTransparency = 1,
    Text = "Brookhaven fully loaded tools",
    TextColor3 = Color3.fromRGB(135, 175, 235),
    Font = Enum.Font.Gotham,
    TextSize = 11,
    TextXAlignment = Enum.TextXAlignment.Left
}, header)

local close = makeButton(
    header, "X",
    UDim2.new(1, -48, 0, 14),
    UDim2.fromOffset(32, 32)
)

-- Layout Panel Navigation Elements
local sidebar = create("Frame", {
    Position = UDim2.fromOffset(0, 65),
    Size = UDim2.fromOffset(130, 295),
    BackgroundColor3 = PANEL,
    BorderSizePixel = 0
}, hub)

local containerLayout = create("ScrollingFrame", {
    Position = UDim2.fromOffset(140, 75),
    Size = UDim2.new(1, -150, 1, -85),
    BackgroundTransparency = 1,
    CanvasSize = UDim2.new(0, 0, 0, 450),
    ScrollBarThickness = 4,
    ScrollBarImageColor3 = BLUE
}, hub)

local listLayout = create("UIListLayout", {
    Padding = UDim.new(0, 10),
    SortOrder = Enum.SortOrder.LayoutOrder
}, containerLayout)

-- Feature Helpers
local function teleportTo(cframe)
    local char = player.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        char.HumanoidRootPart.CFrame = cframe
    end
end

-- Loaded Movement Speed Systems Runtime Controls Loop
local currentSpeedValue = 16
local currentJumpValue = 50

task.spawn(function()
    while task.wait(0.5) do
        local char = player.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.WalkSpeed = currentSpeedValue
            hum.JumpPower = currentJumpValue
            hum.UseJumpPower = true
        end
    end
end)

-- Tab Menu Framework UI Elements Reset
local function clearContainer()
    for _, child in pairs(containerLayout:GetChildren()) do
        if child:IsA("TextButton") or child:IsA("TextBox") or child:IsA("Frame") then
            child:Destroy()
        end
    end
end

local function addFeature(text, callback)
    local btn = makeButton(containerLayout, text, UDim2.new(0,0,0,0), UDim2.new(1, -10, 0, 40))
    btn.MouseButton1Click:Connect(callback)
end

-- Menu Sections Initialization Elements
local function showMovementTab()
    clearContainer()
    
    addFeature("Speed Boost (Fast)", function() currentSpeedValue = 60 end)
    addFeature("Super Sonic Speed", function() currentSpeedValue = 150 end)
    addFeature("Normal Speed", function() currentSpeedValue = 16 end)
    
    addFeature("High Jump Boost", function() currentJumpValue = 100 end)
    addFeature("Normal Jump Power", function() currentJumpValue = 50 end)
end

local function showTeleportsTab()
    clearContainer()
    
    addFeature("Teleport to Bank", function()
        teleportTo(CFrame.new(-22, 14, 50))
    end)
    addFeature("Teleport to Town Hall", function()
        teleportTo(CFrame.new(-12, 14, -130))
    end)
    addFeature("Teleport to Hospital", function()
        teleportTo(CFrame.new(160, 14, -25))
    end)
    addFeature("Teleport to Food Mart", function()
        teleportTo(CFrame.new(-85, 14, 12))
    end)
end

local function showVehicleTab()
    clearContainer()
    
    addFeature("Boost Current Car Speed", function()
        local char = player.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if hum and hum.SeatPart and hum.SeatPart:IsA("VehicleSeat") then
            hum.SeatPart.MaxSpeed = 250
            hum.SeatPart.Torque = 1000
        end
    end)
    
    addFeature("Normal Vehicle Speeds", function()
        local char = player.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if hum and hum.SeatPart and hum.SeatPart:IsA("VehicleSeat") then
            hum.SeatPart.MaxSpeed = 50
        end
    end)
end

-- Sidebar Navigation Controls Buttons Binding Setup
local navLayout = create("UIListLayout", {Padding = UDim.new(0, 5)}, sidebar)
local mBtn = makeButton(sidebar, "Player Speed", UDim2.fromOffset(5, 10), UDim2.fromOffset(120, 35))
local tBtn = makeButton(sidebar, "Teleports", UDim2.fromOffset(5, 50), UDim2.fromOffset(120, 35))
local vBtn = makeButton(sidebar, "Vehicle Mod", UDim2.fromOffset(5, 90), UDim2.fromOffset(120, 35))

Use code with caution.
mBtn.MouseButton1Click:Connect(showMovementTab)
tBtn.MouseButton1Click:Connect(showTeleportsTab)
vBtn.MouseButton1Click:Connect(showVehicleTab)
-- Touch Screen Window Dragging Setup Framework Actions
local dragging = false
local dragStart
local startPosition
header.InputBegan:Connect(function(input)
if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
dragging = true
dragStart = input.Position
startPosition = hub.Position
end
end)
UserInputService.InputChanged:Connect(function(input)
if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
local delta = input.Position - dragStart
hub.Position = UDim2.new(
startPosition.X.Scale,
startPosition.X.Offset + delta.X,
startPosition.Y.Scale,
startPosition.Y.Offset + delta.Y
)
end
end)
UserInputService.InputEnded:Connect(function(input)
if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
dragging = false
end
end)
close.MouseButton1Click:Connect(function()
gui:Destroy()
end)
-- Form Validation Submission Hook Trigger Click Sequence
unlock.MouseButton1Click:Connect(function()
local userTypedKey = keyInput.Text
local success, errMsg = verifyGeneratedKey(userTypedKey)
if success then
status.Text = "Access granted!"
status.TextColor3 = Color3.fromRGB(70, 230, 140)
TweenService:Create(keyFrame, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play()
task.wait(0.2)
keyFrame.Visible = false
hub.Visible = true
showMovementTab()
else
status.Text = errMsg
status.TextColor3 = Color3.fromRGB(255, 100, 100)
end
end)
