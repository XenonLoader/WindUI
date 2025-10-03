local WindUI = require("./src/init")

local Window = WindUI:CreateWindow({
    Title = "WindUI Simple Example",
    Author = "by .ftgs",
    Folder = "WindUISimple",

    Size = UDim2.fromOffset(580, 490),
    Theme = "Dark",
    Acrylic = false,

    OpenButton = {
        Title = "Open UI",
        CornerRadius = UDim.new(0, 8),
        StrokeThickness = 2,
        Enabled = true,
        Draggable = true,
        OnlyMobile = false,
        Icon = "menu",

        Color = ColorSequence.new(
            Color3.fromHex("#30FF6A"),
            Color3.fromHex("#00D9FF")
        )
    }
})

local MainSection = Window:Section({
    Title = "Main Features",
})

local WelcomeTab = MainSection:Tab({
    Title = "Welcome",
    Icon = "home",
})

WelcomeTab:Section({
    Title = "Welcome to WindUI!",
    TextSize = 20,
})

WelcomeTab:Paragraph({
    Title = "About This Example",
    Desc = [[This is a simplified example demonstrating WindUI's auto-config feature.

All UI elements are automatically saved and loaded without manual registration!

Simply create elements, then use the Config tab to save/load settings.]]
})

WelcomeTab:Space()

WelcomeTab:Image({
    Image = "https://repository-images.githubusercontent.com/880118829/428bedb1-dcbd-43d5-bc7f-3beb2e9e0177",
    AspectRatio = "16:9",
    Radius = 8,
})

local SettingsTab = MainSection:Tab({
    Title = "Settings",
    Icon = "settings",
})

SettingsTab:Section({
    Title = "General Settings",
})

SettingsTab:Toggle({
    Title = "Feature One",
    Desc = "Enable or disable feature one",
    Value = false,
    Callback = function(value)
        print("Feature One:", value)
    end
})

SettingsTab:Toggle({
    Title = "Feature Two",
    Desc = "Enable or disable feature two",
    Value = true,
    Callback = function(value)
        print("Feature Two:", value)
    end
})

SettingsTab:Space()

SettingsTab:Slider({
    Title = "Speed",
    Desc = "Adjust speed value",
    Value = { Min = 1, Max = 100, Default = 50 },
    Callback = function(value)
        print("Speed:", value)
    end
})

SettingsTab:Slider({
    Title = "Power",
    Desc = "Adjust power level",
    Value = { Min = 0, Max = 10, Default = 5 },
    Callback = function(value)
        print("Power:", value)
    end
})

SettingsTab:Space()

SettingsTab:Section({
    Title = "Selection Options",
})

SettingsTab:Dropdown({
    Title = "Choose Mode",
    Desc = "Select operation mode",
    Values = {"Easy", "Normal", "Hard", "Expert"},
    Value = "Normal",
    Multi = false,
    Callback = function(value)
        print("Mode:", value)
    end
})

SettingsTab:Dropdown({
    Title = "Select Items",
    Desc = "Choose multiple items",
    Values = {"Item A", "Item B", "Item C", "Item D", "Item E"},
    Value = {},
    Multi = true,
    AllowNone = true,
    Callback = function(values)
        print("Items:", table.concat(values, ", "))
    end
})

SettingsTab:Space()

SettingsTab:Input({
    Title = "Username",
    Desc = "Enter your username",
    PlaceholderText = "Type here...",
    Callback = function(text)
        print("Username:", text)
    end
})

SettingsTab:Space()

SettingsTab:Colorpicker({
    Title = "Theme Color",
    Desc = "Pick your favorite color",
    Default = Color3.fromHex("#30FF6A"),
    Callback = function(color)
        print("Color:", color)
    end
})

SettingsTab:Space()

SettingsTab:Keybind({
    Title = "Toggle Keybind",
    Desc = "Set keybind to toggle",
    Default = Enum.KeyCode.RightShift,
    Callback = function(key)
        print("Keybind:", key.Name)
    end
})

local ButtonsTab = MainSection:Tab({
    Title = "Buttons",
    Icon = "mouse-pointer-click",
})

ButtonsTab:Section({
    Title = "Action Buttons",
})

ButtonsTab:Button({
    Title = "Execute Action",
    Desc = "Click to execute",
    Icon = "play",
    Callback = function()
        WindUI:Notify({
            Title = "Action",
            Content = "Action executed!",
            Duration = 2
        })
    end
})

ButtonsTab:Space()

ButtonsTab:Button({
    Title = "Refresh Data",
    Desc = "Reload all data",
    Icon = "refresh-cw",
    Color = Color3.fromHex("#00D9FF"),
    Callback = function()
        WindUI:Notify({
            Title = "Refresh",
            Content = "Data refreshed!",
            Duration = 2
        })
    end
})

ButtonsTab:Space()

ButtonsTab:Button({
    Title = "Reset Settings",
    Desc = "Reset to defaults",
    Icon = "rotate-ccw",
    Color = Color3.fromHex("#FFA500"),
    Callback = function()
        WindUI:Notify({
            Title = "Reset",
            Content = "Settings reset!",
            Duration = 2
        })
    end
})

ButtonsTab:Space()

local HighlightButton
HighlightButton = ButtonsTab:Button({
    Title = "Highlight Test",
    Desc = "Test highlight effect",
    Icon = "zap",
    Callback = function()
        HighlightButton:Highlight()
        WindUI:Notify({
            Title = "Highlight",
            Content = "Button highlighted!",
            Duration = 1
        })
    end
})

local ConfigSection = Window:Section({
    Title = "Configuration",
})

local ConfigTab = ConfigSection:Tab({
    Title = "Config Manager",
    Icon = "save",
})

ConfigTab:Section({
    Title = "Auto Config System",
    TextSize = 18,
})

ConfigTab:Paragraph({
    Title = "How It Works",
    Desc = [[The Config Manager automatically tracks all your UI elements.

No manual registration needed
All settings saved automatically
Load configs instantly
Uses element titles as keys

Just save and load - it's that simple!]]
})

ConfigTab:Space()

local ConfigManager = Window.ConfigManager
local configFile = nil
local configName = ""
local selectedConfig = ""

if ConfigManager then
    ConfigManager:Init(Window)

    local function getConfigList()
        local configs = {}
        pcall(function()
            if ConfigManager.AllConfigs then
                configs = ConfigManager:AllConfigs()
            end
        end)
        table.sort(configs)
        return configs
    end

    ConfigTab:Section({
        Title = "Load Configuration",
        Icon = "folder-open"
    })

    local configDropdown = ConfigTab:Dropdown({
        Title = "Select Config",
        Desc = "Choose a config to load",
        Multi = false,
        AllowNone = true,
        Values = getConfigList(),
        Callback = function(selected)
            selectedConfig = selected
        end
    })

    ConfigTab:Button({
        Title = "Refresh List",
        Desc = "Update config list",
        Icon = "refresh-cw",
        Callback = function()
            local configs = getConfigList()
            configDropdown:Refresh(configs)
            WindUI:Notify({
                Title = "Refreshed",
                Content = #configs .. " config(s) found",
                Duration = 2,
            })
        end
    })

    ConfigTab:Button({
        Title = "Load Config",
        Desc = "Load selected configuration",
        Icon = "download",
        Color = Color3.fromHex("#00D9FF"),
        Callback = function()
            if selectedConfig ~= "" and selectedConfig ~= nil then
                local success = pcall(function()
                    configFile = ConfigManager:CreateConfig(selectedConfig)
                    configFile:Load()
                end)

                if success then
                    task.wait(0.1)
                    configDropdown:Select(selectedConfig)

                    WindUI:Notify({
                        Title = "Success",
                        Content = "Config '" .. selectedConfig .. "' loaded!",
                        Duration = 3,
                    })
                else
                    WindUI:Notify({
                        Title = "Error",
                        Content = "Failed to load config",
                        Duration = 3,
                    })
                end
            else
                WindUI:Notify({
                    Title = "Warning",
                    Content = "Please select a config first!",
                    Duration = 2,
                })
            end
        end
    })

    ConfigTab:Space()

    ConfigTab:Section({
        Title = "Save Configuration",
        Icon = "save"
    })

    ConfigTab:Input({
        Title = "Config Name",
        Desc = "Name for your config",
        PlaceholderText = "my_config",
        Callback = function(text)
            configName = text
        end
    })

    ConfigTab:Button({
        Title = "Save New Config",
        Desc = "Create new configuration",
        Icon = "plus-circle",
        Color = Color3.fromHex("#30FF6A"),
        Callback = function()
            if configName ~= "" and configName ~= " " then
                local success = pcall(function()
                    configFile = ConfigManager:CreateConfig(configName)
                    configFile:Set("createdAt", os.date("%Y-%m-%d %H:%M:%S"))
                    configFile:Save()
                end)

                if success then
                    selectedConfig = configName

                    WindUI:Notify({
                        Title = "Saved",
                        Content = "Config '" .. configName .. "' created!",
                        Duration = 3,
                    })
                else
                    WindUI:Notify({
                        Title = "Error",
                        Content = "Failed to save config",
                        Duration = 3,
                    })
                end
            else
                WindUI:Notify({
                    Title = "Warning",
                    Content = "Please enter a config name!",
                    Duration = 2,
                })
            end
        end
    })

    ConfigTab:Button({
        Title = "Overwrite Selected",
        Desc = "Update existing config",
        Icon = "upload",
        Color = Color3.fromHex("#FFA500"),
        Callback = function()
            if selectedConfig ~= "" then
                configFile = ConfigManager:CreateConfig(selectedConfig)
                configFile:Set("updatedAt", os.date("%Y-%m-%d %H:%M:%S"))

                if configFile:Save() then
                    WindUI:Notify({
                        Title = "Saved",
                        Content = "Config '" .. selectedConfig .. "' updated!",
                        Duration = 3,
                    })
                else
                    WindUI:Notify({
                        Title = "Error",
                        Content = "Failed to save!",
                        Duration = 3,
                    })
                end
            else
                WindUI:Notify({
                    Title = "Warning",
                    Content = "Please select a config first!",
                    Duration = 2,
                })
            end
        end
    })

    ConfigTab:Space()

    ConfigTab:Section({
        Title = "Manage Configs",
        Icon = "trash-2"
    })

    ConfigTab:Button({
        Title = "Delete Config",
        Desc = "Remove selected config",
        Icon = "trash-2",
        Color = Color3.fromHex("#FF4444"),
        Callback = function()
            if selectedConfig ~= "" and selectedConfig ~= nil then
                local filePath = ConfigManager.Path .. selectedConfig .. ".json"

                if isfile(filePath) then
                    delfile(filePath)

                    WindUI:Notify({
                        Title = "Deleted",
                        Content = "Config '" .. selectedConfig .. "' removed!",
                        Duration = 3,
                    })
                    selectedConfig = ""
                else
                    WindUI:Notify({
                        Title = "Error",
                        Content = "Config file not found!",
                        Duration = 3,
                    })
                end
            else
                WindUI:Notify({
                    Title = "Warning",
                    Content = "Please select a config to delete!",
                    Duration = 2,
                })
            end
        end
    })

    ConfigTab:Space()

    ConfigTab:Section({
        Title = "Information",
        Icon = "info"
    })

    ConfigTab:Button({
        Title = "View Element Count",
        Desc = "Show registered elements",
        Icon = "list",
        Callback = function()
            local count = 0
            local types = {}

            if Window.AllElements then
                for _, element in ipairs(Window.AllElements) do
                    if element and element.__type then
                        count = count + 1
                        types[element.__type] = (types[element.__type] or 0) + 1
                    end
                end
            end

            local typesList = ""
            for elementType, typeCount in pairs(types) do
                typesList = typesList .. elementType .. ": " .. typeCount .. "\n"
            end

            WindUI:Notify({
                Title = "Elements Info",
                Content = "Total: " .. count .. "\n\n" .. typesList,
                Duration = 5,
            })
        end
    })

    ConfigTab:Code({
        Title = "Storage Path",
        Code = ConfigManager.Path or "Unknown",
        OnCopy = function()
            setclipboard(ConfigManager.Path)
            WindUI:Notify({
                Title = "Copied",
                Content = "Path copied to clipboard!",
                Duration = 2
            })
        end
    })

else
    ConfigTab:Paragraph({
        Title = "Error",
        Desc = "ConfigManager is not available. Please check your setup.",
    })
end

Window:SelectTab(1)

print("WindUI Simple Example loaded!")
