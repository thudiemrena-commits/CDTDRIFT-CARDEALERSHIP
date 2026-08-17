-- // RAYFIELD UI & MAIN SETUP // --
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "AIMDRIFT-CDT🚗",
    LoadingTitle = "MeoMeo StayLike System",
    LoadingSubtitle = "🇻🇳LHkhánhviệt",
    ConfigurationSaving = { Enabled = false, FolderName = nil, FileName = "MeoMeoConfig" },
    Discord = { Enabled = false },
    KeySystem = false
})

-- // TAB 1: INFORMATION // --
local InfoTab = Window:CreateTab("Info", 4483362458)
InfoTab:CreateLabel("InfoTIKTOK: meomeostaylike🇻🇳[-KHANH-]")
InfoTab:CreateLabel("Status: hello bro🇻🇳")
InfoTab:CreateLabel("Developer: khanhviet🇻🇳")

-- // TAB 2: MAIN MOVEMENT // --
local MainTab = Window:CreateTab("CdtDRIFT🚗", 4483362458)
local MovementSection = MainTab:CreateSection("AIM CDT Settings")

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

local isEnabled = false
local MovementSpeed = 45
local TurnSpeed = 120 -- Tốc độ xoay (độ / giây)

-- Trạng thái Tab 2
local isPushing = false
local isTurningLeft = false
local isTurningRight = false
local bodyVelocity = nil

local function stopPush()
    if bodyVelocity then
        bodyVelocity:Destroy()
        bodyVelocity = nil
    end
end

-- // TẠO SCREEN GUI TAB 2 // --
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MeoMeoControlGui"
ScreenGui.ResetOnSpawn = false
ScreenGui.Enabled = false

pcall(function() ScreenGui.Parent = game:GetService("CoreGui") end)
if not ScreenGui.Parent then ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

-- 1. CỤM NÚT QUẸO (BÊN TRÁI MÀN HÌNH)
local LeftTurnContainer = Instance.new("Frame")
LeftTurnContainer.Size = UDim2.new(0, 140, 0, 60)
LeftTurnContainer.Position = UDim2.new(0, 30, 0.5, 20)
LeftTurnContainer.BackgroundTransparency = 1
LeftTurnContainer.Parent = ScreenGui

local BtnTurnLeft = Instance.new("TextButton")
BtnTurnLeft.Size = UDim2.new(0, 65, 0, 55)
BtnTurnLeft.Position = UDim2.new(0, 0, 0, 0)
BtnTurnLeft.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
BtnTurnLeft.BorderColor3 = Color3.fromRGB(135, 206, 250)
BtnTurnLeft.BorderSizePixel = 2
BtnTurnLeft.TextColor3 = Color3.fromRGB(255, 255, 255)
BtnTurnLeft.Text = "◄ RE TRÁI"
BtnTurnLeft.Font = Enum.Font.SourceSansBold
BtnTurnLeft.TextSize = 12
BtnTurnLeft.Parent = LeftTurnContainer

local BtnTurnRight = Instance.new("TextButton")
BtnTurnRight.Size = UDim2.new(0, 65, 0, 55)
BtnTurnRight.Position = UDim2.new(0, 72, 0, 0)
BtnTurnRight.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
BtnTurnRight.BorderColor3 = Color3.fromRGB(135, 206, 250)
BtnTurnRight.BorderSizePixel = 2
BtnTurnRight.TextColor3 = Color3.fromRGB(255, 255, 255)
BtnTurnRight.Text = "RẼ PHẢI ►"
BtnTurnRight.Font = Enum.Font.SourceSansBold
BtnTurnRight.TextSize = 12
BtnTurnRight.Parent = LeftTurnContainer

-- 2. NÚT CHẠY ON/OFF (BÊN PHẢI MÀN HÌNH)
local BtnRun = Instance.new("TextButton")
BtnRun.Size = UDim2.new(0, 75, 0, 65)
BtnRun.Position = UDim2.new(1, -100, 0.5, 20)
BtnRun.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
BtnRun.BorderColor3 = Color3.fromRGB(255, 50, 50)
BtnRun.BorderSizePixel = 2
BtnRun.TextColor3 = Color3.fromRGB(255, 255, 255)
BtnRun.Text = "AIM RUN\n(OFF)"
BtnRun.Font = Enum.Font.SourceSansBold
BtnRun.TextSize = 13
BtnRun.Parent = ScreenGui

-- // SỰ KIỆN NÚT CHẠY ON / OFF // --
BtnRun.MouseButton1Click:Connect(function()
    isPushing = not isPushing
    if isPushing then
        BtnRun.Text = "AIM RUN\n(ON)"
        BtnRun.BackgroundColor3 = Color3.fromRGB(30, 144, 255)
        BtnRun.BorderColor3 = Color3.fromRGB(255, 255, 255)
    else
        BtnRun.Text = "AIM RUN\n(OFF)"
        BtnRun.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        BtnRun.BorderColor3 = Color3.fromRGB(255, 50, 50)
        stopPush()
    end
end)

-- // SỰ KIỆN ĐÈ NÚT QUẸO TRÁI / PHẢI // --
BtnTurnLeft.MouseButton1Down:Connect(function() isTurningLeft = true end)
BtnTurnLeft.MouseButton1Up:Connect(function() isTurningLeft = false end)
BtnTurnLeft.MouseLeave:Connect(function() isTurningLeft = false end)

BtnTurnRight.MouseButton1Down:Connect(function() isTurningRight = true end)
BtnTurnRight.MouseButton1Up:Connect(function() isTurningRight = false end)
BtnTurnRight.MouseLeave:Connect(function() isTurningRight = false end)

-- // RAYFIELD CONTROLS TAB 2 // --
MainTab:CreateToggle({
    Name = "Bật Chức Năng AIM CDT",
    CurrentValue = false,
    Flag = "AimCDTToggle",
    Callback = function(Value)
        isEnabled = Value
        ScreenGui.Enabled = Value
        if not isEnabled then
            isPushing = false
            isTurningLeft = false
            isTurningRight = false
            BtnRun.Text = "AIM RUN\n(OFF)"
            BtnRun.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            BtnRun.BorderColor3 = Color3.fromRGB(255, 50, 50)
            stopPush()
        end
    end,
})

MainTab:CreateSlider({
    Name = "Speed Chạy",
    Range = {0, 125},
    Increment = 1,
    Suffix = " Spd",
    CurrentValue = 45,
    Flag = "SpeedSlider",
    Callback = function(Value) MovementSpeed = Value end,
})

MainTab:CreateSlider({
    Name = "Tốc Độ Quẹo (Xoay)",
    Range = {30, 300},
    Increment = 5,
    Suffix = " Deg/s",
    CurrentValue = 120,
    Flag = "TurnSpeedSlider",
    Callback = function(Value) TurnSpeed = Value end,
})

-- // TAB 3: GAME INFORMATION // --
local GameTab = Window:CreateTab("game", 4483362458)
GameTab:CreateLabel("InfoTIKTOK2:🅰️™️ free money")
GameTab:CreateLabel("game: car dealershiptycoon")
GameTab:CreateLabel("Developer: follow me!")

-- // TAB 4: ANTI-ERROR // --
local AntiErrorTab = Window:CreateTab("anti-error", 4483362458)
local SpinSection = AntiErrorTab:CreateSection("Spin Drift Settings")

local isSpinEnabled = false
local spinRightSpeed = 180
local spinLeftSpeed = 180
local isSpinningRight = false
local isSpinningLeft = false

-- // TẠO GUI SPIN DRIFT VÀNG (TAB 4) // --
local SpinGui = Instance.new("ScreenGui")
SpinGui.Name = "MeoMeoSpinGui"
SpinGui.ResetOnSpawn = false
SpinGui.Enabled = false

pcall(function() SpinGui.Parent = game:GetService("CoreGui") end)
if not SpinGui.Parent then SpinGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

local SpinContainer = Instance.new("Frame")
SpinContainer.Size = UDim2.new(0, 140, 0, 60)
SpinContainer.Position = UDim2.new(0, 30, 0.3, 0)
SpinContainer.BackgroundTransparency = 1
SpinContainer.Parent = SpinGui

local BtnSpinLeft = Instance.new("TextButton")
BtnSpinLeft.Size = UDim2.new(0, 65, 0, 55)
BtnSpinLeft.Position = UDim2.new(0, 0, 0, 0)
BtnSpinLeft.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
BtnSpinLeft.BorderColor3 = Color3.fromRGB(255, 215, 0)
BtnSpinLeft.BorderSizePixel = 2
BtnSpinLeft.TextColor3 = Color3.fromRGB(255, 215, 0)
BtnSpinLeft.Text = "<spin"
BtnSpinLeft.Font = Enum.Font.SourceSansBold
BtnSpinLeft.TextSize = 14
BtnSpinLeft.Parent = SpinContainer

local BtnSpinRight = Instance.new("TextButton")
BtnSpinRight.Size = UDim2.new(0, 65, 0, 55)
BtnSpinRight.Position = UDim2.new(0, 72, 0, 0)
BtnSpinRight.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
BtnSpinRight.BorderColor3 = Color3.fromRGB(255, 215, 0)
BtnSpinRight.BorderSizePixel = 2
BtnSpinRight.TextColor3 = Color3.fromRGB(255, 215, 0)
BtnSpinRight.Text = "spin>"
BtnSpinRight.Font = Enum.Font.SourceSansBold
BtnSpinRight.TextSize = 14
BtnSpinRight.Parent = SpinContainer

-- // HÀM KHÓA / MỞ MÀN HÌNH (CAMERA) // --
local function lockCamera()
    Camera.CameraType = Enum.CameraType.Scriptable
end

local function unlockCamera()
    Camera.CameraType = Enum.CameraType.Custom
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        Camera.CameraSubject = LocalPlayer.Character.Humanoid
    end
end

-- // SỰ KIỆN ĐÈ / BUÔNG NÚT SPIN (TAB 4) // --
BtnSpinLeft.MouseButton1Down:Connect(function()
    isSpinningLeft = true
    lockCamera()
end)

BtnSpinLeft.MouseButton1Up:Connect(function()
    isSpinningLeft = false
    unlockCamera()
end)

BtnSpinLeft.MouseLeave:Connect(function()
    if isSpinningLeft then
        isSpinningLeft = false
        unlockCamera()
    end
end)

BtnSpinRight.MouseButton1Down:Connect(function()
    isSpinningRight = true
    lockCamera()
end)

BtnSpinRight.MouseButton1Up:Connect(function()
    isSpinningRight = false
    unlockCamera()
end)

BtnSpinRight.MouseLeave:Connect(function()
    if isSpinningRight then
        isSpinningRight = false
        unlockCamera()
    end
end)

-- // RAYFIELD CONTROLS TAB 4 // --
AntiErrorTab:CreateToggle({
    Name = "Spin Drift",
    CurrentValue = false,
    Flag = "SpinDriftToggle",
    Callback = function(Value)
        isSpinEnabled = Value
        SpinGui.Enabled = Value
        if not Value then
            isSpinningRight = false
            isSpinningLeft = false
            unlockCamera()
        end
    end,
})

AntiErrorTab:CreateSlider({
    Name = "spin (>)",
    Range = {50, 600},
    Increment = 10,
    Suffix = " Spd",
    CurrentValue = 180,
    Flag = "SpinRightSlider",
    Callback = function(Value) spinRightSpeed = Value end,
})

AntiErrorTab:CreateSlider({
    Name = "spin (<)",
    Range = {50, 600},
    Increment = 10,
    Suffix = " Spd",
    CurrentValue = 180,
    Flag = "SpinLeftSlider",
    Callback = function(Value) spinLeftSpeed = Value end,
})

-- // MAIN LOOP TỔNG (XỬ LÝ CẢ 2 CHỨC NĂNG CÙNG LÚC) // --
RunService.RenderStepped:Connect(function(deltaTime)
    local Character = LocalPlayer.Character
    local RootPart = Character and Character:FindFirstChild("HumanoidRootPart")
    if not RootPart then return end

    -- 1. XỬ LÝ TAB 4: SPIN DRIFT
    if isSpinEnabled then
        if isSpinningRight then
            RootPart.CFrame = RootPart.CFrame * CFrame.Angles(0, math.rad(-spinRightSpeed * deltaTime), 0)
        elseif isSpinningLeft then
            RootPart.CFrame = RootPart.CFrame * CFrame.Angles(0, math.rad(spinLeftSpeed * deltaTime), 0)
        end
    end

    -- 2. XỬ LÝ TAB 2: LÁI THƯỜNG & CHẠY
    if isEnabled then
        if isTurningLeft and not isSpinningLeft and not isSpinningRight then
            RootPart.CFrame = RootPart.CFrame * CFrame.Angles(0, math.rad(TurnSpeed * deltaTime), 0)
        elseif isTurningRight and not isSpinningLeft and not isSpinningRight then
            RootPart.CFrame = RootPart.CFrame * CFrame.Angles(0, math.rad(-TurnSpeed * deltaTime), 0)
        end

        if isPushing then
            local camLook = Camera.CFrame.LookVector
            local pushDirection = Vector3.new(camLook.X, 0, camLook.Z).Unit

            if not bodyVelocity or bodyVelocity.Parent ~= RootPart then
                stopPush()
                bodyVelocity = Instance.new("BodyVelocity")
                bodyVelocity.Name = "AIMCDT_Force"
                bodyVelocity.MaxForce = Vector3.new(1e6, 0, 1e6)
                bodyVelocity.P = 12000
                bodyVelocity.Parent = RootPart
            end

            bodyVelocity.Velocity = pushDirection * MovementSpeed
        else
            stopPush()
        end
    end
end)

