--darklua 😍😍
local a=game:GetService"UserInputService"
local b=game:GetService"Players"
local c=game:GetService"Workspace"
game:GetService"ReplicatedStorage"
local d=game:GetService"HttpService"
local e=game:GetService"GuiService"
local f=game:GetService"Lighting"
local g=game:GetService"RunService"
local h=game:GetService"Stats"
local i=game:GetService"CoreGui"
game:GetService"Debris"
local j=game:GetService"TweenService"
game:GetService"SoundService"

local k=Vector2.new local l=
Vector3.new
local m=UDim2.new
local n=UDim.new local o=
Rect.new
local p=CFrame.new
local q=p()local r=
q.PointToObjectSpace local s=
CFrame.Angles
local t=UDim2.fromOffset

local u=Color3.new
local v=Color3.fromRGB
local w=Color3.fromHex local x=
Color3.fromHSV
local y=ColorSequence.new
local z=ColorSequenceKeypoint.new
local A=NumberSequence.new
local B=NumberSequenceKeypoint.new

local C=c.CurrentCamera
local D=b.LocalPlayer
local E=D:GetMouse()
local F=e:GetGuiInset().Y

D:GetPropertyChangedSignal"Team":Connect(function()
if esp then
esp.refresh_elements()
end
end)local G=

math.max
local H=math.floor local I=
math.min local J=
math.abs local K=
math.noise local L=
math.rad local M=
math.random local N=
math.pow local O=
math.sin local P=
math.pi local Q=
math.tan local R=
math.atan2
local S=math.clamp

local T=table.insert
local U=table.find
local V=table.remove
local W=table.concat

local X={}

do
local Y=math.pi
local Z=math.abs
local _=math.clamp
local aa=math.exp
local ab=math.rad
local ac=math.sign
local ad=math.sqrt
local ae=math.tan

local af=game:GetService"ContextActionService"
local ag=game:GetService"Players"
local ah=game:GetService"RunService"
local ai=game:GetService"StarterGui"
local aj=game:GetService"UserInputService"
local ak=game:GetService"Workspace"

local al=ag.LocalPlayer
if not al then
ag:GetPropertyChangedSignal"LocalPlayer":Wait()
al=ag.LocalPlayer
end

local am=ak.CurrentCamera
ak:GetPropertyChangedSignal"CurrentCamera":Connect(function()
local an=ak.CurrentCamera
if an then
am=an
end
end)local an=

Enum.ContextActionPriority.Low.Value
local ao=Enum.ContextActionPriority.High.Value local ap=
{Enum.KeyCode.LeftShift,Enum.KeyCode.P}

local aq=Vector3.new(1,1,1)*64
local ar=Vector2.new(0.75,1)*8
local as=300

local at=ab(90)

local au=10
local av=10
local aw=10

local ax={}do
ax.__index=ax

function ax.new(ay,az)
local aA=setmetatable({},ax)
aA.f=ay
aA.p=az
aA.v=az*0
return aA
end

function ax.Update(ay,az,aA)
local aB=ay.f*2*Y
local aC=ay.p
local aD=ay.v

local aE=aA-aC
local aF=aa(-aB*az)

local aG=aA+(aD*az-aE*(aB*az+1))*aF
local aH=(aB*az*(aE*aB-aD)+aD)*aF

ay.p=aG
ay.v=aH

return aG
end

function ax.Reset(ay,az)
ay.p=az
ay.v=az*0
end
end

local ay=Vector3.new()
local az=Vector2.new()
local aA=0

local aB

local aC=ax.new(au,Vector3.new())
local aD=ax.new(av,Vector2.new())
local aE=ax.new(aw,0)

local aF={}do
local aG do
local aH=2.0
local aI=0.15

local function fCurve(aJ)
return(aa(aH*aJ)-1)/(aa(aH)-1)
end

local function fDeadzone(aJ)
return fCurve((aJ-aI)/(1-aI))
end

function aG(aJ)
return ac(aJ)*_(fDeadzone(Z(aJ)),0,1)
end
end

local aH={
ButtonX=0,
ButtonY=0,
DPadDown=0,
DPadUp=0,
ButtonL2=0,
ButtonR2=0,
Thumbstick1=Vector2.new(),
Thumbstick2=Vector2.new(),
}

local aI={
W=0,
A=0,
S=0,
D=0,
E=0,
Q=0,
U=0,
H=0,
J=0,
K=0,
I=0,
Y=0,
Up=0,
Down=0,
LeftShift=0,
RightShift=0,
}

local aJ={
Delta=Vector2.new(),
MouseWheel=0,
}

local aK=Vector3.new(1,1,1)
local aL=Vector3.new(1,1,1)
local aM=Vector2.new(1,1)*(Y/64)
local aN=Vector2.new(1,1)*(Y/8)
local aO=1.0
local aP=0.25
local aQ=0.75
local aR=0.25

local aS=1

function aF.Vel(aT)
aS=_(aS+aT*(aI.Up-aI.Down)*aQ,0.01,4)

local aU=Vector3.new(
aG(aH.Thumbstick1.X),
aG(aH.ButtonR2)-aG(aH.ButtonL2),
aG(-aH.Thumbstick1.Y)
)*aK

local aV=Vector3.new(
aI.D-aI.A+aI.K-aI.H,
aI.E-aI.Q+aI.I-aI.Y,
aI.S-aI.W+aI.J-aI.U
)*aL

local aW=aj:IsKeyDown(Enum.KeyCode.LeftShift)or aj:IsKeyDown(Enum.KeyCode.RightShift)

return(aU+aV)*(aS*(aW and aR or 1))
end

function aF.Pan(aT)
local aU=Vector2.new(
aG(aH.Thumbstick2.Y),
aG(-aH.Thumbstick2.X)
)*aN
local aV=aJ.Delta*aM
aJ.Delta=Vector2.new()
return aU+aV
end

function aF.Fov(aT)
local aU=(aH.ButtonX-aH.ButtonY)*aP
local aV=aJ.MouseWheel*aO
aJ.MouseWheel=0
return aU+aV
end

do
local function Keypress(aT,aU,aV)
aI[aV.KeyCode.Name]=aU==Enum.UserInputState.Begin and 1 or 0
return Enum.ContextActionResult.Sink
end

local function GpButton(aT,aU,aV)
aH[aV.KeyCode.Name]=aU==Enum.UserInputState.Begin and 1 or 0
return Enum.ContextActionResult.Sink
end

local function MousePan(aT,aU,aV)
local aW=aV.Delta
aJ.Delta=Vector2.new(-aW.y,-aW.x)
return Enum.ContextActionResult.Sink
end

local function Thumb(aT,aU,aV)
aH[aV.KeyCode.Name]=aV.Position
return Enum.ContextActionResult.Sink
end

local function Trigger(aT,aU,aV)
aH[aV.KeyCode.Name]=aV.Position.z
return Enum.ContextActionResult.Sink
end

local function MouseWheel(aT,aU,aV)
aJ[aV.UserInputType.Name]=-aV.Position.z
return Enum.ContextActionResult.Sink
end

local function Zero(aT)
for aU,aV in pairs(aT)do
aT[aU]=aV*0
end
end

function aF.StartCapture()
af:BindActionAtPriority("FreecamKeyboard",Keypress,false,ao,
Enum.KeyCode.W,Enum.KeyCode.U,
Enum.KeyCode.A,Enum.KeyCode.H,
Enum.KeyCode.S,Enum.KeyCode.J,
Enum.KeyCode.D,Enum.KeyCode.K,
Enum.KeyCode.E,Enum.KeyCode.I,
Enum.KeyCode.Q,Enum.KeyCode.Y,
Enum.KeyCode.Up,Enum.KeyCode.Down
)
af:BindActionAtPriority("FreecamMousePan",MousePan,false,ao,Enum.UserInputType.MouseMovement)
af:BindActionAtPriority("FreecamMouseWheel",MouseWheel,false,ao,Enum.UserInputType.MouseWheel)
af:BindActionAtPriority("FreecamGamepadButton",GpButton,false,ao,Enum.KeyCode.ButtonX,Enum.KeyCode.ButtonY)
af:BindActionAtPriority("FreecamGamepadTrigger",Trigger,false,ao,Enum.KeyCode.ButtonR2,Enum.KeyCode.ButtonL2)
af:BindActionAtPriority("FreecamGamepadThumbstick",Thumb,false,ao,Enum.KeyCode.Thumbstick1,Enum.KeyCode.Thumbstick2)
end

function aF.StopCapture()
aS=1
Zero(aH)
Zero(aI)
Zero(aJ)
af:UnbindAction"FreecamKeyboard"
af:UnbindAction"FreecamMousePan"
af:UnbindAction"FreecamMouseWheel"
af:UnbindAction"FreecamGamepadButton"
af:UnbindAction"FreecamGamepadTrigger"
af:UnbindAction"FreecamGamepadThumbstick"
end
end
end

local function GetFocusDistance(aG)
local aH=0.1
local aI=am.ViewportSize
local aJ=2*ae(aA/2)
local aK=aI.x/aI.y*aJ
local aL=aG.rightVector
local aM=aG.upVector
local aN=aG.lookVector

local aO=Vector3.new()
local aP=512

for aQ=0,1,0.5 do
for aR=0,1,0.5 do
local aS=(aQ-0.5)*aK
local aT=(aR-0.5)*aJ
local aU=aL*aS-aM*aT+aN
local aV=aG.p+aU*aH local
aW, aX=ak:FindPartOnRay(Ray.new(aV,aU.unit*aP))
local aY=(aX-aV).magnitude
if aP>aY then
aP=aY
aO=aU.unit
end
end
end

return aN:Dot(aO)*aP
end

local function StepFreecam(aG)

if aB then
local aH=aC:Update(aG,aF.Vel(aG))
local aI=aE:Update(aG,aF.Fov(aG))

local aJ=ad(ae(ab(35))/ae(ab(aA/2)))
aA=_(aA+aI*as*(aG/aJ),1,120)

local aK=aB*CFrame.new(aH*aq*aG)
ay=aK.Position
az=Vector2.new(aK:toEulerAnglesYXZ())

am.CFrame=aK
am.Focus=aK*CFrame.new(0,0,-GetFocusDistance(aK))
am.FieldOfView=aA
return
end

local aH=aC:Update(aG,aF.Vel(aG))
local aI=aD:Update(aG,aF.Pan(aG))
local aJ=aE:Update(aG,aF.Fov(aG))

local aK=ad(ae(ab(35))/ae(ab(aA/2)))

aA=_(aA+aJ*as*(aG/aK),1,120)
az=az+aI*ar*(aG/aK)
az=Vector2.new(_(az.x,-at,at),az.y%(2*Y))

local aL=CFrame.new(ay)*CFrame.fromOrientation(az.x,az.y,0)*CFrame.new(aH*aq*aG)
ay=aL.p

am.CFrame=aL
am.Focus=aL*CFrame.new(0,0,-GetFocusDistance(aL))
am.FieldOfView=aA
end

local aG={}do
local aH
local aI
local aJ
local aK
local aL
local aM
local aN={}
local aO={
Backpack=true,
Chat=true,
Health=true,
PlayerList=true,
}
local aP={
BadgesNotificationsActive=true,
PointsNotificationsActive=true,
}

function aG.Push()

aM=am.FieldOfView
am.FieldOfView=70

aJ=am.CameraType
am.CameraType=Enum.CameraType.Custom

aL=am.CFrame
aK=am.Focus

aI=aj.MouseIconEnabled
aj.MouseIconEnabled=true

aH=aj.MouseBehavior
aj.MouseBehavior=Enum.MouseBehavior.Default
end

function aG.Pop()
for aQ,aR in pairs(aO)do
ai:SetCoreGuiEnabled(Enum.CoreGuiType[aQ],aR)
end
for aQ,aR in pairs(aP)do
ai:SetCore(aQ,aR)
end
for aQ,aR in pairs(aN)do
if aR.Parent then
aR.Enabled=true
end
end

am.FieldOfView=aM
aM=nil

am.CameraType=aJ
aJ=nil

am.CFrame=aL
aL=nil

am.Focus=aK
aK=nil

aj.MouseIconEnabled=true
aj.MouseBehavior=Enum.MouseBehavior.Default
aH=nil
aI=nil
end
end

local function StartFreecam()
local aH=am.CFrame
az=Vector2.new(aH:toEulerAnglesYXZ())
ay=aH.p
aA=am.FieldOfView

aC:Reset(Vector3.new())
aD:Reset(Vector2.new())
aE:Reset(0)

aG.Push()
ah:BindToRenderStep("Freecam",Enum.RenderPriority.Camera.Value,StepFreecam)
aF.StartCapture()
end

local function StopFreecam()
aF.StopCapture()
ah:UnbindFromRenderStep"Freecam"
aG.Pop()

task.spawn(function()
for aH=1,45 do
task.wait()
aj.MouseBehavior=Enum.MouseBehavior.Default
aj.MouseIconEnabled=true
end
end)
end

function X.EnableFreecam(aH)
StartFreecam()
end

function X.StopFreecam(aH)
StopFreecam()
end

local aH=false

function X.IsActive(aI)
return aH
end

function X.SetOverride(aI,aJ)
aB=aJ
end

function X.ClearOverride(aI)
aB=nil
end

function X.set_active(aI)
aI=not not aI

if aI==aH then
return
end

aH=aI

if aI then
X:EnableFreecam()
else
X:StopFreecam()
end

if library.freecam_keybind then
library.freecam_keybind.set(aI)
end
end

aj.InputBegan:Connect(function(aI,aJ)
if aJ then return end
if aI.KeyCode==Enum.KeyCode.P then
local aK=aj:IsKeyDown(Enum.KeyCode.LeftShift)or
aj:IsKeyDown(Enum.KeyCode.RightShift)
if aK then
X.set_active(not aH)
end
end
end)
end

getgenv().library={
directory="priv9",
folders={
"/fonts",
"/configs",
},
flags={},
config_flags={},

connections={},
notifications={},
playerlist_data={
players={},
player={},
},
colorpicker_open=false;
gui;
}

local aa={
preset={
outline=v(10,10,10),
inline=v(35,35,35),
text=v(180,180,180),
text_outline=v(0,0,0),
background=v(20,20,20),
["1"]=w"#245771",
["2"]=w"#215D63",
["3"]=w"#1E6453",
},

utility={
inline={
BackgroundColor3={}
},
text={
TextColor3={}
},
text_outline={
Color={}
},
["1"]={
BackgroundColor3={},
TextColor3={},
ImageColor3={},
ScrollBarImageColor3={},
BorderColor3={},
},
["2"]={
BackgroundColor3={},
TextColor3={},
ImageColor3={},
ScrollBarImageColor3={},
BorderColor3={},
},
["3"]={
BackgroundColor3={},
TextColor3={},
ImageColor3={},
ScrollBarImageColor3={},
BorderColor3={},
},
}
}

local ab={
[Enum.KeyCode.LeftShift]="LShift",
[Enum.KeyCode.RightShift]="RShift",
[Enum.KeyCode.LeftControl]="LCtrl",
[Enum.KeyCode.RightControl]="RCtrl",
[Enum.KeyCode.Insert]="INSERT",
[Enum.KeyCode.Backspace]="BACK",
[Enum.KeyCode.Return]="Enter",
[Enum.KeyCode.LeftAlt]="LAlt",
[Enum.KeyCode.RightAlt]="RAlt",
[Enum.KeyCode.CapsLock]="CAPS",
[Enum.KeyCode.One]="1",
[Enum.KeyCode.Two]="2",
[Enum.KeyCode.Three]="3",
[Enum.KeyCode.Four]="4",
[Enum.KeyCode.Five]="5",
[Enum.KeyCode.Six]="6",
[Enum.KeyCode.Seven]="7",
[Enum.KeyCode.Eight]="8",
[Enum.KeyCode.Nine]="9",
[Enum.KeyCode.Zero]="0",
[Enum.KeyCode.KeypadOne]="Num1",
[Enum.KeyCode.KeypadTwo]="Num2",
[Enum.KeyCode.KeypadThree]="Num3",
[Enum.KeyCode.KeypadFour]="Num4",
[Enum.KeyCode.KeypadFive]="Num5",
[Enum.KeyCode.KeypadSix]="Num6",
[Enum.KeyCode.KeypadSeven]="Num7",
[Enum.KeyCode.KeypadEight]="Num8",
[Enum.KeyCode.KeypadNine]="Num9",
[Enum.KeyCode.KeypadZero]="Num0",
[Enum.KeyCode.Minus]="-",
[Enum.KeyCode.Equals]="=",
[Enum.KeyCode.Tilde]="~",
[Enum.KeyCode.LeftBracket]="[",
[Enum.KeyCode.RightBracket]="]",
[Enum.KeyCode.RightParenthesis]=")",
[Enum.KeyCode.LeftParenthesis]="(",
[Enum.KeyCode.Semicolon]=",",
[Enum.KeyCode.Quote]="'",
[Enum.KeyCode.BackSlash]="\\",
[Enum.KeyCode.Comma]=",",
[Enum.KeyCode.Period]=".",
[Enum.KeyCode.Slash]="/",
[Enum.KeyCode.Asterisk]="*",
[Enum.KeyCode.Plus]="+",
[Enum.KeyCode.Period]=".",
[Enum.KeyCode.Backquote]="`",
[Enum.UserInputType.MouseButton1]="MB1",
[Enum.UserInputType.MouseButton2]="MB2",
[Enum.UserInputType.MouseButton3]="MB3",
[Enum.KeyCode.Escape]="ESCAPE",
[Enum.KeyCode.Space]="SPACE",
}

library.__index=library

for ac,ad in next,library.folders do
makefolder(library.directory..ad)
end

local ac=library.flags
local ad=library.config_flags
library.keybinds={}

local ae={};do
function Register_Font(af,ag,ah,ai)
if not isfile(ai.Id)then
writefile(ai.Id,ai.Font)
end

if isfile(af..".font")then
delfile(af..".font")
end

local aj={
name=af,
faces={
{
name="Regular",
weight=ag,
style=ah,
assetId=getcustomasset(ai.Id),
},
},
}

writefile(af..".font",game:GetService"HttpService":JSONEncode(aj))

return getcustomasset(af..".font")
end

local af=Register_Font("Tahoma",200,"Normal",{
Id="Tahoma.ttf",
Font=game:HttpGet"https://github.com/i77lhm/storage/raw/refs/heads/main/fonts/tahoma_bold.ttf",
})

local ag=Register_Font("ProggyClean",200,"normal",{
Id="ProggyClean.ttf",
Font=game:HttpGet"https://github.com/i77lhm/storage/raw/refs/heads/main/fonts/ProggyClean.ttf"
})

local ah=Register_Font("SmallestPixel",400,"Normal",{
Id="SmallestPixel.ttf",
Font=game:HttpGet"https://github.com/i77lhm/storage/raw/refs/heads/main/fonts/smallest_pixel-7.ttf",
})

ae={TahomaBold=
Font.new(af,Enum.FontWeight.Regular,Enum.FontStyle.Normal);ProggyClean=
Font.new(ag,Enum.FontWeight.Regular,Enum.FontStyle.Normal);SmallestPixel=
Font.new(ah,Enum.FontWeight.Regular,Enum.FontStyle.Normal);
}
end

function library.tween(af,ag,ah)
local ai=j:Create(ag,TweenInfo.new(0.25,Enum.EasingStyle.Quad,Enum.EasingDirection.InOut,0,false,0),ah):Play()

return ai
end

function library.close_current_element(af,ag)
local ah=library.current_element_open

if ah then
ah.set_visible(false)
ah.open=false
end
end

function library.resizify(af,ag)
local ah=Instance.new"TextButton"
ah.Position=m(1,-10,1,-10)
ah.BorderColor3=v(0,0,0)
ah.Size=m(0,10,0,10)
ah.BorderSizePixel=0
ah.BackgroundColor3=v(255,255,255)
ah.Parent=ag
ah.BackgroundTransparency=1
ah.Text=""

local ai=false
local aj
local ak
local al=ag.Size

ah.InputBegan:Connect(function(am)
if am.UserInputType==Enum.UserInputType.MouseButton1 then
ai=true
ak=am.Position
aj=ag.Size
end
end)

ah.InputEnded:Connect(function(am)
if am.UserInputType==Enum.UserInputType.MouseButton1 then
ai=false
end
end)

library:connection(a.InputChanged,function(am,ao)
if ai and am.UserInputType==Enum.UserInputType.MouseMovement then
local ap=C.ViewportSize.X
local aq=C.ViewportSize.Y

local ar=m(
aj.X.Scale,
math.clamp(
aj.X.Offset+(am.Position.X-ak.X),
al.X.Offset,
ap
),
aj.Y.Scale,
math.clamp(
aj.Y.Offset+(am.Position.Y-ak.Y),
al.Y.Offset,
aq
)
)
ag.Size=ar
end
end)
end

function library.mouse_in_frame(af,ag)
local ah=ag.AbsolutePosition.Y<=E.Y and E.Y<=ag.AbsolutePosition.Y+ag.AbsoluteSize.Y
local ai=ag.AbsolutePosition.X<=E.X and E.X<=ag.AbsolutePosition.X+ag.AbsoluteSize.X

return(ah and ai)
end

library.lerp=function(af,ag,ah)
ah=ah or 0.125

return af*(1-ah)+ag*ah
end

function library.draggify(af,ag)
local ah=false
local ai=ag.Position
local aj

ag.InputBegan:Connect(function(ak)
if ak.UserInputType==Enum.UserInputType.MouseButton1 then
ah=true
aj=ak.Position
ai=ag.Position
end
end)

ag.InputEnded:Connect(function(ak)
if ak.UserInputType==Enum.UserInputType.MouseButton1 then
ah=false
end
end)

library:connection(a.InputChanged,function(ak,al)
if ah and ak.UserInputType==Enum.UserInputType.MouseMovement then
local am=C.ViewportSize.X
local ao=C.ViewportSize.Y

local ap=m(
0,
S(
ai.X.Offset+(ak.Position.X-aj.X),
0,
am-ag.Size.X.Offset
),
0,
math.clamp(
ai.Y.Offset+(ak.Position.Y-aj.Y),
0,
ao-ag.Size.Y.Offset
)
)

ag.Position=ap
end
end)
end

function library.convert(af,ag)
local ah={}

for ai in string.gmatch(ag,"[^,]+")do
T(ah,tonumber(ai))
end

if#ah==4 then
return unpack(ah)
else
return
end
end

function library.convert_enum(af,ag)
local ah={}

for ai in string.gmatch(ag,"[%w_]+")do
T(ah,ai)
end

local ai=Enum
for aj=2,#ah do
local ak=ai[ah[aj] ]

ai=ak
end

return ai
end

local af;
function library.update_config_list(ag)
if not af then
return
end

local ah={}

for ai,aj in listfiles(library.directory.."/configs")do
local ak=aj:gsub(library.directory.."/configs\\",""):gsub(".cfg",""):gsub(library.directory.."\\configs\\","")
ah[#ah+1]=ak
end

af.refresh_options(ah)
end

function library.get_config(ag)
local ah={}

for ai,aj in ac do
if type(aj)=="table"and aj.key then
ah[ai]={active=aj.active,mode=aj.mode,key=tostring(aj.key)}
elseif type(aj)=="table"and aj.Transparency and aj.Color then
ah[ai]={Transparency=aj.Transparency,Color=aj.Color:ToHex()}
else
ah[ai]=aj
end
end

return d:JSONEncode(ah)
end

function library.load_config(ag,ah)
local ai=d:JSONDecode(ah)

for aj,ak in next,ai do
local al=library.config_flags[aj]

if aj=="config_name_list"then
continue
end

if al then
if type(ak)=="table"and ak.Transparency and ak.Color then
al(w(ak.Color),ak.Transparency)
print"set cp!"
elseif type(ak)=="table"and ak.active then
al(ak)
else
al(ak)
end
end
end
end

function library.round(ag,ah,ai)
local aj=1/(ai or 1)

return H(ah*aj+0.5)/aj
end

function library.apply_theme(ag,ah,ai,aj)
T(aa.utility[ai][aj],ah)
end

function library.update_theme(ag,ah,ai)
for aj,ak in next,aa.utility[ah]do
for al,am in next,ak do
if am:GetAttribute"PrivToggleState"==false and aj=="BackgroundColor3"then

am[aj]=aa.preset.inline
else
am[aj]=ai
end
end
end

aa.preset[ah]=ai
end

function library.create_visuals_selection_box(ag,ah)
local ai=library:create("Frame",{
Parent=ah.elements;
BorderColor3=aa.preset[tostring(ah.count)];
BorderSizePixel=1;
BackgroundColor3=v(35,35,35);
Size=m(1,0,0,0);
AutomaticSize=Enum.AutomaticSize.Y;
})
library:apply_theme(ai,tostring(ah.count),"BorderColor3")

library:create("UIPadding",{
Parent=ai;
PaddingTop=n(0,4);
PaddingBottom=n(0,4);
PaddingLeft=n(0,6);
PaddingRight=n(0,6);
})

library:create("UIListLayout",{
Parent=ai;
Padding=n(0,4);
SortOrder=Enum.SortOrder.LayoutOrder;
})

return ai
end

function library.create_visuals_page(ag,ah,ai,aj)
local ak=aj.center_label or aj.label
local al=aj.right_label or(aj.label.." options")

local am=aj.auto_fill~=false

local ao=ah:section{name=ak,auto_fill=am,size=1}
local ap=ai:section{name=al,auto_fill=am,size=1}

ao.frame.Visible=false
ap.frame.Visible=false

return{
center=ao,
right=ap,
}
end

library.visuals_registry=library.visuals_registry or{pages={},selection_box=nil}

function library.create_visuals_selection(ag,ah)
local ai=library:create_visuals_selection_box(ah)
library.visuals_registry.selection_box=ai
return ai
end

function library.create_visuals_placeholder(ag,ah,ai)
local aj=ah:section{name=ai or"placeholder",auto_fill=false,size=1}
aj.frame.Visible=false
return aj
end

function library.register_visuals_page(ag,ah,ai,aj,ak)
library.visuals_registry.pages[ah]=library.visuals_registry.pages[ah]or{}
local al=library.visuals_registry.pages[ah]
al.label=ai
al.center=aj
al.right=ak

local am=library.visuals_registry.selection_box
if am and not al.button then
local ao=library:create("TextButton",{
FontFace=ae.ProggyClean;
TextColor3=v(170,170,170);
BorderColor3=v(0,0,0);
Text=ai;
Parent=am;
BackgroundTransparency=1;
BorderSizePixel=0;
AutomaticSize=Enum.AutomaticSize.XY;
TextSize=12;
TextXAlignment=Enum.TextXAlignment.Left;
BackgroundColor3=v(255,255,255)
})

al.button=ao

ao.MouseButton1Click:Connect(function()
library:set_visuals_page(ah)
end)
end

return al
end

function library.get_visuals_page(ag,ah)
library.visuals_registry=library.visuals_registry or{pages={},selection_box=nil}
return library.visuals_registry.pages[ah]
end

function library.set_visuals_page(ag,ah)
library.visuals_registry=library.visuals_registry or{pages={},selection_box=nil}
local function set_visible(ai,aj)
if not ai then return end

if type(ai)=="table"and ai.frame then
ai.frame.Visible=aj
return
end

if type(ai)=="table"then
for ak,al in next,ai do
if al and al.frame then
al.frame.Visible=aj
end
end
end
end

for ai,aj in next,library.visuals_registry.pages do
local ak=ai==ah

set_visible(aj.center,ak)
set_visible(aj.right,ak)

if aj.button then
aj.button.TextColor3=ak and v(255,255,255)or v(170,170,170)
end
end
end

function library.connection(ag,ah,ai)
local aj=ah:Connect(ai)

T(library.connections,aj)

return aj
end

function library.apply_stroke(ag,ah)
local ai=library:create("UIStroke",{
Parent=ah,
Color=aa.preset.text_outline,
LineJoinMode=Enum.LineJoinMode.Miter
})

library:apply_theme(ai,"text_outline","Color")
end

function library.create(ag,ah,ai)
local aj=Instance.new(ah)

for ak,al in next,ai do
aj[ak]=al
end

if ah=="TextLabel"or ah=="TextButton"or ah=="TextBox"then
library:apply_theme(aj,"text","TextColor3")
library:apply_stroke(aj)
end

return aj
end

function library.update_keybind_visualizer(ag)
local ah=ag.active_keybind_container
if not ah then
return
end

local ai={}
for aj,ak in ipairs(ag.keybinds or{})do
if ak.active and not ak.ignore_key and ak.flag~="menu_key"then
T(ai,ak)
end
end

for aj,ak in ipairs(ag.active_keybind_labels or{})do
ak:Destroy()
end
ag.active_keybind_labels={}

if#ai==0 then
ah.Visible=false
return
end

ah.Visible=true
for aj,ak in ipairs(ai)do
local al=library:create("TextLabel",{
Parent=ah;
Text="";
FontFace=ae.SmallestPixel;
TextColor3=w"#8AD4BF";
BackgroundTransparency=1;
BorderSizePixel=0;
AutomaticSize=Enum.AutomaticSize.XY;
TextSize=9;
TextStrokeTransparency=0;
TextXAlignment=Enum.TextXAlignment.Center;
})

local am=ak.mode or""
al.Text=string.format("%s [%s]",ak.name or ak.flag or"keybind",string.lower(am))
T(ag.active_keybind_labels,al)
end
end

function library.unload_menu(ag)
if library.gui then
library.gui:Destroy()
end

for ah,ai in next,library.connections do
ai:Disconnect()
ai=nil
end

if library.sgui then
library.sgui:Destroy()
end

library=nil
end

function library.window(ag,ah)
local ai={
name=ah.name or ah.Name or"priv9",
size=ah.size or ah.Size or m(0,450,0,350),
selected_tab=nil,
tabs={}
}

library.gui=library:create("ScreenGui",{
Parent=i,
Name="\0",
Enabled=true,
ZIndexBehavior=Enum.ZIndexBehavior.Sibling,
IgnoreGuiInset=true,
DisplayOrder=2147483647,
})

local aj=library:create("Frame",{
Parent=library.gui;
Position=m(0.5,-ai.size.X.Offset/2,0.5,-ai.size.Y.Offset/2);
BorderColor3=v(0,0,0);
Size=ai.size;
BorderSizePixel=0;
BackgroundColor3=v(255,255,255)
});
aj.Position=m(0,aj.AbsolutePosition.Y,0,aj.AbsolutePosition.Y)
ai.main_outline=aj

library:resizify(aj)
library:draggify(aj)

local ak=library:create("Frame",{
Parent=aj;
BackgroundTransparency=0.800000011920929;
Position=m(0,2,0,2);
BorderColor3=v(0,0,0);
Size=m(1,-4,0,20);
BorderSizePixel=0;
BackgroundColor3=v(0,0,0)
});

library:create("TextLabel",{
FontFace=ae.TahomaBold;
TextColor3=v(255,255,255);
BorderColor3=v(0,0,0);
Text=ai.name;
Parent=ak;
BackgroundTransparency=1;
Size=m(1,0,1,0);
BorderSizePixel=0;
TextSize=12;
BackgroundColor3=v(255,255,255)
});

library.gradient=library:create("UIGradient",{
Color=y{
z(0,aa.preset["1"]),
z(0.5,aa.preset["2"]),
z(1,aa.preset["3"]),
};
Parent=aj
});

local al=library:create("Frame",{
AnchorPoint=k(0,1);
Parent=aj;
BackgroundTransparency=0.800000011920929;
Position=m(0,2,1,-2);
BorderColor3=v(0,0,0);
Size=m(1,-4,0,20);
BorderSizePixel=0;
BackgroundColor3=v(0,0,0)
});ai.tab_button_holder=al

library:create("UIListLayout",{
VerticalAlignment=Enum.VerticalAlignment.Center;
FillDirection=Enum.FillDirection.Horizontal;
HorizontalAlignment=Enum.HorizontalAlignment.Center;
HorizontalFlex=Enum.UIFlexAlignment.Fill;
Parent=al;
SortOrder=Enum.SortOrder.LayoutOrder;
VerticalFlex=Enum.UIFlexAlignment.Fill
});

function ai.toggle_menu(am)
aj.Visible=am
end

return setmetatable(ai,library)
end

function library.tab(ag,ah)
local ai={
name=ah.name or"visuals",
count=0
}

ag.tabs=ag.tabs or{}
T(ag.tabs,ai)

local aj=library:create("TextButton",{
FontFace=ae.ProggyClean;
TextColor3=v(170,170,170);
BorderColor3=v(0,0,0);
Text=ai.name;
Parent=ag.tab_button_holder;
BackgroundTransparency=1;
BorderSizePixel=0;
AutomaticSize=Enum.AutomaticSize.XY;
TextSize=12;
BackgroundColor3=v(255,255,255)
});

local ak=library:create("Frame",{
Parent=ag.main_outline;
BackgroundTransparency=0.6;
Position=m(0,2,0,24);
BorderColor3=v(0,0,0);
Size=m(1,-4,1,-48);
BorderSizePixel=0;
BackgroundColor3=v(0,0,0),
Visible=false,
});ai.page=ak

library:create("UIListLayout",{
FillDirection=Enum.FillDirection.Horizontal;
HorizontalFlex=Enum.UIFlexAlignment.Fill;
Parent=ak;
Padding=n(0,2);
SortOrder=Enum.SortOrder.LayoutOrder;
VerticalFlex=Enum.UIFlexAlignment.Fill
});

library:create("UIPadding",{
PaddingTop=n(0,2);
PaddingBottom=n(0,2);
Parent=ak;
PaddingRight=n(0,2);
PaddingLeft=n(0,2)
});

function ai.open_tab()
local al=ag.selected_tab

if al then
al[1].Visible=false
al[2].TextColor3=v(170,170,170)

al=nil
end

ak.Visible=true
aj.TextColor3=v(255,255,255)

ag.selected_tab={ak,aj}
end

aj.MouseButton1Down:Connect(function()
ai.open_tab()
end)

if not ag.selected_tab then
ai.open_tab(true)
end

return setmetatable(ai,library)
end

local ag={notifs={}}

library.sgui=library:create("ScreenGui",{
Name="Hi",
Parent=gethui();
IgnoreGuiInset=false;
DisplayOrder=2147483646;
})

library.active_keybind_container=library:create("Frame",{
Parent=library.sgui;
AnchorPoint=k(0.5,0);
Position=m(0.5,0,0.5,30);
BackgroundTransparency=1;
BorderSizePixel=0;
AutomaticSize=Enum.AutomaticSize.XY;
Visible=false;
})
library.active_keybind_labels={}

library:create("UIListLayout",{
Parent=library.active_keybind_container;
Padding=n(0,4);
SortOrder=Enum.SortOrder.LayoutOrder;
HorizontalAlignment=Enum.HorizontalAlignment.Center;
})

function ag.refresh_notifs(ah)
local ai=library.watermark_outline
local aj=(ai and ai.AbsolutePosition and ai.AbsolutePosition.X)and ai.AbsolutePosition.X or 18
local ak=(ai and ai.AbsolutePosition and ai.AbsolutePosition.Y)and ai.AbsolutePosition.Y or 0

local al={}
for am in pairs(ag.notifs)do
if type(am)=="number"then
T(al,am)
end
end

table.sort(al)

local am=30
local ao=(ai and ai.AbsoluteSize and ai.AbsoluteSize.Y)and ai.AbsoluteSize.Y or 24
for ap,aq in ipairs(al)do
local ar=ag.notifs[aq]
if ar then
local as=ak+ao+(ap*am)
j:Create(ar,TweenInfo.new(1,Enum.EasingStyle.Exponential,Enum.EasingDirection.Out),{Position=t(aj,as)}):Play()
end
end
end

function ag.fade(ah,ai,aj)
local ak=aj and 1 or 0

j:Create(ai,TweenInfo.new(1,Enum.EasingStyle.Exponential,Enum.EasingDirection.Out),{BackgroundTransparency=ak}):Play()

for al,am in ai:GetDescendants()do
if not am:IsA"GuiObject"then
if am:IsA"UIStroke"then
j:Create(am,TweenInfo.new(1,Enum.EasingStyle.Exponential,Enum.EasingDirection.Out),{Transparency=ak}):Play()
end

continue
end

if am:IsA"TextLabel"then
j:Create(am,TweenInfo.new(1,Enum.EasingStyle.Exponential,Enum.EasingDirection.Out),{TextTransparency=ak}):Play()
elseif am:IsA"Frame"then
j:Create(am,TweenInfo.new(1,Enum.EasingStyle.Exponential,Enum.EasingDirection.Out),{BackgroundTransparency=am.Transparency and 0.6 and aj and 1 or 0.6}):Play()
end
end
end

function ag.create_notification(ah,ai)
local aj={
name=ai.name or"Hit: retard (retard) in the Head for 100 Damage!",
outline;
}

local ak=library.watermark_outline
local al=(ak and ak.AbsolutePosition and ak.AbsolutePosition.X)and ak.AbsolutePosition.X or 18
local am=(ak and ak.AbsolutePosition and ak.AbsolutePosition.Y)and ak.AbsolutePosition.Y or 0

local ao=8
local ap=(ak and ak.AbsoluteSize and ak.AbsoluteSize.Y)and ak.AbsoluteSize.Y or 24

local aq=library:create("Frame",{
Parent=library.sgui;
Position=t(al,am+ap+((#ag.notifs+1)*ao));
BorderColor3=v(0,0,0);
Size=m(0,0,0,24);
BorderSizePixel=0;
AutomaticSize=Enum.AutomaticSize.X;
BackgroundColor3=v(255,255,255)
});

local ar=library:create("Frame",{
Parent=aq;
BackgroundTransparency=1;
Position=m(0,2,0,2);
BorderColor3=v(0,0,0);
Size=m(1,-4,1,-4);
BorderSizePixel=0;
BackgroundColor3=v(0,0,0)
});

library:create("UIPadding",{
PaddingTop=n(0,7);
PaddingBottom=n(0,6);
Parent=ar;
PaddingRight=n(0,7);
PaddingLeft=n(0,4)
});

library:create("TextLabel",{
FontFace=ae.ProggyClean;
TextColor3=v(255,255,255);
BorderColor3=v(0,0,0);
Text=aj.name;
Parent=ar;
Size=m(0,0,1,0);
Position=m(0,1,0,-1);
BackgroundTransparency=1;
TextXAlignment=Enum.TextXAlignment.Left;
BorderSizePixel=0;
AutomaticSize=Enum.AutomaticSize.X;
TextSize=12;
BackgroundColor3=v(255,255,255)
});

library:create("UIGradient",{
Color=y{
z(0,aa.preset["1"]),
z(0.5,aa.preset["2"]),
z(1,aa.preset["3"]),
};
Parent=aq
});

local as=#ag.notifs+1
ag.notifs[as]=aq

ag:refresh_notifs()
j:Create(aq,TweenInfo.new(1,Enum.EasingStyle.Exponential,Enum.EasingDirection.Out),{AnchorPoint=k(0,0)}):Play()

ag:fade(aq,false)

task.spawn(function()
task.wait(3)

ag.notifs[as]=nil

ag:fade(aq,true)

task.wait(3)

aq:Destroy()
end)
end

function library.watermark(ah,ai)
local aj={
name=ai.name or"nebulahax";
}

local ak=library:create("Frame",{
Parent=library.sgui;
Position=m(0,18,0,0);
BorderColor3=v(0,0,0);
Size=m(0,0,0,24);
BorderSizePixel=0;
AutomaticSize=Enum.AutomaticSize.X;
BackgroundColor3=v(255,255,255)
});library.watermark_outline=ak;library:draggify(ak);

local al=library:create("Frame",{
Parent=ak;
BackgroundTransparency=0.6;
Position=m(0,2,0,2);
BorderColor3=v(0,0,0);
Size=m(1,-4,1,-4);
BorderSizePixel=0;
BackgroundColor3=v(0,0,0)
});

library:create("UIPadding",{
PaddingTop=n(0,7);
PaddingBottom=n(0,6);
Parent=al;
PaddingRight=n(0,7);
PaddingLeft=n(0,4)
});

local am=library:create("TextLabel",{
FontFace=ae.ProggyClean;
TextColor3=v(255,255,255);
BorderColor3=v(0,0,0);
Text=aj.name;
Parent=al;
Size=m(0,0,1,0);
Position=m(0,1,0,-1);
BackgroundTransparency=1;
TextXAlignment=Enum.TextXAlignment.Left;
BorderSizePixel=0;
AutomaticSize=Enum.AutomaticSize.X;
TextSize=12;
BackgroundColor3=v(255,255,255)
});

library.watermark_gradient=library:create("UIGradient",{
Color=y{
z(0,aa.preset["1"]),
z(0.5,aa.preset["2"]),
z(1,aa.preset["3"]),
};
Parent=ak
});

function aj.update_text(ao)
am.Text=ao
end

aj.update_text(aj.name)

return setmetatable(aj,library)
end

local ah=library:watermark{name="priv9.net alpha"}
local ai=0
local aj=tick()

g.RenderStepped:Connect(function()
ai+=1

if tick()-aj>1 then
aj=tick()
local ak=math.floor(h.PerformanceStats.Ping:GetValue()).."ms"
ah.update_text(string.format("priv9.net alpha | fps: %s",ai,ak))
ai=0
end
end)

function library.column(ak,al)
ak.count+=1

local am={color=library.gradient.Color.Keypoints[ak.count].Value,count=ak.count}

local ao=library:create("ScrollingFrame",{
ScrollBarImageColor3=v(0,0,0);
Active=true;
AutomaticCanvasSize=Enum.AutomaticSize.Y;
ScrollBarThickness=0;
Parent=ak.page;
LayoutOrder=-1;
BackgroundTransparency=1;
ScrollBarImageTransparency=1;
BorderColor3=v(0,0,0);
BackgroundColor3=v(0,0,0);
BorderSizePixel=0;
CanvasSize=m(0,0,0,0)
});am.column=ao

library:create("UIListLayout",{
Parent=ao;
Padding=n(0,2);
SortOrder=Enum.SortOrder.LayoutOrder
});

return setmetatable(am,library)
end

function library.section(ak,al)
local am={
name=al.name or al.Name or"section",
size=al.size or 1,
autofill=al.auto_fill or false,
count=ak.count;
color=ak.color;
}

local ao=library:create("Frame",{
Parent=ak.column;
ClipsDescendants=true;
BorderColor3=v(0,0,0);
BorderSizePixel=0;
BackgroundColor3=aa.preset[tostring(ak.count)]
});library:apply_theme(ao,tostring(ak.count),"BackgroundColor3");

local ap=library:create("Frame",{
Parent=ao;
BackgroundTransparency=0.6;
Position=m(0,1,0,16);
BorderColor3=v(0,0,0);
Size=m(1,-2,1,-17);
BorderSizePixel=0;
BackgroundColor3=v(0,0,0)
});

local aq=library:create("Frame",{
Parent=ap;
Position=m(0,4,0,5);
BorderColor3=v(0,0,0);
Size=m(1,-8,0,0);
BackgroundTransparency=1;
BorderSizePixel=0;
BackgroundColor3=v(255,255,255)
});am.elements=aq
am.frame=ao

if am.autofill==false then
aq.AutomaticSize=Enum.AutomaticSize.Y;
ao.AutomaticSize=Enum.AutomaticSize.Y;
ao.Size=m(1,0,0,0);

library:create("UIPadding",{
Parent=aq,
Name="",
PaddingBottom=n(0,7)
})
else

local ar=Instance.new"BoolValue"
ar.Name="__autofill"
ar.Value=true
ar.Parent=ao

ao.Size=m(1,0,0,24)

local function find_listlayout(as)
for at,au in pairs(as:GetChildren())do
if au:IsA"UIListLayout"then
return au
end
end
end

local function apply_autofill()
local as=ao.Parent
if not as then return end

local at=find_listlayout(as)
if not at then return end

local au=at.AbsoluteContentSize.Y
local av=ao.AbsoluteSize.Y

local aw
local ax=-math.huge
for ay,az in pairs(as:GetChildren())do
local aA=az:FindFirstChild"__autofill"
if aA and aA.Value then
if az.AbsolutePosition.Y>ax then
ax=az.AbsolutePosition.Y
aw=az
end
end
end

if aw~=ao then
return
end

local ay=as.AbsoluteSize.Y-(au-av)
ay=math.floor(ay)
if ay<24 then
ay=24
end

if ay and ay>0 then
ao.Size=UDim2.new(1,0,0,ay)
end
end

local as=false
local function schedule()
if as then return end
as=true
task.delay(0.04,function()
as=false
pcall(apply_autofill)
end)
end

local at=ao.Parent
local au=find_listlayout(at)
if au then
library:connection(au:GetPropertyChangedSignal"AbsoluteContentSize",schedule)
end
library:connection(at:GetPropertyChangedSignal"AbsoluteSize",schedule)

library:connection(ao:GetPropertyChangedSignal"AbsoluteSize",schedule)

schedule()
end

library:create("UIListLayout",{
Parent=aq;
Padding=n(0,6);
SortOrder=Enum.SortOrder.LayoutOrder
});

library:create("TextLabel",{
FontFace=ae.TahomaBold;
TextColor3=v(255,255,255);
BorderColor3=v(0,0,0);
Text=am.name;
Parent=ao;
Size=m(1,0,0,0);
Position=m(0,4,0,2);
BackgroundTransparency=1;
TextXAlignment=Enum.TextXAlignment.Left;
BorderSizePixel=0;
AutomaticSize=Enum.AutomaticSize.Y;
TextSize=12;
BackgroundColor3=v(255,255,255)
});

library:create("UIListLayout",{
Parent=ScrollingFrame;
Padding=n(0,5);
SortOrder=Enum.SortOrder.LayoutOrder
});

return setmetatable(am,library)
end

function library.toggle(ak,al)
local am={
name=al.name or"Toggle",
flag=al.flag or al.name or"Flag",

default=al.default or false,
folding=al.folding or false,
callback=al.callback or function()end,

color=ak.color;
count=ak.count;
}

if al.enabled~=nil then
am.enabled=al.enabled
else
am.enabled=am.default
end

local ao=library:create("TextButton",{
Parent=ak.elements;
BackgroundTransparency=1;
Text="";
BorderColor3=v(0,0,0);
Size=m(1,0,0,12);
BorderSizePixel=0;
BackgroundColor3=v(255,255,255)
});

library:create("TextLabel",{
FontFace=ae.ProggyClean;
TextColor3=v(255,255,255);
BorderColor3=v(0,0,0);
Text=am.name;
Parent=ao;
Size=m(1,0,1,0);
Position=m(0,1,0,-1);
BackgroundTransparency=1;
TextXAlignment=Enum.TextXAlignment.Left;
BorderSizePixel=0;
AutomaticSize=Enum.AutomaticSize.X;
TextSize=12;
BackgroundColor3=v(255,255,255)
});

local ap=library:create("Frame",{
AnchorPoint=k(1,0);
Parent=ao;
Position=m(1,0,0,0);
BorderColor3=v(0,0,0);
Size=m(0,12,0,12);
BorderSizePixel=0;
BackgroundColor3=aa.preset[tostring(ak.count)]
});library:apply_theme(ap,tostring(ak.count),"BackgroundColor3");

local aq=library:create("Frame",{
Parent=ap;
Position=m(0,1,0,1);
BorderColor3=v(0,0,0);
Size=m(1,-2,1,-2);
BorderSizePixel=0;
BackgroundColor3=aa.preset[tostring(ak.count)]
});library:apply_theme(aq,tostring(ak.count),"BackgroundColor3");

library:create("UIListLayout",{
FillDirection=Enum.FillDirection.Horizontal;
HorizontalAlignment=Enum.HorizontalAlignment.Right;
Parent=right_components;
Padding=n(0,4);
SortOrder=Enum.SortOrder.LayoutOrder
});

local ar;

if am.folding then
ar=library:create("Frame",{
Parent=ak.elements;
BackgroundTransparency=1;
Position=m(0,4,0,21);
Size=m(1,0,0,0);
BorderSizePixel=0;
Visible=false;
AutomaticSize=Enum.AutomaticSize.Y;
BackgroundColor3=v(255,255,255)
});am.elements=ar

library:create("UIListLayout",{
Parent=ar;
Padding=n(0,6);
HorizontalAlignment=Enum.HorizontalAlignment.Right;
SortOrder=Enum.SortOrder.LayoutOrder
});
end

function am.set(as)
aq.BackgroundColor3=as and aa.preset[tostring(ak.count)]or aa.preset.inline
aq:SetAttribute("PrivToggleState",as)

ac[am.flag]=as

am.callback(as)

if am.folding then
ar.Visible=as
end
end

am.set(am.enabled)

ad[am.flag]=am.set

ao.MouseButton1Click:Connect(function()
am.enabled=not am.enabled
am.set(am.enabled)
end)

return setmetatable(am,library)
end

function library.list(ak,al)
local am={
callback=al and al.callback or function()end,
name=al.name or nil,

scale=al.size or 90,
items=al.items or{"1","2","3"},

visible=al.visible or true,

option_instances={},
current_instance=nil,
flag=al.flag or"flag",
}

local ao=library:create("Frame",{
BorderColor3=v(0,0,0);
AnchorPoint=k(1,0);
Parent=ak.elements;
Position=m(1,0,0,0);
Size=m(1,0,0,am.scale);
BorderSizePixel=0;
AutomaticSize=Enum.AutomaticSize.Y;
BackgroundColor3=aa.preset[tostring(ak.count)]
});library:apply_theme(ao,tostring(ak.count),"BackgroundColor3")

local ap=library:create("Frame",{
Parent=ao;
Position=m(0,1,0,1);
BorderColor3=v(0,0,0);
Size=m(1,-2,1,-2);
BorderSizePixel=0;
BackgroundColor3=v(35,35,35)
});library:apply_theme(ap,"inline","BackgroundColor3")

local aq=library:create("ScrollingFrame",{
ScrollBarImageColor3=v(0,0,0);
Active=true;
AutomaticCanvasSize=Enum.AutomaticSize.Y;
ScrollBarThickness=0;
Parent=ap;
Size=m(1,0,1,0);
LayoutOrder=-1;
BackgroundTransparency=1;
ScrollBarImageTransparency=1;
BorderColor3=v(0,0,0);
BackgroundColor3=v(0,0,0);
BorderSizePixel=0;
CanvasSize=m(0,0,0,0)
});

library:create("UIListLayout",{
Parent=aq;
Padding=n(0,6);
SortOrder=Enum.SortOrder.LayoutOrder
});

library:create("UIPadding",{
PaddingTop=n(0,2);
PaddingBottom=n(0,4);
Parent=aq;
PaddingRight=n(0,5);
PaddingLeft=n(0,5)
});

function am.render_option(ar)
local as=library:create("TextButton",{
FontFace=ae.ProggyClean;
TextColor3=v(170,170,170);
BorderColor3=v(0,0,0);
Text=ar;
AutoButtonColor=false;
BackgroundTransparency=1;
Parent=aq;
BorderSizePixel=0;
Size=m(1,0,0,0);
AutomaticSize=Enum.AutomaticSize.Y;
TextSize=12;
TextXAlignment=Enum.TextXAlignment.Center;
TextYAlignment=Enum.TextYAlignment.Center;
BackgroundColor3=v(255,255,255)
});

return as
end

function am.refresh_options(ar)
for as,at in am.option_instances do
at:Destroy()
end

for as,at in next,ar do
local au=am.render_option(at)

T(am.option_instances,au)

au.MouseButton1Click:Connect(function()
if am.current_instance and am.current_instance~=au then
am.current_instance.TextColor3=v(170,170,170)
end

am.current_instance=au
au.TextColor3=v(255,255,255)

ac[am.flag]=au.text

am.callback(au.text)
end)
end
end

function am.filter_options(ar)
for as,at in next,am.option_instances do
if string.find(at.Text,ar)then
at.Visible=true
else
at.Visible=false
end
end
end
































function am.set(ar)
for as,at in next,am.option_instances do
if at.Text==ar then
at.TextColor3=v(255,255,255)
else
at.TextColor3=v(170,170,170)
end
end

ac[am.flag]=ar
am.callback(ar)
end

am.refresh_options(am.items)

return setmetatable(am,library)
end

function library.slider(ak,al)
local am={
name=al.name or nil,
suffix=al.suffix or"",
flag=al.flag or al.name or"Flag",
callback=al.callback or function()end,

min=al.min or al.minimum or 0,
max=al.max or al.maximum or 100,
intervals=al.interval or al.decimal or 1,
default=al.default or 10,
value=al.default or 10,

ignore=al.ignore or false,
dragging=false,
}

local ao=library:create("Frame",{
Parent=ak.elements;
BackgroundTransparency=1;
BorderColor3=v(0,0,0);
Size=m(1,0,0,25);
BorderSizePixel=0;
BackgroundColor3=v(255,255,255)
});

local ap=library:create("TextLabel",{
FontFace=ae.ProggyClean;
TextColor3=v(255,255,255);
RichText=true;
BorderColor3=v(0,0,0);
Text="max distance : 5000";
Parent=ao;
Size=m(1,0,0,0);
Position=m(0,1,0,-2);
BackgroundTransparency=1;
TextXAlignment=Enum.TextXAlignment.Left;
BorderSizePixel=0;
AutomaticSize=Enum.AutomaticSize.XY;
TextSize=12;
BackgroundColor3=v(255,255,255)
});

local aq=library:create("TextButton",{
Parent=ao;
Text="";
AutoButtonColor=false;
Position=m(0,0,0,13);
BorderColor3=v(0,0,0);
Size=m(1,0,0,12);
BorderSizePixel=0;
BackgroundColor3=aa.preset[tostring(ak.count)]
});library:apply_theme(aq,tostring(ak.count),"BackgroundColor3")

local ar=library:create("Frame",{
Parent=aq;
Position=m(0,1,0,1);
BorderColor3=v(0,0,0);
Size=m(1,-2,1,-2);
BorderSizePixel=0;
BackgroundColor3=aa.preset.inline
});library:apply_theme(aq,"inline","BackgroundColor3")

local as=library:create("Frame",{
Parent=ar;
BorderColor3=v(0,0,0);
Size=m(0.5,0,1,0);
BorderSizePixel=0;
BackgroundColor3=aa.preset[tostring(ak.count)]
});library:apply_theme(as,tostring(ak.count),"BackgroundColor3")

function am.set(at)
local au=tonumber(at)

if au==nil then
return
end

am.value=S(library:round(au,am.intervals),am.min,am.max)

as.Size=m((am.value-am.min)/(am.max-am.min),0,1,0)
ap.Text=am.name.."<font color='#AAAAAA'>"..' - '..tostring(am.value)..am.suffix.."</font>"

ac[am.flag]=am.value

am.callback(ac[am.flag])
end

am.set(am.default)

aq.MouseButton1Down:Connect(function()
am.dragging=true
end)

library:connection(a.InputChanged,function(at)
if am.dragging and at.UserInputType==Enum.UserInputType.MouseMovement then
local au=(at.Position.X-ar.AbsolutePosition.X)/ar.AbsoluteSize.X
local av=((am.max-am.min)*au)+am.min

am.set(av)
end
end)

library:connection(a.InputEnded,function(at)
if at.UserInputType==Enum.UserInputType.MouseButton1 then
am.dragging=false
end
end)

am.set(am.default)

ad[am.flag]=am.set

return setmetatable(am,library)
end

function library.dropdown(ak,al)
local am={
name=al.name or nil,
flag=al.flag or al.name or"Flag",
items=al.items or{""},
callback=al.callback or function()end,
multi=al.multi or false,
scrolling=al.scrolling or false,

open=false,
option_instances={},
multi_items={},
ignore=al.ignore or false,
}

am.default=al.default or(am.multi and{am.items[1]})or am.items[1]or"None"

ac[am.flag]={}

local ao=library:create("Frame",{
Parent=ak.elements;
BackgroundTransparency=1;
BorderColor3=v(0,0,0);
Size=m(1,0,0,16);
BorderSizePixel=0;
BackgroundColor3=v(255,255,255)
});am.frame=ao

local ap=library:create("TextButton",{
AnchorPoint=k(1,0);
AutoButtonColor=false;
Text="";
Parent=ao;
Position=m(1,0,0,0);
BorderColor3=v(0,0,0);
Size=m(0,68,0,16);
BorderSizePixel=0;
BackgroundColor3=aa.preset[tostring(ak.count)]
});library:apply_theme(ap,tostring(ak.count),"BackgroundColor3")

local aq=library:create("Frame",{
Parent=ap;
Position=m(0,1,0,1);
BorderColor3=v(0,0,0);
Size=m(1,-2,1,-2);
BorderSizePixel=0;
BackgroundColor3=v(35,35,35)
});

local ar=library:create("TextLabel",{
FontFace=ae.ProggyClean;
TextColor3=v(255,255,255);
BorderColor3=v(0,0,0);
Text=am.name;
Parent=aq;
Size=m(1,0,1,0);
BackgroundTransparency=1;
Position=m(0,0,0,0);
BorderSizePixel=0;
AutomaticSize=Enum.AutomaticSize.X;
TextSize=12;
BackgroundColor3=v(255,255,255)
});

library:create("TextLabel",{
FontFace=ae.ProggyClean;
TextColor3=v(255,255,255);
BorderColor3=v(0,0,0);
Text=am.name;
Parent=ao;
Size=m(1,0,1,0);
Position=m(0,1,0,0);
BackgroundTransparency=1;
TextXAlignment=Enum.TextXAlignment.Left;
BorderSizePixel=0;
AutomaticSize=Enum.AutomaticSize.X;
TextSize=12;
BackgroundColor3=v(255,255,255)
});

local as=library:create("Frame",{
Parent=library.gui;
Size=m(0.0907348021864891,0,0.006218905560672283,20);
Position=m(0,500,0,100);
BorderColor3=v(0,0,0);
BorderSizePixel=0;
Visible=false;
AutomaticSize=Enum.AutomaticSize.Y;
BackgroundColor3=aa.preset[tostring(ak.count)]
});library:apply_theme(as,tostring(ak.count),"BackgroundColor3")

local at=library:create("Frame",{
Parent=as;
Size=m(1,-2,1,-2);
Position=m(0,1,0,1);
BorderColor3=v(0,0,0);
BorderSizePixel=0;
AutomaticSize=Enum.AutomaticSize.Y;
BackgroundColor3=aa.preset.inline
});library:apply_theme(at,"inline","BackgroundColor3")

library:create("UIListLayout",{
Parent=at;
Padding=n(0,6);
SortOrder=Enum.SortOrder.LayoutOrder
});

library:create("UIPadding",{
PaddingTop=n(0,5);
PaddingBottom=n(0,2);
Parent=at;
PaddingRight=n(0,1);
PaddingLeft=n(0,1)
});

library:create("UIPadding",{
PaddingBottom=n(0,2);
Parent=as
});

function am.render_option(au)
local av=library:create("TextButton",{
FontFace=ae.ProggyClean;
AutoButtonColor=false;
TextColor3=v(170,170,170);
BorderColor3=v(0,0,0);
Text=au;
Parent=at;
Size=m(1,0,0,0);
Position=m(0,0,0,1);
BackgroundTransparency=1;
TextXAlignment=Enum.TextXAlignment.Left;
BorderSizePixel=0;
AutomaticSize=Enum.AutomaticSize.Y;
TextSize=12;
BackgroundColor3=v(255,255,255)
});

return av
end

function am.set_visible(au)
as.Visible=au
end

local function update_label()
if am.open then
ar.Text="..."
return
end

local au=""
if am.multi then
au=W(am.multi_items,", ")
else
au=ac[am.flag]or am.default or""
end

ar.Text=au
end

function am.set(au)
local av={}
local aw=type(au)=="table"

if au==nil then
return
end

for ax,ay in next,am.option_instances do
if ay.Text==au or(aw and U(au,ay.Text))then
T(av,ay.Text)
am.multi_items=av
ay.TextColor3=v(255,255,255)
else
ay.TextColor3=v(170,170,170)
end
end

ac[am.flag]=if aw then av else av[1]
am.callback(ac[am.flag])

update_label()
end

function am.refresh_options(au)
for av,aw in next,am.option_instances do
aw:Destroy()
end

am.option_instances={}

for av,aw in next,au do
local ax=am.render_option(aw)

T(am.option_instances,ax)

ax.MouseButton1Down:Connect(function()
if am.multi then
local ay=U(am.multi_items,ax.Text)

if ay then
V(am.multi_items,ay)
else
T(am.multi_items,ax.Text)
end

am.set(am.multi_items)
else
am.set_visible(false)
am.open=false

am.set(ax.Text)
end
end)
end
end

am.refresh_options(am.items)

am.set(am.default)

ad[am.flag]=am.set

ap.MouseButton1Click:Connect(function()
am.open=not am.open

local au=ap.AbsolutePosition.X
local av=ap.AbsolutePosition.Y
local aw=ap.AbsoluteSize.Y

as.Size=UDim2.new(0,ap.AbsoluteSize.X,as.Size.Y.Scale,as.Size.Y.Offset)
as.Position=UDim2.new(0,au,0,av+aw+57)

am.set_visible(am.open)
update_label()
end)

a.InputEnded:Connect(function(au)
if au.UserInputType==Enum.UserInputType.MouseButton1 then
if not(library:mouse_in_frame(as)or library:mouse_in_frame(ao))then
am.open=false
am.set_visible(false)
update_label()
end
end
end)

return setmetatable(am,library)
end

function library.colorpicker(ak,al)
local am={
name=al.name or"Color",
flag=al.flag or al.name or"Flag",

color=al.color or u(1,1,1),
alpha=al.alpha and 1-al.alpha or 0,

open=false,
callback=al.callback or function()end,
}

local ao=library:create("TextButton",{
Parent=ak.elements;
BackgroundTransparency=1;
Text="";
AutoButtonColor=false;
BorderColor3=v(0,0,0);
Size=m(1,0,0,12);
BorderSizePixel=0;
BackgroundColor3=v(255,255,255)
});am.frame=ao

local ap=library:create("Frame",{
AnchorPoint=k(1,0);
Parent=ao;
Position=m(1,0,0,0);
BorderColor3=v(0,0,0);
Size=m(0,30,0,12);
BorderSizePixel=0;
BackgroundColor3=aa.preset[tostring(ak.count)]
});library:apply_theme(ap,tostring(ak.count),"BackgroundColor3")

local ar=library:create("Frame",{
Parent=ap;
Position=m(0,1,0,1);
BorderColor3=v(0,0,0);
Size=m(1,-2,1,-2);
BorderSizePixel=0;
BackgroundColor3=v(255,255,255)
});

library:create("TextLabel",{
FontFace=ae.ProggyClean;
TextColor3=v(255,255,255);
BorderColor3=v(0,0,0);
Text=am.name;
Parent=ao;
Size=m(1,0,1,0);
Position=m(0,1,0,0);
BackgroundTransparency=1;
TextXAlignment=Enum.TextXAlignment.Left;
BorderSizePixel=0;
AutomaticSize=Enum.AutomaticSize.X;
TextSize=12;
BackgroundColor3=v(255,255,255)
});

local as=library:create("Frame",{
Parent=library.gui;
Position=m(0.6888179183006287,0,0.24751244485378265,0);
BorderColor3=v(0,0,0);
Visible=false;
Size=m(0,150,0,150);
BorderSizePixel=0;
BackgroundColor3=aa.preset[tostring(ak.count)]
});library:apply_theme(as,tostring(ak.count),"BackgroundColor3")

local at=library:create("Frame",{
Parent=as;
BorderColor3=v(0,0,0);
Size=m(1,0,1,0);
BorderSizePixel=0;
BackgroundColor3=aa.preset[tostring(ak.count)]
});library:apply_theme(at,tostring(ak.count),"BackgroundColor3")

local au=library:create("Frame",{
Parent=at;
Position=m(0,1,0,1);
BorderColor3=v(0,0,0);
Size=m(1,-2,1,-2);
BorderSizePixel=0;
BackgroundColor3=v(0,0,0);
BackgroundTransparency=0.6;
ZIndex=-1
});

library:create("UIPadding",{
PaddingTop=n(0,7);
PaddingBottom=n(0,-13);
Parent=au;
PaddingRight=n(0,6);
PaddingLeft=n(0,7)
});

local av=library:create("Frame",{
Parent=au;
Position=m(0,0,1,-36);
BorderColor3=v(0,0,0);
Size=m(1,-1,0,16);
BorderSizePixel=0;
BackgroundColor3=aa.preset[tostring(ak.count)]
});library:apply_theme(av,tostring(ak.count),"BackgroundColor3")

local aw=library:create("TextBox",{
FontFace=ae.ProggyClean;
TextColor3=v(255,255,255);
BorderColor3=v(0,0,0);
Text="";
Parent=av;
BackgroundTransparency=0;
ClearTextOnFocus=false;
PlaceholderColor3=v(255,255,255);
Size=m(1,-2,1,-2);
Position=m(0,1,0,1);
BorderSizePixel=0;
TextSize=12;
TextXAlignment=Enum.TextXAlignment.Center;
BackgroundColor3=aa.preset.inline
});library:apply_theme(aw,"inline","BackgroundColor3")

local ax=library:create("TextButton",{
AnchorPoint=k(1,0);
Text="";
AutoButtonColor=false;
Parent=au;
Position=m(1,-1,0,0);
BorderColor3=v(0,0,0);
Size=m(0,14,1,-60);
BorderSizePixel=0;
BackgroundColor3=aa.preset.inline
});library:apply_theme(ax,"inline","BackgroundColor3")

local ay=library:create("Frame",{
Parent=ax;
Position=m(0,1,0,1);
BorderColor3=v(0,0,0);
Size=m(1,-2,1,-2);
BorderSizePixel=0;
BackgroundColor3=v(255,255,255)
});

library:create("UIGradient",{
Rotation=90;
Parent=ay;
Color=y{z(0,v(255,0,0)),z(0.17,v(255,255,0)),z(0.33,v(0,255,0)),z(0.5,v(0,255,255)),z(0.67,v(0,0,255)),z(0.83,v(255,0,255)),z(1,v(255,0,0))}
});

local az=library:create("Frame",{
Parent=ay;
BorderMode=Enum.BorderMode.Inset;
BorderColor3=v(0,0,0);
Size=m(1,2,0,3);
Position=m(0,-1,0,-1);
BackgroundColor3=v(255,255,255)
});

local aA=library:create("TextButton",{
AnchorPoint=k(0,0.5);
Text="";
AutoButtonColor=false;
Parent=au;
Position=m(0,0,1,-48);
BorderColor3=v(0,0,0);
Size=m(1,-1,0,14);
BorderSizePixel=0;
BackgroundColor3=aa.preset.inline
});library:apply_theme(aA,"inline","BackgroundColor3")

local aB=library:create("Frame",{
Parent=aA;
Position=m(0,1,0,1);
BorderColor3=v(0,0,0);
Size=m(1,-2,1,-2);
BorderSizePixel=0;
BackgroundColor3=v(0,221,255)
});

local aC=library:create("ImageLabel",{
ScaleType=Enum.ScaleType.Tile;
BorderColor3=v(0,0,0);
Parent=aB;
Image="rbxassetid://18274452449";
BackgroundTransparency=1;
Size=m(1,0,1,0);
TileSize=m(0,4,0,4);
BorderSizePixel=0;
BackgroundColor3=v(255,255,255)
});

library:create("UIGradient",{
Parent=aC;
Transparency=A{B(0,0),B(1,1)}
});

local aD=library:create("Frame",{
Parent=aB;
BorderMode=Enum.BorderMode.Inset;
BorderColor3=v(0,0,0);
Size=m(0,3,1,2);
Position=m(0,-1,0,-1);
BackgroundColor3=v(255,255,255)
});

local aE=library:create("TextButton",{
Parent=au;
BorderColor3=v(0,0,0);
Size=m(1,-20,1,-60);
Text="";
AutoButtonColor=false;
BorderSizePixel=0;
BackgroundColor3=aa.preset.inline
});library:apply_theme(aE,"inline","BackgroundColor3")

local aF=library:create("Frame",{
Parent=aE;
Position=m(0,1,0,1);
BorderColor3=v(0,0,0);
Size=m(1,-2,1,-2);
BorderSizePixel=0;
BackgroundColor3=v(0,221,255)
});

local aG=library:create("TextButton",{
Parent=aF;
Text="";
AutoButtonColor=false;
BorderColor3=v(0,0,0);
Size=m(1,0,1,0);
BorderSizePixel=0;
BackgroundColor3=v(255,255,255)
});

library:create("UIGradient",{
Parent=aG;
Transparency=A{B(0,0),B(1,1)}
});

local aH=library:create("Frame",{
Parent=aF;
BorderColor3=v(0,0,0);
Size=m(0,3,0,3);
BorderSizePixel=0;
BackgroundColor3=v(0,0,0)
});

library:create("Frame",{
Parent=aH;
Position=m(0,1,0,1);
BorderColor3=v(0,0,0);
Size=m(1,-2,1,-2);
BorderSizePixel=0;
BackgroundColor3=v(255,255,255)
});

local aI=library:create("TextButton",{
Parent=aF;
Text="";
AutoButtonColor=false;
Size=m(1,0,1,0);
BorderColor3=v(0,0,0);
ZIndex=2;
BorderSizePixel=0;
BackgroundColor3=v(255,255,255)
});

library:create("UIGradient",{
Rotation=270;
Transparency=A{B(0,0),B(1,1)};
Parent=aI;
Color=y{z(0,v(0,0,0)),z(1,v(0,0,0))}
});

local aJ=false
local aK=false
local aL=false

local aM,aN,aO=am.color:ToHSV()
local aP=am.alpha

ac[am.flag]={}

function am.set_visible(aQ)
as.Visible=aQ

as.Position=t(ar.AbsolutePosition.X-1,ar.AbsolutePosition.Y+ar.AbsoluteSize.Y+65)
end

function am.set(aQ,aR)
if aQ then
aM,aN,aO=aQ:ToHSV()
end

if aR then
aP=aR
end

local aS=Color3.fromHSV(aM,aN,aO)

az.Position=m(0,-1,aM,-1)
aD.Position=m(1-aP,-1,0,-1)
aH.Position=m(aN,-1,1-aO,-1)

aB.BackgroundColor3=Color3.fromHSV(aM,1,1)
ar.BackgroundColor3=aS
aF.BackgroundColor3=Color3.fromHSV(aM,1,1)

ac[am.flag]={
Color=aS;
Transparency=aP
}

local aT=ar.BackgroundColor3
aw.Text=string.format("%s, %s, %s, ",library:round(aT.R*255),library:round(aT.G*255),library:round(aT.B*255))
aw.Text..=library:round(1-aP,0.01)

am.callback(aS,aP)
end

function am.update_color()
local aQ=a:GetMouseLocation()
local aR=k(aQ.X,aQ.Y-F)

if aJ then
aN=math.clamp((aR-aE.AbsolutePosition).X/aE.AbsoluteSize.X,0,1)
aO=1-math.clamp((aR-aE.AbsolutePosition).Y/aE.AbsoluteSize.Y,0,1)
elseif aK then
aM=math.clamp((aR-ax.AbsolutePosition).Y/ax.AbsoluteSize.Y,0,1)
elseif aL then
aP=1-math.clamp((aR-aA.AbsolutePosition).X/aA.AbsoluteSize.X,0,1)
end

am.set(nil,nil)
end

am.set(am.color,am.alpha)

ad[am.flag]=am.set

ao.MouseButton1Click:Connect(function()
am.open=not am.open

am.set_visible(am.open)
end)

a.InputChanged:Connect(function(aQ)
if(aJ or aK or aL)and aQ.UserInputType==Enum.UserInputType.MouseMovement then
am.update_color()
end
end)

library:connection(a.InputEnded,function(aQ)
if aQ.UserInputType==Enum.UserInputType.MouseButton1 then
aJ=false
aK=false
aL=false

if not(library:mouse_in_frame(ao)or library:mouse_in_frame(as))then
am.open=false
am.set_visible(false)
end
end
end)

aA.MouseButton1Down:Connect(function()
aL=true
end)

ax.MouseButton1Down:Connect(function()
aK=true
end)

aI.MouseButton1Down:Connect(function()
print"hiu"
aJ=true
end)

aw.FocusLost:Connect(function()
local aQ,aR,aS,aT=library:convert(aw.Text)

if aQ and aR and aS and aT then
am.set(v(aQ,aR,aS),1-aT)
end
end)

return setmetatable(am,library)
end

function library.textbox(ak,al)
local am={
name=al.name or"...",
placeholder=al.placeholder or al.placeholdertext or al.holder or al.holdertext or"type here...",
default=al.default,
flag=al.flag or al.name or"Flag",
callback=al.callback or function()end,
visible=al.visible or true,
}

local ao=library:create("TextButton",{
AnchorPoint=k(1,0);
Text="";
AutoButtonColor=false;
Parent=ak.elements;
Position=m(1,0,0,0);
BorderColor3=v(0,0,0);
Size=m(1,0,0,16);
BorderSizePixel=0;
BackgroundColor3=aa.preset[tostring(ak.count)]
});library:apply_theme(ao,tostring(ak.count),"BackgroundColor3")

local ap=library:create("Frame",{
Parent=ao;
Position=m(0,1,0,1);
BorderColor3=v(0,0,0);
Size=m(1,-2,1,-2);
BorderSizePixel=0;
BackgroundColor3=aa.preset.inline
});library:apply_theme(ap,"inline","BackgroundColor3")

local ar=library:create("TextBox",{
Parent=ao,
Name="",
FontFace=ae.ProggyClean,
TextTruncate=Enum.TextTruncate.AtEnd,
TextSize=12,
Text="",
Size=m(1,-6,1,0),
RichText=true,
TextColor3=v(255,255,255),
BorderColor3=v(0,0,0),
CursorPosition=-1,
BackgroundTransparency=1,
TextXAlignment=Enum.TextXAlignment.Left,
Position=m(0,6,0,0),
BorderSizePixel=0,
PlaceholderColor3=v(170,170,170),
})

function am.set(as)
ac[am.flag]=as

ar.Text=as

am.callback(as)
end

ad[am.flag]=am.set

if am.default then
am.set(am.default)
end

ar:GetPropertyChangedSignal"Text":Connect(function()
am.set(ar.Text)
end)

return setmetatable(am,library)
end

function library.keybind(ak,al)
local am={
flag=al.flag or al.name or"Flag",
callback=al.callback or function()end,
open=false,
binding=nil,
name=al.name or nil,
ignore_key=al.ignore or false,

key=al.key or nil,
force_toggle=al.force_toggle or false,
mode=al.force_toggle and"toggle"or(al.mode or"toggle"),
active=al.default or false,

hold_instances={},
}

ac[am.flag]={}
T(library.keybinds,am)

local ao=library:create("Frame",{
Parent=ak.elements;
BackgroundTransparency=1;
BorderColor3=v(0,0,0);
Size=m(1,0,0,16);
BorderSizePixel=0;
BackgroundColor3=v(255,255,255)
});

local ap=library:create("TextButton",{
AnchorPoint=k(1,0);
AutoButtonColor=false;
Text="";
Parent=ao;
Position=m(1,0,0,0);
BorderColor3=v(0,0,0);
Size=m(0,68,0,16);
BorderSizePixel=0;
BackgroundColor3=aa.preset[tostring(ak.count)]
});library:apply_theme(ap,tostring(ak.count),"BackgroundColor3")

local ar=library:create("Frame",{
Parent=ap;
Position=m(0,1,0,1);
BorderColor3=v(0,0,0);
Size=m(1,-2,1,-2);
BorderSizePixel=0;
BackgroundColor3=v(35,35,35)
});

local as=library:create("TextLabel",{
FontFace=ae.ProggyClean;
TextColor3=v(255,255,255);
BorderColor3=v(0,0,0);
Text=am.name;
Parent=ar;
Size=m(1,0,1,0);
BackgroundTransparency=1;
Position=m(0,0,0,-1);
BorderSizePixel=0;
AutomaticSize=Enum.AutomaticSize.X;
TextSize=12;
BackgroundColor3=v(255,255,255)
});

library:create("TextLabel",{
FontFace=ae.ProggyClean;
TextColor3=v(255,255,255);
BorderColor3=v(0,0,0);
Text=am.name;
Parent=ao;
Size=m(1,0,1,0);
Position=m(0,1,0,0);
BackgroundTransparency=1;
TextXAlignment=Enum.TextXAlignment.Left;
BorderSizePixel=0;
AutomaticSize=Enum.AutomaticSize.X;
TextSize=12;
BackgroundColor3=v(255,255,255)
});

local au=library:create("Frame",{
Parent=library.gui;
Visible=false;
Size=m(0.0907348021864891,0,0.006218905560672283,20);
Position=m(0,500,0,100);
BorderColor3=v(0,0,0);
BorderSizePixel=0;
AutomaticSize=Enum.AutomaticSize.Y;
BackgroundColor3=aa.preset[tostring(ak.count)]
});library:apply_theme(au,tostring(ak.count),"BackgroundColor3")

local av=library:create("Frame",{
Parent=au;
Size=m(1,-2,1,-2);
Position=m(0,1,0,1);
BorderColor3=v(0,0,0);
BorderSizePixel=0;
AutomaticSize=Enum.AutomaticSize.Y;
BackgroundColor3=aa.preset.inline
});library:apply_theme(av,"inline","BackgroundColor3")

library:create("UIListLayout",{
Parent=av;
Padding=n(0,6);
SortOrder=Enum.SortOrder.LayoutOrder
});

library:create("UIPadding",{
PaddingTop=n(0,5);
PaddingBottom=n(0,2);
Parent=av;
PaddingRight=n(0,6);
PaddingLeft=n(0,6)
});

library:create("UIPadding",{
PaddingBottom=n(0,2);
Parent=au
});

local aw=am.force_toggle and{"Toggle"}or{"Hold","Toggle","Always"}

for ax,ay in aw do
local az=library:create("TextButton",{
FontFace=ae.ProggyClean;
TextColor3=v(170,170,170);
BorderColor3=v(0,0,0);
Text=ay;
Parent=av;
Position=m(0,0,0,1);
BackgroundTransparency=1;
TextXAlignment=Enum.TextXAlignment.Left;
BorderSizePixel=0;
AutomaticSize=Enum.AutomaticSize.XY;
TextSize=12;
BackgroundColor3=v(255,255,255)
});am.hold_instances[ay]=az

az.MouseButton1Click:Connect(function()
am.set(ay)

am.set_visible(false)

am.open=false
end)
end

function am.modify_mode_color(ax)
for ay,az in am.hold_instances do
az.TextColor3=v(170,170,170)
end

if am.hold_instances[ax]then
am.hold_instances[ax].TextColor3=v(255,255,255)
end
end

function am.set_mode(ax)
am.mode=am.force_toggle and"Toggle"or ax

if am.mode=="Always"then
am.set(true)
elseif am.mode=="Hold"then
am.set(false)
end

ac[am.flag].mode=am.mode
am.modify_mode_color(am.mode)
end

function am.set(ax)
if type(ax)=="boolean"then
local ay=ax

if am.mode=="Always"then
ay=true
end

am.active=ay
am.callback(ay)
elseif tostring(ax):find"Enum"then
ax=ax.Name=="Escape"and nil or ax

am.key=ax

am.callback(am.active or false)
elseif U({"Toggle","Hold","Always"},ax)then
am.set_mode(ax)

if ax=="Always"then
am.active=true
end

am.callback(am.active or false)
elseif type(ax)=="table"then
ax.key=type(ax.key)=="string"and ax.key~="..."and library:convert_enum(ax.key)or ax.key

ax.key=ax.key==Enum.KeyCode.Escape and nil or ax.key
am.key=ax.key

ax.mode=am.force_toggle and"Toggle"or(ax.mode or"Toggle")
am.mode=ax.mode
am.set_mode(ax.mode)

if ax.active then
am.active=ax.active
end
end

ac[am.flag]={
name=am.name,
mode=am.mode,
key=am.key,
active=am.active
}

library:update_keybind_visualizer()

local ay=am.key and tostring(am.key)~="Enums"and(ab[am.key]or tostring(am.key):gsub("Enum.",""))or nil
local az=ay and(tostring(ay):gsub("KeyCode.",""):gsub("UserInputType.",""))or"none"

as.Text=" "..az.." "

end

function am.set_visible(ax)
au.Visible=ax

au.Size=m(0,ap.AbsoluteSize.X,0,au.Size.Y.Offset)
au.Position=m(0,ap.AbsolutePosition.X,0,ap.AbsolutePosition.Y+77)
end

local function get_input_key(ax)
if ax.UserInputType==Enum.UserInputType.Keyboard then
return ax.KeyCode
end

return ax.UserInputType
end

ap.MouseButton1Down:Connect(function()
task.wait()
as.Text="..."

am.binding=library:connection(a.InputBegan,function(ax,ay)
am.set(get_input_key(ax))

am.binding:Disconnect()
am.binding=nil
end)
end)

ap.MouseButton2Down:Connect(function()
am.open=not am.open

am.set_visible(am.open)
end)

library:connection(a.InputBegan,function(ax,ay)
if ay then return end

local az=get_input_key(ax)
if az==am.key then
if am.mode=="Toggle"then
am.active=not am.active
am.set(am.active)
elseif am.mode=="Hold"then
am.set(true)
end
end
end)

library:connection(a.InputEnded,function(ax,ay)
if ay then
return
end

local az=get_input_key(ax)
if az==am.key then
if am.mode=="Hold"then
am.set(false)
end
end

if ax.UserInputType==Enum.UserInputType.MouseButton1 then
if not(library:mouse_in_frame(ap)or library:mouse_in_frame(au))then
am.open=false
am.set_visible(false)
end
end
end)

ad[am.flag]=am.set
am.set{mode=am.mode,active=am.active,key=am.key}

return setmetatable(am,library)
end

function library.button(ak,al)
local am={
name=al.name or"button",
callback=al.callback or function()end,
}

local ao=library:create("TextButton",{
AnchorPoint=k(1,0);
Text="";
AutoButtonColor=false;
Parent=ak.elements;
Position=m(1,0,0,0);
BorderColor3=v(0,0,0);
Size=m(0,136,0,16);
BorderSizePixel=0;
BackgroundColor3=aa.preset[tostring(ak.count)]
});library:apply_theme(ao,tostring(ak.count),"BackgroundColor3")

local ap=library:create("Frame",{
Parent=ao;
Position=m(0,1,0,1);
BorderColor3=v(0,0,0);
Size=m(1,-2,1,-2);
BorderSizePixel=0;
BackgroundColor3=aa.preset.inline
});library:apply_theme(ap,"inline","BackgroundColor3")

library:create("TextLabel",{
FontFace=ae.ProggyClean;
TextColor3=v(255,255,255);
BorderColor3=v(0,0,0);
Text=am.name;
Parent=ao;
Size=m(1,0,1,0);
BackgroundTransparency=1;
Position=m(0,1,0,-1);
BorderSizePixel=0;
AutomaticSize=Enum.AutomaticSize.X;
TextSize=12;
BackgroundColor3=v(255,255,255)
});

ao.MouseButton1Click:Connect(function()
am.callback()
end)

return setmetatable(am,library)
end

function library.init_config(ak,al)
local am;
local ao

for ap,as in next,al.tabs or{}do
if type(as.name)=="string"and as.name:lower()=="misc"then
ao=as
break
end
end

if not ao then
ao=al:tab{name="misc"}
end

local ap=ao:column{}
local as=ao:column{}
local au=ao:column{}

local av=ap:section{name="misc",size=1,default=true}
library.freecam_keybind=av:keybind{
name="freecam",
flag="freecam_key",
key=Enum.KeyCode.F4,
mode="toggle",
force_toggle=true,
callback=function(aw)
X.set_active(aw)
end,
}
av:dropdown{name="fov",flag="aimbot_fov_circle",items={"off","circle"},default="circle"}
av:colorpicker{name="fov color",flag="aimbot_fov_color",color=v(255,255,255)}

local aw=ap:section{name="movement",size=1,default=true,auto_fill=true}
aw:keybind{
name="speedhack",
flag="speedhack_key",
key=Enum.KeyCode.X,
mode="toggle",
}
aw:slider{name="speed",flag="speedhack_speed",min=12,max=200,default=16,interval=1,suffix="studs/s"}
aw:toggle{name="jump restriction",flag="no_jump_restrictions",default=false,enabled=false}

local ax=as:section{name="fov changer",auto_fill=true,size=1}
ax:toggle{name="enabled",flag="fov_changer_enabled",default=false,enabled=false}
ax:slider{name="amount",flag="fov_changer_amount",min=60,max=120,default=90,interval=1,suffix=""}
ax:keybind{
name="zoom key",
flag="fov_changer_zoom_key",
key=Enum.KeyCode.Z,
mode="Hold",
}
ax:slider{name="zoom amount",flag="fov_changer_zoom_amount",min=0,max=120,default=60,interval=1,suffix=""}

local ay=au:section{name="config",size=1,default=true}
ay:keybind{
name="menu key",
flag="menu_key",
key=Enum.KeyCode.Insert,
mode="toggle",
force_toggle=true,
ignore=true,
callback=function(az)
al.toggle_menu(az)
end,
}
af=ay:dropdown{name="config",options={"Report","This","Error","To","Finobe"},callback=function(az)if am then am.set(az)end end,flag="config_name_list"};library:update_config_list()
am=ay:textbox{name="Config name:",flag="config_name_text"}
ay:button{name="Save",callback=function()writefile(library.directory.."/configs/"..ac.config_name_text..".cfg",library:get_config())library:update_config_list()end}
ay:button{name="Load",callback=function()library:load_config(readfile(library.directory.."/configs/"..ac.config_name_text..".cfg"))library:update_config_list()end}
ay:button{name="Delete",callback=function()delfile(library.directory.."/configs/"..ac.config_name_text..".cfg")library:update_config_list()end}

local az=au:section{name="theme",size=1,default=true}
az:dropdown{
name="theme",
flag="theme",
items={"morytania","ancient","new","dark"},
callback=function(aA)
if aA=="ancient"then
local aB=v(109,78,110)
local aC=v(54,82,114)
local aD=v(0,88,126)

library:update_theme("1",aB)
library:update_theme("2",aC)
library:update_theme("3",aD)

library.gradient.Color=y{
z(0,aB),
z(0.5,aC),
z(1,aD),
};

library.watermark_gradient.Color=y{
z(0,aB),
z(0.5,aC),
z(1,aD),
};
elseif aA=="new"then
local aB=w"#360820"
local aC=w"#360820"
local aD=w"#360820"

library:update_theme("1",aB)
library:update_theme("2",aC)
library:update_theme("3",aD)

library.gradient.Color=y{
z(0,aB),
z(0.5,aC),
z(1,aD),
};

library.watermark_gradient.Color=y{
z(0,aB),
z(0.5,aC),
z(1,aD),
};
elseif aA=="dark"then
local aB=w"#1D1D1D"

library:update_theme("1",aB)
library:update_theme("2",aB)
library:update_theme("3",aB)

library.gradient.Color=y{
z(0,aB),
z(0.5,aB),
z(1,aB),
};

library.watermark_gradient.Color=y{
z(0,aB),
z(0.5,aB),
z(1,aB),
};
else
local aB=w"#245771"
local aC=w"#215D63"
local aD=w"#1E6453"

library:update_theme("1",aB)
library:update_theme("2",aC)
library:update_theme("3",aD)

library.gradient.Color=y{
z(0,aB),
z(0.5,aC),
z(1,aD),
};

library.watermark_gradient.Color=y{
z(0,aB),
z(0.5,aC),
z(1,aD),
};
end
end,
default="morytania"
}
end

local ak=library:window{
name="priv9.net | "..game:GetService"MarketplaceService":GetProductInfo(game.PlaceId).Name,
}

library:connection(a.InputBegan,function(al,am)

local ao=ac.menu_key

if ao and ao.key then
if al.KeyCode==ao.key then
ak.toggle_menu(not ak.main_outline.Visible)
end
elseif al.KeyCode==Enum.KeyCode.Insert then
ak.toggle_menu(not ak.main_outline.Visible)
end
end)

local al

local am=false
local ao=false
local ap=false

local as=ak:tab{name="rage"}
local au=as:column{}
local av=au:section{name="aimbot",auto_fill=false,size=0.3}
local aw=au:section{name="target selection",auto_fill=true,size=0.7}
local ax=av:toggle{name="enabled",flag="aimbot_enabled",default=false,enabled=false,callback=function(ax)
am=ax
ac.aimbot_enabled=ax
end}
ax.set(false)
ac.aimbot_enabled=false
av:keybind{name="aim key",flag="aim_key",key=Enum.UserInputType.MouseButton2,mode="Hold"}
av:toggle{name="silent",flag="aimbot_silent",default=false,enabled=false,callback=function(az)
ao=az
ac.aimbot_silent=az
end}
av:slider{name="smooth",flag="aimbot_smooth",min=0,max=10,default=1,interval=0.1,suffix=""}

aw:toggle{name="target team",flag="aimbot_target_team",default=false,enabled=false,callback=function(az)
ap=az
ac.aimbot_target_team=az
end}
aw:dropdown{name="hitbox",flag="aimbot_hitbox",items={"head","body"},default="body"}
aw:slider{name="fov",flag="aimbot_fov",min=0,max=360,default=40,interval=1,suffix=""}
aw:slider{name="max distance",flag="aimbot_max_distance",min=0,max=5000,default=0,interval=1,suffix=""}

local az=as:column{}
local aA=az:section{name="weapon modifications"}

aA:toggle{name="no-spread",flag="no_spread",default=false,enabled=false}
aA:slider{name="recoil multiplier",min=0,max=10,default=10,interval=0.1,suffix=""}
aA:slider{name="bullet thickness",min=0,max=10,default=10,interval=0.1,suffix=""}
aA:slider{name="bullet speed",min=0,max=10,default=10,interval=0.1,suffix=""}

az:section{name="other",auto_fill=true,size=0.7}

aA:button{name="Test notification",callback=function()
ag:create_notification{name="NOTIFICATION TESTING"}
end}

local aB=ak:tab{name="visuals"}
local aC=aB:column{}
local aD=aB:column{}
local aE=aB:column{}

local aF=aC:section{name="selection",size=1,default=true}
library:create_visuals_selection(aF)
library:apply_theme(aF.frame,tostring(aF.count),"BackgroundColor3")
local aG={}
local aH={
{id="player",label="player",center_label="filter (players)",right_label="options (player)"},
{id="misc",label="world",center_label="world",right_label="fog",auto_fill=false},
}

for aI,aJ in next,aH do

if aJ.id=="scientist"then

local aK=function()return tostring(math.random(1000,9999))end

local aL=aD:section{name="filter_"..aK(),auto_fill=false,size=0.5}
local aM=aD:section{name="details_"..aK(),auto_fill=false,size=0.5}

local aN=aE:section{name="options_"..aK(),auto_fill=false,size=0.5}
local aO=aE:section{name="meta_"..aK(),auto_fill=false,size=0.5}

aL:toggle{name="enable scientist",flag="scientist_enable"}
aM:slider{name="scientist power",min=0,max=100,default=50,interval=1,suffix=""}

aN:button{name="Apply",callback=function()ag:create_notification{name="Applied scientist settings"}end}
aO:dropdown{name="mode",flag="scientist_mode",items={"Alpha","Beta","Gamma"},default="Alpha"}

local aP=library:register_visuals_page(aJ.id,aJ.label,{aL,aM},{aN,aO})
aG[aJ.id]=aP
else
local aK=library:create_visuals_page(aD,aE,aJ)

local aL=library:register_visuals_page(aJ.id,aJ.label,aK.center,aK.right)
aG[aJ.id]=aL
end
end

do
local aI=aG.player
if aI and aI.center and aI.right then
local aJ=aI.center
local aK=aI.right

aJ:slider{name="max distance",flag="player_max_distance",min=0,max=5000,default=0,interval=1,suffix=""}
aJ:toggle{name="enabled",flag="Enabled",default=true,callback=function()if al then al.refresh_elements()end end}
aJ:toggle{name="teammates",flag="player_teammates",default=true,callback=function()if al then al.refresh_elements()end end}
aJ:toggle{name="local",flag="player_local",default=true,callback=function()if al then al.refresh_elements()end end}

aK:toggle{name="box",flag="Boxes",default=true,callback=function()if al then al.refresh_elements()end end}
aK:toggle{name="skeleton",flag="Skeletons",default=true,callback=function()if al then al.refresh_elements()end end}
aK:colorpicker{name="box/skel color",flag="Box_Color",callback=function(aL)
ac.Skeletons_Color={Color=aL}
if al then al.refresh_elements()end
end}
aK:toggle{name="health bar",flag="Healthbar",default=true,callback=function()if al then al.refresh_elements()end end}
aK:toggle{name="name",flag="Names",default=true,callback=function()if al then al.refresh_elements()end end}
aK:colorpicker{name="text color",flag="Name_Color",callback=function(aL)
ac.Distance_Color={Color=aL}
ac.Weapon_Color={Color=aL}
if al then al.refresh_elements()end
end}
aK:toggle{name="weapon",flag="Weapon",default=true,callback=function()if al then al.refresh_elements()end end}
aK:toggle{name="distance",flag="Distance",default=true,callback=function()if al then al.refresh_elements()end end}
aK:toggle{name="flags",flag="player_flags",callback=function()if al then al.refresh_elements()end end}
aK:toggle{name="offscreen arrow",flag="player_offscreen"}
aK:colorpicker{name="offscreen color",flag="player_offscreen_color"}

local aL,aM

aK:dropdown{name="model",flag="player_model",items={"off","ontop","occluded"},default="off",callback=function(aN)
local aO=aN~="off"

if aL and aL.frame then
aL.frame.Visible=aO
if not aO then
aL.open=false
aL.set_visible(false)
end
end

if aM and aM.frame then
aM.frame.Visible=aO
if not aO then
aM.open=false
aM.set_visible(false)
end
end

if al then al.refresh_elements()end
end}

aL=aK:colorpicker{name="fill",flag="player_highlight_fill",color=v(255,255,255),callback=function()
if al then al.refresh_elements()end
end}

aM=aK:colorpicker{name="outline",flag="player_highlight_outline",color=v(0,0,0),callback=function()
if al then al.refresh_elements()end
end}

aL.frame.Visible=false
aM.frame.Visible=false
end
end

do
local aI=aG.misc
if aI and aI.center and aI.right then
local aJ=aI.center
local aK=aI.right

aJ:toggle{name="enabled",flag="world_enabled",default=false}
aJ:slider{name="clock time",flag="world_clock_time",min=0,max=24,default=19.7,interval=0.1,suffix=""}
aJ:slider{name="brightness",flag="world_brightness",min=-20,max=20,default=20,interval=0.1,suffix=""}
aJ:toggle{name="global shadows",flag="world_global_shadows",default=true}
aJ:slider{name="exposure",flag="world_exposure",min=-20,max=20,default=-1,interval=0.1,suffix=""}
aJ:colorpicker{name="ambient",flag="world_ambient",color=v(75,136,174)}

aK:toggle{name="enabled",flag="fog_enabled",default=false}
aK:colorpicker{name="color",flag="fog_color",color=v(88,85,160)}
aK:slider{name="start",flag="fog_start",min=1,max=500,default=35,interval=1,suffix=""}
aK:slider{name="end",flag="fog_end",min=100,max=5000,default=1200,interval=100,suffix=""}
end
end

g.Heartbeat:Connect(function()
if ac.world_enabled then
f.ClockTime=ac.world_clock_time or 1
f.Brightness=ac.world_brightness or 2
f.GlobalShadows=ac.world_global_shadows~=false
f.ExposureCompensation=ac.world_exposure or 0

local aI=ac.world_ambient
if type(aI)=="table"and aI.Color then
f.Ambient=aI.Color
end
end

if ac.fog_enabled then
local aI=ac.fog_color
if type(aI)=="table"and aI.Color then
f.FogColor=aI.Color
end

f.FogStart=ac.fog_start or 11
f.FogEnd=ac.fog_end or 6000
end
end)

library:set_visuals_page"player"

ak:tab{name="misc"}

library:init_config(ak)

local aI=C.FieldOfView
local aJ=C.FieldOfView
local aK=false
local aL=0.12
local aM=aJ
local aN=aJ
local aO=aL

local function ease_in_out_expo(aP)
if aP<=0 or aP>=1 then
return aP
end
if aP<0.5 then
return math.pow(2,20*aP-10)/2
end
return(2-math.pow(2,-20*aP+10))/2
end

g:BindToRenderStep("PrivFOV",Enum.RenderPriority.Last.Value-1,function(aP)
local aQ=ac.fov_changer_zoom_key
local aR=type(aQ)=="table"and aQ.active
local aS=ac.fov_changer_enabled

local aT
if aS then
aT=aR and(ac.fov_changer_zoom_amount or 60)or(ac.fov_changer_amount or 90)
elseif aR then
aT=ac.fov_changer_zoom_amount or 60
end

if aT then
if not aK then
aI=C.FieldOfView
aK=true
aM=aJ
aN=aT
aO=0
elseif aN~=aT then
aM=aJ
aN=aT
aO=0
end
aO=aO+aP
local aU=ease_in_out_expo(math.min(1,aO/aL))
aJ=aM+(aN-aM)*aU
C.FieldOfView=math.max(1,aJ)
elseif aK then
if X:IsActive()then
aK=false
aJ=C.FieldOfView
else
if aN~=aI then
aM=aJ
aN=aI
aO=0
end
aO=aO+aP
local aU=ease_in_out_expo(math.min(1,aO/aL))
aJ=aM+(aN-aM)*aU
C.FieldOfView=math.max(1,aJ)
if aU>=1 then
aJ=aI
aK=false
end
end
elseif not X:IsActive()then
aJ=C.FieldOfView
aI=aJ
end
end)

local function get_effective_aimbot_fov()
local aP=ac.fov_changer_enabled and(ac.fov_changer_amount or 90)or aI
local aQ=aJ
if type(aP)~="number"or aP<=1 then
aP=70
end
if type(aQ)~="number"or aQ<=1 then
aQ=aP
end
local aR=math.tan(math.rad(aP/2))/math.tan(math.rad(aQ/2))
aR=math.clamp(aR,0.25,4)
return(ac.aimbot_fov or 0)*aR
end

local aP={autojump=nil,jumppower=nil,jumpheight=nil}
local aQ=false

g.Stepped:Connect(function(aR,aS)
local aT=D.Character
if not aT then
return
end

local aU=aT:FindFirstChildOfClass"Humanoid"
if not aU then
return
end

local aV=ac.speedhack_key
local aW=type(aV)=="table"and aV.active or false

if aW then
local aX=aU.RootPart or aT:FindFirstChild"HumanoidRootPart"
if aX and aU.Health>0 then
local aY=aU.MoveDirection
if aY.Magnitude>0 then

local Y=S(ac.speedhack_speed or 16,1,200)
aX.CFrame=aX.CFrame+aY*(Y*aS)
end
end
end

local aX=ac.no_jump_restrictions==true

if aX then
if not aQ then
aP.autojump=aU.AutoJumpEnabled
if aU.UseJumpPower then
aP.jumppower=aU.JumpPower
else
aP.jumpheight=aU.JumpHeight
end
aQ=true
end

aU.AutoJumpEnabled=true
aU.JumpHeight=50
aU.JumpPower=50

if a:IsKeyDown(Enum.KeyCode.Space)then
aU:ChangeState(Enum.HumanoidStateType.Jumping)
end
elseif aQ then
aU.AutoJumpEnabled=aP.autojump
if aU.UseJumpPower then
aU.JumpPower=aP.jumppower
else
aU.JumpHeight=aP.jumpheight
end
aQ=false
end
end)

local aR


local function get_aimbot_color()
local aS=ac.aimbot_fov_color
if type(aS)=="table"and aS.Color then
return aS.Color
elseif typeof(aS)=="Color3"then
return aS
end
return v(255,255,255)
end

local function get_aimbot_hit_part(aS)
local aT=ac.aimbot_hitbox or"body"
if aT=="head"and aS:FindFirstChild"Head"then
return aS.Head
end
return aS:FindFirstChild"HumanoidRootPart"
end

local function is_valid_aimbot_target(aS)
if aS==D then
return false
end

if not aS.Character or not aS.Character.Parent then
return false
end

local aT=aS.Character:FindFirstChildOfClass"Humanoid"
if not aT or aT.Health<=0 then
return false
end

local aU=aS.Character:FindFirstChild"HumanoidRootPart"
if not aU then
return false
end

local aV=D.Team
if aV and aS.Team==aV then
return ap==true
end

return true
end

local function get_closest_aimbot_target()
local aS
local aT=math.huge
local aU=get_effective_aimbot_fov()
local aV=ac.aimbot_max_distance or 0
local aW=Vector2.new(C.ViewportSize.X/2,C.ViewportSize.Y/2)

for aX,aY in ipairs(b:GetPlayers())do
if is_valid_aimbot_target(aY)and aY.Character then
local Y=get_aimbot_hit_part(aY.Character)
if Y then
local Z=aY.Character:FindFirstChild"HumanoidRootPart"
if Z then
local _=(Z.Position-C.CFrame.Position).Magnitude
if aV>0 and _>aV then
continue
end

local aZ,a_=C:WorldToScreenPoint(Y.Position)
if not a_ then
continue
end

local a0=e:GetGuiInset()
aZ=Vector2.new(aZ.X+a0.X,aZ.Y+a0.Y)

local a1=(aZ-aW).Magnitude
if a1<=aU and a1<aT then
aT=a1
aS=aY
end
end
end
end
end

return aS
end

local function update_aimbot_circle()
local aS=ac.aimbot_fov_circle or"off"

if aS=="circle"then
if not aR then
aR=Drawing.new"Circle"
aR.Thickness=1
aR.NumSides=64
aR.Filled=false
aR.Transparency=1
end

aR.Visible=true
aR.Position=Vector2.new(C.ViewportSize.X/2,C.ViewportSize.Y/2)
aR.Radius=get_effective_aimbot_fov()
aR.Color=get_aimbot_color()
else
if aR then
aR:Remove()
aR=nil
end
end
end

local function is_aim_key_active()
local aS=ac.aim_key
return aS and aS.active
end









if ac.aimbot_enabled==nil then ac.aimbot_enabled=false end
if ac.aimbot_silent==nil then ac.aimbot_silent=false end
if ac.aimbot_target_team==nil then ac.aimbot_target_team=false end
if ac.aimbot_fov==nil then ac.aimbot_fov=40 end
if ac.aimbot_max_distance==nil then ac.aimbot_max_distance=0 end
if ac.aimbot_smooth==nil then ac.aimbot_smooth=10 end
if ac.aimbot_fov_circle==nil then ac.aimbot_fov_circle="circle"end
if ac.aimbot_fov_color==nil then ac.aimbot_fov_color={Color=v(255,255,255)}end

g:BindToRenderStep("PrivAimbot",Enum.RenderPriority.Character.Value,function()
update_aimbot_circle()

local aS=false

if am and is_aim_key_active()then
local aT=get_closest_aimbot_target()
if aT and aT.Character then
local aU=get_aimbot_hit_part(aT.Character)
if aU and not ao then
local aV=C.CFrame
local aW=aV.Position
local aX=aU.Position

local aY=CFrame.lookAt(aW,aX,aV.UpVector)

local aZ=ac.aimbot_smooth or 0
local a_=aZ<=0 and 1 or math.clamp(1/(aZ+1),0.01,1)
C.CFrame=C.CFrame:Lerp(aY,a_)

if X:IsActive()then
X:SetOverride(C.CFrame)
end

aS=true
end
end
end

if not aS then
X:ClearOverride()
end
end)

task.spawn(function()
task.wait(1)
ag:create_notification{name="welcome "..string.lower(game.Players.LocalPlayer.Name).."!"}
end)

local aS={

{"Head","UpperTorso"},
{"UpperTorso","LowerTorso"},
{"UpperTorso","LeftUpperArm"},
{"UpperTorso","RightUpperArm"},
{"LeftUpperArm","LeftLowerArm"},
{"RightUpperArm","RightLowerArm"},
{"LeftLowerArm","LeftHand"},
{"RightLowerArm","RightHand"},
{"LowerTorso","LeftUpperLeg"},
{"LowerTorso","RightUpperLeg"},
{"LeftUpperLeg","LeftLowerLeg"},
{"RightUpperLeg","RightLowerLeg"},
{"LeftLowerLeg","LeftFoot"},
{"RightLowerLeg","RightFoot"},

}

ac.Health_High=ac.Health_High or{Color=v(0,255,0)}
ac.Health_Low=ac.Health_Low or{Color=v(255,0,0)}
ac.Box_Type=ac.Box_Type or"Normal"
if ac.Boxes==nil then ac.Boxes=true end
if ac.Names==nil then ac.Names=true end
if ac.Distance==nil then ac.Distance=true end
if ac.Weapon==nil then ac.Weapon=true end
if ac.Skeletons==nil then ac.Skeletons=true end
if ac.player_flags==nil then ac.player_flags=false end
if ac.player_local==nil then ac.player_local=true end
if ac.player_teammates==nil then ac.player_teammates=false end
if ac.player_max_distance==nil then ac.player_max_distance=0 end

if ac.player_model==nil then ac.player_model="off"end
ac.player_highlight_fill=ac.player_highlight_fill or{Color=v(255,255,255),Transparency=0}
ac.player_highlight_outline=ac.player_highlight_outline or{Color=v(0,0,0),Transparency=0}

local aT={};do
local aU=Register_Font("TahomaBold",700,"Normal",{
Id="TahomaBold.ttf",
Font=game:HttpGet"https://github.com/i77lhm/storage/raw/refs/heads/main/fonts/tahoma_bold.ttf",
})

local aV=Register_Font("SmallestPixel",400,"Normal",{
Id="SmallestPixel.ttf",
Font=game:HttpGet"https://github.com/i77lhm/storage/raw/refs/heads/main/fonts/smallest_pixel-7.ttf",
})

aT={
main=Font.new(aU,Enum.FontWeight.Regular,Enum.FontStyle.Normal);
secondary=Font.new(aV,Enum.FontWeight.Regular,Enum.FontStyle.Normal);
}
end

al={players={},screengui=Instance.new("ScreenGui",gethui()),cache=Instance.new("ScreenGui",gethui()),connections={}};do
al.screengui.IgnoreGuiInset=true
al.screengui.DisplayOrder=-1E3
al.screengui.Name="\0"

al.cache.Enabled=false

function al.get_screen_pos(aU,aV)
local aW=C.ViewportSize
local aX=C.CFrame:pointToObjectSpace(aV)

local aY=aW.x/aW.y
local aZ=-aX.z*math.tan(math.rad(C.FieldOfView/2))
local a_=aY*aZ

local a0=Vector3.new(-a_,aZ,aX.z)
local a1=aX-a0

local Y=a1.x/(a_*2)
local Z=-a1.y/(aZ*2)

local _=-aX.z>0 and Y>=0 and Y<=1 and Z>=0 and Z<=1

return Vector3.new(Y*aW.x,Z*aW.y,-aX.z),_
end

function al.box_solve(aU,aV)
if not aV then
return nil,nil,nil
end

local aW=aV.Position+(aV.CFrame.UpVector*1.8)+C.CFrame.UpVector
local aX=aV.Position-(aV.CFrame.UpVector*2.5)-C.CFrame.UpVector
local aY=(aV.Position-C.CFrame.p).Magnitude

local aZ,a_=al:get_screen_pos(aW)local
a0=al:get_screen_pos(aX)

local a1=math.max(math.floor(math.abs(aZ.X-a0.X)),3)
local Y=math.max(math.floor(math.max(math.abs(a0.Y-aZ.Y),a1/2)),3)
local Z=Vector2.new(math.floor(math.max(Y/1.5,a1)),Y)
local _=Vector2.new(math.floor(aZ.X*0.5+a0.X*0.5-Z.X*0.5),math.floor(math.min(aZ.Y,a0.Y)))

return Z,_,a_,aY

end

function al.create(aU,aV,aW)
local aX=Instance.new(aV)

for aY,aZ in aW do
aX[aY]=aZ
end

return aX
end

function al.create_object(aU,aV)
al[aV.Name]={
objects={},
info={
character=nil,
humanoid=nil,
rootpart=nil,
},
drawings={},
connections={},
player_connections={},
}
local aW=al[aV.Name]

local aX=aW.objects;do
aX.holder=al:create("Frame",{
Parent=al.screengui;
Name="\0";
BackgroundTransparency=1;
Position=m(0,0,0,0);
BorderColor3=v(0,0,0);
Size=m(0,0,0,0);
BorderSizePixel=0;
BackgroundColor3=v(255,255,255)
});

aX.box_outline=al:create("UIStroke",{
Parent=(ac.Boxes and ac.Box_Type~="Corner"and aX.holder)or al.cache;
LineJoinMode=Enum.LineJoinMode.Miter
});

aX.name=al:create("TextLabel",{
FontFace=aT.main;
Parent=aX.holder;
TextColor3=ac.Name_Color.Color;
BorderColor3=v(0,0,0);
Text=aV.Name;
Name="\0";
TextStrokeTransparency=0;
AnchorPoint=k(0.5,1);
Size=m(1,0,0,0);
BackgroundTransparency=1;
Position=m(0.5,0,0,-4);
BorderSizePixel=0;
AutomaticSize=Enum.AutomaticSize.Y;
TextSize=12;
});

aX.box_handler=al:create("Frame",{
Parent=(ac.Boxes and ac.Box_Type~="Corner"and aX.holder)or al.cache;
Name="\0";
BackgroundTransparency=1;
Position=m(0,1,0,1);
BorderColor3=v(0,0,0);
Size=m(1,-2,1,-2);
BorderSizePixel=0;
BackgroundColor3=v(255,255,255)
});

aX.box_color=al:create("UIStroke",{
Color=ac.Box_Color and ac.Box_Color.Color or v(255,255,255);
LineJoinMode=Enum.LineJoinMode.Miter;
Name="\0";
Parent=aX.box_handler
});

aX.outline=al:create("Frame",{
Parent=aX.box_handler;
Name="\0";
BackgroundTransparency=1;
Position=m(0,1,0,1);
BorderColor3=v(0,0,0);
Size=m(1,-2,1,-2);
BorderSizePixel=0;
BackgroundColor3=v(255,255,255)
});

aX.outline_stroke=al:create("UIStroke",{
Parent=aX.outline;
LineJoinMode=Enum.LineJoinMode.Miter;
Transparency=0;
});

aX.corners=al:create("Frame",{
Visible=true;
BorderColor3=v(0,0,0);
Parent=ac.Boxes and ac.Box_Type=="Corner"and aX.holder or al.cache;
BackgroundTransparency=1;
Position=m(0,-1,0,2);
Name="\0";
Size=m(1,0,1,0);
BorderSizePixel=0;
BackgroundColor3=v(255,255,255)
});

aX["1"]=al:create("Frame",{
Parent=aX.corners;
Name="line";
Position=m(0,0,0,-2);
BorderColor3=v(0,0,0);
Size=m(0.4,0,0,3);
BorderSizePixel=0;
BackgroundColor3=v(0,0,0)
});

al:create("Frame",{
Parent=aX["1"];
Position=m(0,1,0,1);
BorderColor3=v(0,0,0);
Size=m(1,-2,1,-2);
BorderSizePixel=0;
BackgroundColor3=ac.Box_Color.Color
});

aX["2"]=al:create("Frame",{
Parent=aX.corners;
Name="line";
Position=m(0,0,0,1);
BorderColor3=v(0,0,0);
Size=m(0,3,0.25,0);
BorderSizePixel=0;
BackgroundColor3=v(0,0,0)
});

al:create("Frame",{
Parent=aX["2"];
Position=m(0,1,0,-2);
BorderColor3=v(0,0,0);
Size=m(1,-2,1,1);
BorderSizePixel=0;
BackgroundColor3=ac.Box_Color.Color
});

aX["3"]=al:create("Frame",{
AnchorPoint=k(1,0);
Parent=aX.corners;
Name="line";
Position=m(1,0,0,-2);
BorderColor3=v(0,0,0);
Size=m(0.4,0,0,3);
BorderSizePixel=0;
BackgroundColor3=v(0,0,0)
});

al:create("Frame",{
Parent=aX["3"];
Position=m(0,1,0,1);
BorderColor3=v(0,0,0);
Size=m(1,-2,1,-2);
BorderSizePixel=0;
BackgroundColor3=ac.Box_Color.Color
});

aX["4"]=al:create("Frame",{
AnchorPoint=k(1,0);
Parent=aX.corners;
Name="line";
Position=m(1,0,0,1);
BorderColor3=v(0,0,0);
Size=m(0,3,0.25,0);
BorderSizePixel=0;
BackgroundColor3=v(0,0,0)
});

al:create("Frame",{
Parent=aX["4"];
Position=m(0,1,0,-2);
BorderColor3=v(0,0,0);
Size=m(1,-2,1,1);
BorderSizePixel=0;
BackgroundColor3=ac.Box_Color.Color
});

aX["5"]=al:create("Frame",{
AnchorPoint=k(0,1);
Parent=aX.corners;
Name="line";
Position=m(0,0,1,-2);
BorderColor3=v(0,0,0);
Size=m(0.4,0,0,3);
BorderSizePixel=0;
BackgroundColor3=v(0,0,0)
});

al:create("Frame",{
Parent=aX["5"];
Position=m(0,1,0,1);
BorderColor3=v(0,0,0);
Size=m(1,-2,1,-2);
BorderSizePixel=0;
BackgroundColor3=ac.Box_Color.Color
});

aX["6"]=al:create("Frame",{
BorderColor3=v(0,0,0);
Rotation=180;
Parent=aX.corners;
Name="line";
Position=m(0,0,1,-5);
AnchorPoint=k(0,1);
Size=m(0,3,0.25,0);
BorderSizePixel=0;
BackgroundColor3=v(0,0,0)
});

al:create("Frame",{
Parent=aX["6"];
Position=m(0,1,0,-2);
BorderColor3=v(0,0,0);
Size=m(1,-2,1,1);
BorderSizePixel=0;
BackgroundColor3=ac.Box_Color.Color
});

aX["7"]=al:create("Frame",{
AnchorPoint=k(1,1);
Parent=aX.corners;
Name="line";
Position=m(1,0,1,-2);
BorderColor3=v(0,0,0);
Size=m(0.4,0,0,3);
BorderSizePixel=0;
BackgroundColor3=v(0,0,0)
});

al:create("Frame",{
Parent=aX["7"];
Position=m(0,1,0,1);
BorderColor3=v(0,0,0);
Size=m(1,-2,1,-2);
BorderSizePixel=0;
BackgroundColor3=ac.Box_Color.Color
});

aX["7"]=al:create("Frame",{
BorderColor3=v(0,0,0);
Rotation=180;
Parent=aX.corners;
Name="line";
Position=m(1,0,1,-5);
AnchorPoint=k(1,1);
Size=m(0,3,0.25,0);
BorderSizePixel=0;
BackgroundColor3=v(0,0,0)
});

al:create("Frame",{
Parent=aX["7"];
Position=m(0,1,0,-2);
BorderColor3=v(0,0,0);
Size=m(1,-2,1,1);
BorderSizePixel=0;
BackgroundColor3=ac.Box_Color.Color
});

aX.healthbar_holder=al:create("Frame",{
AnchorPoint=k(1,0);
Parent=ac.Healthbar and aX.holder or al.cache;
Name="\0";
Position=m(0,-2,0,-1);
BorderColor3=v(0,0,0);
Size=m(0,4,1,2);
BorderSizePixel=0;
ClipsDescendants=true;
BackgroundColor3=v(0,0,0)
});

aX.healthbar=al:create("Frame",{
Parent=aX.healthbar_holder;
Name="\0";
Position=m(0,1,0,1);
BorderColor3=v(0,0,0);
Size=m(1,-2,1,-2);
BorderSizePixel=0;
BackgroundColor3=v(255,255,255)
});

aX.distance=al:create("TextLabel",{
FontFace=aT.secondary;
TextColor3=ac.Distance_Color.Color;
BorderColor3=v(0,0,0);
Text="38M";
Parent=ac.Distance and aX.holder or al.cache;
TextStrokeTransparency=1;
Name="\0";
Size=m(1,0,0,0);
BackgroundTransparency=1;
Position=m(0,0,1,8);
BorderSizePixel=0;
AutomaticSize=Enum.AutomaticSize.Y;
TextSize=9;
});
al:create("UIStroke",{
Parent=aX.distance;
Color=v(0,0,0);
LineJoinMode=Enum.LineJoinMode.Miter;
});

aX.flag=al:create("TextLabel",{
FontFace=aT.secondary;
TextColor3=ac.Distance_Color.Color;
BorderColor3=v(0,0,0);
Text="INVIS";
Parent=ac.player_flags and aX.holder or al.cache;
TextStrokeTransparency=1;
Name="\0";
AnchorPoint=k(1,0);
Size=m(0,0,0,0);
BackgroundTransparency=1;
Position=m(1,25,0,2);
BorderSizePixel=0;
AutomaticSize=Enum.AutomaticSize.X;
TextSize=9;
TextXAlignment=Enum.TextXAlignment.Right;
Visible=false;
});
al:create("UIStroke",{
Parent=aX.flag;
Color=v(0,0,0);
LineJoinMode=Enum.LineJoinMode.Miter;
});

aX.weapon=al:create("TextLabel",{
FontFace=aT.secondary;
TextColor3=ac.Weapon_Color.Color;
BorderColor3=v(0,0,0);
Text="[ak-47]";
Parent=al.cache;
TextStrokeTransparency=1;
Name="\0";
Size=m(1,0,0,0);
BackgroundTransparency=1;
Position=m(0,0,1,0);
BorderSizePixel=0;
AutomaticSize=Enum.AutomaticSize.Y;
TextSize=9;
});
al:create("UIStroke",{
Parent=aX.weapon;
Color=v(0,0,0);
LineJoinMode=Enum.LineJoinMode.Miter;
});

for aY,aZ in aS do
local a_=Drawing.new"Line"
a_.Color=ac.Skeletons_Color.Color;
a_.Thickness=1;
a_.Visible=false;

aW.drawings[#aW.drawings+1]=a_;
end

end

do
aW.health_changed=function(aY)
if not ac.Healthbar then
return
end

local aZ=aW.info.humanoid
if not aZ then
return
end

local a_=math.max(aY/aZ.MaxHealth,0.001)
local a0=ac.Health_Low.Color:Lerp(ac.Health_High.Color,a_)

aX.healthbar.Size=UDim2.new(1,-2,a_,-2)
aX.healthbar.Position=UDim2.new(0,1,1-a_,1)
aX.healthbar.BackgroundColor3=a0
end

aW.tool_added=function(aY)
if not aY:IsA"Tool"then
return
end

local aZ=aW.info.character:FindFirstChild(aY.Name)
aX.weapon.Text=aY.Name
aX.weapon.Parent=aZ and aX.holder or al.cache
aW.refresh_offsets()
end

aW.refresh_offsets=function()
local aY=aX.weapon.Parent==aX.holder

if aY then
aX.distance.Position=m(0,0,1,8)
aX.weapon.Position=m(0,0,1,0)
else
aX.distance.Position=m(0,0,1,0)
end
end

aW.refresh_descendants=function(aY)

aY=aY or aV.Character
if not aY or not aY.Parent then
return
end

local aZ=aY:WaitForChild("Humanoid",15)
if not aZ then
return
end

local a_=aY:FindFirstChild"HumanoidRootPart"

for a0,a1 in aW.connections do
a1:Disconnect()
end
aW.connections={}

aW.info.character=aY
aW.info.humanoid=aZ
aW.info.rootpart=a_

if aX.highlight then
aX.highlight:Destroy()
aX.highlight=nil
end

local a0=Instance.new"Highlight"
a0.Name="\0"
a0.Adornee=aY
a0.DepthMode=Enum.HighlightDepthMode.Occluded
a0.Enabled=false
a0.Parent=aY
aX.highlight=a0

aW.connections[#aW.connections+1]=aZ.HealthChanged:Connect(aW.health_changed)
aW.connections[#aW.connections+1]=aY.ChildAdded:Connect(aW.tool_added)
aW.connections[#aW.connections+1]=aY.ChildRemoved:Connect(aW.tool_added)

aW.health_changed(aW.info.humanoid.Health)
al.refresh_elements()
end
end

do

if aV.Character then
task.spawn(aW.refresh_descendants,aV.Character)
end

aW.player_connections[#aW.player_connections+1]=aV.CharacterAdded:Connect(function(aY)
task.spawn(aW.refresh_descendants,aY)
end)

aW.player_connections[#aW.player_connections+1]=aV.CharacterRemoving:Connect(function()

aW.info.character=nil
aW.info.humanoid=nil
aW.info.rootpart=nil

if aX.holder then
aX.holder.Visible=false
end

if aX.highlight then
aX.highlight.Enabled=false
end

for aY,aZ in aW.drawings do
aZ.Visible=false
end
end)

aW.player_connections[#aW.player_connections+1]=aV:GetPropertyChangedSignal"Team":Connect(function()
if al then
al.refresh_elements()
end
end)

local aY=aV.Character and aV.Character:FindFirstChildOfClass"Tool"

if aY then
aW.tool_added(aY)
end
end
end

function al.remove_object(aU,aV)
local aW=al[aV.Name]

if not aW then return end

for aX,aY in aW.connections do
aY:Disconnect()
end
aW.connections={}

for aX,aY in aW.player_connections do
aY:Disconnect()
end
aW.player_connections={}

local aX=aW.objects

for aY,aZ in aW.drawings do
aZ:Remove()
end

if aX.highlight then
aX.highlight:Destroy()
end

aX.holder:Destroy()
al[aV.Name]=nil
end

local function should_render_player(aU)
if aU==b.LocalPlayer then
return ac.player_local
end

local aV=b.LocalPlayer.Team
if aV and aU.Team==aV then
return ac.player_teammates
end

return true
end

local aU=v(31,236,66)

local function esp_color(aV,aW)
if aV==b.LocalPlayer then
return aU
end

if type(aW)=="table"and aW.Color then
return aW.Color
end

return aW
end

function al.refresh_elements()
for aV,aW in b:GetPlayers()do
local aX=al[aW.Name]

if not aX then

al:create_object(aW)
aX=al[aW.Name]
end

local aY=aX and aX.objects

if not aX or not aY then
continue
end

local aZ=should_render_player(aW)and aW.Character

if not aZ then
aY.holder.Parent=al.cache
aY.name.Parent=al.cache
aY.corners.Parent=al.cache
aY.box_handler.Parent=al.cache
aY.box_outline.Parent=al.cache
aY.healthbar_holder.Parent=al.cache
aY.weapon.Parent=al.cache
aY.distance.Parent=al.cache

if aY.highlight then
aY.highlight.Enabled=false
end

for a_,a0 in aX.drawings do
a0.Visible=false
end

aX.refresh_offsets()
continue
end

local a_=ac.Enabled and true or false
aY.holder.Parent=a_ and al.screengui or al.cache

aY.name.Parent=ac.Names and aY.holder or al.cache
aY.name.TextColor3=esp_color(aW,ac.Name_Color)

local a0=ac.Box_Type=="Corner"

if ac.Boxes then
aY.corners.Parent=(a0 and aY.holder)or al.cache
aY.box_handler.Parent=(a0 and al.cache or aY.holder)
aY.box_outline.Parent=(a0 and al.cache or aY.holder)
else
aY.corners.Parent=al.cache
aY.box_handler.Parent=al.cache
aY.box_outline.Parent=al.cache
end

aY.box_color.Color=esp_color(aW,ac.Box_Color)
aY.outline_stroke.Transparency=0
aY.flag.TextColor3=esp_color(aW,ac.Distance_Color)
aY.flag.Parent=ac.player_flags and aY.holder or al.cache

local a1=ac.player_model or"off"
if aY.highlight then
aY.highlight.Enabled=a_ and a1~="off"
aY.highlight.DepthMode=a1=="ontop"and Enum.HighlightDepthMode.AlwaysOnTop or Enum.HighlightDepthMode.Occluded

local Y=ac.player_highlight_fill or{Color=v(255,255,255),Transparency=0}
local Z=ac.player_highlight_outline or{Color=v(0,0,0),Transparency=0}

aY.highlight.FillColor=Y.Color
aY.highlight.FillTransparency=Y.Transparency or 0
aY.highlight.OutlineColor=Z.Color
aY.highlight.OutlineTransparency=Z.Transparency or 0
end

local function is_character_invisible(Y)
for Z,_ in ipairs(Y:GetDescendants())do
if _:IsA"BasePart"then
local a2=_.Transparency+(_.LocalTransparencyModifier or 0)
if a2<1 then
return false
end
end
end
return true
end

aY.flag.Visible=ac.player_flags and is_character_invisible(aW.Character)

for a2,Y in aY.corners:GetChildren()do
if Y:IsA"GuiObject"then
Y.BackgroundColor3=esp_color(aW,ac.Box_Color)
end
end

local a2=ak.main_outline and ak.main_outline.Visible

for Y,Z in aX.drawings do
Z.Color=esp_color(aW,ac.Skeletons_Color)
Z.Visible=ac.Skeletons and a_ and not a2
end

aY.healthbar_holder.Parent=ac.Healthbar and aY.holder or al.cache

aY.weapon.TextColor3=esp_color(aW,ac.Weapon_Color)
aY.weapon.Parent=ac.Weapon and aW.Character:FindFirstChildOfClass"Tool"and aY.holder or al.cache

aY.distance.TextColor3=esp_color(aW,ac.Distance_Color)
aY.distance.Parent=ac.Distance and aY.holder or al.cache

aX.refresh_offsets()
end
end

al.connection=g:BindToRenderStep("PrivESP",Enum.RenderPriority.Last.Value,function()
if not ac.Enabled then
return
end

local function set_highlight(aV,aW)
local aX=aV and aV.objects and aV.objects.highlight
if aX then
aX.Enabled=aW
end
end

for aV,aW in b:GetPlayers()do

if not al[aW.Name]then
al:create_object(aW)
end

if not should_render_player(aW)then
local aX=al[aW.Name]
if aX then
if aX.objects and aX.objects.holder then
aX.objects.holder.Visible=false
end
set_highlight(aX,false)
for aY,aZ in aX.drawings do
aZ.Visible=false
end
end
continue
end

local aX=al[aW.Name]

if not aX then
continue
end

local aY=aX.info.character
local aZ=aX.info.humanoid

if not(aY and aZ)then
if aX.objects and aX.objects.holder then
aX.objects.holder.Visible=false
end
set_highlight(aX,false)
for a_,a0 in aX.drawings do
a0.Visible=false
end
continue
end

local a_=aX.objects

if not a_ then
continue
end

local a0=aZ:GetState()
if aZ.Health<=0 or a0==Enum.HumanoidStateType.Dead then
local a1=a_.holder
a1.Visible=false
set_highlight(aX,false)
for a2,Y in aX.drawings do
Y.Visible=false
end
continue
end

local a1=aZ.RootPart or aY:FindFirstChild"HumanoidRootPart"
if not a1 then
local a2=a_.holder
if a2 then
a2.Visible=false
end
set_highlight(aX,false)
for Y,Z in aX.drawings do
Z.Visible=false
end
continue
end

local a2,Y,Z,_=al:box_solve(a1)
local a3=a_.holder

local a4=ac.player_max_distance or 0
if a4>0 and _ and _>a4 then
a3.Visible=false
set_highlight(aX,false)
for a5,a6 in aX.drawings do
a6.Visible=false
end
continue
end

if not Z then
a3.Visible=false
set_highlight(aX,false)
for a5,a6 in aX.drawings do
a6.Visible=false
end
continue
end

if a3.Visible~=Z then
a3.Visible=Z
end

set_highlight(aX,(ac.player_model or"off")~="off")

local a5=_ and _/3.28 or 0
if a5>250 then
a_.outline_stroke.Transparency=1
else
a_.outline_stroke.Transparency=0
end

local function is_character_invisible(a6)
for a7,a8 in ipairs(a6:GetDescendants())do
if a8:IsA"BasePart"then
local a9=a8.Transparency+(a8.LocalTransparencyModifier or 0)
if a9<1 then
return false
end
end
end
return true
end

a_.flag.Visible=ac.player_flags and is_character_invisible(aY)

local a6=ak.main_outline and ak.main_outline.Visible

if ac.Skeletons and not a6 then
for a7=1,#aS do
local a8,a9=aS[a7][1],aS[a7][2]

if not aX.drawings[a7]then
continue
end

local ba=aX.drawings[a7]

local bb=aY:FindFirstChild(a8)
local bc=aY:FindFirstChild(a9)

if bb and bc then
local bd,be=al:get_screen_pos(bb.Position)
local bf,bg=al:get_screen_pos(bc.Position)

if be and bg then
ba.Visible=true
ba.From=Vector2.new(bd.X,bd.Y)
ba.To=Vector2.new(bf.X,bf.Y)
else
ba.Visible=false
end
else
ba.Visible=false
end
end
else
for a7=1,#aS do
if aX.drawings[a7]then
aX.drawings[a7].Visible=false
end
end
end

aX.refresh_offsets()

local a7=t(Y.X,Y.Y)
if a7~=a3.Position then
a3.Position=t(Y.X,Y.Y)
end

local a8=t(a2.X,a2.Y)
if a8~=a3.Size then
a3.Size=a8
end

local a9=a_.distance
local ba=math.round(_/3.28)
if a9.Text~=tostring(ba).."M"then
a9.Text=tostring(ba).."M"
end
end
end)

function al.unload(aV)
for aW,aX in b:GetPlayers()do
al:remove_object(aX)
end

al.connection:Disconnect()
g:UnbindFromRenderStep"PrivESP"
al.player_added:Disconnect()
al.player_removed:Disconnect()

al.cache:Destroy()
al.screengui:Destroy()

al=nil
end

end

for aU,aV in b:GetPlayers()do
al:create_object(aV)
end

al.player_added=b.PlayerAdded:Connect(function(aU)
al:create_object(aU)
end)

al.player_removed=b.PlayerRemoving:Connect(function(aU)
al:remove_object(aU)
end)

task.wait()
al.refresh_elements()
