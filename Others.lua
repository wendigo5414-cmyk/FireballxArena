return function(Window, Tabs, WindUI)
    -- ══════════════════════════════════════════
    --        AUTO-FLAG INJECTION SYSTEM
    -- ══════════════════════════════════════════
    -- 1. Proactive hooking (for UI components created AFTER this script loads)
    local function hookContainer(containerObj, tabPrefix)
        if type(containerObj) ~= "table" then return end
        
        local methodsToHook = {"Toggle", "Slider", "Dropdown", "Input", "Colorpicker", "Keybind"}
        for _, method in ipairs(methodsToHook) do
            local originalMethod = containerObj[method]
            if type(originalMethod) == "function" then
                containerObj[method] = function(self, options)
                    if options and type(options) == "table" and options.Title then
                        if not options.Flag then
                            options.Flag = "PXHRetro_" .. tostring(options.Title):gsub("[^%w]", "")
                        end
                        if options.Save == nil then
                            options.Save = true
                        end
                    end
                    local element = originalMethod(self, options)
                    -- Ensure it gets pushed to WindUI state
                    pcall(function()
                        if element and element.Flag then
                            if Window and type(Window.Flags) == "table" then Window.Flags[element.Flag] = element end
                            if WindUI and type(WindUI.Flags) == "table" then WindUI.Flags[element.Flag] = element end
                            if Window and type(Window.PendingFlags) == "table" then Window.PendingFlags[element.Flag] = element end
                            if WindUI and type(WindUI.PendingFlags) == "table" then WindUI.PendingFlags[element.Flag] = element end
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

            if obj.Type and obj.Title and type(obj.Callback) == "function" then
                if not obj.Flag then
                    obj.Flag = "PXHRetro_" .. tostring(obj.Title):gsub("[^%w]", "")
                end
                if obj.Save == nil then
                    obj.Save = true
                end
                pcall(function()
                    if obj.Flag then
                        if Window and type(Window.Flags) == "table" then Window.Flags[obj.Flag] = obj end
                        if WindUI and type(WindUI.Flags) == "table" then WindUI.Flags[obj.Flag] = obj end
                        if Window and type(Window.PendingFlags) == "table" then Window.PendingFlags[obj.Flag] = obj end
                        if WindUI and type(WindUI.PendingFlags) == "table" then WindUI.PendingFlags[obj.Flag] = obj end
                    end
                end)
            end

            for k, v in pairs(obj) do
                if type(v) == "table" then
                    pcall(scan, v)
                end
            end
        end
        pcall(scan, Window)
        pcall(scan, Tabs)
        pcall(scan, WindUI)
    end
    retrofitElements()

    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    local RunService = game:GetService("RunService")
    local UserInputService = game:GetService("UserInputService")

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
        str = string.upper(tostring(str))
        local numberPart = string.match(str, "^[%d%.]+")
        local suffixPart = string.match(str, "[A-Z]+$")
        
        if not numberPart then return 0 end
        local number = tonumber(numberPart)
        
        if suffixPart then
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
        local speedJumpEnabled = false

        local function applyWalkspeed(character)
            if character and character:FindFirstChild("Humanoid") then
                character.Humanoid.WalkSpeed = currentWalkspeed
            end
        end

        local function applyJumpHeight(character)
            if character and character:FindFirstChild("Humanoid") then
                character.Humanoid.JumpHeight = currentJumpHeight
            end
        end

        -- Apply stats continuously every 0.5 seconds if enabled
        task.spawn(function()
            while true do
                task.wait(0.5)
                if speedJumpEnabled then
                    applyWalkspeed(LocalPlayer.Character)
                    applyJumpHeight(LocalPlayer.Character)
                end
            end
        end)

        Tabs.Movement:Toggle({
            Flag = "SpeedJumpToggle",
            Title = "Enable Speed & Jump",
            Value = false,
            Callback = function(Value)
                speedJumpEnabled = Value
                if Value then
                    applyWalkspeed(LocalPlayer.Character)
                    applyJumpHeight(LocalPlayer.Character)
                else
                    -- Reset to default when turned off
                    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                        LocalPlayer.Character.Humanoid.WalkSpeed = 16
                        LocalPlayer.Character.Humanoid.JumpHeight = 7
                    end
                end
            end
        })

        Tabs.Movement:Slider({
            Flag = "SpeedSlider",
            Title = "Speed Slider",
            Desc = "Change your WalkSpeed",
            Step = 1,
            Value = { Min = 16, Max = 400, Default = 16 },
            Callback = function(Value)
                currentWalkspeed = Value
                if speedJumpEnabled then
                    applyWalkspeed(LocalPlayer.Character)
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
                if speedJumpEnabled then
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
            Title = "Proximity Prompt",
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
        local TeleportSection = Tabs.Teleport:Section({
            Title = "Player Teleport",
        })

        local function getPlayerNames()
            local names = {}
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= LocalPlayer then table.insert(names, player.Name) end
            end
            return #names > 0 and names or {"No players found"}
        end

        local selectedPlayerName = nil

        local PlayerDropdown = Tabs.Teleport:Dropdown({
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

        Tabs.Teleport:Button({
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

        local PositionMemorySection = Tabs.Teleport:Section({
            Title = "Position Memory",
        })

        local savedPos = nil

        Tabs.Teleport:Button({
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

        Tabs.Teleport:Button({
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
        })

        -- Custom Configuration System
        local ConfigFolder = "PXH_Configs"
        local HttpService = game:GetService("HttpService")
        local autoloadFile = "PXH_AutoLoad.json"

        if isfolder and not isfolder(ConfigFolder) then
            pcall(makefolder, ConfigFolder)
        end

        local function GetGameConfigs()
            local prefix = tostring(game.PlaceId) .. "_"
            local list = {}
            local seen = {}
            if listfiles then
                pcall(function()
                    for _, file in ipairs(listfiles(ConfigFolder)) do
                        -- Extract filename without path and without .json extension
                        local filename = string.match(file, "([^/\\]+)%.json$")
                        if filename then
                            if string.sub(filename, 1, string.len(prefix)) == prefix then
                                local stripped = string.sub(filename, string.len(prefix) + 1)
                                if not seen[stripped] then
                                    table.insert(list, stripped)
                                    seen[stripped] = true
                                end
                            elseif not string.match(filename, "^%d+_") then
                                if not seen[filename] then
                                    table.insert(list, filename)
                                    seen[filename] = true
                                end
                            end
                        end
                    end
                end)
            end
            return list
        end
        
        local function SaveConfig(configName)
            if not writefile then return false end
            local settingsToSave = {}
            local targetObj = Window.Flags or WindUI.Flags or {}
            
            for key, obj in pairs(targetObj) do
                if type(obj) == "table" and obj.Save ~= false then
                    -- Detect WindUI elements values. They usually use .Value or .State, etc.
                    local val = obj.Value
                    if val == nil then val = obj.State end
                    -- Save it
                    settingsToSave[key] = val
                end
            end
            
            local success, err = pcall(function()
                local path = ConfigFolder .. "/" .. tostring(game.PlaceId) .. "_" .. configName .. ".json"
                writefile(path, HttpService:JSONEncode(settingsToSave))
            end)
            return success
        end

        local function LoadConfig(configName)
            if not isfile or not readfile then return false end
            
            local path = ConfigFolder .. "/" .. tostring(game.PlaceId) .. "_" .. configName .. ".json"
            if not isfile(path) then 
                path = ConfigFolder .. "/" .. configName .. ".json" -- legacy fallback
                if not isfile(path) then return false end
            end
            
            local success, savedSettings = pcall(function()
                return HttpService:JSONDecode(readfile(path))
            end)
            
            if success and type(savedSettings) == "table" then
                local targetObj = Window.Flags or WindUI.Flags or {}
                for key, val in pairs(savedSettings) do
                    local uiElement = targetObj[key]
                    if uiElement and type(uiElement.Set) == "function" then
                        pcall(function() uiElement:Set(val) end)
                    end
                end
                return true
            end
            return false
        end

        local ConfigName = ""

        local ConfigNameInput = Tabs.Settings:Input({
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

        local AllConfigsDropdown = Tabs.Settings:Dropdown({
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

        Tabs.Settings:Button({
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

        Tabs.Settings:Button({
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
        
        Tabs.Settings:Button({
            Title = "Set As Auto Load (Other...)",
            Desc = "Mark selected config to automatically load next time",
            Icon = "solar:check-circle-bold",
            Callback = function()
                if ConfigName == "" then
                    WindUI:Notify({Title = "Error", Content = "Select a valid config first.", Duration = 3})
                    return
                end
                pcall(function()
                    local autoloads = {}
                    if isfile and isfile(autoloadFile) then
                        autoloads = HttpService:JSONDecode(readfile(autoloadFile))
                    end
                    autoloads[tostring(game.PlaceId)] = ConfigName
                    if writefile then
                        writefile(autoloadFile, HttpService:JSONEncode(autoloads))
                        WindUI:Notify({Title = "Auto Load Enabled!", Content = "'" .. ConfigName .. "' will load automatically next time.", Duration = 4})
                    end
                end)
            end
        })

        -- Auto-load logic executed once 
        task.spawn(function()
            task.wait(1.5) -- small delay to ensure toggles are registered
            local loadedAuto = false
            pcall(function()
                if isfile and isfile(autoloadFile) then
                    local autoloads = HttpService:JSONDecode(readfile(autoloadFile))
                    local target = autoloads[tostring(game.PlaceId)]
                    if target then
                        if LoadConfig(target) then
                            loadedAuto = true
                            WindUI:Notify({Title = "Auto Load", Content = "'" .. target .. "' loaded automatically!", Duration = 5})
                        end
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
            Title = "Prime X Store",
            Desc = "Click to copy Discord link",
            Icon = "solar:link-bold",
            Callback = function()
                setclipboard("https://discord.gg/BXAQebHqAR")
                WindUI:Notify({ Title = "Copied!", Content = "Prime X Store link copied to clipboard.", Duration = 3 })
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
