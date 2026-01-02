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
                            element.Callback(value)
                        end
                    end)
                end
            end
        },
    }
}

function ConfigManager:Init(WindowTable)
    if not WindowTable.Folder and not WindowTable.Settings then
        warn("[ ConfigManager ] Window.Folder is not specified.")
        return false
    end

    ConfigManager.Folder = WindowTable.Folder or (WindowTable.Settings and WindowTable.Settings.Folder)
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

    print("[ ConfigManager ] Initialized successfully")
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

    function ConfigModule:AutoRegisterElements()
        if not Window then
            warn("[ WindUI.ConfigManager ] Window is not set")
            return 0
        end
        
        ConfigModule.Elements = {}
        local allElements = {}
        local seen = {}

        print("[ ConfigManager ] Starting auto-register scan...")

        -- Method 1: Check Window.AllElements (Maclib style)
        if ConfigManager.Window.AllElements and type(ConfigManager.Window.AllElements) == "table" then
            for _, element in pairs(ConfigManager.Window.AllElements) do
                if type(element) == "table" and not seen[element] then
                    seen[element] = true
                    table.insert(allElements, element)
                end
            end
            print("[ ConfigManager ] Found " .. #allElements .. " from Window.AllElements")
        end

        -- Method 2: Check Window.Elements (Alternative structure)
        if ConfigManager.Window.Elements and type(ConfigManager.Window.Elements) == "table" then
            for _, element in pairs(ConfigManager.Window.Elements) do
                if type(element) == "table" and not seen[element] then
                    seen[element] = true
                    table.insert(allElements, element)
                end
            end
            print("[ ConfigManager ] Found " .. #allElements .. " total after Window.Elements")
        end

        -- Method 3: Scan through Tabs (WindUI and Maclib)
        local tabs = ConfigManager.Window.Tabs or ConfigManager.Window.tabs
        if tabs and type(tabs) == "table" then
            print("[ ConfigManager ] Scanning tabs...")
            for tabName, tab in pairs(tabs) do
                if type(tab) == "table" then
                    -- Check tab.Elements
                    if tab.Elements and type(tab.Elements) == "table" then
                        for _, element in pairs(tab.Elements) do
                            if type(element) == "table" and not seen[element] then
                                seen[element] = true
                                table.insert(allElements, element)
                            end
                        end
                    end

                    -- Check tab.AllElements
                    if tab.AllElements and type(tab.AllElements) == "table" then
                        for _, element in pairs(tab.AllElements) do
                            if type(element) == "table" and not seen[element] then
                                seen[element] = true
                                table.insert(allElements, element)
                            end
                        end
                    end

                    -- Check tab.Sections (WindUI style)
                    if tab.Sections and type(tab.Sections) == "table" then
                        for _, section in pairs(tab.Sections) do
                            if type(section) == "table" and section.Elements then
                                for _, element in pairs(section.Elements) do
                                    if type(element) == "table" and not seen[element] then
                                        seen[element] = true
                                        table.insert(allElements, element)
                                    end
                                end
                            end
                        end
                    end
                end
            end
            print("[ ConfigManager ] Found " .. #allElements .. " total after scanning tabs")
        end

        -- Method 4: Deep recursive scan (last resort)
        if #allElements == 0 then
            print("[ ConfigManager ] Performing deep scan...")
            local function scanForElements(obj, depth, visited)
                if depth > 5 or type(obj) ~= "table" or visited[obj] then return end
                visited[obj] = true

                if obj.__type and type(obj.__type) == "string" and not seen[obj] then
                    seen[obj] = true
                    table.insert(allElements, obj)
                end

                for k, v in pairs(obj) do
                    if type(v) == "table" and k ~= "Parent" and k ~= "Window" and k ~= "_G" then
                        scanForElements(v, depth + 1, visited)
                    end
                end
            end

            scanForElements(ConfigManager.Window, 0, {})
            print("[ ConfigManager ] Deep scan found " .. #allElements .. " elements")
        end

        -- Process and filter elements
        local count = 0
        local savedTypes = {
            Toggle = true,
            Slider = true,
            Dropdown = true,
            Input = true,
            Keybind = true,
            Colorpicker = true
        }

        for i, element in ipairs(allElements) do
            if element and element.__type then
                local elementType = tostring(element.__type)

                -- Skip elements that don't need to be saved
                if not savedTypes[elementType] then
                    continue
                end

                -- Skip if title is excluded
                if element.Title and ConfigManager.ExcludedTitles[element.Title] then
                    continue
                end

                -- Get element name (prioritize Title, then Flag, then index)
                local elementName = element.Title or element.Flag or ("Element_" .. i)
                elementName = tostring(elementName):gsub("[^%w_%-% ]", "_")

                -- Avoid duplicate names
                local baseName = elementName
                local suffix = 1
                while ConfigModule.Elements[elementName] do
                    elementName = baseName .. "_" .. suffix
                    suffix = suffix + 1
                end

                ConfigModule.Elements[elementName] = element
                count = count + 1
            end
        end

        print("[ ConfigManager ] Successfully registered " .. count .. " elements")
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

    function ConfigModule:Save()
        if ConfigModule.AutoRegisterEnabled then
            local count = ConfigModule:AutoRegisterElements()
            if count == 0 then
                warn("[ ConfigManager ] No elements found to save!")
                return false
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
                    warn("[ ConfigManager ] Failed to save " .. name .. ": " .. tostring(data))
                end
            end
        end
        
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
                return true
            else
                warn("[ ConfigManager ] Failed to write file: " .. tostring(writeError))
                return false
            end
        else
            warn("[ ConfigManager ] writefile is not available")
            return false
        end
    end
    
    function ConfigModule:Load()
        if isfile and not isfile(ConfigModule.Path) then
            return false, "Config file does not exist"
        end
        
        local success, loadData = pcall(function()
            local readfile = readfile or function() warn("[ ConfigManager ] readfile not available") return nil end
            local content = readfile(ConfigModule.Path)
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
