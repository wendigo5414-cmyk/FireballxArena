--[[ 
    SAIRO HUB - KEY SYSTEM
    Ultra-Premium UI Design
]]

local SairoLibrary = {}

-- You can change this text to display the latest updates inside the Key System.
local ANNOUNCEMENT = "Sairo services are fully operational."

function SairoLibrary.Init()
    local isVerified = false

    local KeySystem = Instance.new("ScreenGui")
    KeySystem.Name = "SairoKeySystem"
    KeySystem.Parent = game.CoreGui
    KeySystem.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    KeySystem.IgnoreGuiInset = true

    local TweenService = game:GetService("TweenService")
    local HttpService = game:GetService("HttpService")
    local UserInputService = game:GetService("UserInputService")
    local coreGui = game:GetService("CoreGui")
    local HWID = game:GetService("RbxAnalyticsService"):GetClientId()

    local API_URL = "https://sairo.online" 
    
    local DEV_ID = _G.DevID or "admin" 

    -- THEME: OBSIDIAN & NEON EMERALD (Sairo Theme)
    local COLOR_ACCENT = Color3.fromRGB(48, 255, 106)
    local COLOR_ACCENT_HOVER = Color3.fromRGB(38, 215, 88)
    local COLOR_BG = Color3.fromRGB(14, 14, 16) 
    local COLOR_SIDE = Color3.fromRGB(10, 10, 12) 
    local COLOR_STROKE = Color3.fromRGB(32, 32, 36) 
    local COLOR_TEXT = Color3.fromRGB(245, 245, 245)
    local COLOR_TEXT_DIM = Color3.fromRGB(140, 140, 150)

    -- --- HELPER FUNCTIONS ---
    local function applyCorner(obj, radius)
        local uic = Instance.new("UICorner")
        uic.CornerRadius = UDim.new(0, radius)
        uic.Parent = obj
    end

    local function applyStroke(obj, color, thickness)
        local stroke = Instance.new("UIStroke")
        stroke.Color = color
        stroke.Thickness = thickness
        stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        stroke.Parent = obj
        return stroke
    end

    local function createGradient(obj, c1, c2)
        local grad = Instance.new("UIGradient")
        grad.Color = ColorSequence.new{
            ColorSequenceKeypoint.new(0, c1),
            ColorSequenceKeypoint.new(1, c2)
        }
        grad.Rotation = 45
        grad.Parent = obj
    end

    local function animateButton(btn, noScale)
        btn.AutoButtonColor = false
        local originalSize = btn.Size
        
        btn.MouseEnter:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.3, Enum.EasingStyle.Sine), {BackgroundColor3 = COLOR_ACCENT_HOVER}):Play()
            if btn:FindFirstChild("UIStroke") then
                TweenService:Create(btn.UIStroke, TweenInfo.new(0.3), {Color = COLOR_ACCENT}):Play()
            end
        end)
        btn.MouseLeave:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.3, Enum.EasingStyle.Sine), {BackgroundColor3 = COLOR_ACCENT}):Play()
            if btn:FindFirstChild("UIStroke") then
                TweenService:Create(btn.UIStroke, TweenInfo.new(0.3), {Color = COLOR_STROKE}):Play()
            end
        end)
        if not noScale then
            btn.MouseButton1Down:Connect(function()
                local targetSize = UDim2.new(
                    originalSize.X.Scale * 0.96, 
                    originalSize.X.Offset * 0.96, 
                    originalSize.Y.Scale * 0.96, 
                    originalSize.Y.Offset * 0.96
                )
                TweenService:Create(btn, TweenInfo.new(0.1, Enum.EasingStyle.Quad), {Size = targetSize}):Play()
            end)
            btn.MouseButton1Up:Connect(function()
                TweenService:Create(btn, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = originalSize}):Play()
            end)
        end
    end

    local function animateGhostButton(btn)
        btn.AutoButtonColor = false
        local defaultColor = btn.BackgroundColor3
        local defaultStroke = btn.UIStroke.Color
        local originalSize = btn.Size
        
        btn.MouseEnter:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(30, 30, 34)}):Play()
            TweenService:Create(btn.UIStroke, TweenInfo.new(0.3), {Color = Color3.fromRGB(70, 70, 80)}):Play()
        end)
        btn.MouseLeave:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.3), {BackgroundColor3 = defaultColor}):Play()
            TweenService:Create(btn.UIStroke, TweenInfo.new(0.3), {Color = defaultStroke}):Play()
        end)
        btn.MouseButton1Down:Connect(function()
            local targetSize = UDim2.new(
                originalSize.X.Scale * 0.96, 
                originalSize.X.Offset * 0.96, 
                originalSize.Y.Scale * 0.96, 
                originalSize.Y.Offset * 0.96
            )
            TweenService:Create(btn, TweenInfo.new(0.1), {Size = targetSize}):Play()
        end)
        btn.MouseButton1Up:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = originalSize}):Play()
        end)
    end

    -- --- CORE UI ELEMENTS ---
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "Main"
    MainFrame.Parent = KeySystem
    MainFrame.BackgroundColor3 = COLOR_BG
    MainFrame.Position = UDim2.new(0.5, -275, 0.5, -165)
    MainFrame.Size = UDim2.new(0, 550, 0, 330)
    MainFrame.BorderSizePixel = 0
    MainFrame.ClipsDescendants = true
    applyCorner(MainFrame, 12)
    applyStroke(MainFrame, COLOR_STROKE, 1)

    local Sidebar = Instance.new("Frame")
    Sidebar.Name = "Sidebar"
    Sidebar.Parent = MainFrame
    Sidebar.BackgroundColor3 = COLOR_SIDE
    Sidebar.Size = UDim2.new(0, 160, 1, 0)
    Sidebar.BorderSizePixel = 0
    Sidebar.ZIndex = 2
    applyCorner(Sidebar, 12)

    local SidebarPatch = Instance.new("Frame")
    SidebarPatch.Parent = Sidebar
    SidebarPatch.BackgroundColor3 = COLOR_SIDE
    SidebarPatch.Position = UDim2.new(1, -12, 0, 0)
    SidebarPatch.Size = UDim2.new(0, 12, 1, 0)
    SidebarPatch.BorderSizePixel = 0
    SidebarPatch.ZIndex = 1
    
    local SidebarLine = Instance.new("Frame")
    SidebarLine.Parent = Sidebar
    SidebarLine.BackgroundColor3 = COLOR_STROKE
    SidebarLine.Position = UDim2.new(1, -1, 0, 0)
    SidebarLine.Size = UDim2.new(0, 1, 1, 0)
    SidebarLine.BorderSizePixel = 0
    SidebarLine.ZIndex = 3

    -- Title Section
    local TitleArea = Instance.new("Frame")
    TitleArea.Parent = Sidebar
    TitleArea.BackgroundTransparency = 1
    TitleArea.Size = UDim2.new(1, 0, 0, 80)
    
    local Title = Instance.new("TextLabel")
    Title.Parent = TitleArea
    Title.BackgroundTransparency = 1
    Title.Position = UDim2.new(0, 20, 0, 25)
    Title.Size = UDim2.new(1, -40, 0, 24)
    Title.Font = Enum.Font.GothamBlack
    Title.Text = "SAIRO"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 24
    Title.TextXAlignment = Enum.TextXAlignment.Left
    createGradient(Title, Color3.fromRGB(255, 255, 255), COLOR_ACCENT)

    local SubTitle = Instance.new("TextLabel")
    SubTitle.Parent = TitleArea
    SubTitle.BackgroundTransparency = 1
    SubTitle.Position = UDim2.new(0, 20, 0, 48)
    SubTitle.Size = UDim2.new(1, -40, 0, 14)
    SubTitle.Font = Enum.Font.GothamBold
    SubTitle.Text = "KEY SYSTEM"
    SubTitle.TextColor3 = COLOR_TEXT_DIM
    SubTitle.TextSize = 10
    SubTitle.TextXAlignment = Enum.TextXAlignment.Left

    -- Tabs Container
    local TabsContainer = Instance.new("Frame")
    TabsContainer.Parent = Sidebar
    TabsContainer.BackgroundTransparency = 1
    TabsContainer.Position = UDim2.new(0, 0, 0, 90)
    TabsContainer.Size = UDim2.new(1, 0, 1, -90)

    local UIList_Tabs = Instance.new("UIListLayout")
    UIList_Tabs.Parent = TabsContainer
    UIList_Tabs.SortOrder = Enum.SortOrder.LayoutOrder
    UIList_Tabs.Padding = UDim.new(0, 8)
    UIList_Tabs.HorizontalAlignment = Enum.HorizontalAlignment.Center

    local ContentArea = Instance.new("Frame")
    ContentArea.Name = "Content"
    ContentArea.Parent = MainFrame
    ContentArea.BackgroundTransparency = 1
    ContentArea.Position = UDim2.new(0, 160, 0, 0)
    ContentArea.Size = UDim2.new(1, -160, 1, 0)

    -- Glow Background
    local RadialGlow = Instance.new("ImageLabel")
    RadialGlow.Parent = ContentArea
    RadialGlow.BackgroundTransparency = 1
    RadialGlow.Position = UDim2.new(0, -100, 0, -100)
    RadialGlow.Size = UDim2.new(1, 200, 1, 200)
    RadialGlow.Image = "rbxassetid://5028857472"
    RadialGlow.ImageColor3 = COLOR_ACCENT
    RadialGlow.ImageTransparency = 0.92
    RadialGlow.ZIndex = 0

    local pages = {}
    local tabButtons = {}
    
    local function createTab(name, iconId)
        local btn = Instance.new("TextButton")
        btn.Parent = TabsContainer
        btn.BackgroundColor3 = Color3.fromRGB(24, 24, 28)
        btn.BackgroundTransparency = 1
        btn.Size = UDim2.new(1, -30, 0, 40)
        btn.Font = Enum.Font.GothamBold
        btn.Text = ""
        btn.AutoButtonColor = false
        applyCorner(btn, 8)

        local icon = Instance.new("ImageLabel")
        icon.Parent = btn
        icon.BackgroundTransparency = 1
        icon.Position = UDim2.new(0, 12, 0.5, -9)
        icon.Size = UDim2.new(0, 18, 0, 18)
        icon.Image = "rbxassetid://" .. iconId
        icon.ImageColor3 = COLOR_TEXT_DIM

        local txt = Instance.new("TextLabel")
        txt.Parent = btn
        txt.BackgroundTransparency = 1
        txt.Position = UDim2.new(0, 40, 0, 0)
        txt.Size = UDim2.new(1, -40, 1, 0)
        txt.Font = Enum.Font.GothamBold
        txt.Text = name
        txt.TextColor3 = COLOR_TEXT_DIM
        txt.TextSize = 13
        txt.TextXAlignment = Enum.TextXAlignment.Left

        local indicator = Instance.new("Frame")
        indicator.Parent = btn
        indicator.BackgroundColor3 = COLOR_ACCENT
        indicator.Position = UDim2.new(0, 0, 0.5, -8)
        indicator.Size = UDim2.new(0, 3, 0, 16)
        indicator.BackgroundTransparency = 1
        indicator.BorderSizePixel = 0
        applyCorner(indicator, 2)

        local page = Instance.new("Frame")
        page.Parent = ContentArea
        page.BackgroundTransparency = 1
        page.Size = UDim2.new(1, 0, 1, 0)
        page.Visible = false
        page.ZIndex = 2
        
        table.insert(pages, page)
        table.insert(tabButtons, {btn = btn, icon = icon, txt = txt, ind = indicator})

        btn.MouseEnter:Connect(function()
            if page.Visible then return end
            TweenService:Create(txt, TweenInfo.new(0.2), {TextColor3 = COLOR_TEXT}):Play()
            TweenService:Create(icon, TweenInfo.new(0.2), {ImageColor3 = COLOR_TEXT}):Play()
            TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundTransparency = 0.8}):Play()
        end)
        btn.MouseLeave:Connect(function()
            if page.Visible then return end
            TweenService:Create(txt, TweenInfo.new(0.2), {TextColor3 = COLOR_TEXT_DIM}):Play()
            TweenService:Create(icon, TweenInfo.new(0.2), {ImageColor3 = COLOR_TEXT_DIM}):Play()
            TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play()
        end)

        return page, btn
    end

    local function selectTab(targetPage)
        for i, p in ipairs(pages) do
            local tb = tabButtons[i]
            if p == targetPage then
                p.Visible = true
                TweenService:Create(tb.btn, TweenInfo.new(0.3), {BackgroundTransparency = 0.9}):Play()
                TweenService:Create(tb.txt, TweenInfo.new(0.3), {TextColor3 = COLOR_TEXT}):Play()
                TweenService:Create(tb.icon, TweenInfo.new(0.3), {ImageColor3 = COLOR_ACCENT}):Play()
                TweenService:Create(tb.ind, TweenInfo.new(0.3), {BackgroundTransparency = 0}):Play()
            else
                p.Visible = false
                TweenService:Create(tb.btn, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
                TweenService:Create(tb.txt, TweenInfo.new(0.3), {TextColor3 = COLOR_TEXT_DIM}):Play()
                TweenService:Create(tb.icon, TweenInfo.new(0.3), {ImageColor3 = COLOR_TEXT_DIM}):Play()
                TweenService:Create(tb.ind, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
            end
        end
    end

    local HomePage, TabHomeBtn = createTab("Authentication", "3944673814") 
    local InfoPage, TabInfoBtn = createTab("Information", "3926307971")

    TabHomeBtn.MouseButton1Click:Connect(function() selectTab(HomePage) end)
    TabInfoBtn.MouseButton1Click:Connect(function() selectTab(InfoPage) end)

    -- Window Close Button
    local CloseBtn = Instance.new("ImageButton")
    CloseBtn.Parent = MainFrame
    CloseBtn.BackgroundTransparency = 1
    CloseBtn.Position = UDim2.new(1, -36, 0, 12)
    CloseBtn.Size = UDim2.new(0, 24, 0, 24)
    CloseBtn.Image = "rbxassetid://3926305904"
    CloseBtn.ImageRectOffset = Vector2.new(284, 4)
    CloseBtn.ImageRectSize = Vector2.new(24, 24)
    CloseBtn.ImageColor3 = Color3.fromRGB(120, 120, 130)
    CloseBtn.ZIndex = 5
    
    CloseBtn.MouseEnter:Connect(function() TweenService:Create(CloseBtn, TweenInfo.new(0.2), {ImageColor3 = Color3.fromRGB(255, 80, 80)}):Play() end)
    CloseBtn.MouseLeave:Connect(function() TweenService:Create(CloseBtn, TweenInfo.new(0.2), {ImageColor3 = Color3.fromRGB(120, 120, 130)}):Play() end)
    CloseBtn.MouseButton1Click:Connect(function() 
        TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {Size = UDim2.new(0, 550, 0, 0), Position = MainFrame.Position + UDim2.new(0,0,0,165)}):Play()
        task.wait(0.3)
        KeySystem:Destroy()
    end)

    -- Notifications Core
    local NotifContainer = Instance.new("Frame")
    NotifContainer.Name = "Notifications"
    NotifContainer.Parent = KeySystem
    NotifContainer.Position = UDim2.new(1, -260, 1, -350)
    NotifContainer.Size = UDim2.new(0, 240, 0, 330)
    NotifContainer.BackgroundTransparency = 1

    local UIListLayout_Notif = Instance.new("UIListLayout")
    UIListLayout_Notif.Parent = NotifContainer
    UIListLayout_Notif.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout_Notif.VerticalAlignment = Enum.VerticalAlignment.Bottom
    UIListLayout_Notif.Padding = UDim.new(0, 10)

    local function Notify(title, text, duration, notifType)
        local tColor = COLOR_ACCENT
        if notifType == "error" then tColor = Color3.fromRGB(255, 80, 80)
        elseif notifType == "success" then tColor = Color3.fromRGB(80, 255, 100)
        elseif notifType == "warning" then tColor = Color3.fromRGB(255, 200, 80) end

        local frame = Instance.new("Frame")
        frame.Parent = NotifContainer
        frame.BackgroundColor3 = Color3.fromRGB(20, 20, 24)
        frame.BorderSizePixel = 0
        frame.Size = UDim2.new(1, 0, 0, 56)
        frame.BackgroundTransparency = 1 
        frame.ClipsDescendants = false
        applyCorner(frame, 6)
        local stroke = applyStroke(frame, COLOR_STROKE, 1)

        local accentLine = Instance.new("Frame")
        accentLine.Parent = frame
        accentLine.BackgroundColor3 = tColor
        accentLine.BorderSizePixel = 0
        accentLine.Size = UDim2.new(0, 3, 1, 0)
        accentLine.BackgroundTransparency = 1
        applyCorner(accentLine, 2)
        
        local txtTitle = Instance.new("TextLabel")
        txtTitle.Parent = frame
        txtTitle.BackgroundTransparency = 1
        txtTitle.Position = UDim2.new(0, 14, 0, 8)
        txtTitle.Size = UDim2.new(1, -24, 0, 18)
        txtTitle.Font = Enum.Font.GothamBold
        txtTitle.Text = title
        txtTitle.TextColor3 = tColor
        txtTitle.TextSize = 13
        txtTitle.TextXAlignment = Enum.TextXAlignment.Left
        txtTitle.TextTransparency = 1
        
        local txtDesc = Instance.new("TextLabel")
        txtDesc.Parent = frame
        txtDesc.BackgroundTransparency = 1
        txtDesc.Position = UDim2.new(0, 14, 0, 28)
        txtDesc.Size = UDim2.new(1, -24, 0, 18)
        txtDesc.Font = Enum.Font.Gotham
        txtDesc.Text = text
        txtDesc.TextColor3 = COLOR_TEXT_DIM
        txtDesc.TextSize = 11
        txtDesc.TextXAlignment = Enum.TextXAlignment.Left
        txtDesc.TextTransparency = 1

        frame.Position = UDim2.new(1, 40, 0, 0)
        TweenService:Create(frame, TweenInfo.new(0.4, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {Position = UDim2.new(0,0,0,0), BackgroundTransparency = 0}):Play()
        TweenService:Create(txtTitle, TweenInfo.new(0.4), {TextTransparency = 0}):Play()
        TweenService:Create(txtDesc, TweenInfo.new(0.4), {TextTransparency = 0}):Play()
        TweenService:Create(accentLine, TweenInfo.new(0.4), {BackgroundTransparency = 0}):Play()
        
        task.delay(duration or 3, function()
            TweenService:Create(frame, TweenInfo.new(0.4, Enum.EasingStyle.Exponential, Enum.EasingDirection.In), {Position = UDim2.new(1, 40, 0, 0), BackgroundTransparency = 1}):Play()
            TweenService:Create(txtTitle, TweenInfo.new(0.3), {TextTransparency = 1}):Play()
            TweenService:Create(txtDesc, TweenInfo.new(0.3), {TextTransparency = 1}):Play()
            TweenService:Create(accentLine, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
            TweenService:Create(stroke, TweenInfo.new(0.3), {Transparency = 1}):Play()
            wait(0.4)
            frame:Destroy()
        end)
    end

    -- --- HOME PAGE LAYOUT ---
    local WelcomeHeader = Instance.new("TextLabel")
    WelcomeHeader.Parent = HomePage
    WelcomeHeader.BackgroundTransparency = 1
    WelcomeHeader.Position = UDim2.new(0, 30, 0, 35)
    WelcomeHeader.Size = UDim2.new(1, -60, 0, 24)
    WelcomeHeader.Font = Enum.Font.GothamBlack
    WelcomeHeader.Text = "HELLO, USER"
    WelcomeHeader.TextColor3 = COLOR_TEXT
    WelcomeHeader.TextSize = 20
    WelcomeHeader.TextXAlignment = Enum.TextXAlignment.Left

    local WelcomeSub = Instance.new("TextLabel")
    WelcomeSub.Parent = HomePage
    WelcomeSub.BackgroundTransparency = 1
    WelcomeSub.Position = UDim2.new(0, 30, 0, 62)
    WelcomeSub.Size = UDim2.new(1, -60, 0, 16)
    WelcomeSub.Font = Enum.Font.Gotham
    WelcomeSub.Text = "Please authenticate via your License Key to continue."
    WelcomeSub.TextColor3 = COLOR_TEXT_DIM
    WelcomeSub.TextSize = 12
    WelcomeSub.TextXAlignment = Enum.TextXAlignment.Left

    local AnnouncementLbl = Instance.new("TextLabel")
    AnnouncementLbl.Parent = HomePage
    AnnouncementLbl.BackgroundTransparency = 1
    AnnouncementLbl.Position = UDim2.new(0, 30, 0, 82)
    AnnouncementLbl.Size = UDim2.new(1, -60, 0, 16)
    AnnouncementLbl.Font = Enum.Font.GothamBold
    AnnouncementLbl.Text = "[!] " .. ANNOUNCEMENT
    AnnouncementLbl.TextColor3 = Color3.fromRGB(240, 180, 70)
    AnnouncementLbl.TextSize = 11
    AnnouncementLbl.TextXAlignment = Enum.TextXAlignment.Left

    local KeyBox = Instance.new("TextBox")
    KeyBox.Parent = HomePage
    KeyBox.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
    KeyBox.Position = UDim2.new(0, 30, 0, 110)
    KeyBox.Size = UDim2.new(1, -60, 0, 46)
    KeyBox.Font = Enum.Font.Code
    KeyBox.PlaceholderText = "Enter your license key here..."
    KeyBox.PlaceholderColor3 = Color3.fromRGB(110, 110, 120)
    KeyBox.Text = ""
    KeyBox.TextColor3 = COLOR_ACCENT
    KeyBox.TextSize = 13
    KeyBox.TextXAlignment = Enum.TextXAlignment.Left
    local padding = Instance.new("UIPadding")
    padding.Parent = KeyBox
    padding.PaddingLeft = UDim.new(0, 15)
    padding.PaddingRight = UDim.new(0, 15)
    applyCorner(KeyBox, 8)
    local kStroke = applyStroke(KeyBox, COLOR_STROKE, 1)

    KeyBox.Focused:Connect(function() TweenService:Create(kStroke, TweenInfo.new(0.2), {Color = COLOR_ACCENT}):Play() end)
    KeyBox.FocusLost:Connect(function() TweenService:Create(kStroke, TweenInfo.new(0.2), {Color = COLOR_STROKE}):Play() end)

    local VerifyBtn = Instance.new("TextButton")
    VerifyBtn.Parent = HomePage
    VerifyBtn.BackgroundColor3 = COLOR_ACCENT
    VerifyBtn.Position = UDim2.new(0, 30, 0, 175)
    VerifyBtn.Size = UDim2.new(0.5, -36, 0, 44)
    VerifyBtn.Font = Enum.Font.GothamBold
    VerifyBtn.Text = "VERIFY KEY"
    VerifyBtn.TextColor3 = Color3.fromRGB(10, 10, 12)
    VerifyBtn.TextSize = 13
    applyCorner(VerifyBtn, 8)
    animateButton(VerifyBtn)

    local GetKeyBtn = Instance.new("TextButton")
    GetKeyBtn.Parent = HomePage
    GetKeyBtn.BackgroundColor3 = Color3.fromRGB(22, 22, 26)
    GetKeyBtn.Position = UDim2.new(0.5, 6, 0, 175) 
    GetKeyBtn.Size = UDim2.new(0.5, -36, 0, 44)
    GetKeyBtn.Font = Enum.Font.GothamBold
    GetKeyBtn.Text = "GET KEY"
    GetKeyBtn.TextColor3 = COLOR_TEXT
    GetKeyBtn.TextSize = 13
    applyCorner(GetKeyBtn, 8)
    applyStroke(GetKeyBtn, COLOR_STROKE, 1)
    animateGhostButton(GetKeyBtn)

    local StatusLabel = Instance.new("TextLabel")
    StatusLabel.Parent = HomePage
    StatusLabel.BackgroundTransparency = 1
    StatusLabel.Position = UDim2.new(0, 30, 1, -40)
    StatusLabel.Size = UDim2.new(1, -60, 0, 20)
    StatusLabel.Font = Enum.Font.GothamBold
    StatusLabel.Text = "AWAITING ACTION"
    StatusLabel.TextColor3 = COLOR_STROKE
    StatusLabel.TextSize = 11
    StatusLabel.TextXAlignment = Enum.TextXAlignment.Center

    local function setStatus(text, color)
        StatusLabel.Text = text
        TweenService:Create(StatusLabel, TweenInfo.new(0.3), {TextColor3 = color}):Play()
    end

    pcall(function() 
        local Players = game:GetService("Players")
        if Players.LocalPlayer then
            WelcomeHeader.Text = "HELLO, " .. string.upper(Players.LocalPlayer.Name)
        else
            Players.PlayerAdded:Connect(function()
                WelcomeHeader.Text = "HELLO, " .. string.upper(Players.LocalPlayer.Name)
            end)
        end
    end)

    -- --- INFO PAGE LAYOUT ---
    local InfoScroll = Instance.new("Frame")
    InfoScroll.Parent = InfoPage
    InfoScroll.BackgroundTransparency = 1
    InfoScroll.Position = UDim2.new(0, 30, 0, 30)
    InfoScroll.Size = UDim2.new(1, -60, 1, -60)
    InfoScroll.BorderSizePixel = 0

    local InfoLayout = Instance.new("UIListLayout")
    InfoLayout.Parent = InfoScroll
    InfoLayout.SortOrder = Enum.SortOrder.LayoutOrder
    InfoLayout.Padding = UDim.new(0, 12)

    local function createLink(title, subtitle, actionObj)
        local btn = Instance.new("TextButton")
        btn.Parent = InfoScroll
        btn.BackgroundColor3 = Color3.fromRGB(20, 20, 24)
        btn.Size = UDim2.new(1, -10, 0, 65)
        btn.Text = ""
        applyCorner(btn, 8)
        applyStroke(btn, COLOR_STROKE, 1)
        
        local t = Instance.new("TextLabel")
        t.Parent = btn
        t.BackgroundTransparency = 1
        t.Position = UDim2.new(0, 20, 0, 15)
        t.Size = UDim2.new(1, -40, 0, 20)
        t.Font = Enum.Font.GothamBold
        t.Text = title
        t.TextColor3 = COLOR_TEXT
        t.TextSize = 14
        t.TextXAlignment = Enum.TextXAlignment.Left

        local d = Instance.new("TextLabel")
        d.Parent = btn
        d.BackgroundTransparency = 1
        d.Position = UDim2.new(0, 20, 0, 36)
        d.Size = UDim2.new(1, -40, 0, 15)
        d.Font = Enum.Font.Gotham
        d.Text = subtitle
        d.TextColor3 = COLOR_TEXT_DIM
        d.TextSize = 11
        d.TextXAlignment = Enum.TextXAlignment.Left

        local arrow = Instance.new("ImageLabel")
        arrow.Parent = btn
        arrow.BackgroundTransparency = 1
        arrow.Position = UDim2.new(1, -30, 0.5, -9)
        arrow.Size = UDim2.new(0, 18, 0, 18)
        arrow.Image = "rbxassetid://3926305904" 
        arrow.ImageRectOffset = Vector2.new(144, 4) 
        arrow.ImageRectSize = Vector2.new(24, 24)
        arrow.ImageColor3 = COLOR_TEXT_DIM

        animateGhostButton(btn)

        btn.MouseButton1Click:Connect(function()
            if type(actionObj) == "function" then
                actionObj()
            else
                setclipboard(actionObj)
                Notify("Copied Link", "Action completed: " .. title .. " link copied.", 4, "success")
            end
        end)
    end

    createLink("Discord Server", "Join for updates and scripts", "https://discord.gg/RQ2SSPuEmT")
    createLink("YouTube Channel", "Watch script showcases and tutorials", "https://www.youtube.com/@primexhub0")
    createLink("Website", "Official hub site", "https://sairo.online/home")
    createLink("Live Support", "Chat with developers for help", function()
        pcall(function() loadstring(game:HttpGet("https://raw.githubusercontent.com/wendigo5414-cmyk/FireballxArena/refs/heads/main/feedbacksystem"))() end)
    end)

    -- Dragging Logic
    local dragging, dragInput, dragStart, startPos
    local function updateMove(input)
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end

    Sidebar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
            input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
        end
    end)
    Sidebar.InputChanged:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseMovement then dragInput = input end end)
    UserInputService.InputChanged:Connect(function(input) if input == dragInput and dragging then updateMove(input) end end)

    -- API & Verify Flow
    
    local function getKey()
        setStatus("GENERATING KEY LINK...", COLOR_TEXT)
        local robloxName = "Unknown"
        pcall(function() 
            local Players = game:GetService("Players")
            if Players.LocalPlayer then robloxName = Players.LocalPlayer.Name end
        end)
        
        local url = API_URL .. "/api/init"
        local body = HttpService:JSONEncode({hwid = HWID, robloxName = robloxName, devId = DEV_ID})
        
        local success, response = pcall(function()
            if syn and syn.request then return syn.request({Url = url, Method = "POST", Headers = {["Content-Type"] = "application/json"}, Body = body})
            elseif http and http.request then return http.request({Url = url, Method = "POST", Headers = {["Content-Type"] = "application/json"}, Body = body})
            elseif request then return request({Url = url, Method = "POST", Headers = {["Content-Type"] = "application/json"}, Body = body})
            else return {StatusCode = 500, Body = "Executor not supported"} end
        end)
        
        if success and response.StatusCode == 200 then
            local data = HttpService:JSONDecode(response.Body)
            if data.url then
                setclipboard(data.url)
                setStatus("LINK COPIED TO CLIPBOARD", COLOR_ACCENT)
                Notify("Generated", "Link to generate key copied.", 4, "success")
            else
                setStatus("SERVER ERROR", Color3.fromRGB(255, 80, 80))
                Notify("Error", "Server error generating key.", 4, "error")
            end
        else
            setStatus("CONNECTION FAILED", Color3.fromRGB(255, 80, 80))
            Notify("Error", "Could not connect to Sairo API.", 4, "error")
        end
    end

    local function onVerify()
        local inputKey = KeyBox.Text
        if inputKey == "" then 
            Notify("Required", "Please provide a valid key.", 3, "warning")
            return 
        end
        
        VerifyBtn.Text = "CHECKING..."
        setStatus("AUTHENTICATING...", COLOR_TEXT)
        
        local robloxName = "Unknown"
        pcall(function() 
            local Players = game:GetService("Players")
            if Players.LocalPlayer then robloxName = Players.LocalPlayer.Name end
        end)
        
        local url = API_URL .. "/api/verify-key?key=" .. inputKey .. "&hwid=" .. HWID .. "&robloxName=" .. robloxName
        local success, response = pcall(function() return game:HttpGet(url) end)
        
        if success then
            local data = HttpService:JSONDecode(response)
            if data.status == "valid" then
                setStatus("ACCESS GRANTED", COLOR_ACCENT)
                Notify("Verified", "Your key is valid. Booting...", 4, "success")
                
                if writefile then pcall(function() writefile("SairoAuth.txt", inputKey) end) end
                
                TweenService:Create(MainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {Size = UDim2.new(0, 550, 0, 0), Position = MainFrame.Position + UDim2.new(0,0,0,165)}):Play()
                task.wait(0.5)
                KeySystem:Destroy()
                
                isVerified = true
            elseif data.status == "invalid_hwid" then
                 setStatus("HWID MISMATCH", Color3.fromRGB(255, 80, 80))
                 Notify("Denied", "Key used on another device.", 5, "error")
            else
                setStatus("INVALID KEY", Color3.fromRGB(255, 80, 80))
                Notify("Denied", "The key is expired or invalid.", 4, "error")
            end
        else
            setStatus("CONNECTION FAILED", Color3.fromRGB(255, 80, 80))
            Notify("Error", "Server unreachable.", 4, "error")
        end
        VerifyBtn.Text = "VERIFY KEY"
    end

    GetKeyBtn.MouseButton1Click:Connect(getKey)
    VerifyBtn.MouseButton1Click:Connect(onVerify)

    selectTab(HomePage)

    if readfile and pcall(function() return readfile("SairoAuth.txt") end) then
        local saved = readfile("SairoAuth.txt")
        KeyBox.Text = saved
        task.delay(0.5, onVerify)
    end

    repeat task.wait(0.2) until isVerified
end

return SairoLibrary
