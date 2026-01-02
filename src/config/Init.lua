local cloneref = (cloneref or clonereference or function(instance) return instance end)

local HttpService = cloneref(game:GetService("HttpService"))

local Window 

local ConfigManager
ConfigManager = {
    Folder = nil,
    Path = nil,
    Configs = {},
    ExcludedTitles = {},
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
        if not isfolder("Avantrix/" .. ConfigManager.Folder .. "/config/") then
            makefolder("Avantrix/" .. ConfigManager.Folder .. "/config/")
        end
    end
    
    local files = ConfigManager:AllConfigs()
    
    for _, f in next, files do
        if isfile and readfile and isfile(ConfigManager.Path .. f .. ".json") then
            ConfigManager.Configs[f] = readfile(ConfigManager.Path .. f .. ".json")
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
        local count = 0
        
        -- Scan semua elemen dari Window.AllElements
        if Window.AllElements then
            for i, element in ipairs(Window.AllElements) do
                if element and element.__type and ConfigManager.Parser[element.__type] then
                    if element.Title and not ConfigManager.ExcludedTitles[element.Title] then
                        local elementName = element.Title or ("Element_" .. i)
                        ConfigModule.Elements[elementName] = element
                        count = count + 1
                    end
                end
            end
        end
        
        -- Fallback ke PendingFlags jika AllElements tidak ada
        if count == 0 and Window.PendingFlags then
            for flag, element in next, Window.PendingFlags do
                ConfigModule:Register(flag, element)
                count = count + 1
            end
        end
        
        return count
    end
    
    function ConfigModule:Register(Name, Element)
        ConfigModule.Elements[Name] = Element
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
            ConfigModule:AutoRegisterElements()
        else
            -- Fallback ke sistem lama jika auto-register dinonaktifkan
            if Window.PendingFlags then
                for flag, element in next, Window.PendingFlags do
                    ConfigModule:Register(flag, element)
                end
            end
        end
        
        local saveData = {
            __version = ConfigModule.Version,
            __elements = {},
            __autoload = ConfigModule.AutoLoad,
            __custom = ConfigModule.CustomData
        }
        
        for name, element in pairs(ConfigModule.Elements) do
            if element.__type and ConfigManager.Parser[element.__type] then
                local success, data = pcall(function()
                    return ConfigManager.Parser[element.__type].Save(element)
                end)
                
                if success then
                    saveData.__elements[tostring(name)] = data
                else
                    warn("[ WindUI.ConfigManager ] Failed to save " .. name)
                end
            end
        end
        
        local success, jsonData = pcall(function()
            return HttpService:JSONEncode(saveData)
        end)
        
        if success and writefile then 
            writefile(ConfigModule.Path, jsonData)
            return saveData
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
            ConfigModule:AutoRegisterElements()
        else
            -- Fallback ke sistem lama jika auto-register dinonaktifkan
            if Window.PendingFlags then
                for flag, element in next, Window.PendingFlags do
                    ConfigModule:Register(flag, element)
                end
            end
        end
        
        for name, data in pairs(loadData.__elements or {}) do
            if ConfigModule.Elements[name] and ConfigManager.Parser[data.__type] then
                pcall(function()
                    ConfigManager.Parser[data.__type].Load(ConfigModule.Elements[name], data)
                end)
            end
        end
        
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
                    if Window.Debug then print("[ WindUI.ConfigManager ] AutoLoaded config: " .. configFilename) end
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

return ConfigManager