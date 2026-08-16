-- // RAYFIELD UI & MAIN SETUP // --
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "AIMDRIFT-CDT-Car-dealership-tycoon-meomeostaylike",
    LoadingTitle = "MeoMeo StayLike System",
    LoadingSubtitle = "🇻🇳LHkhánhviệt",
    ConfigurationSaving = { Enabled = false, FolderName = nil, FileName = "MeoMeoConfig" },
    Discord = { Enabled = false },
    KeySystem = false
})

-- // TAB 1: INFORMATION // --
local InfoTab = Window:CreateTab("Info", 4483362458)
InfoTab:CreateLabel("InfoTIKTOKofficial : meomeostaylike🇻🇳[-KHANH-]")
InfoTab:CreateLabel("chat: hello bro🇻🇳")
InfoTab:CreateLabel("nameADMIN: khanhviet🇻🇳")

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

-- Trạng thái
local isPushing = false -- Toggle Bật/Tắt chạy bằng nút ScreenGui
local isTurningLeft = false
local isTurningRight = false

local bodyVelocity = nil

local function stopPush()
    if bodyVelocity then
        bodyVelocity:Destroy()
        bodyVelocity = nil
    end
end

-- // TẠO SCREEN GUI // --
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MeoMeoControlGui"
ScreenGui.ResetOnSpawn = false
ScreenGui.Enabled = false -- Chỉ hiện khi BẬT AIM CDT trong Rayfield

pcall(function() ScreenGui.Parent = game:GetService("CoreGui") end)
if not ScreenGui.Parent then ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

-- 1. CỤM NÚT QUẸO (BÊN TRÁI MÀN HÌNH - ĐÈ NÚT ĐỂ XOAY)
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

-- 2. NÚT CHẠY ON/OFF (BÊN PHẢI MÀN HÌNH - BẤM CHUYỂN TRẠNG THÁI)
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

-- // RAYFIELD CONTROLS // --
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
    Callback = function(Value)
        MovementSpeed = Value
    end,
})

MainTab:CreateSlider({
    Name = "Tốc Độ Quẹo (Xoay)",
    Range = {30, 300},
    Increment = 5,
    Suffix = " Deg/s",
    CurrentValue = 120,
    Flag = "TurnSpeedSlider",
    Callback = function(Value)
        TurnSpeed = Value
    end,
})

-- // MAIN LOOP // --
RunService.RenderStepped:Connect(function(deltaTime)
    if not isEnabled then return end

    local Character = LocalPlayer.Character
    local RootPart = Character and Character:FindFirstChild("HumanoidRootPart")
    if not RootPart then return end

    -- 1. Xoay từ từ khi ĐÈ nút Quẹo
    if isTurningLeft then
        RootPart.CFrame = RootPart.CFrame * CFrame.Angles(0, math.rad(TurnSpeed * deltaTime), 0)
    elseif isTurningRight then
        RootPart.CFrame = RootPart.CFrame * CFrame.Angles(0, math.rad(-TurnSpeed * deltaTime), 0)
    end

    -- 2. Tự động đẩy tiến theo Cam khi Nút Chạy ở trạng thái ON
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
end)                                                                                                                                                                         InfoTab:CreateLabel("tuto:Turn on camera show  ")                               InfoTab:CreateLabel("car:( all  ) 🚗")                                                                  
-- // TAB 3: INFORMATION // --
local InfoTab = Window:CreateTab("game", 4483362458)
InfoTab:CreateLabel("InfoTIKTOK2:🅰️™️ free money")
InfoTab:CreateLabel("game: car dealershiptycoon")
InfoTab:CreateLabel("Notification : follow me!")                                   InfoTab:CreateLabel("skibidi: aura 99+ 🤫")
