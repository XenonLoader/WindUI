local Creator = require("../modules/Creator")
local New = Creator.New

local Element = {}

local CreateButton = require("../components/ui/Button").New

function Element:New(ElementConfig)
    ElementConfig.Hover = false
    ElementConfig.TextOffset = 0
    ElementConfig.IsButtons = ElementConfig.Buttons and #ElementConfig.Buttons > 0 and true or false

    local ParagraphModule = {
        __type = "Paragraph",
        Title = ElementConfig.Title or "Paragraph",
        Desc = ElementConfig.Desc or nil,
        Locked = ElementConfig.Locked or false,
        _titleLabel = nil,
        _descLabel = nil,
    }

    local Paragraph = require("../components/window/Element")(ElementConfig)

    ParagraphModule.ParagraphFrame = Paragraph

    ParagraphModule._titleLabel = Paragraph.UIElements.Title
    ParagraphModule._descLabel = Paragraph.UIElements.Desc

    function ParagraphModule:SetTitle(newTitle)
        if self._titleLabel and newTitle then
            self.Title = newTitle
            self._titleLabel.Text = newTitle
        end
    end

    function ParagraphModule:SetDesc(newDesc)
        if self._descLabel and newDesc then
            self.Desc = newDesc
            self._descLabel.Text = newDesc
        end
    end

    function ParagraphModule:UpdateText(newTitle, newDesc)
        if newTitle then
            self:SetTitle(newTitle)
        end
        if newDesc then
            self:SetDesc(newDesc)
        end
    end

    if ElementConfig.Buttons and #ElementConfig.Buttons > 0 then
        local ButtonsContainer = New("Frame", {
            Size = UDim2.new(1,0,0,38),
            BackgroundTransparency = 1,
            AutomaticSize = "Y",
            Parent = Paragraph.UIElements.Container
        }, {
            New("UIListLayout", {
                Padding = UDim.new(0,10),
                FillDirection = "Vertical",
            })
        })

        for _,Button in next, ElementConfig.Buttons do
            local ButtonFrame = CreateButton(Button.Title, Button.Icon, Button.Callback, "White", ButtonsContainer)
            ButtonFrame.Size = UDim2.new(1,0,0,38)
        end
    end

    return ParagraphModule.__type, ParagraphModule

end

return Element
