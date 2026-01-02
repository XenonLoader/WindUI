local cloneref = (cloneref or clonereference or function(instance) return instance end)

local HttpService = cloneref(game:GetService("HttpService"))

local Window 

local ConfigManager
ConfigManager = {
    Folder = nil,
    Path = nil,
    Configs = {},
    ExcludedTitles = {},
    RegisteredElements = {}, -- NEW: Track all registered elements globally
    Parser = {
        Colorpicker = {
            Save = function(obj)
                local color = obj.Default or Color3.new(1, 1, 1)
                local colorHex
                
                if typeof(color) == "Color3" then
                    colorHex = "#" .. color:ToHex()
                else
                    colorHex = "#FFFFFF"
                end
                
                return {
                    __type = obj.__type,
                    value = colorHex,
                    transparency = obj.Transparency or nil,
                }
            end,
            Load = function(element, data)
                if element and element.Update then
                    local color = Color3.fromHex(data.value)
                    element:Update(color, data.transparency or nil)
                    
                    task.spawn(function()
                        task.wait(0.05)
                        if element.Callback then
                            element.Callback(color, data.transparency)
                        end
                    end)
                end
            end
        },
        Dropdown = {
            Save = function(obj)
                return {
                    __type = obj.__type,
                    value = obj.Value,
                    multi = obj.Multi or false,
                }
            end,
            Load = function(element, data)
                if element and element.Select then
                    local value = data.value
                    
                    task.spawn(function()
                        element:Select(value)
                        
                        task.wait(0.1)
                        if element.Callback then
                            element.Callback(value)
                        end
                    end)
                end
            end
        },
        Input = {
            Save = function(obj)
                return {
                    __type = obj.__type,
                    value = tostring(obj.Value or ""),
                }
            end,
            Load = function(element, data)
                if element and element.Set then
                    element:Set(data.value or "")
                    
                    task.spawn(function()
                        task.wait(0.05)
                        if element.Callback then
                            element.Callback(data.value)
                        end
                    end)
                end
            end
        },
        Keybind = {
            Save = function(obj)
                local value = obj.Value
                if typeof(value) == "EnumItem" then
                    value = value.Name
                end
                return {
                    __type = obj.__type,
                    value = tostring(value),
                }
            end,
            Load = function(element, data)
                if element and element.Set then
                    local value = data.value
                    
                    if type(value) == "string" and Enum.KeyCode[value] then
                        value = Enum.KeyCode[value]
                    end
                    
                    element:Set(value)
                    
                    task.spawn(function()
                        task.wait(0.05)
                        if element.Callback then
                            element.Callback(value)
                        end
                    end)
                end
            end
        },
        Slider = {
            Save = function(obj)
                local value = obj.Value
                if type(value) == "table" then
                    value = value.Default or 0
                end
                
                return {
                    __type = obj.__type,
                    value = tonumber(value) or 0,
                }
            end,
            Load = function(element, data)
                if element and element.Set then
                    element:Set(data.value or 0)
                    
                    task.spawn(function()
                        task.wait(0.05)
                        if element.Callback then
                            element.Callback(data.value)
                        end
                    end)
                end
            end
        },
        Toggle = {
            Save = function(obj)
                return {
                    __type = obj.__type,
                    value = obj.Value == true,
                }
            end,
            Load = function(element, data)
                if element and element.Set then
                    element:Set(data.value == true)
                    
                    task.spawn(function()
                        task.wait(0.05)
                        if element.Callback then
                            element.Callback(data.value)
                        end
                    end)
                end
            end
        },
        Section = {
            Save = function(obj)
                return {
                    __type = obj.__type,
                    opened = obj.Opened == true,
                }
            end,
            Load = function(element, data)
                if element then
                    task.spawn(function()
                        task.wait(0.1)
                        if data.opened and element.Open then
                            element:Open()
                        elseif not data.opened and element.Close then
                            element:Close()
                        end
                    end)
                end
            end
        },
    }
}

-- NEW: Function to register element globally
function ConfigManager:RegisterElement(element, title)
    if not element or not element.__type then return end
    if not ConfigManager.Parser[element.__type] then return end
    if ConfigManager.ExcludedTitles[title] then return end
    
    local key = title or "Unknown"
    local counter = 1
    local finalKey = key
    
    while ConfigManager.RegisteredElements[finalKey] do
        finalKey = key .. "_" .. counter
        counter = counter + 1
    end
    
    ConfigManager.RegisteredElements[finalKey] = element
    
    -- Also add to Window.AllElements if exists
    if Window and Window.AllElements then
        table.insert(Window.AllElements, element)
    end
    
    return finalKey
end

function ConfigManager:Init(WindowTable)
    if not WindowTable.Folder then
        warn("[ WindUI.ConfigManager ] Window.Folder is not specified.")
        return false
    end
    
    Window = WindowTable
    ConfigManager.Folder = Window.Folder
    ConfigManager.Path = "Avantrix/" .. tostring(ConfigManager.Folder) .. "/config/"
    
    if not isfolder("Avantrix/" .. ConfigManager.Folder) then
        makefolder("Avantrix/" .. ConfigManager.Folder)
    end
    if not isfolder(ConfigManager.Path) then
        makefolder(ConfigManager.Path)
    end
    
    local files = ConfigManager:AllConfigs()
    
    for _, f in next, files do
        local filePath = ConfigManager.Path .. f .. ".json"
        if isfile and readfile and isfile(filePath) then
            ConfigManager.Configs[f] = readfile(filePath)
        end
    end
    
    return ConfigManager
end

function ConfigManager:CreateConfig(configFilename, autoload)
    local ConfigModule = {
        Path = ConfigManager.Path .. configFilename .. ".json",
        Elements = {},
        CustomData = {},
        AutoLoad = autoload or false,
        Version = 1.3,
        AutoRegisterEnabled = true
    }
    
    if not configFilename then
        return false, "No config file is selected"
    end
    
    function ConfigModule:SetAsCurrent()
        Window:SetCurrentConfig(ConfigModule)
    end
    
    function ConfigModule:AutoRegisterElements()
        if not Window then
            warn("[ WindUI.ConfigManager ] Window is not set")
            return 0
        end
        
        ConfigModule.Elements = {}
        
        -- Use globally registered elements
        local count = 0
        for key, element in pairs(ConfigManager.RegisteredElements) do
            if element.__type and ConfigManager.Parser[element.__type] then
                ConfigModule.Elements[key] = element
                count = count + 1
            end
        end
        
        print(string.format("[ ConfigManager ] AutoRegister found %d elements", count))
        
        return count
    end
    
    function ConfigModule:Register(Name, Element)
        ConfigModule.Elements[Name] = Element
        ConfigManager:RegisterElement(Element, Name)
    end
    
    function ConfigModule:Set(key, value)
        ConfigModule.CustomData[key] = value
    end
    
    function ConfigModule:Get(key)
        return ConfigModule.CustomData[key]
    end
    
    function ConfigModule:SetAutoLoad(Value)
        ConfigModule.AutoLoad = Value
    end
    
    function ConfigModule:Save()
        if ConfigModule.AutoRegisterEnabled then
            local registered = ConfigModule:AutoRegisterElements()
            print(string.format("[ ConfigManager ] Saving %d elements", registered))
        end
        
        local saveData = {
            __version = ConfigModule.Version,
            __elements = {},
            __autoload = ConfigModule.AutoLoad,
            __custom = ConfigModule.CustomData
        }
        
        local savedCount = 0
        for name, element in pairs(ConfigModule.Elements) do
            if element.__type and ConfigManager.Parser[element.__type] then
                local success, data = pcall(function()
                    return ConfigManager.Parser[element.__type].Save(element)
                end)
                
                if success then
                    saveData.__elements[tostring(name)] = data
                    savedCount = savedCount + 1
                    print(string.format("[ ConfigManager ] Saved: %s (%s) = %s", 
                        name, element.__type, tostring(data.value)))
                else
                    warn(string.format("[ ConfigManager ] Failed to save %s: %s", name, tostring(data)))
                end
            end
        end
        
        print(string.format("[ ConfigManager ] Total saved: %d elements", savedCount))
        
        local success, jsonData = pcall(function()
            return HttpService:JSONEncode(saveData)
        end)
        
        if success and writefile then
            writefile(ConfigModule.Path, jsonData)
            print("[ ConfigManager ] Config saved to: " .. ConfigModule.Path)
            return saveData
        else
            warn("[ ConfigManager ] Failed to encode or write config")
        end
        
        return false
    end
    
    function ConfigModule:Load()
        if isfile and not isfile(ConfigModule.Path) then 
            return false, "Config file does not exist" 
        end
        
        local success, loadData = pcall(function()
            local readfile = readfile or function() 
                warn("[ WindUI.ConfigManager ] The config system doesn't work in the studio.") 
                return nil 
            end
            return HttpService:JSONDecode(readfile(ConfigModule.Path))
        end)
        
        if not success then
            return false, "Failed to parse config file"
        end
        
        if not loadData.__version then
            local migratedData = {
                __version = ConfigModule.Version,
                __elements = loadData,
                __custom = {}
            }
            loadData = migratedData
        end
        
        if ConfigModule.AutoRegisterEnabled then
            local registered = ConfigModule:AutoRegisterElements()
            print(string.format("[ ConfigManager ] Loading %d elements", registered))
        end
        
        local loadedCount = 0
        for name, data in pairs(loadData.__elements or {}) do
            if ConfigModule.Elements[name] and ConfigManager.Parser[data.__type] then
                local success = pcall(function()
                    ConfigManager.Parser[data.__type].Load(ConfigModule.Elements[name], data)
                    loadedCount = loadedCount + 1
                    print(string.format("[ ConfigManager ] Loaded: %s (%s) = %s", 
                        name, data.__type, tostring(data.value)))
                end)
                
                if not success then
                    warn(string.format("[ ConfigManager ] Failed to load: %s", name))
                end
            else
                print(string.format("[ ConfigManager ] Element not found: %s", name))
            end
        end
        
        print(string.format("[ ConfigManager ] Total loaded: %d elements", loadedCount))
        
        ConfigModule.CustomData = loadData.__custom or {}
        
        return ConfigModule.CustomData
    end
    
    function ConfigModule:Delete()
        if not delfile then
            return false, "delfile function is not available"
        end
        
        if not isfile(ConfigModule.Path) then
            return false, "Config file does not exist"
        end
        
        local success, err = pcall(function()
            delfile(ConfigModule.Path)
        end)
        
        if not success then
            return false, "Failed to delete config file: " .. tostring(err)
        end
        
        ConfigManager.Configs[configFilename] = nil
        
        if Window.CurrentConfig == ConfigModule then
            Window.CurrentConfig = nil
        end
        
        return true, "Config deleted successfully"
    end
    
    function ConfigModule:GetData()
        return {
            elements = ConfigModule.Elements,
            custom = ConfigModule.CustomData,
            autoload = ConfigModule.AutoLoad
        }
    end
    
    -- AutoLoad Logic
    if isfile(ConfigModule.Path) then
        local success, configData = pcall(function()
            return HttpService:JSONDecode(readfile(ConfigModule.Path))
        end)
        
        if success and configData and configData.__autoload then
            ConfigModule.AutoLoad = true
            
            task.spawn(function()
                task.wait(0.5)
                local success, result = pcall(function()
                    return ConfigModule:Load()
                end)
                if success then
                    print("[ WindUI.ConfigManager ] AutoLoaded config: " .. configFilename)
                else
                    warn("[ WindUI.ConfigManager ] Failed to AutoLoad config: " .. configFilename .. " - " .. tostring(result))
                end
            end)
        end
    end
    
    ConfigModule:SetAsCurrent()
    ConfigManager.Configs[configFilename] = ConfigModule
    return ConfigModule
end

function ConfigManager:Config(configFilename, autoload)
    return ConfigManager:CreateConfig(configFilename, autoload)
end

function ConfigManager:GetAutoLoadConfigs()
    local autoloadConfigs = {}
    
    for configName, configModule in pairs(ConfigManager.Configs) do
        if configModule.AutoLoad then
            table.insert(autoloadConfigs, configName)
        end
    end
    
    return autoloadConfigs
end

function ConfigManager:DeleteConfig(configName)
    if not delfile then
        return false, "delfile function is not available"
    end
    
    local configPath = ConfigManager.Path .. configName .. ".json"
    
    if not isfile(configPath) then
        return false, "Config file does not exist"
    end
    
    local success, err = pcall(function()
        delfile(configPath)
    end)
    
    if not success then
        return false, "Failed to delete config file: " .. tostring(err)
    end
    
    ConfigManager.Configs[configName] = nil
    
    if Window.CurrentConfig and Window.CurrentConfig.Path == configPath then
        Window.CurrentConfig = nil
    end
    
    return true, "Config deleted successfully"
end

function ConfigManager:AllConfigs()
    if not listfiles then return {} end
    
    local files = {}
    if not isfolder(ConfigManager.Path) then
        makefolder(ConfigManager.Path)
        return files
    end
    
    for _, file in next, listfiles(ConfigManager.Path) do
        local name = file:match("([^\\/]+)%.json$")
        if name then
            table.insert(files, name)
        end
    end
    
    return files
end

function ConfigManager:GetConfig(configName)
    return ConfigManager.Configs[configName]
end

-- NEW: Debug function to print all registered elements
function ConfigManager:DebugPrintElements()
    print("=== ConfigManager Registered Elements ===")
    local count = 0
    for key, element in pairs(ConfigManager.RegisteredElements) do
        count = count + 1
        print(string.format("%d. %s (%s)", count, key, element.__type or "unknown"))
    end
    print(string.format("Total: %d elements", count))
    print("========================================")
end

return ConfigManager
