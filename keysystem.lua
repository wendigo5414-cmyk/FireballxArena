--[[ 
    SAIRO HUB - ULTRA PREMIUM KEY SYSTEM (SNOWY HUB / LIYHUB LUXURY EDITION)
    - Animated Falling Snow Particles
    - Rotating Dual-Light Glowing Border on Input Box
    - Responsive Auto-Adapting Mobile / PC Layout
    - Live User Avatar, HWID, Ping, Session & System Telemetry
    - Fluid Spring Scale Pop-In (120% -> 100%) & Pop-Out (115% -> 80% Fade)
    - Preserves Full Sairo API Verification & Auto-Login Logic
]]

local SairoLibrary = {}
local ANNOUNCEMENT = "Sairo Key System is fully operational. Fast & Secure."

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
    ScreenGui.Name = "SairoSnowyKeySystem"
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.ResetOnSpawn = false
    ScreenGui.IgnoreGuiInset = true
    ScreenGui.Parent = getGuiParent()

    -- Dark Ambient Blur / Dimmer
    local Backdrop = Instance.new("Frame")
    Backdrop.Name = "Backdrop"
    Backdrop.Size = UDim2.new(1, 0, 1, 0)
    Backdrop.BackgroundColor3 = Color3.fromRGB(4, 5, 8)
    Backdrop.BackgroundTransparency = 1
    Backdrop.BorderSizePixel = 0
    Backdrop.Parent = ScreenGui

    -- Main Container Frame
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    MainFrame.Size = UDim2.new(0, 690, 0, 420)
    MainFrame.BackgroundColor3 = Color3.fromRGB(11, 13, 17)
    MainFrame.BorderSizePixel = 0
    MainFrame.ClipsDescendants = true
    MainFrame.Parent = ScreenGui

    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 16)
    MainCorner.Parent = MainFrame

    local MainStroke = Instance.new("UIStroke")
    MainStroke.Color = Color3.fromRGB(28, 34, 46)
    MainStroke.Thickness = 1.2
    MainStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    MainStroke.Parent = MainFrame

    -- Inner Gradient
    local MainGrad = Instance.new("UIGradient")
    MainGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(13, 16, 22)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(9, 10, 14))
    })
    MainGrad.Rotation = 45
    MainGrad.Parent = MainFrame

    -- =========================================================================
    -- 1. AMBIENT FALLING SNOW PARTICLES (Snowy Hub Style)
    -- =========================================================================
    local SnowContainer = Instance.new("Frame")
    SnowContainer.Name = "SnowContainer"
    SnowContainer.Size = UDim2.new(1, 0, 1, 0)
    SnowContainer.BackgroundTransparency = 1
    SnowContainer.ClipsDescendants = true
    SnowContainer.ZIndex = 2
    SnowContainer.Parent = MainFrame

    local snowSymbols = {"❄", "•", "❅", "*"}
    local flakes = {}
    local rng = Random.new()

    for i = 1, 24 do
        local flake = Instance.new("TextLabel")
        flake.Name = "Flake_" .. i
        flake.BackgroundTransparency = 1
        flake.Font = Enum.Font.GothamBold
        flake.Text = snowSymbols[rng:NextInteger(1, #snowSymbols)]
        flake.TextColor3 = Color3.fromRGB(220, 235, 255)
        flake.TextSize = rng:NextInteger(8, 14)
        flake.TextTransparency = rng:NextNumber(0.45, 0.85)
        flake.ZIndex = 2
        flake.Parent = SnowContainer

        local startX = rng:NextNumber(0.02, 0.98)
        local startY = rng:NextNumber(-0.1, 1.0)
        local speed = rng:NextNumber(0.08, 0.22)
        local swaySpeed = rng:NextNumber(1.2, 2.5)
        local swayAmp = rng:NextNumber(0.005, 0.02)
        local timeOffset = rng:NextNumber(0, 10)

        flake.Position = UDim2.new(startX, 0, startY, 0)
        table.insert(flakes, {
            label = flake,
            x = startX,
            y = startY,
            speed = speed,
            swaySpeed = swaySpeed,
            swayAmp = swayAmp,
            offset = timeOffset
        })
    end

    local snowConn
    snowConn = RunService.Heartbeat:Connect(function(dt)
        if not ScreenGui.Parent then
            snowConn:Disconnect()
            return
        end
        local now = tick()
        for _, f in ipairs(flakes) do
            f.y = f.y + (f.speed * dt)
            local currentX = f.x + math.sin((now + f.offset) * f.swaySpeed) * f.swayAmp
            if f.y > 1.05 then
                f.y = -0.05
                f.x = rng:NextNumber(0.02, 0.98)
            end
            f.label.Position = UDim2.new(currentX, 0, f.y, 0)
        end
    end)

    -- =========================================================================
    -- 2. LEFT SIDEBAR (User Profile & Live Telemetry)
    -- =========================================================================
    local Sidebar = Instance.new("Frame")
    Sidebar.Name = "Sidebar"
    Sidebar.Size = UDim2.new(0, 225, 1, 0)
    Sidebar.Position = UDim2.new(0, 0, 0, 0)
    Sidebar.BackgroundColor3 = Color3.fromRGB(10, 11, 15)
    Sidebar.BorderSizePixel = 0
    Sidebar.ZIndex = 5
    Sidebar.Parent = MainFrame

    local SidebarCorner = Instance.new("UICorner")
    SidebarCorner.CornerRadius = UDim.new(0, 16)
    SidebarCorner.Parent = Sidebar

    local SidebarDivider = Instance.new("Frame")
    SidebarDivider.Name = "Divider"
    SidebarDivider.Size = UDim2.new(0, 1, 1, 0)
    SidebarDivider.Position = UDim2.new(1, -1, 0, 0)
    SidebarDivider.BackgroundColor3 = Color3.fromRGB(25, 29, 39)
    SidebarDivider.BorderSizePixel = 0
    SidebarDivider.ZIndex = 6
    SidebarDivider.Parent = Sidebar

    -- Sidebar Header
    local UserInfoTag = Instance.new("TextLabel")
    UserInfoTag.Size = UDim2.new(1, -30, 0, 20)
    UserInfoTag.Position = UDim2.new(0, 18, 0, 16)
    UserInfoTag.BackgroundTransparency = 1
    UserInfoTag.Text = "👤  USER INFO"
    UserInfoTag.TextColor3 = Color3.fromRGB(14, 165, 233)
    UserInfoTag.Font = Enum.Font.GothamBold
    UserInfoTag.TextSize = 11
    UserInfoTag.TextXAlignment = Enum.TextXAlignment.Left
    UserInfoTag.ZIndex = 6
    UserInfoTag.Parent = Sidebar

    -- Avatar Circle with glowing status ring
    local AvatarWrap = Instance.new("Frame")
    AvatarWrap.Size = UDim2.new(0, 68, 0, 68)
    AvatarWrap.Position = UDim2.new(0.5, -34, 0, 44)
    AvatarWrap.BackgroundColor3 = Color3.fromRGB(16, 20, 28)
    AvatarWrap.ZIndex = 6
    AvatarWrap.Parent = Sidebar

    local AvatarWrapCorner = Instance.new("UICorner")
    AvatarWrapCorner.CornerRadius = UDim.new(1, 0)
    AvatarWrapCorner.Parent = AvatarWrap

    local AvatarStroke = Instance.new("UIStroke")
    AvatarStroke.Color = Color3.fromRGB(14, 165, 233)
    AvatarStroke.Thickness = 2
    AvatarStroke.Parent = AvatarWrap

    local AvatarImg = Instance.new("ImageLabel")
    AvatarImg.Size = UDim2.new(1, -6, 1, -6)
    AvatarImg.Position = UDim2.new(0, 3, 0, 3)
    AvatarImg.BackgroundTransparency = 1
    AvatarImg.Image = "rbxthumb://type=AvatarHeadShot&id=" .. LocalPlayer.UserId .. "&w=150&h=150"
    AvatarImg.ZIndex = 7
    AvatarImg.Parent = AvatarWrap

    local AvatarImgCorner = Instance.new("UICorner")
    AvatarImgCorner.CornerRadius = UDim.new(1, 0)
    AvatarImgCorner.Parent = AvatarImg

    -- Status dot
    local StatusDot = Instance.new("Frame")
    StatusDot.Size = UDim2.new(0, 12, 0, 12)
    StatusDot.Position = UDim2.new(1, -12, 1, -12)
    StatusDot.BackgroundColor3 = Color3.fromRGB(34, 197, 94)
    StatusDot.ZIndex = 8
    StatusDot.Parent = AvatarWrap

    local StatusDotCorner = Instance.new("UICorner")
    StatusDotCorner.CornerRadius = UDim.new(1, 0)
    StatusDotCorner.Parent = StatusDot

    -- User display name & tag
    local UserNameLbl = Instance.new("TextLabel")
    UserNameLbl.Size = UDim2.new(1, -20, 0, 18)
    UserNameLbl.Position = UDim2.new(0, 10, 0, 118)
    UserNameLbl.BackgroundTransparency = 1
    UserNameLbl.Text = string.upper(LocalPlayer.DisplayName or LocalPlayer.Name)
    UserNameLbl.TextColor3 = Color3.fromRGB(240, 245, 255)
    UserNameLbl.Font = Enum.Font.GothamBold
    UserNameLbl.TextSize = 13
    UserNameLbl.TextTruncate = Enum.TextTruncate.AtEnd
    UserNameLbl.ZIndex = 6
    UserNameLbl.Parent = Sidebar

    local UserTagLbl = Instance.new("TextLabel")
    UserTagLbl.Size = UDim2.new(1, -20, 0, 14)
    UserTagLbl.Position = UDim2.new(0, 10, 0, 136)
    UserTagLbl.BackgroundTransparency = 1
    UserTagLbl.Text = "@" .. LocalPlayer.Name
    UserTagLbl.TextColor3 = Color3.fromRGB(120, 130, 150)
    UserTagLbl.Font = Enum.Font.Gotham
    UserTagLbl.TextSize = 11
    UserTagLbl.TextTruncate = Enum.TextTruncate.AtEnd
    UserTagLbl.ZIndex = 6
    UserTagLbl.Parent = Sidebar

    -- Hardware & Session Stats List
    local StatsList = Instance.new("Frame")
    StatsList.Size = UDim2.new(1, -24, 0, 170)
    StatsList.Position = UDim2.new(0, 12, 0, 160)
    StatsList.BackgroundTransparency = 1
    StatsList.ZIndex = 6
    StatsList.Parent = Sidebar

    local StatsLayout = Instance.new("UIListLayout")
    StatsLayout.SortOrder = Enum.SortOrder.LayoutOrder
    StatsLayout.Padding = UDim.new(0, 6)
    StatsLayout.Parent = StatsList

    local function createStatRow(icon, label, valueText)
        local row = Instance.new("Frame")
        row.Size = UDim2.new(1, 0, 0, 24)
        row.BackgroundTransparency = 1
        row.ZIndex = 6
        row.Parent = StatsList

        local ic = Instance.new("TextLabel")
        ic.Size = UDim2.new(0, 20, 1, 0)
        ic.BackgroundTransparency = 1
        ic.Text = icon
        ic.TextSize = 12
        ic.ZIndex = 6
        ic.Parent = row

        local lb = Instance.new("TextLabel")
        lb.Size = UDim2.new(0, 65, 1, 0)
        lb.Position = UDim2.new(0, 22, 0, 0)
        lb.BackgroundTransparency = 1
        lb.Text = label
        lb.TextColor3 = Color3.fromRGB(120, 130, 150)
        lb.Font = Enum.Font.Gotham
        lb.TextSize = 10
        lb.TextXAlignment = Enum.TextXAlignment.Left
        lb.ZIndex = 6
        lb.Parent = row

        local vl = Instance.new("TextLabel")
        vl.Size = UDim2.new(1, -90, 1, 0)
        vl.Position = UDim2.new(0, 90, 0, 0)
        vl.BackgroundTransparency = 1
        vl.Text = valueText
        vl.TextColor3 = Color3.fromRGB(220, 230, 245)
        vl.Font = Enum.Font.GothamBold
        vl.TextSize = 10
        vl.TextXAlignment = Enum.TextXAlignment.Right
        vl.TextTruncate = Enum.TextTruncate.AtEnd
        vl.ZIndex = 6
        vl.Parent = row

        return vl
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

    createStatRow("🖥️", "Executor", execName)
    createStatRow("📱", "Device", deviceStr)
    createStatRow("🛡️", "HWID", "Available")
    createStatRow("🎮", "Game", gameTitle)
    local sessionVal = createStatRow("⏱️", "Session", "00:00")
    local pingVal = createStatRow("📶", "Ping", "45 ms")

    -- Session Timer & Ping Updater
    local sessionSeconds = 0
    task.spawn(function()
        while ScreenGui.Parent do
            task.wait(1)
            sessionSeconds = sessionSeconds + 1
            local mins = math.floor(sessionSeconds / 60)
            local secs = sessionSeconds % 60
            sessionVal.Text = string.format("%02d:%02d", mins, secs)

            if sessionSeconds % 2 == 0 then
                pcall(function()
                    local ping = StatsService.Network.ServerStatsItem["Data Ping"]:GetValue()
                    pingVal.Text = string.format("%.1f ms", ping)
                end)
            end
        end
    end)

    -- Bottom Connected Badge
    local BottomBadge = Instance.new("Frame")
    BottomBadge.Size = UDim2.new(1, -24, 0, 32)
    BottomBadge.Position = UDim2.new(0, 12, 1, -44)
    BottomBadge.BackgroundColor3 = Color3.fromRGB(15, 23, 20)
    BottomBadge.BorderSizePixel = 0
    BottomBadge.ZIndex = 6
    BottomBadge.Parent = Sidebar

    local BottomBadgeCorner = Instance.new("UICorner")
    BottomBadgeCorner.CornerRadius = UDim.new(0, 8)
    BottomBadgeCorner.Parent = BottomBadge

    local BottomBadgeStroke = Instance.new("UIStroke")
    BottomBadgeStroke.Color = Color3.fromRGB(34, 197, 94)
    BottomBadgeStroke.Thickness = 1
    BottomBadgeStroke.Transparency = 0.5
    BottomBadgeStroke.Parent = BottomBadge

    local BadgeCheck = Instance.new("TextLabel")
    BadgeCheck.Size = UDim2.new(0, 20, 1, 0)
    BadgeCheck.Position = UDim2.new(0, 6, 0, 0)
    BadgeCheck.BackgroundTransparency = 1
    BadgeCheck.Text = "✓"
    BadgeCheck.TextColor3 = Color3.fromRGB(34, 197, 94)
    BadgeCheck.Font = Enum.Font.GothamBold
    BadgeCheck.TextSize = 13
    BadgeCheck.ZIndex = 7
    BadgeCheck.Parent = BottomBadge

    local BadgeTxt = Instance.new("TextLabel")
    BadgeTxt.Size = UDim2.new(1, -30, 1, 0)
    BadgeTxt.Position = UDim2.new(0, 26, 0, 0)
    BadgeTxt.BackgroundTransparency = 1
    BadgeTxt.Text = "Connected to Sairo Hub"
    BadgeTxt.TextColor3 = Color3.fromRGB(180, 230, 200)
    BadgeTxt.Font = Enum.Font.GothamBold
    BadgeTxt.TextSize = 10
    BadgeTxt.TextXAlignment = Enum.TextXAlignment.Left
    BadgeTxt.ZIndex = 7
    BadgeTxt.Parent = BottomBadge

    -- =========================================================================
    -- 3. RIGHT PANEL (Main Key Gateway Flow)
    -- =========================================================================
    local RightPanel = Instance.new("Frame")
    RightPanel.Name = "RightPanel"
    RightPanel.Size = UDim2.new(1, -225, 1, 0)
    RightPanel.Position = UDim2.new(0, 225, 0, 0)
    RightPanel.BackgroundTransparency = 1
    RightPanel.ZIndex = 5
    RightPanel.Parent = MainFrame

    -- Top Header Bar (Draggable)
    local HeaderBar = Instance.new("Frame")
    HeaderBar.Name = "HeaderBar"
    HeaderBar.Size = UDim2.new(1, 0, 0, 52)
    HeaderBar.BackgroundTransparency = 1
    HeaderBar.ZIndex = 8
    HeaderBar.Parent = RightPanel

    local BrandTitle = Instance.new("TextLabel")
    BrandTitle.Size = UDim2.new(0, 180, 0, 22)
    BrandTitle.Position = UDim2.new(0, 22, 0, 12)
    BrandTitle.BackgroundTransparency = 1
    BrandTitle.Text = "Sairo Hub"
    BrandTitle.TextColor3 = Color3.fromRGB(245, 248, 255)
    BrandTitle.Font = Enum.Font.GothamBlack
    BrandTitle.TextSize = 18
    BrandTitle.TextXAlignment = Enum.TextXAlignment.Left
    BrandTitle.ZIndex = 8
    BrandTitle.Parent = HeaderBar

    local BrandSub = Instance.new("TextLabel")
    BrandSub.Size = UDim2.new(0, 180, 0, 14)
    BrandSub.Position = UDim2.new(0, 22, 0, 32)
    BrandSub.BackgroundTransparency = 1
    BrandSub.Text = "Secure Gateway & Verification"
    BrandSub.TextColor3 = Color3.fromRGB(110, 120, 140)
    BrandSub.Font = Enum.Font.Gotham
    BrandSub.TextSize = 10
    BrandSub.TextXAlignment = Enum.TextXAlignment.Left
    BrandSub.ZIndex = 8
    BrandSub.Parent = HeaderBar

    -- Close & Minimize Buttons
    local WindowControls = Instance.new("Frame")
    WindowControls.Size = UDim2.new(0, 64, 0, 28)
    WindowControls.Position = UDim2.new(1, -84, 0, 12)
    WindowControls.BackgroundTransparency = 1
    WindowControls.ZIndex = 9
    WindowControls.Parent = HeaderBar

    local MinBtn = Instance.new("TextButton")
    MinBtn.Size = UDim2.new(0, 28, 0, 28)
    MinBtn.Position = UDim2.new(0, 0, 0, 0)
    MinBtn.BackgroundColor3 = Color3.fromRGB(20, 24, 32)
    MinBtn.Text = "—"
    MinBtn.TextColor3 = Color3.fromRGB(140, 150, 170)
    MinBtn.Font = Enum.Font.GothamBold
    MinBtn.TextSize = 11
    MinBtn.ZIndex = 10
    MinBtn.Parent = WindowControls

    local MinCorner = Instance.new("UICorner")
    MinCorner.CornerRadius = UDim.new(0, 8)
    MinCorner.Parent = MinBtn

    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Size = UDim2.new(0, 28, 0, 28)
    CloseBtn.Position = UDim2.new(1, -28, 0, 0)
    CloseBtn.BackgroundColor3 = Color3.fromRGB(28, 20, 24)
    CloseBtn.Text = "✕"
    CloseBtn.TextColor3 = Color3.fromRGB(244, 63, 94)
    CloseBtn.Font = Enum.Font.GothamBold
    CloseBtn.TextSize = 12
    CloseBtn.ZIndex = 10
    CloseBtn.Parent = WindowControls

    local CloseCorner = Instance.new("UICorner")
    CloseCorner.CornerRadius = UDim.new(0, 8)
    CloseCorner.Parent = CloseBtn

    -- Active Service Card
    local ServiceCard = Instance.new("Frame")
    ServiceCard.Name = "ServiceCard"
    ServiceCard.Size = UDim2.new(1, -44, 0, 46)
    ServiceCard.Position = UDim2.new(0, 22, 0, 56)
    ServiceCard.BackgroundColor3 = Color3.fromRGB(15, 18, 26)
    ServiceCard.BorderSizePixel = 0
    ServiceCard.ZIndex = 7
    ServiceCard.Parent = RightPanel

    local ServiceCorner = Instance.new("UICorner")
    ServiceCorner.CornerRadius = UDim.new(0, 10)
    ServiceCorner.Parent = ServiceCard

    local ServiceStroke = Instance.new("UIStroke")
    ServiceStroke.Color = Color3.fromRGB(30, 38, 54)
    ServiceStroke.Thickness = 1
    ServiceStroke.Parent = ServiceCard

    local ServiceIcon = Instance.new("TextLabel")
    ServiceIcon.Size = UDim2.new(0, 36, 1, 0)
    ServiceIcon.Position = UDim2.new(0, 6, 0, 0)
    ServiceIcon.BackgroundTransparency = 1
    ServiceIcon.Text = "⚡"
    ServiceIcon.TextSize = 18
    ServiceIcon.ZIndex = 8
    ServiceIcon.Parent = ServiceCard

    local ServiceTitle = Instance.new("TextLabel")
    ServiceTitle.Size = UDim2.new(1, -160, 0, 16)
    ServiceTitle.Position = UDim2.new(0, 44, 0, 8)
    ServiceTitle.BackgroundTransparency = 1
    ServiceTitle.Text = "Active Service: Sairo Hub Official"
    ServiceTitle.TextColor3 = Color3.fromRGB(235, 240, 255)
    ServiceTitle.Font = Enum.Font.GothamBold
    ServiceTitle.TextSize = 11
    ServiceTitle.TextXAlignment = Enum.TextXAlignment.Left
    ServiceTitle.ZIndex = 8
    ServiceTitle.Parent = ServiceCard

    local ServiceSub = Instance.new("TextLabel")
    ServiceSub.Size = UDim2.new(1, -160, 0, 14)
    ServiceSub.Position = UDim2.new(0, 44, 0, 24)
    ServiceSub.BackgroundTransparency = 1
    ServiceSub.Text = "Verified client delivery • 24hr HWID Lock"
    ServiceSub.TextColor3 = Color3.fromRGB(120, 130, 150)
    ServiceSub.Font = Enum.Font.Gotham
    ServiceSub.TextSize = 10
    ServiceSub.TextXAlignment = Enum.TextXAlignment.Left
    ServiceSub.ZIndex = 8
    ServiceSub.Parent = ServiceCard

    local VerifiedPill = Instance.new("Frame")
    VerifiedPill.Size = UDim2.new(0, 116, 0, 24)
    VerifiedPill.Position = UDim2.new(1, -126, 0.5, -12)
    VerifiedPill.BackgroundColor3 = Color3.fromRGB(12, 28, 22)
    VerifiedPill.BorderSizePixel = 0
    VerifiedPill.ZIndex = 8
    VerifiedPill.Parent = ServiceCard

    local VerifiedCorner = Instance.new("UICorner")
    VerifiedCorner.CornerRadius = UDim.new(0, 6)
    VerifiedCorner.Parent = VerifiedPill

    local VerifiedStroke = Instance.new("UIStroke")
    VerifiedStroke.Color = Color3.fromRGB(34, 197, 94)
    VerifiedStroke.Thickness = 1
    VerifiedStroke.Transparency = 0.6
    VerifiedStroke.Parent = VerifiedPill

    local VerifiedText = Instance.new("TextLabel")
    VerifiedText.Size = UDim2.new(1, 0, 1, 0)
    VerifiedText.BackgroundTransparency = 1
    VerifiedText.Text = "🛡️ SAIRO VERIFIED"
    VerifiedText.TextColor3 = Color3.fromRGB(34, 197, 94)
    VerifiedText.Font = Enum.Font.GothamBold
    VerifiedText.TextSize = 9
    VerifiedText.ZIndex = 9
    VerifiedText.Parent = VerifiedPill

    -- Secure Access Section Header
    local SecHeader = Instance.new("TextLabel")
    SecHeader.Size = UDim2.new(1, -44, 0, 16)
    SecHeader.Position = UDim2.new(0, 22, 0, 110)
    SecHeader.BackgroundTransparency = 1
    SecHeader.Text = "SECURE ACCESS"
    SecHeader.TextColor3 = Color3.fromRGB(14, 165, 233)
    SecHeader.Font = Enum.Font.GothamBold
    SecHeader.TextSize = 10
    SecHeader.TextXAlignment = Enum.TextXAlignment.Left
    SecHeader.ZIndex = 8
    SecHeader.Parent = RightPanel

    local SecDesc = Instance.new("TextLabel")
    SecDesc.Size = UDim2.new(1, -44, 0, 14)
    SecDesc.Position = UDim2.new(0, 22, 0, 126)
    SecDesc.BackgroundTransparency = 1
    SecDesc.Text = "Enter your Sairo license key to launch the supported script"
    SecDesc.TextColor3 = Color3.fromRGB(120, 130, 150)
    SecDesc.Font = Enum.Font.Gotham
    SecDesc.TextSize = 10
    SecDesc.TextXAlignment = Enum.TextXAlignment.Left
    SecDesc.ZIndex = 8
    SecDesc.Parent = RightPanel

    -- =========================================================================
    -- 4. ROTATING DUAL-LIGHT BORDER INPUT BOX (Snowy Hub Feature)
    -- =========================================================================
    local KeyInputWrap = Instance.new("Frame")
    KeyInputWrap.Name = "KeyInputWrap"
    KeyInputWrap.Size = UDim2.new(1, -44, 0, 44)
    KeyInputWrap.Position = UDim2.new(0, 22, 0, 146)
    KeyInputWrap.BackgroundColor3 = Color3.fromRGB(13, 16, 23)
    KeyInputWrap.BorderSizePixel = 0
    KeyInputWrap.ZIndex = 8
    KeyInputWrap.Parent = RightPanel

    local KeyInputCorner = Instance.new("UICorner")
    KeyInputCorner.CornerRadius = UDim.new(0, 10)
    KeyInputCorner.Parent = KeyInputWrap

    -- Rotating dual-light beam stroke
    local KeyInputStroke = Instance.new("UIStroke")
    KeyInputStroke.Thickness = 1.6
    KeyInputStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    KeyInputStroke.Color = Color3.fromRGB(255, 255, 255)
    KeyInputStroke.Parent = KeyInputWrap

    local DualLightGrad = Instance.new("UIGradient")
    DualLightGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 40, 60)),
        ColorSequenceKeypoint.new(0.25, Color3.fromRGB(14, 165, 233)), -- Light 1 (Cyan)
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(30, 40, 60)),
        ColorSequenceKeypoint.new(0.75, Color3.fromRGB(249, 115, 22)), -- Light 2 (Sairo Orange)
        ColorSequenceKeypoint.new(1, Color3.fromRGB(30, 40, 60))
    })
    DualLightGrad.Rotation = 0
    DualLightGrad.Parent = KeyInputStroke

    -- Light rotation loop
    local rotConn
    rotConn = RunService.RenderStepped:Connect(function(dt)
        if not ScreenGui.Parent then
            rotConn:Disconnect()
            return
        end
        DualLightGrad.Rotation = (DualLightGrad.Rotation + (120 * dt)) % 360
    end)

    local KeyIcon = Instance.new("TextLabel")
    KeyIcon.Size = UDim2.new(0, 36, 1, 0)
    KeyIcon.Position = UDim2.new(0, 6, 0, 0)
    KeyIcon.BackgroundTransparency = 1
    KeyIcon.Text = "🔑"
    KeyIcon.TextSize = 14
    KeyIcon.ZIndex = 9
    KeyIcon.Parent = KeyInputWrap

    local KeyBox = Instance.new("TextBox")
    KeyBox.Size = UDim2.new(1, -44, 1, 0)
    KeyBox.Position = UDim2.new(0, 38, 0, 0)
    KeyBox.BackgroundTransparency = 1
    KeyBox.Text = ""
    KeyBox.PlaceholderText = "Waiting for key..."
    KeyBox.PlaceholderColor3 = Color3.fromRGB(90, 100, 120)
    KeyBox.TextColor3 = Color3.fromRGB(245, 248, 255)
    KeyBox.Font = Enum.Font.Code
    KeyBox.TextSize = 12
    KeyBox.TextXAlignment = Enum.TextXAlignment.Left
    KeyBox.ClearTextOnFocus = false
    KeyBox.ZIndex = 9
    KeyBox.Parent = KeyInputWrap

    -- Action Buttons Row: [ Get Key ] and [ Redeem ]
    local ActionRow = Instance.new("Frame")
    ActionRow.Size = UDim2.new(1, -44, 0, 40)
    ActionRow.Position = UDim2.new(0, 22, 0, 198)
    ActionRow.BackgroundTransparency = 1
    ActionRow.ZIndex = 8
    ActionRow.Parent = RightPanel

    local GetKeyBtn = Instance.new("TextButton")
    GetKeyBtn.Name = "GetKeyBtn"
    GetKeyBtn.Size = UDim2.new(0.5, -6, 1, 0)
    GetKeyBtn.Position = UDim2.new(0, 0, 0, 0)
    GetKeyBtn.BackgroundColor3 = Color3.fromRGB(14, 165, 233)
    GetKeyBtn.Text = "🔑  Get Key"
    GetKeyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    GetKeyBtn.Font = Enum.Font.GothamBold
    GetKeyBtn.TextSize = 12
    GetKeyBtn.ZIndex = 9
    GetKeyBtn.Parent = ActionRow

    local GetKeyCorner = Instance.new("UICorner")
    GetKeyCorner.CornerRadius = UDim.new(0, 10)
    GetKeyCorner.Parent = GetKeyBtn

    local GetKeyGrad = Instance.new("UIGradient")
    GetKeyGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(14, 165, 233)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(2, 132, 199))
    })
    GetKeyGrad.Parent = GetKeyBtn

    local VerifyBtn = Instance.new("TextButton")
    VerifyBtn.Name = "VerifyBtn"
    VerifyBtn.Size = UDim2.new(0.5, -6, 1, 0)
    VerifyBtn.Position = UDim2.new(0.5, 6, 0, 0)
    VerifyBtn.BackgroundColor3 = Color3.fromRGB(20, 25, 36)
    VerifyBtn.Text = "🛡️  Redeem"
    VerifyBtn.TextColor3 = Color3.fromRGB(240, 245, 255)
    VerifyBtn.Font = Enum.Font.GothamBold
    VerifyBtn.TextSize = 12
    VerifyBtn.ZIndex = 9
    VerifyBtn.Parent = ActionRow

    local VerifyCorner = Instance.new("UICorner")
    VerifyCorner.CornerRadius = UDim.new(0, 10)
    VerifyCorner.Parent = VerifyBtn

    local VerifyStroke = Instance.new("UIStroke")
    VerifyStroke.Color = Color3.fromRGB(38, 48, 68)
    VerifyStroke.Thickness = 1.2
    VerifyStroke.Parent = VerifyBtn

    -- Utility Buttons Row: [ Discord ] [ Copy HWID ] [ Settings ]
    local UtilRow = Instance.new("Frame")
    UtilRow.Size = UDim2.new(1, -44, 0, 32)
    UtilRow.Position = UDim2.new(0, 22, 0, 246)
    UtilRow.BackgroundTransparency = 1
    UtilRow.ZIndex = 8
    UtilRow.Parent = RightPanel

    local UtilLayout = Instance.new("UIListLayout")
    UtilLayout.FillDirection = Enum.FillDirection.Horizontal
    UtilLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UtilLayout.Padding = UDim.new(0, 8)
    UtilLayout.Parent = UtilRow

    local function createUtilBtn(text, order)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0.333, -6, 1, 0)
        btn.BackgroundColor3 = Color3.fromRGB(18, 22, 31)
        btn.Text = text
        btn.TextColor3 = Color3.fromRGB(180, 190, 210)
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 10
        btn.LayoutOrder = order
        btn.ZIndex = 9
        btn.Parent = UtilRow

        local c = Instance.new("UICorner")
        c.CornerRadius = UDim.new(0, 8)
        c.Parent = btn

        local s = Instance.new("UIStroke")
        s.Color = Color3.fromRGB(30, 38, 52)
        s.Thickness = 1
        s.Parent = btn

        btn.MouseEnter:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(26, 32, 45)}):Play()
            TweenService:Create(s, TweenInfo.new(0.2), {Color = Color3.fromRGB(14, 165, 233)}):Play()
        end)
        btn.MouseLeave:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(18, 22, 31)}):Play()
            TweenService:Create(s, TweenInfo.new(0.2), {Color = Color3.fromRGB(30, 38, 52)}):Play()
        end)

        return btn
    end

    local DiscordBtn = createUtilBtn("💬 Discord", 1)
    local CopyHwidBtn = createUtilBtn("📋 Copy HWID", 2)
    local SettingsBtn = createUtilBtn("⚙️ Support", 3)

    -- Status Notification Line
    local StatusLine = Instance.new("Frame")
    StatusLine.Size = UDim2.new(1, -44, 0, 24)
    StatusLine.Position = UDim2.new(0, 22, 0, 286)
    StatusLine.BackgroundTransparency = 1
    StatusLine.ZIndex = 8
    StatusLine.Parent = RightPanel

    local StatusAccent = Instance.new("Frame")
    StatusAccent.Size = UDim2.new(0, 3, 1, 0)
    StatusAccent.BackgroundColor3 = Color3.fromRGB(14, 165, 233)
    StatusAccent.BorderSizePixel = 0
    StatusAccent.ZIndex = 8
    StatusAccent.Parent = StatusLine

    local StatusAccentCorner = Instance.new("UICorner")
    StatusAccentCorner.CornerRadius = UDim.new(0, 2)
    StatusAccentCorner.Parent = StatusAccent

    local StatusLabel = Instance.new("TextLabel")
    StatusLabel.Size = UDim2.new(1, -12, 1, 0)
    StatusLabel.Position = UDim2.new(0, 10, 0, 0)
    StatusLabel.BackgroundTransparency = 1
    StatusLabel.Text = "ℹ️ Ready for " .. gameTitle
    StatusLabel.TextColor3 = Color3.fromRGB(180, 210, 240)
    StatusLabel.Font = Enum.Font.Gotham
    StatusLabel.TextSize = 10
    StatusLabel.TextXAlignment = Enum.TextXAlignment.Left
    StatusLabel.TextTruncate = Enum.TextTruncate.AtEnd
    StatusLabel.ZIndex = 8
    StatusLabel.Parent = StatusLine

    -- =========================================================================
    -- 5. BOTTOM PREMIUM ACCESS CARD (Snowy Hub Style)
    -- =========================================================================
    local PremiumCard = Instance.new("Frame")
    PremiumCard.Name = "PremiumCard"
    PremiumCard.Size = UDim2.new(1, -44, 0, 84)
    PremiumCard.Position = UDim2.new(0, 22, 1, -96)
    PremiumCard.BackgroundColor3 = Color3.fromRGB(14, 16, 23)
    PremiumCard.BorderSizePixel = 0
    PremiumCard.ZIndex = 7
    PremiumCard.Parent = RightPanel

    local PremiumCorner = Instance.new("UICorner")
    PremiumCorner.CornerRadius = UDim.new(0, 12)
    PremiumCorner.Parent = PremiumCard

    local PremiumStroke = Instance.new("UIStroke")
    PremiumStroke.Color = Color3.fromRGB(30, 36, 50)
    PremiumStroke.Thickness = 1
    PremiumStroke.Parent = PremiumCard

    local SairoPlusBadge = Instance.new("TextLabel")
    SairoPlusBadge.Size = UDim2.new(0, 68, 0, 16)
    SairoPlusBadge.Position = UDim2.new(0, 14, 0, 10)
    SairoPlusBadge.BackgroundColor3 = Color3.fromRGB(40, 26, 15)
    SairoPlusBadge.Text = "SAIRO+"
    SairoPlusBadge.TextColor3 = Color3.fromRGB(249, 115, 22)
    SairoPlusBadge.Font = Enum.Font.GothamBold
    SairoPlusBadge.TextSize = 9
    SairoPlusBadge.ZIndex = 8
    SairoPlusBadge.Parent = PremiumCard

    local PlusCorner = Instance.new("UICorner")
    PlusCorner.CornerRadius = UDim.new(0, 4)
    PlusCorner.Parent = SairoPlusBadge

    local PremTitle = Instance.new("TextLabel")
    PremTitle.Size = UDim2.new(1, -160, 0, 18)
    PremTitle.Position = UDim2.new(0, 14, 0, 30)
    PremTitle.BackgroundTransparency = 1
    PremTitle.Text = "Premium Access"
    PremTitle.TextColor3 = Color3.fromRGB(245, 248, 255)
    PremTitle.Font = Enum.Font.GothamBold
    PremTitle.TextSize = 13
    PremTitle.TextXAlignment = Enum.TextXAlignment.Left
    PremTitle.ZIndex = 8
    PremTitle.Parent = PremiumCard

    local PremDesc = Instance.new("TextLabel")
    PremDesc.Size = UDim2.new(1, -160, 0, 26)
    PremDesc.Position = UDim2.new(0, 14, 0, 48)
    PremDesc.BackgroundTransparency = 1
    PremDesc.Text = "Unlock extra perks, bypass cooldowns & priority support\nsairo.online/pricing"
    PremDesc.TextColor3 = Color3.fromRGB(120, 130, 150)
    PremDesc.Font = Enum.Font.Gotham
    PremDesc.TextSize = 9
    PremDesc.TextXAlignment = Enum.TextXAlignment.Left
    PremDesc.ZIndex = 8
    PremDesc.Parent = PremiumCard

    local ViewPlansBtn = Instance.new("TextButton")
    ViewPlansBtn.Size = UDim2.new(0, 110, 0, 36)
    ViewPlansBtn.Position = UDim2.new(1, -124, 0.5, -18)
    ViewPlansBtn.BackgroundColor3 = Color3.fromRGB(147, 51, 234)
    ViewPlansBtn.Text = "⚡ View Plans"
    ViewPlansBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    ViewPlansBtn.Font = Enum.Font.GothamBold
    ViewPlansBtn.TextSize = 11
    ViewPlansBtn.ZIndex = 9
    ViewPlansBtn.Parent = PremiumCard

    local ViewPlansCorner = Instance.new("UICorner")
    ViewPlansCorner.CornerRadius = UDim.new(0, 8)
    ViewPlansCorner.Parent = ViewPlansBtn

    local ViewPlansGrad = Instance.new("UIGradient")
    ViewPlansGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(168, 85, 247)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(126, 34, 206))
    })
    ViewPlansGrad.Parent = ViewPlansBtn

    ViewPlansBtn.MouseButton1Click:Connect(function()
        if setclipboard then
            setclipboard("https://sairo.online/pricing")
            StatusLabel.Text = "Copied pricing link to clipboard!"
            StatusAccent.BackgroundColor3 = Color3.fromRGB(168, 85, 247)
        end
    end)

    -- =========================================================================
    -- 6. RESPONSIVE MOBILE / PC ADAPTATION (Snowy Hub Style)
    -- =========================================================================
    local isMobileMode = false
    local function adaptLayout()
        local vp = Camera.ViewportSize
        local mobile = (vp.X < 640 or vp.Y < 480 or (UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled))
        if mobile ~= isMobileMode then
            isMobileMode = mobile
            if isMobileMode then
                -- MOBILE COMPACT VIEW: Hide left sidebar, hide bottom promo, full width right panel
                TweenService:Create(Sidebar, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    Position = UDim2.new(0, -230, 0, 0)
                }):Play()
                TweenService:Create(RightPanel, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    Size = UDim2.new(1, 0, 1, 0),
                    Position = UDim2.new(0, 0, 0, 0)
                }):Play()
                PremiumCard.Visible = false
                MainFrame.Size = UDim2.new(0, math.min(vp.X - 32, 420), 0, 340)
            else
                -- DESKTOP VIEW: Restore full dual-column layout
                Sidebar.Visible = true
                TweenService:Create(Sidebar, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    Position = UDim2.new(0, 0, 0, 0)
                }):Play()
                TweenService:Create(RightPanel, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    Size = UDim2.new(1, -225, 1, 0),
                    Position = UDim2.new(0, 225, 0, 0)
                }):Play()
                PremiumCard.Visible = true
                MainFrame.Size = UDim2.new(0, 690, 0, 420)
            end
        end
    end

    Camera:GetPropertyChangedSignal("ViewportSize"):Connect(adaptLayout)
    adaptLayout()

    -- =========================================================================
    -- 7. DRAGGABLE WINDOW LOGIC
    -- =========================================================================
    local isDragging = false
    local dragStart, startPos

    local function handleDragStart(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            isDragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
        end
    end

    HeaderBar.InputBegan:Connect(handleDragStart)
    Sidebar.InputBegan:Connect(handleDragStart)

    UserInputService.InputChanged:Connect(function(input)
        if isDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    local function handleDragEnd(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            isDragging = false
        end
    end

    UserInputService.InputEnded:Connect(handleDragEnd)

    -- =========================================================================
    -- 8. FLUID SPRING ENTRANCE & EXIT ANIMATIONS (120% Pop-in / 80% Exit)
    -- =========================================================================
    local isClosing = false
    local function closeWithAnimation(onComplete)
        if isClosing then return end
        isClosing = true

        -- Pop out: pops slightly (108%) then shrinks to 80% while fading out
        TweenService:Create(Backdrop, TweenInfo.new(0.25), {BackgroundTransparency = 1}):Play()
        local tPop = TweenService:Create(MainFrame, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = UDim2.new(MainFrame.Size.X.Scale, MainFrame.Size.X.Offset * 1.06, MainFrame.Size.Y.Scale, MainFrame.Size.Y.Offset * 1.06)
        })
        tPop:Play()
        tPop.Completed:Connect(function()
            local tExit = TweenService:Create(MainFrame, TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
                Size = UDim2.new(MainFrame.Size.X.Scale, MainFrame.Size.X.Offset * 0.75, MainFrame.Size.Y.Scale, MainFrame.Size.Y.Offset * 0.75),
                BackgroundTransparency = 1
            })
            tExit:Play()
            tExit.Completed:Connect(function()
                ScreenGui:Destroy()
                if onComplete then onComplete() end
            end)
        end)
    end

    CloseBtn.MouseButton1Click:Connect(function()
        closeWithAnimation()
    end)

    local isMinimized = false
    MinBtn.MouseButton1Click:Connect(function()
        isMinimized = not isMinimized
        if isMinimized then
            TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
                Size = UDim2.new(0, 300, 0, 52)
            }):Play()
        else
            adaptLayout()
        end
    end)

    -- Entrance animation: Starts small (0.8x), pops to 1.1x, then settles to 1.0
    local targetSize = MainFrame.Size
    MainFrame.Size = UDim2.new(targetSize.X.Scale, targetSize.X.Offset * 0.8, targetSize.Y.Scale, targetSize.Y.Offset * 0.8)
    MainFrame.BackgroundTransparency = 0.5
    Backdrop.BackgroundTransparency = 1

    TweenService:Create(Backdrop, TweenInfo.new(0.3), {BackgroundTransparency = 0.6}):Play()
    local tEnter = TweenService:Create(MainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = targetSize,
        BackgroundTransparency = 0
    })
    tEnter:Play()

    -- =========================================================================
    -- 9. UTILITY BUTTON ACTIONS
    -- =========================================================================
    DiscordBtn.MouseButton1Click:Connect(function()
        if setclipboard then
            setclipboard("https://discord.gg/RQ2SSPuEmT")
            StatusLabel.Text = "Copied Discord invite to clipboard!"
            StatusAccent.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
        end
    end)

    CopyHwidBtn.MouseButton1Click:Connect(function()
        if setclipboard then
            setclipboard(HWID)
            StatusLabel.Text = "Copied HWID: " .. string.sub(HWID, 1, 16) .. "..."
            StatusAccent.BackgroundColor3 = Color3.fromRGB(34, 197, 94)
        end
    end)

    SettingsBtn.MouseButton1Click:Connect(function()
        pcall(function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/wendigo5414-cmyk/FireballxArena/refs/heads/main/feedbacksystem"))()
        end)
    end)

    -- =========================================================================
    -- 10. API & VERIFICATION FLOW
    -- =========================================================================
    local function setStatus(text, color)
        StatusLabel.Text = text
        StatusAccent.BackgroundColor3 = color or Color3.fromRGB(14, 165, 233)
    end

    local function getKey()
        setStatus("Generating Key link...", Color3.fromRGB(14, 165, 233))
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
                setStatus("Key URL copied to clipboard! Open in browser.", Color3.fromRGB(34, 197, 94))
            else
                setStatus("Server error generating link.", Color3.fromRGB(244, 63, 94))
            end
        else
            setStatus("Connection failed to Sairo API.", Color3.fromRGB(244, 63, 94))
        end
    end

    local function onVerify()
        local inputKey = KeyBox.Text:gsub("%s+", "")
        if inputKey == "" then
            setStatus("Please enter a valid key.", Color3.fromRGB(245, 158, 11))
            return
        end

        VerifyBtn.Text = "Checking..."
        setStatus("Authenticating with Sairo gateway...", Color3.fromRGB(14, 165, 233))

        local robloxName = LocalPlayer.Name
        local url = API_URL .. "/api/verify-key?key=" .. inputKey .. "&hwid=" .. HWID .. "&robloxName=" .. robloxName

        local success, response = pcall(function() return game:HttpGet(url) end)

        if success then
            local sDecode, data = pcall(function() return HttpService:JSONDecode(response) end)
            if sDecode and data and data.status == "valid" then
                setStatus("Access Granted! Launching script...", Color3.fromRGB(34, 197, 94))
                if writefile then
                    pcall(function() writefile("SairoAuth.txt", inputKey) end)
                end

                task.wait(0.6)
                closeWithAnimation(function()
                    isVerified = true
                end)
                return
            elseif data and data.status == "invalid_hwid" then
                setStatus("HWID mismatch! Key used on another device.", Color3.fromRGB(244, 63, 94))
            else
                setStatus("Key is invalid or expired. Please generate a new key.", Color3.fromRGB(244, 63, 94))
            end
        else
            setStatus("Failed to reach Sairo verification server.", Color3.fromRGB(244, 63, 94))
        end
        VerifyBtn.Text = "🛡️  Redeem"
    end

    GetKeyBtn.MouseButton1Click:Connect(getKey)
    VerifyBtn.MouseButton1Click:Connect(onVerify)

    -- Auto login if saved key exists
    if readfile and pcall(function() return readfile("SairoAuth.txt") end) then
        local saved = readfile("SairoAuth.txt"):gsub("%s+", "")
        if saved ~= "" then
            KeyBox.Text = saved
            task.delay(0.4, onVerify)
        end
    end

    repeat task.wait(0.2) until isVerified
end

return SairoLibrary
