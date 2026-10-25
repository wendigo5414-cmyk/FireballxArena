return function(Window, Tabs, WindUI)
    -- ══════════════════════════════════════════
    --        AUTO-FLAG INJECTION SYSTEM
    -- ══════════════════════════════════════════
    -- 1. Proactive hooking (for UI components created AFTER this script loads)
    local function registerFlagElement(flag, element)
        if not flag or type(element) ~= "table" then return end
        if not Window.Flags then Window.Flags = {} end
        Window.Flags[flag] = element

        if not WindUI.Flags then WindUI.Flags = {} end
        WindUI.Flags[flag] = element
    end

    local function hookContainer(containerObj, tabPrefix)
        if type(containerObj) ~= "table" or containerObj.__pxhHooked then return end
        containerObj.__pxhHooked = true
        
        local methodsToHook = {"Toggle", "Slider", "Dropdown", "Input", "Colorpicker", "Keybind"}
        for _, method in ipairs(methodsToHook) do
            local originalMethod = containerObj[method]
            if type(originalMethod) == "function" then
                containerObj[method] = function(self, options)
                    local elementRef = nil
                    local initialVal = nil
                    if options and type(options) == "table" then
                        if options.Title and not options.Flag then
                            options.Flag = "PXHRetro_" .. tostring(options.Title):gsub("[^%w]", "")
                        end
                        if options.Save == nil then
                            options.Save = true
                        end

                        if method == "Slider" and type(options.Value) == "table" then
                            initialVal = options.Value.Default or options.Value.Min or 0
                        else
                            initialVal = options.Value
                        end

                        local origCallback = options.Callback
                        options.Callback = function(val, ...)
                            if type(elementRef) == "table" then
                                elementRef.__savedValue = val
                            end
                            if type(origCallback) == "function" then
                                return origCallback(val, ...)
                            end
                        end
                    end

                    local element = originalMethod(self, options)
                    elementRef = element

                    -- Ensure it gets pushed to WindUI state
                    pcall(function()
                        if type(element) == "table" and options then
                            if not element.Flag and options.Flag then
                                element.Flag = options.Flag
                            end
                            if element.Save == nil and options.Save ~= nil then
                                element.Save = options.Save
                            end
                            if element.__savedValue == nil then
                                if method == "Slider" or element.__type == "Slider" then
                                    element.__savedValue = (type(element.Value) == "table" and element.Value.Default) or initialVal
                                else
                                    element.__savedValue = (element.Value ~= nil and element.Value) or initialVal
                                end
                            end
                            
                            if element.Flag then
                                registerFlagElement(element.Flag, element)
                            end
                        end
                    end)
                    return element
                end
            end
        end
        
        local originalSection = containerObj.Section
        if type(originalSection) == "function" then
            containerObj.Section = function(self, options)
                local sectionObj = originalSection(self, options)
                if sectionObj and type(sectionObj) == "table" then
                    hookContainer(sectionObj, tabPrefix)
                end
                return sectionObj
            end
        end

        local originalGroup = containerObj.Group
        if type(originalGroup) == "function" then
            containerObj.Group = function(self, options)
                local groupObj = originalGroup(self, options)
                if groupObj and type(groupObj) == "table" then
                    hookContainer(groupObj, tabPrefix)
                end
                return groupObj
            end
        end
    end
    
    for tabName, tabObj in pairs(Tabs) do
        hookContainer(tabObj, tabName)
    end
    
    -- 2. Retroactive injection (for UI components created BEFORE this script loads, e.g. legacy scripts)
    local function retrofitElements()
        local seen = {}
        local function scan(obj)
            if type(obj) ~= "table" or seen[obj] then return end
            seen[obj] = true

            local elemType = obj.__type or obj.Type
            if elemType and obj.Title and type(obj.Callback) == "function" then
                if not obj.Flag then
                    obj.Flag = "PXHRetro_" .. tostring(obj.Title):gsub("[^%w]", "")
                end
                if obj.Save == nil then
                    obj.Save = true
                end
                if not obj.__pxhCallbackHooked then
                    obj.__pxhCallbackHooked = true
                    local origCb = obj.Callback
                    obj.Callback = function(val, ...)
                        obj.__savedValue = val
                        return origCb(val, ...)
                    end
                end
                if obj.__savedValue == nil then
                    if elemType == "Slider" and type(obj.Value) == "table" then
                        obj.__savedValue = obj.Value.Default
                    else
                        obj.__savedValue = obj.Value
                    end
                end
                pcall(function()
                    if obj.Flag then
                        registerFlagElement(obj.Flag, obj)
                    end
                end)
            end

            for k, v in pairs(obj) do
                if type(v) == "table" and k ~= "Parent" and k ~= "Window" and k ~= "WindUI" then
                    pcall(scan, v)
                end
            end
        end
        pcall(scan, Window)
        pcall(scan, Tabs)
        pcall(scan, WindUI)
        if type(Window) == "table" and type(Window.PendingFlags) == "table" then
            for flag, elem in pairs(Window.PendingFlags) do
                registerFlagElement(flag, elem)
            end
        end
    end
    retrofitElements()

    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    local RunService = game:GetService("RunService")
    local UserInputService = game:GetService("UserInputService")
    local TweenService = game:GetService("TweenService")

    -- ══════════════════════════════════════════
    --         AUTO CAMERA ZOOM UNLOCKER
    -- ══════════════════════════════════════════
    local TARGET_MAX_ZOOM = 100000
    local TARGET_MIN_ZOOM = 0.5

    local function unlockCameraZoom()
        pcall(function()
            if not LocalPlayer then return end
            if LocalPlayer.CameraMode == Enum.CameraMode.LockFirstPerson then
                LocalPlayer.CameraMode = Enum.CameraMode.Classic
            end
            if LocalPlayer.CameraMaxZoomDistance < TARGET_MAX_ZOOM then
                LocalPlayer.CameraMaxZoomDistance = TARGET_MAX_ZOOM
            end
            if LocalPlayer.CameraMinZoomDistance > TARGET_MIN_ZOOM then
                LocalPlayer.CameraMinZoomDistance = TARGET_MIN_ZOOM
            end
        end)
    end

    -- 1. Unlock immediately on script execution
    unlockCameraZoom()

    -- 2. Instant lock detection via GetPropertyChangedSignal
    if LocalPlayer then
        pcall(function()
            LocalPlayer:GetPropertyChangedSignal("CameraMaxZoomDistance"):Connect(function()
                if LocalPlayer.CameraMaxZoomDistance < TARGET_MAX_ZOOM then
                    LocalPlayer.CameraMaxZoomDistance = TARGET_MAX_ZOOM
                end
            end)
            LocalPlayer:GetPropertyChangedSignal("CameraMinZoomDistance"):Connect(function()
                if LocalPlayer.CameraMinZoomDistance > TARGET_MIN_ZOOM then
                    LocalPlayer.CameraMinZoomDistance = TARGET_MIN_ZOOM
                end
            end)
            LocalPlayer:GetPropertyChangedSignal("CameraMode"):Connect(function()
                if LocalPlayer.CameraMode == Enum.CameraMode.LockFirstPerson then
                    LocalPlayer.CameraMode = Enum.CameraMode.Classic
                end
            end)
        end)
    end

    -- 3. 5-second fallback loop to guarantee zoom stays unlocked
    task.spawn(function()
        while true do
            task.wait(5)
            unlockCameraZoom()
        end
    end)

    -- ══════════════════════════════════════════
    --              NUMBER CONVERTER
    -- ══════════════════════════════════════════
    local NumberConverter = {}
    
    local suffixes = {
        "K", "M", "B", "T", "Qa", "Qi", "Sx", "Sp", "Oc", "No", "Dc", "Ud", "Dd", "Td", "Qad", "Qid", "Sxd", "Spd", "Ocd", "Nod", "Vg", "Uvg"
    }
    -- This handles up to 10^66 (Uvg). For 100 zeros, we can add more:
    local extendedSuffixes = {
        "K", "M", "B", "T", "Qa", "Qi", "Sx", "Sp", "Oc", "No", -- 10^3 to 10^30
        "Dc", "Ud", "Dd", "Td", "Qad", "Qid", "Sxd", "Spd", "Ocd", "Nod", -- 10^33 to 10^60
        "Vg", "Uvg", "Dvg", "Tvg", "Qavg", "Qivg", "Sxvg", "Spvg", "Ocvg", "Novg", -- 10^63 to 10^90
        "Tg", "Utg", "Dtg", "Ttg", "Qatg", "Qitg", "Sxtg", "Sptg", "Octg", "Notg", -- 10^93 to 10^120
        "Qd", "Uqd", "Dqd", "Tqd", "Qaqd", "Qiqd", "Sxqd", "Spqd", "Ocqd", "Noqd", -- 10^123 to 10^150
    }

    function NumberConverter.Format(value)
        local number = tonumber(value)
        if not number then return value end
        if number < 1000 then return tostring(number) end

        local suffixIndex = math.floor(math.log10(number) / 3)
        local shortValue = number / (10 ^ (suffixIndex * 3))
        
        if suffixIndex > 0 and suffixIndex <= #extendedSuffixes then
            return string.format("%.2f%s", shortValue, extendedSuffixes[suffixIndex])
        else
            return string.format("%.2e", number) -- Fallback to scientific notation if it exceeds our list
        end
    end

    function NumberConverter.Parse(str)
        if type(str) == "number" then return str end
        str = tostring(str)

        -- 1. Strip rich text tags
        str = string.gsub(str, "<[^>]+>", "")

        -- 2. Strip everything from '/' onwards (e.g. '/s', '/sec')
        local slashPos = string.find(str, "/")
        if slashPos then
            str = string.sub(str, 1, slashPos - 1)
        end

        -- 3. Uppercase and remove common noise words
        str = string.upper(str)
        str = string.gsub(str, "WINS", "")
        str = string.gsub(str, "REQUIRED", "")
        str = string.gsub(str, "COST", "")
        str = string.gsub(str, "PRICE", "")
        str = string.gsub(str, "NEEDED", "")

        -- 4. Strip spaces, commas, dollars, plus size, and any non-alphanumeric noise
        str = string.gsub(str, "[^%d%.A-Z]", "")

        local numberPart = string.match(str, "^[%d%.]+")
        local suffixPart = string.match(str, "[A-Z]+$")
        
        if not numberPart then return 0 end
        local number = tonumber(numberPart)
        
        if suffixPart then
            if suffixPart == "QT" then suffixPart = "QI" end
            if suffixPart == "QD" then suffixPart = "QA" end
            
            for i, suffix in ipairs(extendedSuffixes) do
                if string.upper(suffix) == suffixPart then
                    return number * (10 ^ (i * 3))
                end
            end
        end
        return number
    end

    -- ══════════════════════════════════════════
    --              MOVEMENT TAB
    -- ══════════════════════════════════════════
    if Tabs.Movement then
        local MovementSection = Tabs.Movement:Section({
            Title = "Movement",
        })

        local currentWalkspeed = 16
        local currentJumpHeight = 7
        local normalSpeedEnabled = false
        local tweenSpeedEnabled = false
        local isSyncingSpeedToggles = false
        local NormalSpeedToggle = nil
        local TweenSpeedToggle = nil

        local activeSpeedTween = nil
        local speedTweenConnection = nil
        local TWEEN_STEP_TIME = 0.08
        local speedTweenInfo = TweenInfo.new(TWEEN_STEP_TIME, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)

        local function stopTweenSpeed()
            if activeSpeedTween then
                pcall(function()
                    activeSpeedTween:Cancel()
                end)
                activeSpeedTween = nil
            end
        end

        local function disconnectTweenSpeedLoop()
            stopTweenSpeed()
            if speedTweenConnection then
                speedTweenConnection:Disconnect()
                speedTweenConnection = nil
            end
        end

        local function applyNormalWalkSpeed(character)
            if character and character:FindFirstChild("Humanoid") then
                character.Humanoid.WalkSpeed = currentWalkspeed
            end
        end

        local function applyJumpHeight(character)
            if character and character:FindFirstChild("Humanoid") then
                character.Humanoid.JumpHeight = currentJumpHeight
            end
        end

        local function startTweenSpeedLoop()
            disconnectTweenSpeedLoop()

            speedTweenConnection = RunService.Heartbeat:Connect(function()
                if not tweenSpeedEnabled then
                    stopTweenSpeed()
                    return
                end

                local character = LocalPlayer.Character
                local humanoid = character and character:FindFirstChildOfClass("Humanoid")
                local hrp = character and character:FindFirstChild("HumanoidRootPart")

                if not humanoid or not hrp or humanoid.Health <= 0 then
                    stopTweenSpeed()
                    return
                end

                local moveDir = humanoid.MoveDirection
                if moveDir.Magnitude > 0 and currentWalkspeed > 16 then
                    local baseSpeed = humanoid.WalkSpeed
                    local extraSpeed = math.max(0, currentWalkspeed - baseSpeed)
                    if extraSpeed > 0 then
                        local offset = moveDir.Unit * (extraSpeed * TWEEN_STEP_TIME)
                        local targetCFrame = hrp.CFrame + Vector3.new(offset.X, 0, offset.Z)
                        stopTweenSpeed()
                        activeSpeedTween = TweenService:Create(hrp, speedTweenInfo, { CFrame = targetCFrame })
                        activeSpeedTween:Play()
                    else
                        stopTweenSpeed()
                    end
                else
                    stopTweenSpeed()
                end
            end)
        end

        -- Apply WalkSpeed / JumpHeight continuously every 0.5 seconds if enabled
        task.spawn(function()
            while true do
                task.wait(0.5)
                if normalSpeedEnabled then
                    applyNormalWalkSpeed(LocalPlayer.Character)
                    applyJumpHeight(LocalPlayer.Character)
                elseif tweenSpeedEnabled then
                    applyJumpHeight(LocalPlayer.Character)
                end
            end
        end)

        -- Side-by-side mutually exclusive toggles on the same line using WindUI Group
        local SpeedToggleGroup = Tabs.Movement:Group({})

        NormalSpeedToggle = SpeedToggleGroup:Toggle({
            Flag = "SpeedJumpToggle",
            Title = "Speed",
            Value = false,
            Callback = function(Value)
                if isSyncingSpeedToggles then return end
                normalSpeedEnabled = Value

                if Value then
                    if tweenSpeedEnabled then
                        isSyncingSpeedToggles = true
                        tweenSpeedEnabled = false
                        disconnectTweenSpeedLoop()
                        if TweenSpeedToggle and type(TweenSpeedToggle.Set) == "function" then
                            pcall(function() TweenSpeedToggle:Set(false) end)
                        end
                        if TweenSpeedToggle then
                            TweenSpeedToggle.Value = false
                            TweenSpeedToggle.__savedValue = false
                        end
                        isSyncingSpeedToggles = false
                    end
                    applyNormalWalkSpeed(LocalPlayer.Character)
                    applyJumpHeight(LocalPlayer.Character)
                else
                    if not tweenSpeedEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                        LocalPlayer.Character.Humanoid.WalkSpeed = 16
                        LocalPlayer.Character.Humanoid.JumpHeight = 7
                    end
                end
            end
        })

        SpeedToggleGroup:Space()

        TweenSpeedToggle = SpeedToggleGroup:Toggle({
            Flag = "TweenSpeedToggle",
            Title = "Tween Speed",
            Value = false,
            Callback = function(Value)
                if isSyncingSpeedToggles then return end
                tweenSpeedEnabled = Value

                if Value then
                    if normalSpeedEnabled then
                        isSyncingSpeedToggles = true
                        normalSpeedEnabled = false
                        if NormalSpeedToggle and type(NormalSpeedToggle.Set) == "function" then
                            pcall(function() NormalSpeedToggle:Set(false) end)
                        end
                        if NormalSpeedToggle then
                            NormalSpeedToggle.Value = false
                            NormalSpeedToggle.__savedValue = false
                        end
                        isSyncingSpeedToggles = false
                    end
                    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                        LocalPlayer.Character.Humanoid.WalkSpeed = 16
                    end
                    startTweenSpeedLoop()
                    applyJumpHeight(LocalPlayer.Character)
                else
                    disconnectTweenSpeedLoop()
                    if not normalSpeedEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                        LocalPlayer.Character.Humanoid.WalkSpeed = 16
                        LocalPlayer.Character.Humanoid.JumpHeight = 7
                    end
                end
            end
        })

        Tabs.Movement:Slider({
            Flag = "SpeedSlider",
            Title = "Speed Slider",
            Desc = "Change your Speed / Tween Speed",
            Step = 1,
            Value = { Min = 16, Max = 400, Default = 16 },
            Callback = function(Value)
                currentWalkspeed = Value
                if normalSpeedEnabled then
                    applyNormalWalkSpeed(LocalPlayer.Character)
                end
                if not tweenSpeedEnabled or currentWalkspeed <= 16 then
                    stopTweenSpeed()
                end
            end
        })

        Tabs.Movement:Slider({
            Flag = "JumpSlider",
            Title = "Jump Height Slider",
            Desc = "Change your Jump Height",
            Step = 1,
            Value = { Min = 7, Max = 100, Default = 7 },
            Callback = function(Value)
                currentJumpHeight = Value
                if normalSpeedEnabled or tweenSpeedEnabled then
                    applyJumpHeight(LocalPlayer.Character)
                end
            end
        })

        local infiniteJumpEnabled = false
        local jumpConnection

        Tabs.Movement:Toggle({
            Flag = "InfJump",
            Title = "INF Jump",
            Value = false,
            Callback = function(Value)
                infiniteJumpEnabled = Value
                if Value then
                    jumpConnection = UserInputService.JumpRequest:Connect(function()
                        if infiniteJumpEnabled then
                            local character = LocalPlayer.Character
                            if character and character:FindFirstChild("Humanoid") then
                                character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                            end
                        end
                    end)
                else
                    if jumpConnection then jumpConnection:Disconnect(); jumpConnection = nil end
                end
            end
        })

        local noclipEnabled = false
        local noclipConnection

        Tabs.Movement:Toggle({
            Flag = "NoClip",
            Title = "No Clip",
            Value = false,
            Callback = function(Value)
                noclipEnabled = Value
                if Value then
                    noclipConnection = RunService.Stepped:Connect(function()
                        if noclipEnabled then
                            local character = LocalPlayer.Character
                            if character then
                                for _, v in ipairs(character:GetDescendants()) do
                                    if v:IsA("BasePart") then v.CanCollide = false end
                                end
                            end
                        end
                    end)
                else
                    if noclipConnection then noclipConnection:Disconnect(); noclipConnection = nil end
                end
            end
        })

        local ProtectionSection = Tabs.Movement:Section({
            Title = "Protection & Proximity",
        })

        local instantPromptsEnabled = false
        local originalHoldDurations = {}
        local promptAddedConnection

        local function setPromptHoldDuration(prompt, instant)
            if instant then
                originalHoldDurations[prompt] = prompt.HoldDuration
                prompt.HoldDuration = 0
            else
                if originalHoldDurations[prompt] then
                    prompt.HoldDuration = originalHoldDurations[prompt]
                    originalHoldDurations[prompt] = nil
                end
            end
        end

        Tabs.Movement:Toggle({
            Flag = "ProximityPrompt",
            Title = "Instant Proximity Prompt",
            Value = false,
            Callback = function(Value)
                instantPromptsEnabled = Value
                if Value then
                    for _, v in ipairs(workspace:GetDescendants()) do
                        if v:IsA("ProximityPrompt") then setPromptHoldDuration(v, true) end
                    end
                    promptAddedConnection = game.DescendantAdded:Connect(function(desc)
                        if instantPromptsEnabled and desc:IsA("ProximityPrompt") then
                            setPromptHoldDuration(desc, true)
                        end
                    end)
                else
                    for _, v in ipairs(workspace:GetDescendants()) do
                        if v:IsA("ProximityPrompt") then setPromptHoldDuration(v, false) end
                    end
                    if promptAddedConnection then promptAddedConnection:Disconnect(); promptAddedConnection = nil end
                end
            end
        })
    end

    -- ══════════════════════════════════════════
    --              TELEPORT TAB
    -- ══════════════════════════════════════════
    if Tabs.Teleport then
        local BasicTeleportSection = Tabs.Teleport:Section({
            Title = "Basic Teleport",
            Box = true,
            BoxBorder = true,
            Expandable = true,
            Opened = true
        })

        local function getPlayerNames()
            local names = {}
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= LocalPlayer then table.insert(names, player.Name) end
            end
            return #names > 0 and names or {"No players found"}
        end

        local selectedPlayerName = nil

        local PlayerDropdown = BasicTeleportSection:Dropdown({
            Flag = "PlayerDropdown",
            Title = "Select Player",
            Desc = "Choose a player to teleport to",
            Values = getPlayerNames(),
            Multi = false,
            Value = "No players found",
            Callback = function(Value)
                selectedPlayerName = Value
            end
        })

        Players.PlayerAdded:Connect(function()   PlayerDropdown:Refresh(getPlayerNames()) end)
        Players.PlayerRemoving:Connect(function() PlayerDropdown:Refresh(getPlayerNames()) end)

        BasicTeleportSection:Button({
            Title = "Teleport to Selected Player",
            Desc = "Teleports you to the chosen player",
            Callback = function()
                if not selectedPlayerName or selectedPlayerName == "No players found" then
                    WindUI:Notify({ Title = "Error", Content = "No player selected!", Duration = 3 })
                    return
                end
                local targetPlayer = Players:FindFirstChild(selectedPlayerName)
                if not targetPlayer then
                    WindUI:Notify({ Title = "Error", Content = "Player not found in game!", Duration = 3 })
                    return
                end
                local targetModel = workspace:FindFirstChild(targetPlayer.Name)
                local targetCF = nil
                if targetModel and targetModel:FindFirstChild("HumanoidRootPart") then
                    targetCF = targetModel.HumanoidRootPart.CFrame + Vector3.new(0, 3, 0)
                elseif targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    targetCF = targetPlayer.Character.HumanoidRootPart.CFrame + Vector3.new(0, 3, 0)
                end
                if targetCF then
                    local character = LocalPlayer.Character
                    if character and character:FindFirstChild("HumanoidRootPart") then
                        character.HumanoidRootPart.CFrame = targetCF
                        WindUI:Notify({ Title = "Teleported!", Content = "Teleported to " .. selectedPlayerName, Duration = 3 })
                    end
                else
                    WindUI:Notify({ Title = "Error", Content = "Could not find " .. selectedPlayerName .. "'s position!", Duration = 3 })
                end
            end
        })

        local savedPos = nil

        BasicTeleportSection:Button({
            Title = "Save Current Position",
            Desc = "Stores where you are standing right now",
            Callback = function()
                local character = LocalPlayer.Character
                if character and character:FindFirstChild("HumanoidRootPart") then
                    savedPos = character.HumanoidRootPart.CFrame
                    WindUI:Notify({ Title = "Position Saved!", Content = "Current position stored.", Duration = 2 })
                else
                    WindUI:Notify({ Title = "Error", Content = "Character not found!", Duration = 2 })
                end
            end
        })

        BasicTeleportSection:Button({
            Title = "Teleport to Saved Position",
            Desc = "Teleports you back to the saved position",
            Callback = function()
                if savedPos then
                    local character = LocalPlayer.Character
                    if character and character:FindFirstChild("HumanoidRootPart") then
                        character.HumanoidRootPart.CFrame = savedPos
                        WindUI:Notify({ Title = "Teleported!", Content = "Returned to saved position.", Duration = 2 })
                    end
                else
                    WindUI:Notify({ Title = "No Position Saved", Content = "Save a position first!", Duration = 2 })
                end
            end
        })
    end

    -- ══════════════════════════════════════════
    --           SETTINGS TAB
    -- ══════════════════════════════════════════
    if Tabs.Settings then
        local ConfigSection = Tabs.Settings:Section({
            Title = "Configuration",
            Box = true,
            BoxBorder = true,
            Expandable = true,
            Opened = true
        })

        ConfigSection:Button({
            Title = "Enable Anti AFK",
            Desc = "Prevents you from being kicked for idle. Rejoin to turn off.",
            Icon = "solar:shield-bold",
            Callback = function()
                WindUI:Notify({
                    Title = "Anti AFK",
                    Content = "Anti AFK is on. Rejoin to turn it off.",
                    Duration = 5
                })
                
                local Players = game:GetService("Players")
                if getconnections then
                    for _, connection in pairs(getconnections(Players.LocalPlayer.Idled)) do
                        if connection["Disable"] then
                            connection["Disable"](connection)
                        elseif connection["Disconnect"] then
                            connection["Disconnect"](connection)
                        end
                    end
                else
                    Players.LocalPlayer.Idled:Connect(function()
                        local vu = game:GetService("VirtualUser")
                        vu:CaptureController()
                        vu:ClickButton2(Vector2.new())
                    end)
                end
            end
        })

        -- Custom Global Configuration System (Not Locked Per Game)
        local ConfigFolder = "PXH_Configs"
        local HttpService = game:GetService("HttpService")
        local autoloadFile = "PXH_AutoLoad.json"

        if isfolder and not isfolder(ConfigFolder) then
            pcall(makefolder, ConfigFolder)
        end

        local function GetGameConfigs()
            local list = {}
            local seen = {}
            if listfiles then
                pcall(function()
                    for _, file in ipairs(listfiles(ConfigFolder)) do
                        local filename = string.match(file, "([^/\\]+)%.json$")
                        if filename then
                            local stripped = string.match(filename, "^%d+_(.+)$") or filename
                            if stripped and stripped ~= "" and not seen[stripped] then
                                table.insert(list, stripped)
                                seen[stripped] = true
                            end
                        end
                    end
                end)
            end
            return list
        end

        local function getElementCurrentValue(obj)
            if type(obj) ~= "table" then return nil end
            local elemType = obj.__type or obj.Type
            if elemType == "Slider" or (type(obj.Value) == "table" and obj.Value.Default ~= nil) then
                if type(obj.__savedValue) == "number" then
                    return obj.__savedValue
                elseif type(obj.Value) == "table" and obj.Value.Default ~= nil then
                    return tonumber(obj.Value.Default) or obj.Value.Default
                end
            end
            if obj.__savedValue ~= nil then
                return obj.__savedValue
            end
            if obj.Value ~= nil then
                return obj.Value
            end
            return obj.State
        end

        local function unwrapSavedValue(rawVal)
            if type(rawVal) == "table" then
                if rawVal.Default ~= nil then
                    return tonumber(rawVal.Default) or rawVal.Default
                elseif rawVal.__type ~= nil and rawVal.value ~= nil then
                    return rawVal.value
                end
            end
            return rawVal
        end

        local function applyValueToElement(uiElement, rawVal)
            if type(uiElement) ~= "table" then return end
            local val = unwrapSavedValue(rawVal)
            local elemType = uiElement.__type or uiElement.Type
            local isSlider = (elemType == "Slider") or (type(uiElement.Value) == "table" and uiElement.Value.Default ~= nil)
            local isToggle = (elemType == "Toggle") or (type(val) == "boolean")

            if isSlider then
                local numVal = tonumber(val)
                if not numVal then return end
                if type(uiElement.Set) == "function" then
                    pcall(function() uiElement:Set(numVal) end)
                elseif type(uiElement.SetValue) == "function" then
                    pcall(function() uiElement:SetValue(numVal) end)
                end
                if type(uiElement.Value) == "table" then
                    uiElement.Value.Default = numVal
                end
                uiElement.__savedValue = numVal
                if type(uiElement.Callback) == "function" then
                    pcall(uiElement.Callback, numVal)
                end
            elseif isToggle then
                local boolVal = (val == true)
                if type(uiElement.Set) == "function" then
                    pcall(function() uiElement:Set(boolVal) end)
                elseif type(uiElement.SetValue) == "function" then
                    pcall(function() uiElement:SetValue(boolVal) end)
                end
                uiElement.Value = boolVal
                uiElement.__savedValue = boolVal
                if type(uiElement.Callback) == "function" then
                    pcall(uiElement.Callback, boolVal)
                end
            else
                if type(uiElement.Set) == "function" then
                    pcall(function() uiElement:Set(val) end)
                elseif type(uiElement.SetValue) == "function" then
                    pcall(function() uiElement:SetValue(val) end)
                else
                    uiElement.Value = val
                end
                uiElement.__savedValue = val
                if type(uiElement.Callback) == "function" then
                    pcall(uiElement.Callback, val)
                end
            end
        end
        
        local function SaveConfig(configName)
            if not writefile then return false end
            retrofitElements()
            local settingsToSave = {}
            local targetObj = Window.Flags or WindUI.Flags or {}
            
            for key, obj in pairs(targetObj) do
                if type(obj) == "table" and obj.Save ~= false then
                    local val = getElementCurrentValue(obj)
                    if val ~= nil then
                        settingsToSave[key] = val
                    end
                end
            end
            
            local success = pcall(function()
                local path = ConfigFolder .. "/" .. configName .. ".json"
                writefile(path, HttpService:JSONEncode(settingsToSave))
            end)
            return success
        end

        local function resolveConfigPath(configName)
            local globalPath = ConfigFolder .. "/" .. configName .. ".json"
            if isfile(globalPath) then
                return globalPath
            end
            local legacyPlacePath = ConfigFolder .. "/" .. tostring(game.PlaceId) .. "_" .. configName .. ".json"
            if isfile(legacyPlacePath) then
                return legacyPlacePath
            end
            if listfiles then
                local foundPath = nil
                pcall(function()
                    for _, file in ipairs(listfiles(ConfigFolder)) do
                        local fname = string.match(file, "([^/\\]+)%.json$")
                        if fname then
                            local stripped = string.match(fname, "^%d+_(.+)$")
                            if stripped == configName then
                                foundPath = file
                                break
                            end
                        end
                    end
                end)
                if foundPath then return foundPath end
            end
            return nil
        end

        local function LoadConfig(configName)
            if not isfile or not readfile then return false end
            retrofitElements()
            
            local path = resolveConfigPath(configName)
            if not path then return false end
            
            local success, savedSettings = pcall(function()
                return HttpService:JSONDecode(readfile(path))
            end)
            
            if success and type(savedSettings) == "table" then
                if savedSettings.__elements and type(savedSettings.__elements) == "table" then
                    savedSettings = savedSettings.__elements
                end

                local targetObj = Window.Flags or WindUI.Flags or {}

                -- Pass 1: Apply Sliders, Dropdowns, Inputs, Colorpickers first (so speed/jump values are ready before toggles activate)
                for key, rawVal in pairs(savedSettings) do
                    local uiElement = targetObj[key]
                    if uiElement then
                        local val = unwrapSavedValue(rawVal)
                        local elemType = uiElement.__type or uiElement.Type
                        local isToggle = (elemType == "Toggle") or (type(val) == "boolean")
                        if not isToggle then
                            applyValueToElement(uiElement, val)
                        end
                    end
                end

                -- Pass 2: Apply Toggles
                for key, rawVal in pairs(savedSettings) do
                    local uiElement = targetObj[key]
                    if uiElement then
                        local val = unwrapSavedValue(rawVal)
                        local elemType = uiElement.__type or uiElement.Type
                        local isToggle = (elemType == "Toggle") or (type(val) == "boolean")
                        if isToggle then
                            applyValueToElement(uiElement, val)
                        end
                    end
                end

                return true
            end
            return false
        end

        local ConfigName = ""

        local ConfigNameInput = ConfigSection:Input({
            Title = "Config Name",
            Desc = "Enter config name to save/load",
            Icon = "solar:file-text-bold",
            Save = false,
            Callback = function(value)
                ConfigName = value
            end
        })

        local GameConfigs = GetGameConfigs()
        local DefaultValue = table.find(GameConfigs, ConfigName) and ConfigName or nil

        local AllConfigsDropdown = ConfigSection:Dropdown({
            Title = "All Configs",
            Desc = "Select an existing config",
            Values = GameConfigs,
            Value = DefaultValue,
            Save = false,
            Callback = function(value)
                ConfigName = value
                ConfigNameInput:Set(value)
            end
        })

        ConfigSection:Button({
            Title = "Save Config",
            Desc = "Saves the current settings",
            Icon = "solar:diskette-bold",
            Callback = function()
                if ConfigName == "" then
                    WindUI:Notify({Title = "Error", Content = "Enter a config name first.", Duration = 3})
                    return
                end
                
                if SaveConfig(ConfigName) then
                    WindUI:Notify({
                        Title = "Config Saved",
                        Content = "Config '" .. ConfigName .. "' saved successfully.",
                        Duration = 3
                    })
                else
                    WindUI:Notify({Title = "Error", Content = "Failed to save config.", Duration = 3})
                end
                AllConfigsDropdown:Refresh(GetGameConfigs())
            end
        })

        ConfigSection:Button({
            Title = "Load Config",
            Desc = "Loads the selected settings",
            Icon = "solar:upload-bold",
            Callback = function()
                if ConfigName == "" then return end
                
                if LoadConfig(ConfigName) then
                    WindUI:Notify({
                        Title = "Config Loaded",
                        Content = "Config '" .. ConfigName .. "' loaded successfully.",
                        Duration = 3
                    })
                else
                    WindUI:Notify({
                        Title = "Error",
                        Content = "Could not load '" .. ConfigName .. "'.",
                        Duration = 3
                    })
                end
            end
        })

        ConfigSection:Button({
            Title = "Set As Auto Load (Other...)",
            Desc = "Mark selected config to automatically load next time across all games",
            Icon = "solar:check-circle-bold",
            Callback = function()
                if ConfigName == "" then
                    WindUI:Notify({Title = "Error", Content = "Select a valid config first.", Duration = 3})
                    return
                end
                pcall(function()
                    local autoloads = {
                        AutoLoadConfig = ConfigName
                    }
                    if writefile then
                        writefile(autoloadFile, HttpService:JSONEncode(autoloads))
                        WindUI:Notify({Title = "Auto Load Enabled!", Content = "'" .. ConfigName .. "' will load automatically next time.", Duration = 4})
                    end
                end)
            end
        })

        -- Auto-load logic executed once (globally, not locked by game)
        task.spawn(function()
            task.wait(1.5) -- small delay to ensure all external toggles/sliders are registered
            local loadedAuto = false
            pcall(function()
                if isfile and isfile(autoloadFile) then
                    local decoded = HttpService:JSONDecode(readfile(autoloadFile))
                    local target = nil
                    if type(decoded) == "table" then
                        target = decoded.AutoLoadConfig or decoded.global or decoded[tostring(game.PlaceId)]
                        if not target then
                            for _, v in pairs(decoded) do
                                if type(v) == "string" and v ~= "" then
                                    target = v
                                    break
                                end
                            end
                        end
                    elseif type(decoded) == "string" and decoded ~= "" then
                        target = decoded
                    end

                    if target and LoadConfig(target) then
                        loadedAuto = true
                        ConfigName = target
                        pcall(function() ConfigNameInput:Set(target) end)
                        WindUI:Notify({Title = "Auto Load", Content = "'" .. target .. "' loaded automatically!", Duration = 5})
                    end
                end
            end)
            
            -- Fallback to default if no valid auto-load was triggered
            if not loadedAuto and table.find(GetGameConfigs(), "default") then
                LoadConfig("default")
            end
        end)
    end

    -- ══════════════════════════════════════════
    --              ABOUT US TAB
    -- ══════════════════════════════════════════
    if Tabs.AboutUs then
        Tabs.AboutUs:Section({
            Title = "Prime X Links",
        })

        Tabs.AboutUs:Button({
            Title = "Sairo",
            Desc = "Click to copy Discord link (dsc.gg/sairo)",
            Icon = "solar:link-bold",
            Callback = function()
                setclipboard("dsc.gg/sairo")
                WindUI:Notify({ Title = "Copied!", Content = "Sairo link (dsc.gg/sairo) copied to clipboard.", Duration = 3 })
            end
        })

        Tabs.AboutUs:Button({
            Title = "Prime X Hub",
            Desc = "Click to copy Discord link",
            Icon = "solar:link-bold",
            Callback = function()
                setclipboard("https://discord.gg/wx2bp2DvvP")
                WindUI:Notify({ Title = "Copied!", Content = "Prime X Hub link copied to clipboard.", Duration = 3 })
            end
        })

        Tabs.AboutUs:Section({
            Title = "Feedback",
        })

        Tabs.AboutUs:Button({
            Title = "Submit Feedback",
            Desc = "Need an update / Report a bug / Any Issue with script. (15 Min Cooldown)",
            Icon = "solar:chat-round-line-bold",
            Callback = function()
                local COOLDOWN_TIME = 15 * 60
                local COOLDOWN_FILE = "PrimeX_Feedback_Cooldown.txt"
                
                local currentCooldown = 0
                if isfile and readfile and isfile(COOLDOWN_FILE) then
                    local lastTime = tonumber(readfile(COOLDOWN_FILE))
                    if lastTime then
                        local timePassed = os.time() - lastTime
                        if timePassed < COOLDOWN_TIME then
                            currentCooldown = COOLDOWN_TIME - timePassed
                        end
                    end
                end
                
                if currentCooldown > 0 then
                    local mins = math.floor(currentCooldown / 60)
                    local secs = math.floor(currentCooldown % 60)
                    local timeStr = mins .. " Min " .. secs .. " Sec"
                    
                    WindUI:Notify({
                        Title = "Cooldown Active",
                        Content = "Please wait " .. timeStr .. " before sending another feedback.",
                        Duration = 5
                    })
                    return
                end
                
                loadstring(game:HttpGet("https://raw.githubusercontent.com/wendigo5414-cmyk/FireballxArena/refs/heads/main/feedbacksystem", true))()
            end
        })

        Tabs.AboutUs:Paragraph({
            Title = "🐛 Reporting a Bug",
            Desc = "Please explain clearly: What exactly is not working? When does it happen? Does it occur at a specific time or after a certain action? Provide as much detail as possible."
        })

        Tabs.AboutUs:Paragraph({
            Title = "💡 Requesting a Feature",
            Desc = "Please think your idea through carefully and ensure it makes logical sense for the game. Don't worry about whether it is possible to code—just share your idea, and I will figure out the rest!"
        })
    end

    return NumberConverter
end
