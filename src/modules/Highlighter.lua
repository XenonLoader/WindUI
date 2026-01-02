-- Credits: https://devforum.roblox.com/t/realtime-richtext-lua-syntax-highlighting/2500399
-- Modified by me (Footagesus)

local highlighter = {}
local keywords = {
	lua = {
		"and", "break", "or", "else", "elseif", "if", "then", "until", "repeat", "while", "do", "for", "in", "end",
		"local", "return", "function", "export", "continue", "goto",
	},
	rbx = {
		"game", "workspace", "script", "math", "string", "table", "task", "wait", "select", "next", "Enum",
		"tick", "assert", "shared", "loadstring", "tonumber", "tostring", "type",
		"typeof", "unpack", "Instance", "CFrame", "Vector3", "Vector2", "Color3", "UDim", "UDim2", "Ray", "BrickColor",
		"OverlapParams", "RaycastParams", "Axes", "Random", "Region3", "Rect", "TweenInfo",
		"collectgarbage", "not", "utf8", "pcall", "xpcall", "_G", "setmetatable", "getmetatable", "os", "pairs", "ipairs",
		"require", "spawn", "delay", "warn", "error", "print", "DateTime", "NumberSequence", "ColorSequence",
		"PhysicalProperties", "NumberRange", "PathWaypoint", "coroutine", "debug", "newproxy",
	},
	operators = {
		"#", "+", "-", "*", "%", "/", "^", "=", "~", "=", "<", ">", "//", "+=", "-=", "*=", "/=", "//=", "^=", "..=", "and", "or", "not",
	}
}

local colors = {
    numbers = Color3.fromHex("#FAB387"),
    boolean = Color3.fromHex("#FAB387"),
    operator = Color3.fromHex("#94E2D5"),
    lua = Color3.fromHex("#CBA6F7"),
    rbx = Color3.fromHex("#F38BA8"),
    str = Color3.fromHex("#A6E3A1"),
    comment = Color3.fromHex("#9399B2"),
    null = Color3.fromHex("#F38BA8"),
    call = Color3.fromHex("#89B4FA"),    
    self_call = Color3.fromHex("#89B4FA"),
    local_property = Color3.fromHex("#CBA6F7"),
    builtin = Color3.fromHex("#F9E2AF"),
}

local builtinFunctions = {
	"print", "warn", "error", "assert", "type", "typeof", "tonumber", "tostring",
	"pairs", "ipairs", "next", "select", "pcall", "xpcall", "getmetatable", "setmetatable",
	"rawget", "rawset", "rawequal", "require", "wait", "spawn", "delay", "tick",
}

local function createKeywordSet(keywords)
	local keywordSet = {}
	for _, keyword in ipairs(keywords) do
		keywordSet[keyword] = true
	end
	return keywordSet
end

local luaSet = createKeywordSet(keywords.lua)
local rbxSet = createKeywordSet(keywords.rbx)
local operatorsSet = createKeywordSet(keywords.operators)
local builtinSet = createKeywordSet(builtinFunctions)

local function getHighlight(tokens, index)
	local token = tokens[index]

	if colors[token .. "_color"] then
		return colors[token .. "_color"]
	end

	if tonumber(token) then
		return colors.numbers
	elseif token == "nil" then
		return colors.null
	elseif token:sub(1, 2) == "--" then
		return colors.comment
	elseif operatorsSet[token] then
		return colors.operator
	elseif luaSet[token] then
		return colors.lua
	elseif rbxSet[token] then
		return colors.rbx
	elseif token:sub(1, 1) == "\"" or token:sub(1, 1) == "\'" or token:sub(1, 2) == "[[" then
		return colors.str
	elseif token == "true" or token == "false" then
		return colors.boolean
	end

	if tokens[index + 1] == "(" then
		if tokens[index - 1] == ":" then
			return colors.self_call
		end
		
		if builtinSet[token] then
			return colors.builtin
		end

		return colors.call
	end

	if tokens[index - 1] == "." then
		if tokens[index - 2] == "Enum" then
			return colors.rbx
		end

		return colors.local_property
	end
	
	if tokens[index - 1] == ":" and tokens[index + 1] == "(" then
		return colors.self_call
	end
end

function highlighter.run(source)
	local tokens = {}
	local currentToken = ""
	
	local inString = false
	local inComment = false
	local commentPersist = false
	local inMultilineString = false
	
	for i = 1, #source do
		local character = source:sub(i, i)
		
		if inComment then
			if character == "\n" and not commentPersist then
				table.insert(tokens, currentToken)
				table.insert(tokens, character)
				currentToken = ""
				
				inComment = false
			elseif source:sub(i - 1, i) == "]]" and commentPersist then
				currentToken = currentToken .. "]"
				
				table.insert(tokens, currentToken)
				currentToken = ""
				
				inComment = false
				commentPersist = false
			else
				currentToken = currentToken .. character
			end
		elseif inMultilineString then
			currentToken = currentToken .. character
			if source:sub(i - 1, i) == "]]" then
				table.insert(tokens, currentToken)
				currentToken = ""
				inMultilineString = false
			end
		elseif inString then
			if character == inString and source:sub(i-1, i-1) ~= "\\" or character == "\n" then
				currentToken = currentToken .. character
				table.insert(tokens, currentToken)
				currentToken = ""
				inString = false
			else
				currentToken = currentToken .. character
			end
		else
			if source:sub(i, i + 1) == "--" then
				if currentToken ~= "" then
					table.insert(tokens, currentToken)
				end
				currentToken = "-"
				inComment = true
				commentPersist = source:sub(i + 2, i + 3) == "[["
			elseif source:sub(i, i + 1) == "[[" then
				if currentToken ~= "" then
					table.insert(tokens, currentToken)
				end
				currentToken = "[["
				inMultilineString = true
			elseif character == "\"" or character == "\'" then
				if currentToken ~= "" then
					table.insert(tokens, currentToken)
				end
				currentToken = character
				inString = character
			elseif source:sub(i, i + 1) == "//" or source:sub(i, i + 1) == "+=" or 
			       source:sub(i, i + 1) == "-=" or source:sub(i, i + 1) == "*=" or 
			       source:sub(i, i + 1) == "/=" or source:sub(i, i + 1) == "^=" or
			       source:sub(i, i + 2) == "//=" or source:sub(i, i + 2) == "..=" then
				if currentToken ~= "" then
					table.insert(tokens, currentToken)
				end
				local opLen = (source:sub(i, i + 2) == "//=" or source:sub(i, i + 2) == "..=") and 3 or 2
				table.insert(tokens, source:sub(i, i + opLen - 1))
				currentToken = ""
			elseif operatorsSet[character] then
				if currentToken ~= "" then
					table.insert(tokens, currentToken)
				end
				table.insert(tokens, character)
				currentToken = ""
			elseif character:match("[%w_]") then
				currentToken = currentToken .. character
			else
				if currentToken ~= "" then
					table.insert(tokens, currentToken)
				end
				table.insert(tokens, character)
				currentToken = ""
			end
		end
	end
	
	if currentToken ~= "" then
		table.insert(tokens, currentToken)
	end

	local highlighted = {}
	
	for i, token in ipairs(tokens) do
		local highlight = getHighlight(tokens, i)

		if highlight then
			local syntax = string.format("<font color=\"#%s\">%s</font>", highlight:ToHex(), token:gsub("<", "&lt;"):gsub(">", "&gt;"))
			
			table.insert(highlighted, syntax)
		else
			table.insert(highlighted, token:gsub("<", "&lt;"):gsub(">", "&gt;"))
		end
	end

	return table.concat(highlighted)
end

return highlighter