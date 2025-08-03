local UserInputService = game:GetService("UserInputService")
local Mouse = game:GetService("Players").LocalPlayer:GetMouse()
local Camera = game:GetService("Workspace").CurrentCamera

local Creator = require("../modules/Creator")
local New = Creator.New
local Tween = Creator.Tween

local CreateLabel = require("../components/ui/Label").New

local Element = {
    UICorner = 10,
    UIPadding = 12,
    MenuCorner = 12,
    MenuPadding = 8,
    TabPadding = 12,
}

function Element:New(Config)
    local Dropdown = {
        __type = "Dropdown",
        Title = Config.Title or "Dropdown",
        Desc = Config.Desc or nil,
        Locked = Config.Locked or false,
        Values = Config.Values or {},
        MenuWidth = Config.MenuWidth or 200,
        Value = Config.Value,
        AllowNone = Config.AllowNone,
        Multi = Config.Multi,
        Callback = Config.Callback or function() end,
        
        UIElements = {},
        
        Opened = false,
        Tabs = {},
        FilteredValues = {}, -- For search functionality
        SearchText = "", -- Current search text
    }
    
    if Dropdown.Multi and not Dropdown.Value then
        Dropdown.Value = {}
    end
    
    -- Initialize filtered values with all values
    Dropdown.FilteredValues = Dropdown.Values
    
    local CanCallback = true
    
    Dropdown.DropdownFrame = require("../components/window/Element")({
        Title = Dropdown.Title,
        Desc = Dropdown.Desc,
        Parent = Config.Parent,
        TextOffset = 0,
        Hover = false,
    })
    
    
    Dropdown.UIElements.Dropdown = CreateLabel("", nil, Dropdown.DropdownFrame.UIElements.Container)
    
    Dropdown.UIElements.Dropdown.Frame.Frame.TextLabel.TextTruncate = "AtEnd"
    Dropdown.UIElements.Dropdown.Frame.Frame.TextLabel.Size = UDim2.new(1, Dropdown.UIElements.Dropdown.Frame.Frame.TextLabel.Size.X.Offset - 18 - 12 - 12,0,0)
    
    Dropdown.UIElements.Dropdown.Size = UDim2.new(1,0,0,40)
    
    local DropdownIcon = New("ImageLabel", {
        Image = Creator.Icon("chevrons-up-down")[1],
        ImageRectOffset = Creator.Icon("chevrons-up-down")[2].ImageRectPosition,
        ImageRectSize = Creator.Icon("chevrons-up-down")[2].ImageRectSize,
        Size = UDim2.new(0,18,0,18),
        Position = UDim2.new(1,-12,0.5,0),
        ThemeTag = {
            ImageColor3 = "Icon"
        },
        AnchorPoint = Vector2.new(1,0.5),
        Parent = Dropdown.UIElements.Dropdown.Frame
    })

    Dropdown.UIElements.UIListLayout = New("UIListLayout", {
        Padding = UDim.new(0,Element.MenuPadding),
        FillDirection = "Vertical"
    })

    -- Search TextBox with improved styling
    Dropdown.UIElements.SearchBox = New("TextBox", {
        Size = UDim2.new(1,0,0,36),
        BackgroundColor3 = Color3.fromRGB(45, 45, 45),
        BorderSizePixel = 0,
        Text = "",
        PlaceholderText = "Search...",
        PlaceholderColor3 = Color3.fromRGB(120, 120, 120),
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 14,
        FontFace = Font.new(Creator.Font, Enum.FontWeight.Regular),
        TextXAlignment = "Left",
        ClearTextOnFocus = false,
        ThemeTag = {
            BackgroundColor3 = "ElementBackground",
            TextColor3 = "Text",
        },
    }, {
        New("UICorner", {
            CornerRadius = UDim.new(0, 8),
        }),
        New("UIPadding", {
            PaddingLeft = UDim.new(0, 12),
            PaddingRight = UDim.new(0, 12),
            PaddingTop = UDim.new(0, 6),
            PaddingBottom = UDim.new(0, 6),
        }),
        New("UIStroke", {
            Color = Color3.fromRGB(60, 60, 60),
            Thickness = 1,
            Transparency = 0.5,
            ThemeTag = {
                Color = "Border"
            }
        })
    })

    -- Improved menu container with better shadow and positioning
    Dropdown.UIElements.Menu = Creator.NewRoundFrame(Element.MenuCorner, "Squircle", {
        ThemeTag = {
            ImageColor3 = "Background",
        },
        ImageTransparency = 0.02,
        Size = UDim2.new(1,0,1,0),
        AnchorPoint = Vector2.new(0,0),
        Position = UDim2.new(0,0,0,0),
    }, {
        -- Drop shadow effect
        Creator.NewRoundFrame(Element.MenuCorner, "Squircle", {
            Size = UDim2.new(1,2,1,2),
            Position = UDim2.new(0,-1,0,-1),
            ImageColor3 = Color3.fromRGB(0, 0, 0),
            ImageTransparency = 0.8,
            ZIndex = -1,
        }),
        New("UIPadding", {
            PaddingTop = UDim.new(0, Element.MenuPadding),
            PaddingLeft = UDim.new(0, Element.MenuPadding),
            PaddingRight = UDim.new(0, Element.MenuPadding),
            PaddingBottom = UDim.new(0, Element.MenuPadding),
        }),
        New("UIStroke", {
            Color = Color3.fromRGB(70, 70, 70),
            Thickness = 1,
            Transparency = 0.3,
            ThemeTag = {
                Color = "Border"
            }
        }),
		New("Frame", {
		    BackgroundTransparency = 1,
		    Size = UDim2.new(1,0,1,0),
		    ClipsDescendants = true
		}, {
		    New("UICorner", {
		        CornerRadius = UDim.new(0,Element.MenuCorner - Element.MenuPadding),
		    }),
            New("Frame", {
                Size = UDim2.new(1,0,1,0),
                BackgroundTransparency = 1,
            }, {
                New("UIListLayout", {
                    Padding = UDim.new(0, 6),
                    FillDirection = "Vertical"
                }),
                Dropdown.UIElements.SearchBox,
                New("ScrollingFrame", {
                    Size = UDim2.new(1,0,1,-42), -- Adjust for search box with better spacing
                    ScrollBarThickness = 4,
                    ScrollingDirection = "Y",
                    AutomaticCanvasSize = "Y",
                    CanvasSize = UDim2.new(0,0,0,0),
                    BackgroundTransparency = 1,
                    ScrollBarImageColor3 = Color3.fromRGB(100, 100, 100),
                    ScrollBarImageTransparency = 0.5,
                    BorderSizePixel = 0,
                    ThemeTag = {
                        ScrollBarImageColor3 = "ScrollBar"
                    }
                }, {
                    Dropdown.UIElements.UIListLayout,
                    New("UIPadding", {
                        PaddingRight = UDim.new(0, 4),
                    }),
                })
            })
		})
    })

    -- Fixed positioning container that stays below dropdown
    Dropdown.UIElements.MenuCanvas = New("Frame", {
        Size = UDim2.new(0,Dropdown.MenuWidth,0,300),
        BackgroundTransparency = 1,
        Position = UDim2.new(0,0,1,4), -- Position below dropdown with 4px gap
        Visible = false,
        Active = false,
        Parent = Dropdown.DropdownFrame.UIElements.Container,
        AnchorPoint = Vector2.new(0,0),
        ZIndex = 1000, -- High ZIndex to appear above other elements
    }, {
        Dropdown.UIElements.Menu,
        New("UISizeConstraint", {
            MinSize = Vector2.new(180,0),
            MaxSize = Vector2.new(400,350)
        })
    })
    
    -- Search functionality
    function Dropdown:FilterValues(searchText)
        Dropdown.SearchText = searchText:lower()
        Dropdown.FilteredValues = {}
        
        if Dropdown.SearchText == "" then
            Dropdown.FilteredValues = Dropdown.Values
        else
            for _, value in ipairs(Dropdown.Values) do
                if value:lower():find(Dropdown.SearchText, 1, true) then
                    table.insert(Dropdown.FilteredValues, value)
                end
            end
        end
        
        Dropdown:Refresh(Dropdown.FilteredValues)
    end
    
    -- Connect search box events
    Creator.AddSignal(Dropdown.UIElements.SearchBox:GetPropertyChangedSignal("Text"), function()
        Dropdown:FilterValues(Dropdown.UIElements.SearchBox.Text)
    end)
    
    -- Enhanced search box focus effects
    Creator.AddSignal(Dropdown.UIElements.SearchBox.Focused, function()
        Tween(Dropdown.UIElements.SearchBox.UIStroke, 0.2, {
            Color = Color3.fromRGB(100, 150, 255),
            Transparency = 0.2
        }):Play()
    end)
    
    Creator.AddSignal(Dropdown.UIElements.SearchBox.FocusLost, function()
        Tween(Dropdown.UIElements.SearchBox.UIStroke, 0.2, {
            Color = Color3.fromRGB(60, 60, 60),
            Transparency = 0.5
        }):Play()
    end)
    
    function Dropdown:Lock()
        CanCallback = false
        return Dropdown.DropdownFrame:Lock()
    end
    function Dropdown:Unlock()
        CanCallback = true
        return Dropdown.DropdownFrame:Unlock()
    end
    
    if Dropdown.Locked then
        Dropdown:Lock()
    end
    
    local function RecalculateCanvasSize()
		Dropdown.UIElements.Menu.Frame.Frame.ScrollingFrame.CanvasSize = UDim2.fromOffset(0, Dropdown.UIElements.UIListLayout.AbsoluteContentSize.Y)
    end

    local function RecalculateListSize()
        local contentHeight = Dropdown.UIElements.UIListLayout.AbsoluteContentSize.Y + 48 + (Element.MenuPadding * 2) + 12 -- +48 for search box + padding
        local maxHeight = 320
        
		if contentHeight > maxHeight then
			Dropdown.UIElements.MenuCanvas.Size = UDim2.fromOffset(Dropdown.MenuWidth, maxHeight)
		else
			Dropdown.UIElements.MenuCanvas.Size = UDim2.fromOffset(Dropdown.MenuWidth, contentHeight)
		end
	end
    
    function Dropdown:Display()
		local Values = Dropdown.Values
		local Str = ""

		if Dropdown.Multi then
			for Idx, Value in next, Values do
				if table.find(Dropdown.Value, Value) then
					Str = Str .. Value .. ", "
				end
			end
			Str = Str:sub(1, #Str - 2)
		else
			Str = Dropdown.Value or ""
		end

		Dropdown.UIElements.Dropdown.Frame.Frame.TextLabel.Text = (Str == "" and "--" or Str)
	end
    
    function Dropdown:Refresh(Values)
        local scrollFrame = Dropdown.UIElements.Menu.Frame.Frame.ScrollingFrame
        
        -- Clear all existing tab items properly
        for _, child in pairs(scrollFrame:GetChildren()) do
            if not child:IsA("UIListLayout") and not child:IsA("UIPadding") then
                child:Destroy()
            end
        end
        
        -- Clear the tabs table completely
        Dropdown.Tabs = {}
        
        -- Wait a frame to ensure cleanup is complete
        task.wait()
        
        for Index,Tab in next, Values do
            local TabMain = {
                Name = Tab,
                Selected = false,
                UIElements = {},
            }
            
            -- Enhanced tab item with better styling
            TabMain.UIElements.TabItem = Creator.NewRoundFrame(8, "Squircle", {
                Size = UDim2.new(1,0,0,38),
                ImageTransparency = 1,
                Parent = scrollFrame,
                ImageColor3 = Color3.fromRGB(255,255,255),
                
            }, {
                -- Hover highlight
                Creator.NewRoundFrame(8, "SquircleOutline", {
                    Size = UDim2.new(1,0,1,0),
                    ImageColor3 = Color3.fromRGB(100, 150, 255),
                    ImageTransparency = 1,
                    Name = "Highlight",
                }),
                -- Selection background
                Creator.NewRoundFrame(8, "Squircle", {
                    Size = UDim2.new(1,0,1,0),
                    ImageColor3 = Color3.fromRGB(100, 150, 255),
                    ImageTransparency = 1,
                    Name = "Selection",
                }),
                New("TextButton", {
                    Size = UDim2.new(1,0,1,0),
                    BackgroundTransparency = 1,
                    Text = "",
                    AutoButtonColor = false,
                }, {
                    New("UIPadding", {
                        PaddingLeft = UDim.new(0,Element.TabPadding),
                        PaddingRight = UDim.new(0,Element.TabPadding),
                        PaddingTop = UDim.new(0,6),
                        PaddingBottom = UDim.new(0,6),
                    }),
                    New("UICorner", {
                        CornerRadius = UDim.new(0,8)
                    }),
                    New("TextLabel", {
                        Text = Tab,
                        TextXAlignment = "Left",
                        FontFace = Font.new(Creator.Font, Enum.FontWeight.Medium),
                        ThemeTag = {
                            TextColor3 = "Text",
                        },
                        TextSize = 14,
                        BackgroundTransparency = 1,
                        TextTransparency = 0.2,
                        AutomaticSize = "Y",
                        Size = UDim2.new(1,0,0,0),
                        AnchorPoint = Vector2.new(0,0.5),
                        Position = UDim2.new(0,0,0.5,0),
                    })
                })
            }, true)
        
            if Dropdown.Multi then
                TabMain.Selected = table.find(Dropdown.Value or {}, TabMain.Name)
            else
                TabMain.Selected = Dropdown.Value == TabMain.Name
            end
            
            if TabMain.Selected then
                TabMain.UIElements.TabItem.Selection.ImageTransparency = 0.85
                TabMain.UIElements.TabItem.TextButton.TextLabel.TextTransparency = 0
                TabMain.UIElements.TabItem.TextButton.TextLabel.FontFace = Font.new(Creator.Font, Enum.FontWeight.SemiBold)
            end
            
            Dropdown.Tabs[Index] = TabMain
            
            Dropdown:Display()
            
            local function Callback()
                Dropdown:Display()
                task.spawn(function()
                    Creator.SafeCallback(Dropdown.Callback, Dropdown.Value)
                end)
            end
            
            -- Enhanced hover effects
            Creator.AddSignal(TabMain.UIElements.TabItem.TextButton.MouseEnter, function()
                if not TabMain.Selected then
                    Tween(TabMain.UIElements.TabItem.Highlight, 0.15, {ImageTransparency = 0.9}):Play()
                    Tween(TabMain.UIElements.TabItem.TextButton.TextLabel, 0.15, {TextTransparency = 0.1}):Play()
                end
            end)
            
            Creator.AddSignal(TabMain.UIElements.TabItem.TextButton.MouseLeave, function()
                if not TabMain.Selected then
                    Tween(TabMain.UIElements.TabItem.Highlight, 0.15, {ImageTransparency = 1}):Play()
                    Tween(TabMain.UIElements.TabItem.TextButton.TextLabel, 0.15, {TextTransparency = 0.2}):Play()
                end
            end)
            
            Creator.AddSignal(TabMain.UIElements.TabItem.TextButton.MouseButton1Click, function()
                if Dropdown.Multi then
                    if not TabMain.Selected then
                        TabMain.Selected = true
                        Tween(TabMain.UIElements.TabItem.Selection, 0.2, {ImageTransparency = 0.85}):Play()
                        Tween(TabMain.UIElements.TabItem.TextButton.TextLabel, 0.2, {
                            TextTransparency = 0,
                        }):Play()
                        TabMain.UIElements.TabItem.TextButton.TextLabel.FontFace = Font.new(Creator.Font, Enum.FontWeight.SemiBold)
                        table.insert(Dropdown.Value, TabMain.Name)
                    else
                        if not Dropdown.AllowNone and #Dropdown.Value == 1 then
                            return
                        end
                        TabMain.Selected = false
                        Tween(TabMain.UIElements.TabItem.Selection, 0.2, {ImageTransparency = 1}):Play()
                        Tween(TabMain.UIElements.TabItem.TextButton.TextLabel, 0.2, {
                            TextTransparency = 0.2,
                        }):Play()
                        TabMain.UIElements.TabItem.TextButton.TextLabel.FontFace = Font.new(Creator.Font, Enum.FontWeight.Medium)
                        for i, v in ipairs(Dropdown.Value) do
                            if v == TabMain.Name then
                                table.remove(Dropdown.Value, i)
                                break
                            end
                        end
                    end
                else
                    for Index, TabPisun in next, Dropdown.Tabs do
                        Tween(TabPisun.UIElements.TabItem.Selection, 0.2, {ImageTransparency = 1}):Play()
                        Tween(TabPisun.UIElements.TabItem.TextButton.TextLabel, 0.2, {
                            TextTransparency = 0.2,
                        }):Play()
                        TabPisun.UIElements.TabItem.TextButton.TextLabel.FontFace = Font.new(Creator.Font, Enum.FontWeight.Medium)
                        TabPisun.Selected = false
                    end
                    TabMain.Selected = true
                    Tween(TabMain.UIElements.TabItem.Selection, 0.2, {ImageTransparency = 0.85}):Play()
                    Tween(TabMain.UIElements.TabItem.TextButton.TextLabel, 0.2, {
                        TextTransparency = 0,
                    }):Play()
                    TabMain.UIElements.TabItem.TextButton.TextLabel.FontFace = Font.new(Creator.Font, Enum.FontWeight.SemiBold)
                    Dropdown.Value = TabMain.Name
                    
                    -- Auto close for single selection
                    task.wait(0.1)
                    Dropdown:Close()
                end
                Callback()
            end)
            
            RecalculateCanvasSize()
            RecalculateListSize()
        end
        
        -- Auto-resize based on content
        local maxWidth = Dropdown.MenuWidth
        for _, tabmain in next, Dropdown.Tabs do
            if tabmain.UIElements.TabItem.TextButton.TextLabel then
                local width = tabmain.UIElements.TabItem.TextButton.TextLabel.TextBounds.X + (Element.TabPadding * 2) + 20
                maxWidth = math.max(maxWidth, width)
            end
        end
        
        maxWidth = math.min(maxWidth, 400) -- Max width constraint
        Dropdown.UIElements.MenuCanvas.Size = UDim2.new(0, maxWidth, Dropdown.UIElements.MenuCanvas.Size.Y.Scale, Dropdown.UIElements.MenuCanvas.Size.Y.Offset)
    end
    
    Dropdown:Refresh(Dropdown.FilteredValues)
    
    function Dropdown:Select(Items)
        if Items then
            Dropdown.Value = Items
        else
            if Dropdown.Multi then
                Dropdown.Value = {}
            else
                Dropdown.Value = nil
            end
        end
        Dropdown:Refresh(Dropdown.FilteredValues)
    end
    
    RecalculateListSize()
    
    function Dropdown:Open()
        if CanCallback then
            Dropdown.UIElements.Menu.Visible = true
            Dropdown.UIElements.MenuCanvas.Visible = true
            Dropdown.UIElements.MenuCanvas.Active = true
            Dropdown.UIElements.Menu.Size = UDim2.new(1, 0, 0, 0)
            
            -- Smooth opening animation
            Tween(Dropdown.UIElements.Menu, 0.25, {
                Size = UDim2.new(1, 0, 1, 0)
            }, Enum.EasingStyle.Quart, Enum.EasingDirection.Out):Play()
            
            -- Animate dropdown icon rotation
            Tween(DropdownIcon, 0.25, {
                Rotation = 180
            }, Enum.EasingStyle.Quart, Enum.EasingDirection.Out):Play()
            
            -- Focus search box after animation
            task.spawn(function()
                task.wait(0.1)
                Dropdown.UIElements.SearchBox:CaptureFocus()
                Dropdown.Opened = true
            end)
        end
    end
    
    function Dropdown:Close()
        Dropdown.Opened = false
        
        -- Clear search when closing
        Dropdown.UIElements.SearchBox.Text = ""
        Dropdown:FilterValues("")
        
        -- Smooth closing animation
        Tween(Dropdown.UIElements.Menu, 0.2, {
            Size = UDim2.new(1, 0, 0, 0)
        }, Enum.EasingStyle.Quart, Enum.EasingDirection.Out):Play()
        
        -- Animate dropdown icon back
        Tween(DropdownIcon, 0.2, {
            Rotation = 0
        }, Enum.EasingStyle.Quart, Enum.EasingDirection.Out):Play()
        
        task.spawn(function()
            task.wait(.15)
            Dropdown.UIElements.Menu.Visible = false
        end)
        
        task.spawn(function()
            task.wait(.2)
            Dropdown.UIElements.MenuCanvas.Visible = false
            Dropdown.UIElements.MenuCanvas.Active = false
        end)
    end
    
    Creator.AddSignal(Dropdown.UIElements.Dropdown.MouseButton1Click, function()
        if Dropdown.Opened then
            Dropdown:Close()
        else
            Dropdown:Open()
        end
    end)
    
    -- Improved click outside detection
    Creator.AddSignal(UserInputService.InputBegan, function(Input)
		if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
			local AbsPos, AbsSize = Dropdown.UIElements.MenuCanvas.AbsolutePosition, Dropdown.UIElements.MenuCanvas.AbsoluteSize
			local DropdownPos, DropdownSize = Dropdown.UIElements.Dropdown.AbsolutePosition, Dropdown.UIElements.Dropdown.AbsoluteSize
			
			if Dropdown.Opened then
			    local clickedOnDropdown = (Mouse.X >= DropdownPos.X and Mouse.X <= DropdownPos.X + DropdownSize.X and 
			                             Mouse.Y >= DropdownPos.Y and Mouse.Y <= DropdownPos.Y + DropdownSize.Y)
			    local clickedOnMenu = (Mouse.X >= AbsPos.X and Mouse.X <= AbsPos.X + AbsSize.X and 
			                          Mouse.Y >= AbsPos.Y and Mouse.Y <= AbsPos.Y + AbsSize.Y)
			    
			    if not clickedOnDropdown and not clickedOnMenu then
			        Dropdown:Close()
			    end
			end
		end
	end)
    
    -- Handle escape key to close dropdown
    Creator.AddSignal(UserInputService.InputBegan, function(Input)
        if Input.KeyCode == Enum.KeyCode.Escape and Dropdown.Opened then
            Dropdown:Close()
        end
    end)
    
    return Dropdown.__type, Dropdown
end

return Element