--[[ 
    SAIRO HUB - SIGNATURE LUXURY KEY SYSTEM (SAIROAUTH EDITION)
    - Recreated with Exact Lucide Asset IDs & Spritesheet Crop Offsets
    - Fixed Button Pop Engine (Zero Layout-Shift & Perfectly Centered Pop)
    - Full Automatic Multi-Device & Mobile Viewport Auto-Scaling (Zero Clipping)
    - Dynamic Multi-Size Layout Optimization (Fully Responsive Frame Anchoring)
    - Live Functional Sairo Hub Connectivity Heartbeat & Latency Monitor
    - Comprehensive Diagnostic Error Logger with One-Click Copy Error Button
    - Authentic Compact Mode Minimize Engine (Never Vertical Squish)
    - Animated Placeholder Trailing Dots & Interactive Status Feedback
    - Multi-Layer Avatar Halo, Gradient Ring & Online Dot Backing
    - Rotating Dual-Light Beam Border Animation
    - Verified Service Asset: rbxassetid://97736695351156
]]

local SairoLibrary = {
    _active = false,
    _isVerified = false
}

function SairoLibrary.Init()
    -- Singleton Guard: If an instance is already active, wait for it instead of spawning a duplicate GUI!
    if SairoLibrary._active then
        repeat task.wait(0.2) until SairoLibrary._isVerified
        return SairoLibrary
    end
    SairoLibrary._active = true
    SairoLibrary._isVerified = false

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

    local guiParent = getGuiParent()
    -- Destroy any previous or duplicate ScreenGui instances cleanly
    for _, child in ipairs(guiParent:GetChildren()) do
        if child.Name == "SairoFlowAuthLoader" then
            pcall(function() child:Destroy() end)
        end
    end

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "SairoFlowAuthLoader"
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.ResetOnSpawn = false
    ScreenGui.IgnoreGuiInset = true
    ScreenGui.Parent = guiParent

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
    Shell.Visible = false -- Pre-rendered in background, becomes visible only if key is required
    Shell.Parent = Backdrop

    local ShellCorner = Instance.new("UICorner")
    ShellCorner.CornerRadius = UDim.new(0, 16)
    ShellCorner.Parent = Shell

    local ShellScale = Instance.new("UIScale")
    ShellScale.Scale = 0.92
    ShellScale.Parent = Shell

    -- Premium Centered Loading Card (Shows while server connects & license verifies)
    local LoadingCard = Instance.new("Frame")
    LoadingCard.Name = "LoadingCard"
    LoadingCard.AnchorPoint = Vector2.new(0.5, 0.5)
    LoadingCard.Position = UDim2.new(0.5, 0, 0.5, 0)
    LoadingCard.Size = UDim2.new(0, 410, 0, 172)
    LoadingCard.BackgroundColor3 = Color3.fromRGB(12, 23, 39)
    LoadingCard.BorderSizePixel = 0
    LoadingCard.ClipsDescendants = true
    LoadingCard.Parent = Backdrop

    local LoadingCorner = Instance.new("UICorner")
    LoadingCorner.CornerRadius = UDim.new(0, 16)
    LoadingCorner.Parent = LoadingCard

    local LoadingScale = Instance.new("UIScale")
    LoadingScale.Scale = 0.72
    LoadingScale.Parent = LoadingCard
    -- Entrance Pop-In Animation
    TweenService:Create(LoadingScale, TweenInfo.new(0.38, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Scale = 1.0}):Play()

    -- Animated Luxury Cyber-Glow Stroke (Replaces static orange stroke)
    local LoadingStroke = Instance.new("UIStroke")
    LoadingStroke.Color = Color3.fromRGB(255, 255, 255)
    LoadingStroke.Thickness = 1.8
    LoadingStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    LoadingStroke.Parent = LoadingCard

    local LoadingStrokeGrad = Instance.new("UIGradient")
    LoadingStrokeGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(24, 38, 58)),
        ColorSequenceKeypoint.new(0.2, Color3.fromRGB(250, 204, 21)), -- Sun Yellow
        ColorSequenceKeypoint.new(0.35, Color3.fromRGB(249, 115, 22)), -- Flame Orange
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(24, 38, 58)),
        ColorSequenceKeypoint.new(0.7, Color3.fromRGB(168, 85, 247)), -- Violet
        ColorSequenceKeypoint.new(0.85, Color3.fromRGB(56, 189, 248)), -- Cyan
        ColorSequenceKeypoint.new(1, Color3.fromRGB(24, 38, 58))
    })
    LoadingStrokeGrad.Rotation = 0
    LoadingStrokeGrad.Parent = LoadingStroke

    local LoadingIcon = Instance.new("ImageLabel")
    LoadingIcon.Name = "LoadingIcon"
    LoadingIcon.Size = UDim2.new(0, 32, 0, 32)
    LoadingIcon.Position = UDim2.new(0, 22, 0, 22)
    LoadingIcon.BackgroundTransparency = 1
    LoadingIcon.Image = "rbxassetid://7733919427" -- Shield check
    LoadingIcon.ImageColor3 = Color3.fromRGB(250, 204, 21)
    LoadingIcon.Parent = LoadingCard

    local LoadingTitle = Instance.new("TextLabel")
    LoadingTitle.Name = "LoadingTitle"
    LoadingTitle.Size = UDim2.new(1, -145, 0, 20)
    LoadingTitle.Position = UDim2.new(0, 64, 0, 20)
    LoadingTitle.BackgroundTransparency = 1
    LoadingTitle.Font = Enum.Font.GothamBlack
    LoadingTitle.Text = "SAIRO SECURITY GATEWAY"
    LoadingTitle.TextColor3 = Color3.fromRGB(239, 245, 255)
    LoadingTitle.TextSize = 13
    LoadingTitle.TextXAlignment = Enum.TextXAlignment.Left
    LoadingTitle.Parent = LoadingCard

    local LoadingPct = Instance.new("TextLabel")
    LoadingPct.Name = "LoadingPct"
    LoadingPct.Size = UDim2.new(0, 65, 0, 20)
    LoadingPct.Position = UDim2.new(1, -87, 0, 20)
    LoadingPct.BackgroundTransparency = 1
    LoadingPct.Font = Enum.Font.GothamBold
    LoadingPct.Text = "0%"
    LoadingPct.TextColor3 = Color3.fromRGB(246, 192, 79)
    LoadingPct.TextSize = 13
    LoadingPct.TextXAlignment = Enum.TextXAlignment.Right
    LoadingPct.Parent = LoadingCard

    local LoadingStatus = Instance.new("TextLabel")
    LoadingStatus.Name = "LoadingStatus"
    LoadingStatus.Size = UDim2.new(1, -76, 0, 18)
    LoadingStatus.Position = UDim2.new(0, 64, 0, 42)
    LoadingStatus.BackgroundTransparency = 1
    LoadingStatus.Font = Enum.Font.GothamBold
    LoadingStatus.Text = "Connecting to Sairo Security Gateway..."
    LoadingStatus.TextColor3 = Color3.fromRGB(162, 181, 209)
    LoadingStatus.TextSize = 11
    LoadingStatus.TextXAlignment = Enum.TextXAlignment.Left
    LoadingStatus.Parent = LoadingCard

    -- Double Thickness Progress Bar Track (Height 16px)
    local ProgressTrack = Instance.new("Frame")
    ProgressTrack.Name = "ProgressTrack"
    ProgressTrack.Size = UDim2.new(1, -44, 0, 16)
    ProgressTrack.Position = UDim2.new(0, 22, 0, 78)
    ProgressTrack.BackgroundColor3 = Color3.fromRGB(6, 14, 25)
    ProgressTrack.BorderSizePixel = 0
    ProgressTrack.ClipsDescendants = true
    ProgressTrack.Parent = LoadingCard

    local ProgressCorner = Instance.new("UICorner")
    ProgressCorner.CornerRadius = UDim.new(1, 0)
    ProgressCorner.Parent = ProgressTrack

    local ProgressTrackStroke = Instance.new("UIStroke")
    ProgressTrackStroke.Color = Color3.fromRGB(30, 48, 76)
    ProgressTrackStroke.Thickness = 1
    ProgressTrackStroke.Parent = ProgressTrack

    -- Rainbow RGB Glowing Progress Fill
    local ProgressBar = Instance.new("Frame")
    ProgressBar.Name = "ProgressBar"
    ProgressBar.Size = UDim2.new(0, 0, 1, 0)
    ProgressBar.Position = UDim2.new(0, 0, 0, 0)
    ProgressBar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    ProgressBar.BorderSizePixel = 0
    ProgressBar.Parent = ProgressTrack

    local BarCorner = Instance.new("UICorner")
    BarCorner.CornerRadius = UDim.new(1, 0)
    BarCorner.Parent = ProgressBar

    -- Glowing Rainbow Gradient
    local BarGrad = Instance.new("UIGradient")
    BarGrad.Parent = ProgressBar

    -- Glossy Shine Glass Overlay on Progress Track (Capsule Glass Glare)
    local ProgressShine = Instance.new("Frame")
    ProgressShine.Name = "ProgressShine"
    ProgressShine.Size = UDim2.new(1, 0, 0.48, 0)
    ProgressShine.Position = UDim2.new(0, 0, 0, 0)
    ProgressShine.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    ProgressShine.BackgroundTransparency = 0.84
    ProgressShine.BorderSizePixel = 0
    ProgressShine.ZIndex = 4
    ProgressShine.Parent = ProgressTrack

    local ShineGrad = Instance.new("UIGradient")
    ShineGrad.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.72),
        NumberSequenceKeypoint.new(1, 1.0)
    })
    ShineGrad.Rotation = 90
    ShineGrad.Parent = ProgressShine

    local LoadingSubtext = Instance.new("TextLabel")
    LoadingSubtext.Name = "LoadingSubtext"
    LoadingSubtext.Size = UDim2.new(1, -44, 0, 36)
    LoadingSubtext.Position = UDim2.new(0, 22, 0, 108)
    LoadingSubtext.BackgroundTransparency = 1
    LoadingSubtext.Font = Enum.Font.GothamMedium
    LoadingSubtext.Text = "Verifying multi-layer shield & game credentials..."
    LoadingSubtext.TextColor3 = Color3.fromRGB(108, 132, 163)
    LoadingSubtext.TextSize = 10
    LoadingSubtext.TextWrapped = true
    LoadingSubtext.TextXAlignment = Enum.TextXAlignment.Left
    LoadingSubtext.Parent = LoadingCard

    -- Dynamic Animation Loop for LoadingCard (Continuous Silky Chromatic Flow + Rotating Stroke)
    local loadingConn
    loadingConn = RunService.RenderStepped:Connect(function(dt)
        if not LoadingCard or not LoadingCard.Parent or not ScreenGui.Parent then
            if loadingConn then loadingConn:Disconnect() end
            return
        end
        if LoadingStrokeGrad and LoadingStrokeGrad.Parent then
            LoadingStrokeGrad.Rotation = (LoadingStrokeGrad.Rotation + (140 * dt)) % 360
        end
        if BarGrad and BarGrad.Parent and not isVerified then
            local t = tick() * 0.45
            BarGrad.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromHSV((t) % 1, 0.90, 1.0)),
                ColorSequenceKeypoint.new(0.2, Color3.fromHSV((t + 0.2) % 1, 0.90, 1.0)),
                ColorSequenceKeypoint.new(0.4, Color3.fromHSV((t + 0.4) % 1, 0.90, 1.0)),
                ColorSequenceKeypoint.new(0.6, Color3.fromHSV((t + 0.6) % 1, 0.90, 1.0)),
                ColorSequenceKeypoint.new(0.8, Color3.fromHSV((t + 0.8) % 1, 0.90, 1.0)),
                ColorSequenceKeypoint.new(1, Color3.fromHSV((t + 1.0) % 1, 0.90, 1.0))
            })
        end
    end)

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
    -- 1. LEFT COLUMN: USER INFO (Fully responsive height)
    -- =========================================================================
    local UserInfo = Instance.new("Frame")
    UserInfo.Name = "UserInfo"
    UserInfo.Size = UDim2.new(0, 278, 1, -16)
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

    -- Authentic Avatar Halo System
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
    OnlineDot.Name = "OnlineDot"
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

    -- Metrics (Session + Ping) - Docked above ConnectedCard
    local Metrics = Instance.new("Frame")
    Metrics.Name = "Metrics"
    Metrics.Size = UDim2.new(1, -36, 0, 66)
    Metrics.Position = UDim2.new(0, 18, 1, -156)
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

    -- Connected to Sairo Hub Badge Card (Functional & Responsive Bottom Dock)
    local ConnectedCard = Instance.new("Frame")
    ConnectedCard.Name = "ConnectedCard"
    ConnectedCard.Size = UDim2.new(1, -36, 0, 68)
    ConnectedCard.Position = UDim2.new(0, 18, 1, -80)
    ConnectedCard.BackgroundTransparency = 1
    ConnectedCard.Parent = UserInfo

    local ConnIcon = createLucideIcon("rbxassetid://7733919427", 20, Color3.fromRGB(47, 224, 151), ConnectedCard)
    ConnIcon.Position = UDim2.new(0, 14, 0, 24)

    local ConnTitle = Instance.new("TextLabel")
    ConnTitle.Name = "ConnTitle"
    ConnTitle.Size = UDim2.new(1, -56, 0, 24)
    ConnTitle.Position = UDim2.new(0, 44, 0, 11)
    ConnTitle.BackgroundTransparency = 1
    ConnTitle.Text = "Connecting to Hub..."
    ConnTitle.TextColor3 = Color3.fromRGB(246, 192, 79)
    ConnTitle.Font = Enum.Font.GothamBold
    ConnTitle.TextSize = 12
    ConnTitle.TextXAlignment = Enum.TextXAlignment.Left
    ConnTitle.Parent = ConnectedCard

    local ConnSub = Instance.new("TextLabel")
    ConnSub.Name = "ConnSub"
    ConnSub.Size = UDim2.new(1, -56, 0, 18)
    ConnSub.Position = UDim2.new(0, 44, 0, 35)
    ConnSub.BackgroundTransparency = 1
    ConnSub.Text = "Checking server status..."
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
    -- 2. RIGHT COLUMN: MAIN PANEL (Fully responsive width & height)
    -- =========================================================================
    local Main = Instance.new("Frame")
    Main.Name = "Main"
    Main.Size = UDim2.new(1, -302, 1, -16)
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

    -- =========================================================================
    -- BUTTON POP ANIMATION ENGINE (Fixed: Zero Layout-Shift & Perfectly Centered)
    -- =========================================================================
    local function applyButtonPop(btn, visual)
        local target = visual or btn
        local scale = target:FindFirstChildOfClass("UIScale")
        if not scale then
            scale = Instance.new("UIScale")
            scale.Scale = 1
            scale.Parent = target
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

    -- Header Icon Button Helper (Centered Pop)
    local function createHeaderIconButton(name, posX, iconAsset)
        local btn = Instance.new("ImageButton")
        btn.Name = name
        btn.Size = UDim2.new(0, 32, 0, 32)
        btn.Position = posX
        btn.BackgroundTransparency = 1
        btn.BorderSizePixel = 0
        btn.AutoButtonColor = false
        btn.Parent = Header

        local visual = Instance.new("Frame")
        visual.Name = "ButtonVisual"
        visual.AnchorPoint = Vector2.new(0.5, 0.5)
        visual.Position = UDim2.new(0.5, 0, 0.5, 0)
        visual.Size = UDim2.new(1, 0, 1, 0)
        visual.BackgroundColor3 = Color3.fromRGB(23, 36, 59)
        visual.BorderSizePixel = 0
        visual.Parent = btn

        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 8)
        corner.Parent = visual

        local icon = createLucideIcon(iconAsset, 16, Color3.fromRGB(162, 181, 209), visual)
        icon.AnchorPoint = Vector2.new(0.5, 0.5)
        icon.Position = UDim2.new(0.5, 0, 0.5, 0)

        btn.MouseEnter:Connect(function()
            TweenService:Create(visual, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(33, 50, 80)}):Play()
        end)
        btn.MouseLeave:Connect(function()
            TweenService:Create(visual, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(23, 36, 59)}):Play()
        end)

        applyButtonPop(btn, visual)
        return btn
    end

    local MinBtn = createHeaderIconButton("Minimize", UDim2.new(1, -82, 0, 14), "rbxassetid://7734000129")
    local CloseBtn = createHeaderIconButton("Close", UDim2.new(1, -44, 0, 14), "rbxassetid://7743878857")

    local HeaderDiv = Instance.new("Frame")
    HeaderDiv.Size = UDim2.new(1, -40, 0, 1)
    HeaderDiv.Position = UDim2.new(0, 20, 0, 61)
    HeaderDiv.BackgroundColor3 = Color3.fromRGB(87, 119, 154)
    HeaderDiv.BackgroundTransparency = 0.6
    HeaderDiv.BorderSizePixel = 0
    HeaderDiv.Parent = Header

    -- Active Service Card
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

    -- Animated Key Placeholder Dots
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

    -- =========================================================================
    -- BUTTON BUILDER ENGINE (Zero UIListLayout Shifting & Symmetrically Centered)
    -- =========================================================================
    local function createStandardButton(name, widthScale, widthOffset, bgColor, iconAsset, labelText, parent, textSize, rectOffset, rectSize)
        -- Outer slot: Anchored inside UIListLayout with stable fixed bounds
        local btn = Instance.new("TextButton")
        btn.Name = name
        btn.Size = UDim2.new(widthScale, widthOffset, 1, 0)
        btn.BackgroundTransparency = 1
        btn.Text = ""
        btn.AutoButtonColor = false
        btn.Parent = parent

        -- Inner visual container: AnchorPoint (0.5, 0.5) ensures perfectly centered pop without moving neighbors!
        local visual = Instance.new("Frame")
        visual.Name = "ButtonVisual"
        visual.AnchorPoint = Vector2.new(0.5, 0.5)
        visual.Position = UDim2.new(0.5, 0, 0.5, 0)
        visual.Size = UDim2.new(1, 0, 1, 0)
        visual.BackgroundColor3 = bgColor
        visual.BorderSizePixel = 0
        visual.Parent = btn

        local c = Instance.new("UICorner")
        c.CornerRadius = UDim.new(0, 10)
        c.Parent = visual

        local content = Instance.new("Frame")
        content.Name = "ButtonContent"
        content.Size = UDim2.new(0, 0, 0, 18)
        content.Position = UDim2.new(0.5, 0, 0.5, 0)
        content.AnchorPoint = Vector2.new(0.5, 0.5)
        content.BackgroundTransparency = 1
        content.Parent = visual

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
            TweenService:Create(visual, TweenInfo.new(0.18), {BackgroundTransparency = 0.15}):Play()
        end)
        btn.MouseLeave:Connect(function()
            TweenService:Create(visual, TweenInfo.new(0.18), {BackgroundTransparency = 0}):Play()
        end)

        applyButtonPop(btn, visual)

        return btn, lbl, ic, visual
    end

    -- Primary Action Row (Get Key & Redeem)
    local PrimaryRow = Instance.new("Frame")
    PrimaryRow.Name = "PrimaryRow"
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
    UtilRow.Name = "UtilRow"
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

    -- Status Card Frame (Docked dynamically above Premium Access)
    local StatusCard = Instance.new("Frame")
    StatusCard.Name = "StatusCard"
    StatusCard.Size = UDim2.new(1, -40, 0, 46)
    StatusCard.Position = UDim2.new(0, 20, 1, -212)
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
    StatusSummary.Size = UDim2.new(1, -156, 0, 20)
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
    StatusDetail.Size = UDim2.new(1, -156, 0, 18)
    StatusDetail.Position = UDim2.new(0, 42, 0, 26)
    StatusDetail.BackgroundTransparency = 1
    StatusDetail.Text = ""
    StatusDetail.TextColor3 = Color3.fromRGB(162, 181, 209)
    StatusDetail.Font = Enum.Font.Gotham
    StatusDetail.TextSize = 9
    StatusDetail.TextXAlignment = Enum.TextXAlignment.Left
    StatusDetail.TextTruncate = Enum.TextTruncate.AtEnd
    StatusDetail.Visible = false
    StatusDetail.Parent = StatusCard

    local CopyErrorBtn = createStandardButton("CopyError", 0, 96, Color3.fromRGB(185, 28, 28), "rbxassetid://7733764083", "Copy Error", StatusCard, 9)
    CopyErrorBtn.Size = UDim2.new(0, 96, 0, 26)
    CopyErrorBtn.Position = UDim2.new(1, -100, 0.5, -13)
    CopyErrorBtn.Visible = false

    local lastFullDiagnostic = ""
    CopyErrorBtn.MouseButton1Click:Connect(function()
        if setclipboard and lastFullDiagnostic ~= "" then
            setclipboard(lastFullDiagnostic)
            StatusSummary.Text = "Diagnostic error copied!"
            StatusSummary.TextColor3 = Color3.fromRGB(47, 224, 151)
            StatusIcon.Image = "rbxassetid://7733919427"
            StatusIcon.ImageColor3 = Color3.fromRGB(47, 224, 151)
            task.delay(3, function()
                if ScreenGui.Parent then
                    StatusSummary.Text = "Ready for " .. gameTitle
                    StatusSummary.TextColor3 = Color3.fromRGB(246, 192, 79)
                    StatusIcon.Image = "rbxassetid://7733964719"
                    StatusIcon.ImageColor3 = Color3.fromRGB(246, 192, 79)
                end
            end)
        end
    end)

    -- Status Setter helper with Icon flipping & diagnostic reporting
    local function setStatus(text, color, iconAsset, detailText, fullDiagnosticReport)
        StatusSummary.Text = text
        StatusSummary.TextColor3 = color or Color3.fromRGB(246, 192, 79)
        StatusAccentLine.BackgroundColor3 = color or Color3.fromRGB(246, 192, 79)
        StatusIcon.Image = iconAsset or "rbxassetid://7733964719"
        StatusIcon.ImageColor3 = color or Color3.fromRGB(246, 192, 79)

        if detailText and detailText ~= "" then
            StatusDetail.Text = detailText
            StatusDetail.Visible = true
            StatusSummary.Position = UDim2.new(0, 42, 0, 8)
        else
            StatusDetail.Visible = false
            StatusSummary.Position = UDim2.new(0, 42, 0, 13)
        end

        if fullDiagnosticReport and fullDiagnosticReport ~= "" then
            lastFullDiagnostic = fullDiagnosticReport
            CopyErrorBtn.Visible = true
            warn("[SairoAuth Diagnostic Report]\n" .. fullDiagnosticReport)
        else
            CopyErrorBtn.Visible = false
        end
    end

    -- Diagnostic Report Generator
    local function buildDiagnosticReport(context, errCode, errMsg, rawRes, reqUrl)
        return string.format(
            "=== SAIRO HUB DIAGNOSTIC ERROR REPORT ===\n" ..
            "Timestamp: %s UTC\n" ..
            "Context: %s\n" ..
            "Error Code: %s\n" ..
            "Message: %s\n" ..
            "Target Endpoint: %s\n" ..
            "Roblox PlaceId: %s (%s)\n" ..
            "Client HWID: %s\n" ..
            "Player: %s (@%s)\n" ..
            "Executor: %s\n" ..
            "Device: %s\n" ..
            "Raw API Response:\n%s\n" ..
            "=========================================",
            os.date("!%Y-%m-%d %H:%M:%S"),
            tostring(context or "General"),
            tostring(errCode or "UNKNOWN_ERR"),
            tostring(errMsg or "An unexpected issue occurred."),
            tostring(reqUrl or API_URL),
            tostring(game.PlaceId),
            gameTitle,
            HWID,
            LocalPlayer.DisplayName or LocalPlayer.Name,
            LocalPlayer.Name,
            execName,
            deviceStr,
            tostring(rawRes or "N/A")
        )
    end

    -- Premium Access Card (Docked dynamically at the bottom of Main)
    local PremiumAccess = Instance.new("Frame")
    PremiumAccess.Name = "PremiumAccess"
    PremiumAccess.Size = UDim2.new(1, -40, 0, 146)
    PremiumAccess.Position = UDim2.new(0, 20, 1, -156)
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
    -- 3. RESPONSIVE MULTI-DEVICE AUTO-SCALING ENGINE (Phone & Desktop)
    -- =========================================================================
    local isMobileView = false
    local isCompactMode = false

    local function adaptLayout()
        local vp = Camera.ViewportSize
        -- Automatically detect phone/small screens or touch-only mobile devices
        local isMobile = (vp.X < 940 or vp.Y < 640 or (UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled))

        if isMobile ~= isMobileView then
            isMobileView = isMobile
            if isMobileView then
                -- Single-Column Mobile Mode: Ergonomic, touch-friendly, focused key entry
                UserInfo.Visible = false
                ColumnDivider.Visible = false
                Main.Size = UDim2.new(1, -16, 1, -16)
                Main.Position = UDim2.new(0, 8, 0, 8)
                Shell.Size = UDim2.new(0, 644, 0, 620)
            else
                -- Restore Standard Dual-Column Layout if not in Compact Mode
                if not isCompactMode then
                    UserInfo.Visible = true
                    ColumnDivider.Visible = true
                    Main.Size = UDim2.new(1, -302, 1, -16)
                    Main.Position = UDim2.new(0, 294, 0, 8)
                    Shell.Size = UDim2.new(0, 930, 0, 620)
                end
            end
        end

        -- Automatic Safe-Bounds Multi-Device Scaling (Phone, Tablet, Laptop, Ultrawide)
        local safeMarginX = isMobileView and 16 or 32
        local safeMarginY = isMobileView and 16 or 32
        local availableW = math.max(vp.X - safeMarginX, 100)
        local availableH = math.max(vp.Y - safeMarginY, 100)
        local targetW = (isMobileView or isCompactMode) and 644 or 930
        local targetH = 620

        local fitScale = math.min(availableW / targetW, availableH / targetH)
        -- Keep 1.0 on large displays, smoothly scale down on smaller screens/phones down to 0.40
        ShellScale.Scale = math.clamp(fitScale, 0.40, 1.0)
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
            local tShrink = TweenService:Create(ShellScale, TweenInfo.new(0.22, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Scale = 0.5})
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

    -- AUTHENTIC COMPACT MODE TOGGLE
    MinBtn.MouseButton1Click:Connect(function()
        if isMobileView then
            setStatus("Optimized for mobile screen.", Color3.fromRGB(162, 181, 209), "rbxassetid://7733964719")
            return
        end

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
                Position = UDim2.new(0, 8, 0, 8),
                Size = UDim2.new(1, -16, 1, -16)
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
            adaptLayout()
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
                Position = UDim2.new(0, 294, 0, 8),
                Size = UDim2.new(1, -302, 1, -16)
            }):Play()
            adaptLayout()
            setStatus("Ready for " .. gameTitle, Color3.fromRGB(246, 192, 79), "rbxassetid://7733964719")
        end
    end)

    -- Entrance Ambient Backdrop Animation
    Backdrop.BackgroundTransparency = 1
    TweenService:Create(Backdrop, TweenInfo.new(0.3), {BackgroundTransparency = 0.65}):Play()

    -- =========================================================================
    -- 7. BUTTON ACTIONS
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
    -- 8. LIVE FUNCTIONAL HUB CONNECTIVITY HEARTBEAT
    -- =========================================================================
    local isHubConnected = false
    local function testHubConnection()
        local t0 = os.clock()
        local testUrl = API_URL .. "/api/announcement"
        local success, res = pcall(function()
            local req = syn and syn.request or http and http.request or request
            if req then
                return req({Url = testUrl, Method = "GET"})
            else
                return {StatusCode = 200, Body = game:HttpGet(testUrl)}
            end
        end)

        local latency = math.floor((os.clock() - t0) * 1000)

        if success and res and (res.StatusCode == 200 or res.StatusCode == nil) then
            isHubConnected = true
            ConnTitle.Text = "Connected to Sairo Hub"
            ConnTitle.TextColor3 = Color3.fromRGB(47, 224, 151)
            ConnIcon.Image = "rbxassetid://7733919427"
            ConnIcon.ImageColor3 = Color3.fromRGB(47, 224, 151)
            ConnSub.Text = string.format("Operational (%d ms latency)", latency)
            ConnSub.TextColor3 = Color3.fromRGB(162, 181, 209)
            OnlineDot.BackgroundColor3 = Color3.fromRGB(64, 237, 165)
        else
            isHubConnected = false
            ConnTitle.Text = "Disconnected from Hub"
            ConnTitle.TextColor3 = Color3.fromRGB(244, 63, 94)
            ConnIcon.Image = "rbxassetid://7734000129"
            ConnIcon.ImageColor3 = Color3.fromRGB(244, 63, 94)
            ConnSub.Text = "Server Unreachable (Offline)"
            ConnSub.TextColor3 = Color3.fromRGB(244, 63, 94)
            OnlineDot.BackgroundColor3 = Color3.fromRGB(244, 63, 94)

            local errReport = buildDiagnosticReport(
                "Heartbeat Health Check",
                "HUB_OFFLINE",
                "Unable to establish handshake with Sairo API.",
                tostring(res and res.Body or "No response received"),
                testUrl
            )
            setStatus("Warning: Server Unreachable", Color3.fromRGB(244, 63, 94), "rbxassetid://7734000129", "Cannot reach Sairo API. Check your internet or Discord.", errReport)
        end
    end

    -- Initial Handshake + Recurring Background Heartbeat
    task.spawn(function()
        task.wait(0.2)
        testHubConnection()
        while ScreenGui.Parent do
            task.wait(15)
            testHubConnection()
        end
    end)

    -- =========================================================================
    -- 9. API & AUTHENTICATION LOGIC (With Comprehensive Diagnostics)
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
                return {StatusCode = 500, Body = "Executor does not support HTTP requests"}
            end
        end)

        if success and response and response.StatusCode == 200 then
            local decodeSuccess, data = pcall(function() return HttpService:JSONDecode(response.Body) end)
            if decodeSuccess and data and data.url then
                if setclipboard then setclipboard(data.url) end
                setStatus("Key URL copied to clipboard! Open in browser.", Color3.fromRGB(47, 224, 151), "rbxassetid://7733919427")
            else
                local report = buildDiagnosticReport(
                    "Key Generation Init",
                    "MALFORMED_RESPONSE",
                    "API did not return a valid checkpoint URL in JSON body.",
                    response.Body,
                    url
                )
                setStatus("Server error generating link.", Color3.fromRGB(244, 63, 94), "rbxassetid://7733964719", "API returned an invalid checkpoint response.", report)
            end
        else
            local statusC = (response and response.StatusCode) or "ERR_CONN"
            local rawB = (response and response.Body) or tostring(response)
            local report = buildDiagnosticReport(
                "Key Generation Init",
                "HTTP_" .. tostring(statusC),
                "Connection failed while calling /api/init on Sairo API.",
                rawB,
                url
            )
            setStatus("Connection failed to Sairo API.", Color3.fromRGB(244, 63, 94), "rbxassetid://7733964719", "Could not reach Sairo API (Status: " .. tostring(statusC) .. ")", report)
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
        local placeId = tostring(game.PlaceId or 0)
        local gameId = tostring(_G.TargetGameId or game.GameId or 0)
        local url = API_URL .. "/api/verify-key?key=" .. inputKey .. "&hwid=" .. HWID .. "&robloxName=" .. robloxName .. "&placeId=" .. placeId .. "&gameId=" .. gameId

        local success, response = pcall(function() return game:HttpGet(url) end)

        if success and response then
            local sDecode, data = pcall(function() return HttpService:JSONDecode(response) end)
            if sDecode and data and data.status == "valid" then
                setStatus("Access Granted! Launching script...", Color3.fromRGB(47, 224, 151), "rbxassetid://7733919427")
                if writefile then
                    pcall(function() writefile("SairoAuth.txt", inputKey) end)
                end

                task.wait(0.4)

                -- Seamless Handover to Decryption Chain if multi-layer script
                if _G.SairoTotalLayers and _G.SairoTotalLayers > 1 and _G.SairoNextLayerUrl then
                    local popShell = TweenService:Create(ShellScale, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Scale = 0.45})
                    popShell:Play()
                    popShell.Completed:Connect(function()
                        Shell.Visible = false
                        LoadingCard.Visible = true
                        LoadingScale.Scale = 0.45
                        LoadingCard.BackgroundTransparency = 0
                        TweenService:Create(LoadingScale, TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Scale = 1.0}):Play()
                        LoadingStatus.Text = "License Verified! Decrypting Security Layers..."
                        LoadingStatus.TextColor3 = Color3.fromRGB(47, 224, 151)
                        LoadingSubtext.Text = "Authorization confirmed. Initializing decryption chain..."
                        task.wait(0.25)
                        if _G.SairoSecurity and _G.SairoSecurity.AdvanceLayer then
                            _G.SairoSecurity.AdvanceLayer(1, _G.SairoTotalLayers)
                        end
                        task.spawn(function()
                            local s, err = pcall(function()
                                loadstring(game:HttpGet(_G.SairoNextLayerUrl))()
                            end)
                            if not s then
                                warn("[Sairo] Decryption chain error: " .. tostring(err))
                            end
                        end)
                    end)
                    return
                end

                closeWithAnimation(function()
                    isVerified = true
                    SairoLibrary._isVerified = true
                    SairoLibrary._active = false
                    -- Only execute server payload if running in Universal Runscript Mode!
                    -- For normal/old scripts importing keysystem.lua, the script itself continues execution after Init()
                    if _G.SairoRunScriptMode and data.scriptPayload and #data.scriptPayload > 0 then
                        local execFn, loadErr = loadstring(data.scriptPayload)
                        if execFn then
                            task.spawn(execFn)
                        else
                            warn("[Sairo] Execution error: " .. tostring(loadErr))
                        end
                    end
                end)
                return
            elseif sDecode and data and data.status == "invalid_hwid" then
                local report = buildDiagnosticReport(
                    "Key Verification",
                    "HWID_MISMATCH",
                    "This license key is already locked to another hardware identity.",
                    response,
                    url
                )
                setStatus("HWID mismatch! Key used on another device.", Color3.fromRGB(244, 63, 94), "rbxassetid://7733964719", "Key is hardware locked to another device.", report)
            else
                local serverMsg = (data and (data.message or data.error)) or "Key is invalid or expired."
                local report = buildDiagnosticReport(
                    "Key Verification",
                    "INVALID_KEY",
                    tostring(serverMsg),
                    response,
                    url
                )
                setStatus("Key is invalid or expired.", Color3.fromRGB(244, 63, 94), "rbxassetid://7733964719", tostring(serverMsg), report)
            end
        else
            local report = buildDiagnosticReport(
                "Key Verification",
                "HTTP_GET_FAILED",
                "HTTP GET request to Sairo verify endpoint failed.",
                tostring(response),
                url
            )
            setStatus("Failed to reach Sairo verification server.", Color3.fromRGB(244, 63, 94), "rbxassetid://7733964719", "Network error contacting verification endpoint.", report)
        end
        RedeemLbl.Text = "Redeem"
    end

    GetKeyBtn.MouseButton1Click:Connect(getKey)
    RedeemBtn.MouseButton1Click:Connect(onVerify)

    -- Smart Gateway Pre-Auth & Loading Gateway
    task.spawn(function()
        local placeId = tostring(game.PlaceId or 0)
        local gameId = tostring(_G.TargetGameId or game.GameId or 0)
        local robloxName = LocalPlayer.Name

        local currentProgressPct = 0
        local function advanceProgress(targetPct, stepDelay)
            stepDelay = stepDelay or 0.1
            targetPct = math.clamp(targetPct, 0, 100)
            while currentProgressPct < targetPct do
                currentProgressPct = math.min(currentProgressPct + 10, targetPct)
                LoadingPct.Text = tostring(math.floor(currentProgressPct)) .. "%"
                local frac = currentProgressPct / 100
                TweenService:Create(ProgressBar, TweenInfo.new(stepDelay * 0.92, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    Size = UDim2.new(frac, 0, 1, 0)
                }):Play()
                task.wait(stepDelay)
            end
        end

        -- Step 1: Connecting to Sairo Gateway (0% -> 40% with 0.1s delay per 10%)
        LoadingStatus.Text = "Connecting to Sairo Gateway..."
        LoadingSubtext.Text = "Establishing encrypted SSL handshake..."
        advanceProgress(40, 0.1)

        -- Check saved key in SairoAuth.txt
        local savedKey = ""
        if readfile and pcall(function() return readfile("SairoAuth.txt") end) then
            savedKey = (readfile("SairoAuth.txt") or ""):gsub("%s+", "")
            if savedKey ~= "" then
                KeyInput.Text = savedKey
            end
        end

        -- Define Global Sairo Security Decryption Controller
        _G.SairoSecurity = {
            TotalLayers = _G.SairoTotalLayers or 7,
            CurrentLayer = 0,
            AdvanceLayer = function(layerIdx, total)
                total = total or _G.SairoTotalLayers or 7
                _G.SairoSecurity.CurrentLayer = layerIdx
                local pct = math.floor(60 + ((layerIdx / total) * 40))
                pct = math.clamp(pct, 60, 100)
                LoadingStatus.Text = "Decrypting Security Layer (" .. tostring(layerIdx) .. " / " .. tostring(total) .. ")..."
                LoadingStatus.TextColor3 = Color3.fromRGB(239, 245, 255)
                LoadingSubtext.Text = "Deobfuscating runtime bytecode layer " .. tostring(layerIdx) .. " of " .. tostring(total) .. "..."
                LoadingPct.Text = tostring(pct) .. "%"
                TweenService:Create(ProgressBar, TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    Size = UDim2.new(pct / 100, 0, 1, 0)
                }):Play()
            end,
            Finish = function()
                LoadingStatus.Text = "Decryption Complete! Launching script..."
                LoadingStatus.TextColor3 = Color3.fromRGB(47, 224, 151)
                LoadingSubtext.Text = "All security layers unlocked. Enjoy your script!"
                LoadingIcon.ImageColor3 = Color3.fromRGB(47, 224, 151)
                LoadingPct.Text = "100%"
                isVerified = true
                if BarGrad and BarGrad.Parent then
                    BarGrad.Color = ColorSequence.new({
                        ColorSequenceKeypoint.new(0, Color3.fromRGB(47, 224, 151)),
                        ColorSequenceKeypoint.new(1, Color3.fromRGB(16, 185, 129))
                    })
                end
                TweenService:Create(ProgressBar, TweenInfo.new(0.15), {Size = UDim2.new(1, 0, 1, 0)}):Play()
                task.wait(0.35)
                local tDismiss = TweenService:Create(LoadingScale, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
                    Scale = 0.45
                })
                TweenService:Create(LoadingCard, TweenInfo.new(0.18), {BackgroundTransparency = 1}):Play()
                TweenService:Create(Backdrop, TweenInfo.new(0.25), {BackgroundTransparency = 1}):Play()
                tDismiss:Play()
                tDismiss.Completed:Connect(function()
                    LoadingCard:Destroy()
                    if ScreenGui and ScreenGui.Parent then
                        ScreenGui:Destroy()
                    end
                end)
                isVerified = true
                SairoLibrary._isVerified = true
                SairoLibrary._active = false
            end
        }

        -- Step 2: Resolving license & free trials
        LoadingStatus.Text = "Resolving game license & free trials..."
        LoadingSubtext.Text = "Verifying place ID " .. placeId .. " credentials..."

        local authData = nil
        local netDone = false
        task.spawn(function()
            local checkUrl = API_URL .. "/api/runscript/auth-check?placeId=" .. placeId .. "&gameId=" .. gameId .. "&hwid=" .. HWID .. "&username=" .. robloxName .. "&key=" .. savedKey
            local reqSuccess, checkResponse = pcall(function()
                return game:HttpGet(checkUrl)
            end)
            if reqSuccess and checkResponse then
                local decOk, parsed = pcall(function() return HttpService:JSONDecode(checkResponse) end)
                if decOk and parsed then
                    authData = parsed
                end
            end
            netDone = true
        end)

        -- If script has multiple security layers, only load up to 60% during handshake
        -- The remaining 60% -> 100% will be dynamically mapped to layers (e.g. 1/7 to 7/7)
        local targetHandshakePct = (_G.SairoTotalLayers and _G.SairoTotalLayers > 1) and 60 or 70
        advanceProgress(targetHandshakePct, 0.1)

        -- Await response if network is taking a moment, then complete handshake
        local waitBudget = 0
        while not netDone and waitBudget < 3.0 do
            task.wait(0.05)
            waitBudget = waitBudget + 0.05
        end

        -- Check if layers are present and user is verified
        if authData and authData.verified == true and _G.SairoTotalLayers and _G.SairoTotalLayers > 1 and _G.SairoNextLayerUrl then
            -- Seamless Decryption Phase: Progress smoothly transitions into Layer Decryption (60% -> 100%)
            LoadingStatus.Text = "License Verified! Decrypting Security Layers..."
            LoadingStatus.TextColor3 = Color3.fromRGB(47, 224, 151)
            LoadingSubtext.Text = "Authorization confirmed. Initializing decryption chain..."
            LoadingIcon.ImageColor3 = Color3.fromRGB(47, 224, 151)
            task.wait(0.25)
            _G.SairoSecurity.AdvanceLayer(1, _G.SairoTotalLayers)
            task.spawn(function()
                local s, err = pcall(function()
                    loadstring(game:HttpGet(_G.SairoNextLayerUrl))()
                end)
                if not s then
                    warn("[Sairo] Decryption chain error: " .. tostring(err))
                end
            end)
            return
        end

        -- Step 3: Normal complete (No layers attached)
        advanceProgress(100, 0.1)
        LoadingPct.Text = "100%"

        -- Now execute transition based on auth result
        if authData and authData.verified == true then
            -- VERIFIED VIA FREE TRIAL OR SAVED LICENSE KEY
            if authData.isTrial then
                LoadingStatus.Text = "🎁 " .. tostring(authData.hoursLeft or authData.freeHours or 24) .. "h Free Access Active!"
                LoadingStatus.TextColor3 = Color3.fromRGB(47, 224, 151)
                LoadingSubtext.Text = "Free trial granted for this game. Enjoy!"
            else
                LoadingStatus.Text = "License Verified! Access Granted"
                LoadingStatus.TextColor3 = Color3.fromRGB(47, 224, 151)
                LoadingSubtext.Text = "Sairo authorization active. Welcome back!"
            end
            LoadingIcon.ImageColor3 = Color3.fromRGB(47, 224, 151)
            isVerified = true
            if BarGrad and BarGrad.Parent then
                BarGrad.Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(47, 224, 151)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(16, 185, 129))
                })
            end

            task.wait(0.35)
            -- Pop-in shrink dismissal
            local tDismiss = TweenService:Create(LoadingScale, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
                Scale = 0.45
            })
            TweenService:Create(LoadingCard, TweenInfo.new(0.18), {BackgroundTransparency = 1}):Play()
            TweenService:Create(Backdrop, TweenInfo.new(0.25), {BackgroundTransparency = 1}):Play()
            tDismiss:Play()
            tDismiss.Completed:Connect(function()
                ScreenGui:Destroy()
            end)

            isVerified = true
            SairoLibrary._isVerified = true
            SairoLibrary._active = false

            -- Only execute server payload if running in Universal Runscript Mode!
            if _G.SairoRunScriptMode and authData.scriptPayload and #authData.scriptPayload > 0 then
                local execFn, loadErr = loadstring(authData.scriptPayload)
                if execFn then
                    task.spawn(execFn)
                else
                    warn("[Sairo] Error running payload: " .. tostring(loadErr))
                end
            end
            return
        else
            -- NOT VERIFIED: License key required
            LoadingStatus.Text = "Authentication Required"
            LoadingStatus.TextColor3 = Color3.fromRGB(246, 192, 79)
            LoadingSubtext.Text = "Launching Sairo Key System interface..."

            if authData and authData.trialExpired then
                setStatus("Free trial expired for this game. Enter key.", Color3.fromRGB(246, 192, 79), "rbxassetid://7733964719")
            end

            task.wait(0.2)

            -- 1. Pop-In: LoadingCard pops in (shrinks inward into center)
            local popInTween = TweenService:Create(LoadingScale, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
                Scale = 0.45
            })
            TweenService:Create(LoadingCard, TweenInfo.new(0.18), {BackgroundTransparency = 1}):Play()
            popInTween:Play()
            task.wait(0.2)
            LoadingCard:Destroy()

            -- 2. Pop-Out: Shell immediately pops out from center with luxury spring bounce
            Shell.Visible = true
            local finalFitScale = ShellScale.Scale
            ShellScale.Scale = finalFitScale * 0.72
            TweenService:Create(ShellScale, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                Scale = finalFitScale
            }):Play()
            return
        end
    end)

    repeat task.wait(0.2) until isVerified
    SairoLibrary._isVerified = true
    SairoLibrary._active = false
    return SairoLibrary
end

-- ONLY auto-initialize if explicitly running in Universal /runscript Mode!
-- Old scripts and custom scripts do: loadstring(game:HttpGet(".../keysystem.lua"))().Init()
if _G.SairoRunScriptMode then
    task.spawn(function()
        SairoLibrary.Init()
    end)
end

return SairoLibrary
