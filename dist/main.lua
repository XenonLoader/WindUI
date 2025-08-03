local a a={cache={}, load=function(b)if not a.cache[b]then a.cache[b]={c=a[b]()}end return a.cache[b].c end}do function a.a()





local b=game:GetService"RunService"local c=
b.Heartbeat
local d=game:GetService"UserInputService"
local e=game:GetService"TweenService"

local f=loadstring(game:HttpGetAsync"https://raw.githubusercontent.com/Footagesus/Icons/main/Main.lua")()
f.SetIconsType"lucide"

local g={
Font="rbxassetid://12187365364",
CanDraggable=true,
Theme=nil,
Themes=nil,
WindUI=nil,
Signals={},
Objects={},
FontObjects={},
Request=http_request or(syn and syn.request)or request,
DefaultProperties={
ScreenGui={
ResetOnSpawn=false,
ZIndexBehavior="Sibling",
},
CanvasGroup={
BorderSizePixel=0,
BackgroundColor3=Color3.new(1,1,1),
},
Frame={
BorderSizePixel=0,
BackgroundColor3=Color3.new(1,1,1),
},
TextLabel={
BackgroundColor3=Color3.new(1,1,1),
BorderSizePixel=0,
Text="",
RichText=true,
TextColor3=Color3.new(1,1,1),
TextSize=14,
},TextButton={
BackgroundColor3=Color3.new(1,1,1),
BorderSizePixel=0,
Text="",
AutoButtonColor=false,
TextColor3=Color3.new(1,1,1),
TextSize=14,
},
TextBox={
BackgroundColor3=Color3.new(1,1,1),
BorderColor3=Color3.new(0,0,0),
ClearTextOnFocus=false,
Text="",
TextColor3=Color3.new(0,0,0),
TextSize=14,
},
ImageLabel={
BackgroundTransparency=1,
BackgroundColor3=Color3.new(1,1,1),
BorderSizePixel=0,
},
ImageButton={
BackgroundColor3=Color3.new(1,1,1),
BorderSizePixel=0,
AutoButtonColor=false,
},
UIListLayout={
SortOrder="LayoutOrder",
},
ScrollingFrame={
ScrollBarImageTransparency=1,
BorderSizePixel=0,
}
},
Colors={
Red="#e53935",
Orange="#f57c00",
Green="#43a047",
Blue="#039be5",
White="#ffffff",
Grey="#484848",
}
}

function g.Init(h)
g.WindUI=h
end


function g.AddSignal(h,i)
table.insert(g.Signals,h:Connect(i))
end

function g.DisconnectAll()
for h,i in next,g.Signals do
local j=table.remove(g.Signals,h)
j:Disconnect()
end
end


function g.SafeCallback(h,...)
if not h then
return
end

local i,j=pcall(h,...)
if not i then local
k, l=j:find":%d+: "


warn("[ WindUI: DEBUG Mode ] "..j)

return g.WindUI:Notify{
Title="DEBUG Mode: Error",
Content=not l and j or j:sub(l+1),
Duration=8,
}
end
end

function g.SetTheme(h)
g.Theme=h
g.UpdateTheme(nil,true)
end

function g.AddFontObject(h)
table.insert(g.FontObjects,h)
g.UpdateFont(g.Font)
end

function g.UpdateFont(h)
g.Font=h
for i,j in next,g.FontObjects do
j.FontFace=Font.new(h,j.FontFace.Weight,j.FontFace.Style)
end
end

function g.GetThemeProperty(h,i)
return i[h]or g.Themes.Dark[h]
end

function g.AddThemeObject(h,i)
g.Objects[h]={Object=h,Properties=i}
g.UpdateTheme(h,false)
return h
end

function g.UpdateTheme(h,i)
local function ApplyTheme(j)
for k,l in pairs(j.Properties or{})do
local m=g.GetThemeProperty(l,g.Theme)
if m then
if not i then
j.Object[k]=Color3.fromHex(m)
else
g.Tween(j.Object,0.08,{[k]=Color3.fromHex(m)}):Play()
end
end
end
end

if h then
local j=g.Objects[h]
if j then
ApplyTheme(j)
end
else
for j,k in pairs(g.Objects)do
ApplyTheme(k)
end
end
end

function g.Icon(h)
return f.Icon(h)
end

function g.New(h,i,j)
local k=Instance.new(h)

for l,m in next,g.DefaultProperties[h]or{}do
k[l]=m
end

for l,m in next,i or{}do
if l~="ThemeTag"then
k[l]=m
end
end

for l,m in next,j or{}do
m.Parent=k
end

if i and i.ThemeTag then
g.AddThemeObject(k,i.ThemeTag)
end
if i and i.FontFace then
g.AddFontObject(k)
end
return k
end

function g.Tween(h,i,j,...)
return e:Create(h,TweenInfo.new(i,...),j)
end

function g.NewRoundFrame(h,i,j,k,l)






local m=g.New(l and"ImageButton"or"ImageLabel",{
Image=i=="Squircle"and"rbxassetid://80999662900595"
or i=="SquircleOutline"and"rbxassetid://117788349049947"
or i=="SquircleOutline2"and"rbxassetid://117817408534198"
or i=="Shadow-sm"and"rbxassetid://84825982946844"
or i=="Squircle-TL-TR"and"rbxassetid://73569156276236",
ScaleType="Slice",
SliceCenter=i~="Shadow-sm"and Rect.new(256
,256
,256
,256

)or Rect.new(512,512,512,512),
SliceScale=1,
BackgroundTransparency=1,
ThemeTag=j.ThemeTag and j.ThemeTag
},k)

for n,o in pairs(j or{})do
if n~="ThemeTag"then
m[n]=o
end
end

local function UpdateSliceScale(n)
local o=i~="Shadow-sm"and(n/(256))or(n/512)
m.SliceScale=o
end

UpdateSliceScale(h)

return m
end

local h=g.New local i=
g.Tween

function g.SetDraggable(j)
g.CanDraggable=j
end

function g.Drag(j,k,l)
local m
local n,o,p,q
local r={
CanDraggable=true
}

if not k or type(k)~="table"then
k={j}
end

local function update(s)
local t=s.Position-p
g.Tween(j,0.02,{Position=UDim2.new(
q.X.Scale,q.X.Offset+t.X,
q.Y.Scale,q.Y.Offset+t.Y
)}):Play()
end

for s,t in pairs(k)do
t.InputBegan:Connect(function(u)
if(u.UserInputType==Enum.UserInputType.MouseButton1 or u.UserInputType==Enum.UserInputType.Touch)and r.CanDraggable then
if m==nil then
m=t
n=true
p=u.Position
q=j.Position

if l and type(l)=="function"then
l(true,m)
end

u.Changed:Connect(function()
if u.UserInputState==Enum.UserInputState.End then
n=false
m=nil

if l and type(l)=="function"then
l(false,m)
end
end
end)
end
end
end)

t.InputChanged:Connect(function(u)
if m==t and n then
if u.UserInputType==Enum.UserInputType.MouseMovement or u.UserInputType==Enum.UserInputType.Touch then
o=u
end
end
end)
end

d.InputChanged:Connect(function(s)
if s==o and n and m~=nil then
if r.CanDraggable then
update(s)
end
end
end)

function r.Set(s,t)
r.CanDraggable=t
end

return r
end

function g.Image(j,k,l,m,n,o,p)
local function SanitizeFilename(q)
q=q:gsub("[%s/\\:*?\"<>|]+","-")
q=q:gsub("[^%w%-_%.]","")
return q
end

m=m or"Temp"
k=SanitizeFilename(k)

local q=h("Frame",{
Size=UDim2.new(0,0,0,0),

BackgroundTransparency=1,
},{
h("ImageLabel",{
Size=UDim2.new(1,0,1,0),
BackgroundTransparency=1,
ScaleType="Crop",
ThemeTag=(g.Icon(j)or p)and{
ImageColor3=o and"Icon"
}or nil,
},{
h("UICorner",{
CornerRadius=UDim.new(0,l)
})
})
})
if g.Icon(j)then
q.ImageLabel.Image=g.Icon(j)[1]
q.ImageLabel.ImageRectOffset=g.Icon(j)[2].ImageRectPosition
q.ImageLabel.ImageRectSize=g.Icon(j)[2].ImageRectSize
end
if string.find(j,"http")then
local r="WindUI/"..m.."/Assets/."..n.."-"..k..".png"
local s,t=pcall(function()
task.spawn(function()
if not isfile(r)then
local s=g.Request{
Url=j,
Method="GET",
}.Body

writefile(r,s)
end
q.ImageLabel.Image=getcustomasset(r)
end)
end)
if not s then
warn("[ WindUI.Creator ]  '"..identifyexecutor().."' doesnt support the URL Images. Error: "..t)

q:Destroy()
end
elseif string.find(j,"rbxassetid")then
q.ImageLabel.Image=j
end

return q
end

return g end function a.b()
return{
Dark={
Name="Dark",
Accent="#18181b",
Dialog="#18181b",
Outline="#FFFFFF",
Text="#FFFFFF",
Placeholder="#999999",
Background="#101010",
Button="#52525b",
Icon="#a1a1aa",
},
Light={
Name="Light",
Accent="#FFFFFF",
Dialog="#f4f4f5",
Outline="#09090b",
Text="#000000",
Placeholder="#777777",
Background="#e4e4e7",
Button="#18181b",
Icon="#52525b",
},
Rose={
Name="Rose",
Accent="#f43f5e",
Outline="#ffe4e6",
Text="#ffe4e6",
Placeholder="#fda4af",
Background="#881337",
Button="#e11d48",
Icon="#fecdd3",
},
Plant={
Name="Plant",
Accent="#22c55e",
Outline="#dcfce7",
Text="#dcfce7",
Placeholder="#bbf7d0",
Background="#14532d",
Button="#22c55e",
Icon="#86efac",
},
Red={
Name="Red",
Accent="#ef4444",
Outline="#fee2e2",
Text="#ffe4e6",
Placeholder="#fca5a5",
Background="#7f1d1d",
Button="#ef4444",
Icon="#fecaca",
},
Indigo={
Name="Indigo",
Accent="#6366f1",
Outline="#e0e7ff",
Text="#e0e7ff",
Placeholder="#a5b4fc",
Background="#312e81",
Button="#6366f1",
Icon="#c7d2fe",
},
Sky={
Name="Sky",
Accent="#0ea5e9",
Outline="#e0f2fe",
Text="#e0f2fe",
Placeholder="#7dd3fc",
Background="#075985",
Button="#0ea5e9",
Icon="#bae6fd",
},
Violet={
Name="Violet",
Accent="#8b5cf6",
Outline="#ede9fe",
Text="#ede9fe",
Placeholder="#c4b5fd",
Background="#4c1d95",
Button="#8b5cf6",
Icon="#ddd6fe",
},
Amber={
Name="Amber",
Accent="#f59e0b",
Outline="#fef3c7",
Text="#fef3c7",
Placeholder="#fcd34d",
Background="#78350f",
Button="#f59e0b",
Icon="#fde68a",
},
Emerald={
Name="Emerald",
Accent="#10b981",
Outline="#d1fae5",
Text="#d1fae5",
Placeholder="#6ee7b7",
Background="#064e3b",
Button="#10b981",
Icon="#a7f3d0",
},
}end function a.c()
local b={}

local d=a.load'a'
local e=d.New
local f=d.Tween


function b.New(g,h,i,j,k,l,m)
j=j or"Primary"
local n=not m and 10 or 99
local o
if h and h~=""then
o=e("ImageLabel",{
Image=d.Icon(h)[1],
ImageRectSize=d.Icon(h)[2].ImageRectSize,
ImageRectOffset=d.Icon(h)[2].ImageRectPosition,
Size=UDim2.new(0,21,0,21),
BackgroundTransparency=1,
ThemeTag={
ImageColor3="Icon",
}
})
end

local p=e("TextButton",{
Size=UDim2.new(0,0,1,0),
AutomaticSize="X",
Parent=k,
BackgroundTransparency=1
},{
d.NewRoundFrame(n,"Squircle",{
ThemeTag={
ImageColor3=j~="White"and"Button"or nil,
},
ImageColor3=j=="White"and Color3.new(1,1,1)or nil,
Size=UDim2.new(1,0,1,0),
Name="Squircle",
ImageTransparency=j=="Primary"and 0 or j=="White"and 0 or 1
}),

d.NewRoundFrame(n,"Squircle",{



ImageColor3=Color3.new(1,1,1),
Size=UDim2.new(1,0,1,0),
Name="Special",
ImageTransparency=j=="Secondary"and 0.95 or 1
}),

d.NewRoundFrame(n,"Shadow-sm",{



ImageColor3=Color3.new(0,0,0),
Size=UDim2.new(1,3,1,3),
AnchorPoint=Vector2.new(0.5,0.5),
Position=UDim2.new(0.5,0,0.5,0),
Name="Shadow",
ImageTransparency=j=="Secondary"and 0 or 1,
Visible=not m
}),

d.NewRoundFrame(n,not m and"SquircleOutline"or"SquircleOutline2",{
ThemeTag={
ImageColor3=j~="White"and"Outline"or nil,
},
Size=UDim2.new(1,0,1,0),
ImageColor3=j=="White"and Color3.new(0,0,0)or nil,
ImageTransparency=j=="Primary"and.95 or.85,
Name="SquircleOutline",
}),

d.NewRoundFrame(n,"Squircle",{
Size=UDim2.new(1,0,1,0),
Name="Frame",
ThemeTag={
ImageColor3=j~="White"and"Text"or nil
},
ImageColor3=j=="White"and Color3.new(0,0,0)or nil,
ImageTransparency=1
},{
e("UIPadding",{
PaddingLeft=UDim.new(0,16),
PaddingRight=UDim.new(0,16),
}),
e("UIListLayout",{
FillDirection="Horizontal",
Padding=UDim.new(0,8),
VerticalAlignment="Center",
HorizontalAlignment="Center",
}),
o,
e("TextLabel",{
BackgroundTransparency=1,
FontFace=Font.new(d.Font,Enum.FontWeight.SemiBold),
Text=g or"Button",
ThemeTag={
TextColor3=(j~="Primary"and j~="White")and"Text",
},
TextColor3=j=="Primary"and Color3.new(1,1,1)or j=="White"and Color3.new(0,0,0)or nil,
AutomaticSize="XY",
TextSize=18,
})
})
})

d.AddSignal(p.MouseEnter,function()
f(p.Frame,.047,{ImageTransparency=.95}):Play()
end)
d.AddSignal(p.MouseLeave,function()
f(p.Frame,.047,{ImageTransparency=1}):Play()
end)
d.AddSignal(p.MouseButton1Up,function()
if l then
l:Close()()
end
if i then
d.SafeCallback(i)
end
end)

return p
end


return b end function a.d()
local b={}

local d=a.load'a'
local e=d.New local f=
d.Tween


function b.New(g,h,i,j,k)
j=j or"Input"
local l=10
local m
if h and h~=""then
m=e("ImageLabel",{
Image=d.Icon(h)[1],
ImageRectSize=d.Icon(h)[2].ImageRectSize,
ImageRectOffset=d.Icon(h)[2].ImageRectPosition,
Size=UDim2.new(0,21,0,21),
BackgroundTransparency=1,
ThemeTag={
ImageColor3="Icon",
}
})
end

local n=j~="Input"

local o=e("TextBox",{
BackgroundTransparency=1,
TextSize=16,
FontFace=Font.new(d.Font,Enum.FontWeight.Regular),
Size=UDim2.new(1,m and-29 or 0,1,0),
PlaceholderText=g,
ClearTextOnFocus=false,
ClipsDescendants=true,
TextWrapped=n,
MultiLine=n,
TextXAlignment="Left",
TextYAlignment=j=="Input"and"Center"or"Top",

ThemeTag={
PlaceholderColor3="PlaceholderText",
TextColor3="Text",
},
})

local p=e("Frame",{
Size=UDim2.new(1,0,0,42),
Parent=i,
BackgroundTransparency=1
},{
e("Frame",{
Size=UDim2.new(1,0,1,0),
BackgroundTransparency=1,
},{
d.NewRoundFrame(l,"Squircle",{
ThemeTag={
ImageColor3="Accent",
},
Size=UDim2.new(1,0,1,0),
ImageTransparency=.85,
}),
d.NewRoundFrame(l,"SquircleOutline",{
ThemeTag={
ImageColor3="Outline",
},
Size=UDim2.new(1,0,1,0),
ImageTransparency=.9,
}),
d.NewRoundFrame(l,"Squircle",{
Size=UDim2.new(1,0,1,0),
Name="Frame",
ImageColor3=Color3.new(1,1,1),
ImageTransparency=.95
},{
e("UIPadding",{
PaddingTop=UDim.new(0,j=="Input"and 0 or 12),
PaddingLeft=UDim.new(0,12),
PaddingRight=UDim.new(0,12),
PaddingBottom=UDim.new(0,j=="Input"and 0 or 12),
}),
e("UIListLayout",{
FillDirection="Horizontal",
Padding=UDim.new(0,8),
VerticalAlignment=j=="Input"and"Center"or"Top",
HorizontalAlignment="Left",
}),
m,
o,
})
})
})










d.AddSignal(o.FocusLost,function()
if k then
d.SafeCallback(k,o.Text)
end
end)

return p
end


return b end function a.e()
local b=a.load'a'
local d=b.New
local e=b.Tween

local f={
Holder=nil,
Window=nil,
Parent=nil,
}

function f.Init(g,h)
f.Window=g
f.Parent=h
return f
end

function f.Create(g)
local h={
UICorner=32,
UIPadding=12,
UIElements={}
}

if g then h.UIPadding=0 end
if g then h.UICorner=26 end

if not g then
h.UIElements.FullScreen=d("Frame",{
ZIndex=999,
BackgroundTransparency=1,
BackgroundColor3=Color3.fromHex"#000000",
Size=UDim2.new(1,0,1,0),
Active=false,
Visible=false,
Parent=f.Parent or(f.Window and f.Window.UIElements and f.Window.UIElements.Main and f.Window.UIElements.Main.Main)
},{
d("UICorner",{
CornerRadius=UDim.new(0,f.Window.UICorner)
})
})
end

h.UIElements.Main=d("Frame",{
Size=UDim2.new(0,280,0,0),
ThemeTag={
BackgroundColor3="Dialog",
},
AutomaticSize="Y",
BackgroundTransparency=1,
Visible=false,
ZIndex=99999,
},{
d("UIPadding",{
PaddingTop=UDim.new(0,h.UIPadding),
PaddingLeft=UDim.new(0,h.UIPadding),
PaddingRight=UDim.new(0,h.UIPadding),
PaddingBottom=UDim.new(0,h.UIPadding),
})
})

h.UIElements.MainContainer=b.NewRoundFrame(h.UICorner,"Squircle",{
Visible=false,

ImageTransparency=g and 0.15 or 0,
Parent=g and f.Parent or h.UIElements.FullScreen,
Position=UDim2.new(0.5,0,0.5,0),
AnchorPoint=Vector2.new(0.5,0.5),
AutomaticSize="XY",
ThemeTag={
ImageColor3="Dialog"
},
ZIndex=9999,
},{





h.UIElements.Main,



b.NewRoundFrame(h.UICorner,"SquircleOutline2",{
Size=UDim2.new(1,0,1,0),
ImageTransparency=.85,
ThemeTag={
ImageColor3="Outline",
},
},{
d("UIGradient",{
Rotation=45,
Transparency=NumberSequence.new{
NumberSequenceKeypoint.new(0,0.55),
NumberSequenceKeypoint.new(0.5,0.8),
NumberSequenceKeypoint.new(1,0.6)
}
})
})
})

function h.Open(i)
if not g then
h.UIElements.FullScreen.Visible=true
h.UIElements.FullScreen.Active=true
end

task.spawn(function()
h.UIElements.MainContainer.Visible=true

if not g then
e(h.UIElements.FullScreen,0.1,{BackgroundTransparency=.3}):Play()
end
e(h.UIElements.MainContainer,0.1,{ImageTransparency=0}):Play()


task.spawn(function()
task.wait(0.05)
h.UIElements.Main.Visible=true
end)
end)
end
function h.Close(i)
if not g then
e(h.UIElements.FullScreen,0.1,{BackgroundTransparency=1}):Play()
h.UIElements.FullScreen.Active=false
task.spawn(function()
task.wait(.1)
h.UIElements.FullScreen.Visible=false
end)
end
h.UIElements.Main.Visible=false

e(h.UIElements.MainContainer,0.1,{ImageTransparency=1}):Play()



task.spawn(function()
task.wait(.1)
if not g then
h.UIElements.FullScreen:Destroy()
else
h.UIElements.MainContainer:Destroy()
end
end)

return function()end
end


return h
end

return f end function a.f()
local b={}


local d=a.load'a'
local e=d.New local f=
d.Tween

local g=a.load'c'.New
local h=a.load'd'.New

function b.new(i,j,k)
local l=a.load'e'.Init(nil,i.WindUI.ScreenGui.KeySystem)
local m=l.Create(true)


local n

local o=200

local p=430
if i.KeySystem.Thumbnail and i.KeySystem.Thumbnail.Image then
p=430+(o/2)
end

m.UIElements.Main.AutomaticSize="Y"
m.UIElements.Main.Size=UDim2.new(0,p,0,0)

local q

if i.Icon then

q=d.Image(
i.Icon,
i.Title..":"..i.Icon,
0,
i.WindUI.Window,
"KeySystem",
i.IconThemed
)
q.Size=UDim2.new(0,24,0,24)
q.LayoutOrder=-1
end

local r=e("TextLabel",{
AutomaticSize="XY",
BackgroundTransparency=1,
Text=i.Title,
FontFace=Font.new(d.Font,Enum.FontWeight.SemiBold),
ThemeTag={
TextColor3="Text",
},
TextSize=20
})
local s=e("TextLabel",{
AutomaticSize="XY",
BackgroundTransparency=1,
Text="Key System",
AnchorPoint=Vector2.new(1,0.5),
Position=UDim2.new(1,0,0.5,0),
TextTransparency=1,
FontFace=Font.new(d.Font,Enum.FontWeight.Medium),
ThemeTag={
TextColor3="Text",
},
TextSize=16
})

local t=e("Frame",{
BackgroundTransparency=1,
AutomaticSize="XY",
},{
e("UIListLayout",{
Padding=UDim.new(0,14),
FillDirection="Horizontal",
VerticalAlignment="Center"
}),
q,r
})

local u=e("Frame",{
AutomaticSize="Y",
Size=UDim2.new(1,0,0,0),
BackgroundTransparency=1,
},{





t,s,
})

local v=h("Enter Key","key",nil,"Input",function(v)
n=v
end)

local w
if i.KeySystem.Note and i.KeySystem.Note~=""then
w=e("TextLabel",{
Size=UDim2.new(1,0,0,0),
AutomaticSize="Y",
FontFace=Font.new(d.Font,Enum.FontWeight.Medium),
TextXAlignment="Left",
Text=i.KeySystem.Note,
TextSize=18,
TextTransparency=.4,
ThemeTag={
TextColor3="Text",
},
BackgroundTransparency=1,
RichText=true
})
end

local x=e("Frame",{
Size=UDim2.new(1,0,0,42),
BackgroundTransparency=1,
},{
e("Frame",{
BackgroundTransparency=1,
AutomaticSize="X",
Size=UDim2.new(0,0,1,0),
},{
e("UIListLayout",{
Padding=UDim.new(0,9),
FillDirection="Horizontal",
})
})
})


local y
if i.KeySystem.Thumbnail and i.KeySystem.Thumbnail.Image then
local z
if i.KeySystem.Thumbnail.Title then
z=e("TextLabel",{
Text=i.KeySystem.Thumbnail.Title,
ThemeTag={
TextColor3="Text",
},
TextSize=18,
FontFace=Font.new(d.Font,Enum.FontWeight.Medium),
BackgroundTransparency=1,
AutomaticSize="XY",
AnchorPoint=Vector2.new(0.5,0.5),
Position=UDim2.new(0.5,0,0.5,0),
})
end
y=e("ImageLabel",{
Image=i.KeySystem.Thumbnail.Image,
BackgroundTransparency=1,
Size=UDim2.new(0,o,1,0),
Parent=m.UIElements.Main,
ScaleType="Crop"
},{
z,
e("UICorner",{
CornerRadius=UDim.new(0,0),
})
})
end

e("Frame",{

Size=UDim2.new(1,y and-o or 0,1,0),
Position=UDim2.new(0,y and o or 0,0,0),
BackgroundTransparency=1,
Parent=m.UIElements.Main
},{
e("Frame",{

Size=UDim2.new(1,0,1,0),
BackgroundTransparency=1,
},{
e("UIListLayout",{
Padding=UDim.new(0,18),
FillDirection="Vertical",
}),
u,
w,
v,
x,
e("UIPadding",{
PaddingTop=UDim.new(0,16),
PaddingLeft=UDim.new(0,16),
PaddingRight=UDim.new(0,16),
PaddingBottom=UDim.new(0,16),
})
}),
})





local z=g("Exit","log-out",function()
m:Close()()
end,"Tertiary",x.Frame)

if y then
z.Parent=y
z.Size=UDim2.new(0,0,0,42)
z.Position=UDim2.new(0,16,1,-16)
z.AnchorPoint=Vector2.new(0,1)
end

if i.KeySystem.URL then
g("Get key","key",function()
setclipboard(i.KeySystem.URL)
end,"Secondary",x.Frame)
end

local A=g("Submit","arrow-right",function()
local A=n
local B
if type(i.KeySystem.Key)=="table"then
B=table.find(i.KeySystem.Key,tostring(A))
else
B=tostring(i.KeySystem.Key)==tostring(A)
end

if B then
m:Close()()

if i.KeySystem.SaveKey then
local C=i.Folder or i.Title
writefile(C.."/"..j..".key",tostring(A))
end

task.wait(.4)
k(true)
end
end,"Primary",x)

A.AnchorPoint=Vector2.new(1,0.5)
A.Position=UDim2.new(1,0,0.5,0)










m:Open()
end

return b end function a.g()
local b=a.load'a'
local d=b.New
local e=b.Tween

local f={
Size=UDim2.new(0,300,1,-156),
SizeLower=UDim2.new(0,300,1,-56),
UICorner=16,
UIPadding=14,
ButtonPadding=9,
Holder=nil,
NotificationIndex=0,
Notifications={}
}

function f.Init(g)
local h={
Lower=false
}

function h.SetLower(i)
h.Lower=i
h.Frame.Size=i and f.SizeLower or f.Size
end

h.Frame=d("Frame",{
Position=UDim2.new(1,-29,0,56),
AnchorPoint=Vector2.new(1,0),
Size=f.Size,
Parent=g,
BackgroundTransparency=1,




},{
d("UIListLayout",{
HorizontalAlignment="Center",
SortOrder="LayoutOrder",
VerticalAlignment="Bottom",
Padding=UDim.new(0,8),
}),
d("UIPadding",{
PaddingBottom=UDim.new(0,29)
})
})
return h
end

function f.New(g)
local h={
Title=g.Title or"Notification",
Content=g.Content or nil,
Icon=g.Icon or nil,
IconThemed=g.IconThemed,
Background=g.Background,
BackgroundImageTransparency=g.BackgroundImageTransparency,
Duration=g.Duration or 5,
Buttons=g.Buttons or{},
CanClose=true,
UIElements={},
Closed=false,
}
if h.CanClose==nil then
h.CanClose=true
end
f.NotificationIndex=f.NotificationIndex+1
f.Notifications[f.NotificationIndex]=h

local i=d("UICorner",{
CornerRadius=UDim.new(0,f.UICorner),
})

local j=d("UIStroke",{
ThemeTag={
Color="Text"
},
Transparency=1,
Thickness=.6,
})

local k

if h.Icon then





















k=b.Image(
h.Icon,
h.Title..":"..h.Icon,
0,
g.Window,
"Notification",
h.IconThemed
)
k.Size=UDim2.new(0,26,0,26)
k.Position=UDim2.new(0,f.UIPadding,0,f.UIPadding)

end

local l
if h.CanClose then
l=d("ImageButton",{
Image=b.Icon"x"[1],
ImageRectSize=b.Icon"x"[2].ImageRectSize,
ImageRectOffset=b.Icon"x"[2].ImageRectPosition,
BackgroundTransparency=1,
Size=UDim2.new(0,16,0,16),
Position=UDim2.new(1,-f.UIPadding,0,f.UIPadding),
AnchorPoint=Vector2.new(1,0),
ThemeTag={
ImageColor3="Text"
}
},{
d("TextButton",{
Size=UDim2.new(1,8,1,8),
BackgroundTransparency=1,
AnchorPoint=Vector2.new(0.5,0.5),
Position=UDim2.new(0.5,0,0.5,0),
Text="",
})
})
end

local m=d("Frame",{
Size=UDim2.new(1,0,0,3),
BackgroundTransparency=.9,
ThemeTag={
BackgroundColor3="Text",
},

})

local n=d("Frame",{
Size=UDim2.new(1,
h.Icon and-28-f.UIPadding or 0,
1,0),
Position=UDim2.new(1,0,0,0),
AnchorPoint=Vector2.new(1,0),
BackgroundTransparency=1,
AutomaticSize="Y",
},{
d("UIPadding",{
PaddingTop=UDim.new(0,f.UIPadding),
PaddingLeft=UDim.new(0,f.UIPadding),
PaddingRight=UDim.new(0,f.UIPadding),
PaddingBottom=UDim.new(0,f.UIPadding),
}),
d("TextLabel",{
AutomaticSize="Y",
Size=UDim2.new(1,-30-f.UIPadding,0,0),
TextWrapped=true,
TextXAlignment="Left",
RichText=true,
BackgroundTransparency=1,
TextSize=16,
ThemeTag={
TextColor3="Text"
},
Text=h.Title,
FontFace=Font.new(b.Font,Enum.FontWeight.SemiBold)
}),
d("UIListLayout",{
Padding=UDim.new(0,f.UIPadding/3)
})
})

if h.Content then
d("TextLabel",{
AutomaticSize="Y",
Size=UDim2.new(1,0,0,0),
TextWrapped=true,
TextXAlignment="Left",
RichText=true,
BackgroundTransparency=1,
TextTransparency=.4,
TextSize=15,
ThemeTag={
TextColor3="Text"
},
Text=h.Content,
FontFace=Font.new(b.Font,Enum.FontWeight.Medium),
Parent=n
})
end


local o=d("CanvasGroup",{
Size=UDim2.new(1,0,0,0),
Position=UDim2.new(2,0,1,0),
AnchorPoint=Vector2.new(0,1),
AutomaticSize="Y",
BackgroundTransparency=.25,
ThemeTag={
BackgroundColor3="Accent"
},

},{
d("ImageLabel",{
Name="Background",
Image=h.Background,
BackgroundTransparency=1,
Size=UDim2.new(1,0,1,0),
ScaleType="Crop",
ImageTransparency=h.BackgroundImageTransparency

}),

j,i,
n,
k,l,
m,

})

local p=d("Frame",{
BackgroundTransparency=1,
Size=UDim2.new(1,0,0,0),
Parent=g.Holder
},{
o
})

function h.Close(q)
if not h.Closed then
h.Closed=true
e(p,0.45,{Size=UDim2.new(1,0,0,-8)},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
e(o,0.55,{Position=UDim2.new(2,0,1,0)},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
task.wait(.45)
p:Destroy()
end
end

task.spawn(function()
task.wait()
e(p,0.45,{Size=UDim2.new(
1,
0,
0,
o.AbsoluteSize.Y
)},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
e(o,0.45,{Position=UDim2.new(0,0,1,0)},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
if h.Duration then
e(m,h.Duration,{Size=UDim2.new(0,0,0,3)},Enum.EasingStyle.Linear,Enum.EasingDirection.InOut):Play()
task.wait(h.Duration)
h:Close()
end
end)

if l then
b.AddSignal(l.TextButton.MouseButton1Click,function()
h:Close()
end)
end


return h
end

return f end function a.h()
local b={}

local d=a.load'a'
local e=d.New local f=
d.Tween


function b.new(g)
local h={
Title=g.Title or"Dialog",
Content=g.Content,
Icon=g.Icon,
IconThemed=g.IconThemed,
Thumbnail=g.Thumbnail,
Buttons=g.Buttons
}

local i=a.load'e'.Init(nil,g.WindUI.ScreenGui.Popups)
local j=i.Create(true)

local k=200

local l=430
if h.Thumbnail and h.Thumbnail.Image then
l=430+(k/2)
end

j.UIElements.Main.AutomaticSize="Y"
j.UIElements.Main.Size=UDim2.new(0,l,0,0)



local m

if h.Icon then
m=d.Image(
h.Icon,
h.Title..":"..h.Icon,
0,
g.WindUI.Window,
"Popup",
g.IconThemed
)
m.Size=UDim2.new(0,22,0,22)
m.LayoutOrder=-1
end


local n=e("TextLabel",{
AutomaticSize="XY",
BackgroundTransparency=1,
Text=h.Title,
TextXAlignment="Left",
FontFace=Font.new(d.Font,Enum.FontWeight.SemiBold),
ThemeTag={
TextColor3="Text",
},
TextSize=20
})

local o=e("Frame",{
BackgroundTransparency=1,
AutomaticSize="XY",
},{
e("UIListLayout",{
Padding=UDim.new(0,14),
FillDirection="Horizontal",
VerticalAlignment="Center"
}),
m,n
})

local p=e("Frame",{
AutomaticSize="Y",
Size=UDim2.new(1,0,0,0),
BackgroundTransparency=1,
},{





o,
})

local q
if h.Content and h.Content~=""then
q=e("TextLabel",{
Size=UDim2.new(1,0,0,0),
AutomaticSize="Y",
FontFace=Font.new(d.Font,Enum.FontWeight.Medium),
TextXAlignment="Left",
Text=h.Content,
TextSize=18,
TextTransparency=.2,
ThemeTag={
TextColor3="Text",
},
BackgroundTransparency=1,
RichText=true
})
end

local r=e("Frame",{
Size=UDim2.new(1,0,0,42),
BackgroundTransparency=1,
},{
e("UIListLayout",{
Padding=UDim.new(0,9),
FillDirection="Horizontal",
HorizontalAlignment="Right"
})
})

local s
if h.Thumbnail and h.Thumbnail.Image then
local t
if h.Thumbnail.Title then
t=e("TextLabel",{
Text=h.Thumbnail.Title,
ThemeTag={
TextColor3="Text",
},
TextSize=18,
FontFace=Font.new(d.Font,Enum.FontWeight.Medium),
BackgroundTransparency=1,
AutomaticSize="XY",
AnchorPoint=Vector2.new(0.5,0.5),
Position=UDim2.new(0.5,0,0.5,0),
})
end
s=e("ImageLabel",{
Image=h.Thumbnail.Image,
BackgroundTransparency=1,
Size=UDim2.new(0,k,1,0),
Parent=j.UIElements.Main,
ScaleType="Crop"
},{
t,
e("UICorner",{
CornerRadius=UDim.new(0,0),
})
})
end

e("Frame",{

Size=UDim2.new(1,s and-k or 0,1,0),
Position=UDim2.new(0,s and k or 0,0,0),
BackgroundTransparency=1,
Parent=j.UIElements.Main
},{
e("Frame",{

Size=UDim2.new(1,0,1,0),
BackgroundTransparency=1,
},{
e("UIListLayout",{
Padding=UDim.new(0,18),
FillDirection="Vertical",
}),
p,
q,
r,
e("UIPadding",{
PaddingTop=UDim.new(0,16),
PaddingLeft=UDim.new(0,16),
PaddingRight=UDim.new(0,16),
PaddingBottom=UDim.new(0,16),
})
}),
})

local t=a.load'c'.New

for u,v in next,h.Buttons do
t(v.Title,v.Icon,v.Callback,v.Variant,r,j)
end

j:Open()


return h
end

return b end function a.i()
local b={}

local d=a.load'a'
local e=d.New local f=
d.Tween


function b.New(g,h,i)
local j=10
local k
if h and h~=""then
k=e("ImageLabel",{
Image=d.Icon(h)[1],
ImageRectSize=d.Icon(h)[2].ImageRectSize,
ImageRectOffset=d.Icon(h)[2].ImageRectPosition,
Size=UDim2.new(0,21,0,21),
BackgroundTransparency=1,
ThemeTag={
ImageColor3="Icon",
}
})
end

local l=e("TextLabel",{
BackgroundTransparency=1,
TextSize=16,
FontFace=Font.new(d.Font,Enum.FontWeight.Regular),
Size=UDim2.new(1,k and-29 or 0,1,0),
TextXAlignment="Left",
ThemeTag={
TextColor3="Text",
},
Text=g,
})

local m=e("TextButton",{
Size=UDim2.new(1,0,0,42),
Parent=i,
BackgroundTransparency=1,
Text="",
},{
e("Frame",{
Size=UDim2.new(1,0,1,0),
BackgroundTransparency=1,
},{
d.NewRoundFrame(j,"Squircle",{
ThemeTag={
ImageColor3="Accent",
},
Size=UDim2.new(1,0,1,0),
ImageTransparency=.85,
}),
d.NewRoundFrame(j,"SquircleOutline",{
ThemeTag={
ImageColor3="Outline",
},
Size=UDim2.new(1,0,1,0),
ImageTransparency=.9,
}),
d.NewRoundFrame(j,"Squircle",{
Size=UDim2.new(1,0,1,0),
Name="Frame",
ImageColor3=Color3.new(1,1,1),
ImageTransparency=.95
},{
e("UIPadding",{
PaddingLeft=UDim.new(0,12),
PaddingRight=UDim.new(0,12),
}),
e("UIListLayout",{
FillDirection="Horizontal",
Padding=UDim.new(0,8),
VerticalAlignment="Center",
HorizontalAlignment="Left",
}),
k,
l,
})
})
})

return m
end


return b end function a.j()
local b={}

local d=game:GetService"UserInputService"

local e=a.load'a'
local f=e.New local g=
e.Tween


function b.New(h,i,j,k)
local l=f("Frame",{
Size=UDim2.new(0,k,1,0),
BackgroundTransparency=1,
Position=UDim2.new(1,0,0,0),
AnchorPoint=Vector2.new(1,0),
Parent=i,
ZIndex=999,
Active=true,
})

local m=e.NewRoundFrame(k/2,"Squircle",{
Size=UDim2.new(1,0,0,0),
ImageTransparency=0.85,
ThemeTag={ImageColor3="Text"},
Parent=l,
})

local n=f("Frame",{
Size=UDim2.new(1,12,1,12),
Position=UDim2.new(0.5,0,0.5,0),
AnchorPoint=Vector2.new(0.5,0.5),
BackgroundTransparency=1,
Active=true,
ZIndex=999,
Parent=m,
})

local o=false
local p=0

local function updateSliderSize()
local q=h
local r=q.AbsoluteCanvasSize.Y
local s=q.AbsoluteWindowSize.Y

if r<=s then
m.Visible=false
return
end

local t=math.clamp(s/r,0.1,1)
m.Size=UDim2.new(1,0,t,0)
m.Visible=true
end

local function updateScrollingFramePosition()
local q=m.Position.Y.Scale
local r=h.AbsoluteCanvasSize.Y
local s=h.AbsoluteWindowSize.Y
local t=math.max(r-s,0)

if t<=0 then return end

local u=math.max(1-m.Size.Y.Scale,0)
if u<=0 then return end

local v=q/u

h.CanvasPosition=Vector2.new(
h.CanvasPosition.X,
v*t
)
end

local function updateThumbPosition()
if o then return end

local q=h.CanvasPosition.Y
local r=h.AbsoluteCanvasSize.Y
local s=h.AbsoluteWindowSize.Y
local t=math.max(r-s,0)

if t<=0 then
m.Position=UDim2.new(0,0,0,0)
return
end

local u=q/t
local v=math.max(1-m.Size.Y.Scale,0)
local w=math.clamp(u*v,0,v)

m.Position=UDim2.new(0,0,w,0)
end

e.AddSignal(l.InputBegan,function(q)
if(q.UserInputType==Enum.UserInputType.MouseButton1 or q.UserInputType==Enum.UserInputType.Touch)then
local r=m.AbsolutePosition.Y
local s=r+m.AbsoluteSize.Y

if not(q.Position.Y>=r and q.Position.Y<=s)then
local t=l.AbsolutePosition.Y
local u=l.AbsoluteSize.Y
local v=m.AbsoluteSize.Y

local w=q.Position.Y-t-v/2
local x=u-v

local y=math.clamp(w/x,0,1-m.Size.Y.Scale)

m.Position=UDim2.new(0,0,y,0)
updateScrollingFramePosition()
end
end
end)

e.AddSignal(n.InputBegan,function(q)
if q.UserInputType==Enum.UserInputType.MouseButton1 or q.UserInputType==Enum.UserInputType.Touch then
o=true
p=q.Position.Y-m.AbsolutePosition.Y

local r
local s

r=d.InputChanged:Connect(function(t)
if t.UserInputType==Enum.UserInputType.MouseMovement or t.UserInputType==Enum.UserInputType.Touch then
local u=l.AbsolutePosition.Y
local v=l.AbsoluteSize.Y
local w=m.AbsoluteSize.Y

local x=t.Position.Y-u-p
local y=v-w

local z=math.clamp(x/y,0,1-m.Size.Y.Scale)

m.Position=UDim2.new(0,0,z,0)
updateScrollingFramePosition()
end
end)

s=d.InputEnded:Connect(function(t)
if t.UserInputType==Enum.UserInputType.MouseButton1 or t.UserInputType==Enum.UserInputType.Touch then
o=false
if r then r:Disconnect()end
if s then s:Disconnect()end
end
end)
end
end)

e.AddSignal(h:GetPropertyChangedSignal"AbsoluteWindowSize",function()
updateSliderSize()
updateThumbPosition()
end)

e.AddSignal(h:GetPropertyChangedSignal"AbsoluteCanvasSize",function()
updateSliderSize()
updateThumbPosition()
end)

e.AddSignal(h:GetPropertyChangedSignal"CanvasPosition",function()
if not o then
updateThumbPosition()
end
end)

updateSliderSize()
updateThumbPosition()

return l
end


return b end function a.k()

local b=game:GetService"HttpService"

local d
d={
Window=nil,
Folder=nil,
Path=nil,
Configs={},
Parser={
Colorpicker={
Save=function(e)
return{
__type=e.__type,
value=e.Default:ToHex(),
transparency=e.Transparency or nil,
}
end,
Load=function(e,f)
if e then
e:Update(Color3.fromHex(f.value),f.transparency or nil)
end
end
},
Dropdown={
Save=function(e)
return{
__type=e.__type,
value=e.Value,
}
end,
Load=function(e,f)
if e then
e:Select(f.value)
end
end
},
Input={
Save=function(e)
return{
__type=e.__type,
value=e.Value,
}
end,
Load=function(e,f)
if e then
e:Set(f.value)
end
end
},
Keybind={
Save=function(e)
return{
__type=e.__type,
value=e.Value,
}
end,
Load=function(e,f)
if e then
e:Set(f.value)
end
end
},
Slider={
Save=function(e)
return{
__type=e.__type,
value=e.Value.Default,
}
end,
Load=function(e,f)
if e then
e:Set(f.value)
end
end
},
Toggle={
Save=function(e)
return{
__type=e.__type,
value=e.Value,
}
end,
Load=function(e,f)
if e then
e:Set(f.value)
end
end
},
}
}

function d.Init(e,f)
if not f.Folder then
warn"[ WindUI.ConfigManager ] Window.Folder is not specified."

return false
end

d.Window=f
d.Folder=f.Folder
d.Path="WindUI/"..tostring(d.Folder).."/config/"

return d
end

function d.CreateConfig(e,f)
local g={
Path=d.Path..f..".json",

Elements={}
}

if not f then
return false,"No config file is selected"
end

function g.Register(h,i,j)
g.Elements[i]=j
end

function g.Save(h)
local i={
Elements={}
}

for j,k in next,g.Elements do
if d.Parser[k.__type]then
i.Elements[tostring(j)]=d.Parser[k.__type].Save(k)
end
end

print(b:JSONEncode(i))

writefile(g.Path,b:JSONEncode(i))
end

function g.Load(h)
if not isfile(g.Path)then return false,"Invalid file"end

local i=b:JSONDecode(readfile(g.Path))

for j,k in next,i.Elements do
if g.Elements[j]and d.Parser[k.__type]then
task.spawn(function()
d.Parser[k.__type].Load(g.Elements[j],k)
end)
end
end

end


d.Configs[f]=g

return g
end

function d.AllConfigs(e)
if listfiles then
local f={}
for g,h in next,listfiles(d.Path)do
local i=h:match"([^\\/]+)%.json$"
if i then
table.insert(f,i)
end
end

return f
end
return false
end

return d end function a.l()
local b={}

local d=a.load'a'
local e=d.New
local f=d.Tween

local g=game:GetService"UserInputService"


function b.New(h)
local i={
Button=nil
}

local j













local k=e("TextLabel",{
Text=h.Title,
TextSize=17,
FontFace=Font.new(d.Font,Enum.FontWeight.Medium),
BackgroundTransparency=1,
AutomaticSize="XY",
})

local l=e("Frame",{
Size=UDim2.new(0,36,0,36),
BackgroundTransparency=1,
Name="Drag",
},{
e("ImageLabel",{
Image=d.Icon"move"[1],
ImageRectOffset=d.Icon"move"[2].ImageRectPosition,
ImageRectSize=d.Icon"move"[2].ImageRectSize,
Size=UDim2.new(0,18,0,18),
BackgroundTransparency=1,
Position=UDim2.new(0.5,0,0.5,0),
AnchorPoint=Vector2.new(0.5,0.5),
})
})
local m=e("Frame",{
Size=UDim2.new(0,1,1,0),
Position=UDim2.new(0,36,0.5,0),
AnchorPoint=Vector2.new(0,0.5),
BackgroundColor3=Color3.new(1,1,1),
BackgroundTransparency=.9,
})

local n=e("Frame",{
Size=UDim2.new(0,0,0,0),
Position=UDim2.new(0.5,0,0,28),
AnchorPoint=Vector2.new(0.5,0.5),
Parent=h.Parent,
BackgroundTransparency=1,
Active=true,
Visible=false,
})
local o=e("TextButton",{
Size=UDim2.new(0,0,0,44),
AutomaticSize="X",
Parent=n,
Active=false,
BackgroundTransparency=.25,
ZIndex=99,
BackgroundColor3=Color3.new(0,0,0),
},{



e("UICorner",{
CornerRadius=UDim.new(1,0)
}),
e("UIStroke",{
Thickness=1,
ApplyStrokeMode="Border",
Color=Color3.new(1,1,1),
Transparency=0,
},{
e("UIGradient",{
Color=ColorSequence.new(Color3.fromHex"40c9ff",Color3.fromHex"e81cff")
})
}),
l,
m,

e("UIListLayout",{
Padding=UDim.new(0,4),
FillDirection="Horizontal",
VerticalAlignment="Center",
}),

e("TextButton",{
AutomaticSize="XY",
Active=true,
BackgroundTransparency=1,
Size=UDim2.new(0,0,0,36),

BackgroundColor3=Color3.new(1,1,1),
},{
e("UICorner",{
CornerRadius=UDim.new(1,-4)
}),
j,
e("UIListLayout",{
Padding=UDim.new(0,h.UIPadding),
FillDirection="Horizontal",
VerticalAlignment="Center",
}),
k,
e("UIPadding",{
PaddingLeft=UDim.new(0,12),
PaddingRight=UDim.new(0,12),
}),
}),
e("UIPadding",{
PaddingLeft=UDim.new(0,4),
PaddingRight=UDim.new(0,4),
})
})

i.Button=o



function i.SetIcon(p,q)
if j then
j:Destroy()
end
if q then
j=d.Image(
q,
h.Title,
0,
h.Folder,
"OpenButton",
true,
h.IconThemed
)
j.Size=UDim2.new(0,22,0,22)
j.LayoutOrder=-1
j.Parent=i.Button.TextButton
end
end

if h.Icon then
i:SetIcon(h.Icon)
end



d.AddSignal(o:GetPropertyChangedSignal"AbsoluteSize",function()
n.Size=UDim2.new(
0,o.AbsoluteSize.X,
0,o.AbsoluteSize.Y
)
end)

d.AddSignal(o.TextButton.MouseEnter,function()
f(o.TextButton,.1,{BackgroundTransparency=.93}):Play()
end)
d.AddSignal(o.TextButton.MouseLeave,function()
f(o.TextButton,.1,{BackgroundTransparency=1}):Play()
end)

local p=d.Drag(n)


function i.Visible(q,r)
n.Visible=r
end

function i.Edit(q,r)
local s={
Title=r.Title,
Icon=r.Icon,
Enabled=r.Enabled,
Position=r.Position,
Draggable=r.Draggable,
OnlyMobile=r.OnlyMobile,
CornerRadius=r.CornerRadius or UDim.new(1,0),
StrokeThickness=r.StrokeThickness or 2,
Color=r.Color
or ColorSequence.new(Color3.fromHex"40c9ff",Color3.fromHex"e81cff"),
}



if s.Enabled==false then
h.IsOpenButtonEnabled=false
end
if s.Draggable==false and l and m then
l.Visible=s.Draggable
m.Visible=s.Draggable

if p then
p:Set(s.Draggable)
end
end
if s.Position and OpenButtonContainer then
OpenButtonContainer.Position=s.Position

end

local t=g.KeyboardEnabled or not g.TouchEnabled
b.Visible=not s.OnlyMobile or not t

if not b.Visible then return end

if k then
if s.Title then
k.Text=s.Title
elseif s.Title==nil then

end
end

if s.Icon then
i:SetIcon(s.Icon)
end

o.UIStroke.UIGradient.Color=s.Color
if Glow then
Glow.UIGradient.Color=s.Color
end

o.UICorner.CornerRadius=s.CornerRadius
o.TextButton.UICorner.CornerRadius=UDim.new(s.CornerRadius.Scale,s.CornerRadius.Offset-4)
o.UIStroke.Thickness=s.StrokeThickness
end

return i
end



return b end function a.m()
local b={}

local d=a.load'a'
local e=d.New
local f=d.Tween


function b.New(g,h)
local i={
Container=nil,
ToolTipSize=16,
}

local j=e("TextLabel",{
AutomaticSize="XY",
TextWrapped=true,
BackgroundTransparency=1,
FontFace=Font.new(d.Font,Enum.FontWeight.Medium),
Text=g,
TextSize=17,
ThemeTag={
TextColor3="Text",
}
})

local k=e("UIScale",{
Scale=.9
})

local l=e("CanvasGroup",{
AnchorPoint=Vector2.new(0.5,0),
AutomaticSize="XY",
BackgroundTransparency=1,
Parent=h,
GroupTransparency=1,
Visible=false
},{
e("UISizeConstraint",{
MaxSize=Vector2.new(400,math.huge)
}),
e("Frame",{
AutomaticSize="XY",
BackgroundTransparency=1,
LayoutOrder=99,
Visible=false
},{
e("ImageLabel",{
Size=UDim2.new(0,i.ToolTipSize,0,i.ToolTipSize/2),
BackgroundTransparency=1,
Rotation=180,
Image="rbxassetid://89524607682719",
ThemeTag={
ImageColor3="Accent",
},
},{
e("ImageLabel",{
Size=UDim2.new(0,i.ToolTipSize,0,i.ToolTipSize/2),
BackgroundTransparency=1,
LayoutOrder=99,
ImageTransparency=.9,
Image="rbxassetid://89524607682719",
ThemeTag={
ImageColor3="Text",
},
}),
}),
}),
e("Frame",{
AutomaticSize="XY",
ThemeTag={
BackgroundColor3="Accent",
},

},{
e("UICorner",{
CornerRadius=UDim.new(0,16),
}),
e("Frame",{
ThemeTag={
BackgroundColor3="Text",
},
AutomaticSize="XY",
BackgroundTransparency=.9,
},{
e("UICorner",{
CornerRadius=UDim.new(0,16),
}),
e("UIListLayout",{
Padding=UDim.new(0,12),
FillDirection="Horizontal",
VerticalAlignment="Center"
}),

j,
e("UIPadding",{
PaddingTop=UDim.new(0,12),
PaddingLeft=UDim.new(0,12),
PaddingRight=UDim.new(0,12),
PaddingBottom=UDim.new(0,12),
}),
})
}),
k,
e("UIListLayout",{
Padding=UDim.new(0,0),
FillDirection="Vertical",
VerticalAlignment="Center",
HorizontalAlignment="Center",
}),
})
i.Container=l

function i.Open(m)
l.Visible=true

f(l,.16,{GroupTransparency=0},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
f(k,.18,{Scale=1},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
end

function i.Close(m)
f(l,.2,{GroupTransparency=1},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
f(k,.2,{Scale=.9},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()

task.wait(.25)

l.Visible=false
l:Destroy()
end

return i
end


return b end function a.n()
local b=a.load'a'
local d=b.New
local e=b.NewRoundFrame
local f=b.Tween

game:GetService"UserInputService"


return function(g)
local h={
Title=g.Title,
Desc=g.Desc or nil,
Hover=g.Hover,
Thumbnail=g.Thumbnail,
ThumbnailSize=g.ThumbnailSize or 80,
Image=g.Image,
IconThemed=g.IconThemed or false,
ImageSize=g.ImageSize or 30,
Color=g.Color,
Scalable=g.Scalable,
Parent=g.Parent,
UIPadding=14,
UICorner=14,
UIElements={}
}

local i=h.ImageSize
local j=h.ThumbnailSize
local k=true


local l=0

local m
local n
if h.Thumbnail then
m=b.Image(
h.Thumbnail,
h.Title,
h.UICorner-3,
g.Window.Folder,
"Thumbnail",
false,
h.IconThemed
)
m.Size=UDim2.new(1,0,0,j)
end
if h.Image then
n=b.Image(
h.Image,
h.Title,
h.UICorner-3,
g.Window.Folder,
"Image",
h.Color and true or false
)
if h.Color=="White"then
n.ImageLabel.ImageColor3=Color3.new(0,0,0)
elseif h.Color then
n.ImageLabel.ImageColor3=Color3.new(1,1,1)
end
n.Size=UDim2.new(0,i,0,i)

l=i
end

local function CreateText(o,p)
return d("TextLabel",{
BackgroundTransparency=1,
Text=o or"",
TextSize=p=="Desc"and 15 or 17,
TextXAlignment="Left",
ThemeTag={
TextColor3=not h.Color and(p=="Desc"and"Icon"or"Text")or nil,
},
TextColor3=h.Color and(h.Color=="White"and Color3.new(0,0,0)or h.Color~="White"and Color3.new(1,1,1))or nil,
TextTransparency=h.Color and(p=="Desc"and.3 or 0),
TextWrapped=true,
Size=UDim2.new(1,0,0,0),
AutomaticSize="Y",
FontFace=Font.new(b.Font,Enum.FontWeight.Medium)
})
end

local o=CreateText(h.Title,"Title")
local p=CreateText(h.Desc,"Desc")
if not h.Desc or h.Desc==""then
p.Visible=false
end

h.UIElements.Container=d("Frame",{
Size=UDim2.new(1,0,0,0),
AutomaticSize="Y",
BackgroundTransparency=1,
},{
d("UIListLayout",{
Padding=UDim.new(0,h.UIPadding),
FillDirection="Vertical",
VerticalAlignment="Top",
HorizontalAlignment="Left",
}),
m,
d("Frame",{
Size=UDim2.new(1,-g.TextOffset,0,0),
AutomaticSize="Y",
BackgroundTransparency=1,
},{
d("UIListLayout",{
Padding=UDim.new(0,h.UIPadding),
FillDirection="Horizontal",
VerticalAlignment="Top",
HorizontalAlignment="Left",
}),
n,
d("Frame",{
BackgroundTransparency=1,
AutomaticSize="Y",
Size=UDim2.new(1,-l,0,(50-(h.UIPadding*2)))
},{
d("UIListLayout",{
Padding=UDim.new(0,4),
FillDirection="Vertical",
VerticalAlignment="Center",
HorizontalAlignment="Left",
}),
o,
p
}),
})
})

h.UIElements.Locked=e(h.UICorner,"Squircle",{
Size=UDim2.new(1,h.UIPadding*2,1,h.UIPadding*2),
ImageTransparency=.4,
AnchorPoint=Vector2.new(0.5,0.5),
Position=UDim2.new(0.5,0,0.5,0),
ImageColor3=Color3.new(0,0,0),
Visible=false,
Active=false,
ZIndex=9999999,
})

h.UIElements.Main=e(h.UICorner,"Squircle",{
Size=UDim2.new(1,0,0,50),
AutomaticSize="Y",
ImageTransparency=h.Color and.1 or.95,



Parent=g.Parent,
ThemeTag={
ImageColor3=not h.Color and"Text"or nil
},
ImageColor3=h.Color and Color3.fromHex(b.Colors[h.Color])or nil
},{
h.UIElements.Container,
h.UIElements.Locked,
d("UIPadding",{
PaddingTop=UDim.new(0,h.UIPadding),
PaddingLeft=UDim.new(0,h.UIPadding),
PaddingRight=UDim.new(0,h.UIPadding),
PaddingBottom=UDim.new(0,h.UIPadding),
}),
},true)

if h.Hover then
b.AddSignal(h.UIElements.Main.MouseEnter,function()
if k then
f(h.UIElements.Main,.05,{ImageTransparency=h.Color and.15 or.9}):Play()
end
end)
b.AddSignal(h.UIElements.Main.InputEnded,function()
if k then
f(h.UIElements.Main,.05,{ImageTransparency=h.Color and.1 or.95}):Play()
end
end)
end

function h.SetTitle(q,r)
o.Text=r
end

function h.SetDesc(q,r)
p.Text=r or""
if not r then
p.Visible=false
elseif not p.Visible then
p.Visible=true
end
end






function h.Destroy(q)
h.UIElements.Main:Destroy()
end


function h.Lock(q)
k=false
h.UIElements.Locked.Active=true
h.UIElements.Locked.Visible=true
end

function h.Unlock(q)
k=true
h.UIElements.Locked.Active=false
h.UIElements.Locked.Visible=false
end





return h
end end function a.o()
local b=a.load'a'
local d=b.New

local e={}

function e.New(f,g)
local h={
__type="Button",
Title=g.Title or"Button",
Desc=g.Desc or nil,
Locked=g.Locked or false,
Callback=g.Callback or function()end,
UIElements={}
}

local i=true

h.ButtonFrame=a.load'n'{
Title=h.Title,
Desc=h.Desc,
Parent=g.Parent,




Window=g.Window,
TextOffset=20,
Hover=true,
Scalable=true,
}

h.UIElements.ButtonIcon=d("ImageLabel",{
Image=b.Icon"mouse-pointer-click"[1],
ImageRectOffset=b.Icon"mouse-pointer-click"[2].ImageRectPosition,
ImageRectSize=b.Icon"mouse-pointer-click"[2].ImageRectSize,
BackgroundTransparency=1,
Parent=h.ButtonFrame.UIElements.Main,
Size=UDim2.new(0,20,0,20),
AnchorPoint=Vector2.new(1,0.5),
Position=UDim2.new(1,0,0.5,0),
ThemeTag={
ImageColor3="Text"
}
})

function h.Lock(j)
i=false
return h.ButtonFrame:Lock()
end
function h.Unlock(j)
i=true
return h.ButtonFrame:Unlock()
end

if h.Locked then
h:Lock()
end

b.AddSignal(h.ButtonFrame.UIElements.Main.MouseButton1Click,function()
if i then
task.spawn(function()
b.SafeCallback(h.Callback)
end)
end
end)
return h.__type,h
end

return e end function a.p()
local b={}

local d=a.load'a'
local e=d.New
local f=d.Tween


function b.New(g,h,i,j)
local k={}


local l=13
local m
if h and h~=""then
m=e("ImageLabel",{
Size=UDim2.new(1,-7,1,-7),
BackgroundTransparency=1,
AnchorPoint=Vector2.new(0.5,0.5),
Position=UDim2.new(0.5,0,0.5,0),
Image=d.Icon(h)[1],
ImageRectOffset=d.Icon(h)[2].ImageRectPosition,
ImageRectSize=d.Icon(h)[2].ImageRectSize,
ImageTransparency=1,
ImageColor3=Color3.new(0,0,0),
})
end

local n=d.NewRoundFrame(l,"Squircle",{
ImageTransparency=.95,
ThemeTag={
ImageColor3="Text"
},
Parent=i,
Size=UDim2.new(0,42,0,26),
},{
d.NewRoundFrame(l,"Squircle",{
Size=UDim2.new(1,0,1,0),
Name="Layer",
ThemeTag={
ImageColor3="Button",
},
ImageTransparency=1,
}),
d.NewRoundFrame(l,"SquircleOutline",{
Size=UDim2.new(1,0,1,0),
Name="Stroke",
ImageColor3=Color3.new(1,1,1),
ImageTransparency=1,
},{
e("UIGradient",{
Rotation=90,
Transparency=NumberSequence.new{
NumberSequenceKeypoint.new(0,0),
NumberSequenceKeypoint.new(1,1),
}
})
}),


d.NewRoundFrame(l,"Squircle",{
Size=UDim2.new(0,18,0,18),
Position=UDim2.new(0,3,0.5,0),
AnchorPoint=Vector2.new(0,0.5),
ImageTransparency=0,
ImageColor3=Color3.new(1,1,1),
Name="Frame",
},{
m,
})
})

function k.Set(o,p)
if p then
f(n.Frame,0.1,{
Position=UDim2.new(1,-22,0.5,0),

},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
f(n.Layer,0.1,{
ImageTransparency=0,
}):Play()
f(n.Stroke,0.1,{
ImageTransparency=0.95,
}):Play()

if m then
f(m,0.1,{
ImageTransparency=0,
}):Play()
end
else
f(n.Frame,0.1,{
Position=UDim2.new(0,4,0.5,0),
Size=UDim2.new(0,18,0,18),
},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
f(n.Layer,0.1,{
ImageTransparency=1,
}):Play()
f(n.Stroke,0.1,{
ImageTransparency=1,
}):Play()

if m then
f(m,0.1,{
ImageTransparency=1,
}):Play()
end
end

task.spawn(function()
if j then
d.SafeCallback(j,p)
end
end)


end

return n,k
end


return b end function a.q()
local b={}

local d=a.load'a'
local e=d.New
local f=d.Tween


function b.New(g,h,i,j)
local k={}

h=h or"check"

local l=10
local m=e("ImageLabel",{
Size=UDim2.new(1,-10,1,-10),
BackgroundTransparency=1,
AnchorPoint=Vector2.new(0.5,0.5),
Position=UDim2.new(0.5,0,0.5,0),
Image=d.Icon(h)[1],
ImageRectOffset=d.Icon(h)[2].ImageRectPosition,
ImageRectSize=d.Icon(h)[2].ImageRectSize,
ImageTransparency=1,
ImageColor3=Color3.new(1,1,1),
})

local n=d.NewRoundFrame(l,"Squircle",{
ImageTransparency=.95,
ThemeTag={
ImageColor3="Text"
},
Parent=i,
Size=UDim2.new(0,27,0,27),
},{
d.NewRoundFrame(l,"Squircle",{
Size=UDim2.new(1,0,1,0),
Name="Layer",
ThemeTag={
ImageColor3="Button",
},
ImageTransparency=1,
}),
d.NewRoundFrame(l,"SquircleOutline",{
Size=UDim2.new(1,0,1,0),
Name="Stroke",
ImageColor3=Color3.new(1,1,1),
ImageTransparency=1,
},{
e("UIGradient",{
Rotation=90,
Transparency=NumberSequence.new{
NumberSequenceKeypoint.new(0,0),
NumberSequenceKeypoint.new(1,1),
}
})
}),

m,
})

function k.Set(o,p)
if p then
f(n.Layer,0.06,{
ImageTransparency=0,
}):Play()
f(n.Stroke,0.06,{
ImageTransparency=0.95,
}):Play()
f(m,0.06,{
ImageTransparency=0,
}):Play()
else
f(n.Layer,0.05,{
ImageTransparency=1,
}):Play()
f(n.Stroke,0.05,{
ImageTransparency=1,
}):Play()
f(m,0.06,{
ImageTransparency=1,
}):Play()
end

task.spawn(function()
if j then
d.SafeCallback(j,p)
end
end)
end

return n,k
end


return b end function a.r()
local b=a.load'a'local d=
b.New local e=
b.Tween

local f=a.load'p'.New
local g=a.load'q'.New

local h={}

function h.New(i,j)
local k={
__type="Toggle",
Title=j.Title or"Toggle",
Desc=j.Desc or nil,
Value=j.Value,
Icon=j.Icon or nil,
Type=j.Type or"Toggle",
Callback=j.Callback or function()end,
UIElements={}
}
k.ToggleFrame=a.load'n'{
Title=k.Title,
Desc=k.Desc,




Window=j.Window,
Parent=j.Parent,
TextOffset=44,
Hover=false,
}

local l=true

if k.Value==nil then
k.Value=false
end



function k.Lock(m)
l=false
return k.ToggleFrame:Lock()
end
function k.Unlock(m)
l=true
return k.ToggleFrame:Unlock()
end

if k.Locked then
k:Lock()
end

local m=k.Value

local n,o
if k.Type=="Toggle"then
n,o=f(m,k.Icon,k.ToggleFrame.UIElements.Main,k.Callback)
elseif k.Type=="Checkbox"then
n,o=g(m,k.Icon,k.ToggleFrame.UIElements.Main,k.Callback)
else
error("Unknown Toggle Type: "..tostring(k.Type))
end

n.AnchorPoint=Vector2.new(1,0.5)
n.Position=UDim2.new(1,0,0.5,0)

function k.Set(p,q)
if l then
o:Set(q)
m=q
k.Value=q
end
end

k:Set(m)

b.AddSignal(k.ToggleFrame.UIElements.Main.MouseButton1Click,function()
k:Set(not m)
end)

return k.__type,k
end

return h end function a.s()
local b=a.load'a'
local e=b.New
local f=b.Tween

local g={}

local h=false

function g.New(i,j)
local k={
__type="Slider",
Title=j.Title or"Slider",
Desc=j.Desc or nil,
Locked=j.Locked or nil,
Value=j.Value or{},
Step=j.Step or 1,
Callback=j.Callback or function()end,
UIElements={},
IsFocusing=false,
}
local l
local m
local n
local o=k.Value.Default or k.Value.Min or 0

local p=o
local q=(o-(k.Value.Min or 0))/((k.Value.Max or 100)-(k.Value.Min or 0))

local r=true
local s=k.Step%1~=0

local function FormatValue(t)
if s then
return string.format("%.2f",t)
else
return tostring(math.floor(t+0.5))
end
end

local function CalculateValue(t)
if s then
return math.floor(t/k.Step+0.5)*k.Step
else
return math.floor(t/k.Step+0.5)*k.Step
end
end

k.SliderFrame=a.load'n'{
Title=k.Title,
Desc=k.Desc,
Parent=j.Parent,
TextOffset=0,
Hover=false,
}

k.UIElements.SliderIcon=b.NewRoundFrame(99,"Squircle",{
ImageTransparency=.95,
Size=UDim2.new(1,-68,0,4),
Name="Frame",
ThemeTag={
ImageColor3="Text",
},
},{
b.NewRoundFrame(99,"Squircle",{
Name="Frame",
Size=UDim2.new(q,0,1,0),
ImageTransparency=.1,
ThemeTag={
ImageColor3="Button",
},
},{
b.NewRoundFrame(99,"Squircle",{
Size=UDim2.new(0,13,0,13),
Position=UDim2.new(1,0,0.5,0),
AnchorPoint=Vector2.new(0.5,0.5),
ThemeTag={
ImageColor3="Text",
},
})
})
})

k.UIElements.SliderContainer=e("Frame",{
Size=UDim2.new(1,0,0,0),
AutomaticSize="Y",
Position=UDim2.new(0,0,0,0),
BackgroundTransparency=1,
Parent=k.SliderFrame.UIElements.Container,
},{
e("UIListLayout",{
Padding=UDim.new(0,8),
FillDirection="Horizontal",
VerticalAlignment="Center",
}),
k.UIElements.SliderIcon,
e("TextBox",{
Size=UDim2.new(0,60,0,0),
TextXAlignment="Left",
Text=FormatValue(o),
ThemeTag={
TextColor3="Text"
},
TextTransparency=.4,
AutomaticSize="Y",
TextSize=15,
FontFace=Font.new(b.Font,Enum.FontWeight.Medium),
BackgroundTransparency=1,
LayoutOrder=-1,
})
})

function k.Lock(t)
r=false
return k.SliderFrame:Lock()
end
function k.Unlock(t)
r=true
return k.SliderFrame:Unlock()
end

if k.Locked then
k:Lock()
end

function k.Set(t,u,v)
if r then
if not k.IsFocusing and not h and(not v or(v.UserInputType==Enum.UserInputType.MouseButton1 or v.UserInputType==Enum.UserInputType.Touch))then
u=math.clamp(u,k.Value.Min or 0,k.Value.Max or 100)

local w=math.clamp((u-(k.Value.Min or 0))/((k.Value.Max or 100)-(k.Value.Min or 0)),0,1)
u=CalculateValue(k.Value.Min+w*(k.Value.Max-k.Value.Min))

if u~=p then
f(k.UIElements.SliderIcon.Frame,0.08,{Size=UDim2.new(w,0,1,0)}):Play()
k.UIElements.SliderContainer.TextBox.Text=FormatValue(u)
k.Value.Default=FormatValue(u)
p=u
b.SafeCallback(k.Callback,FormatValue(u))
end

if v then
l=(v.UserInputType==Enum.UserInputType.Touch)
k.SliderFrame.Parent.ScrollingEnabled=false
h=true
m=game:GetService"RunService".RenderStepped:Connect(function()
local x=l and v.Position.X or game:GetService"UserInputService":GetMouseLocation().X
local y=math.clamp((x-k.UIElements.SliderIcon.AbsolutePosition.X)/k.UIElements.SliderIcon.AbsoluteSize.X,0,1)
u=CalculateValue(k.Value.Min+y*(k.Value.Max-k.Value.Min))

if u~=p then
f(k.UIElements.SliderIcon.Frame,0.08,{Size=UDim2.new(y,0,1,0)}):Play()
k.UIElements.SliderContainer.TextBox.Text=FormatValue(u)
k.Value.Default=FormatValue(u)
p=u
b.SafeCallback(k.Callback,FormatValue(u))
end
end)
n=game:GetService"UserInputService".InputEnded:Connect(function(x)
if(x.UserInputType==Enum.UserInputType.MouseButton1 or x.UserInputType==Enum.UserInputType.Touch)and v==x then
m:Disconnect()
n:Disconnect()
h=false
k.SliderFrame.Parent.ScrollingEnabled=true
end
end)
end
end
end
end

b.AddSignal(k.UIElements.SliderContainer.TextBox.FocusLost,function(t)
if t then
local u=tonumber(k.UIElements.SliderContainer.TextBox.Text)
if u then
k:Set(u)
else
k.UIElements.SliderContainer.TextBox.Text=FormatValue(p)
end
end
end)

b.AddSignal(k.UIElements.SliderContainer.InputBegan,function(t)
k:Set(o,t)
end)

return k.__type,k
end

return g end function a.t()
local b=game:GetService"UserInputService"

local e=a.load'a'
local f=e.New local g=
e.Tween

local h={
UICorner=6,
UIPadding=8,
}

local i=a.load'i'.New

function h.New(j,k)
local l={
__type="Keybind",
Title=k.Title or"Keybind",
Desc=k.Desc or nil,
Locked=k.Locked or false,
Value=k.Value or"F",
Callback=k.Callback or function()end,
CanChange=k.CanChange or true,
Picking=false,
UIElements={},
}

local m=true

l.KeybindFrame=a.load'n'{
Title=l.Title,
Desc=l.Desc,
Parent=k.Parent,
TextOffset=85,
Hover=l.CanChange,
}

l.UIElements.Keybind=i(l.Value,nil,l.KeybindFrame.UIElements.Main)

l.UIElements.Keybind.Size=UDim2.new(
0,24
+l.UIElements.Keybind.Frame.Frame.TextLabel.TextBounds.X,
0,
42
)
l.UIElements.Keybind.AnchorPoint=Vector2.new(1,0.5)
l.UIElements.Keybind.Position=UDim2.new(1,0,0.5,0)

f("UIScale",{
Parent=l.UIElements.Keybind,
Scale=.85,
})

e.AddSignal(l.UIElements.Keybind.Frame.Frame.TextLabel:GetPropertyChangedSignal"TextBounds",function()
l.UIElements.Keybind.Size=UDim2.new(
0,24
+l.UIElements.Keybind.Frame.Frame.TextLabel.TextBounds.X,
0,
42
)
end)

function l.Lock(n)
m=false
return l.KeybindFrame:Lock()
end
function l.Unlock(n)
m=true
return l.KeybindFrame:Unlock()
end

function l.Set(n,o)
l.Value=o
l.UIElements.Keybind.Frame.Frame.TextLabel.Text=o
end

if l.Locked then
l:Lock()
end

e.AddSignal(l.KeybindFrame.UIElements.Main.MouseButton1Click,function()
if m then
if l.CanChange then
l.Picking=true
l.UIElements.Keybind.Frame.Frame.TextLabel.Text="..."

task.wait(0.2)

local n
n=b.InputBegan:Connect(function(o)
local p

if o.UserInputType==Enum.UserInputType.Keyboard then
p=o.KeyCode.Name
elseif o.UserInputType==Enum.UserInputType.MouseButton1 then
p="MouseLeft"
elseif o.UserInputType==Enum.UserInputType.MouseButton2 then
p="MouseRight"
end

local q
q=b.InputEnded:Connect(function(r)
if r.KeyCode.Name==p or p=="MouseLeft"and r.UserInputType==Enum.UserInputType.MouseButton1 or p=="MouseRight"and r.UserInputType==Enum.UserInputType.MouseButton2 then
l.Picking=false

l.UIElements.Keybind.Frame.Frame.TextLabel.Text=p
l.Value=p

n:Disconnect()
q:Disconnect()
end
end)
end)
end
end
end)
e.AddSignal(b.InputBegan,function(n)
if m then
if n.KeyCode.Name==l.Value then
e.SafeCallback(l.Callback,n.KeyCode.Name)
end
end
end)
return l.__type,l
end

return h end function a.u()
local b=a.load'a'
local e=b.New local f=
b.Tween

local g={
UICorner=8,
UIPadding=8,
}local h=a.load'c'


.New
local i=a.load'd'.New

function g.New(j,k)
local l={
__type="Input",
Title=k.Title or"Input",
Desc=k.Desc or nil,
Type=k.Type or"Input",
Locked=k.Locked or false,
InputIcon=k.InputIcon or false,
Placeholder=k.Placeholder or"Enter Text...",
Value=k.Value or"",
Callback=k.Callback or function()end,
ClearTextOnFocus=k.ClearTextOnFocus or false,
UIElements={},
}

local m=true

l.InputFrame=a.load'n'{
Title=l.Title,
Desc=l.Desc,
Parent=k.Parent,
TextOffset=0,
Hover=false,
}

local n=i(l.Placeholder,l.InputIcon,l.InputFrame.UIElements.Container,l.Type,function(n)
l:Set(n)
end)
n.Size=UDim2.new(1,0,0,l.Type=="Input"and 42 or 148)

e("UIScale",{
Parent=n,
Scale=1,
})

function l.Lock(o)
m=false
return l.InputFrame:Lock()
end
function l.Unlock(o)
m=true
return l.InputFrame:Unlock()
end


function l.Set(o,p)
if m then
b.SafeCallback(l.Callback,p)

n.Frame.Frame.TextBox.Text=p
l.Value=p
end
end
function l.SetPlaceholder(o,p)
n.Frame.Frame.TextBox.PlaceholderText=p
l.Placeholder=p
end

l:Set(l.Value)

if l.Locked then
l:Lock()
end

return l.__type,l
end

return g end function a.v()
local b=game:GetService"UserInputService"
local e=game:GetService"Players".LocalPlayer:GetMouse()local g=
game:GetService"Workspace".CurrentCamera
game:GetService"TextService"

local h=a.load'a'
local i=h.New
local j=h.Tween

local k=a.load'i'.New

local l={
UICorner=10,
UIPadding=12,
MenuCorner=15,
MenuPadding=5,
TabPadding=10,
}

function l.New(m,n)
local o={
__type="Dropdown",
Title=n.Title or"Dropdown",
Desc=n.Desc or nil,
Locked=n.Locked or false,
Values=n.Values or{},
MenuWidth=n.MenuWidth or 170,
Value=n.Value,
SearchEnabled=n.SearchEnabled~=false,
SearchPlaceholder=n.SearchPlaceholder or"Search...",
AllowNone=n.AllowNone,
Multi=n.Multi,
Callback=n.Callback or function()end,

UIElements={},

Opened=false,
Tabs={},
FilteredValues={},
SearchQuery=""
}

if o.Multi and not o.Value then
o.Value={}
end


o.FilteredValues=o.Values

local p=true

o.DropdownFrame=a.load'n'{
Title=o.Title,
Desc=o.Desc,
Parent=n.Parent,
TextOffset=0,
Hover=false,
}


o.UIElements.Dropdown=k("",nil,o.DropdownFrame.UIElements.Container)

o.UIElements.Dropdown.Frame.Frame.TextLabel.TextTruncate="AtEnd"
o.UIElements.Dropdown.Frame.Frame.TextLabel.Size=UDim2.new(1,o.UIElements.Dropdown.Frame.Frame.TextLabel.Size.X.Offset-18-12-12,0,0)

o.UIElements.Dropdown.Size=UDim2.new(1,0,0,40)






i("ImageLabel",{
Image=h.Icon"chevrons-up-down"[1],
ImageRectOffset=h.Icon"chevrons-up-down"[2].ImageRectPosition,
ImageRectSize=h.Icon"chevrons-up-down"[2].ImageRectSize,
Size=UDim2.new(0,18,0,18),
Position=UDim2.new(1,-12,0.5,0),
ThemeTag={
ImageColor3="Icon"
},
AnchorPoint=Vector2.new(1,0.5),
Parent=o.UIElements.Dropdown.Frame
})

o.UIElements.UIListLayout=i("UIListLayout",{
Padding=UDim.new(0,l.MenuPadding),
FillDirection="Vertical"
})

o.UIElements.Menu=h.NewRoundFrame(l.MenuCorner,"Squircle",{
ThemeTag={
ImageColor3="Background",
},
ImageTransparency=0.05,
Size=UDim2.new(1,0,1,0),
AnchorPoint=Vector2.new(1,0),
Position=UDim2.new(1,0,0,0),
},{
i("UIPadding",{
PaddingTop=UDim.new(0,l.MenuPadding),
PaddingLeft=UDim.new(0,l.MenuPadding),
PaddingRight=UDim.new(0,l.MenuPadding),
PaddingBottom=UDim.new(0,l.MenuPadding),
}),

o.SearchEnabled and i("Frame",{
Size=UDim2.new(1,0,0,32),
ThemeTag={
BackgroundColor3="ElementBackground"
},
BorderSizePixel=0,
Name="SearchContainer"
},{
i("UICorner",{
CornerRadius=UDim.new(0,6)
}),
i("UIPadding",{
PaddingLeft=UDim.new(0,8),
PaddingRight=UDim.new(0,8),
PaddingTop=UDim.new(0,4),
PaddingBottom=UDim.new(0,4),
}),
i("TextBox",{
Size=UDim2.new(1,-20,1,0),
Position=UDim2.new(0,20,0,0),
BackgroundTransparency=1,
Text="",
PlaceholderText=o.SearchPlaceholder,
TextSize=14,
TextXAlignment="Left",
FontFace=Font.new(h.Font,Enum.FontWeight.Regular),
ThemeTag={
TextColor3="Text",
PlaceholderColor3="SubText"
},
Name="SearchInput",
ClearTextOnFocus=false
}),
i("ImageLabel",{
Image=h.Icon"search"[1],
ImageRectOffset=h.Icon"search"[2].ImageRectPosition,
ImageRectSize=h.Icon"search"[2].ImageRectSize,
Size=UDim2.new(0,16,0,16),
Position=UDim2.new(0,0,0.5,0),
AnchorPoint=Vector2.new(0,0.5),
BackgroundTransparency=1,
ThemeTag={
ImageColor3="SubText"
}
})
})or nil,
i("Frame",{
BackgroundTransparency=1,
Size=o.SearchEnabled and UDim2.new(1,0,1,-37)or UDim2.new(1,0,1,0),
Position=o.SearchEnabled and UDim2.new(0,0,0,37)or UDim2.new(0,0,0,0),

ClipsDescendants=true
},{
i("UICorner",{
CornerRadius=UDim.new(0,l.MenuCorner-l.MenuPadding),
}),
i("ScrollingFrame",{
Size=UDim2.new(1,0,1,0),
ScrollBarThickness=0,
ScrollingDirection="Y",
AutomaticCanvasSize="Y",
CanvasSize=UDim2.new(0,0,0,0),
BackgroundTransparency=1,
ScrollBarImageTransparency=1,
},{
o.UIElements.UIListLayout,
})
})
})

o.UIElements.MenuCanvas=i("Frame",{
Size=UDim2.new(0,o.MenuWidth,0,o.SearchEnabled and 337 or 300),
BackgroundTransparency=1,
Position=UDim2.new(0,0,1,5),
Visible=false,
Active=false,

Parent=n.WindUI.DropdownGui,
AnchorPoint=Vector2.new(0,0),
},{
o.UIElements.Menu,






i("UISizeConstraint",{
MinSize=Vector2.new(170,0)
})
})


if o.SearchEnabled then
o.UIElements.SearchInput=o.UIElements.Menu.SearchContainer.SearchInput
end

function o.Lock(q)
p=false
return o.DropdownFrame:Lock()
end
function o.Unlock(q)
p=true
return o.DropdownFrame:Unlock()
end

if o.Locked then
o:Lock()
end

local function RecalculateCanvasSize()
o.UIElements.Menu.Frame.ScrollingFrame.CanvasSize=UDim2.fromOffset(0,o.UIElements.UIListLayout.AbsoluteContentSize.Y)
end

local function RecalculateListSize()
if#o.Values>10 then
o.UIElements.MenuCanvas.Size=UDim2.fromOffset(o.UIElements.MenuCanvas.AbsoluteSize.X,o.SearchEnabled and 429 or 392)
else
local q=o.UIElements.UIListLayout.AbsoluteContentSize.Y+(l.MenuPadding*2)
local r=o.SearchEnabled and 37 or 0
o.UIElements.MenuCanvas.Size=UDim2.fromOffset(o.UIElements.MenuCanvas.AbsoluteSize.X,q+r)
end
end


function UpdatePosition()
local q=o.UIElements.Dropdown
local r=o.UIElements.MenuCanvas


r.Position=UDim2.new(
0,
q.AbsolutePosition.X,
0,
q.AbsolutePosition.Y+q.AbsoluteSize.Y+5
)
end


function o.FilterValues(q,r)
if not r or r==""then
o.FilteredValues=o.Values
else
o.FilteredValues={}
local s=string.lower(r)
for t,u in ipairs(o.Values)do
if string.find(string.lower(u),s,1,true)then
table.insert(o.FilteredValues,u)
end
end
end
o:Refresh(o.FilteredValues)
end

function o.Display(q)
local r=o.FilteredValues
local s=""

if o.Multi then
for t,u in next,r do
if table.find(o.Value,u)then
s=s..u..", "
end
end
s=s:sub(1,#s-2)
else
s=o.Value or""
end

o.UIElements.Dropdown.Frame.Frame.TextLabel.Text=(s==""and"--"or s)
end

function o.Refresh(q,r)
for s,t in next,o.UIElements.Menu.Frame.ScrollingFrame:GetChildren()do
if not t:IsA"UIListLayout"then
t:Destroy()
end
end

o.Tabs={}

for s,t in next,r do

local u={
Name=t,
Selected=false,
UIElements={},
}
u.UIElements.TabItem=h.NewRoundFrame(l.MenuCorner-l.MenuPadding,"Squircle",{
Size=UDim2.new(1,0,0,34),

ImageTransparency=1,
Parent=o.UIElements.Menu.Frame.ScrollingFrame,



},{
h.NewRoundFrame(l.MenuCorner-l.MenuPadding,"SquircleOutline",{
Size=UDim2.new(1,0,1,0),
ImageColor3=Color3.new(1,1,1),
ImageTransparency=1,
Name="Highlight",
},{
i("UIGradient",{
Rotation=80,
Color=ColorSequence.new{
ColorSequenceKeypoint.new(0.0,Color3.fromRGB(255,255,255)),
ColorSequenceKeypoint.new(0.5,Color3.fromRGB(255,255,255)),
ColorSequenceKeypoint.new(1.0,Color3.fromRGB(255,255,255)),
},
Transparency=NumberSequence.new{
NumberSequenceKeypoint.new(0.0,0.1),
NumberSequenceKeypoint.new(0.5,1),
NumberSequenceKeypoint.new(1.0,0.1),
}
}),
}),
i("Frame",{
Size=UDim2.new(1,0,1,0),
BackgroundTransparency=1,
},{
i("UIPadding",{

PaddingLeft=UDim.new(0,l.TabPadding),
PaddingRight=UDim.new(0,l.TabPadding),

}),
i("UICorner",{
CornerRadius=UDim.new(0,l.MenuCorner-l.MenuPadding)
}),













i("TextLabel",{
Text=t,
TextXAlignment="Left",
FontFace=Font.new(h.Font,Enum.FontWeight.Regular),
ThemeTag={
TextColor3="Text",
BackgroundColor3="Text"
},
TextSize=15,
BackgroundTransparency=1,
TextTransparency=.4,
AutomaticSize="Y",

Size=UDim2.new(1,0,0,0),
AnchorPoint=Vector2.new(0,0.5),
Position=UDim2.new(0,0,0.5,0),
})
})
},true)


if o.Multi then
u.Selected=table.find(o.Value or{},u.Name)
else
u.Selected=o.Value==u.Name
end

if u.Selected then
u.UIElements.TabItem.ImageTransparency=.95
u.UIElements.TabItem.Highlight.ImageTransparency=.75


u.UIElements.TabItem.Frame.TextLabel.TextTransparency=0.05
end

o.Tabs[s]=u

o:Display()

local function Callback()
o:Display()
task.spawn(function()
h.SafeCallback(o.Callback,o.Value)
end)
end

h.AddSignal(u.UIElements.TabItem.MouseButton1Click,function()
if o.Multi then
if not u.Selected then
u.Selected=true
j(u.UIElements.TabItem,0.1,{ImageTransparency=.95}):Play()
j(u.UIElements.TabItem.Highlight,0.1,{ImageTransparency=.75}):Play()

j(u.UIElements.TabItem.Frame.TextLabel,0.1,{TextTransparency=0}):Play()
table.insert(o.Value,u.Name)
else
if not o.AllowNone and#o.Value==1 then
return
end
u.Selected=false
j(u.UIElements.TabItem,0.1,{ImageTransparency=1}):Play()
j(u.UIElements.TabItem.Highlight,0.1,{ImageTransparency=1}):Play()

j(u.UIElements.TabItem.Frame.TextLabel,0.1,{TextTransparency=.4}):Play()
for v,w in ipairs(o.Value)do
if w==u.Name then
table.remove(o.Value,v)
break
end
end
end
else
for v,w in next,o.Tabs do

j(w.UIElements.TabItem,0.1,{ImageTransparency=1}):Play()
j(w.UIElements.TabItem.Highlight,0.1,{ImageTransparency=1}):Play()

j(w.UIElements.TabItem.Frame.TextLabel,0.1,{TextTransparency=.5}):Play()
w.Selected=false
end
u.Selected=true
j(u.UIElements.TabItem,0.1,{ImageTransparency=.95}):Play()
j(u.UIElements.TabItem.Highlight,0.1,{ImageTransparency=.75}):Play()

j(u.UIElements.TabItem.Frame.TextLabel,0.1,{TextTransparency=0.05}):Play()
o.Value=u.Name
end
Callback()
end)

RecalculateCanvasSize()
RecalculateListSize()
end

local s=0
for t,u in next,o.Tabs do
if u.UIElements.TabItem.Frame.TextLabel then

local v=u.UIElements.TabItem.Frame.TextLabel.TextBounds.X
s=math.max(s,v)
end
end

o.UIElements.MenuCanvas.Size=UDim2.new(0,s+6+6+5+5+18+6+6,o.UIElements.MenuCanvas.Size.Y.Scale,o.UIElements.MenuCanvas.Size.Y.Offset)

end


o:Refresh(o.FilteredValues)


if o.SearchEnabled and o.UIElements.SearchInput then
h.AddSignal(o.UIElements.SearchInput:GetPropertyChangedSignal"Text",function()
local q=o.UIElements.SearchInput.Text
o.SearchQuery=q
o:FilterValues(q)
end)

h.AddSignal(o.UIElements.SearchInput.FocusLost,function()

end)
end

function o.Select(q,r)
if r then
o.Value=r
else
if o.Multi then
o.Value={}
else
o.Value=nil

end
end
o:FilterValues(o.SearchQuery)
end


RecalculateListSize()

function o.Open(q)
if p then
o.UIElements.Menu.Visible=true
o.UIElements.MenuCanvas.Visible=true
o.UIElements.MenuCanvas.Active=true
o.UIElements.Menu.Size=UDim2.new(
1,0,
0,0
)
j(o.UIElements.Menu,0.1,{
Size=UDim2.new(
1,0,
1,0
)
},Enum.EasingStyle.Quart,Enum.EasingDirection.Out):Play()

task.spawn(function()
task.wait(.1)
o.Opened=true
end)




UpdatePosition()
end
end

function o.Close(q)
o.Opened=false


if o.SearchEnabled and o.UIElements.SearchInput then
o.UIElements.SearchInput.Text=""
o.SearchQuery=""
o:FilterValues""
end

j(o.UIElements.Menu,0.25,{
Size=UDim2.new(
1,0,
0,0
)
},Enum.EasingStyle.Quart,Enum.EasingDirection.Out):Play()


task.spawn(function()
task.wait(.2)
o.UIElements.Menu.Visible=false
end)

task.spawn(function()
task.wait(.25)
o.UIElements.MenuCanvas.Visible=false
o.UIElements.MenuCanvas.Active=false
end)
end

h.AddSignal(o.UIElements.Dropdown.MouseButton1Click,function()
o:Open()
end)

h.AddSignal(b.InputBegan,function(q)
if
q.UserInputType==Enum.UserInputType.MouseButton1
or q.UserInputType==Enum.UserInputType.Touch
then
local r,s=o.UIElements.MenuCanvas.AbsolutePosition,o.UIElements.MenuCanvas.AbsoluteSize
if
n.Window.CanDropdown
and o.Opened
and(e.X<r.X
or e.X>r.X+s.X
or e.Y<r.Y
or e.Y>r.Y+s.Y
)
then
o:Close()
end
end
end)

h.AddSignal(o.UIElements.Dropdown:GetPropertyChangedSignal"AbsolutePosition",UpdatePosition)

return o.__type,o
end

return l end function a.w()






local b={}
local e={
lua={
"and","break","or","else","elseif","if","then","until","repeat","while","do","for","in","end",
"local","return","function","export",
},
rbx={
"game","workspace","script","math","string","table","task","wait","select","next","Enum",
"tick","assert","shared","loadstring","tonumber","tostring","type",
"typeof","unpack","Instance","CFrame","Vector3","Vector2","Color3","UDim","UDim2","Ray","BrickColor",
"OverlapParams","RaycastParams","Axes","Random","Region3","Rect","TweenInfo",
"collectgarbage","not","utf8","pcall","xpcall","_G","setmetatable","getmetatable","os","pairs","ipairs"
},
operators={
"#","+","-","*","%","/","^","=","~","=","<",">",
}
}

local g={
numbers=Color3.fromHex"#FAB387",
boolean=Color3.fromHex"#FAB387",
operator=Color3.fromHex"#94E2D5",
lua=Color3.fromHex"#CBA6F7",
rbx=Color3.fromHex"#F38BA8",
str=Color3.fromHex"#A6E3A1",
comment=Color3.fromHex"#9399B2",
null=Color3.fromHex"#F38BA8",
call=Color3.fromHex"#89B4FA",
self_call=Color3.fromHex"#89B4FA",
local_property=Color3.fromHex"#CBA6F7",
}

local function createKeywordSet(h)
local i={}
for j,k in ipairs(h)do
i[k]=true
end
return i
end

local h=createKeywordSet(e.lua)
local i=createKeywordSet(e.rbx)
local j=createKeywordSet(e.operators)

local function getHighlight(k,l)
local m=k[l]

if g[m.."_color"]then
return g[m.."_color"]
end

if tonumber(m)then
return g.numbers
elseif m=="nil"then
return g.null
elseif m:sub(1,2)=="--"then
return g.comment
elseif j[m]then
return g.operator
elseif h[m]then
return g.lua
elseif i[m]then
return g.rbx
elseif m:sub(1,1)=="\""or m:sub(1,1)=="\'"then
return g.str
elseif m=="true"or m=="false"then
return g.boolean
end

if k[l+1]=="("then
if k[l-1]==":"then
return g.self_call
end

return g.call
end

if k[l-1]=="."then
if k[l-2]=="Enum"then
return g.rbx
end

return g.local_property
end
end

function b.run(k)
local l={}
local m=""

local n=false
local o=false
local p=false

for q=1,#k do
local r=k:sub(q,q)

if o then
if r=="\n"and not p then
table.insert(l,m)
table.insert(l,r)
m=""

o=false
elseif k:sub(q-1,q)=="]]"and p then
m..="]"

table.insert(l,m)
m=""

o=false
p=false
else
m=m..r
end
elseif n then
if r==n and k:sub(q-1,q-1)~="\\"or r=="\n"then
m=m..r
n=false
else
m=m..r
end
else
if k:sub(q,q+1)=="--"then
table.insert(l,m)
m="-"
o=true
p=k:sub(q+2,q+3)=="[["
elseif r=="\""or r=="\'"then
table.insert(l,m)
m=r
n=r
elseif j[r]then
table.insert(l,m)
table.insert(l,r)
m=""
elseif r:match"[%w_]"then
m=m..r
else
table.insert(l,m)
table.insert(l,r)
m=""
end
end
end

table.insert(l,m)

local q={}

for r,s in ipairs(l)do
local t=getHighlight(l,r)

if t then
local u=string.format("<font color = \"#%s\">%s</font>",t:ToHex(),s:gsub("<","&lt;"):gsub(">","&gt;"))

table.insert(q,u)
else
table.insert(q,s)
end
end

return table.concat(q)
end

return b end function a.x()
local b={}

local e=a.load'a'
local g=e.New
local h=e.Tween

local i=a.load'w'

function b.New(j,k,l,m,n)
local o={
Radius=12,
Padding=10
}

local p=g("TextLabel",{
Text="",
TextColor3=Color3.fromHex"#CDD6F4",
TextTransparency=0,
TextSize=14,
TextWrapped=false,
LineHeight=1.15,
RichText=true,
TextXAlignment="Left",
Size=UDim2.new(0,0,0,0),
BackgroundTransparency=1,
AutomaticSize="XY",
},{
g("UIPadding",{
PaddingTop=UDim.new(0,o.Padding+3),
PaddingLeft=UDim.new(0,o.Padding+3),
PaddingRight=UDim.new(0,o.Padding+3),
PaddingBottom=UDim.new(0,o.Padding+3),
})
})
p.Font="Code"

local q=g("ScrollingFrame",{
Size=UDim2.new(1,0,0,0),
BackgroundTransparency=1,
AutomaticCanvasSize="X",
ScrollingDirection="X",
ElasticBehavior="Never",
CanvasSize=UDim2.new(0,0,0,0),
ScrollBarThickness=0,
},{
p
})

local r=g("TextButton",{
BackgroundTransparency=1,
Size=UDim2.new(0,30,0,30),
Position=UDim2.new(1,-o.Padding/2,0,o.Padding/2),
AnchorPoint=Vector2.new(1,0),
Visible=m and true or false,
},{
e.NewRoundFrame(o.Radius-4,"Squircle",{



ImageColor3=Color3.fromHex"#ffffff",
ImageTransparency=1,
Size=UDim2.new(1,0,1,0),
AnchorPoint=Vector2.new(0.5,0.5),
Position=UDim2.new(0.5,0,0.5,0),
Name="Button",
},{
g("UIScale",{
Scale=1,
}),
g("ImageLabel",{
Image=e.Icon"copy"[1],
ImageRectSize=e.Icon"copy"[2].ImageRectSize,
ImageRectOffset=e.Icon"copy"[2].ImageRectPosition,
BackgroundTransparency=1,
AnchorPoint=Vector2.new(0.5,0.5),
Position=UDim2.new(0.5,0,0.5,0),
Size=UDim2.new(0,12,0,12),



ImageColor3=Color3.fromHex"#ffffff",
ImageTransparency=.1,
})
})
})

e.AddSignal(r.MouseEnter,function()
h(r.Button,.05,{ImageTransparency=.95}):Play()
h(r.Button.UIScale,.05,{Scale=.9}):Play()
end)
e.AddSignal(r.InputEnded,function()
h(r.Button,.08,{ImageTransparency=1}):Play()
h(r.Button.UIScale,.08,{Scale=1}):Play()
end)

e.NewRoundFrame(o.Radius,"Squircle",{



ImageColor3=Color3.fromHex"#212121",
ImageTransparency=.035,
Size=UDim2.new(1,0,0,20+(o.Padding*2)),
AutomaticSize="Y",
Parent=l,
},{
e.NewRoundFrame(o.Radius,"SquircleOutline",{
Size=UDim2.new(1,0,1,0),



ImageColor3=Color3.fromHex"#ffffff",
ImageTransparency=.955,
}),
g("Frame",{
BackgroundTransparency=1,
Size=UDim2.new(1,0,0,0),
AutomaticSize="Y",
},{
e.NewRoundFrame(o.Radius,"Squircle-TL-TR",{



ImageColor3=Color3.fromHex"#ffffff",
ImageTransparency=.96,
Size=UDim2.new(1,0,0,20+(o.Padding*2)),
Visible=k and true or false
},{
g("ImageLabel",{
Size=UDim2.new(0,18,0,18),
BackgroundTransparency=1,
Image="rbxassetid://132464694294269",



ImageColor3=Color3.fromHex"#ffffff",
ImageTransparency=.2,
}),
g("TextLabel",{
Text=k,



TextColor3=Color3.fromHex"#ffffff",
TextTransparency=.2,
TextSize=16,
AutomaticSize="Y",
FontFace=Font.new(e.Font,Enum.FontWeight.Medium),
TextXAlignment="Left",
BackgroundTransparency=1,
TextTruncate="AtEnd",
Size=UDim2.new(1,r and-20-(o.Padding*2),0,0)
}),
g("UIPadding",{

PaddingLeft=UDim.new(0,o.Padding+3),
PaddingRight=UDim.new(0,o.Padding+3),

}),
g("UIListLayout",{
Padding=UDim.new(0,o.Padding),
FillDirection="Horizontal",
VerticalAlignment="Center",
})
}),
q,
g("UIListLayout",{
Padding=UDim.new(0,0),
FillDirection="Vertical",
})
}),
r,
})

e.AddSignal(p:GetPropertyChangedSignal"TextBounds",function()
q.Size=UDim2.new(1,0,0,(p.TextBounds.Y/(n or 1))+((o.Padding+3)*2))
end)

function o.Set(s)
p.Text=i.run(s)
end

o.Set(j)

e.AddSignal(r.MouseButton1Click,function()
if m then
m()
local s=e.Icon"check"
r.Button.ImageLabel.Image=s[1]
r.Button.ImageLabel.ImageRectSize=s[2].ImageRectSize
r.Button.ImageLabel.ImageRectOffset=s[2].ImageRectPosition
end
end)
return o
end


return b end function a.y()
local b=a.load'a'local e=
b.New


local g=a.load'x'

local h={}

function h.New(i,j)
local k={
__type="Code",
Title=j.Title,
Code=j.Code,
UIElements={}
}

local l=not k.Locked











local m=g.New(k.Code,k.Title,j.Parent,function()
if l then
local m=k.Title or"code"
local n,o=pcall(function()
toclipboard(k.Code)
end)
if n then
j.WindUI:Notify{
Title="Success",
Content="The "..m.." copied to your clipboard.",
Icon="check",
Duration=5,
}
else
j.WindUI:Notify{
Title="Error",
Content="The "..m.." is not copied. Error: "..o,
Icon="x",
Duration=5,
}
end
end
end,j.WindUI.UIScale)

function k.SetCode(n,o)
m.Set(o)
end

return k.__type,k
end

return h end function a.z()
local b=a.load'a'
local e=b.New local g=
b.Tween

local h=game:GetService"UserInputService"
game:GetService"TouchInputService"
local i=game:GetService"RunService"
local j=game:GetService"Players"

local k=i.RenderStepped
local l=j.LocalPlayer
local m=l:GetMouse()

local n=a.load'c'.New
local o=a.load'd'.New

local p={
UICorner=8,
UIPadding=8
}

function p.Colorpicker(q,r,s)
local t={
__type="Colorpicker",
Title=r.Title,
Desc=r.Desc,
Default=r.Default,
Callback=r.Callback,
Transparency=r.Transparency,
UIElements=r.UIElements,
}

function t.SetHSVFromRGB(u,v)
local w,x,y=Color3.toHSV(v)
t.Hue=w
t.Sat=x
t.Vib=y
end

t:SetHSVFromRGB(t.Default)

local u=a.load'e'.Init(r.Window)
local v=u.Create()

t.ColorpickerFrame=v



local w,x,y=t.Hue,t.Sat,t.Vib

t.UIElements.Title=e("TextLabel",{
Text=t.Title,
TextSize=20,
FontFace=Font.new(b.Font,Enum.FontWeight.SemiBold),
TextXAlignment="Left",
Size=UDim2.new(1,0,0,0),
AutomaticSize="Y",
ThemeTag={
TextColor3="Text"
},
BackgroundTransparency=1,
Parent=v.UIElements.Main
},{
e("UIPadding",{
PaddingTop=UDim.new(0,8),
PaddingLeft=UDim.new(0,8),
PaddingRight=UDim.new(0,8),
PaddingBottom=UDim.new(0,8),
})
})





local z=e("ImageLabel",{
Size=UDim2.new(0,18,0,18),
ScaleType=Enum.ScaleType.Fit,
AnchorPoint=Vector2.new(0.5,0.5),
BackgroundTransparency=1,
Image="http://www.roblox.com/asset/?id=4805639000",
})

t.UIElements.SatVibMap=e("ImageLabel",{
Size=UDim2.fromOffset(160,158),
Position=UDim2.fromOffset(0,40),
Image="rbxassetid://4155801252",
BackgroundColor3=Color3.fromHSV(w,1,1),
BackgroundTransparency=0,
Parent=v.UIElements.Main,
},{
e("UICorner",{
CornerRadius=UDim.new(0,8),
}),
e("UIStroke",{
Thickness=.6,
ThemeTag={
Color="Text"
},
Transparency=.8,
}),
z,
})

t.UIElements.Inputs=e("Frame",{
AutomaticSize="XY",
Size=UDim2.new(0,0,0,0),
Position=UDim2.fromOffset(t.Transparency and 240 or 210,40),
BackgroundTransparency=1,
Parent=v.UIElements.Main
},{
e("UIListLayout",{
Padding=UDim.new(0,5),
FillDirection="Vertical",
})
})





local A=e("Frame",{
BackgroundColor3=t.Default,
Size=UDim2.fromScale(1,1),
BackgroundTransparency=t.Transparency,
},{
e("UICorner",{
CornerRadius=UDim.new(0,8),
}),
})

e("ImageLabel",{
Image="http://www.roblox.com/asset/?id=14204231522",
ImageTransparency=0.45,
ScaleType=Enum.ScaleType.Tile,
TileSize=UDim2.fromOffset(40,40),
BackgroundTransparency=1,
Position=UDim2.fromOffset(85,208),
Size=UDim2.fromOffset(75,24),
Parent=v.UIElements.Main,
},{
e("UICorner",{
CornerRadius=UDim.new(0,8),
}),
e("UIStroke",{
Thickness=1,
Transparency=0.8,
ThemeTag={
Color="Text"
}
}),
A,
})

local B=e("Frame",{
BackgroundColor3=t.Default,
Size=UDim2.fromScale(1,1),
BackgroundTransparency=0,
ZIndex=9,
},{
e("UICorner",{
CornerRadius=UDim.new(0,8),
}),
})

e("ImageLabel",{
Image="http://www.roblox.com/asset/?id=14204231522",
ImageTransparency=0.45,
ScaleType=Enum.ScaleType.Tile,
TileSize=UDim2.fromOffset(40,40),
BackgroundTransparency=1,
Position=UDim2.fromOffset(0,208),
Size=UDim2.fromOffset(75,24),
Parent=v.UIElements.Main,
},{
e("UICorner",{
CornerRadius=UDim.new(0,8),
}),
e("UIStroke",{
Thickness=1,
Transparency=0.8,
ThemeTag={
Color="Text"
}
}),
B,
})

local C={}

for D=0,1,0.1 do
table.insert(C,ColorSequenceKeypoint.new(D,Color3.fromHSV(D,1,1)))
end

local D=e("UIGradient",{
Color=ColorSequence.new(C),
Rotation=90,
})

local E=e("Frame",{
Size=UDim2.new(1,0,1,0),
Position=UDim2.new(0,0,0,0),
BackgroundTransparency=1,
})

local F=e("Frame",{
Size=UDim2.new(0,14,0,14),
AnchorPoint=Vector2.new(0.5,0.5),
Position=UDim2.new(0.5,0,0,0),
Parent=E,


BackgroundColor3=t.Default
},{
e("UIStroke",{
Thickness=2,
Transparency=.1,
ThemeTag={
Color="Text",
},
}),
e("UICorner",{
CornerRadius=UDim.new(1,0),
})
})

local G=e("Frame",{
Size=UDim2.fromOffset(10,192),
Position=UDim2.fromOffset(180,40),
Parent=v.UIElements.Main,
},{
e("UICorner",{
CornerRadius=UDim.new(1,0),
}),
D,
E,
})


function CreateNewInput(H,I)
local J=o(H,nil,t.UIElements.Inputs)

e("TextLabel",{
BackgroundTransparency=1,
TextTransparency=.4,
TextSize=17,
FontFace=Font.new(b.Font,Enum.FontWeight.Regular),
AutomaticSize="XY",
ThemeTag={
TextColor3="Placeholder",
},
AnchorPoint=Vector2.new(1,0.5),
Position=UDim2.new(1,-12,0.5,0),
Parent=J.Frame,
Text=H,
})

e("UIScale",{
Parent=J,
Scale=.85,
})

J.Frame.Frame.TextBox.Text=I
J.Size=UDim2.new(0,150,0,42)

return J
end

local function ToRGB(H)
return{
R=math.floor(H.R*255),
G=math.floor(H.G*255),
B=math.floor(H.B*255)
}
end

local H=CreateNewInput("Hex","#"..t.Default:ToHex())

local I=CreateNewInput("Red",ToRGB(t.Default).R)
local J=CreateNewInput("Green",ToRGB(t.Default).G)
local K=CreateNewInput("Blue",ToRGB(t.Default).B)
local L
if t.Transparency then
L=CreateNewInput("Alpha",((1-t.Transparency)*100).."%")
end

local M=e("Frame",{
Size=UDim2.new(1,0,0,40),
AutomaticSize="Y",
Position=UDim2.new(0,0,0,254),
BackgroundTransparency=1,
Parent=v.UIElements.Main,
LayoutOrder=4,
},{
e("UIListLayout",{
Padding=UDim.new(0,6),
FillDirection="Horizontal",
HorizontalAlignment="Right",
}),
})

local N={
{
Title="Cancel",
Variant="Secondary",
Callback=function()end
},
{
Title="Apply",
Icon="chevron-right",
Variant="Primary",
Callback=function()s(Color3.fromHSV(t.Hue,t.Sat,t.Vib),t.Transparency)end
}
}

for O,P in next,N do
local Q=n(P.Title,P.Icon,P.Callback,P.Variant,M,v,true)
Q.Size=UDim2.new(0.5,-3,0,40)
Q.AutomaticSize="None"
end



local O,P,Q
if t.Transparency then
local R=e("Frame",{
Size=UDim2.new(1,0,1,0),
Position=UDim2.fromOffset(0,0),
BackgroundTransparency=1,
})

P=e("ImageLabel",{
Size=UDim2.new(0,14,0,14),
AnchorPoint=Vector2.new(0.5,0.5),
Position=UDim2.new(0.5,0,0,0),
ThemeTag={
BackgroundColor3="Text",
},
Parent=R,

},{
e("UIStroke",{
Thickness=2,
Transparency=.1,
ThemeTag={
Color="Text",
},
}),
e("UICorner",{
CornerRadius=UDim.new(1,0),
})

})

Q=e("Frame",{
Size=UDim2.fromScale(1,1),
},{
e("UIGradient",{
Transparency=NumberSequence.new{
NumberSequenceKeypoint.new(0,0),
NumberSequenceKeypoint.new(1,1),
},
Rotation=270,
}),
e("UICorner",{
CornerRadius=UDim.new(0,6),
}),
})

O=e("Frame",{
Size=UDim2.fromOffset(10,192),
Position=UDim2.fromOffset(210,40),
Parent=v.UIElements.Main,
BackgroundTransparency=1,
},{
e("UICorner",{
CornerRadius=UDim.new(1,0),
}),
e("ImageLabel",{
Image="rbxassetid://14204231522",
ImageTransparency=0.45,
ScaleType=Enum.ScaleType.Tile,
TileSize=UDim2.fromOffset(40,40),
BackgroundTransparency=1,
Size=UDim2.fromScale(1,1),
},{
e("UICorner",{
CornerRadius=UDim.new(1,0),
}),
}),
Q,
R,
})
end

function t.Round(R,S,T)
if T==0 then
return math.floor(S)
end
S=tostring(S)
return S:find"%."and tonumber(S:sub(1,S:find"%."+T))or S
end


function t.Update(R,S,T)
if S then w,x,y=Color3.toHSV(S)else w,x,y=t.Hue,t.Sat,t.Vib end

t.UIElements.SatVibMap.BackgroundColor3=Color3.fromHSV(w,1,1)
z.Position=UDim2.new(x,0,1-y,0)
B.BackgroundColor3=Color3.fromHSV(w,x,y)
F.BackgroundColor3=Color3.fromHSV(w,1,1)
F.Position=UDim2.new(0.5,0,w,0)

H.Frame.Frame.TextBox.Text="#"..Color3.fromHSV(w,x,y):ToHex()
I.Frame.Frame.TextBox.Text=ToRGB(Color3.fromHSV(w,x,y)).R
J.Frame.Frame.TextBox.Text=ToRGB(Color3.fromHSV(w,x,y)).G
K.Frame.Frame.TextBox.Text=ToRGB(Color3.fromHSV(w,x,y)).B

if T or t.Transparency then
B.BackgroundTransparency=t.Transparency or T
Q.BackgroundColor3=Color3.fromHSV(w,x,y)
P.BackgroundColor3=Color3.fromHSV(w,x,y)
P.BackgroundTransparency=t.Transparency or T
P.Position=UDim2.new(0.5,0,1-t.Transparency or T,0)
L.Frame.Frame.TextBox.Text=t:Round((1-t.Transparency or T)*100,0).."%"
end
end

t:Update(t.Default,t.Transparency)




local function GetRGB()
local R=Color3.fromHSV(t.Hue,t.Sat,t.Vib)
return{R=math.floor(R.r*255),G=math.floor(R.g*255),B=math.floor(R.b*255)}
end



local function clamp(R,S,T)
return math.clamp(tonumber(R)or 0,S,T)
end

b.AddSignal(H.Frame.Frame.TextBox.FocusLost,function(R)
if R then
local S=H.Frame.Frame.TextBox.Text:gsub("#","")
local T,U=pcall(Color3.fromHex,S)
if T and typeof(U)=="Color3"then
t.Hue,t.Sat,t.Vib=Color3.toHSV(U)
t:Update()
t.Default=U
end
end
end)

local function updateColorFromInput(R,S)
b.AddSignal(R.Frame.Frame.TextBox.FocusLost,function(T)
if T then
local U=R.Frame.Frame.TextBox
local V=GetRGB()
local W=clamp(U.Text,0,255)
U.Text=tostring(W)

V[S]=W
local X=Color3.fromRGB(V.R,V.G,V.B)
t.Hue,t.Sat,t.Vib=Color3.toHSV(X)
t:Update()
end
end)
end

updateColorFromInput(I,"R")
updateColorFromInput(J,"G")
updateColorFromInput(K,"B")

if t.Transparency then
b.AddSignal(L.Frame.Frame.TextBox.FocusLost,function(R)
if R then
local S=L.Frame.Frame.TextBox
local T=clamp(S.Text,0,100)
S.Text=tostring(T)

t.Transparency=1-T*0.01
t:Update(nil,t.Transparency)
end
end)
end



local R=t.UIElements.SatVibMap
b.AddSignal(R.InputBegan,function(S)
if S.UserInputType==Enum.UserInputType.MouseButton1 or S.UserInputType==Enum.UserInputType.Touch then
while h:IsMouseButtonPressed(Enum.UserInputType.MouseButton1)do
local T=R.AbsolutePosition.X
local U=T+R.AbsoluteSize.X
local V=math.clamp(m.X,T,U)

local W=R.AbsolutePosition.Y
local X=W+R.AbsoluteSize.Y
local Y=math.clamp(m.Y,W,X)

t.Sat=(V-T)/(U-T)
t.Vib=1-((Y-W)/(X-W))
t:Update()

k:Wait()
end
end
end)

b.AddSignal(G.InputBegan,function(S)
if S.UserInputType==Enum.UserInputType.MouseButton1 or S.UserInputType==Enum.UserInputType.Touch then
while h:IsMouseButtonPressed(Enum.UserInputType.MouseButton1)do
local T=G.AbsolutePosition.Y
local U=T+G.AbsoluteSize.Y
local V=math.clamp(m.Y,T,U)

t.Hue=((V-T)/(U-T))
t:Update()

k:Wait()
end
end
end)

if t.Transparency then
b.AddSignal(O.InputBegan,function(S)
if S.UserInputType==Enum.UserInputType.MouseButton1 or S.UserInputType==Enum.UserInputType.Touch then
while h:IsMouseButtonPressed(Enum.UserInputType.MouseButton1)do
local T=O.AbsolutePosition.Y
local U=T+O.AbsoluteSize.Y
local V=math.clamp(m.Y,T,U)

t.Transparency=1-((V-T)/(U-T))
t:Update()

k:Wait()
end
end
end)
end

return t
end

function p.New(q,r)
local s={
__type="Colorpicker",
Title=r.Title or"Colorpicker",
Desc=r.Desc or nil,
Locked=r.Locked or false,
Default=r.Default or Color3.new(1,1,1),
Callback=r.Callback or function()end,
Window=r.Window,
Transparency=r.Transparency,
UIElements={}
}

local t=true


s.ColorpickerFrame=a.load'n'{
Title=s.Title,
Desc=s.Desc,
Parent=r.Parent,
TextOffset=40,
Hover=false,
}

s.UIElements.Colorpicker=b.NewRoundFrame(p.UICorner,"Squircle",{
ImageTransparency=0,
Active=true,
ImageColor3=s.Default,
Parent=s.ColorpickerFrame.UIElements.Main,
Size=UDim2.new(0,30,0,30),
AnchorPoint=Vector2.new(1,0.5),
Position=UDim2.new(1,0,0.5,0),
ZIndex=2
},nil,true)


function s.Lock(u)
t=false
return s.ColorpickerFrame:Lock()
end
function s.Unlock(u)
t=true
return s.ColorpickerFrame:Unlock()
end

if s.Locked then
s:Lock()
end


function s.Update(u,v,w)
s.UIElements.Colorpicker.ImageTransparency=w or 0
s.UIElements.Colorpicker.ImageColor3=v
s.Default=v
if w then
s.Transparency=w
end
end

function s.Set(u,v,w)
return s:Update(v,w)
end

b.AddSignal(s.UIElements.Colorpicker.MouseButton1Click,function()
if t then
p:Colorpicker(s,function(u,v)
s:Update(u,v)
s.Default=u
s.Transparency=v
b.SafeCallback(s.Callback,u,v)
end).ColorpickerFrame:Open()
end
end)

return s.__type,s
end

return p end function a.A()
local b=a.load'a'
local e=b.New
local g=b.Tween

local h={}

function h.New(i,j)
local k={
__type="Section",
Title=j.Title or"Section",
Icon=j.Icon,
TextXAlignment=j.TextXAlignment or"Left",
TextSize=j.TextSize or 19,
UIElements={},
}

local l
if k.Icon then
l=b.Image(
k.Icon,
k.Icon..":"..k.Title,
0,
j.Window.Folder,
k.__type,
true
)
l.Size=UDim2.new(0,24,0,24)
end

k.UIElements.Main=e("TextLabel",{
BackgroundTransparency=1,
TextXAlignment="Left",
AutomaticSize="XY",
TextSize=k.TextSize,
ThemeTag={
TextColor3="Text",
},
FontFace=Font.new(b.Font,Enum.FontWeight.SemiBold),


Text=k.Title,
})

e("Frame",{
Size=UDim2.new(1,0,0,0),
BackgroundTransparency=1,
AutomaticSize="Y",
Parent=j.Parent,
},{
l,
k.UIElements.Main,
e("UIListLayout",{
Padding=UDim.new(0,8),
FillDirection="Horizontal",
VerticalAlignment="Center",
HorizontalAlignment=k.TextXAlignment,
}),
e("UIPadding",{
PaddingTop=UDim.new(0,4),
PaddingBottom=UDim.new(0,2),
})
})





function k.SetTitle(m,n)
k.UIElements.Main.Text=n
end
function k.Destroy(m)
k.UIElements.Main.AutomaticSize="None"
k.UIElements.Main.Size=UDim2.new(1,0,0,k.UIElements.Main.TextBounds.Y)

g(k.UIElements.Main,.1,{TextTransparency=1}):Play()
task.wait(.1)
g(k.UIElements.Main,.15,{Size=UDim2.new(1,0,0,0)},Enum.EasingStyle.Quint,Enum.EasingDirection.InOut):Play()
end

return k.__type,k
end

return h end function a.B()
game:GetService"UserInputService"
local b=game.Players.LocalPlayer:GetMouse()

local e=a.load'a'
local g=e.New
local h=e.Tween

local i=a.load'c'.New
local j=a.load'm'.New
local k=a.load'j'.New


local l={
Window=nil,
WindUI=nil,
Tabs={},
Containers={},
SelectedTab=nil,
TabCount=0,
ToolTipParent=nil,
TabHighlight=nil,

OnChangeFunc=function(l)end
}

function l.Init(m,n,o,p)
l.Window=m
l.WindUI=n
l.ToolTipParent=o
l.TabHighlight=p
return l
end

function l.New(m)
local n={
__type="Tab",
Title=m.Title or"Tab",
Desc=m.Desc,
Icon=m.Icon,
IconThemed=m.IconThemed,
Locked=m.Locked,
ShowTabTitle=m.ShowTabTitle,
Selected=false,
Index=nil,
Parent=m.Parent,
UIElements={},
Elements={},
ContainerFrame=nil,
UICorner=l.Window.UICorner-(l.Window.UIPadding/2),
}

local o=l.Window
local p=l.WindUI

l.TabCount=l.TabCount+1
local q=l.TabCount
n.Index=q

n.UIElements.Main=e.NewRoundFrame(n.UICorner,"Squircle",{
BackgroundTransparency=1,
Size=UDim2.new(1,-7,0,0),
AutomaticSize="Y",
Parent=m.Parent,
ThemeTag={
ImageColor3="Text",
},
ImageTransparency=1,
},{
e.NewRoundFrame(n.UICorner,"SquircleOutline",{
Size=UDim2.new(1,0,1,0),
ThemeTag={
ImageColor3="Text",
},
ImageTransparency=1,
Name="Outline"
},{
g("UIGradient",{
Rotation=80,
Color=ColorSequence.new{
ColorSequenceKeypoint.new(0.0,Color3.fromRGB(255,255,255)),
ColorSequenceKeypoint.new(0.5,Color3.fromRGB(255,255,255)),
ColorSequenceKeypoint.new(1.0,Color3.fromRGB(255,255,255)),
},
Transparency=NumberSequence.new{
NumberSequenceKeypoint.new(0.0,0.1),
NumberSequenceKeypoint.new(0.5,1),
NumberSequenceKeypoint.new(1.0,0.1),
}
}),
}),
e.NewRoundFrame(n.UICorner,"Squircle",{
Size=UDim2.new(1,0,0,0),
AutomaticSize="Y",
ThemeTag={
ImageColor3="Text",
},
ImageTransparency=1,
Name="Frame",
},{
g("UIListLayout",{
SortOrder="LayoutOrder",
Padding=UDim.new(0,10),
FillDirection="Horizontal",
VerticalAlignment="Center",
}),
g("TextLabel",{
Text=n.Title,
ThemeTag={
TextColor3="Text"
},
TextTransparency=not n.Locked and 0.4 or.7,
TextSize=15,
Size=UDim2.new(1,0,0,0),
FontFace=Font.new(e.Font,Enum.FontWeight.Medium),
TextWrapped=true,
RichText=true,
AutomaticSize="Y",
LayoutOrder=2,
TextXAlignment="Left",
BackgroundTransparency=1,
}),
g("UIPadding",{
PaddingTop=UDim.new(0,2+(o.UIPadding/2)),
PaddingLeft=UDim.new(0,4+(o.UIPadding/2)),
PaddingRight=UDim.new(0,4+(o.UIPadding/2)),
PaddingBottom=UDim.new(0,2+(o.UIPadding/2)),
})
}),
},true)

local r=0
local s
local t

if n.Icon then
s=e.Image(
n.Icon,
n.Icon..":"..n.Title,
0,
l.Window.Folder,
n.__type,
true,
n.IconThemed
)
s.Size=UDim2.new(0,16,0,16)
s.Parent=n.UIElements.Main.Frame
s.ImageLabel.ImageTransparency=not n.Locked and 0 or.7
n.UIElements.Main.Frame.TextLabel.Size=UDim2.new(1,-30,0,0)
r=-30

n.UIElements.Icon=s


t=e.Image(
n.Icon,
n.Icon..":"..n.Title,
0,
l.Window.Folder,
n.__type,
true,
n.IconThemed
)
t.Size=UDim2.new(0,16,0,16)
t.ImageLabel.ImageTransparency=not n.Locked and 0 or.7
r=-30




end

n.UIElements.ContainerFrame=g("ScrollingFrame",{
Size=UDim2.new(1,0,1,n.ShowTabTitle and-((o.UIPadding*2.4)+12)or 0),
BackgroundTransparency=1,
ScrollBarThickness=0,
ElasticBehavior="Never",
CanvasSize=UDim2.new(0,0,0,0),
AnchorPoint=Vector2.new(0,1),
Position=UDim2.new(0,0,1,0),
AutomaticCanvasSize="Y",

ScrollingDirection="Y",
},{
g("UIPadding",{
PaddingTop=UDim.new(0,20),
PaddingLeft=UDim.new(0,20),
PaddingRight=UDim.new(0,20),
PaddingBottom=UDim.new(0,20),
}),
g("UIListLayout",{
SortOrder="LayoutOrder",
Padding=UDim.new(0,6),
HorizontalAlignment="Center",
})
})





n.UIElements.ContainerFrameCanvas=g("Frame",{
Size=UDim2.new(1,0,1,0),
BackgroundTransparency=1,
Visible=false,
Parent=o.UIElements.MainBar,
ZIndex=5,
},{
n.UIElements.ContainerFrame,
g("Frame",{
Size=UDim2.new(1,0,0,((o.UIPadding*2.4)+12)),
BackgroundTransparency=1,
Visible=n.ShowTabTitle or false,
Name="TabTitle"
},{
t,
g("TextLabel",{
Text=n.Title,
ThemeTag={
TextColor3="Text"
},
TextSize=20,
TextTransparency=.1,
Size=UDim2.new(1,-r,1,0),
FontFace=Font.new(e.Font,Enum.FontWeight.SemiBold),
TextTruncate="AtEnd",
RichText=true,
LayoutOrder=2,
TextXAlignment="Left",
BackgroundTransparency=1,
}),
g("UIPadding",{
PaddingTop=UDim.new(0,20),
PaddingLeft=UDim.new(0,20),
PaddingRight=UDim.new(0,20),
PaddingBottom=UDim.new(0,20),
}),
g("UIListLayout",{
SortOrder="LayoutOrder",
Padding=UDim.new(0,10),
FillDirection="Horizontal",
VerticalAlignment="Center",
})
}),
g("Frame",{
Size=UDim2.new(1,0,0,1),
BackgroundTransparency=.9,
ThemeTag={
BackgroundColor3="Text"
},
Position=UDim2.new(0,0,0,((o.UIPadding*2.4)+12)),
Visible=n.ShowTabTitle or false,
})
})

l.Containers[q]=n.UIElements.ContainerFrameCanvas
l.Tabs[q]=n

n.ContainerFrame=ContainerFrameCanvas

e.AddSignal(n.UIElements.Main.MouseButton1Click,function()
if not n.Locked then
l:SelectTab(q)
end
end)

k(n.UIElements.ContainerFrame,n.UIElements.ContainerFrameCanvas,o,3)

local u
local v
local w
local x=false



if n.Desc then


e.AddSignal(n.UIElements.Main.InputBegan,function()
x=true
v=task.spawn(function()
task.wait(0.35)
if x and not u then
u=j(n.Desc,l.ToolTipParent)

local function updatePosition()
if u then
u.Container.Position=UDim2.new(0,b.X,0,b.Y-20)
end
end

updatePosition()
w=b.Move:Connect(updatePosition)
u:Open()
end
end)
end)

end

e.AddSignal(n.UIElements.Main.MouseEnter,function()
if not n.Locked then
h(n.UIElements.Main.Frame,0.08,{ImageTransparency=.97}):Play()
end
end)
e.AddSignal(n.UIElements.Main.InputEnded,function()
if n.Desc then
x=false
if v then
task.cancel(v)
v=nil
end
if w then
w:Disconnect()
w=nil
end
if u then
u:Close()
u=nil
end
end

if not n.Locked then
h(n.UIElements.Main.Frame,0.08,{ImageTransparency=1}):Play()
end
end)



local y={
Button=a.load'o',
Toggle=a.load'r',
Slider=a.load's',
Keybind=a.load't',
Input=a.load'u',
Dropdown=a.load'v',
Code=a.load'y',
Colorpicker=a.load'z',
Section=a.load'A',
}

function n.Divider(z)
local A=g("Frame",{
Size=UDim2.new(1,0,0,1),
Position=UDim2.new(0.5,0,0.5,0),
AnchorPoint=Vector2.new(0.5,0.5),
BackgroundTransparency=.9,
ThemeTag={
BackgroundColor3="Text"
}
})
local B=g("Frame",{
Parent=n.UIElements.ContainerFrame,
Size=UDim2.new(1,-7,0,5),
BackgroundTransparency=1,
},{
A
})

return B
end

function n.Paragraph(z,A)
A.Parent=n.UIElements.ContainerFrame
A.Window=o
A.Hover=false

A.TextOffset=0
A.IsButtons=A.Buttons and#A.Buttons>0 and true or false

local B={
__type="Paragraph",
Title=A.Title or"Paragraph",
Desc=A.Desc or nil,

Locked=A.Locked or false,
}
local C=a.load'n'(A)

B.ParagraphFrame=C
if A.Buttons and#A.Buttons>0 then
local D=g("Frame",{
Size=UDim2.new(1,0,0,38),
BackgroundTransparency=1,
AutomaticSize="Y",
Parent=C.UIElements.Container
},{
g("UIListLayout",{
Padding=UDim.new(0,10),
FillDirection="Vertical",
})
})


for E,F in next,A.Buttons do
local G=i(F.Title,F.Icon,F.Callback,"White",D)
G.Size=UDim2.new(1,0,0,38)

end
end

function B.SetTitle(D,E)
B.ParagraphFrame:SetTitle(E)
end
function B.SetDesc(D,E)
B.ParagraphFrame:SetDesc(E)
end
function B.Destroy(D)
B.ParagraphFrame:Destroy()
end

table.insert(n.Elements,B)
return B
end

for z,A in pairs(y)do
n[z]=function(B,C)
C.Parent=B.UIElements.ContainerFrame
C.Window=o
C.WindUI=p local

D, E=A:New(C)
table.insert(B.Elements,E)

local F
for G,H in pairs(E)do
if typeof(H)=="table"and G:match"Frame$"then
F=H
break
end
end

if F then
function E.SetTitle(G,H)
F:SetTitle(H)
end
function E.SetDesc(G,H)
F:SetDesc(H)
end
function E.Destroy(G)
F:Destroy()
end
end
return E
end
end


task.spawn(function()
local z=g("Frame",{
BackgroundTransparency=1,
Size=UDim2.new(1,0,1,-o.UIElements.Main.Main.Topbar.AbsoluteSize.Y),
Parent=n.UIElements.ContainerFrame
},{
g("UIListLayout",{
Padding=UDim.new(0,8),
SortOrder="LayoutOrder",
VerticalAlignment="Center",
HorizontalAlignment="Center",
FillDirection="Vertical",
}),
g("ImageLabel",{
Size=UDim2.new(0,48,0,48),
Image=e.Icon"frown"[1],
ImageRectOffset=e.Icon"frown"[2].ImageRectPosition,
ImageRectSize=e.Icon"frown"[2].ImageRectSize,
ThemeTag={
ImageColor3="Icon"
},
BackgroundTransparency=1,
ImageTransparency=.6,
}),
g("TextLabel",{
AutomaticSize="XY",
Text="This tab is empty",
ThemeTag={
TextColor3="Text"
},
TextSize=18,
TextTransparency=.5,
BackgroundTransparency=1,
FontFace=Font.new(e.Font,Enum.FontWeight.Medium),
})
})





e.AddSignal(n.UIElements.ContainerFrame.ChildAdded,function()
z.Visible=false
end)
end)

return n
end

function l.OnChange(m,n)
l.OnChangeFunc=n
end

function l.SelectTab(m,n)
if not l.Tabs[n].Locked then
l.SelectedTab=n

for o,p in next,l.Tabs do
if not p.Locked then
h(p.UIElements.Main,0.15,{ImageTransparency=1}):Play()
h(p.UIElements.Main.Outline,0.15,{ImageTransparency=1}):Play()
h(p.UIElements.Main.Frame.TextLabel,0.15,{TextTransparency=0.3}):Play()
if p.UIElements.Icon then
h(p.UIElements.Icon.ImageLabel,0.15,{ImageTransparency=0.4}):Play()
end
p.Selected=false
end
end
h(l.Tabs[n].UIElements.Main,0.15,{ImageTransparency=0.95}):Play()
h(l.Tabs[n].UIElements.Main.Outline,0.15,{ImageTransparency=0.85}):Play()
h(l.Tabs[n].UIElements.Main.Frame.TextLabel,0.15,{TextTransparency=0}):Play()
if l.Tabs[n].UIElements.Icon then
h(l.Tabs[n].UIElements.Icon.ImageLabel,0.15,{ImageTransparency=0.1}):Play()
end
l.Tabs[n].Selected=true


task.spawn(function()
for o,p in next,l.Containers do
p.AnchorPoint=Vector2.new(0,0.05)
p.Visible=false
end
l.Containers[n].Visible=true
h(l.Containers[n],0.15,{AnchorPoint=Vector2.new(0,0)},Enum.EasingStyle.Quart,Enum.EasingDirection.Out):Play()
end)

l.OnChangeFunc(n)
end
end

return l end function a.C()
local b={}


local e=a.load'a'
local g=e.New
local h=e.Tween

local i=a.load'B'

function b.New(j,k,l,m)
local n={
Title=j.Title or"Section",
Icon=j.Icon,
IconThemed=j.IconThemed,
Opened=j.Opened or false,

HeaderSize=42,
IconSize=18,

Expandable=false,
}

local o
if n.Icon then
o=e.Image(
n.Icon,
n.Icon,
0,
l,
"Section",
true,
n.IconThemed
)

o.Size=UDim2.new(0,n.IconSize,0,n.IconSize)
o.ImageLabel.ImageTransparency=.25
end

local p=g("Frame",{
Size=UDim2.new(0,n.IconSize,0,n.IconSize),
BackgroundTransparency=1,
Visible=false
},{
g("ImageLabel",{
Size=UDim2.new(1,0,1,0),
BackgroundTransparency=1,
Image=e.Icon"chevron-down"[1],
ImageRectSize=e.Icon"chevron-down"[2].ImageRectSize,
ImageRectOffset=e.Icon"chevron-down"[2].ImageRectPosition,
ThemeTag={
ImageColor3="Icon",
},
ImageTransparency=.7,
})
})

local q=g("Frame",{
Size=UDim2.new(1,0,0,n.HeaderSize),
BackgroundTransparency=1,
Parent=k,
ClipsDescendants=true,
},{
g("TextButton",{
Size=UDim2.new(1,0,0,n.HeaderSize),
BackgroundTransparency=1,
Text="",
},{
o,
g("TextLabel",{
Text=n.Title,
TextXAlignment="Left",
Size=UDim2.new(
1,
o and(-n.IconSize-10)*2
or(-n.IconSize-10),

1,
0
),
ThemeTag={
TextColor3="Text",
},
FontFace=Font.new(e.Font,Enum.FontWeight.SemiBold),
TextSize=14,
BackgroundTransparency=1,
TextTransparency=.7,

TextWrapped=true
}),
g("UIListLayout",{
FillDirection="Horizontal",
VerticalAlignment="Center",
Padding=UDim.new(0,10)
}),
p,
g("UIPadding",{
PaddingLeft=UDim.new(0,11),
PaddingRight=UDim.new(0,11),
})
}),
g("Frame",{
BackgroundTransparency=1,
Size=UDim2.new(1,0,0,0),
AutomaticSize="Y",
Name="Content",
Visible=true,
Position=UDim2.new(0,0,0,n.HeaderSize)
},{
g("UIListLayout",{
FillDirection="Vertical",
Padding=UDim.new(0,0),
VerticalAlignment="Bottom",
}),
})
})


function n.Tab(r,s)
if not n.Expandable then
n.Expandable=true
p.Visible=true
end
s.Parent=q.Content
return i.New(s)
end

function n.Open(r)
if n.Expandable then
n.Opened=true
h(q,0.33,{
Size=UDim2.new(1,0,0,n.HeaderSize+(q.Content.AbsoluteSize.Y/m))
},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()

h(p.ImageLabel,0.1,{Rotation=180},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
end
end
function n.Close(r)
if n.Expandable then
n.Opened=false
h(q,0.26,{
Size=UDim2.new(1,0,0,n.HeaderSize)
},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
h(p.ImageLabel,0.1,{Rotation=0},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
end
end

e.AddSignal(q.TextButton.MouseButton1Click,function()
if n.Expandable then
if n.Opened then
n:Close()
else
n:Open()
end
end
end)

if n.Opened then
task.spawn(function()
task.wait()
n:Open()
end)
end



return n
end


return b end function a.D()
return{
Tab="table-of-contents",
Paragraph="type",
Button="square-mouse-pointer",
Toggle="toggle-right",
Slider="sliders-horizontal",
Keybind="command",
Input="text-cursor-input",
Dropdown="chevrons-up-down",
Code="terminal",
Colorpicker="palette",
}end function a.E()
game:GetService"UserInputService"

local b={
Margin=8,
Padding=9,
}


local e=a.load'a'
local g=e.New
local h=e.Tween


function b.new(i,j,k)
local l={
IconSize=14,
Padding=14,
Radius=18,
Width=400,
MaxHeight=380,

Icons=a.load'D'
}


local m=g("TextBox",{
Text="",
PlaceholderText="Search...",
ThemeTag={
PlaceholderColor3="Placeholder",
TextColor3="Text",
},
Size=UDim2.new(
1,
-((l.IconSize*2)+(l.Padding*2)),
0,
0
),
AutomaticSize="Y",
ClipsDescendants=true,
ClearTextOnFocus=false,
BackgroundTransparency=1,
TextXAlignment="Left",
FontFace=Font.new(e.Font,Enum.FontWeight.Regular),
TextSize=17,
})

local n=g("ImageLabel",{
Image=e.Icon"x"[1],
ImageRectSize=e.Icon"x"[2].ImageRectSize,
ImageRectOffset=e.Icon"x"[2].ImageRectPosition,
BackgroundTransparency=1,
ThemeTag={
ImageColor3="Text",
},
ImageTransparency=.2,
Size=UDim2.new(0,l.IconSize,0,l.IconSize)
},{
g("TextButton",{
Size=UDim2.new(1,8,1,8),
BackgroundTransparency=1,
Active=true,
ZIndex=999999999,
AnchorPoint=Vector2.new(0.5,0.5),
Position=UDim2.new(0.5,0,0.5,0),
Text="",
})
})

local o=g("ScrollingFrame",{
Size=UDim2.new(1,0,0,0),
AutomaticCanvasSize="Y",
ScrollingDirection="Y",
ElasticBehavior="Never",
ScrollBarThickness=0,
CanvasSize=UDim2.new(0,0,0,0),
BackgroundTransparency=1,
Visible=false
},{
g("UIListLayout",{
Padding=UDim.new(0,0),
FillDirection="Vertical",
}),
g("UIPadding",{
PaddingTop=UDim.new(0,l.Padding),
PaddingLeft=UDim.new(0,l.Padding),
PaddingRight=UDim.new(0,l.Padding),
PaddingBottom=UDim.new(0,l.Padding),
})
})

local p=e.NewRoundFrame(l.Radius,"Squircle",{
Size=UDim2.new(1,0,1,0),
ThemeTag={
ImageColor3="Accent",
},
ImageTransparency=0,
},{
g("Frame",{
Size=UDim2.new(1,0,1,0),
BackgroundTransparency=1,

Visible=false,
},{
g("Frame",{
Size=UDim2.new(1,0,0,46),
BackgroundTransparency=1,
},{








g("Frame",{
Size=UDim2.new(1,0,1,0),
BackgroundTransparency=1,
},{
g("ImageLabel",{
Image=e.Icon"search"[1],
ImageRectSize=e.Icon"search"[2].ImageRectSize,
ImageRectOffset=e.Icon"search"[2].ImageRectPosition,
BackgroundTransparency=1,
ThemeTag={
ImageColor3="Icon",
},
ImageTransparency=.05,
Size=UDim2.new(0,l.IconSize,0,l.IconSize)
}),
m,
n,
g("UIListLayout",{
Padding=UDim.new(0,l.Padding),
FillDirection="Horizontal",
VerticalAlignment="Center",
}),
g("UIPadding",{
PaddingLeft=UDim.new(0,l.Padding),
PaddingRight=UDim.new(0,l.Padding),
})
})
}),
g("Frame",{
BackgroundTransparency=1,
AutomaticSize="Y",
Size=UDim2.new(1,0,0,0),
Name="Results",
},{
g("Frame",{
Size=UDim2.new(1,0,0,1),
ThemeTag={
BackgroundColor3="Outline",
},
BackgroundTransparency=.9,
Visible=false,
}),
o,
g("UISizeConstraint",{
MaxSize=Vector2.new(l.Width,l.MaxHeight),
}),
}),
g("UIListLayout",{
Padding=UDim.new(0,0),
FillDirection="Vertical",
}),
})
})

local q=g("Frame",{
Size=UDim2.new(0,l.Width,0,0),
AutomaticSize="Y",
Parent=j,
BackgroundTransparency=1,
Position=UDim2.new(0.5,0,0.5,0),
AnchorPoint=Vector2.new(0.5,0.5),
Visible=false,

ZIndex=99999999,
},{
g("UIScale",{
Scale=.9,
}),
p,
e.NewRoundFrame(l.Radius,"SquircleOutline2",{
Size=UDim2.new(1,0,1,0),
ThemeTag={
ImageColor3="Outline",
},
ImageTransparency=.7,
},{
g("UIGradient",{
Rotation=45,
Transparency=NumberSequence.new{
NumberSequenceKeypoint.new(0,0.55),
NumberSequenceKeypoint.new(0.5,0.8),
NumberSequenceKeypoint.new(1,0.6)
}
})
})
})

local function CreateSearchTab(r,s,t,u,v,w)
local x=g("TextButton",{
Size=UDim2.new(1,0,0,0),
AutomaticSize="Y",
BackgroundTransparency=1,
Parent=u or nil
},{
e.NewRoundFrame(l.Radius-4,"Squircle",{
Size=UDim2.new(1,0,0,0),
Position=UDim2.new(0.5,0,0.5,0),
AnchorPoint=Vector2.new(0.5,0.5),

ThemeTag={
ImageColor3="Text",
},
ImageTransparency=1,
Name="Main"
},{
g("UIPadding",{
PaddingTop=UDim.new(0,l.Padding-2),
PaddingLeft=UDim.new(0,l.Padding),
PaddingRight=UDim.new(0,l.Padding),
PaddingBottom=UDim.new(0,l.Padding-2),
}),
g("ImageLabel",{
Image=e.Icon(t)[1],
ImageRectSize=e.Icon(t)[2].ImageRectSize,
ImageRectOffset=e.Icon(t)[2].ImageRectPosition,
BackgroundTransparency=1,
ThemeTag={
ImageColor3="Text",
},
ImageTransparency=.2,
Size=UDim2.new(0,l.IconSize,0,l.IconSize)
}),
g("Frame",{
Size=UDim2.new(1,-l.IconSize-l.Padding,0,0),
BackgroundTransparency=1,
},{
g("TextLabel",{
Text=r,
ThemeTag={
TextColor3="Text",
},
TextSize=17,
BackgroundTransparency=1,
TextXAlignment="Left",
FontFace=Font.new(e.Font,Enum.FontWeight.Medium),
Size=UDim2.new(1,0,0,0),
TextTruncate="AtEnd",
AutomaticSize="Y",
Name="Title"
}),
g("TextLabel",{
Text=s or"",
Visible=s and true or false,
ThemeTag={
TextColor3="Text",
},
TextSize=15,
TextTransparency=.2,
BackgroundTransparency=1,
TextXAlignment="Left",
FontFace=Font.new(e.Font,Enum.FontWeight.Medium),
Size=UDim2.new(1,0,0,0),
TextTruncate="AtEnd",
AutomaticSize="Y",
Name="Desc"
})or nil,
g("UIListLayout",{
Padding=UDim.new(0,6),
FillDirection="Vertical",
})
}),
g("UIListLayout",{
Padding=UDim.new(0,l.Padding),
FillDirection="Horizontal",
})
},true),
g("Frame",{
Name="ParentContainer",
Size=UDim2.new(1,-l.Padding,0,0),
AutomaticSize="Y",
BackgroundTransparency=1,
Visible=v,

},{
e.NewRoundFrame(99,"Squircle",{
Size=UDim2.new(0,2,1,0),
BackgroundTransparency=1,
ThemeTag={
ImageColor3="Text"
},
ImageTransparency=.9,
}),
g("Frame",{
Size=UDim2.new(1,-l.Padding-2,0,0),
Position=UDim2.new(0,l.Padding+2,0,0),
BackgroundTransparency=1,
},{
g("UIListLayout",{
Padding=UDim.new(0,0),
FillDirection="Vertical",
}),
}),
}),
g("UIListLayout",{
Padding=UDim.new(0,0),
FillDirection="Vertical",
HorizontalAlignment="Right"
})
})



x.Main.Size=UDim2.new(
1,
0,
0,
x.Main.Frame.Desc.Visible and(((l.Padding-2)*2)+x.Main.Frame.Title.TextBounds.Y+6+x.Main.Frame.Desc.TextBounds.Y)
or(((l.Padding-2)*2)+x.Main.Frame.Title.TextBounds.Y)
)

e.AddSignal(x.Main.MouseEnter,function()
h(x.Main,.04,{ImageTransparency=.95}):Play()
end)
e.AddSignal(x.Main.InputEnded,function()
h(x.Main,.08,{ImageTransparency=1}):Play()
end)
e.AddSignal(x.Main.MouseButton1Click,function()
if w then
w()
end
end)

return x
end

local function ContainsText(r,s)
if not s or s==""then
return false
end

if not r or r==""then
return false
end

local t=string.lower(r)
local u=string.lower(s)

return string.find(t,u,1,true)~=nil
end

local function Search(r)
if not r or r==""then
return{}
end

local s={}
for t,u in next,i.Tabs do
local v=ContainsText(u.Title or"",r)
local w={}

for x,y in next,u.Elements do
if y.__type~="Section"then
local z=ContainsText(y.Title or"",r)
local A=ContainsText(y.Desc or"",r)

if z or A then
w[x]={
Title=y.Title,
Desc=y.Desc,
Original=y,
__type=y.__type
}
end
end
end

if v or next(w)~=nil then
s[t]={
Tab=u,
Title=u.Title,
Icon=u.Icon,
Elements=w,
}
end
end
return s
end

function l.Search(r,s)
s=s or""

local t=Search(s)

o.Visible=true
p.Frame.Results.Frame.Visible=true
for u,v in next,o:GetChildren()do
if v.ClassName~="UIListLayout"and v.ClassName~="UIPadding"then
v:Destroy()
end
end

if t and next(t)~=nil then
for u,v in next,t do
local w=l.Icons.Tab
local x=CreateSearchTab(v.Title,nil,w,o,true,function()
l:Close()
i:SelectTab(u)
end)
if v.Elements and next(v.Elements)~=nil then
for y,z in next,v.Elements do
local A=l.Icons[z.__type]
CreateSearchTab(z.Title,z.Desc,A,x:FindFirstChild"ParentContainer"and x.ParentContainer.Frame or nil,false,function()
l:Close()
i:SelectTab(u)

end)

end
end
end
elseif s~=""then
g("TextLabel",{
Size=UDim2.new(1,0,0,70),
BackgroundTransparency=1,
Text="No results found",
TextSize=16,
ThemeTag={
TextColor3="Text",
},
TextTransparency=.2,
BackgroundTransparency=1,
FontFace=Font.new(e.Font,Enum.FontWeight.Medium),
Parent=o,
Name="NotFound",
})
else
o.Visible=false
p.Frame.Results.Frame.Visible=false
end
end

e.AddSignal(m:GetPropertyChangedSignal"Text",function()
l:Search(m.Text)
end)

e.AddSignal(o.UIListLayout:GetPropertyChangedSignal"AbsoluteContentSize",function()

h(o,.06,{Size=UDim2.new(
1,
0,
0,
math.clamp(o.UIListLayout.AbsoluteContentSize.Y+(l.Padding*2),0,l.MaxHeight)
)},Enum.EasingStyle.Quint,Enum.EasingDirection.InOut):Play()






end)

function l.Open(r)
task.spawn(function()
p.Frame.Visible=true
q.Visible=true
h(q.UIScale,.12,{Scale=1},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
end)
end

function l.Close(r)
task.spawn(function()
k()
p.Frame.Visible=false
h(q.UIScale,.12,{Scale=1},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()

task.wait(.12)
q.Visible=false
end)
end

e.AddSignal(n.TextButton.MouseButton1Click,function()
l:Close()
end)

l:Open()

return l
end

return b end function a.F()

local b=game:GetService"UserInputService"
game:GetService"RunService"

local e=workspace.CurrentCamera

local g=a.load'a'
local h=g.New
local i=g.Tween


local j=a.load'i'.New
local k=a.load'c'.New
local l=a.load'j'.New

local m=a.load'k'

local n=false

return function(o)
local p={
Title=o.Title or"UI Library",
Author=o.Author,
Icon=o.Icon,
IconThemed=o.IconThemed,
Folder=o.Folder,
Resizable=o.Resizable,
Background=o.Background,
BackgroundImageTransparency=o.BackgroundImageTransparency or 0,
User=o.User or{},
Size=o.Size and UDim2.new(
0,math.clamp(o.Size.X.Offset,480,700),
0,math.clamp(o.Size.Y.Offset,350,520))or UDim2.new(0,580,0,460),
ToggleKey=o.ToggleKey or Enum.KeyCode.G,
Transparent=o.Transparent or false,
HideSearchBar=o.HideSearchBar,
ScrollBarEnabled=o.ScrollBarEnabled or false,
SideBarWidth=o.SideBarWidth or 200,

Position=UDim2.new(0.5,0,0.5,0),
UICorner=16,
UIPadding=14,
UIElements={},
CanDropdown=true,
Closed=false,
Parent=o.Parent,
Destroyed=false,
IsFullscreen=false,
CanResize=false,
IsOpenButtonEnabled=true,

ConfigManager=nil,
CurrentTab=nil,
TabModule=nil,

OnCloseCallback=nil,
OnDestroyCallback=nil,

TopBarButtons={},

}

if p.HideSearchBar~=false then
p.HideSearchBar=true
end
if p.Resizable~=false then
p.CanResize=true
p.Resizable=true
end

if p.Folder then
makefolder("WindUI/"..p.Folder)
end

local q=h("UICorner",{
CornerRadius=UDim.new(0,p.UICorner)
})

p.ConfigManager=m:Init(p)



local r=h("Frame",{
Size=UDim2.new(0,32,0,32),
Position=UDim2.new(1,0,1,0),
AnchorPoint=Vector2.new(.5,.5),
BackgroundTransparency=1,
ZIndex=99,
Active=true
},{
h("ImageLabel",{
Size=UDim2.new(0,96,0,96),
BackgroundTransparency=1,
Image="rbxassetid://120997033468887",
Position=UDim2.new(0.5,-16,0.5,-16),
AnchorPoint=Vector2.new(0.5,0.5),
ImageTransparency=1,
})
})
local s=g.NewRoundFrame(p.UICorner,"Squircle",{
Size=UDim2.new(1,0,1,0),
ImageTransparency=1,
ImageColor3=Color3.new(0,0,0),
ZIndex=98,
Active=false,
},{
h("ImageLabel",{
Size=UDim2.new(0,70,0,70),
Image=g.Icon"expand"[1],
ImageRectOffset=g.Icon"expand"[2].ImageRectPosition,
ImageRectSize=g.Icon"expand"[2].ImageRectSize,
BackgroundTransparency=1,
Position=UDim2.new(0.5,0,0.5,0),
AnchorPoint=Vector2.new(0.5,0.5),
ImageTransparency=1,
}),
})

local t=g.NewRoundFrame(p.UICorner,"Squircle",{
Size=UDim2.new(1,0,1,0),
ImageTransparency=1,
ImageColor3=Color3.new(0,0,0),
ZIndex=999,
Active=false,
})










p.UIElements.SideBar=h("ScrollingFrame",{
Size=UDim2.new(
1,
p.ScrollBarEnabled and-3-(p.UIPadding/2)or 0,
1,
not p.HideSearchBar and-45 or 0
),
Position=UDim2.new(0,0,1,0),
AnchorPoint=Vector2.new(0,1),
BackgroundTransparency=1,
ScrollBarThickness=0,
ElasticBehavior="Never",
CanvasSize=UDim2.new(0,0,0,0),
AutomaticCanvasSize="Y",
ScrollingDirection="Y",
ClipsDescendants=true,
VerticalScrollBarPosition="Left",
},{
h("Frame",{
BackgroundTransparency=1,
AutomaticSize="Y",
Size=UDim2.new(1,0,0,0),
Name="Frame",
},{
h("UIPadding",{
PaddingTop=UDim.new(0,p.UIPadding/2),


PaddingBottom=UDim.new(0,p.UIPadding/2),
}),
h("UIListLayout",{
SortOrder="LayoutOrder",
Padding=UDim.new(0,0)
})
}),
h("UIPadding",{

PaddingLeft=UDim.new(0,p.UIPadding/2),
PaddingRight=UDim.new(0,p.UIPadding/2),

}),

})

p.UIElements.SideBarContainer=h("Frame",{
Size=UDim2.new(0,p.SideBarWidth,1,p.User.Enabled and-94-(p.UIPadding*2)or-52),
Position=UDim2.new(0,0,0,52),
BackgroundTransparency=1,
Visible=true,
},{
h("Frame",{
Name="Content",
BackgroundTransparency=1,
Size=UDim2.new(
1,
0,
1,
not p.HideSearchBar and-45-p.UIPadding/2 or 0
),
Position=UDim2.new(0,0,1,0),
AnchorPoint=Vector2.new(0,1),
}),
p.UIElements.SideBar,
})

if p.ScrollBarEnabled then
l(p.UIElements.SideBar,p.UIElements.SideBarContainer.Content,p,3)
end


p.UIElements.MainBar=h("Frame",{
Size=UDim2.new(1,-p.UIElements.SideBarContainer.AbsoluteSize.X,1,-52),
Position=UDim2.new(1,0,1,0),
AnchorPoint=Vector2.new(1,1),
BackgroundTransparency=1,
},{
g.NewRoundFrame(p.UICorner-(p.UIPadding/2),"Squircle",{
Size=UDim2.new(1,0,1,0),
ImageColor3=Color3.new(1,1,1),
ZIndex=3,
ImageTransparency=.95,
Name="Background",
}),
h("UIPadding",{
PaddingTop=UDim.new(0,p.UIPadding/2),
PaddingLeft=UDim.new(0,p.UIPadding/2),
PaddingRight=UDim.new(0,p.UIPadding/2),
PaddingBottom=UDim.new(0,p.UIPadding/2),
})
})

local u=h("ImageLabel",{
Image="rbxassetid://8992230677",
ImageColor3=Color3.new(0,0,0),
ImageTransparency=1,
Size=UDim2.new(1,120,1,116),
Position=UDim2.new(0,-60,0,-58),
ScaleType="Slice",
SliceCenter=Rect.new(99,99,99,99),
BackgroundTransparency=1,
ZIndex=-999999999999999,
Name="Blur",
})

local v

if b.TouchEnabled and not b.KeyboardEnabled then
v=false
elseif b.KeyboardEnabled then
v=true
else
v=nil
end









local w
if p.User.Enabled then local
x, y=game.Players:GetUserThumbnailAsync(
p.User.Anonymous and 1 or game.Players.LocalPlayer.UserId,
Enum.ThumbnailType.HeadShot,
Enum.ThumbnailSize.Size420x420
)

w=h("TextButton",{
Size=UDim2.new(0,
(p.UIElements.SideBarContainer.AbsoluteSize.X)-(p.UIPadding/2),
0,
42+(p.UIPadding)
),
Position=UDim2.new(0,p.UIPadding/2,1,-(p.UIPadding/2)),
AnchorPoint=Vector2.new(0,1),
BackgroundTransparency=1,
},{
g.NewRoundFrame(p.UICorner-(p.UIPadding/2),"SquircleOutline",{
Size=UDim2.new(1,0,1,0),
ThemeTag={
ImageColor3="Text",
},
ImageTransparency=1,
Name="Outline"
},{
h("UIGradient",{
Rotation=78,
Color=ColorSequence.new{
ColorSequenceKeypoint.new(0.0,Color3.fromRGB(255,255,255)),
ColorSequenceKeypoint.new(0.5,Color3.fromRGB(255,255,255)),
ColorSequenceKeypoint.new(1.0,Color3.fromRGB(255,255,255)),
},
Transparency=NumberSequence.new{
NumberSequenceKeypoint.new(0.0,0.1),
NumberSequenceKeypoint.new(0.5,1),
NumberSequenceKeypoint.new(1.0,0.1),
}
}),
}),
g.NewRoundFrame(p.UICorner-(p.UIPadding/2),"Squircle",{
Size=UDim2.new(1,0,1,0),
ThemeTag={
ImageColor3="Text",
},
ImageTransparency=1,
Name="UserIcon",
},{
h("ImageLabel",{
Image=x,
BackgroundTransparency=1,
Size=UDim2.new(0,42,0,42),
ThemeTag={
BackgroundColor3="Text",
},
BackgroundTransparency=.93,
},{
h("UICorner",{
CornerRadius=UDim.new(1,0)
})
}),
h("Frame",{
AutomaticSize="XY",
BackgroundTransparency=1,
},{
h("TextLabel",{
Text=p.User.Anonymous and"Anonymous"or game.Players.LocalPlayer.DisplayName,
TextSize=17,
ThemeTag={
TextColor3="Text",
},
FontFace=Font.new(g.Font,Enum.FontWeight.SemiBold),
AutomaticSize="Y",
BackgroundTransparency=1,
Size=UDim2.new(1,-27,0,0),
TextTruncate="AtEnd",
TextXAlignment="Left",
}),
h("TextLabel",{
Text=p.User.Anonymous and"@anonymous"or"@"..game.Players.LocalPlayer.Name,
TextSize=15,
TextTransparency=.6,
ThemeTag={
TextColor3="Text",
},
FontFace=Font.new(g.Font,Enum.FontWeight.Medium),
AutomaticSize="Y",
BackgroundTransparency=1,
Size=UDim2.new(1,-27,0,0),
TextTruncate="AtEnd",
TextXAlignment="Left",
}),
h("UIListLayout",{
Padding=UDim.new(0,4),
HorizontalAlignment="Left",
})
}),
h("UIListLayout",{
Padding=UDim.new(0,p.UIPadding),
FillDirection="Horizontal",
VerticalAlignment="Center",
}),
h("UIPadding",{
PaddingLeft=UDim.new(0,p.UIPadding/2),
PaddingRight=UDim.new(0,p.UIPadding/2),
})
})
})

if p.User.Callback then
g.AddSignal(w.MouseButton1Click,function()
p.User.Callback()
end)
g.AddSignal(w.MouseEnter,function()
i(w.UserIcon,0.04,{ImageTransparency=.95}):Play()
i(w.Outline,0.04,{ImageTransparency=.85}):Play()
end)
g.AddSignal(w.InputEnded,function()
i(w.UserIcon,0.04,{ImageTransparency=1}):Play()
i(w.Outline,0.04,{ImageTransparency=1}):Play()
end)
end
end

local x
local y


local z=g.NewRoundFrame(99,"Squircle",{
ImageTransparency=.8,
ImageColor3=Color3.new(1,1,1),
Size=UDim2.new(0,0,0,4),
Position=UDim2.new(0.5,0,1,4),
AnchorPoint=Vector2.new(0.5,0),
},{
h("Frame",{
Size=UDim2.new(1,12,1,12),
BackgroundTransparency=1,
Position=UDim2.new(0.5,0,0.5,0),
AnchorPoint=Vector2.new(0.5,0.5),
Active=true,
ZIndex=99,
})
})

local A=h("TextLabel",{
Text=p.Title,
FontFace=Font.new(g.Font,Enum.FontWeight.SemiBold),
BackgroundTransparency=1,
AutomaticSize="XY",
Name="Title",
TextXAlignment="Left",
TextSize=16,
ThemeTag={
TextColor3="Text"
}
})

p.UIElements.Main=h("Frame",{
Size=p.Size,
Position=p.Position,
BackgroundTransparency=1,
Parent=o.Parent,
AnchorPoint=Vector2.new(0.5,0.5),
Active=true,
},{
u,
g.NewRoundFrame(p.UICorner,"Squircle",{
ImageTransparency=1,
Size=UDim2.new(1,0,1,-240),
AnchorPoint=Vector2.new(0.5,0.5),
Position=UDim2.new(0.5,0,0.5,0),
Name="Background",
ThemeTag={
ImageColor3="Background"
},

},{
h("ImageLabel",{
BackgroundTransparency=1,
Size=UDim2.new(1,0,1,0),
Image=p.Background,
ImageTransparency=1,
ScaleType="Crop",
},{
h("UICorner",{
CornerRadius=UDim.new(0,p.UICorner)
}),
}),
z,
r,



}),
UIStroke,
q,
s,
t,
h("Frame",{
Size=UDim2.new(1,0,1,0),
BackgroundTransparency=1,
Name="Main",

Visible=false,
ZIndex=97,
},{
h("UICorner",{
CornerRadius=UDim.new(0,p.UICorner)
}),
p.UIElements.SideBarContainer,
p.UIElements.MainBar,

w,

y,
h("Frame",{
Size=UDim2.new(1,0,0,52),
BackgroundTransparency=1,
BackgroundColor3=Color3.fromRGB(50,50,50),
Name="Topbar"
},{
x,






h("Frame",{
AutomaticSize="X",
Size=UDim2.new(0,0,1,0),
BackgroundTransparency=1,
Name="Left"
},{
h("UIListLayout",{
Padding=UDim.new(0,p.UIPadding+4),
SortOrder="LayoutOrder",
FillDirection="Horizontal",
VerticalAlignment="Center",
}),
h("Frame",{
AutomaticSize="XY",
BackgroundTransparency=1,
Name="Title",
Size=UDim2.new(0,0,1,0),
LayoutOrder=2,
},{
h("UIListLayout",{
Padding=UDim.new(0,0),
SortOrder="LayoutOrder",
FillDirection="Vertical",
VerticalAlignment="Top",
}),
A,
}),
h("UIPadding",{
PaddingLeft=UDim.new(0,4)
})
}),
h("Frame",{
AutomaticSize="XY",
BackgroundTransparency=1,
Position=UDim2.new(1,0,0.5,0),
AnchorPoint=Vector2.new(1,0.5),
Name="Right",
},{
h("UIListLayout",{
Padding=UDim.new(0,9),
FillDirection="Horizontal",
SortOrder="LayoutOrder",
}),

}),
h("UIPadding",{
PaddingTop=UDim.new(0,p.UIPadding),
PaddingLeft=UDim.new(0,p.UIPadding),
PaddingRight=UDim.new(0,8),
PaddingBottom=UDim.new(0,p.UIPadding),
})
})
})
})


function p.CreateTopbarButton(B,C,D,E,F,G)
local H=g.Image(
D,
D,
0,
p.Folder,
"TopbarIcon",
true,
G
)
H.Size=UDim2.new(0,16,0,16)
H.AnchorPoint=Vector2.new(0.5,0.5)
H.Position=UDim2.new(0.5,0,0.5,0)

local I=g.NewRoundFrame(9,"Squircle",{
Size=UDim2.new(0,36,0,36),
LayoutOrder=F or 999,
Parent=p.UIElements.Main.Main.Topbar.Right,

ZIndex=9999,
ThemeTag={
ImageColor3="Text"
},
ImageTransparency=1
},{
g.NewRoundFrame(9,"SquircleOutline",{
Size=UDim2.new(1,0,1,0),
ThemeTag={
ImageColor3="Text",
},
ImageTransparency=1,
Name="Outline"
},{
h("UIGradient",{
Rotation=45,
Color=ColorSequence.new{
ColorSequenceKeypoint.new(0.0,Color3.fromRGB(255,255,255)),
ColorSequenceKeypoint.new(0.5,Color3.fromRGB(255,255,255)),
ColorSequenceKeypoint.new(1.0,Color3.fromRGB(255,255,255)),
},
Transparency=NumberSequence.new{
NumberSequenceKeypoint.new(0.0,0.1),
NumberSequenceKeypoint.new(0.5,1),
NumberSequenceKeypoint.new(1.0,0.1),
}
}),
}),
H
},true)



p.TopBarButtons[100-F]={
Name=C,
Object=I
}

g.AddSignal(I.MouseButton1Click,function()
E()
end)
g.AddSignal(I.MouseEnter,function()
i(I,.15,{ImageTransparency=.93}):Play()
i(I.Outline,.15,{ImageTransparency=.75}):Play()

end)
g.AddSignal(I.MouseLeave,function()
i(I,.1,{ImageTransparency=1}):Play()
i(I.Outline,.1,{ImageTransparency=1}):Play()

end)

return I
end



local B=g.Drag(
p.UIElements.Main,
{p.UIElements.Main.Main.Topbar,z.Frame},
function(B,C)
if not p.Closed then
if B and C==z.Frame then
i(z,.1,{ImageTransparency=.35}):Play()
else
i(z,.2,{ImageTransparency=.8}):Play()
end
end
end
)














if p.Author then
h("TextLabel",{
Text=p.Author,
FontFace=Font.new(g.Font,Enum.FontWeight.Medium),
BackgroundTransparency=1,
TextTransparency=0.4,
AutomaticSize="XY",
Parent=p.UIElements.Main.Main.Topbar.Left.Title,
TextXAlignment="Left",
TextSize=13,
LayoutOrder=2,
ThemeTag={
TextColor3="Text"
}
})

end

local C=a.load'l'.New(p)


task.spawn(function()
if p.Icon then

local D=g.Image(
p.Icon,
p.Title,
0,
p.Folder,
"Window",
true,
p.IconThemed
)
D.Parent=p.UIElements.Main.Main.Topbar.Left
D.Size=UDim2.new(0,22,0,22)

C:SetIcon(p.Icon)











else
C:SetIcon(p.Icon)
OpenButtonIcon.Visible=false
end
end)

function p.SetToggleKey(D,E)
p.ToggleKey=E
end

function p.SetBackgroundImage(D,E)
p.UIElements.Main.Background.ImageLabel.Image=E
end
function p.SetBackgroundImageTransparency(D,E)
p.UIElements.Main.Background.ImageLabel.ImageTransparency=E
p.BackgroundImageTransparency=E
end

local D
local E
g.Icon"minimize"
g.Icon"maximize"

p:CreateTopbarButton("Fullscreen","maximize",function()
p:ToggleFullscreen()
end,998)

function p.ToggleFullscreen(F)
local G=p.IsFullscreen

B:Set(G)

if not G then
D=p.UIElements.Main.Position
E=p.UIElements.Main.Size

p.CanResize=false
else
if p.Resizable then
p.CanResize=true
end
end

i(p.UIElements.Main,0.45,{Size=G and E or UDim2.new(1,-20,1,-72)},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()

i(p.UIElements.Main,0.45,{Position=G and D or UDim2.new(0.5,0,0.5,26)},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()



p.IsFullscreen=not G
end


p:CreateTopbarButton("Minimize","minus",function()
p:Close()
task.spawn(function()
task.wait(.3)
if not v and p.IsOpenButtonEnabled then

C:Visible(true)
end
end)

local F=v and"Press "..p.ToggleKey.Name.." to open the Window"or"Click the Button to open the Window"

if not p.IsOpenButtonEnabled then
n=true
end
if not n then
n=not n
o.WindUI:Notify{
Title="Minimize",
Content="You've closed the Window. "..F,
Icon="eye-off",
Duration=5,
}
end
end,997)

function p.OnClose(F,G)
p.OnCloseCallback=G
end
function p.OnDestroy(F,G)
p.OnDestroyCallback=G
end

function p.Open(F)
task.spawn(function()
task.wait(.06)
p.Closed=false

i(p.UIElements.Main.Background,0.2,{
ImageTransparency=p.Transparent and o.WindUI.TransparencyValue or 0,
},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()

i(p.UIElements.Main.Background,0.4,{
Size=UDim2.new(1,0,1,0),
},Enum.EasingStyle.Exponential,Enum.EasingDirection.Out):Play()

i(p.UIElements.Main.Background.ImageLabel,0.2,{ImageTransparency=p.BackgroundImageTransparency},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()

i(u,0.25,{ImageTransparency=.7},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
if UIStroke then
i(UIStroke,0.25,{Transparency=.8},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
end

task.spawn(function()
task.wait(.5)
i(z,.45,{Size=UDim2.new(0,200,0,4),ImageTransparency=.8},Enum.EasingStyle.Exponential,Enum.EasingDirection.Out):Play()
task.wait(.45)
B:Set(true)
if p.Resizable then
i(r.ImageLabel,.45,{ImageTransparency=.8},Enum.EasingStyle.Exponential,Enum.EasingDirection.Out):Play()
p.CanResize=true
end
end)


p.CanDropdown=true

p.UIElements.Main.Visible=true
task.spawn(function()
task.wait(.05)
p.UIElements.Main.Main.Visible=true
end)
end)
end
function p.Close(F)
local G={}

if p.OnCloseCallback then
task.spawn(function()
g.SafeCallback(p.OnCloseCallback)
end)
end

p.UIElements.Main.Main.Visible=false
p.CanDropdown=false
p.Closed=true

i(p.UIElements.Main.Background,0.32,{
ImageTransparency=1,
},Enum.EasingStyle.Quint,Enum.EasingDirection.InOut):Play()

i(p.UIElements.Main.Background,0.4,{
Size=UDim2.new(1,0,1,-240),
},Enum.EasingStyle.Exponential,Enum.EasingDirection.InOut):Play()


i(p.UIElements.Main.Background.ImageLabel,0.2,{ImageTransparency=1},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
i(u,0.25,{ImageTransparency=1},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
if UIStroke then
i(UIStroke,0.25,{Transparency=1},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
end

i(z,.3,{Size=UDim2.new(0,0,0,4),ImageTransparency=1},Enum.EasingStyle.Exponential,Enum.EasingDirection.InOut):Play()
i(r.ImageLabel,.3,{ImageTransparency=1},Enum.EasingStyle.Exponential,Enum.EasingDirection.Out):Play()
B:Set(false)
p.CanResize=false

task.spawn(function()
task.wait(0.4)
p.UIElements.Main.Visible=false
end)

function G.Destroy(H)
if p.OnDestroyCallback then
task.spawn(function()
g.SafeCallback(p.OnDestroyCallback)
end)
end
p.Destroyed=true
task.wait(0.4)
o.Parent.Parent:Destroy()


end

return G
end

function p.ToggleTransparency(F,G)

p.Transparent=G
o.WindUI.Transparent=G

p.UIElements.Main.Background.ImageTransparency=G and o.WindUI.TransparencyValue or 0

p.UIElements.MainBar.Background.ImageTransparency=G and 0.97 or 0.95

end


function p.SetUIScale(F,G)
o.WindUI.UIScale=G
i(o.WindUI.ScreenGui.UIScale,.2,{Scale=G},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
end

do

if(e.ViewportSize.X-40<p.UIElements.Main.AbsoluteSize.X)
or(e.ViewportSize.Y-40<p.UIElements.Main.AbsoluteSize.Y)then
if not p.IsFullscreen then
p:SetUIScale(.9)
end
end
end

if not v and p.IsOpenButtonEnabled then
g.AddSignal(C.Button.TextButton.MouseButton1Click,function()

C:Visible(false)
p:Open()
end)
end

g.AddSignal(b.InputBegan,function(F,G)
if G then return end

if F.KeyCode==p.ToggleKey then
if p.Closed then
p:Open()
else
p:Close()
end
end
end)

task.spawn(function()

p:Open()
end)

function p.EditOpenButton(F,G)
return C:Edit(G)
end


local F=a.load'B'
local G=a.load'C'
local H=F.Init(p,o.WindUI,o.Parent.Parent.ToolTips)
H:OnChange(function(I)p.CurrentTab=I end)

p.TabModule=F

function p.Tab(I,J)
J.Parent=p.UIElements.SideBar.Frame
return H.New(J)
end

function p.SelectTab(I,J)
H:SelectTab(J)
end

function p.Section(I,J)
return G.New(J,p.UIElements.SideBar.Frame,p.Folder,o.WindUI.UIScale)
end

function p.IsResizable(I,J)
p.Resizable=J
p.CanResize=J
end

function p.Divider(I)
local J=h("Frame",{
Size=UDim2.new(1,0,0,1),
Position=UDim2.new(0.5,0,0,0),
AnchorPoint=Vector2.new(0.5,0),
BackgroundTransparency=.9,
ThemeTag={
BackgroundColor3="Text"
}
})
local K=h("Frame",{
Parent=p.UIElements.SideBar.Frame,

Size=UDim2.new(1,-7,0,5),
BackgroundTransparency=1,
},{
J
})

return K
end

local I=a.load'e'.Init(p,nil)
function p.Dialog(J,K)
local L={
Title=K.Title or"Dialog",
Width=K.Width or 320,
Content=K.Content,
Buttons=K.Buttons or{},

TextPadding=10,
}
local M=I.Create(false)

M.UIElements.Main.Size=UDim2.new(0,L.Width,0,0)

local N=h("Frame",{
Size=UDim2.new(1,0,0,0),
AutomaticSize="Y",
BackgroundTransparency=1,
Parent=M.UIElements.Main
},{
h("UIListLayout",{
FillDirection="Horizontal",
Padding=UDim.new(0,M.UIPadding),
VerticalAlignment="Center"
}),
h("UIPadding",{
PaddingTop=UDim.new(0,L.TextPadding),
PaddingLeft=UDim.new(0,L.TextPadding),
PaddingRight=UDim.new(0,L.TextPadding),
})
})

local O
if K.Icon then
O=g.Image(
K.Icon,
L.Title..":"..K.Icon,
0,
p,
"Dialog",
true,
K.IconThemed
)
O.Size=UDim2.new(0,22,0,22)
O.Parent=N
end

M.UIElements.UIListLayout=h("UIListLayout",{
Padding=UDim.new(0,12),
FillDirection="Vertical",
HorizontalAlignment="Left",
Parent=M.UIElements.Main
})

h("UISizeConstraint",{
MinSize=Vector2.new(180,20),
MaxSize=Vector2.new(400,math.huge),
Parent=M.UIElements.Main,
})


M.UIElements.Title=h("TextLabel",{
Text=L.Title,
TextSize=20,
FontFace=Font.new(g.Font,Enum.FontWeight.SemiBold),
TextXAlignment="Left",
TextWrapped=true,
RichText=true,
Size=UDim2.new(1,O and-26-M.UIPadding or 0,0,0),
AutomaticSize="Y",
ThemeTag={
TextColor3="Text"
},
BackgroundTransparency=1,
Parent=N
})
if L.Content then
h("TextLabel",{
Text=L.Content,
TextSize=18,
TextTransparency=.4,
TextWrapped=true,
RichText=true,
FontFace=Font.new(g.Font,Enum.FontWeight.Medium),
TextXAlignment="Left",
Size=UDim2.new(1,0,0,0),
AutomaticSize="Y",
LayoutOrder=2,
ThemeTag={
TextColor3="Text"
},
BackgroundTransparency=1,
Parent=M.UIElements.Main
},{
h("UIPadding",{
PaddingLeft=UDim.new(0,L.TextPadding),
PaddingRight=UDim.new(0,L.TextPadding),
PaddingBottom=UDim.new(0,L.TextPadding),
})
})
end

local P=h("UIListLayout",{
Padding=UDim.new(0,6),
FillDirection="Horizontal",
HorizontalAlignment="Right",
})

local Q=h("Frame",{
Size=UDim2.new(1,0,0,40),
AutomaticSize="None",
BackgroundTransparency=1,
Parent=M.UIElements.Main,
LayoutOrder=4,
},{
P,
})


local R={}

for S,T in next,L.Buttons do
local U=k(T.Title,T.Icon,T.Callback,T.Variant,Q,M,true)
table.insert(R,U)
end

local function CheckButtonsOverflow()
P.FillDirection=Enum.FillDirection.Horizontal
P.HorizontalAlignment=Enum.HorizontalAlignment.Right
P.VerticalAlignment=Enum.VerticalAlignment.Center
Q.AutomaticSize=Enum.AutomaticSize.None

for S,T in ipairs(R)do
T.Size=UDim2.new(0,0,1,0)
T.AutomaticSize=Enum.AutomaticSize.X
end

wait()

local S=P.AbsoluteContentSize.X
local T=Q.AbsoluteSize.X

if S>T then
P.FillDirection=Enum.FillDirection.Vertical
P.HorizontalAlignment=Enum.HorizontalAlignment.Right
P.VerticalAlignment=Enum.VerticalAlignment.Bottom
Q.AutomaticSize=Enum.AutomaticSize.Y

for U,V in ipairs(R)do
V.Size=UDim2.new(1,0,0,40)
V.AutomaticSize=Enum.AutomaticSize.None
end
else
local U=T-S
if U>0 then
local V
local W=math.huge

for X,Y in ipairs(R)do
local Z=Y.AbsoluteSize.X
if Z<W then
W=Z
V=Y
end
end

if V then
V.Size=UDim2.new(0,W+U,1,0)
V.AutomaticSize=Enum.AutomaticSize.None
end
end
end
end

g.AddSignal(M.UIElements.Main:GetPropertyChangedSignal"AbsoluteSize",CheckButtonsOverflow)
CheckButtonsOverflow()

wait()
M:Open()

return M
end

p:CreateTopbarButton("Close","x",function()
i(p.UIElements.Main,0.35,{Position=UDim2.new(0.5,0,0.5,0)},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
p:Dialog{

Title="Close Window",
Content="Do you want to close this window? You will not be able to open it again.",
Buttons={
{
Title="Cancel",

Callback=function()end,
Variant="Secondary",
},
{
Title="Close Window",

Callback=function()p:Close():Destroy()end,
Variant="Primary",
}
}
}
end,999)


local function startResizing(J)
if p.CanResize then
isResizing=true
s.Active=true
initialSize=p.UIElements.Main.Size
initialInputPosition=J.Position
i(s,0.12,{ImageTransparency=.65}):Play()
i(s.ImageLabel,0.12,{ImageTransparency=0}):Play()
i(r.ImageLabel,0.1,{ImageTransparency=.35}):Play()

g.AddSignal(J.Changed,function()
if J.UserInputState==Enum.UserInputState.End then
isResizing=false
s.Active=false
i(s,0.2,{ImageTransparency=1}):Play()
i(s.ImageLabel,0.17,{ImageTransparency=1}):Play()
i(r.ImageLabel,0.17,{ImageTransparency=.8}):Play()
end
end)
end
end

g.AddSignal(r.InputBegan,function(J)
if J.UserInputType==Enum.UserInputType.MouseButton1 or J.UserInputType==Enum.UserInputType.Touch then
if p.CanResize then
startResizing(J)
end
end
end)

g.AddSignal(b.InputChanged,function(J)
if J.UserInputType==Enum.UserInputType.MouseMovement or J.UserInputType==Enum.UserInputType.Touch then
if isResizing and p.CanResize then
local K=J.Position-initialInputPosition
local L=UDim2.new(0,initialSize.X.Offset+K.X*2,0,initialSize.Y.Offset+K.Y*2)

i(p.UIElements.Main,0,{
Size=UDim2.new(
0,math.clamp(L.X.Offset,480,700),
0,math.clamp(L.Y.Offset,350,520)
)}):Play()
end
end
end)




if not p.HideSearchBar then
local J=a.load'E'
local K=false





















local L=j("Search","search",p.UIElements.SideBarContainer)
L.Size=UDim2.new(1,-p.UIPadding/2,0,39)
L.Position=UDim2.new(0,p.UIPadding/2,0,p.UIPadding/2)

g.AddSignal(L.MouseButton1Click,function()
if K then return end

J.new(p.TabModule,p.UIElements.Main,function()

K=false
if p.Resizable then
p.CanResize=true
end

i(t,0.1,{ImageTransparency=1}):Play()
t.Active=false
end)
i(t,0.1,{ImageTransparency=.65}):Play()
t.Active=true

K=true
p.CanResize=false
end)
end




function p.DisableTopbarButtons(J,K)
for L,M in next,K do
for N,O in next,p.TopBarButtons do
if O.Name==M then
O.Object.Visible=false
end
end
end
end

return p
end end end
local b={
Window=nil,
Theme=nil,
Creator=a.load'a',
Themes=a.load'b',
Transparent=false,

TransparencyValue=.15,

UIScale=1,

ConfigManager=nil
}


local e=a.load'f'

local g=b.Themes
local h=b.Creator

local i=h.New local j=
h.Tween

h.Themes=g

local k=game:GetService"Players"and game:GetService"Players".LocalPlayer or nil
b.Themes=g

local l=protectgui or(syn and syn.protect_gui)or function()end

local m=gethui and gethui()or game.CoreGui


b.ScreenGui=i("ScreenGui",{
Name="WindUI",
Parent=m,
IgnoreGuiInset=true,
ScreenInsets="None",
},{
i("UIScale",{
Scale=b.Scale,
}),
i("Folder",{
Name="Window"
}),






i("Folder",{
Name="KeySystem"
}),
i("Folder",{
Name="Popups"
}),
i("Folder",{
Name="ToolTips"
})
})

b.NotificationGui=i("ScreenGui",{
Name="WindUI/Notifications",
Parent=m,
IgnoreGuiInset=true,
})
b.DropdownGui=i("ScreenGui",{
Name="WindUI/Dropdowns",
Parent=m,
IgnoreGuiInset=true,
})
l(b.ScreenGui)
l(b.NotificationGui)
l(b.DropdownGui)

h.Init(b)

math.clamp(b.TransparencyValue,0,0.4)

local n=a.load'g'
local o=n.Init(b.NotificationGui)

function b.Notify(p,q)
q.Holder=o.Frame
q.Window=b.Window
q.WindUI=b
return n.New(q)
end

function b.SetNotificationLower(p,q)
o.SetLower(q)
end

function b.SetFont(p,q)
h.UpdateFont(q)
end

function b.AddTheme(p,q)
g[q.Name]=q
return q
end

function b.SetTheme(p,q)
if g[q]then
b.Theme=g[q]
h.SetTheme(g[q])
h.UpdateTheme()

return g[q]
end
return nil
end

b:SetTheme"Dark"

function b.GetThemes(p)
return g
end
function b.GetCurrentTheme(p)
return b.Theme.Name
end
function b.GetTransparency(p)
return b.Transparent or false
end
function b.GetWindowSize(p)
return Window.UIElements.Main.Size
end


function b.Popup(p,q)
q.WindUI=b
return a.load'h'.new(q)
end


function b.CreateWindow(p,q)
local r=a.load'F'

if not isfolder"WindUI"then
makefolder"WindUI"
end
if q.Folder then
makefolder(q.Folder)
else
makefolder(q.Title)
end

q.WindUI=b
q.Parent=b.ScreenGui.Window

if b.Window then
warn"You cannot create more than one window"
return
end

local s=true

local t=g[q.Theme or"Dark"]

b.Theme=t

h.SetTheme(t)

local u=k.Name or"Unknown"

if q.KeySystem then
s=false
if q.KeySystem.SaveKey and q.Folder then
if isfile(q.Folder.."/"..u..".key")then
local v
if type(q.KeySystem.Key)=="table"then
v=table.find(q.KeySystem.Key,readfile(q.Folder.."/"..u..".key"))
else
v=tostring(q.KeySystem.Key)==tostring(readfile(q.Folder.."/"..u..".key"))
end
if v then
s=true
end
else
e.new(q,u,function(v)s=v end)
end
else
e.new(q,u,function(v)s=v end)
end
repeat task.wait()until s
end

local v=r(q)

b.Transparent=q.Transparent
b.Window=v














return v
end

return b