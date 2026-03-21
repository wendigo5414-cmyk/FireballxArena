return function(Window, Tabs, WindUI)
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

        -- Apply stats continuously every 2 seconds
        task.spawn(function()
            while true do
                task.wait(2)
                applyWalkspeed(LocalPlayer.Character)
                applyJumpHeight(LocalPlayer.Character)
            end
        end)

        Tabs.Movement:Slider({
            Flag = "SpeedSlider",
            Title = "Speed Slider",
            Desc = "Change your WalkSpeed",
            Step = 1,
            Value = { Min = 16, Max = 400, Default = 16 },
            Callback = function(Value)
                currentWalkspeed = Value
                applyWalkspeed(LocalPlayer.Character)
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
                applyJumpHeight(LocalPlayer.Character)
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

        local ConfigManager = Window.ConfigManager
        local ConfigName = "default"

        local ConfigNameInput = Tabs.Settings:Input({
            Title = "Config Name",
            Desc = "Enter config name to save/load",
            Icon = "solar:file-text-bold",
            Callback = function(value)
                ConfigName = value
            end
        })

        local AllConfigs = ConfigManager:AllConfigs()
        local DefaultValue = table.find(AllConfigs, ConfigName) and ConfigName or nil

        local AllConfigsDropdown = Tabs.Settings:Dropdown({
            Title = "All Configs",
            Desc = "Select an existing config",
            Values = AllConfigs,
            Value = DefaultValue,
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
                Window.CurrentConfig = ConfigManager:Config(ConfigName)
                if Window.CurrentConfig:Save() then
                    WindUI:Notify({
                        Title = "Config Saved",
                        Content = "Config '" .. ConfigName .. "' saved successfully",
                        Duration = 3
                    })
                end
                AllConfigsDropdown:Refresh(ConfigManager:AllConfigs())
            end
        })

        Tabs.Settings:Button({
            Title = "Load Config",
            Desc = "Loads the selected settings",
            Icon = "solar:upload-bold",
            Callback = function()
                Window.CurrentConfig = ConfigManager:CreateConfig(ConfigName)
                if Window.CurrentConfig:Load() then
                    WindUI:Notify({
                        Title = "Config Loaded",
                        Content = "Config '" .. ConfigName .. "' loaded successfully",
                        Duration = 3
                    })
                end
            end
        })
        
        -- Auto-load the default config if it exists
        task.spawn(function()
            if table.find(ConfigManager:AllConfigs(), "default") then
                Window.CurrentConfig = ConfigManager:CreateConfig("default")
                Window.CurrentConfig:Load()
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
            Title = "Feedback Guidelines",
            Desc = "🐛 Reporting a Bug:\nPlease explain clearly: What exactly is not working? When does it happen? Does it occur at a specific time or after a certain action? Provide as much detail as possible.\n\n💡 Requesting a Feature:\nPlease think your idea through carefully and ensure it makes logical sense for the game. Don't worry about whether it is possible to code—just share your idea, and I will figure out the rest!"
        })
    end

    return NumberConverter
end
