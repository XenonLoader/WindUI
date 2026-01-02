local HttpService = game:GetService("HttpService")

local ConfigManager = {
    Folder = nil,
    Path = nil,
    Configs = {},
    ExcludedTitles = {},
    Window = nil,
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
                        local originalCallback = element.Callback
                        element.Callback = function() end

                        element.Value = {}
                        element:Display()

                        task.wait(0.1)

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

                        element:Display()

                        task.wait(0.1)
                        element.Callback = originalCallback

                        if element.Callback then
                            task.spawn(function()
                                element.Callback(value)
                            end)
                        end
                    else
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
        warn("[ ConfigManager ] Window.Folder is not specified.")
        return false
    end

    ConfigManager.Folder = WindowTable.Folder
    ConfigManager.Path = "Avantrix/" .. tostring(ConfigManager.Folder) .. "/config/"
    ConfigManager.Window = WindowTable

    if not isfolder("Avantrix/" .. ConfigManager.Folder) then
        makefolder("Avantrix/" .. ConfigManager.Folder)
        if not isfolder("Avantrix/" .. ConfigManager.Folder .. "/config/") then
            makefolder("Avantrix/" .. ConfigManager.Folder .. "/config/")
        end
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
        if not ConfigManager.Window then 
            warn("[ ConfigManager ] Window is not set")
            return 
        end
        
        if not ConfigManager.Window.AllElements then 
            warn("[ ConfigManager ] Window.AllElements is nil or empty")
            return 
        end

        ConfigModule.Elements = {}

        local count = 0
        for i, element in ipairs(ConfigManager.Window.AllElements) do
            if element and element.__type then
                -- Skip elements yang tidak perlu disimpan
                if element.__type == "Paragraph" or 
                   element.__type == "Button" or 
                   element.__type == "Section" or 
                   element.__type == "Divider" or 
                   element.__type == "Space" or
                   element.__type == "Image" or
                   element.__type == "Code" then
                    continue
                end
                
                -- Skip jika title ada di excluded list
                if element.Title and ConfigManager.ExcludedTitles[element.Title] then
                    continue
                end

                -- Gunakan Title sebagai key jika ada, fallback ke index
                local elementName = element.Title or ("Element_" .. i)
                elementName = elementName:gsub("[^%w_]", "_")

                ConfigModule.Elements[elementName] = element
                count = count + 1
                
                print("[ ConfigManager ] Registered: " .. elementName .. " (" .. element.__type .. ")")
            end
        end
        
        print("[ ConfigManager ] Auto-registered " .. count .. " elements")
        return count
    end

    function ConfigModule:Register(Name, Element)
        ConfigModule.Elements[Name] = Element
        print("[ ConfigManager ] Manually registered: " .. Name)
    end

    function ConfigModule:Set(key, value)
        ConfigModule.CustomData[key] = value
    end

    function ConfigModule:Get(key)
        return ConfigModule.CustomData[key]
    end

    function ConfigModule:Save()
        if ConfigModule.AutoRegisterEnabled then
            local count = ConfigModule:AutoRegisterElements()
            if count == 0 then
                warn("[ ConfigManager ] No elements found to save!")
            end
        end

        local saveData = {
            __version = ConfigModule.Version,
            __elements = {},
            __custom = ConfigModule.CustomData
        }

        local elementCount = 0
        for name, element in next, ConfigModule.Elements do
            if element and element.__type and ConfigManager.Parser[element.__type] then
                local success, data = pcall(function()
                    return ConfigManager.Parser[element.__type].Save(element)
                end)
                
                if success then
                    saveData.__elements[tostring(name)] = data
                    elementCount = elementCount + 1
                    print("[ ConfigManager ] Saved: " .. name .. " = " .. HttpService:JSONEncode(data))
                else
                    warn("[ ConfigManager ] Failed to save " .. name .. ": " .. tostring(data))
                end
            else
                warn("[ ConfigManager ] Skipped " .. name .. " (no parser for " .. tostring(element and element.__type or "nil") .. ")")
            end
        end

        print("[ ConfigManager ] Saving " .. elementCount .. " elements to " .. ConfigModule.Path)

        local success, jsonData = pcall(function()
            return HttpService:JSONEncode(saveData)
        end)
        
        if not success then
            warn("[ ConfigManager ] Failed to encode JSON: " .. tostring(jsonData))
            return false
        end

        if writefile then
            local writeSuccess, writeError = pcall(function()
                writefile(ConfigModule.Path, jsonData)
            end)
            
            if writeSuccess then
                print("[ ConfigManager ] Config saved successfully!")
                print("[ ConfigManager ] JSON Preview: " .. jsonData:sub(1, 200) .. "...")
            else
                warn("[ ConfigManager ] Failed to write file: " .. tostring(writeError))
            end
        else
            warn("[ ConfigManager ] writefile is not available")
        end

        return saveData
    end

    function ConfigModule:Load()
        if isfile and not isfile(ConfigModule.Path) then
            return false, "Config file does not exist"
        end

        local success, loadData = pcall(function()
            local readfile = readfile or function() warn("[ ConfigManager ] The config system doesn't work in the studio.") return nil end
            local content = readfile(ConfigModule.Path)
            print("[ ConfigManager ] Reading file content: " .. content:sub(1, 200) .. "...")
            return HttpService:JSONDecode(content)
        end)

        if not success then
            warn("[ ConfigManager ] Failed to parse config file: " .. tostring(loadData))
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

        local loadedCount = 0
        for name, data in next, (loadData.__elements or {}) do
            if ConfigModule.Elements[name] and data.__type and ConfigManager.Parser[data.__type] then
                local success, err = pcall(function()
                    ConfigManager.Parser[data.__type].Load(ConfigModule.Elements[name], data)
                end)
                
                if success then
                    loadedCount = loadedCount + 1
                    print("[ ConfigManager ] Loaded: " .. name)
                else
                    warn("[ ConfigManager ] Failed to load " .. name .. ": " .. tostring(err))
                end
            else
                warn("[ ConfigManager ] Element not found or no parser: " .. name)
            end
        end

        print("[ ConfigManager ] Loaded " .. loadedCount .. " elements from " .. ConfigModule.Path)

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

function ConfigManager:SetWindow(WindowTable)
    ConfigManager.Window = WindowTable
end

return ConfigManager
