-- [[ KEY SYSTEM LOADER ]] --
local KeySystem = loadstring(game:HttpGet("https://raw.githubusercontent.com/wendigo5414-cmyk/scripts/refs/heads/main/keysystem.lua"))()
KeySystem.Init()

-- [[ GAME SCRIPT START ]] --
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local Window = Fluent:CreateWindow({
    Title = "Prime X Hub",
    SubTitle = "",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

local Tabs = {
    Main = Window:AddTab({ Title = "Main", Icon = "home" }),
    -- Example = Window:AddTab({ Title = "Example", Icon = "book" }), -- Commented out to hide from user
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

local Options = Fluent.Options

-- [[ MOBILE BUTTON LOGIC ]] --
local MobileGui = Instance.new("ScreenGui")
MobileGui.Name = "PrimeXHubMobile"
MobileGui.Parent = game.CoreGui
MobileGui.Enabled = true -- Default ON

local MobBtn = Instance.new("ImageButton")
MobBtn.Parent = MobileGui
MobBtn.Size = UDim2.new(0, 50, 0, 50)
MobBtn.Position = UDim2.new(0.1, 0, 0.2, 0)
MobBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
MobBtn.BackgroundTransparency = 0.5
MobBtn.Image = "rbxassetid://111389972632079" -- Updated Asset ID
MobBtn.Active = true

local uic = Instance.new("UICorner")
uic.CornerRadius = UDim.new(1, 0)
uic.Parent = MobBtn

-- Dragging Logic
local UserInputService = game:GetService("UserInputService")
local dragging, dragInput, dragStart, startPos
local function update(input)
    local delta = input.Position - dragStart
    MobBtn.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end
MobBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MobBtn.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)
MobBtn.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then update(input) end
end)

-- Click to Toggle Window
MobBtn.MouseButton1Click:Connect(function()
    Window:Minimize()
end)

-- [[ SETTINGS: MOBILE BUTTON TOGGLE ]] --
Tabs.Settings:AddToggle("MobileButton", {Title = "Mobile (GUI - Open/Close) ICON", Default = true })
Options.MobileButton:OnChanged(function()
    MobileGui.Enabled = Options.MobileButton.Value
end)


-- [[ EXAMPLE CONTENT (COMMENTED OUT FOR REFERENCE) ]] --
--[[ 
do
    Fluent:Notify({
        Title = "Notification",
        Content = "Script Loaded",
        SubContent = "Prime X Hub",
        Duration = 5
    })

    -- NOTE: To use these, you must uncomment the Example tab in the Tabs table above.

    Tabs.Example:AddParagraph({
        Title = "Paragraph",
        Content = "This is a paragraph.\nSecond line!"
    })

    Tabs.Example:AddButton({
        Title = "Button",
        Description = "Very important button",
        Callback = function()
            Window:Dialog({
                Title = "Title",
                Content = "This is a dialog",
                Buttons = {
                    {
                        Title = "Confirm",
                        Callback = function()
                            print("Confirmed the dialog.")
                        end
                    },
                    {
                        Title = "Cancel",
                        Callback = function()
                            print("Cancelled the dialog.")
                        end
                    }
                }
            })
        end
    })

    local Toggle = Tabs.Example:AddToggle("MyToggle", {Title = "Toggle", Default = false })
    Toggle:OnChanged(function()
        print("Toggle changed:", Options.MyToggle.Value)
    end)
    Options.MyToggle:SetValue(false)

    local Slider = Tabs.Example:AddSlider("Slider", {
        Title = "Slider",
        Description = "This is a slider",
        Default = 2,
        Min = 0,
        Max = 5,
        Rounding = 1,
        Callback = function(Value)
            print("Slider was changed:", Value)
        end
    })
    Slider:OnChanged(function(Value)
        print("Slider changed:", Value)
    end)
    Slider:SetValue(3)

    local Dropdown = Tabs.Example:AddDropdown("Dropdown", {
        Title = "Dropdown",
        Values = {"one", "two", "three", "four", "five", "six", "seven", "eight", "nine", "ten", "eleven", "twelve", "thirteen", "fourteen"},
        Multi = false,
        Default = 1,
    })
    Dropdown:SetValue("four")
    Dropdown:OnChanged(function(Value)
        print("Dropdown changed:", Value)
    end)

    local MultiDropdown = Tabs.Example:AddDropdown("MultiDropdown", {
        Title = "Dropdown",
        Description = "You can select multiple values.",
        Values = {"one", "two", "three", "four", "five", "six", "seven", "eight", "nine", "ten", "eleven", "twelve", "thirteen", "fourteen"},
        Multi = true,
        Default = {"seven", "twelve"},
    })
    MultiDropdown:SetValue({
        three = true,
        five = true,
        seven = false
    })
    MultiDropdown:OnChanged(function(Value)
        local Values = {}
        for Value, State in next, Value do
            table.insert(Values, Value)
        end
        print("Mutlidropdown changed:", table.concat(Values, ", "))
    end)

    local Colorpicker = Tabs.Example:AddColorpicker("Colorpicker", {
        Title = "Colorpicker",
        Default = Color3.fromRGB(96, 205, 255)
    })
    Colorpicker:OnChanged(function()
        print("Colorpicker changed:", Colorpicker.Value)
    end)
    Colorpicker:SetValueRGB(Color3.fromRGB(0, 255, 140))

    local TColorpicker = Tabs.Example:AddColorpicker("TransparencyColorpicker", {
        Title = "Colorpicker",
        Description = "but you can change the transparency.",
        Transparency = 0,
        Default = Color3.fromRGB(96, 205, 255)
    })
    TColorpicker:OnChanged(function()
        print("TColorpicker changed:", TColorpicker.Value, "Transparency:", TColorpicker.Transparency)
    end)

    local Keybind = Tabs.Example:AddKeybind("Keybind", {
        Title = "KeyBind",
        Mode = "Toggle", 
        Default = "LeftControl",
        Callback = function(Value)
            print("Keybind clicked!", Value)
        end,
        ChangedCallback = function(New)
            print("Keybind changed!", New)
        end
    })
    Keybind:OnClick(function()
        print("Keybind clicked:", Keybind:GetState())
    end)
    Keybind:OnChanged(function()
        print("Keybind changed:", Keybind.Value)
    end)
    task.spawn(function()
        while true do
            wait(1)
            local state = Keybind:GetState()
            if state then
                print("Keybind is being held down")
            end
            if Fluent.Unloaded then break end
        end
    end)
    Keybind:SetValue("MB2", "Toggle")

    local Input = Tabs.Example:AddInput("Input", {
        Title = "Input",
        Default = "Default",
        Placeholder = "Placeholder",
        Numeric = false, 
        Finished = false, 
        Callback = function(Value)
            print("Input changed:", Value)
        end
    })
    Input:OnChanged(function()
        print("Input updated:", Input.Value)
    end)
end
]]

-- Managers
SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({})
InterfaceManager:SetFolder("PrimeXHub")
SaveManager:SetFolder("PrimeXHub/specific-game")
InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)

Window:SelectTab(1)
SaveManager:LoadAutoloadConfig()

-- [[ CLEANUP LOGIC ]] --
-- Destroys the Mobile Button when the script is unloaded (e.g., User presses 'X' on window)
task.spawn(function()
    while true do
        task.wait(1)
        if Fluent.Unloaded then
            if MobileGui then
                MobileGui:Destroy()
            end
            break
        end
    end
end)
