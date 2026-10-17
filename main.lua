
-- Blue Hub | Brookhaven Edition
-- Roblox Studio LocalScript
-- Place in StarterPlayer > StarterPlayerScripts

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Configuration
local HUB_NAME = "Blue Hub"
local ACCESS_KEY = "BLUE-2026" -- Demo key only
local BROOKHAVEN_PLACE_ID = 4924922222

local BLUE = Color3.fromRGB(20, 115, 255)
local DARK = Color3.fromRGB(10, 17, 32)
local PANEL = Color3.fromRGB(17, 29, 50)
local WHITE = Color3.fromRGB(240, 246, 255)

-- Brookhaven-only restriction
if game.PlaceId ~= BROOKHAVEN_PLACE_ID then
    warn(HUB_NAME .. ": This hub is for Brookhaven only.")
    return
end

local gui = Instance.new("ScreenGui")
gui.Name = "BlueHub"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.Parent = playerGui

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
        TextSize = 14,
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
    PlaceholderText = "Enter your key...",
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
    Text = "Enter your access key to continue",
    TextColor3 = Color3.fromRGB(150, 185, 235),
    Font = Enum.Font.Gotham,
    TextSize = 11
}, keyFrame)

-- Main hub
local hub = create("Frame", {
    Size = UDim2.fromOffset(440, 330),
    Position = UDim2.new(0.5, -220, 0.5, -165),
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
    Text = "Brookhaven roleplay tools",
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

local content = create("Frame", {
    Position = UDim2.fromOffset(14, 78),
    Size = UDim2.new(1, -28, 1, -92),
    BackgroundTransparency = 1
}, hub)

local message = create("TextLabel", {
    Position = UDim2.fromOffset(8, 0),
    Size = UDim2.new(1, -16, 0, 44),
    BackgroundTransparency = 1,
    Text = "Welcome to Blue Hub!",
    TextColor3 = WHITE,
    Font = Enum.Font.GothamSemibold,
    TextSize = 17,
    TextXAlignment = Enum.TextXAlignment.Left
}, content)

local function featureButton(text, y, callback)
    local button = makeButton(
        content,
        text,
        UDim2.fromOffset(8, y),
        UDim2.new(1, -16, 0, 42)
    )
    button.MouseButton1Click:Connect(callback)
    return button
end

featureButton("Roleplay Ideas", 53, function()
    message.Text = "Try: police, doctor, family or business RP!"
end)

featureButton("Character Options", 103, function()
    message.Text = "Use Roblox avatar settings to customize your look."
end)

featureButton("Reset Character", 153, function()
    message.Text = "Resetting your character..."
    local character = player.Character
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")

    if humanoid then
        humanoid.Health = 0
    end
end)

featureButton("Hide / Show Hub", 203, function()
    hub.Visible = false
end)

-- Make the hub draggable
local dragging = false
local dragStart
local startPosition

header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPosition = hub.Position
    end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
    if dragging and (
        input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch
    ) then
        local delta = input.Position - dragStart
        hub.Position = UDim2.new(
            startPosition.X.Scale,
            startPosition.X.Offset + delta.X,
            startPosition.Y.Scale,
            startPosition.Y.Offset + delta.Y
        )
    end
end)

game:GetService("UserInputService").InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

close.MouseButton1Click:Connect(function()
    hub.Visible = false
    keyFrame.Visible = false
end)

unlock.MouseButton1Click:Connect(function()
    if keyInput.Text == ACCESS_KEY then
        status.Text = "Access granted!"
        status.TextColor3 = Color3.fromRGB(70, 230, 140)

        TweenService:Create(
            keyFrame,
            TweenInfo.new(0.2),
            {BackgroundTransparency = 1}
        ):Play()

        task.wait(0.2)
        keyFrame.Visible = false
        hub.Visible = true
    else
        status.Text = "Invalid key. Try again."
        status.TextColor3 = Color3.fromRGB(255, 95, 95)
    end
end)

print("Blue Hub loaded successfully.")
