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
                local color = obj.Value or obj.Default or Color3.new(1, 1, 1)
                local colorHex

                -- Handle different color storage methods
                if type(color) == "table" and color.ToHex then
                    colorHex = color:ToHex()
                elseif typeof(color) == "Color3" then
                    colorHex = "#" .. color:ToHex()
                else
                    colorHex = "#FFFFFF"
                end

                return {
                    __type = obj.__type,
                    value = colorHex,
                    transparency = obj.Transparency or obj.Alpha or nil,
                }
            end,
            Load = function(element, data)
                if element then
                    local color = Color3.fromHex(data.value)

                    -- Try different update methods
                    if element.Update then
                        element:Update(color, data.transparency or nil)
                    elseif element.Set then
                        element:Set(color)
                    elseif element.SetValue then
                        element:SetValue(color)
                    end

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
                local value = obj.Value or obj.Text or ""
                return {
                    __type = obj.__type,
                    value = tostring(value),
                }
            end,
            Load = function(element, data)
                if element then
                    local value = data.value or ""

                    -- Try different set methods
                    if element.Set then
                        element:Set(value)
                    elseif element.SetValue then
                        element:SetValue(value)
                    end

                    task.spawn(function()
                        task.wait(0.05)
                        if element.Callback then
                            element.Callback(value)
                        end
                    end)
                end
            end
        },
        Keybind = {
            Save = function(obj)
                local value = obj.Value
                -- Handle Enum.KeyCode
                if typeof(value) == "EnumItem" then
                    value = value.Name
                end
                return {
                    __type = obj.__type,
                    value = tostring(value),
                }
            end,
            Load = function(element, data)
                if element then
                    local value = data.value

                    -- Try to convert string to Enum.KeyCode
                    if type(value) == "string" and Enum.KeyCode[value] then
                        value = Enum.KeyCode[value]
                    end

                    -- Try different set methods
                    if element.Set then
                        element:Set(value)
                    elseif element.SetValue then
                        element:SetValue(value)
                    end

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
                -- Handle different value storage methods
                if type(value) == "table" then
                    value = value.Default or value.Value or value.Current or 0
                elseif type(value) == "number" then
                    -- Value is already a number
                else
                    value = tonumber(value) or 0
                end

                return {
                    __type = obj.__type,
                    value = value,
                }
            end,
            Load = function(element, data)
                if element then
                    local value = data.value or 0
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
        Toggle = {
            Save = function(obj)
                local value = obj.Value
                -- Handle different value storage
                if type(value) == "table" then
                    value = value.Value or value.State or false
                end
                -- Ensure boolean
                value = value == true

                return {
                    __type = obj.__type,
                    value = value,
                }
            end,
            Load = function(element, data)
                if element then
                    local value = data.value == true

                    -- Try different set methods
                    if element.Set then
                        element:Set(value)
                    elseif element.SetValue then
                        element:SetValue(value)
                    elseif element.Toggle then
                        if element.Value ~= value then
                            element:Toggle()
                        end
                    end

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
            return 0
        end

        ConfigModule.Elements = {}
        local allElements = {}

        -- DEBUG: Print Window structure
        print("[ ConfigManager ] DEBUG: Scanning Window structure...")
        print("[ ConfigManager ] Window type: " .. type(ConfigManager.Window))

        -- Method 1: Check Window.AllElements (standard)
        if ConfigManager.Window.AllElements and type(ConfigManager.Window.AllElements) == "table" then
            local count = 0
            for _ in pairs(ConfigManager.Window.AllElements) do count = count + 1 end
            print("[ ConfigManager ] Found Window.AllElements with " .. count .. " items")
            for _, element in pairs(ConfigManager.Window.AllElements) do
                if type(element) == "table" then
                    table.insert(allElements, element)
                end
            end
        else
            print("[ ConfigManager ] Window.AllElements not found or empty")
        end

        -- Method 2: Check Window.Elements (alternative)
        if ConfigManager.Window.Elements and type(ConfigManager.Window.Elements) == "table" then
            local count = 0
            for _ in pairs(ConfigManager.Window.Elements) do count = count + 1 end
            print("[ ConfigManager ] Found Window.Elements with " .. count .. " items")
            for _, element in pairs(ConfigManager.Window.Elements) do
                if type(element) == "table" then
                    table.insert(allElements, element)
                end
            end
        end

        -- Method 3: Scan through Tabs and their elements
        if ConfigManager.Window.Tabs and type(ConfigManager.Window.Tabs) == "table" then
            print("[ ConfigManager ] Found Window.Tabs, scanning...")
            for tabName, tab in pairs(ConfigManager.Window.Tabs) do
                if type(tab) == "table" then
                    print("[ ConfigManager ] Checking tab: " .. tostring(tabName))

                    -- Check tab.Elements
                    if tab.Elements and type(tab.Elements) == "table" then
                        local count = 0
                        for _ in pairs(tab.Elements) do count = count + 1 end
                        print("[ ConfigManager ] Found " .. count .. " elements in tab.Elements: " .. tostring(tabName))
                        for _, element in pairs(tab.Elements) do
                            if type(element) == "table" then
                                table.insert(allElements, element)
                            end
                        end
                    end

                    -- Check tab.AllElements
                    if tab.AllElements and type(tab.AllElements) == "table" then
                        print("[ ConfigManager ] Found tab.AllElements in: " .. tostring(tabName))
                        for _, element in pairs(tab.AllElements) do
                            if type(element) == "table" then
                                table.insert(allElements, element)
                            end
                        end
                    end
                end
            end
        else
            print("[ ConfigManager ] Window.Tabs not found")
        end

        -- Method 4: Recursive scan for any object with __type property
        local function scanForElements(obj, depth, path, visited)
            if depth > 4 or type(obj) ~= "table" or visited[obj] then return end
            visited[obj] = true

            -- Check if this object is an element
            if obj.__type and type(obj.__type) == "string" then
                table.insert(allElements, obj)
            end

            -- Recursively scan children
            for k, v in pairs(obj) do
                if type(v) == "table" and k ~= "Parent" and k ~= "Window" and k ~= "_G" then
                    scanForElements(v, depth + 1, path .. "." .. tostring(k), visited)
                end
            end
        end

        if #allElements == 0 then
            print("[ ConfigManager ] No elements found via standard methods, performing deep scan...")
            scanForElements(ConfigManager.Window, 0, "Window", {})
            print("[ ConfigManager ] Deep scan found " .. #allElements .. " potential elements")
        end

        print("[ ConfigManager ] Total elements found: " .. #allElements)

        -- Process and filter elements
        local count = 0
        local seen = {}

        for i, element in ipairs(allElements) do
            -- Skip duplicates
            if seen[element] then
                continue
            end
            seen[element] = true

            if element and element.__type then
                local elementType = tostring(element.__type)

                -- Skip elements yang tidak perlu disimpan
                if elementType == "Paragraph" or
                   elementType == "Button" or
                   elementType == "Section" or
                   elementType == "Divider" or
                   elementType == "Space" or
                   elementType == "Image" or
                   elementType == "Code" or
                   elementType == "Label" or
                   elementType == "SubLabel" or
                   elementType == "Header" then
                    continue
                end

                -- Skip jika title ada di excluded list
                if element.Title and ConfigManager.ExcludedTitles[element.Title] then
                    print("[ ConfigManager ] Skipped excluded: " .. tostring(element.Title))
                    continue
                end

                -- Gunakan Title sebagai key jika ada, fallback ke Flag atau index
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

                print("[ ConfigManager ] Registered: " .. elementName .. " (" .. elementType .. ")")
            end
        end

        if count == 0 then
            warn("[ ConfigManager ] WARNING: No elements registered!")
            warn("[ ConfigManager ] Window properties: " .. table.concat((function()
                local props = {}
                for k, v in pairs(ConfigManager.Window) do
                    table.insert(props, k .. ":" .. type(v))
                end
                return props
            end)(), ", "))
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

-- Helper function to debug Window structure
function ConfigManager:DebugWindow()
    if not ConfigManager.Window then
        warn("[ ConfigManager ] Window is not set")
        return
    end

    print("====== ConfigManager Window Debug ======")
    print("Window type: " .. type(ConfigManager.Window))

    local function printTable(tbl, indent, maxDepth, currentDepth, visited)
        indent = indent or ""
        maxDepth = maxDepth or 3
        currentDepth = currentDepth or 0
        visited = visited or {}

        if currentDepth >= maxDepth then return end
        if visited[tbl] then
            print(indent .. "[circular reference]")
            return
        end
        visited[tbl] = true

        for k, v in pairs(tbl) do
            if type(v) == "table" then
                print(indent .. tostring(k) .. ": [table]")
                if k ~= "Parent" and k ~= "Window" and k ~= "_G" then
                    printTable(v, indent .. "  ", maxDepth, currentDepth + 1, visited)
                end
            else
                local valueStr = tostring(v)
                if #valueStr > 50 then
                    valueStr = valueStr:sub(1, 50) .. "..."
                end
                print(indent .. tostring(k) .. ": " .. type(v) .. " = " .. valueStr)
            end
        end
    end

    printTable(ConfigManager.Window, "", 2)
    print("========================================")
end

-- Helper function to manually populate AllElements if it doesn't exist
function ConfigManager:PopulateAllElements()
    if not ConfigManager.Window then
        warn("[ ConfigManager ] Window is not set")
        return
    end

    if not ConfigManager.Window.AllElements then
        ConfigManager.Window.AllElements = {}
    end

    local function scanAndAdd(obj, visited)
        if type(obj) ~= "table" or visited[obj] then return end
        visited[obj] = true

        -- Check if this is an element
        if obj.__type and type(obj.__type) == "string" then
            -- Check if not already in AllElements
            local found = false
            for _, el in ipairs(ConfigManager.Window.AllElements) do
                if el == obj then
                    found = true
                    break
                end
            end
            if not found then
                table.insert(ConfigManager.Window.AllElements, obj)
            end
        end

        -- Scan children
        for k, v in pairs(obj) do
            if type(v) == "table" and k ~= "Parent" and k ~= "Window" and k ~= "_G" then
                scanAndAdd(v, visited)
            end
        end
    end

    scanAndAdd(ConfigManager.Window, {})
    print("[ ConfigManager ] Populated AllElements with " .. #ConfigManager.Window.AllElements .. " elements")
end

return ConfigManager
