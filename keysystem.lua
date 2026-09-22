--[[ 
    SAIRO HUB - SIGNATURE LUXURY KEY SYSTEM (SAIROAUTH EDITION)
    - Recreated with Exact Lucide Asset IDs & Spritesheet Crop Offsets
    - Authentic Compact Mode Minimize Engine (Never Vertical Squish)
    - Animated Placeholder Trailing Dots & Interactive Status Feedback
    - Multi-Layer Avatar Halo, Gradient Ring & Online Dot Backing
    - Rotating Dual-Light Beam Border Animation
    - Verified Service Asset: rbxassetid://97736695351156
    - Responsive Mobile/PC Layout & Centered ButtonContent Engine
]]

local SairoLibrary = {}

function SairoLibrary.Init()
    local isVerified = false

    local TweenService = game:GetService("TweenService")
    local HttpService = game:GetService("HttpService")
    local UserInputService = game:GetService("UserInputService")
    local RunService = game:GetService("RunService")
    local Players = game:GetService("Players")
    local MarketplaceService = game:GetService("MarketplaceService")
    local StatsService = game:GetService("Stats")
    local Camera = workspace.CurrentCamera

    local LocalPlayer = Players.LocalPlayer or Players.PlayerAdded:Wait()
    local HWID = "UNKNOWN"
    pcall(function()
        HWID = game:GetService("RbxAnalyticsService"):GetClientId()
    end)

    local API_URL = "https://sairo.online"
    local DEV_ID = _G.DevID or "admin"

    -- Target GUI Container
    local function getGuiParent()
        local success, core = pcall(function()
            if gethui then return gethui() end
            if syn and syn.protect_gui then
                local g = Instance.new("ScreenGui")
                syn.protect_gui(g)
                g.Parent = game:GetService("CoreGui")
                return g
            end
            return game:GetService("CoreGui")
        end)
        if success and core then return core end
        return LocalPlayer:WaitForChild("PlayerGui")
    end

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "SairoFlowAuthLoader"
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.ResetOnSpawn = false
    ScreenGui.IgnoreGuiInset = true
    ScreenGui.Parent = getGuiParent()

    -- Dark Ambient Backdrop
    local Backdrop = Instance.new("Frame")
    Backdrop.Name = "Backdrop"
    Backdrop.Size = UDim2.new(1, 0, 1, 0)
    Backdrop.Position = UDim2.new(0, 0, 0, 0)
    Backdrop.BackgroundColor3 = Color3.fromRGB(2, 6, 12)
    Backdrop.BackgroundTransparency = 1
    Backdrop.BorderSizePixel = 0
    Backdrop.Parent = ScreenGui

    -- Shell Container with UIScale for responsive sizing (Smooth Rounded CanvasGroup)
    local Shell = Instance.new("CanvasGroup")
    Shell.Name = "Shell"
    Shell.AnchorPoint = Vector2.new(0.5, 0.5)
    Shell.Position = UDim2.new(0.5, 0, 0.5, 0)
    Shell.Size = UDim2.new(0, 930, 0, 620)
    Shell.BackgroundColor3 = Color3.fromRGB(12, 23, 39)
    Shell.BackgroundTransparency = 1
    Shell.BorderSizePixel = 0
    Shell.ClipsDescendants = true
    Shell.Parent = Backdrop

    local ShellCorner = Instance.new("UICorner")
    ShellCorner.CornerRadius = UDim.new(0, 16)
    ShellCorner.Parent = Shell

    local ShellScale = Instance.new("UIScale")
    ShellScale.Scale = 1
    ShellScale.Parent = Shell

    -- Chrome Frame
    local Chrome = Instance.new("Frame")
    Chrome.Name = "Chrome"
    Chrome.Size = UDim2.new(1, 0, 1, 0)
    Chrome.BackgroundColor3 = Color3.fromRGB(12, 23, 39)
    Chrome.BorderSizePixel = 0
    Chrome.ClipsDescendants = true
    Chrome.Parent = Shell

    local ChromeCorner = Instance.new("UICorner")
    ChromeCorner.CornerRadius = UDim.new(0, 16)
    ChromeCorner.Parent = Chrome

    local ChromeStroke = Instance.new("UIStroke")
    ChromeStroke.Color = Color3.fromRGB(28, 48, 76)
    ChromeStroke.Thickness = 1.2
    ChromeStroke.Parent = Chrome

    local ChromeGrad = Instance.new("UIGradient")
    ChromeGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(14, 26, 44)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(8, 16, 28))
    })
    ChromeGrad.Rotation = 45
    ChromeGrad.Parent = Chrome

    -- =========================================================================
    -- HELPER: Lucide Image Builder (With Spritesheet Crop Offsets)
    -- =========================================================================
    local function createLucideIcon(assetId, size, color, parent, rectOffset, rectSize)
        local icon = Instance.new("ImageLabel")
        icon.Name = "LucideIcon"
        icon.Size = UDim2.new(0, size, 0, size)
        icon.BackgroundTransparency = 1
        icon.Image = assetId
        icon.ImageColor3 = color or Color3.fromRGB(108, 132, 163)
        icon.BorderSizePixel = 0
        icon.ZIndex = 5
        if rectOffset and rectSize then
            icon.ImageRectOffset = rectOffset
            icon.ImageRectSize = rectSize
        end
        icon.Parent = parent
        return icon
    end

    -- =========================================================================
    -- 1. LEFT COLUMN: USER INFO
    -- =========================================================================
    local UserInfo = Instance.new("Frame")
    UserInfo.Name = "UserInfo"
    UserInfo.Size = UDim2.new(0, 278, 0, 604)
    UserInfo.Position = UDim2.new(0, 8, 0, 8)
    UserInfo.BackgroundTransparency = 1
    UserInfo.ZIndex = 3
    UserInfo.Parent = Chrome

    -- Header Icon & Title (Using Lucide Spritesheet Crop Offset: 661, 869)
    local UserInfoIcon = createLucideIcon("rbxassetid://16898613869", 15, Color3.fromRGB(246, 192, 79), UserInfo, Vector2.new(661, 869), Vector2.new(48, 48))
    UserInfoIcon.Position = UDim2.new(0, 20, 0, 19)

    local UserInfoLabel = Instance.new("TextLabel")
    UserInfoLabel.Size = UDim2.new(1, -62, 0, 26)
    UserInfoLabel.Position = UDim2.new(0, 43, 0, 14)
    UserInfoLabel.BackgroundTransparency = 1
    UserInfoLabel.Text = "User Info"
    UserInfoLabel.TextColor3 = Color3.fromRGB(246, 192, 79)
    UserInfoLabel.Font = Enum.Font.GothamBold
    UserInfoLabel.TextSize = 11
    UserInfoLabel.TextXAlignment = Enum.TextXAlignment.Left
    UserInfoLabel.Parent = UserInfo

    local UserHeaderDivider = Instance.new("Frame")
    UserHeaderDivider.Size = UDim2.new(1, -36, 0, 1)
    UserHeaderDivider.Position = UDim2.new(0, 18, 0, 48)
    UserHeaderDivider.BackgroundColor3 = Color3.fromRGB(87, 119, 154)
    UserHeaderDivider.BackgroundTransparency = 0.5
    UserHeaderDivider.BorderSizePixel = 0
    UserHeaderDivider.Parent = UserInfo

    -- Authentic Avatar Halo System (From Dump)
    local AvatarHalo = Instance.new("Frame")
    AvatarHalo.Name = "AvatarHalo"
    AvatarHalo.Size = UDim2.new(0, 100, 0, 100)
    AvatarHalo.Position = UDim2.new(0.5, -50, 0, 58)
    AvatarHalo.BackgroundTransparency = 1
    AvatarHalo.Parent = UserInfo

    local AvatarHaloCorner = Instance.new("UICorner")
    AvatarHaloCorner.CornerRadius = UDim.new(1, 0)
    AvatarHaloCorner.Parent = AvatarHalo

    local AvatarGradientRing = Instance.new("Frame")
    AvatarGradientRing.Name = "AvatarGradientRing"
    AvatarGradientRing.Size = UDim2.new(0, 92, 0, 92)
    AvatarGradientRing.Position = UDim2.new(0, 4, 0, 4)
    AvatarGradientRing.BackgroundTransparency = 1
    AvatarGradientRing.Parent = AvatarHalo

    local RingCorner = Instance.new("UICorner")
    RingCorner.CornerRadius = UDim.new(1, 0)
    RingCorner.Parent = AvatarGradientRing

    local RingStroke = Instance.new("UIStroke")
    RingStroke.Name = "AvatarRingStroke"
    RingStroke.Thickness = 2.5
    RingStroke.Color = Color3.fromRGB(249, 115, 22)
    RingStroke.Parent = AvatarGradientRing

    local RingGrad = Instance.new("UIGradient")
    RingGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(250, 204, 21)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(249, 115, 22)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(250, 204, 21))
    })
    RingGrad.Rotation = 45
    RingGrad.Parent = RingStroke

    local AvatarSeparator = Instance.new("Frame")
    AvatarSeparator.Name = "AvatarSeparator"
    AvatarSeparator.Size = UDim2.new(0, 88, 0, 88)
    AvatarSeparator.Position = UDim2.new(0, 2, 0, 2)
    AvatarSeparator.BackgroundColor3 = Color3.fromRGB(12, 23, 39)
    AvatarSeparator.BorderSizePixel = 0
    AvatarSeparator.Parent = AvatarGradientRing

    local SepCorner = Instance.new("UICorner")
    SepCorner.CornerRadius = UDim.new(1, 0)
    SepCorner.Parent = AvatarSeparator

    local AvatarImg = Instance.new("ImageLabel")
    AvatarImg.Size = UDim2.new(0, 84, 0, 84)
    AvatarImg.Position = UDim2.new(0, 2, 0, 2)
    AvatarImg.BackgroundTransparency = 1
    AvatarImg.Image = "rbxthumb://type=AvatarHeadShot&id=" .. LocalPlayer.UserId .. "&w=420&h=420"
    AvatarImg.ScaleType = Enum.ScaleType.Crop
    AvatarImg.Parent = AvatarSeparator

    local AvatarImgCorner = Instance.new("UICorner")
    AvatarImgCorner.CornerRadius = UDim.new(1, 0)
    AvatarImgCorner.Parent = AvatarImg

    -- Online Status Dot with Backing Ring
    local OnlineDotBacking = Instance.new("Frame")
    OnlineDotBacking.Name = "OnlineDotBacking"
    OnlineDotBacking.Size = UDim2.new(0, 22, 0, 22)
    OnlineDotBacking.Position = UDim2.new(1, -26, 1, -26)
    OnlineDotBacking.BackgroundColor3 = Color3.fromRGB(4, 12, 23)
    OnlineDotBacking.BorderSizePixel = 0
    OnlineDotBacking.Parent = AvatarHalo

    local DotBackCorner = Instance.new("UICorner")
    DotBackCorner.CornerRadius = UDim.new(1, 0)
    DotBackCorner.Parent = OnlineDotBacking

    local OnlineDot = Instance.new("Frame")
    OnlineDot.Size = UDim2.new(0, 12, 0, 12)
    OnlineDot.Position = UDim2.new(0, 5, 0, 5)
    OnlineDot.BackgroundColor3 = Color3.fromRGB(64, 237, 165)
    OnlineDot.BorderSizePixel = 0
    OnlineDot.Parent = OnlineDotBacking

    local DotCorner = Instance.new("UICorner")
    DotCorner.CornerRadius = UDim.new(1, 0)
    DotCorner.Parent = OnlineDot

    -- Player Names
    local NameLabel = Instance.new("TextLabel")
    NameLabel.Size = UDim2.new(1, -36, 0, 22)
    NameLabel.Position = UDim2.new(0, 18, 0, 164)
    NameLabel.BackgroundTransparency = 1
    NameLabel.Text = string.upper(LocalPlayer.DisplayName or LocalPlayer.Name)
    NameLabel.TextColor3 = Color3.fromRGB(239, 245, 255)
    NameLabel.Font = Enum.Font.GothamBold
    NameLabel.TextSize = 14
    NameLabel.TextTruncate = Enum.TextTruncate.AtEnd
    NameLabel.Parent = UserInfo

    local UserTagLabel = Instance.new("TextLabel")
    UserTagLabel.Size = UDim2.new(1, -36, 0, 18)
    UserTagLabel.Position = UDim2.new(0, 18, 0, 185)
    UserTagLabel.BackgroundTransparency = 1
    UserTagLabel.Text = "@" .. LocalPlayer.Name
    UserTagLabel.TextColor3 = Color3.fromRGB(108, 132, 163)
    UserTagLabel.Font = Enum.Font.Gotham
    UserTagLabel.TextSize = 10
    UserTagLabel.TextTruncate = Enum.TextTruncate.AtEnd
    UserTagLabel.Parent = UserInfo

    -- Profile Details Frame
    local ProfileDetails = Instance.new("Frame")
    ProfileDetails.Name = "ProfileDetails"
    ProfileDetails.Size = UDim2.new(1, -36, 0, 166)
    ProfileDetails.Position = UDim2.new(0, 18, 0, 214)
    ProfileDetails.BackgroundTransparency = 1
    ProfileDetails.Parent = UserInfo

    local function createDetailRow(iconAsset, labelText, valueText, yPos, valueColor, rectOffset, rectSize)
        local ic = createLucideIcon(iconAsset, 16, valueColor or Color3.fromRGB(162, 181, 209), ProfileDetails, rectOffset, rectSize)
        ic.Position = UDim2.new(0, 14, 0, yPos + 8)

        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(0, 78, 0, 15)
        lbl.Position = UDim2.new(0, 42, 0, yPos)
        lbl.BackgroundTransparency = 1
        lbl.Text = labelText
        lbl.TextColor3 = Color3.fromRGB(108, 132, 163)
        lbl.Font = Enum.Font.GothamMedium
        lbl.TextSize = 9
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.Parent = ProfileDetails

        local val = Instance.new("TextLabel")
        val.Size = UDim2.new(1, -56, 0, 18)
        val.Position = UDim2.new(0, 42, 0, yPos + 14)
        val.BackgroundTransparency = 1
        val.Text = valueText
        val.TextColor3 = valueColor or Color3.fromRGB(162, 181, 209)
        val.Font = Enum.Font.GothamMedium
        val.TextSize = 10
        val.TextXAlignment = Enum.TextXAlignment.Left
        val.TextTruncate = Enum.TextTruncate.AtEnd
        val.Parent = ProfileDetails

        if yPos < 120 then
            local div = Instance.new("Frame")
            div.Size = UDim2.new(1, -56, 0, 1)
            div.Position = UDim2.new(0, 42, 0, yPos + 36)
            div.BackgroundColor3 = Color3.fromRGB(87, 119, 154)
            div.BackgroundTransparency = 0.6
            div.BorderSizePixel = 0
            div.Parent = ProfileDetails
        end

        return val
    end

    local execName = "Standard"
    pcall(function()
        if identifyexecutor then execName = identifyexecutor() end
    end)
    local isMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
    local deviceStr = isMobile and "Mobile" or "PC"

    local gameTitle = "Roblox Game"
    pcall(function()
        local info = MarketplaceService:GetProductInfo(game.PlaceId)
        if info and info.Name then gameTitle = info.Name end
    end)

    createDetailRow("rbxassetid://7734002839", "Executor", execName, 4)
    createDetailRow("rbxassetid://7734002839", "Device", deviceStr, 45)
    createDetailRow("rbxassetid://16898613777", "HWID", "Available", 86, nil, Vector2.new(771, 257), Vector2.new(48, 48))
    createDetailRow("rbxassetid://7733799901", "Game", gameTitle, 127, Color3.fromRGB(47, 224, 151))

    -- Metrics (Session + Ping)
    local Metrics = Instance.new("Frame")
    Metrics.Name = "Metrics"
    Metrics.Size = UDim2.new(1, -36, 0, 66)
    Metrics.Position = UDim2.new(0, 18, 0, 392)
    Metrics.BackgroundTransparency = 1
    Metrics.Parent = UserInfo

    local MetricDivider = Instance.new("Frame")
    MetricDivider.Size = UDim2.new(0, 1, 1, -24)
    MetricDivider.Position = UDim2.new(0.5, 0, 0, 12)
    MetricDivider.BackgroundColor3 = Color3.fromRGB(87, 119, 154)
    MetricDivider.BackgroundTransparency = 0.6
    MetricDivider.BorderSizePixel = 0
    MetricDivider.Parent = Metrics

    -- Left: Session
    local SessionBox = Instance.new("Frame")
    SessionBox.Size = UDim2.new(0.5, 0, 1, 0)
    SessionBox.Position = UDim2.new(0, 0, 0, 0)
    SessionBox.BackgroundTransparency = 1
    SessionBox.Parent = Metrics

    local SessionIcon = createLucideIcon("rbxassetid://7733734848", 16, Color3.fromRGB(246, 192, 79), SessionBox)
    SessionIcon.Position = UDim2.new(0, 14, 0, 16)

    local SessionTitle = Instance.new("TextLabel")
    SessionTitle.Size = UDim2.new(1, -48, 0, 18)
    SessionTitle.Position = UDim2.new(0, 38, 0, 9)
    SessionTitle.BackgroundTransparency = 1
    SessionTitle.Text = "Session"
    SessionTitle.TextColor3 = Color3.fromRGB(108, 132, 163)
    SessionTitle.Font = Enum.Font.GothamMedium
    SessionTitle.TextSize = 9
    SessionTitle.TextXAlignment = Enum.TextXAlignment.Left
    SessionTitle.Parent = SessionBox

    local SessionVal = Instance.new("TextLabel")
    SessionVal.Size = UDim2.new(1, -48, 0, 22)
    SessionVal.Position = UDim2.new(0, 38, 0, 27)
    SessionVal.BackgroundTransparency = 1
    SessionVal.Text = "00:00"
    SessionVal.TextColor3 = Color3.fromRGB(246, 192, 79)
    SessionVal.Font = Enum.Font.GothamBold
    SessionVal.TextSize = 12
    SessionVal.TextXAlignment = Enum.TextXAlignment.Left
    SessionVal.Parent = SessionBox

    -- Right: Ping
    local PingBox = Instance.new("Frame")
    PingBox.Size = UDim2.new(0.5, 0, 1, 0)
    PingBox.Position = UDim2.new(0.5, 0, 0, 0)
    PingBox.BackgroundTransparency = 1
    PingBox.Parent = Metrics

    local PingIcon = createLucideIcon("rbxassetid://7743878148", 16, Color3.fromRGB(47, 224, 151), PingBox)
    PingIcon.Position = UDim2.new(0, 14, 0, 16)

    local PingTitle = Instance.new("TextLabel")
    PingTitle.Size = UDim2.new(1, -48, 0, 18)
    PingTitle.Position = UDim2.new(0, 38, 0, 9)
    PingTitle.BackgroundTransparency = 1
    PingTitle.Text = "Ping"
    PingTitle.TextColor3 = Color3.fromRGB(108, 132, 163)
    PingTitle.Font = Enum.Font.GothamMedium
    PingTitle.TextSize = 9
    PingTitle.TextXAlignment = Enum.TextXAlignment.Left
    PingTitle.Parent = PingBox

    local PingVal = Instance.new("TextLabel")
    PingVal.Size = UDim2.new(1, -48, 0, 22)
    PingVal.Position = UDim2.new(0, 38, 0, 27)
    PingVal.BackgroundTransparency = 1
    PingVal.Text = "45 ms"
    PingVal.TextColor3 = Color3.fromRGB(47, 224, 151)
    PingVal.Font = Enum.Font.GothamBold
    PingVal.TextSize = 12
    PingVal.TextXAlignment = Enum.TextXAlignment.Left
    PingVal.Parent = PingBox

    -- Live Telemetry Updater
    local elapsedSec = 0
    task.spawn(function()
        while ScreenGui.Parent do
            task.wait(1)
            elapsedSec = elapsedSec + 1
            local m = math.floor(elapsedSec / 60)
            local s = elapsedSec % 60
            SessionVal.Text = string.format("%02d:%02d", m, s)

            if elapsedSec % 2 == 0 then
                pcall(function()
                    local ping = StatsService.Network.ServerStatsItem["Data Ping"]:GetValue()
                    PingVal.Text = string.format("%.1f ms", ping)
                end)
            end
        end
    end)

    -- Connected to Sairo Hub Badge Card
    local ConnectedCard = Instance.new("Frame")
    ConnectedCard.Size = UDim2.new(1, -36, 0, 68)
    ConnectedCard.Position = UDim2.new(0, 18, 0, 502)
    ConnectedCard.BackgroundTransparency = 1
    ConnectedCard.Parent = UserInfo

    local ConnIcon = createLucideIcon("rbxassetid://7733919427", 20, Color3.fromRGB(47, 224, 151), ConnectedCard)
    ConnIcon.Position = UDim2.new(0, 14, 0, 24)

    local ConnTitle = Instance.new("TextLabel")
    ConnTitle.Size = UDim2.new(1, -56, 0, 24)
    ConnTitle.Position = UDim2.new(0, 44, 0, 11)
    ConnTitle.BackgroundTransparency = 1
    ConnTitle.Text = "Connected to Sairo Hub"
    ConnTitle.TextColor3 = Color3.fromRGB(47, 224, 151)
    ConnTitle.Font = Enum.Font.GothamBold
    ConnTitle.TextSize = 12
    ConnTitle.TextXAlignment = Enum.TextXAlignment.Left
    ConnTitle.Parent = ConnectedCard

    local ConnSub = Instance.new("TextLabel")
    ConnSub.Size = UDim2.new(1, -56, 0, 18)
    ConnSub.Position = UDim2.new(0, 44, 0, 35)
    ConnSub.BackgroundTransparency = 1
    ConnSub.Text = "Sairo Hub is ready"
    ConnSub.TextColor3 = Color3.fromRGB(162, 181, 209)
    ConnSub.Font = Enum.Font.Gotham
    ConnSub.TextSize = 9
    ConnSub.TextXAlignment = Enum.TextXAlignment.Left
    ConnSub.Parent = ConnectedCard

    -- Column Divider (Between Left and Right)
    local ColumnDivider = Instance.new("Frame")
    ColumnDivider.Name = "ColumnDivider"
    ColumnDivider.Size = UDim2.new(0, 1, 1, -40)
    ColumnDivider.Position = UDim2.new(0, 286, 0, 20)
    ColumnDivider.BackgroundColor3 = Color3.fromRGB(87, 119, 154)
    ColumnDivider.BackgroundTransparency = 0.5
    ColumnDivider.BorderSizePixel = 0
    ColumnDivider.ZIndex = 3
    ColumnDivider.Parent = Chrome

    -- =========================================================================
    -- 2. RIGHT COLUMN: MAIN PANEL
    -- =========================================================================
    local Main = Instance.new("Frame")
    Main.Name = "Main"
    Main.Size = UDim2.new(0, 628, 0, 604)
    Main.Position = UDim2.new(0, 294, 0, 8)
    Main.BackgroundTransparency = 1
    Main.ZIndex = 3
    Main.Parent = Chrome

    -- Header with Draggable Support
    local Header = Instance.new("Frame")
    Header.Name = "Header"
    Header.Size = UDim2.new(1, 0, 0, 62)
    Header.BackgroundTransparency = 1
    Header.ZIndex = 4
    Header.Parent = Main

    local MainTitle = Instance.new("TextLabel")
    MainTitle.Size = UDim2.new(0, 180, 0, 30)
    MainTitle.Position = UDim2.new(0, 22, 0, 8)
    MainTitle.BackgroundTransparency = 1
    MainTitle.Text = "Sairo Hub"
    MainTitle.TextColor3 = Color3.fromRGB(239, 245, 255)
    MainTitle.Font = Enum.Font.GothamBold
    MainTitle.TextSize = 22
    MainTitle.TextXAlignment = Enum.TextXAlignment.Left
    MainTitle.Parent = Header

    local MainSub = Instance.new("TextLabel")
    MainSub.Size = UDim2.new(0, 220, 0, 16)
    MainSub.Position = UDim2.new(0, 23, 0, 35)
    MainSub.BackgroundTransparency = 1
    MainSub.Text = "Secure SairoAuth loader"
    MainSub.TextColor3 = Color3.fromRGB(108, 132, 163)
    MainSub.Font = Enum.Font.Gotham
    MainSub.TextSize = 9
    MainSub.TextXAlignment = Enum.TextXAlignment.Left
    MainSub.Parent = Header

    -- Minimize & Close Buttons
    local MinBtn = Instance.new("ImageButton")
    MinBtn.Name = "Minimize"
    MinBtn.Size = UDim2.new(0, 32, 0, 32)
    MinBtn.Position = UDim2.new(1, -82, 0, 14)
    MinBtn.BackgroundColor3 = Color3.fromRGB(23, 36, 59)
    MinBtn.BorderSizePixel = 0
    MinBtn.AutoButtonColor = false
    MinBtn.Parent = Header

    local MinCorner = Instance.new("UICorner")
    MinCorner.CornerRadius = UDim.new(0, 8)
    MinCorner.Parent = MinBtn

    local MinIcon = createLucideIcon("rbxassetid://7734000129", 16, Color3.fromRGB(162, 181, 209), MinBtn)
    MinIcon.Position = UDim2.new(0, 8, 0, 8)

    local CloseBtn = Instance.new("ImageButton")
    CloseBtn.Name = "Close"
    CloseBtn.Size = UDim2.new(0, 32, 0, 32)
    CloseBtn.Position = UDim2.new(1, -44, 0, 14)
    CloseBtn.BackgroundColor3 = Color3.fromRGB(23, 36, 59)
    CloseBtn.BorderSizePixel = 0
    CloseBtn.AutoButtonColor = false
    CloseBtn.Parent = Header

    local CloseCorner = Instance.new("UICorner")
    CloseCorner.CornerRadius = UDim.new(0, 8)
    CloseCorner.Parent = CloseBtn

    local CloseIcon = createLucideIcon("rbxassetid://7743878857", 16, Color3.fromRGB(162, 181, 209), CloseBtn)
    CloseIcon.Position = UDim2.new(0, 8, 0, 8)

    local HeaderDiv = Instance.new("Frame")
    HeaderDiv.Size = UDim2.new(1, -40, 0, 1)
    HeaderDiv.Position = UDim2.new(0, 20, 0, 61)
    HeaderDiv.BackgroundColor3 = Color3.fromRGB(87, 119, 154)
    HeaderDiv.BackgroundTransparency = 0.6
    HeaderDiv.BorderSizePixel = 0
    HeaderDiv.Parent = Header

    -- Active Service Card (With User's Asset: rbxassetid://97736695351156)
    local ServiceCard = Instance.new("Frame")
    ServiceCard.Name = "ServiceCard"
    ServiceCard.Size = UDim2.new(1, -40, 0, 88)
    ServiceCard.Position = UDim2.new(0, 20, 0, 74)
    ServiceCard.BackgroundTransparency = 1
    ServiceCard.Parent = Main

    local ServiceLogoSlot = Instance.new("Frame")
    ServiceLogoSlot.Name = "ServiceLogoSlot"
    ServiceLogoSlot.Size = UDim2.new(0, 116, 0, 82)
    ServiceLogoSlot.Position = UDim2.new(0, 0, 0, 2)
    ServiceLogoSlot.BackgroundTransparency = 1
    ServiceLogoSlot.Parent = ServiceCard

    local ServiceLogoImg = Instance.new("ImageLabel")
    ServiceLogoImg.Size = UDim2.new(0, 132, 0, 88)
    ServiceLogoImg.Position = UDim2.new(0.5, 0, 0.5, 0)
    ServiceLogoImg.AnchorPoint = Vector2.new(0.5, 0.5)
    ServiceLogoImg.BackgroundTransparency = 1
    ServiceLogoImg.Image = "rbxassetid://97736695351156"
    ServiceLogoImg.ScaleType = Enum.ScaleType.Fit
    ServiceLogoImg.Parent = ServiceLogoSlot

    local SvcTag = Instance.new("TextLabel")
    SvcTag.Size = UDim2.new(1, -318, 0, 17)
    SvcTag.Position = UDim2.new(0, 128, 0, 11)
    SvcTag.BackgroundTransparency = 1
    SvcTag.Text = "ACTIVE SERVICE"
    SvcTag.TextColor3 = Color3.fromRGB(47, 224, 151)
    SvcTag.Font = Enum.Font.GothamBold
    SvcTag.TextSize = 9
    SvcTag.TextXAlignment = Enum.TextXAlignment.Left
    SvcTag.Parent = ServiceCard

    local SvcTitle = Instance.new("TextLabel")
    SvcTitle.Size = UDim2.new(1, -318, 0, 24)
    SvcTitle.Position = UDim2.new(0, 128, 0, 29)
    SvcTitle.BackgroundTransparency = 1
    SvcTitle.Text = "Sairo Scripts"
    SvcTitle.TextColor3 = Color3.fromRGB(239, 245, 255)
    SvcTitle.Font = Enum.Font.GothamBold
    SvcTitle.TextSize = 15
    SvcTitle.TextXAlignment = Enum.TextXAlignment.Left
    SvcTitle.Parent = ServiceCard

    local SvcSub = Instance.new("TextLabel")
    SvcSub.Size = UDim2.new(1, -318, 0, 18)
    SvcSub.Position = UDim2.new(0, 128, 0, 54)
    SvcSub.BackgroundTransparency = 1
    SvcSub.Text = "Verified client delivery"
    SvcSub.TextColor3 = Color3.fromRGB(108, 132, 163)
    SvcSub.Font = Enum.Font.Gotham
    SvcSub.TextSize = 10
    SvcSub.TextXAlignment = Enum.TextXAlignment.Left
    SvcSub.Parent = ServiceCard

    -- Verified Pill Badge
    local VerifiedBadge = Instance.new("Frame")
    VerifiedBadge.Size = UDim2.new(0, 154, 0, 34)
    VerifiedBadge.Position = UDim2.new(1, -172, 0.5, -17)
    VerifiedBadge.BackgroundColor3 = Color3.fromRGB(10, 53, 44)
    VerifiedBadge.BorderSizePixel = 0
    VerifiedBadge.Parent = ServiceCard

    local VerifiedCorner = Instance.new("UICorner")
    VerifiedCorner.CornerRadius = UDim.new(0, 8)
    VerifiedCorner.Parent = VerifiedBadge

    local VerifiedIcon = createLucideIcon("rbxassetid://7734056411", 16, Color3.fromRGB(47, 224, 151), VerifiedBadge)
    VerifiedIcon.Position = UDim2.new(0, 12, 0, 9)

    local VerifiedTxt = Instance.new("TextLabel")
    VerifiedTxt.Size = UDim2.new(1, -44, 1, 0)
    VerifiedTxt.Position = UDim2.new(0, 36, 0, 0)
    VerifiedTxt.BackgroundTransparency = 1
    VerifiedTxt.Text = "SAIROAUTH VERIFIED"
    VerifiedTxt.TextColor3 = Color3.fromRGB(47, 224, 151)
    VerifiedTxt.Font = Enum.Font.GothamBold
    VerifiedTxt.TextSize = 9
    VerifiedTxt.TextXAlignment = Enum.TextXAlignment.Left
    VerifiedTxt.Parent = VerifiedBadge

    -- Secure Access Labeling
    local SecAccessTag = Instance.new("TextLabel")
    SecAccessTag.Size = UDim2.new(1, -44, 0, 16)
    SecAccessTag.Position = UDim2.new(0, 22, 0, 174)
    SecAccessTag.BackgroundTransparency = 1
    SecAccessTag.Text = "SECURE ACCESS"
    SecAccessTag.TextColor3 = Color3.fromRGB(249, 115, 22)
    SecAccessTag.Font = Enum.Font.GothamBold
    SecAccessTag.TextSize = 9
    SecAccessTag.TextXAlignment = Enum.TextXAlignment.Left
    SecAccessTag.Parent = Main

    local SecAccessDesc = Instance.new("TextLabel")
    SecAccessDesc.Size = UDim2.new(1, -44, 0, 19)
    SecAccessDesc.Position = UDim2.new(0, 22, 0, 190)
    SecAccessDesc.BackgroundTransparency = 1
    SecAccessDesc.Text = "Enter your SairoAuth key to launch the supported script"
    SecAccessDesc.TextColor3 = Color3.fromRGB(162, 181, 209)
    SecAccessDesc.Font = Enum.Font.Gotham
    SecAccessDesc.TextSize = 11
    SecAccessDesc.TextXAlignment = Enum.TextXAlignment.Left
    SecAccessDesc.Parent = Main

    -- Key Input Box with Rotating Dual-Light Beam Border (Sun Yellow & Flame Orange, No Blue)
    local KeyInputWrap = Instance.new("Frame")
    KeyInputWrap.Name = "KeyInputWrap"
    KeyInputWrap.Size = UDim2.new(1, -40, 0, 50)
    KeyInputWrap.Position = UDim2.new(0, 20, 0, 214)
    KeyInputWrap.BackgroundColor3 = Color3.fromRGB(7, 15, 28)
    KeyInputWrap.BorderSizePixel = 0
    KeyInputWrap.Parent = Main

    local KeyInputCorner = Instance.new("UICorner")
    KeyInputCorner.CornerRadius = UDim.new(0, 10)
    KeyInputCorner.Parent = KeyInputWrap

    local KeyInputStroke = Instance.new("UIStroke")
    KeyInputStroke.Thickness = 1.5
    KeyInputStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    KeyInputStroke.Color = Color3.fromRGB(255, 255, 255)
    KeyInputStroke.Parent = KeyInputWrap

    local DualLightGrad = Instance.new("UIGradient")
    DualLightGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 42, 60)),
        ColorSequenceKeypoint.new(0.25, Color3.fromRGB(250, 204, 21)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(30, 42, 60)),
        ColorSequenceKeypoint.new(0.75, Color3.fromRGB(249, 115, 22)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(30, 42, 60))
    })
    DualLightGrad.Rotation = 0
    DualLightGrad.Parent = KeyInputStroke

    local rotConn
    rotConn = RunService.RenderStepped:Connect(function(dt)
        if not ScreenGui.Parent then
            rotConn:Disconnect()
            return
        end
        DualLightGrad.Rotation = (DualLightGrad.Rotation + (120 * dt)) % 360
    end)

    local KeyIcon = createLucideIcon("rbxassetid://7733965118", 18, Color3.fromRGB(108, 132, 163), KeyInputWrap)
    KeyIcon.Position = UDim2.new(0, 16, 0.5, -9)

    local KeyInput = Instance.new("TextBox")
    KeyInput.Name = "KeyInput"
    KeyInput.Size = UDim2.new(1, -54, 1, 0)
    KeyInput.Position = UDim2.new(0, 46, 0, 0)
    KeyInput.BackgroundTransparency = 1
    KeyInput.PlaceholderText = "Waiting for key..."
    KeyInput.PlaceholderColor3 = Color3.fromRGB(108, 132, 163)
    KeyInput.TextColor3 = Color3.fromRGB(239, 245, 255)
    KeyInput.Font = Enum.Font.GothamMedium
    KeyInput.TextSize = 13
    KeyInput.TextXAlignment = Enum.TextXAlignment.Left
    KeyInput.ClearTextOnFocus = false
    KeyInput.Parent = KeyInputWrap

    -- Animated Key Placeholder Dots (Waiting for key, Waiting for key., Waiting for key.., Waiting for key...)
    task.spawn(function()
        local dotStates = {"Waiting for key", "Waiting for key.", "Waiting for key..", "Waiting for key..."}
        local dIdx = 1
        while ScreenGui.Parent do
            task.wait(0.7)
            if KeyInput and KeyInput.Text == "" then
                dIdx = (dIdx % #dotStates) + 1
                KeyInput.PlaceholderText = dotStates[dIdx]
            end
        end
    end)

    -- Pop Animation Engine (Tactile Press-Down & Spring Pop for All Buttons)
    local function applyButtonPop(btn)
        local scale = btn:FindFirstChildOfClass("UIScale")
        if not scale then
            scale = Instance.new("UIScale")
            scale.Scale = 1
            scale.Parent = btn
        end

        local isDown = false

        local function doPress()
            isDown = true
            TweenService:Create(scale, TweenInfo.new(0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Scale = 0.92
            }):Play()
        end

        local function doRelease()
            if isDown then
                isDown = false
                local tPop = TweenService:Create(scale, TweenInfo.new(0.12, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                    Scale = 1.05
                })
                tPop:Play()
                tPop.Completed:Connect(function()
                    if not isDown then
                        TweenService:Create(scale, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                            Scale = 1.0
                        }):Play()
                    end
                end)
            end
        end

        btn.MouseButton1Down:Connect(doPress)
        btn.MouseButton1Up:Connect(doRelease)
        btn.MouseButton1Click:Connect(function()
            if isDown then
                doRelease()
            end
        end)
        btn.MouseLeave:Connect(function()
            if isDown then
                isDown = false
                TweenService:Create(scale, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    Scale = 1.0
                }):Play()
            end
        end)
    end

    -- Hook up Pop Animation on Header Buttons
    applyButtonPop(MinBtn)
    applyButtonPop(CloseBtn)

    -- Helper: Button Builder using Centered ButtonContent Engine
    local function createStandardButton(name, widthScale, widthOffset, bgColor, iconAsset, labelText, parent, textSize, rectOffset, rectSize)
        local btn = Instance.new("TextButton")
        btn.Name = name
        btn.Size = UDim2.new(widthScale, widthOffset, 1, 0)
        btn.BackgroundColor3 = bgColor
        btn.Text = ""
        btn.AutoButtonColor = false
        btn.Parent = parent

        local c = Instance.new("UICorner")
        c.CornerRadius = UDim.new(0, 10)
        c.Parent = btn

        local content = Instance.new("Frame")
        content.Name = "ButtonContent"
        content.Size = UDim2.new(0, 0, 0, 18)
        content.Position = UDim2.new(0.5, 0, 0.5, 0)
        content.AnchorPoint = Vector2.new(0.5, 0.5)
        content.BackgroundTransparency = 1
        content.Parent = btn

        local layout = Instance.new("UIListLayout")
        layout.FillDirection = Enum.FillDirection.Horizontal
        layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        layout.VerticalAlignment = Enum.VerticalAlignment.Center
        layout.SortOrder = Enum.SortOrder.LayoutOrder
        layout.Padding = UDim.new(0, 8)
        layout.Parent = content

        local ic = createLucideIcon(iconAsset, 16, Color3.fromRGB(239, 245, 255), content, rectOffset, rectSize)
        ic.LayoutOrder = 1

        local lbl = Instance.new("TextLabel")
        lbl.Name = "ButtonLabel"
        lbl.Size = UDim2.new(0, 0, 0, 18)
        lbl.AutomaticSize = Enum.AutomaticSize.X
        lbl.BackgroundTransparency = 1
        lbl.Text = labelText
        lbl.TextColor3 = Color3.fromRGB(239, 245, 255)
        lbl.Font = Enum.Font.GothamBold
        lbl.TextSize = textSize or 13
        lbl.LayoutOrder = 2
        lbl.Parent = content

        btn.MouseEnter:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.18), {BackgroundTransparency = 0.15}):Play()
        end)
        btn.MouseLeave:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.18), {BackgroundTransparency = 0}):Play()
        end)

        applyButtonPop(btn)

        return btn, lbl, ic
    end

    -- Primary Action Row (Get Key & Redeem)
    local PrimaryRow = Instance.new("Frame")
    PrimaryRow.Size = UDim2.new(1, -40, 0, 46)
    PrimaryRow.Position = UDim2.new(0, 20, 0, 276)
    PrimaryRow.BackgroundTransparency = 1
    PrimaryRow.Parent = Main

    local PrimaryLayout = Instance.new("UIListLayout")
    PrimaryLayout.FillDirection = Enum.FillDirection.Horizontal
    PrimaryLayout.SortOrder = Enum.SortOrder.LayoutOrder
    PrimaryLayout.Padding = UDim.new(0, 10)
    PrimaryLayout.Parent = PrimaryRow

    local GetKeyBtn = createStandardButton("GetKey", 0.5, -5, Color3.fromRGB(249, 115, 22), "rbxassetid://7733965118", "Get Key", PrimaryRow, 13)
    local RedeemBtn, RedeemLbl = createStandardButton("Redeem", 0.5, -5, Color3.fromRGB(27, 45, 72), "rbxassetid://7734056411", "Redeem", PrimaryRow, 13)

    -- Utility Row (Discord, CopyHWID, Live Support)
    local UtilRow = Instance.new("Frame")
    UtilRow.Size = UDim2.new(1, -40, 0, 38)
    UtilRow.Position = UDim2.new(0, 20, 0, 334)
    UtilRow.BackgroundTransparency = 1
    UtilRow.Parent = Main

    local UtilLayout = Instance.new("UIListLayout")
    UtilLayout.FillDirection = Enum.FillDirection.Horizontal
    UtilLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UtilLayout.Padding = UDim.new(0, 10)
    UtilLayout.Parent = UtilRow

    local DiscordBtn = createStandardButton("Discord", 0.333, -7, Color3.fromRGB(23, 36, 59), "rbxassetid://7733993311", "Discord", UtilRow, 11)
    local CopyHwidBtn = createStandardButton("CopyHWID", 0.333, -7, Color3.fromRGB(23, 36, 59), "rbxassetid://7733764083", "Copy HWID", UtilRow, 11)
    local LiveSupportBtn = createStandardButton("LiveSupport", 0.333, -7, Color3.fromRGB(23, 36, 59), "rbxassetid://7733964719", "Live Support", UtilRow, 10)

    -- Status Card Frame
    local StatusCard = Instance.new("Frame")
    StatusCard.Name = "StatusCard"
    StatusCard.Size = UDim2.new(1, -40, 0, 46)
    StatusCard.Position = UDim2.new(0, 20, 0, 384)
    StatusCard.BackgroundTransparency = 1
    StatusCard.ClipsDescendants = true
    StatusCard.Parent = Main

    local StatusAccentLine = Instance.new("Frame")
    StatusAccentLine.Size = UDim2.new(0, 3, 1, -16)
    StatusAccentLine.Position = UDim2.new(0, 0, 0, 8)
    StatusAccentLine.BackgroundColor3 = Color3.fromRGB(246, 192, 79)
    StatusAccentLine.BorderSizePixel = 0
    StatusAccentLine.Parent = StatusCard

    local StatusLineCorner = Instance.new("UICorner")
    StatusLineCorner.CornerRadius = UDim.new(0, 2)
    StatusLineCorner.Parent = StatusAccentLine

    local StatusIcon = createLucideIcon("rbxassetid://7733964719", 16, Color3.fromRGB(246, 192, 79), StatusCard)
    StatusIcon.Position = UDim2.new(0, 16, 0, 15)

    local StatusSummary = Instance.new("TextLabel")
    StatusSummary.Name = "StatusSummary"
    StatusSummary.Size = UDim2.new(1, -58, 0, 20)
    StatusSummary.Position = UDim2.new(0, 42, 0, 13)
    StatusSummary.BackgroundTransparency = 1
    StatusSummary.Text = "Ready for " .. gameTitle
    StatusSummary.TextColor3 = Color3.fromRGB(246, 192, 79)
    StatusSummary.Font = Enum.Font.GothamBold
    StatusSummary.TextSize = 11
    StatusSummary.TextXAlignment = Enum.TextXAlignment.Left
    StatusSummary.TextTruncate = Enum.TextTruncate.AtEnd
    StatusSummary.Parent = StatusCard

    local StatusDetail = Instance.new("TextLabel")
    StatusDetail.Name = "StatusDetail"
    StatusDetail.Size = UDim2.new(1, -160, 0, 18)
    StatusDetail.Position = UDim2.new(0, 42, 0, 26)
    StatusDetail.BackgroundTransparency = 1
    StatusDetail.Text = ""
    StatusDetail.TextColor3 = Color3.fromRGB(162, 181, 209)
    StatusDetail.Font = Enum.Font.Gotham
    StatusDetail.TextSize = 9
    StatusDetail.TextXAlignment = Enum.TextXAlignment.Left
    StatusDetail.Visible = false
    StatusDetail.Parent = StatusCard

    local CopyErrorBtn = createStandardButton("CopyError", 0, 94, Color3.fromRGB(23, 36, 59), "rbxassetid://7733764083", "Copy Error", StatusCard, 9)
    CopyErrorBtn.Size = UDim2.new(0, 94, 0, 26)
    CopyErrorBtn.Position = UDim2.new(1, -108, 0, 10)
    CopyErrorBtn.Visible = false

    local lastErrorText = ""
    CopyErrorBtn.MouseButton1Click:Connect(function()
        if setclipboard and lastErrorText ~= "" then
            setclipboard(lastErrorText)
            StatusSummary.Text = "Error details copied!"
        end
    end)

    -- Status Setter helper with Icon flipping
    local function setStatus(text, color, iconAsset, detailText)
        StatusSummary.Text = text
        StatusSummary.TextColor3 = color or Color3.fromRGB(246, 192, 79)
        StatusAccentLine.BackgroundColor3 = color or Color3.fromRGB(246, 192, 79)
        StatusIcon.Image = iconAsset or "rbxassetid://7733964719"
        StatusIcon.ImageColor3 = color or Color3.fromRGB(246, 192, 79)

        if detailText and detailText ~= "" then
            lastErrorText = detailText
            StatusDetail.Text = detailText
            StatusDetail.Visible = true
            CopyErrorBtn.Visible = true
            StatusSummary.Position = UDim2.new(0, 42, 0, 8)
        else
            StatusDetail.Visible = false
            CopyErrorBtn.Visible = false
            StatusSummary.Position = UDim2.new(0, 42, 0, 13)
        end
    end

    -- Premium Access Card
    local PremiumAccess = Instance.new("Frame")
    PremiumAccess.Name = "PremiumAccess"
    PremiumAccess.Size = UDim2.new(1, -40, 0, 146)
    PremiumAccess.Position = UDim2.new(0, 20, 0, 442)
    PremiumAccess.BackgroundTransparency = 1
    PremiumAccess.ClipsDescendants = true
    PremiumAccess.Parent = Main

    local PremDivider = Instance.new("Frame")
    PremDivider.Name = "PremiumDivider"
    PremDivider.Size = UDim2.new(1, 0, 0, 1)
    PremDivider.Position = UDim2.new(0, 0, 0, 0)
    PremDivider.BackgroundColor3 = Color3.fromRGB(87, 119, 154)
    PremDivider.BackgroundTransparency = 0.6
    PremDivider.BorderSizePixel = 0
    PremDivider.Parent = PremiumAccess

    local PremBadge = Instance.new("TextLabel")
    PremBadge.Size = UDim2.new(0, 62, 0, 18)
    PremBadge.Position = UDim2.new(0, 18, 0, 14)
    PremBadge.BackgroundColor3 = Color3.fromRGB(67, 50, 27)
    PremBadge.Text = "SAIRO+"
    PremBadge.TextColor3 = Color3.fromRGB(246, 192, 79)
    PremBadge.Font = Enum.Font.GothamBold
    PremBadge.TextSize = 8
    PremBadge.BorderSizePixel = 0
    PremBadge.Parent = PremiumAccess

    local PremBadgeCorner = Instance.new("UICorner")
    PremBadgeCorner.CornerRadius = UDim.new(0, 4)
    PremBadgeCorner.Parent = PremBadge

    local PremTitle = Instance.new("TextLabel")
    PremTitle.Size = UDim2.new(1, -170, 0, 22)
    PremTitle.Position = UDim2.new(0, 18, 0, 40)
    PremTitle.BackgroundTransparency = 1
    PremTitle.Text = "Premium Access"
    PremTitle.TextColor3 = Color3.fromRGB(239, 245, 255)
    PremTitle.Font = Enum.Font.GothamBold
    PremTitle.TextSize = 15
    PremTitle.TextXAlignment = Enum.TextXAlignment.Left
    PremTitle.Parent = PremiumAccess

    local PremSub1 = Instance.new("TextLabel")
    PremSub1.Size = UDim2.new(1, -170, 0, 19)
    PremSub1.Position = UDim2.new(0, 18, 0, 64)
    PremSub1.BackgroundTransparency = 1
    PremSub1.Text = "Unlock extra perks and priority support"
    PremSub1.TextColor3 = Color3.fromRGB(162, 181, 209)
    PremSub1.Font = Enum.Font.GothamMedium
    PremSub1.TextSize = 11
    PremSub1.TextXAlignment = Enum.TextXAlignment.Left
    PremSub1.Parent = PremiumAccess

    local PremUrl = Instance.new("TextLabel")
    PremUrl.Size = UDim2.new(1, -170, 0, 18)
    PremUrl.Position = UDim2.new(0, 18, 0, 87)
    PremUrl.BackgroundTransparency = 1
    PremUrl.Text = "sairo.online/pricing"
    PremUrl.TextColor3 = Color3.fromRGB(246, 192, 79)
    PremUrl.Font = Enum.Font.GothamMedium
    PremUrl.TextSize = 10
    PremUrl.TextXAlignment = Enum.TextXAlignment.Left
    PremUrl.Parent = PremiumAccess

    local PremPerks = Instance.new("TextLabel")
    PremPerks.Size = UDim2.new(1, -170, 0, 19)
    PremPerks.Position = UDim2.new(0, 18, 0, 111)
    PremPerks.BackgroundTransparency = 1
    PremPerks.Text = "Priority support  |  Extra tools  |  Early access"
    PremPerks.TextColor3 = Color3.fromRGB(108, 132, 163)
    PremPerks.Font = Enum.Font.GothamMedium
    PremPerks.TextSize = 10
    PremPerks.TextXAlignment = Enum.TextXAlignment.Left
    PremPerks.Parent = PremiumAccess

    local PlansSlot = Instance.new("Frame")
    PlansSlot.Name = "PlansSlot"
    PlansSlot.Size = UDim2.new(0, 124, 0, 40)
    PlansSlot.Position = UDim2.new(1, -142, 0.5, -20)
    PlansSlot.BackgroundTransparency = 1
    PlansSlot.Parent = PremiumAccess

    local ViewPlansBtn = createStandardButton("PremiumPlans", 1, 0, Color3.fromRGB(126, 87, 232), "rbxassetid://7743866903", "View Plans", PlansSlot, 12)

    ViewPlansBtn.MouseButton1Click:Connect(function()
        if setclipboard then
            setclipboard("https://sairo.online/pricing")
            setStatus("Pricing link copied.", Color3.fromRGB(47, 224, 151), "rbxassetid://7733919427")
        end
    end)

    -- =========================================================================
    -- 3. RESPONSIVE MOBILE / PC ADAPTATION
    -- =========================================================================
    local isMobileView = false
    local isCompactMode = false

    local function adaptLayout()
        local vp = Camera.ViewportSize
        local mobile = (vp.X < 640 or vp.Y < 480 or (UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled))
        if mobile ~= isMobileView then
            isMobileView = mobile
            if isMobileView then
                UserInfo.Visible = false
                ColumnDivider.Visible = false
                Main.Size = UDim2.new(1, -16, 1, -16)
                Main.Position = UDim2.new(0, 8, 0, 8)
                PremiumAccess.Visible = false
                Shell.Size = UDim2.new(0, math.min(vp.X - 24, 460), 0, 440)
            else
                if not isCompactMode then
                    UserInfo.Visible = true
                    ColumnDivider.Visible = true
                    Main.Size = UDim2.new(0, 628, 0, 604)
                    Main.Position = UDim2.new(0, 294, 0, 8)
                    PremiumAccess.Visible = true
                    Shell.Size = UDim2.new(0, 930, 0, 620)
                end
            end
        end

        if not isMobileView then
            local availableH = vp.Y - 40
            local scaleH = math.clamp(availableH / 640, 0.7, 1)
            ShellScale.Scale = scaleH
        else
            ShellScale.Scale = 1
        end
    end

    Camera:GetPropertyChangedSignal("ViewportSize"):Connect(adaptLayout)
    adaptLayout()

    -- =========================================================================
    -- 4. DRAGGABLE WINDOW LOGIC
    -- =========================================================================
    local isDragging = false
    local dragStart, startPos

    local function onDragStart(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            isDragging = true
            dragStart = input.Position
            startPos = Shell.Position
        end
    end

    Header.InputBegan:Connect(onDragStart)
    UserInfo.InputBegan:Connect(onDragStart)

    UserInputService.InputChanged:Connect(function(input)
        if isDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            Shell.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    local function onDragEnd(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            isDragging = false
        end
    end
    UserInputService.InputEnded:Connect(onDragEnd)

    -- =========================================================================
    -- 5. SMOOTH POP-IN & POP-OUT ANIMATIONS
    -- =========================================================================
    local isDismissing = false
    local function closeWithAnimation(callback)
        if isDismissing then return end
        isDismissing = true
        TweenService:Create(Backdrop, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play()
        local tPop = TweenService:Create(ShellScale, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Scale = ShellScale.Scale * 1.06})
        tPop:Play()
        tPop.Completed:Connect(function()
            local tShrink = TweenService:Create(ShellScale, TweenInfo.new(0.22, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Scale = 0.65})
            tShrink:Play()
            tShrink.Completed:Connect(function()
                ScreenGui:Destroy()
                if callback then callback() end
            end)
        end)
    end

    CloseBtn.MouseButton1Click:Connect(function()
        closeWithAnimation()
    end)

    -- AUTHENTIC COMPACT MODE TOGGLE (From Snowy Timeline Dump)
    MinBtn.MouseButton1Click:Connect(function()
        isCompactMode = not isCompactMode
        if isCompactMode then
            -- Transition smoothly into Compact Mode
            TweenService:Create(UserInfo, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                Position = UDim2.new(0, -286, 0, 8)
            }):Play()
            TweenService:Create(ColumnDivider, TweenInfo.new(0.2), {
                BackgroundTransparency = 1
            }):Play()
            TweenService:Create(Main, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                Position = UDim2.new(0, 8, 0, 8)
            }):Play()
            local tCompact = TweenService:Create(Shell, TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                Size = UDim2.new(0, 644, 0, 620)
            })
            tCompact:Play()
            tCompact.Completed:Connect(function()
                if isCompactMode then
                    UserInfo.Visible = false
                    ColumnDivider.Visible = false
                end
            end)
            setStatus("Compact mode enabled.", Color3.fromRGB(162, 181, 209), "rbxassetid://7733964719")
        else
            -- Restore Standard Dual-Column Layout
            UserInfo.Visible = true
            ColumnDivider.Visible = true
            TweenService:Create(Shell, TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                Size = UDim2.new(0, 930, 0, 620)
            }):Play()
            TweenService:Create(UserInfo, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                Position = UDim2.new(0, 8, 0, 8)
            }):Play()
            TweenService:Create(ColumnDivider, TweenInfo.new(0.2), {
                BackgroundTransparency = 0.5
            }):Play()
            TweenService:Create(Main, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                Position = UDim2.new(0, 294, 0, 8)
            }):Play()
            setStatus("Ready for " .. gameTitle, Color3.fromRGB(246, 192, 79), "rbxassetid://7733964719")
        end
    end)

    -- Entrance Scale Animation (0.8x -> 1.05x -> 1.0x)
    local targetScale = ShellScale.Scale
    ShellScale.Scale = 0.78
    Backdrop.BackgroundTransparency = 1
    TweenService:Create(Backdrop, TweenInfo.new(0.3), {BackgroundTransparency = 0.65}):Play()
    TweenService:Create(ShellScale, TweenInfo.new(0.38, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Scale = targetScale}):Play()

    -- =========================================================================
    -- 6. BUTTON ACTIONS
    -- =========================================================================
    DiscordBtn.MouseButton1Click:Connect(function()
        if setclipboard then
            setclipboard("https://dsc.gg/sairo")
            setStatus("Discord link copied.", Color3.fromRGB(47, 224, 151), "rbxassetid://7733919427")
        end
    end)

    CopyHwidBtn.MouseButton1Click:Connect(function()
        if setclipboard then
            setclipboard(HWID)
            setStatus("HWID copied to clipboard.", Color3.fromRGB(47, 224, 151), "rbxassetid://7733919427")
        end
    end)

    LiveSupportBtn.MouseButton1Click:Connect(function()
        if setclipboard then
            setclipboard("https://dsc.gg/sairo")
            setStatus("Support link copied to clipboard.", Color3.fromRGB(47, 224, 151), "rbxassetid://7733919427")
        end
        pcall(function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/wendigo5414-cmyk/FireballxArena/refs/heads/main/feedbacksystem"))()
        end)
    end)

    -- =========================================================================
    -- 7. API & AUTHENTICATION LOGIC
    -- =========================================================================
    local function getKey()
        setStatus("Generating Key link...", Color3.fromRGB(246, 192, 79), "rbxassetid://7733964719")
        local robloxName = LocalPlayer.Name
        local url = API_URL .. "/api/init"
        local body = HttpService:JSONEncode({hwid = HWID, robloxName = robloxName, devId = DEV_ID})

        local success, response = pcall(function()
            local req = syn and syn.request or http and http.request or request
            if req then
                return req({Url = url, Method = "POST", Headers = {["Content-Type"] = "application/json"}, Body = body})
            else
                return {StatusCode = 500, Body = "Executor not supported"}
            end
        end)

        if success and response.StatusCode == 200 then
            local data = HttpService:JSONDecode(response.Body)
            if data.url then
                if setclipboard then setclipboard(data.url) end
                setStatus("Key URL copied to clipboard! Open in browser.", Color3.fromRGB(47, 224, 151), "rbxassetid://7733919427")
            else
                setStatus("Server error generating link.", Color3.fromRGB(244, 63, 94), "rbxassetid://7733964719", "API did not return a valid checkpoint URL.")
            end
        else
            setStatus("Connection failed to Sairo API.", Color3.fromRGB(244, 63, 94), "rbxassetid://7733964719", "Could not connect to " .. API_URL)
        end
    end

    local function onVerify()
        local inputKey = KeyInput.Text:gsub("%s+", "")
        if inputKey == "" then
            setStatus("Please enter a valid key.", Color3.fromRGB(246, 192, 79), "rbxassetid://7733964719")
            return
        end

        RedeemLbl.Text = "Checking..."
        setStatus("Authenticating with Sairo gateway...", Color3.fromRGB(246, 192, 79), "rbxassetid://7733964719")

        local robloxName = LocalPlayer.Name
        local url = API_URL .. "/api/verify-key?key=" .. inputKey .. "&hwid=" .. HWID .. "&robloxName=" .. robloxName

        local success, response = pcall(function() return game:HttpGet(url) end)

        if success then
            local sDecode, data = pcall(function() return HttpService:JSONDecode(response) end)
            if sDecode and data and data.status == "valid" then
                setStatus("Access Granted! Launching script...", Color3.fromRGB(47, 224, 151), "rbxassetid://7733919427")
                if writefile then
                    pcall(function() writefile("SairoAuth.txt", inputKey) end)
                end

                task.wait(0.6)
                closeWithAnimation(function()
                    isVerified = true
                end)
                return
            elseif data and data.status == "invalid_hwid" then
                setStatus("HWID mismatch! Key used on another device.", Color3.fromRGB(244, 63, 94), "rbxassetid://7733964719", "Your key is locked to another HWID.")
            else
                setStatus("Key is invalid or expired.", Color3.fromRGB(244, 63, 94), "rbxassetid://7733964719", "Please generate a new key or check for typos.")
            end
        else
            setStatus("Failed to reach Sairo verification server.", Color3.fromRGB(244, 63, 94), "rbxassetid://7733964719", "HTTP GET failed for Sairo verify endpoint.")
        end
        RedeemLbl.Text = "Redeem"
    end

    GetKeyBtn.MouseButton1Click:Connect(getKey)
    RedeemBtn.MouseButton1Click:Connect(onVerify)

    -- Auto login if saved key exists
    if readfile and pcall(function() return readfile("SairoAuth.txt") end) then
        local saved = readfile("SairoAuth.txt"):gsub("%s+", "")
        if saved ~= "" then
            KeyInput.Text = saved
            task.delay(0.4, onVerify)
        end
    end

    repeat task.wait(0.2) until isVerified
end

return SairoLibrary
