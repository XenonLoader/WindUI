-- Config Manager for WindUI
-- Enhanced version with save/delete functionality and Config Tab
local HttpService = game:GetService("HttpService")

local ConfigManager = {
    Window = nil,
    Folder = nil,
    Path = nil,
    Configs = {},
    Elements = {},
    ConfigTab = nil,
    Parser = {
        Colorpicker = {
            Save = function(obj)
                return {
                    __type = "Colorpicker",
                    value = obj.Value and obj.Value:ToHex() or "#FFFFFF",
                    transparency = obj.Transparency or 0,
                }
            end,
            Load = function(element, data)
                if element and element.Set then
                    local color = Color3.fromHex(data.value or "#FFFFFF")
                    element:Set(color, data.transparency or 0)
                end
            end
        },
        Dropdown = {
            Save = function(obj)
                return {
                    __type = "Dropdown",
                    value = obj.Value,
                    multi = obj.Multi or false,
                }
            end,
            Load = function(element, data)
                if element and element.Set then
                    element:Set(data.value)
                end
            end
        },
        Input = {
            Save = function(obj)
                return {
                    __type = "Input",
                    value = obj.Value or "",
                }
            end,
            Load = function(element, data)
                if element and element.Set then
                    element:Set(data.value or "")
                end
            end
        },
        Keybind = {
            Save = function(obj)
                return {
                    __type = "Keybind",
                    value = obj.Value,
                }
            end,
            Load = function(element, data)
                if element and element.Set then
                    element:Set(data.value)
                end
            end
        },
        Slider = {
            Save = function(obj)
                return {
                    __type = "Slider",
                    value = obj.Value or 0,
                }
            end,
            Load = function(element, data)
                if element and element.Set then
                    element:Set(data.value or 0)
                end
            end
        },
        Toggle = {
            Save = function(obj)
                return {
                    __type = "Toggle",
                    value = obj.Value or false,
                }
            end,
            Load = function(element, data)
                if element and element.Set then
                    element:Set(data.value or false)
                end
            end
        },
    }
}

function ConfigManager:Init(Window, FolderName)
    if not FolderName then
        warn("[ ConfigManager ] Folder name is not specified.")
        return false
    end

    ConfigManager.Window = Window
    ConfigManager.Folder = FolderName
    ConfigManager.Path = "WindUI/" .. tostring(ConfigManager.Folder) .. "/"
    
    -- Create folder if it doesn't exist
    pcall(function()
        makefolder("WindUI")
        makefolder(ConfigManager.Path)
    end)

    -- Create Config Tab
    ConfigManager:CreateConfigTab()

    return ConfigManager
end

function ConfigManager:CreateConfigTab()
    if not ConfigManager.Window then
        warn("[ ConfigManager ] Window not initialized")
        return
    end

    -- Create Config Tab
    ConfigManager.ConfigTab = ConfigManager.Window:Tab({
        Title = "Config",
        Icon = "save",
        Locked = false,
    })

    -- Config Management Section
    ConfigManager.ConfigTab:Section({ Title = "Config Management", Icon = "save" })

    local configNameInput = ""
    local selectedConfigName = ""

    local configNameInputElement = ConfigManager.ConfigTab:Input({
        Title = "Config Name",
        Placeholder = "Enter config name",
        Value = "",
        Callback = function(text)
            configNameInput = text or ""
        end
    })

    local configsDropdown
    local function refreshConfigsList()
        local configs = ConfigManager:GetAllConfigs()
        if configsDropdown then
            configsDropdown:Refresh(configs)
        end
        return configs
    end

    configsDropdown = ConfigManager.ConfigTab:Dropdown({
        Title = "Select Config",
        Multi = false,
        AllowNone = true,
        Value = "",
        Values = refreshConfigsList(),
        Callback = function(selectedConfig)
            selectedConfigName = selectedConfig or ""
            if selectedConfigName ~= "" then
                configNameInputElement:Set(selectedConfigName)
                configNameInput = selectedConfigName
            end
        end
    })

    ConfigManager.ConfigTab:Button({
        Title = "Save Config",
        Desc = "Save current settings to config file",
        Callback = function()
            if configNameInput ~= "" then
                local success, message = ConfigManager:SaveConfig(configNameInput)
                if success then
                    ConfigManager.Window:Notify({
                        Title = "Config Saved",
                        Content = "Config '" .. configNameInput .. "' saved successfully!",
                        Duration = 3,
                    })
                    refreshConfigsList()
                else
                    ConfigManager.Window:Notify({
                        Title = "Save Error",
                        Content = message or "Failed to save config",
                        Duration = 3,
                    })
                end
            else
                ConfigManager.Window:Notify({
                    Title = "Save Error",
                    Content = "Please enter a config name first",
                    Duration = 3,
                })
            end
        end
    })

    ConfigManager.ConfigTab:Button({
        Title = "Load Config",
        Desc = "Load settings from selected config file",
        Callback = function()
            if selectedConfigName ~= "" then
                local success, message = ConfigManager:LoadConfig(selectedConfigName)
                if success then
                    ConfigManager.Window:Notify({
                        Title = "Config Loaded",
                        Content = "Config '" .. selectedConfigName .. "' loaded successfully!",
                        Duration = 3,
                    })
                else
                    ConfigManager.Window:Notify({
                        Title = "Load Error",
                        Content = message or "Failed to load config",
                        Duration = 3,
                    })
                end
            else
                ConfigManager.Window:Notify({
                    Title = "Load Error",
                    Content = "Please select a config first",
                    Duration = 3,
                })
            end
        end
    })

    ConfigManager.ConfigTab:Button({
        Title = "Delete Config",
        Desc = "Delete selected config file",
        Callback = function()
            if selectedConfigName ~= "" then
                local success, message = ConfigManager:DeleteConfig(selectedConfigName)
                if success then
                    ConfigManager.Window:Notify({
                        Title = "Config Deleted",
                        Content = "Config '" .. selectedConfigName .. "' deleted successfully!",
                        Duration = 3,
                    })
                    selectedConfigName = ""
                    configNameInput = ""
                    configNameInputElement:Set("")
                    refreshConfigsList()
                else
                    ConfigManager.Window:Notify({
                        Title = "Delete Error",
                        Content = message or "Failed to delete config",
                        Duration = 3,
                    })
                end
            else
                ConfigManager.Window:Notify({
                    Title = "Delete Error",
                    Content = "Please select a config first",
                    Duration = 3,
                })
            end
        end
    })

    ConfigManager.ConfigTab:Button({
        Title = "Refresh Config List",
        Desc = "Refresh the list of available configs",
        Callback = function()
            local configs = refreshConfigsList()
            ConfigManager.Window:Notify({
                Title = "List Refreshed",
                Content = "Found " .. #configs .. " config files",
                Duration = 2,
            })
        end
    })
end

function ConfigManager:Register(Name, Element, ElementType)
    if not Element then
        warn("[ ConfigManager ] Element is nil for:", Name)
        return
    end
    
    ConfigManager.Elements[Name] = {
        element = Element,
        type = ElementType or "Toggle"
    }
end

function ConfigManager:SaveConfig(configName)
    if not configName or configName == "" then
        return false, "No config name specified"
    end

    local saveData = {
        ConfigName = configName,
        SavedAt = os.date("%Y-%m-%d %H:%M:%S"),
        Elements = {}
    }
    
    for name, elementData in pairs(ConfigManager.Elements) do
        local element = elementData.element
        local elementType = elementData.type
        
        if element and ConfigManager.Parser[elementType] then
            local success, result = pcall(function()
                return ConfigManager.Parser[elementType].Save(element)
            end)
            
            if success then
                saveData.Elements[name] = result
            else
                warn("[ ConfigManager ] Failed to save element:", name, result)
            end
        end
    end
    
    local filePath = ConfigManager.Path .. configName .. ".json"
    local success, error = pcall(function()
        writefile(filePath, HttpService:JSONEncode(saveData))
    end)
    
    if success then
        return true, "Config saved successfully"
    else
        return false, "Failed to save config: " .. tostring(error)
    end
end

function ConfigManager:LoadConfig(configName)
    if not configName or configName == "" then
        return false, "No config name specified"
    end
    
    local filePath = ConfigManager.Path .. configName .. ".json"
    
    if not isfile(filePath) then
        return false, "Config file not found"
    end
    
    local success, loadData = pcall(function()
        return HttpService:JSONDecode(readfile(filePath))
    end)
    
    if not success then
        return false, "Failed to decode config file"
    end
    
    if not loadData or not loadData.Elements then
        return false, "Invalid config file format"
    end
    
    local loadedCount = 0
    for name, data in pairs(loadData.Elements) do
        if ConfigManager.Elements[name] and ConfigManager.Parser[data.__type] then
            local element = ConfigManager.Elements[name].element
            
            task.spawn(function()
                local success, error = pcall(function()
                    ConfigManager.Parser[data.__type].Load(element, data)
                end)
                
                if success then
                    loadedCount = loadedCount + 1
                else
                    warn("[ ConfigManager ] Failed to load element:", name, error)
                end
            end)
        end
    end
    
    return true, "Config loaded successfully (" .. loadedCount .. " elements)"
end

function ConfigManager:DeleteConfig(configName)
    if not configName or configName == "" then
        return false, "No config name specified"
    end
    
    local filePath = ConfigManager.Path .. configName .. ".json"
    
    if not isfile(filePath) then
        return false, "Config file not found"
    end
    
    local success, error = pcall(function()
        delfile(filePath)
    end)
    
    if success then
        return true, "Config deleted successfully"
    else
        return false, "Failed to delete config: " .. tostring(error)
    end
end

function ConfigManager:GetAllConfigs()
    local configs = {}
    
    local success, files = pcall(function()
        return listfiles(ConfigManager.Path)
    end)
    
    if success and files then
        for _, file in ipairs(files) do
            local configName = file:match("([^/\\]+)%.json$")
            if configName then
                table.insert(configs, configName)
            end
        end
    end
    
    return configs
end

function ConfigManager:GetConfigInfo(configName)
    if not configName or configName == "" then
        return nil
    end
    
    local filePath = ConfigManager.Path .. configName .. ".json"
    
    if not isfile(filePath) then
        return nil
    end
    
    local success, data = pcall(function()
        return HttpService:JSONDecode(readfile(filePath))
    end)
    
    if success and data then
        return {
            name = data.ConfigName or configName,
            savedAt = data.SavedAt or "Unknown",
            elementCount = data.Elements and #data.Elements or 0
        }
    end
    
    return nil
end

return ConfigManager