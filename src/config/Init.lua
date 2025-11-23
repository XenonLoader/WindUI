-- credits: dawid, extended functionality
local HttpService = game:GetService("HttpService")

local Window 

local ConfigManager
ConfigManager = {
    --Window = nil,
    Folder = nil,
    Path = nil,
    Configs = {},
    ExcludedTitles = {
        ["Select Config"] = true,
        ["Config Name"] = true,
    },
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
                    
                    -- Trigger callback if exists
                    task.spawn(function()
                        task.wait(0.05)
                        if element.Callback then
                            element.Callback(Color3.fromHex(data.value), data.transparency)
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
                if element then
                    local value = data.value
                    local isMulti = data.multi or element.Multi

                    if isMulti and type(value) == "table" then
                        -- DISABLE callback sementara
                        local originalCallback = element.Callback
                        element.Callback = function() end

                        -- Clear semua seleksi dulu
                        element.Value = {}
                        element:Display()

                        task.wait(0.1)

                        -- Select semua item dari saved value
                        for _, item in ipairs(value) do
                            local found = false
                            for _, existing in ipairs(element.Value) do
                                if existing == item then
                                    found = true
                                    break
                                end
                            end
                            if not found then
                                table.insert(element.Value, item)
                            end
                        end

                        -- Update display
                        element:Display()

                        -- RESTORE callback dan trigger sekali dengan full array
                        task.wait(0.1)
                        element.Callback = originalCallback

                        if element.Callback then
                            task.spawn(function()
                                element.Callback(value)
                            end)
                        end
                    else
                        -- Single Dropdown
                        local singleValue = value
                        if type(value) == "table" and #value > 0 then
                            singleValue = value[1]
                        end

                        element:Select(singleValue)

                        task.spawn(function()
                            task.wait(0.1)
                            if element.Callback then
                                element.Callback(singleValue)
                            end
                        end)
                    end
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
                    
                    -- Trigger callback if exists
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
                return {
                    __type = obj.__type,
                    value = obj.Value,
                }
            end,
            Load = function(element, data)
                if element then
                    element:Set(data.value)
                    
                    -- Trigger callback if exists
                    task.spawn(function()
                        task.wait(0.05)
                        if element.Callback then
                            element.Callback(data.value)
                        end
                    end)
                end
            end
        },
        Slider = {
            Save = function(obj)
                return {
                    __type = obj.__type,
                    value = obj.Value.Default,
                }
            end,
            Load = function(element, data)
                if element then
                    element:Set(data.value)
                    
                    -- Trigger callback if exists
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
                    value = obj.Value,
                }
            end,
            Load = function(element, data)
                if element then
                    element:Set(data.value)
                    
                    -- Trigger callback if exists
                    task.spawn(function()
                        task.wait(0.05)
                        if element.Callback then
                            element.Callback(data.value)
                        end
                    end)
                end
            end
        },
    }
}

function ConfigManager:Init(WindowTable)
    if not WindowTable.Folder then
        warn("[ Avantrix.ConfigManager ] Window.Folder is not specified.")
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
        if isfile and readfile and isfile(f .. ".json") then
            ConfigManager.Configs[f] = readfile(f .. ".json")
        end
    end

    
    return ConfigManager
end

function ConfigManager:CreateConfig(configFilename)
    local ConfigModule = {
        Path = ConfigManager.Path .. configFilename .. ".json",
        Elements = {},
        CustomData = {},
        Version = 1.2,
        AutoRegisterEnabled = true
    }

    if not configFilename then
        return false, "No config file is selected"
    end

    function ConfigModule:AutoRegisterElements()
        if not Window then return end

        ConfigModule.Elements = {}

        if Window.AllElements then
            for i, element in ipairs(Window.AllElements) do
                if element and element.__type then
                    -- SKIP excluded elements (config UI elements)
                    if element.Title and ConfigManager.ExcludedTitles[element.Title] then
                        continue
                    end
                    
                    local elementName = element.Title or ("Element_" .. i)
                    elementName = elementName:gsub("[^%w_]", "_")

                    ConfigModule.Elements[elementName] = element
                end
            end
        end
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
    
    function ConfigModule:Save()
        if ConfigModule.AutoRegisterEnabled then
            ConfigModule:AutoRegisterElements()
        end

        local saveData = {
            __version = ConfigModule.Version,
            __elements = {},
            __custom = ConfigModule.CustomData
        }

        for name, element in next, ConfigModule.Elements do
            if ConfigManager.Parser[element.__type] then
                saveData.__elements[tostring(name)] = ConfigManager.Parser[element.__type].Save(element)
            end
        end

        local jsonData = HttpService:JSONEncode(saveData)
        if writefile then
            writefile(ConfigModule.Path, jsonData)
        end

        return saveData
    end
    
    function ConfigModule:Load()
        if isfile and not isfile(ConfigModule.Path) then
            return false, "Config file does not exist"
        end

        local success, loadData = pcall(function()
            local readfile = readfile or function() warn("[ Avantrix.ConfigManager ] The config system doesn't work in the studio.") return nil end
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
        end

        for name, data in next, (loadData.__elements or {}) do
            if ConfigModule.Elements[name] and ConfigManager.Parser[data.__type] then
                task.spawn(function()
                    ConfigManager.Parser[data.__type].Load(ConfigModule.Elements[name], data)
                end)
            else
                for elementName, element in next, ConfigModule.Elements do
                    if element.__type == data.__type then
                        local savedTitle = data.value and type(data.value) == "table" and data.value.Title or nil
                        local elementTitle = element.Title

                        if elementTitle and savedTitle and elementTitle == savedTitle then
                            task.spawn(function()
                                ConfigManager.Parser[data.__type].Load(element, data)
                            end)
                            break
                        end
                    end
                end
            end
        end

        ConfigModule.CustomData = loadData.__custom or {}

        return ConfigModule.CustomData
    end
    
    function ConfigModule:GetData()
        return {
            elements = ConfigModule.Elements,
            custom = ConfigModule.CustomData
        }
    end
    
    ConfigManager.Configs[configFilename] = ConfigModule
    return ConfigModule
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
