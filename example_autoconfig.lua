local WindUI = require("./src/init")

local Window = WindUI:CreateWindow({
    Title = "WindUI Auto Config Example",
    Author = "by .ftgs • Footagesus",
    Folder = "WindUIAutoConfigExample",
    NewElements = true,

    HideSearchBar = false,

    OpenButton = {
        Title = "Open Example UI",
        CornerRadius = UDim.new(1,0),
        StrokeThickness = 3,
        Enabled = true,
        Draggable = true,
        OnlyMobile = false,

        Color = ColorSequence.new(
            Color3.fromHex("#30FF6A"),
            Color3.fromHex("#e7ff2f")
        )
    }
})

local MainSection = Window:Section({
    Title = "Main Settings",
})

local SettingsTab = MainSection:Tab({
    Title = "Settings",
    Icon = "settings",
})

SettingsTab:Section({
    Title = "Auto Config Example",
    TextSize = 18,
})

SettingsTab:Paragraph({
    Title = "How Auto Config Works",
    Desc = "All elements are automatically registered when you save or load. No need to manually register each element!"
})

SettingsTab:Space()

SettingsTab:Toggle({
    Title = "Auto Farm",
    Desc = "Enable auto farming",
    Value = false,
})

SettingsTab:Toggle({
    Title = "Auto Collect",
    Desc = "Automatically collect items",
    Value = true,
})

SettingsTab:Space()

SettingsTab:Slider({
    Title = "Speed Multiplier",
    Desc = "Adjust movement speed",
    Value = { Min = 1, Max = 10, Default = 5 },
})

SettingsTab:Space()

SettingsTab:Dropdown({
    Title = "Select Weapon",
    Values = {"Sword", "Bow", "Staff", "Axe"},
    Value = "Sword",
    Multi = false,
})

SettingsTab:Dropdown({
    Title = "Select Items",
    Values = {"Health Potion", "Mana Potion", "Speed Boost", "Shield"},
    Value = {},
    Multi = true,
    AllowNone = true,
})

SettingsTab:Space()

SettingsTab:Input({
    Title = "Player Name",
    PlaceholderText = "Enter your name",
})

SettingsTab:Space()

SettingsTab:Colorpicker({
    Title = "Theme Color",
    Default = Color3.fromHex("#30FF6A"),
})

SettingsTab:Space()

SettingsTab:Keybind({
    Title = "Toggle UI",
    Default = Enum.KeyCode.RightShift,
})

local ConfigTab = MainSection:Tab({
    Title = "Configuration",
    Icon = "save",
})

ConfigTab:Section({
    Title = "Auto Register Config System",
    TextSize = 18,
})

ConfigTab:Paragraph({
    Title = "About Auto Register",
    Desc = [[This example uses the AutoRegisterElements feature from ConfigManager.

All UI elements are automatically tracked by Window.AllElements and registered when you save/load configs.

Features:
• No manual :Register() calls needed
• All elements auto-saved
• All elements auto-loaded
• Uses element Title as key]]
})

local ConfigManager = Window.ConfigManager
local configFile = nil
local configName = ""
local selectedConfig = ""

if ConfigManager then
    ConfigManager:Init(Window)

    local function getConfigList()
        if not ConfigManager then
            return {}
        end

        local configs = {}
        local success, result = pcall(function()
            if ConfigManager.AllConfigs then
                configs = ConfigManager:AllConfigs()
            end
        end)

        if not success then
            return {}
        end

        table.sort(configs)
        return configs
    end

    ConfigTab:Section({ Title = "Load Configuration", Icon = "folder-open" })

    local configFiles = getConfigList()

    local configDropdown = ConfigTab:Dropdown({
        Title = "Select Config",
        Multi = false,
        AllowNone = true,
        Values = configFiles,
        Callback = function(selected)
            selectedConfig = selected
        end
    })

    ConfigTab:Button({
        Title = "Refresh Config List",
        Desc = "Refresh available configs",
        Icon = "refresh-cw",
        Callback = function()
            local updatedConfigs = getConfigList()
            configDropdown:Refresh(updatedConfigs)
            WindUI:Notify({
                Title = "Refreshed",
                Content = #updatedConfigs .. " configs found",
                Duration = 2,
            })
        end
    })

    ConfigTab:Button({
        Title = "Load Config",
        Desc = "Load selected configuration",
        Icon = "download",
        Callback = function()
            if selectedConfig ~= "" and selectedConfig ~= nil then
                local success, err = pcall(function()
                    configFile = ConfigManager:CreateConfig(selectedConfig)

                    configFile:Load()
                end)

                if success then
                    task.wait(0.1)
                    configDropdown:Select(selectedConfig)

                    WindUI:Notify({
                        Title = "Config Loaded",
                        Content = "'" .. selectedConfig .. "' loaded successfully!",
                        Duration = 3,
                    })
                else
                    WindUI:Notify({
                        Title = "Error",
                        Content = "Failed to load: " .. tostring(err),
                        Duration = 3,
                    })
                end
            else
                WindUI:Notify({
                    Title = "Error",
                    Content = "Please select a config!",
                    Duration = 3,
                })
            end
        end
    })

    ConfigTab:Space()

    ConfigTab:Section({ Title = "Save Configuration", Icon = "save" })

    ConfigTab:Input({
        Title = "Config Name",
        PlaceholderText = "Enter config name",
        Callback = function(text)
            configName = text
        end
    })

    ConfigTab:Button({
        Title = "Save New Config",
        Desc = "Save all settings automatically",
        Icon = "save",
        Callback = function()
            if configName ~= "" and configName ~= " " then
                local success, err = pcall(function()
                    configFile = ConfigManager:CreateConfig(configName)

                    configFile:Set("lastSave", os.date("%Y-%m-%d %H:%M:%S"))
                    configFile:Save()
                end)

                if success then
                    selectedConfig = configName

                    WindUI:Notify({
                        Title = "Config Saved",
                        Content = "'" .. configName .. "' saved! (Auto-registered all elements)",
                        Duration = 3,
                    })
                else
                    WindUI:Notify({
                        Title = "Error",
                        Content = "Failed: " .. tostring(err),
                        Duration = 3,
                    })
                end
            else
                WindUI:Notify({
                    Title = "Error",
                    Content = "Enter a valid config name!",
                    Duration = 3,
                })
            end
        end
    })

    ConfigTab:Button({
        Title = "Overwrite Config",
        Desc = "Save to selected config",
        Icon = "upload",
        Callback = function()
            if selectedConfig ~= "" then
                configFile = ConfigManager:CreateConfig(selectedConfig)

                configFile:Set("lastSave", os.date("%Y-%m-%d %H:%M:%S"))

                if configFile:Save() then
                    WindUI:Notify({
                        Title = "Config Saved",
                        Content = "'" .. selectedConfig .. "' overwritten!",
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
                    Title = "Error",
                    Content = "Select a config to overwrite!",
                    Duration = 3,
                })
            end
        end
    })

    ConfigTab:Space()

    ConfigTab:Button({
        Title = "Delete Config",
        Desc = "Delete selected config",
        Icon = "trash-2",
        Color = Color3.fromHex("#ff4830"),
        Callback = function()
            if selectedConfig ~= "" and selectedConfig ~= nil then
                local filePath = ConfigManager.Path .. selectedConfig .. ".json"

                if isfile(filePath) then
                    delfile(filePath)

                    WindUI:Notify({
                        Title = "Config Deleted",
                        Content = "'" .. selectedConfig .. "' deleted!",
                        Duration = 3,
                    })
                    selectedConfig = ""
                else
                    WindUI:Notify({
                        Title = "Error",
                        Content = "Config not found!",
                        Duration = 3,
                    })
                end
            else
                WindUI:Notify({
                    Title = "Error",
                    Content = "Select a config to delete!",
                    Duration = 3,
                })
            end
        end
    })

    ConfigTab:Space()

    ConfigTab:Section({ Title = "Advanced Info", Icon = "info" })

    ConfigTab:Button({
        Title = "Show Registered Elements",
        Desc = "View all auto-registered elements",
        Icon = "list",
        Callback = function()
            local elementCount = 0
            local elementTypes = {}

            if Window.AllElements then
                for i, element in ipairs(Window.AllElements) do
                    if element and element.__type then
                        elementCount = elementCount + 1

                        local elementType = element.__type
                        elementTypes[elementType] = (elementTypes[elementType] or 0) + 1
                    end
                end
            end

            local typesList = ""
            for elementType, count in pairs(elementTypes) do
                typesList = typesList .. elementType .. ": " .. count .. "\n"
            end

            WindUI:Notify({
                Title = "Auto Registered Elements",
                Content = "Total: " .. elementCount .. " elements\n\n" .. typesList,
                Duration = 5,
            })
        end
    })

else
    ConfigTab:Paragraph({
        Title = "Config Manager Not Available",
        Desc = "ConfigManager is required for this feature.",
    })
end

Window:SelectTab(1)
