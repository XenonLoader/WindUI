local WindUI = require("./src/init")

local Window = WindUI:CreateWindow({
    Title = "Simplified Config Example",
    Author = "by .ftgs",
    Folder = "SimplifiedExample",
    Size = UDim2.fromOffset(580, 490),
    Theme = "Dark",
})

local MainSection = Window:Section({
    Title = "Features",
    Opened = true
})

local MainTab = MainSection:Tab({
    Title = "Main",
    Icon = "home",
})

MainTab:Toggle({
    Title = "Auto Farm",
    Value = false,
    Callback = function(value)
        print("Auto Farm:", value)
    end
})

MainTab:Dropdown({
    Title = "Select Weapon",
    Values = {"Sword", "Bow", "Staff"},
    Multi = true,
    Callback = function(selected)
        print("Selected weapons:", table.concat(selected, ", "))
    end
})

MainTab:Slider({
    Title = "Speed",
    Value = { Min = 0, Max = 100, Default = 50 },
    Callback = function(value)
        print("Speed:", value)
    end
})

MainTab:Input({
    Title = "Username",
    PlaceholderText = "Enter username",
    Callback = function(text)
        print("Username:", text)
    end
})

local ConfigTab = MainSection:Tab({
    Title = "Configuration",
    Icon = "settings",
})

local ConfigManager = Window.ConfigManager
if ConfigManager then
    ConfigManager:Init(Window)

    local configName = ""
    local selectedConfig = ""

    ConfigTab:Section({ Title = "Save Configuration" })

    ConfigTab:Input({
        Title = "Config Name",
        PlaceholderText = "Enter config name",
        Callback = function(text)
            configName = text
        end
    })

    ConfigTab:Button({
        Title = "Save Config",
        Desc = "Config akan otomatis menyimpan semua elemen",
        Callback = function()
            if configName ~= "" then
                local configFile = ConfigManager:CreateConfig(configName)
                configFile:Save()

                WindUI:Notify({
                    Title = "Tersimpan",
                    Content = "Config '" .. configName .. "' berhasil disimpan!",
                    Duration = 3,
                })
            else
                WindUI:Notify({
                    Title = "Error",
                    Content = "Masukkan nama config!",
                    Duration = 3,
                })
            end
        end
    })

    ConfigTab:Section({ Title = "Load Configuration" })

    local function getConfigList()
        return ConfigManager:AllConfigs()
    end

    local configDropdown = ConfigTab:Dropdown({
        Title = "Select Config",
        Values = getConfigList(),
        Multi = false,
        Callback = function(selected)
            selectedConfig = selected
        end
    })

    ConfigTab:Button({
        Title = "Refresh List",
        Icon = "refresh-cw",
        Callback = function()
            local configs = getConfigList()
            configDropdown:Refresh(configs)
            WindUI:Notify({
                Title = "Refreshed",
                Content = #configs .. " configs found",
                Duration = 2,
            })
        end
    })

    ConfigTab:Button({
        Title = "Load Config",
        Callback = function()
            if selectedConfig ~= "" then
                local configFile = ConfigManager:CreateConfig(selectedConfig)
                configFile:Load()

                WindUI:Notify({
                    Title = "Loaded",
                    Content = "Config '" .. selectedConfig .. "' berhasil dimuat!",
                    Duration = 3,
                })
            else
                WindUI:Notify({
                    Title = "Error",
                    Content = "Pilih config terlebih dahulu!",
                    Duration = 3,
                })
            end
        end
    })

    ConfigTab:Button({
        Title = "Overwrite Config",
        Callback = function()
            if selectedConfig ~= "" then
                local configFile = ConfigManager:CreateConfig(selectedConfig)
                configFile:Save()

                WindUI:Notify({
                    Title = "Saved",
                    Content = "Config '" .. selectedConfig .. "' diperbarui!",
                    Duration = 3,
                })
            else
                WindUI:Notify({
                    Title = "Error",
                    Content = "Pilih config terlebih dahulu!",
                    Duration = 3,
                })
            end
        end
    })

    ConfigTab:Button({
        Title = "Delete Config",
        Color = Color3.fromHex("#ff4830"),
        Callback = function()
            if selectedConfig ~= "" then
                local filePath = ConfigManager.Path .. selectedConfig .. ".json"
                if isfile(filePath) then
                    delfile(filePath)
                    WindUI:Notify({
                        Title = "Deleted",
                        Content = "Config '" .. selectedConfig .. "' dihapus!",
                        Duration = 3,
                    })
                    configDropdown:Refresh(getConfigList())
                end
            else
                WindUI:Notify({
                    Title = "Error",
                    Content = "Pilih config terlebih dahulu!",
                    Duration = 3,
                })
            end
        end
    })
end

Window:SelectTab(1)
