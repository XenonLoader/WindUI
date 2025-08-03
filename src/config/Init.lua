-- credits: dawid
local HttpService = game:GetService("HttpService")

local ConfigManager
ConfigManager = {
    Window = nil,
    Folder = nil,
    Path = nil,
    Configs = {},
    Parser = {
        Colorpicker = {
            Save = function(obj)
                return {
                    __type = obj.__type,
                    value = obj.Default:ToHex(),
                    transparency = obj.Transparency or nil,
                }
            end,
            Load = function(element, data)
                if element then
                    element:Update(Color3.fromHex(data.value), data.transparency or nil)
                end
            end
        },
        Dropdown = {
            Save = function(obj)
                return {
                    __type = obj.__type,
                    value = obj.Value,
                }
            end,
            Load = function(element, data)
                if element then
                    element:Set(data.value)
                end
            end
        },
        Input = {
            Save = function(obj)
                return {
                    __type = obj.__type,
                    value = obj.Value,
                }
            end,
            Load = function(element, data)
                if element then
                    element:Set(data.value)
                end
            end
        },
        Keybind = {
            Save = function(obj)
                return {
                    __type = obj.__type,
                    value = obj.Value,
                }
            end,
            Load = function(element, data)
                if element then
                    element:Set(data.value)
                end
            end
        },
        Slider = {
            Save = function(obj)
                return {
                    __type = obj.__type,
                    value = obj.Value or obj.Default,
                }
            end,
            Load = function(element, data)
                if element then
                    element:Set(data.value)
                end
            end
        },
        Toggle = {
            Save = function(obj)
                return {
                    __type = obj.__type,
                    value = obj.Value,
                }
            end,
            Load = function(element, data)
                if element then
                    element:Set(data.value)
                end
            end
        },
    }
}

function ConfigManager:Init(Window)
    if not Window.Folder then
        warn("[ WindUI.ConfigManager ] Window.Folder is not specified.")
        return false
    end
    
    ConfigManager.Window = Window
    ConfigManager.Folder = Window.Folder
    ConfigManager.Path = "WindUI/" .. tostring(ConfigManager.Folder) .. "/config/"

    -- Create folder if it doesn't exist
    pcall(function()
        makefolder("WindUI")
        makefolder("WindUI/" .. tostring(ConfigManager.Folder))
        makefolder(ConfigManager.Path)
    end)

    return ConfigManager
end

function ConfigManager:CreateConfig(configFilename)
    local ConfigModule = {
        Path = ConfigManager.Path .. configFilename .. ".json",
        Elements = {}
    }
    
    if not configFilename then
        return false, "No config file is selected"
    end

    function ConfigModule:Register(Name, Element)
        ConfigModule.Elements[Name] = Element
    end
    
    function ConfigModule:Save()
        local saveData = {
            Elements = {},
            WindowSettings = {
                Theme = ConfigManager.Window and ConfigManager.Window:GetCurrentTheme() or "Dark",
                Transparency = ConfigManager.Window and ConfigManager.Window:GetTransparency() or false
            }
        }
        
        for name, element in next, ConfigModule.Elements do
            if ConfigManager.Parser[element.__type] then
                saveData.Elements[tostring(name)] = ConfigManager.Parser[element.__type].Save(element)
            end
        end
        
        local success, err = pcall(function()
            writefile(ConfigModule.Path, HttpService:JSONEncode(saveData))
        end)
        
        return success, err
    end
    
    function ConfigModule:Load()
        if not isfile(ConfigModule.Path) then 
            return false, "Config file not found" 
        end
        
        local success, loadData = pcall(function()
            return HttpService:JSONDecode(readfile(ConfigModule.Path))
        end)
        
        if not success then
            return false, "Failed to decode config file"
        end
        
        -- Load elements
        for name, data in next, loadData.Elements do
            if ConfigModule.Elements[name] and ConfigManager.Parser[data.__type] then
                task.spawn(function()
                    ConfigManager.Parser[data.__type].Load(ConfigModule.Elements[name], data)
                end)
            end
        end
        
        -- Load window settings
        if loadData.WindowSettings and ConfigManager.Window then
            if loadData.WindowSettings.Theme then
                ConfigManager.Window:SetTheme(loadData.WindowSettings.Theme)
            end
            if loadData.WindowSettings.Transparency ~= nil then
                ConfigManager.Window:ToggleTransparency(loadData.WindowSettings.Transparency)
            end
        end
        
        return true
    end
    
    function ConfigModule:Delete()
        if isfile(ConfigModule.Path) then
            local success = pcall(function()
                delfile(ConfigModule.Path)
            end)
            return success
        end
        return false, "Config file not found"
    end
    
    ConfigManager.Configs[configFilename] = ConfigModule
    
    return ConfigModule
end

function ConfigManager:AllConfigs()
    if listfiles then
        local files = {}
        local success, fileList = pcall(function()
            return listfiles(ConfigManager.Path)
        end)
        
        if success and fileList then
            for _, file in next, fileList do
                local name = file:match("([^\\/]+)%.json$")
                if name then
                    table.insert(files, name)
                end
            end
        end
        
        return files
    end
    return {}
end

function ConfigManager:DeleteConfig(configName)
    if not configName then return false, "No config name provided" end
    
    local filePath = ConfigManager.Path .. configName .. ".json"
    if isfile(filePath) then
        local success = pcall(function()
            delfile(filePath)
        end)
        
        -- Remove from configs table
        if success and ConfigManager.Configs[configName] then
            ConfigManager.Configs[configName] = nil
        end
        
        return success
    end
    return false, "Config file not found"
end

function ConfigManager:ConfigExists(configName)
    if not configName then return false end
    local filePath = ConfigManager.Path .. configName .. ".json"
    return isfile(filePath)
end

return ConfigManager