local UserInputService = game:GetService("UserInputService")
local Mouse = game:GetService("Players").LocalPlayer:GetMouse()
local Camera = game:GetService("Workspace").CurrentCamera
local TweenService = game:GetService("TweenService")

local Creator = require("../modules/Creator")
local New = Creator.New
local Tween = Creator.Tween

local CreateLabel = require("../components/ui/Label").New

local Element = {
    UICorner = 10,
    UIPadding = 12,
    MenuCorner = 15,
    MenuPadding = 8,
    TabPadding = 12,
    SearchPadding = 6,
}

function Element:New(Config)
    local Dropdown = {
        __type = "SearchDropdown",
        Title = Config.Title or "Search Dropdown",
        Desc = Config.Desc or nil,
        Locked = Config.Locked or false,
        Values = Config.Values or {},
        FilteredValues = {},
        MenuWidth = Config.MenuWidth or 200,
        MaxHeight = Config.MaxHeight or 250,
        Value = Config.Value,
        AllowNone = Config.AllowNone or true,
        Multi = Config.Multi or false,
        Placeholder = Config.Placeholder or "Search...",
        Callback = Config.Callback or function() end,
        
        UIElements = {},
        
        Opened = false,
        Tabs = {},
        SearchText = ""
    }
    
    -- Initialize filtered values
    Dropdown.FilteredValues = {}
    for i, v in ipairs(Dropdown.Values) do
        table.insert(Dropdown.FilteredValues, v)
    end
    
    if Dropdown.Multi and not Dropdown.Value then
        Dropdown.Value = {}
    end
    
    local CanCallback = true
    
    -- Main dropdown frame
    Dropdown.DropdownFrame = require("../components/window/Element")({
        Title = Dropdown.Title,
        Desc = Dropdown.Desc,
        Parent = Config.Parent,
        TextOffset = 0,
        Hover = false,
    })
    
    -- Display label for selected values
    Dropdown.UIElements.Display = CreateLabel("", nil, Dropdown.DropdownFrame.UIElements.Container)
    Dropdown.UIElements.Display.Frame.Frame.TextLabel.TextTruncate = "AtEnd"
    Dropdown.UIElements.Display.Frame.Frame.TextLabel.Size = UDim2.new(1, -30, 1, 0)
    Dropdown.UIElements.Display.Size = UDim2.new(1, 0, 0, 40)
    
    -- Dropdown arrow icon
    local DropdownIcon = New("ImageLabel", {
        Image = Creator.Icon("chevron-down")[1],
        ImageRectOffset = Creator.Icon("chevron-down")[2].ImageRectPosition,
        ImageRectSize = Creator.Icon("chevron-down")[2].ImageRectSize,
        Size = UDim2.new(0, 16, 0, 16),
        Position = UDim2.new(1, -18, 0.5, 0),
        ThemeTag = {
            ImageColor3 = "Icon"
        },
        AnchorPoint = Vector2.new(1, 0.5),
        Parent = Dropdown.UIElements.Display.Frame
    })
    
    -- Search input frame (with background and padding)
    Dropdown.UIElements.SearchFrame = Creator.NewRoundFrame(Element.UICorner, "Squircle", {
        ThemeTag = {
            ImageColor3 = "Element",
        },
        ImageTransparency = 0.05,
        Size = UDim2.new(1, 0, 0, 36),
        Visible = false,
        Parent = Dropdown.DropdownFrame.UIElements.Container,
    }, {
        New("UIPadding", {
            PaddingTop = UDim.new(0, Element.SearchPadding),
            PaddingLeft = UDim.new(0, Element.SearchPadding + 4),
            PaddingRight = UDim.new(0, Element.SearchPadding + 4),
            PaddingBottom = UDim.new(0, Element.SearchPadding),
        }),
        New("Frame", {
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 1, 0),
        }, {
            New("ImageLabel", {
                Image = Creator.Icon("search")[1],
                ImageRectOffset = Creator.Icon("search")[2].ImageRectPosition,
                ImageRectSize = Creator.Icon("search")[2].ImageRectSize,
                Size = UDim2.new(0, 16, 0, 16),
                Position = UDim2.new(0, 0, 0.5, 0),
                ThemeTag = {
                    ImageColor3 = "SubText"
                },
                AnchorPoint = Vector2.new(0, 0.5),
                BackgroundTransparency = 1,
            }),
            New("TextBox", {
                PlaceholderText = Dropdown.Placeholder,
                Text = "",
                TextXAlignment = "Left",
                FontFace = Font.new(Creator.Font, Enum.FontWeight.Regular),
                ThemeTag = {
                    TextColor3 = "Text",
                    PlaceholderColor3 = "SubText"
                },
                TextSize = 14,
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                Size = UDim2.new(1, -20, 1, 0),
                Position = UDim2.new(0, 20, 0, 0),
                ClearTextOnFocus = false,
                Name = "SearchInput"
            })
        })
    })
    
    Dropdown.UIElements.SearchInput = Dropdown.UIElements.SearchFrame.SearchInput
    
    -- List layout for dropdown items
    Dropdown.UIElements.UIListLayout = New("UIListLayout", {
        Padding = UDim.new(0, 2),
        FillDirection = "Vertical"
    })
    
    -- Main menu container
    Dropdown.UIElements.Menu = Creator.NewRoundFrame(Element.MenuCorner, "Squircle", {
        ThemeTag = {
            ImageColor3 = "Background",
        },
        ImageTransparency = 0.02,
        Size = UDim2.new(1, 0, 1, 0),
        AnchorPoint = Vector2.new(0, 0),
        Position = UDim2.new(0, 0, 0, 0),
    }, {
        New("UIPadding", {
            PaddingTop = UDim.new(0, Element.MenuPadding),
            PaddingLeft = UDim.new(0, Element.MenuPadding),
            PaddingRight = UDim.new(0, Element.MenuPadding),
            PaddingBottom = UDim.new(0, Element.MenuPadding),
        }),
        New("Frame", {
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 1, 0),
            ClipsDescendants = true
        }, {
            New("UICorner", {
                CornerRadius = UDim.new(0, Element.MenuCorner - Element.MenuPadding),
            }),
            New("ScrollingFrame", {
                Size = UDim2.new(1, 0, 1, 0),
                ScrollBarThickness = 3,
                ScrollingDirection = "Y",
                AutomaticCanvasSize = "Y",
                CanvasSize = UDim2.new(0, 0, 0, 0),
                BackgroundTransparency = 1,
                ScrollBarImageTransparency = 0.8,
                ThemeTag = {
                    ScrollBarImageColor3 = "SubText"
                },
                Name = "DropdownScroll"
            }, {
                Dropdown.UIElements.UIListLayout,
            })
        })
    })
    
    -- Menu canvas (positioned below dropdown)
    Dropdown.UIElements.MenuCanvas = New("Frame", {
        Size = UDim2.new(0, Dropdown.MenuWidth, 0, 0),
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 0, 1, 4), -- Position below dropdown with 4px gap
        Visible = false,
        Active = true, -- Make sure it's active for clicks
        Parent = Dropdown.DropdownFrame.UIElements.Container, -- Changed parent
        ClipsDescendants = false,
    }, {
        Dropdown.UIElements.Menu,
        New("UISizeConstraint", {
            MinSize = Vector2.new(180, 0),
            MaxSize = Vector2.new(400, Dropdown.MaxHeight)
        }),
        -- Drop shadow effect
        New("ImageLabel", {
            Image = "rbxasset://textures/ui/GuiImagePlaceholder.png",
            ImageTransparency = 0.95,
            Size = UDim2.new(1, 4, 1, 4),
            Position = UDim2.new(0, 2, 0, 2),
            BackgroundTransparency = 1,
            ZIndex = -1,
        })
    })
    
    -- Lock/Unlock functions
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
    
    -- Helper functions
    local function RecalculateCanvasSize()
        local scrollFrame = Dropdown.UIElements.Menu.Frame.DropdownScroll
        scrollFrame.CanvasSize = UDim2.fromOffset(0, Dropdown.UIElements.UIListLayout.AbsoluteContentSize.Y)
    end
    
    local function RecalculateListSize()
        local contentHeight = Dropdown.UIElements.UIListLayout.AbsoluteContentSize.Y + (Element.MenuPadding * 2)
        local maxHeight = math.min(contentHeight, Dropdown.MaxHeight)
        
        Dropdown.UIElements.MenuCanvas.Size = UDim2.fromOffset(
            Dropdown.UIElements.MenuCanvas.AbsoluteSize.X, 
            maxHeight
        )
    end
    
    -- Filter function for search
    local function FilterValues(searchText)
        Dropdown.FilteredValues = {}
        
        if searchText == "" then
            for i, v in ipairs(Dropdown.Values) do
                table.insert(Dropdown.FilteredValues, v)
            end
        else
            local lowerSearch = string.lower(searchText)
            for i, v in ipairs(Dropdown.Values) do
                if string.find(string.lower(tostring(v)), lowerSearch, 1, true) then
                    table.insert(Dropdown.FilteredValues, v)
                end
            end
        end
        
        Dropdown:RefreshItems()
    end
    
    -- Display selected values
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

        Dropdown.UIElements.Display.Frame.Frame.TextLabel.Text = (Str == "" and "Select..." or Str)
    end
    
    -- Refresh dropdown items
    function Dropdown:RefreshItems()
        -- Clear existing items
        for _, Element in next, Dropdown.UIElements.Menu.Frame.DropdownScroll:GetChildren() do
            if not Element:IsA("UIListLayout") then
                Element:Destroy()
            end
        end
        
        Dropdown.Tabs = {}
        
        -- Create items from filtered values
        for Index, Tab in next, Dropdown.FilteredValues do
            local TabMain = {
                Name = Tab,
                Selected = false,
                UIElements = {},
            }
            
            -- Create item frame
            TabMain.UIElements.TabItem = New("TextButton", {
                Size = UDim2.new(1, 0, 0, 32),
                BackgroundTransparency = 1,
                Parent = Dropdown.UIElements.Menu.Frame.DropdownScroll,
                Text = "",
                AutoButtonColor = false,
            }, {
                Creator.NewRoundFrame(Element.UICorner - 2, "Squircle", {
                    Size = UDim2.new(1, 0, 1, 0),
                    ImageTransparency = 1,
                    ImageColor3 = Color3.new(1, 1, 1),
                    Name = "Background"
                }),
                -- Hover highlight
                Creator.NewRoundFrame(Element.UICorner - 2, "SquircleOutline", {
                    Size = UDim2.new(1, 0, 1, 0),
                    ImageColor3 = Color3.new(1, 1, 1),
                    ImageTransparency = 1,
                    Name = "Highlight",
                }, {
                    New("UIGradient", {
                        Rotation = 90,
                        Color = ColorSequence.new({
                            ColorSequenceKeypoint.new(0.0, Color3.fromRGB(255, 255, 255)),
                            ColorSequenceKeypoint.new(1.0, Color3.fromRGB(200, 200, 255)),
                        }),
                        Transparency = NumberSequence.new({
                            NumberSequenceKeypoint.new(0.0, 0.9),
                            NumberSequenceKeypoint.new(1.0, 0.95),
                        })
                    }),
                }),
                -- Content frame
                New("Frame", {
                    Size = UDim2.new(1, 0, 1, 0),
                    BackgroundTransparency = 1,
                }, {
                    New("UIPadding", {
                        PaddingLeft = UDim.new(0, Element.TabPadding),
                        PaddingRight = UDim.new(0, Element.TabPadding),
                    }),
                    New("UICorner", {
                        CornerRadius = UDim.new(0, Element.UICorner - 2)
                    }),
                    -- Selection indicator
                    New("Frame", {
                        Size = UDim2.new(0, 3, 0.6, 0),
                        Position = UDim2.new(0, 2, 0.5, 0),
                        AnchorPoint = Vector2.new(0, 0.5),
                        BackgroundTransparency = 1,
                        ThemeTag = {
                            BackgroundColor3 = "Accent"
                        },
                        Name = "SelectionBar"
                    }, {
                        New("UICorner", {
                            CornerRadius = UDim.new(0, 2)
                        })
                    }),
                    -- Text label
                    New("TextLabel", {
                        Text = Tab,
                        TextXAlignment = "Left",
                        FontFace = Font.new(Creator.Font, Enum.FontWeight.Regular),
                        ThemeTag = {
                            TextColor3 = "Text",
                        },
                        TextSize = 14,
                        BackgroundTransparency = 1,
                        TextTransparency = 0.2,
                        Size = UDim2.new(1, -8, 1, 0),
                        Position = UDim2.new(0, 8, 0, 0),
                        TextTruncate = "AtEnd",
                    })
                })
            })
            
            -- Check if selected
            if Dropdown.Multi then
                TabMain.Selected = table.find(Dropdown.Value or {}, TabMain.Name)
            else
                TabMain.Selected = Dropdown.Value == TabMain.Name
            end
            
            -- Apply selected state
            if TabMain.Selected then
                TabMain.UIElements.TabItem.Background.ImageTransparency = 0.92
                TabMain.UIElements.TabItem.Highlight.ImageTransparency = 0.85
                TabMain.UIElements.TabItem.Frame.TextLabel.TextTransparency = 0
                TabMain.UIElements.TabItem.Frame.SelectionBar.BackgroundTransparency = 0
            end
            
            Dropdown.Tabs[Index] = TabMain
            
            -- Click handler
            local function HandleClick()
                if Dropdown.Multi then
                    if not TabMain.Selected then
                        TabMain.Selected = true
                        Tween(TabMain.UIElements.TabItem.Background, 0.15, {ImageTransparency = 0.92}):Play()
                        Tween(TabMain.UIElements.TabItem.Highlight, 0.15, {ImageTransparency = 0.85}):Play()
                        Tween(TabMain.UIElements.TabItem.Frame.TextLabel, 0.15, {TextTransparency = 0}):Play()
                        Tween(TabMain.UIElements.TabItem.Frame.SelectionBar, 0.15, {BackgroundTransparency = 0}):Play()
                        table.insert(Dropdown.Value, TabMain.Name)
                    else
                        if not Dropdown.AllowNone and #Dropdown.Value == 1 then
                            return
                        end
                        TabMain.Selected = false
                        Tween(TabMain.UIElements.TabItem.Background, 0.15, {ImageTransparency = 1}):Play()
                        Tween(TabMain.UIElements.TabItem.Highlight, 0.15, {ImageTransparency = 1}):Play()
                        Tween(TabMain.UIElements.TabItem.Frame.TextLabel, 0.15, {TextTransparency = 0.2}):Play()
                        Tween(TabMain.UIElements.TabItem.Frame.SelectionBar, 0.15, {BackgroundTransparency = 1}):Play()
                        for i, v in ipairs(Dropdown.Value) do
                            if v == TabMain.Name then
                                table.remove(Dropdown.Value, i)
                                break
                            end
                        end
                    end
                else
                    -- Single selection
                    for Index, TabOther in next, Dropdown.Tabs do
                        Tween(TabOther.UIElements.TabItem.Background, 0.15, {ImageTransparency = 1}):Play()
                        Tween(TabOther.UIElements.TabItem.Highlight, 0.15, {ImageTransparency = 1}):Play()
                        Tween(TabOther.UIElements.TabItem.Frame.TextLabel, 0.15, {TextTransparency = 0.2}):Play()
                        Tween(TabOther.UIElements.TabItem.Frame.SelectionBar, 0.15, {BackgroundTransparency = 1}):Play()
                        TabOther.Selected = false
                    end
                    TabMain.Selected = true
                    Tween(TabMain.UIElements.TabItem.Background, 0.15, {ImageTransparency = 0.92}):Play()
                    Tween(TabMain.UIElements.TabItem.Highlight, 0.15, {ImageTransparency = 0.85}):Play()
                    Tween(TabMain.UIElements.TabItem.Frame.TextLabel, 0.15, {TextTransparency = 0}):Play()
                    Tween(TabMain.UIElements.TabItem.Frame.SelectionBar, 0.15, {BackgroundTransparency = 0}):Play()
                    Dropdown.Value = TabMain.Name
                    
                    -- Close dropdown after selection (single mode)
                    task.wait(0.1)
                    Dropdown:Close()
                end
                
                Dropdown:Display()
                if CanCallback then
                    task.spawn(function()
                        Creator.SafeCallback(Dropdown.Callback, Dropdown.Value)
                    end)
                end
            end
            
            Creator.AddSignal(TabMain.UIElements.TabItem.MouseButton1Click, HandleClick)
            
            -- Hover effects
            Creator.AddSignal(TabMain.UIElements.TabItem.MouseEnter, function()
                if not TabMain.Selected then
                    Tween(TabMain.UIElements.TabItem.Background, 0.1, {ImageTransparency = 0.96}):Play()
                    Tween(TabMain.UIElements.TabItem.Highlight, 0.1, {ImageTransparency = 0.9}):Play()
                end
            end)
            
            Creator.AddSignal(TabMain.UIElements.TabItem.MouseLeave, function()
                if not TabMain.Selected then
                    Tween(TabMain.UIElements.TabItem.Background, 0.1, {ImageTransparency = 1}):Play()
                    Tween(TabMain.UIElements.TabItem.Highlight, 0.1, {ImageTransparency = 1}):Play()
                end
            end)
        end
        
        -- Update sizes
        task.wait()
        RecalculateCanvasSize()
        RecalculateListSize()
        
        -- Auto-adjust width based on content
        local maxWidth = Dropdown.MenuWidth
        for _, tabmain in next, Dropdown.Tabs do
            if tabmain.UIElements.TabItem.Frame.TextLabel then
                local width = tabmain.UIElements.TabItem.Frame.TextLabel.TextBounds.X
                maxWidth = math.max(maxWidth, width + Element.TabPadding * 2 + 20)
            end
        end
        
        Dropdown.UIElements.MenuCanvas.Size = UDim2.new(
            0, math.min(maxWidth, 350), 
            Dropdown.UIElements.MenuCanvas.Size.Y.Scale, 
            Dropdown.UIElements.MenuCanvas.Size.Y.Offset
        )
    end
    
    -- Initialize display and items
    Dropdown:RefreshItems()
    Dropdown:Display()
    
    -- Selection function
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
        Dropdown:RefreshItems()
        Dropdown:Display()
    end
    
    -- Open dropdown
    function Dropdown:Open()
        if not CanCallback then return end
        
        Dropdown.UIElements.SearchFrame.Visible = true
        Dropdown.UIElements.MenuCanvas.Visible = true
        Dropdown.UIElements.MenuCanvas.Active = true
        
        -- Animate search frame
        Dropdown.UIElements.SearchFrame.Size = UDim2.new(1, 0, 0, 0)
        Tween(Dropdown.UIElements.SearchFrame, 0.2, {
            Size = UDim2.new(1, 0, 0, 36)
        }, Enum.EasingStyle.Quart, Enum.EasingDirection.Out):Play()
        
        -- Animate menu
        Dropdown.UIElements.Menu.Size = UDim2.new(1, 0, 0, 0)
        Tween(Dropdown.UIElements.Menu, 0.25, {
            Size = UDim2.new(1, 0, 1, 0)
        }, Enum.EasingStyle.Quart, Enum.EasingDirection.Out):Play()
        
        -- Rotate arrow
        Tween(DropdownIcon, 0.2, {Rotation = 180}):Play()
        
        -- Focus search input
        task.wait(0.2)
        Dropdown.UIElements.SearchInput:CaptureFocus()
        Dropdown.Opened = true
    end
    
    -- Close dropdown
    function Dropdown:Close()
        Dropdown.Opened = false
        
        -- Animate menu close
        Tween(Dropdown.UIElements.Menu, 0.2, {
            Size = UDim2.new(1, 0, 0, 0)
        }, Enum.EasingStyle.Quart, Enum.EasingDirection.Out):Play()
        
        -- Animate search frame close
        Tween(Dropdown.UIElements.SearchFrame, 0.15, {
            Size = UDim2.new(1, 0, 0, 0)
        }, Enum.EasingStyle.Quart, Enum.EasingDirection.Out):Play()
        
        -- Rotate arrow back
        Tween(DropdownIcon, 0.2, {Rotation = 0}):Play()
        
        -- Clear search and reset filter
        Dropdown.UIElements.SearchInput.Text = ""
        Dropdown.SearchText = ""
        FilterValues("")
        
        -- Hide after animation
        task.spawn(function()
            task.wait(0.2)
            Dropdown.UIElements.SearchFrame.Visible = false
            Dropdown.UIElements.MenuCanvas.Visible = false
            Dropdown.UIElements.MenuCanvas.Active = false
        end)
    end
    
    -- Event handlers
    Creator.AddSignal(Dropdown.UIElements.Display.MouseButton1Click, function()
        if Dropdown.Opened then
            Dropdown:Close()
        else
            Dropdown:Open()
        end
    end)
    
    -- Search input handler
    Creator.AddSignal(Dropdown.UIElements.SearchInput:GetPropertyChangedSignal("Text"), function()
        local newText = Dropdown.UIElements.SearchInput.Text
        if newText ~= Dropdown.SearchText then
            Dropdown.SearchText = newText
            FilterValues(newText)
        end
    end)
    
    -- Close when clicking outside
    Creator.AddSignal(UserInputService.InputBegan, function(Input)
        if (Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch) then
            if Config.Window.CanDropdown and Dropdown.Opened then
                local searchPos, searchSize = Dropdown.UIElements.SearchFrame.AbsolutePosition, Dropdown.UIElements.SearchFrame.AbsoluteSize
                local menuPos, menuSize = Dropdown.UIElements.MenuCanvas.AbsolutePosition, Dropdown.UIElements.MenuCanvas.AbsoluteSize
                
                local mouseX, mouseY = Mouse.X, Mouse.Y
                local inSearch = mouseX >= searchPos.X and mouseX <= searchPos.X + searchSize.X and 
                               mouseY >= searchPos.Y and mouseY <= searchPos.Y + searchSize.Y
                local inMenu = mouseX >= menuPos.X and mouseX <= menuPos.X + menuSize.X and 
                             mouseY >= menuPos.Y and mouseY <= menuPos.Y + menuSize.Y
                
                if not inSearch and not inMenu then
                    Dropdown:Close()
                end
            end
        end
    end)
    
    return Dropdown.__type, Dropdown
end

return Element