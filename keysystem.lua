--[[ 
    SAIRO KEY SYSTEM [PREMIUM] - MODULE VERSION
    Host this file on GitHub.
]]

local SairoLibrary = {}

function SairoLibrary.Init()
    -- SERVICES
    local TweenService = game:GetService("TweenService")
    local HttpService = game:GetService("HttpService")
    local UserInputService = game:GetService("UserInputService")
    local HWID = game:GetService("RbxAnalyticsService"):GetClientId()
    local CoreGui = game:GetService("CoreGui")

    -- CONFIG
    local API_URL = "https://webservice-g7b9.onrender.com" 
    local SCRIPT_URL = "No URL" -- Not needed in this module version
    
    -- THEME
    local COLOR_ACCENT = Color3.fromRGB(249, 115, 22)
    local COLOR_ACCENT_HOVER = Color3.fromRGB(251, 146, 60)
    local COLOR_BG = Color3.fromRGB(10, 10, 10)
    local COLOR_SIDE = Color3.fromRGB(18, 18, 18)
    local COLOR_STROKE = Color3.fromRGB(40, 40, 40)

    -- STATE
    local isVerified = false

    -- UI CONSTRUCTION
    local KeySystem = Instance.new("ScreenGui")
    KeySystem.Name = "SairoPremium"
    KeySystem.Parent = CoreGui
    KeySystem.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    local MainCanvas = Instance.new("CanvasGroup")
    MainCanvas.Name = "Main"
    MainCanvas.Parent = KeySystem
    MainCanvas.BackgroundColor3 = COLOR_BG
    MainCanvas.Position = UDim2.new(0.5, -225, 0.5, -130)
    MainCanvas.Size = UDim2.new(0, 450, 0, 260)
    MainCanvas.BorderSizePixel = 0
    MainCanvas.GroupTransparency = 0
    
    -- Helpers
    local function round(obj, radius)
        local uic = Instance.new("UICorner")
        uic.CornerRadius = UDim.new(0, radius)
        uic.Parent = obj
    end

    local function addStroke(obj, color, thickness)
        local stroke = Instance.new("UIStroke")
        stroke.Color = color
        stroke.Thickness = thickness
        stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        stroke.Parent = obj
        return stroke
    end

    local function createGradient(obj, c1, c2)
        local grad = Instance.new("UIGradient")
        grad.Color = ColorSequence.new{ColorSequenceKeypoint.new(0, c1), ColorSequenceKeypoint.new(1, c2)}
        grad.Rotation = 45
        grad.Parent = obj
    end

    local function animateButton(btn)
        btn.AutoButtonColor = false
        btn.MouseEnter:Connect(function() TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = COLOR_ACCENT_HOVER}):Play() end)
        btn.MouseLeave:Connect(function() TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = COLOR_ACCENT}):Play() end)
        btn.MouseButton1Down:Connect(function() TweenService:Create(btn, TweenInfo.new(0.1), {Size = UDim2.new(btn.Size.X.Scale, -2, btn.Size.Y.Scale, -2)}):Play() end)
        btn.MouseButton1Up:Connect(function() TweenService:Create(btn, TweenInfo.new(0.1), {Size = UDim2.new(btn.Size.X.Scale, 2, btn.Size.Y.Scale, 2)}):Play() end)
    end

    round(MainCanvas, 12)
    addStroke(MainCanvas, Color3.fromRGB(60, 60, 60), 1)

    -- Glow
    local Glow = Instance.new("ImageLabel")
    Glow.Name = "Glow"
    Glow.Parent = MainCanvas
    Glow.BackgroundTransparency = 1
    Glow.Position = UDim2.new(0, -100, 0, -100)
    Glow.Size = UDim2.new(1, 200, 1, 200)
    Glow.Image = "rbxassetid://5028857472"
    Glow.ImageColor3 = COLOR_ACCENT
    Glow.ImageTransparency = 0.92
    Glow.ZIndex = 0

    -- Notifications
    local NotifContainer = Instance.new("Frame")
    NotifContainer.Parent = KeySystem
    NotifContainer.Position = UDim2.new(1, -220, 1, -300) 
    NotifContainer.Size = UDim2.new(0, 200, 0, 280)
    NotifContainer.BackgroundTransparency = 1
    
    local UIListLayout_Notif = Instance.new("UIListLayout")
    UIListLayout_Notif.Parent = NotifContainer
    UIListLayout_Notif.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout_Notif.VerticalAlignment = Enum.VerticalAlignment.Bottom
    UIListLayout_Notif.Padding = UDim.new(0, 5)

    local function Notify(title, text, duration)
        local frame = Instance.new("Frame")
        frame.Parent = NotifContainer
        frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
        frame.Size = UDim2.new(1, 0, 0, 50)
        frame.BackgroundTransparency = 1 
        round(frame, 6)
        local stroke = addStroke(frame, COLOR_STROKE, 1)
        
        local tLabel = Instance.new("TextLabel")
        tLabel.Parent = frame
        tLabel.BackgroundTransparency = 1
        tLabel.Position = UDim2.new(0, 10, 0, 5)
        tLabel.Size = UDim2.new(1, -20, 0, 20)
        tLabel.Font = Enum.Font.GothamBold
        tLabel.Text = title
        tLabel.TextColor3 = COLOR_ACCENT
        tLabel.TextSize = 12
        tLabel.TextXAlignment = Enum.TextXAlignment.Left
        tLabel.TextTransparency = 1
        
        local cLabel = Instance.new("TextLabel")
        cLabel.Parent = frame
        cLabel.BackgroundTransparency = 1
        cLabel.Position = UDim2.new(0, 10, 0, 22)
        cLabel.Size = UDim2.new(1, -20, 0, 20)
        cLabel.Font = Enum.Font.Gotham
        cLabel.Text = text
        cLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
        cLabel.TextSize = 11
        cLabel.TextXAlignment = Enum.TextXAlignment.Left
        cLabel.TextTransparency = 1

        TweenService:Create(frame, TweenInfo.new(0.3), {BackgroundTransparency = 0.1}):Play()
        TweenService:Create(tLabel, TweenInfo.new(0.3), {TextTransparency = 0}):Play()
        TweenService:Create(cLabel, TweenInfo.new(0.3), {TextTransparency = 0}):Play()
        
        task.delay(duration or 3, function()
            TweenService:Create(frame, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
            TweenService:Create(tLabel, TweenInfo.new(0.3), {TextTransparency = 1}):Play()
            TweenService:Create(cLabel, TweenInfo.new(0.3), {TextTransparency = 1}):Play()
            TweenService:Create(stroke, TweenInfo.new(0.3), {Transparency = 1}):Play()
            wait(0.3)
            frame:Destroy()
        end)
    end

    -- Sidebar
    local Sidebar = Instance.new("Frame")
    Sidebar.Parent = MainCanvas
    Sidebar.BackgroundColor3 = COLOR_SIDE
    Sidebar.Size = UDim2.new(0, 130, 1, 0)
    Sidebar.ZIndex = 2

    local Title = Instance.new("TextLabel")
    Title.Parent = Sidebar
    Title.BackgroundTransparency = 1
    Title.Position = UDim2.new(0, 0, 0, 25)
    Title.Size = UDim2.new(1, 0, 0, 30)
    Title.Font = Enum.Font.GothamBlack
    Title.Text = "SAIRO"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 22
    createGradient(Title, Color3.fromRGB(255, 255, 255), COLOR_ACCENT)

    local function createTabBtn(name, yPos)
        local btn = Instance.new("TextButton")
        btn.Parent = Sidebar
        btn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        btn.BackgroundTransparency = 1
        btn.Position = UDim2.new(0, 10, 0, yPos)
        btn.Size = UDim2.new(1, -20, 0, 35)
        btn.Font = Enum.Font.GothamMedium
        btn.Text = "  " .. name
        btn.TextColor3 = Color3.fromRGB(150, 150, 150)
        btn.TextSize = 13
        btn.TextXAlignment = Enum.TextXAlignment.Left
        btn.ZIndex = 2
        round(btn, 6)
        
        btn.MouseEnter:Connect(function()
            if btn.BackgroundTransparency == 1 then
                TweenService:Create(btn, TweenInfo.new(0.2), {TextColor3 = Color3.new(1,1,1)}):Play()
            end
        end)
        btn.MouseLeave:Connect(function()
            if btn.BackgroundTransparency == 1 then
                TweenService:Create(btn, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(150,150,150)}):Play()
            end
        end)
        return btn
    end

    local TabHome = createTabBtn("Gateway", 90)
    local TabHistory = createTabBtn("History", 135)

    -- Content
    local ContentArea = Instance.new("Frame")
    ContentArea.Parent = MainCanvas
    ContentArea.BackgroundTransparency = 1
    ContentArea.Position = UDim2.new(0, 130, 0, 0)
    ContentArea.Size = UDim2.new(1, -130, 1, 0)
    ContentArea.ZIndex = 2

    local HomePage = Instance.new("Frame")
    HomePage.Parent = ContentArea
    HomePage.Size = UDim2.new(1, 0, 1, 0)
    HomePage.BackgroundTransparency = 1

    local HistoryPage = Instance.new("Frame")
    HistoryPage.Parent = ContentArea
    HistoryPage.Size = UDim2.new(1, 0, 1, 0)
    HistoryPage.BackgroundTransparency = 1
    HistoryPage.Visible = false

    -- Home Elements
    local InfoTitle = Instance.new("TextLabel")
    InfoTitle.Parent = HomePage
    InfoTitle.BackgroundTransparency = 1
    InfoTitle.Position = UDim2.new(0, 30, 0, 25)
    InfoTitle.Size = UDim2.new(1, -60, 0, 20)
    InfoTitle.Font = Enum.Font.GothamBold
    InfoTitle.Text = "ACCESS CONTROL"
    InfoTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    InfoTitle.TextSize = 16
    InfoTitle.TextXAlignment = Enum.TextXAlignment.Left

    local InfoDesc = Instance.new("TextLabel")
    InfoDesc.Parent = HomePage
    InfoDesc.BackgroundTransparency = 1
    InfoDesc.Position = UDim2.new(0, 30, 0, 45)
    InfoDesc.Size = UDim2.new(1, -60, 0, 30)
    InfoDesc.Font = Enum.Font.Gotham
    InfoDesc.Text = "Valid key required to initialize script execution."
    InfoDesc.TextColor3 = Color3.fromRGB(100, 100, 100)
    InfoDesc.TextSize = 11
    InfoDesc.TextWrapped = true
    InfoDesc.TextXAlignment = Enum.TextXAlignment.Left

    local KeyBox = Instance.new("TextBox")
    KeyBox.Parent = HomePage
    KeyBox.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    KeyBox.Position = UDim2.new(0, 30, 0, 90)
    KeyBox.Size = UDim2.new(1, -60, 0, 45)
    KeyBox.Font = Enum.Font.Code
    KeyBox.PlaceholderText = "Enter License Key..."
    KeyBox.PlaceholderColor3 = Color3.fromRGB(60, 60, 60)
    KeyBox.Text = ""
    KeyBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    KeyBox.TextSize = 13
    round(KeyBox, 8)
    addStroke(KeyBox, COLOR_STROKE, 1)

    local VerifyBtn = Instance.new("TextButton")
    VerifyBtn.Parent = HomePage
    VerifyBtn.BackgroundColor3 = COLOR_ACCENT
    VerifyBtn.Position = UDim2.new(0, 30, 0, 150)
    VerifyBtn.Size = UDim2.new(0.45, 0, 0, 40)
    VerifyBtn.Font = Enum.Font.GothamBold
    VerifyBtn.Text = "AUTHENTICATE"
    VerifyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    VerifyBtn.TextSize = 11
    round(VerifyBtn, 8)
    animateButton(VerifyBtn)

    local GetKeyBtn = Instance.new("TextButton")
    GetKeyBtn.Parent = HomePage
    GetKeyBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    GetKeyBtn.Position = UDim2.new(0.52, 0, 0, 150)
    GetKeyBtn.Size = UDim2.new(0.40, 0, 0, 40)
    GetKeyBtn.Font = Enum.Font.GothamBold
    GetKeyBtn.Text = "GET KEY"
    GetKeyBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
    GetKeyBtn.TextSize = 11
    round(GetKeyBtn, 8)
    addStroke(GetKeyBtn, COLOR_STROKE, 1)
    
    GetKeyBtn.MouseEnter:Connect(function() TweenService:Create(GetKeyBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(35,35,35)}):Play() end)
    GetKeyBtn.MouseLeave:Connect(function() TweenService:Create(GetKeyBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(25,25,25)}):Play() end)

    local Status = Instance.new("TextLabel")
    Status.Parent = HomePage
    Status.BackgroundTransparency = 1
    Status.Position = UDim2.new(0, 30, 1, -30)
    Status.Size = UDim2.new(1, -60, 0, 20)
    Status.Font = Enum.Font.GothamBold
    Status.Text = "SYSTEM READY"
    Status.TextColor3 = Color3.fromRGB(60, 60, 60)
    Status.TextSize = 10
    Status.TextXAlignment = Enum.TextXAlignment.Left

    -- History
    local HistoryScroll = Instance.new("ScrollingFrame")
    HistoryScroll.Parent = HistoryPage
    HistoryScroll.BackgroundTransparency = 1
    HistoryScroll.Position = UDim2.new(0, 20, 0, 60)
    HistoryScroll.Size = UDim2.new(1, -40, 1, -70)
    HistoryScroll.ScrollBarThickness = 2
    HistoryScroll.BorderSizePixel = 0
    
    local HistoryTitle = Instance.new("TextLabel")
    HistoryTitle.Parent = HistoryPage
    HistoryTitle.BackgroundTransparency = 1
    HistoryTitle.Position = UDim2.new(0, 25, 0, 20)
    HistoryTitle.Size = UDim2.new(1, 0, 0, 30)
    HistoryTitle.Font = Enum.Font.GothamBold
    HistoryTitle.Text = "RECENT KEYS"
    HistoryTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    HistoryTitle.TextSize = 14
    HistoryTitle.TextXAlignment = Enum.TextXAlignment.Left

    local HistoryLayout = Instance.new("UIListLayout")
    HistoryLayout.Parent = HistoryScroll
    HistoryLayout.Padding = UDim.new(0, 8)

    -- LOGIC
    local function switchTab(page)
        HomePage.Visible = false
        HistoryPage.Visible = false
        page.Visible = true
        
        TabHome.TextColor3 = Color3.fromRGB(150, 150, 150)
        TabHistory.TextColor3 = Color3.fromRGB(150, 150, 150)
        TabHome.BackgroundTransparency = 1
        TabHistory.BackgroundTransparency = 1
        
        local activeBtn = (page == HomePage) and TabHome or TabHistory
        activeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        TweenService:Create(activeBtn, TweenInfo.new(0.3), {BackgroundTransparency = 0.95}):Play()
    end

    local function setStatus(text, color)
        Status.Text = string.upper(text)
        Status.TextColor3 = color
    end

    local function getKey()
        setStatus("CONTACTING SERVER...", Color3.fromRGB(255, 255, 255))
        local url = API_URL .. "/api/init"
        local body = HttpService:JSONEncode({hwid = HWID})
        
        local success, response = pcall(function()
            if syn and syn.request then
                return syn.request({Url = url, Method = "POST", Headers = {["Content-Type"] = "application/json"}, Body = body})
            elseif http and http.request then
                return http.request({Url = url, Method = "POST", Headers = {["Content-Type"] = "application/json"}, Body = body})
            elseif request then
                return request({Url = url, Method = "POST", Headers = {["Content-Type"] = "application/json"}, Body = body})
            else
                return {StatusCode = 500, Body = "Executor not supported"}
            end
        end)
        
        if success and response.StatusCode == 200 then
            local data = HttpService:JSONDecode(response.Body)
            if data.url then
                setclipboard(data.url)
                setStatus("LINK COPIED TO CLIPBOARD", Color3.fromRGB(74, 222, 128))
                Notify("Link Generated", "Copied to clipboard.", 4)
            else
                setStatus("SERVER ERROR", Color3.fromRGB(248, 113, 113))
                Notify("Error", "Invalid server response.", 4)
            end
        else
            setStatus("CONNECTION FAILED", Color3.fromRGB(248, 113, 113))
            Notify("Network Error", "Check your connection.", 4)
        end
    end

    local function verify(inputKey)
        if inputKey == "" then 
            Notify("Input Required", "Paste key to continue.", 3)
            return 
        end
        
        setStatus("AUTHENTICATING...", Color3.fromRGB(255, 255, 255))
        VerifyBtn.Text = "..."
        
        local url = API_URL .. "/api/verify-key?key=" .. inputKey .. "&hwid=" .. HWID
        local success, response = pcall(function() return game:HttpGet(url) end)
        
        if success then
            local data = HttpService:JSONDecode(response)
            if data.status == "valid" then
                setStatus("GRANTED", Color3.fromRGB(74, 222, 128))
                Notify("Authenticated", "Loading script...", 5)
                
                if writefile then writefile("Sairo_Last.txt", inputKey) end
                
                -- ANIMATE OUT
                TweenService:Create(MainCanvas, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {GroupTransparency = 1}):Play()
                TweenService:Create(MainCanvas, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Size = UDim2.new(0, 0, 0, 0)}):Play()
                
                task.wait(0.5)
                KeySystem:Destroy()
                
                -- UNLOCK
                isVerified = true
            elseif data.status == "invalid_hwid" then
                 setStatus("HWID MISMATCH", Color3.fromRGB(248, 113, 113))
                 Notify("Error", "Key invalid for this device.", 5)
            else
                setStatus("INVALID KEY", Color3.fromRGB(248, 113, 113))
                Notify("Error", "Key invalid or expired.", 4)
            end
        else
            setStatus("CONNECTION FAILED", Color3.fromRGB(248, 113, 113))
            Notify("Error", "Server unreachable.", 4)
        end
        VerifyBtn.Text = "AUTHENTICATE"
    end

    local function loadHistory()
        for _, child in pairs(HistoryScroll:GetChildren()) do
            if child:IsA("Frame") then child:Destroy() end
        end
        
        if readfile and pcall(function() readfile("Sairo_Last.txt") end) then
             local lastKey = readfile("Sairo_Last.txt")
             local card = Instance.new("Frame")
             card.Parent = HistoryScroll
             card.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
             card.Size = UDim2.new(1, 0, 0, 45)
             round(card, 8)
             addStroke(card, Color3.fromRGB(40, 40, 40), 1)
             
             local kLabel = Instance.new("TextLabel")
             kLabel.Parent = card
             kLabel.BackgroundTransparency = 1
             kLabel.Position = UDim2.new(0, 15, 0, 0)
             kLabel.Size = UDim2.new(1, -30, 1, 0)
             kLabel.Font = Enum.Font.Code
             kLabel.Text = lastKey
             kLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
             kLabel.TextSize = 12
             kLabel.TextXAlignment = Enum.TextXAlignment.Left
             
             local copyBtn = Instance.new("TextButton")
             copyBtn.Parent = card
             copyBtn.Size = UDim2.new(1,0,1,0)
             copyBtn.BackgroundTransparency = 1
             copyBtn.Text = ""
             copyBtn.MouseButton1Click:Connect(function()
                 setclipboard(lastKey)
                 Notify("History", "Key copied.", 2)
             end)
        end
    end

    -- CONNECT EVENTS
    GetKeyBtn.MouseButton1Click:Connect(getKey)
    VerifyBtn.MouseButton1Click:Connect(function() verify(KeyBox.Text) end)
    TabHome.MouseButton1Click:Connect(function() switchTab(HomePage) end)
    TabHistory.MouseButton1Click:Connect(function() switchTab(HistoryPage); loadHistory() end)

    -- DRAG
    local dragging, dragInput, dragStart, startPos
    local function update(input)
        local delta = input.Position - dragStart
        MainCanvas.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
    MainCanvas.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = MainCanvas.Position
            input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
        end
    end)
    MainCanvas.InputChanged:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseMovement then dragInput = input end end)
    UserInputService.InputChanged:Connect(function(input) if input == dragInput and dragging then update(input) end end)

    -- INIT UI
    switchTab(HomePage)
    
    -- AUTO LOAD
    if readfile and pcall(function() readfile("Sairo_Last.txt") end) then
        local saved = readfile("Sairo_Last.txt")
        KeyBox.Text = saved
        task.delay(0.5, function() verify(saved) end)
    end

    -- YIELD (THE IMPORTANT PART)
    -- This halts the thread until Verified is true
    repeat task.wait(0.1) until isVerified
    
    return true
end

return SairoLibrary
