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

local C=c.CurrentCamera or c:FindFirstChildOfClass"Camera"
c:GetPropertyChangedSignal"CurrentCamera":Connect(function()
local D=c.CurrentCamera
if D then
C=D
end
end)
local D=b.LocalPlayer
local E=D:GetMouse()
local F=e:GetGuiInset().Y

D:GetPropertyChangedSignal"Team":Connect(function()
if esp then
esp.refresh_elements()
end
end)

local G=math.max
local H=math.floor
local I=math.min
local J=math.abs local K=
math.noise
local L=math.rad local M=
math.random local N=
math.pow local O=
math.sin local P=
math.pi
local Q=math.tan local R=
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
mode="hold",
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
ax:slider{name="zoom amount",flag="fov_changer_zoom_amount",min=5,max=60,default=25,interval=1,suffix=""}

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



local aI={
ClockTime=f.ClockTime,
Brightness=f.Brightness,
GlobalShadows=f.GlobalShadows,
ExposureCompensation=f.ExposureCompensation,
Ambient=f.Ambient,
FogColor=f.FogColor,
FogStart=f.FogStart,
FogEnd=f.FogEnd,
}

local aJ=false
local aK=false

g.Heartbeat:Connect(function()
local aL=ac.world_enabled
if aL~=aJ then
aJ=aL
if not aL then

f.ClockTime=aI.ClockTime
f.Brightness=aI.Brightness
f.GlobalShadows=aI.GlobalShadows
f.ExposureCompensation=aI.ExposureCompensation
f.Ambient=aI.Ambient
end
end

if aL then
f.ClockTime=ac.world_clock_time or 1
f.Brightness=ac.world_brightness or 2
f.GlobalShadows=ac.world_global_shadows~=false
f.ExposureCompensation=ac.world_exposure or 0

local aM=ac.world_ambient
if type(aM)=="table"and aM.Color then
f.Ambient=aM.Color
end
end

local aM=ac.fog_enabled
if aM~=aK then
aK=aM
if not aM then

f.FogColor=aI.FogColor
f.FogStart=aI.FogStart
f.FogEnd=aI.FogEnd
end
end

if aM then
local aN=ac.fog_color
if type(aN)=="table"and aN.Color then
f.FogColor=aN.Color
end

f.FogStart=ac.fog_start or 11
f.FogEnd=ac.fog_end or 6000
end
end)

library:set_visuals_page"player"

ak:tab{name="misc"}

library:init_config(ak)

local aL=C.FieldOfView
local aM=C.FieldOfView
local aN=false
local aO=0.12
local aP=aM
local aQ=aM
local aR=aO

local function ease_in_out_expo(aS)
if aS<=0 or aS>=1 then
return aS
end
if aS<0.5 then
return math.pow(2,20*aS-10)/2
end
return(2-math.pow(2,-20*aS+10))/2
end














g.Heartbeat:Connect(function(aS)
local aT=ac.fov_changer_zoom_key
local aU=type(aT)=="table"and(aT.active or false)
local aV=ac.fov_changer_enabled

local aW=aU and(ac.fov_changer_zoom_amount or 60)
or(aV and(ac.fov_changer_amount or 90))
or nil

if aW then
if not aN then
aM=C.FieldOfView
aL=aM
aP=aM
aQ=aW
aR=0
aN=true
elseif aQ~=aW then
aP=aM
aQ=aW
aR=0
end
elseif aN then
if aQ~=aL then
aP=aM
aQ=aL
aR=0
end
else
aL=C.FieldOfView
aM=aL
end

if aN then
aR=aR+aS
local aX=ease_in_out_expo(math.min(1,aR/aO))
aM=aP+(aQ-aP)*aX
C.FieldOfView=math.max(1,aM)

if not aW and aX>=1 then
aM=aL
aN=false
end
end
end)





C:GetPropertyChangedSignal"FieldOfView":Connect(function()
if aN then
local aS=C.FieldOfView
if math.abs(aS-aM)>0.5 then
aL=aS
C.FieldOfView=math.max(1,aM)
end
end
end)

local function get_effective_aimbot_fov()
local aS=ac.fov_changer_enabled and(ac.fov_changer_amount or 90)or aL
local aT=aM
if type(aS)~="number"or aS<=1 then
aS=70
end
if type(aT)~="number"or aT<=1 then
aT=aS
end
local aU=math.tan(math.rad(aS/2))/math.tan(math.rad(aT/2))
aU=math.clamp(aU,0.25,4)
return(ac.aimbot_fov or 0)*aU
end

local aS={autojump=nil,jumppower=nil,jumpheight=nil}
local aT=false

g.Stepped:Connect(function(aU,aV)
local aW=D.Character
if not aW then
return
end

local aX=aW:FindFirstChildOfClass"Humanoid"
if not aX then
return
end

local aY=ac.speedhack_key
local Y=type(aY)=="table"and aY.active or false

if Y then
local Z=aX.RootPart or aW:FindFirstChild"HumanoidRootPart"
if Z and aX.Health>0 then
local _=aX.MoveDirection
if _.Magnitude>0 then

local aZ=S(ac.speedhack_speed or 16,1,200)
Z.CFrame=Z.CFrame+_*(aZ*aV)
end
end
end

local aZ=ac.no_jump_restrictions==true

if aZ then
if not aT then
aS.autojump=aX.AutoJumpEnabled
if aX.UseJumpPower then
aS.jumppower=aX.JumpPower
else
aS.jumpheight=aX.JumpHeight
end
aT=true
end

aX.AutoJumpEnabled=true
aX.JumpHeight=50
aX.JumpPower=50

if a:IsKeyDown(Enum.KeyCode.Space)then
aX:ChangeState(Enum.HumanoidStateType.Jumping)
end
elseif aT then
aX.AutoJumpEnabled=aS.autojump
if aX.UseJumpPower then
aX.JumpPower=aS.jumppower
else
aX.JumpHeight=aS.jumpheight
end
aT=false
end
end)

local aU


local function get_aimbot_color()
local aV=ac.aimbot_fov_color
if type(aV)=="table"and aV.Color then
return aV.Color
elseif typeof(aV)=="Color3"then
return aV
end
return v(255,255,255)
end

local function get_aimbot_hit_part(aV)
local aW=ac.aimbot_hitbox or"body"
if aW=="head"and aV:FindFirstChild"Head"then
return aV.Head
end
return aV:FindFirstChild"HumanoidRootPart"
end

local function is_valid_aimbot_target(aV)
if aV==D then
return false
end

if not aV.Character or not aV.Character.Parent then
return false
end

local aW=aV.Character:FindFirstChildOfClass"Humanoid"
if not aW or aW.Health<=0 then
return false
end

local aX=aV.Character:FindFirstChild"HumanoidRootPart"
if not aX then
return false
end

local aY=D.Team
if aY and aV.Team==aY then
return ap==true
end

return true
end

local function get_closest_aimbot_target()
local aV
local aW=math.huge
local aX=get_effective_aimbot_fov()
local aY=ac.aimbot_max_distance or 0
local aZ=Vector2.new(C.ViewportSize.X/2,C.ViewportSize.Y/2)

for Y,Z in ipairs(b:GetPlayers())do
if is_valid_aimbot_target(Z)and Z.Character then
local _=get_aimbot_hit_part(Z.Character)
if _ then
local a_=Z.Character:FindFirstChild"HumanoidRootPart"
if a_ then
local a0=(a_.Position-C.CFrame.Position).Magnitude
if aY>0 and a0>aY then
continue
end

local a1,a2=C:WorldToScreenPoint(_.Position)
if not a2 then
continue
end

local a3=e:GetGuiInset()
a1=Vector2.new(a1.X+a3.X,a1.Y+a3.Y)

local a4=(a1-aZ).Magnitude
if a4<=aX and a4<aW then
aW=a4
aV=Z
end
end
end
end
end

return aV
end

local function update_aimbot_circle()
local aV=ac.aimbot_fov_circle or"off"

if aV=="circle"then
if not aU then
aU=Drawing.new"Circle"
aU.Thickness=1
aU.NumSides=64
aU.Filled=false
aU.Transparency=1
end

aU.Visible=true
aU.Position=Vector2.new(C.ViewportSize.X/2,C.ViewportSize.Y/2)
aU.Radius=get_effective_aimbot_fov()
aU.Color=get_aimbot_color()
else
if aU then
aU:Remove()
aU=nil
end
end
end

local function is_aim_key_active()
local aV=ac.aim_key
return aV and aV.active
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

local aV=false

if am and is_aim_key_active()then
local aW=get_closest_aimbot_target()
if aW and aW.Character then
local aX=get_aimbot_hit_part(aW.Character)
if aX and not ao then
local aY=C.CFrame
local aZ=aY.Position
local a_=aX.Position

local a0=CFrame.lookAt(aZ,a_,aY.UpVector)

local a1=ac.aimbot_smooth or 0
local a2=a1<=0 and 1 or math.clamp(1/(a1+1),0.01,1)
C.CFrame=C.CFrame:Lerp(a0,a2)

if X:IsActive()then
X:SetOverride(C.CFrame)
end

aV=true
end
end
end

if not aV then
X:ClearOverride()
end
end)

task.spawn(function()
task.wait(1)
ag:create_notification{name="welcome "..string.lower(game.Players.LocalPlayer.Name).."!"}
end)

local aV={

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

local aW={};do
local aX=Register_Font("TahomaBold",700,"Normal",{
Id="TahomaBold.ttf",
Font=game:HttpGet"https://github.com/i77lhm/storage/raw/refs/heads/main/fonts/tahoma_bold.ttf",
})

local aY=Register_Font("SmallestPixel",400,"Normal",{
Id="SmallestPixel.ttf",
Font=game:HttpGet"https://github.com/i77lhm/storage/raw/refs/heads/main/fonts/smallest_pixel-7.ttf",
})

aW={
main=Font.new(aX,Enum.FontWeight.Regular,Enum.FontStyle.Normal);
secondary=Font.new(aY,Enum.FontWeight.Regular,Enum.FontStyle.Normal);
}
end

al={players={},screengui=Instance.new("ScreenGui",gethui()),cache=Instance.new("ScreenGui",gethui()),connections={}};do
al.screengui.IgnoreGuiInset=true
al.screengui.DisplayOrder=-1E3
al.screengui.Name="\0"

al.cache.Enabled=false

local aX=math.sqrt
local aY=math.round

local aZ,a_,a0=0,0,0
local a1,a2,a3=1,0,0
local a4,Y,Z=0,1,0
local _,a5,a6=0,0,-1
local a7=1
local a8,a9=0,0
local ba,bb=1,1
local bc=false

local function begin_frame()
local bd=C
if not bd then
bc=false
return
end

local be=bd.CFrame
local bf=be.Position
local bg=be.RightVector
local bh=be.UpVector
local bi=be.LookVector
local bj=bd.ViewportSize

aZ,a_,a0=bf.x,bf.y,bf.z
a1,a2,a3=bg.x,bg.y,bg.z
a4,Y,Z=bh.x,bh.y,bh.z
_,a5,a6=bi.x,bi.y,bi.z
ba,bb=bj.x,bj.y
a8,a9=bj.x*0.5,bj.y*0.5

local bk=bd.FieldOfView
if type(bk)~="number"or bk<=0 or bk>=180 then
bk=70
end
a7=a9/Q(L(bk*0.5))
bc=true
end

local function project(bd,be,bf)
if not bc then
return nil
end

local bg=bd-aZ
local bh=be-a_
local bi=bf-a0

local bj=bg*_+bh*a5+bi*a6
if bj<=0 then
return nil
end

local bk=bg*a1+bh*a2+bi*a3
local bl=bg*a4+bh*Y+bi*Z

local bm=1/bj
local bn=a8+bk*a7*bm
local bo=a9-bl*a7*bm

return bn,bo,bj
end

function al.get_screen_pos(bd,be)
if not C then
return Vector3.new(-99999,-99999,0),false
end

local bf=C.ViewportSize
if bf.x<=0 or bf.y<=0 then
return Vector3.new(-99999,-99999,0),false
end

local bg=C.CFrame:pointToObjectSpace(be)
if-bg.z<=0 then
return Vector3.new(-99999,-99999,0),false
end

local bh=C.FieldOfView
if type(bh)~="number"or bh<=0 or bh>=180 then
bh=70
end

local bi=bf.x/bf.y
local bj=-bg.z*math.tan(math.rad(bh/2))
local bk=bi*bj

local bl=Vector3.new(-bk,bj,bg.z)
local bm=bg-bl

local bn=bm.x/(bk*2)
local bo=-bm.y/(bj*2)

local bp=bn>=0 and bn<=1 and bo>=0 and bo<=1

return Vector3.new(bn*bf.x,bo*bf.y,-bg.z),bp
end

function al.box_solve(bd,be,bf)
if not be then
return nil,nil,nil
end

if not bc then
local bg=be.Position+(be.CFrame.UpVector*1.8)+C.CFrame.UpVector
local bh=be.Position-(be.CFrame.UpVector*2.5)-C.CFrame.UpVector
bf=bf or(be.Position-C.CFrame.p).Magnitude

local bi,bj=al:get_screen_pos(bg)
local bk=al:get_screen_pos(bh)

local bl=math.max(math.floor(math.abs(bi.X-bk.X)),3)
local bm=math.max(math.floor(math.max(math.abs(bk.Y-bi.Y),bl/2)),3)
local bn=Vector2.new(math.floor(math.max(bm/1.5,bl)),bm)
local bo=Vector2.new(math.floor(bi.X*0.5+bk.X*0.5-bn.X*0.5),math.floor(math.min(bi.Y,bk.Y)))

return bn,bo,bj,bf
end

local bg=be.Position
local bh,bi,bj=bg.x,bg.y,bg.z
local bk=be.CFrame.UpVector
local bl,bm,bn=bk.x,bk.y,bk.z

bf=bf or aX((bh-aZ)*(bh-aZ)+(bi-a_)*(bi-a_)+(bj-a0)*(bj-a0))

local bo,bp=project(bh+bl*1.8+a4,bi+bm*1.8+Y,bj+bn*1.8+Z)
local bq,br=project(bh-bl*2.5-a4,bi-bm*2.5-Y,bj-bn*2.5-Z)

if not bo then
bo,bp=-99999,-99999
end
if not bq then
bq,br=-99999,-99999
end

local bs=bo>=0 and bo<=ba and bp>=0 and bp<=bb

local bt=G(H(J(bo-bq)),3)
local bu=G(H(G(J(br-bp),bt/2)),3)
local bv=k(H(G(bu/1.5,bt)),bu)
local bw=k(H(bo*0.5+bq*0.5-bv.X*0.5),H(I(bp,br)))

return bv,bw,bs,bf

end

function al.create(bd,be,bf)
local bg=Instance.new(be)

for bh,bi in bf do
bg[bh]=bi
end

return bg
end

function al.create_object(bd,be)
al[be.Name]={
objects={},
info={
character=nil,
humanoid=nil,
rootpart=nil,
bones=nil,
tool=nil,
invisible=false,
flag_checked=0,
},
drawings={},
connections={},
player_connections={},
}
local bf=al[be.Name]

local bg=bf.objects;do
bg.holder=al:create("Frame",{
Parent=al.screengui;
Name="\0";
BackgroundTransparency=1;
Position=m(0,0,0,0);
BorderColor3=v(0,0,0);
Size=m(0,0,0,0);
BorderSizePixel=0;
BackgroundColor3=v(255,255,255)
});

bg.box_outline=al:create("UIStroke",{
Parent=(ac.Boxes and ac.Box_Type~="Corner"and bg.holder)or al.cache;
LineJoinMode=Enum.LineJoinMode.Miter
});

bg.name=al:create("TextLabel",{
FontFace=aW.main;
Parent=bg.holder;
TextColor3=ac.Name_Color.Color;
BorderColor3=v(0,0,0);
Text=be.Name;
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

bg.box_handler=al:create("Frame",{
Parent=(ac.Boxes and ac.Box_Type~="Corner"and bg.holder)or al.cache;
Name="\0";
BackgroundTransparency=1;
Position=m(0,1,0,1);
BorderColor3=v(0,0,0);
Size=m(1,-2,1,-2);
BorderSizePixel=0;
BackgroundColor3=v(255,255,255)
});

bg.box_color=al:create("UIStroke",{
Color=ac.Box_Color and ac.Box_Color.Color or v(255,255,255);
LineJoinMode=Enum.LineJoinMode.Miter;
Name="\0";
Parent=bg.box_handler
});

bg.outline=al:create("Frame",{
Parent=bg.box_handler;
Name="\0";
BackgroundTransparency=1;
Position=m(0,1,0,1);
BorderColor3=v(0,0,0);
Size=m(1,-2,1,-2);
BorderSizePixel=0;
BackgroundColor3=v(255,255,255)
});

bg.outline_stroke=al:create("UIStroke",{
Parent=bg.outline;
LineJoinMode=Enum.LineJoinMode.Miter;
Transparency=0;
});

bg.corners=al:create("Frame",{
Visible=true;
BorderColor3=v(0,0,0);
Parent=ac.Boxes and ac.Box_Type=="Corner"and bg.holder or al.cache;
BackgroundTransparency=1;
Position=m(0,-1,0,2);
Name="\0";
Size=m(1,0,1,0);
BorderSizePixel=0;
BackgroundColor3=v(255,255,255)
});

bg["1"]=al:create("Frame",{
Parent=bg.corners;
Name="line";
Position=m(0,0,0,-2);
BorderColor3=v(0,0,0);
Size=m(0.4,0,0,3);
BorderSizePixel=0;
BackgroundColor3=v(0,0,0)
});

al:create("Frame",{
Parent=bg["1"];
Position=m(0,1,0,1);
BorderColor3=v(0,0,0);
Size=m(1,-2,1,-2);
BorderSizePixel=0;
BackgroundColor3=ac.Box_Color.Color
});

bg["2"]=al:create("Frame",{
Parent=bg.corners;
Name="line";
Position=m(0,0,0,1);
BorderColor3=v(0,0,0);
Size=m(0,3,0.25,0);
BorderSizePixel=0;
BackgroundColor3=v(0,0,0)
});

al:create("Frame",{
Parent=bg["2"];
Position=m(0,1,0,-2);
BorderColor3=v(0,0,0);
Size=m(1,-2,1,1);
BorderSizePixel=0;
BackgroundColor3=ac.Box_Color.Color
});

bg["3"]=al:create("Frame",{
AnchorPoint=k(1,0);
Parent=bg.corners;
Name="line";
Position=m(1,0,0,-2);
BorderColor3=v(0,0,0);
Size=m(0.4,0,0,3);
BorderSizePixel=0;
BackgroundColor3=v(0,0,0)
});

al:create("Frame",{
Parent=bg["3"];
Position=m(0,1,0,1);
BorderColor3=v(0,0,0);
Size=m(1,-2,1,-2);
BorderSizePixel=0;
BackgroundColor3=ac.Box_Color.Color
});

bg["4"]=al:create("Frame",{
AnchorPoint=k(1,0);
Parent=bg.corners;
Name="line";
Position=m(1,0,0,1);
BorderColor3=v(0,0,0);
Size=m(0,3,0.25,0);
BorderSizePixel=0;
BackgroundColor3=v(0,0,0)
});

al:create("Frame",{
Parent=bg["4"];
Position=m(0,1,0,-2);
BorderColor3=v(0,0,0);
Size=m(1,-2,1,1);
BorderSizePixel=0;
BackgroundColor3=ac.Box_Color.Color
});

bg["5"]=al:create("Frame",{
AnchorPoint=k(0,1);
Parent=bg.corners;
Name="line";
Position=m(0,0,1,-2);
BorderColor3=v(0,0,0);
Size=m(0.4,0,0,3);
BorderSizePixel=0;
BackgroundColor3=v(0,0,0)
});

al:create("Frame",{
Parent=bg["5"];
Position=m(0,1,0,1);
BorderColor3=v(0,0,0);
Size=m(1,-2,1,-2);
BorderSizePixel=0;
BackgroundColor3=ac.Box_Color.Color
});

bg["6"]=al:create("Frame",{
BorderColor3=v(0,0,0);
Rotation=180;
Parent=bg.corners;
Name="line";
Position=m(0,0,1,-5);
AnchorPoint=k(0,1);
Size=m(0,3,0.25,0);
BorderSizePixel=0;
BackgroundColor3=v(0,0,0)
});

al:create("Frame",{
Parent=bg["6"];
Position=m(0,1,0,-2);
BorderColor3=v(0,0,0);
Size=m(1,-2,1,1);
BorderSizePixel=0;
BackgroundColor3=ac.Box_Color.Color
});

bg["7"]=al:create("Frame",{
AnchorPoint=k(1,1);
Parent=bg.corners;
Name="line";
Position=m(1,0,1,-2);
BorderColor3=v(0,0,0);
Size=m(0.4,0,0,3);
BorderSizePixel=0;
BackgroundColor3=v(0,0,0)
});

al:create("Frame",{
Parent=bg["7"];
Position=m(0,1,0,1);
BorderColor3=v(0,0,0);
Size=m(1,-2,1,-2);
BorderSizePixel=0;
BackgroundColor3=ac.Box_Color.Color
});

bg["7"]=al:create("Frame",{
BorderColor3=v(0,0,0);
Rotation=180;
Parent=bg.corners;
Name="line";
Position=m(1,0,1,-5);
AnchorPoint=k(1,1);
Size=m(0,3,0.25,0);
BorderSizePixel=0;
BackgroundColor3=v(0,0,0)
});

al:create("Frame",{
Parent=bg["7"];
Position=m(0,1,0,-2);
BorderColor3=v(0,0,0);
Size=m(1,-2,1,1);
BorderSizePixel=0;
BackgroundColor3=ac.Box_Color.Color
});

bg.healthbar_holder=al:create("Frame",{
AnchorPoint=k(1,0);
Parent=ac.Healthbar and bg.holder or al.cache;
Name="\0";
Position=m(0,-2,0,-1);
BorderColor3=v(0,0,0);
Size=m(0,4,1,2);
BorderSizePixel=0;
ClipsDescendants=true;
BackgroundColor3=v(0,0,0)
});

bg.healthbar=al:create("Frame",{
Parent=bg.healthbar_holder;
Name="\0";
Position=m(0,1,0,1);
BorderColor3=v(0,0,0);
Size=m(1,-2,1,-2);
BorderSizePixel=0;
BackgroundColor3=v(255,255,255)
});

bg.distance=al:create("TextLabel",{
FontFace=aW.secondary;
TextColor3=ac.Distance_Color.Color;
BorderColor3=v(0,0,0);
Text="38M";
Parent=ac.Distance and bg.holder or al.cache;
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
Parent=bg.distance;
Color=v(0,0,0);
LineJoinMode=Enum.LineJoinMode.Miter;
});

bg.flag=al:create("TextLabel",{
FontFace=aW.secondary;
TextColor3=ac.Distance_Color.Color;
BorderColor3=v(0,0,0);
Text="INVIS";
Parent=ac.player_flags and bg.holder or al.cache;
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
Parent=bg.flag;
Color=v(0,0,0);
LineJoinMode=Enum.LineJoinMode.Miter;
});

bg.weapon=al:create("TextLabel",{
FontFace=aW.secondary;
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
Parent=bg.weapon;
Color=v(0,0,0);
LineJoinMode=Enum.LineJoinMode.Miter;
});

for bh,bi in aV do
local bj=Drawing.new"Line"
bj.Color=ac.Skeletons_Color.Color;
bj.Thickness=1;
bj.Visible=false;

bf.drawings[#bf.drawings+1]=bj;
end

end

do
bf.health_changed=function(bh)
if not ac.Healthbar then
return
end

local bi=bf.info.humanoid
if not bi then
return
end

local bj=math.max(bh/bi.MaxHealth,0.001)
local bk=ac.Health_Low.Color:Lerp(ac.Health_High.Color,bj)

bg.healthbar.Size=UDim2.new(1,-2,bj,-2)
bg.healthbar.Position=UDim2.new(0,1,1-bj,1)
bg.healthbar.BackgroundColor3=bk
end

bf.refresh_bones=function()
local bh=bf.info.character
local bi={}
if bh then
for bj=1,#aV do
local bk=aV[bj]
local bl=bh:FindFirstChild(bk[1])
local bm=bh:FindFirstChild(bk[2])
if bl and bm then
bi[bj]={bl,bm}
end
end
end
bf.info.bones=bi
end

bf.tool_added=function(bh)
if not bh:IsA"Tool"then
return
end

local bi=bf.info.character
local bj=bi and bi:FindFirstChild(bh.Name)

if bj then
bf.info.tool=bh
bg.weapon.Text=bh.Name
bg.weapon.Parent=bg.holder
else
bf.info.tool=nil
bg.weapon.Parent=al.cache
end

bf.refresh_offsets()
end

bf.refresh_offsets=function()
local bh=bg.weapon.Parent==bg.holder

if bh then
bg.distance.Position=m(0,0,1,8)
bg.weapon.Position=m(0,0,1,0)
else
bg.distance.Position=m(0,0,1,0)
end
end

bf.refresh_descendants=function(bh)

bh=bh or be.Character
if not bh or not bh.Parent then
return
end

local bi=bh:WaitForChild("Humanoid",15)
if not bi then
return
end

local bj=bh:FindFirstChild"HumanoidRootPart"

for bk,bl in bf.connections do
bl:Disconnect()
end
bf.connections={}

bf.info.character=bh
bf.info.humanoid=bi
bf.info.rootpart=bj
bf.info.invisible=false
bf.info.flag_checked=0

if bg.highlight then
bg.highlight:Destroy()
bg.highlight=nil
end

local bk=Instance.new"Highlight"
bk.Name="\0"
bk.Adornee=bh
bk.DepthMode=Enum.HighlightDepthMode.Occluded
bk.Enabled=false
bk.Parent=bh
bg.highlight=bk

bf.connections[#bf.connections+1]=bi.HealthChanged:Connect(bf.health_changed)
bf.connections[#bf.connections+1]=bh.ChildAdded:Connect(function(bl)
bf.refresh_bones()
bf.tool_added(bl)
end)
bf.connections[#bf.connections+1]=bh.ChildRemoved:Connect(function(bl)
bf.refresh_bones()
bf.tool_added(bl)
end)

bf.refresh_bones()

local bl=bh:FindFirstChildOfClass"Tool"
if bl then
bf.tool_added(bl)
else
bf.info.tool=nil
bg.weapon.Parent=al.cache
bf.refresh_offsets()
end

bf.health_changed(bf.info.humanoid.Health)
al.refresh_elements()
end
end

do

if be.Character then
task.spawn(bf.refresh_descendants,be.Character)
end

bf.player_connections[#bf.player_connections+1]=be.CharacterAdded:Connect(function(bh)
task.spawn(bf.refresh_descendants,bh)
end)

bf.player_connections[#bf.player_connections+1]=be.CharacterRemoving:Connect(function()

bf.info.character=nil
bf.info.humanoid=nil
bf.info.rootpart=nil

if bg.holder then
bg.holder.Visible=false
end

if bg.highlight then
bg.highlight.Enabled=false
end

for bh,bi in bf.drawings do
bi.Visible=false
end
end)

bf.player_connections[#bf.player_connections+1]=be:GetPropertyChangedSignal"Team":Connect(function()
if al then
al.refresh_elements()
end
end)

local bh=be.Character and be.Character:FindFirstChildOfClass"Tool"

if bh then
bf.tool_added(bh)
end
end
end

function al.remove_object(bd,be)
local bf=al[be.Name]

if not bf then return end

for bg,bh in bf.connections do
bh:Disconnect()
end
bf.connections={}

for bg,bh in bf.player_connections do
bh:Disconnect()
end
bf.player_connections={}

local bg=bf.objects

for bh,bi in bf.drawings do
bi:Remove()
end

if bg.highlight then
bg.highlight:Destroy()
end

bg.holder:Destroy()
al[be.Name]=nil
end

local function should_render_player(bd)
if bd==b.LocalPlayer then
return ac.player_local
end

local be=b.LocalPlayer.Team
if be and bd.Team==be then
return ac.player_teammates
end

return true
end

local bd=v(31,236,66)

local function esp_color(be,bf)
if be==b.LocalPlayer then
return bd
end

if type(bf)=="table"and bf.Color then
return bf.Color
end

return bf
end

local function is_character_invisible(be)
for bf,bg in ipairs(be:GetDescendants())do
if bg:IsA"BasePart"then
local bh=bg.Transparency+(bg.LocalTransparencyModifier or 0)
if bh<1 then
return false
end
end
end
return true
end

local function set_highlight(be,bf)
local bg=be and be.objects and be.objects.highlight
if bg and bg.Enabled~=bf then
bg.Enabled=bf
end
end

function al.refresh_elements()
for be,bf in b:GetPlayers()do
local bg=al[bf.Name]

if not bg then

al:create_object(bf)
bg=al[bf.Name]
end

local bh=bg and bg.objects

if not bg or not bh then
continue
end

local bi=should_render_player(bf)and bf.Character

if not bi then
bh.holder.Parent=al.cache
bh.name.Parent=al.cache
bh.corners.Parent=al.cache
bh.box_handler.Parent=al.cache
bh.box_outline.Parent=al.cache
bh.healthbar_holder.Parent=al.cache
bh.weapon.Parent=al.cache
bh.distance.Parent=al.cache

if bh.highlight then
bh.highlight.Enabled=false
end

for bj,bk in bg.drawings do
bk.Visible=false
end

bg.refresh_offsets()
continue
end

local bj=ac.Enabled and true or false
bh.holder.Parent=bj and al.screengui or al.cache

bh.name.Parent=ac.Names and bh.holder or al.cache
bh.name.TextColor3=esp_color(bf,ac.Name_Color)

local bk=ac.Box_Type=="Corner"

if ac.Boxes then
bh.corners.Parent=(bk and bh.holder)or al.cache
bh.box_handler.Parent=(bk and al.cache or bh.holder)
bh.box_outline.Parent=(bk and al.cache or bh.holder)
else
bh.corners.Parent=al.cache
bh.box_handler.Parent=al.cache
bh.box_outline.Parent=al.cache
end

bh.box_color.Color=esp_color(bf,ac.Box_Color)
bh.outline_stroke.Transparency=0
bh.flag.TextColor3=esp_color(bf,ac.Distance_Color)
bh.flag.Parent=ac.player_flags and bh.holder or al.cache

local bl=ac.player_model or"off"
if bh.highlight then
bh.highlight.Enabled=bj and bl~="off"
bh.highlight.DepthMode=bl=="ontop"and Enum.HighlightDepthMode.AlwaysOnTop or Enum.HighlightDepthMode.Occluded

local bm=ac.player_highlight_fill or{Color=v(255,255,255),Transparency=0}
local bn=ac.player_highlight_outline or{Color=v(0,0,0),Transparency=0}

bh.highlight.FillColor=bm.Color
bh.highlight.FillTransparency=bm.Transparency or 0
bh.highlight.OutlineColor=bn.Color
bh.highlight.OutlineTransparency=bn.Transparency or 0
end

bh.flag.Visible=ac.player_flags and is_character_invisible(bf.Character)

for bm,bn in bh.corners:GetChildren()do
if bn:IsA"GuiObject"then
bn.BackgroundColor3=esp_color(bf,ac.Box_Color)
end
end

local bm=ak.main_outline and ak.main_outline.Visible

for bn,bo in bg.drawings do
bo.Color=esp_color(bf,ac.Skeletons_Color)
bo.Visible=ac.Skeletons and bj and not bm
end

bh.healthbar_holder.Parent=ac.Healthbar and bh.holder or al.cache

bh.weapon.TextColor3=esp_color(bf,ac.Weapon_Color)
bh.weapon.Parent=ac.Weapon and bf.Character:FindFirstChildOfClass"Tool"and bh.holder or al.cache

bh.distance.TextColor3=esp_color(bf,ac.Distance_Color)
bh.distance.Parent=ac.Distance and bh.holder or al.cache

bg.refresh_offsets()
end
end

al.connection=g:BindToRenderStep("PrivESP",Enum.RenderPriority.Last.Value,function()
if not ac.Enabled then
return
end

begin_frame()
if not bc then
return
end

local be=ac.Skeletons
local bf=ac.player_flags
local bg=ac.player_model or"off"
local bh=ac.player_max_distance or 0
local bi=ac.Distance
local bj=ac.Weapon
local bk=ak.main_outline and ak.main_outline.Visible
local bl=be and not bk
local bm=tick()

for bn,bo in b:GetPlayers()do

if not al[bo.Name]then
al:create_object(bo)
end

if not should_render_player(bo)then
local bp=al[bo.Name]
if bp then
if bp.objects and bp.objects.holder then
bp.objects.holder.Visible=false
end
set_highlight(bp,false)
for bq,br in bp.drawings do
br.Visible=false
end
end
continue
end

local bp=al[bo.Name]

if not bp then
continue
end

local bq=bp.info.character
local br=bp.info.humanoid

if not(bq and br)then
if bp.objects and bp.objects.holder then
bp.objects.holder.Visible=false
end
set_highlight(bp,false)
for bs,bt in bp.drawings do
bt.Visible=false
end
continue
end

local bs=bp.objects

if not bs then
continue
end

local bt=br:GetState()
if br.Health<=0 or bt==Enum.HumanoidStateType.Dead then
local bu=bs.holder
bu.Visible=false
set_highlight(bp,false)
for bv,bw in bp.drawings do
bw.Visible=false
end
continue
end

local bu=br.RootPart or bq:FindFirstChild"HumanoidRootPart"
if not bu then
local bv=bs.holder
if bv then
bv.Visible=false
end
set_highlight(bp,false)
for bw,bx in bp.drawings do
bx.Visible=false
end
continue
end

local bv=bs.holder

local bw=bu.Position
local bx=bw.X-aZ
local by=bw.Y-a_
local bz=bw.Z-a0
local bA=aX(bx*bx+by*by+bz*bz)

if bh>0 and bA>bh then
if bv.Visible then bv.Visible=false end
set_highlight(bp,false)
for bB,bC in bp.drawings do
if bC.Visible then bC.Visible=false end
end
continue
end

local bB,bC,bD=al:box_solve(bu,bA)

if not bD then
bv.Visible=false
set_highlight(bp,false)
for bE,bF in bp.drawings do
bF.Visible=false
end
continue
end

if bv.Visible~=bD then
bv.Visible=bD
end

set_highlight(bp,bg~="off")

local bE=bs.outline_stroke
local bF=bA>820 and 1 or 0
if bE.Transparency~=bF then
bE.Transparency=bF
end

local bG=bs.flag
if bf then
if bm-(bp.info.flag_checked or 0)>0.5 then
bp.info.flag_checked=bm
bp.info.invisible=is_character_invisible(bq)
end
if bG.Visible~=bp.info.invisible then
bG.Visible=bp.info.invisible
end
elseif bG.Visible then
bG.Visible=false
end

if bl then
local bH=bp.info.bones
if bH then
for bI=1,#aV do
local bJ=bp.drawings[bI]
if not bJ then
continue
end

local bK=bH[bI]
if bK then
local bL=bK[1]
local bM=bK[2]
local bN,bO=project(bL.Position.X,bL.Position.Y,bL.Position.Z)
if bN and bN>=0 and bN<=ba and bO>=0 and bO<=bb then
local bP,bQ=project(bM.Position.X,bM.Position.Y,bM.Position.Z)
if bP and bP>=0 and bP<=ba and bQ>=0 and bQ<=bb then
if not bJ.Visible then bJ.Visible=true end
bJ.From=k(bN,bO)
bJ.To=k(bP,bQ)
continue
end
end
end

if bJ.Visible then bJ.Visible=false end
end
end
else
for bH,bI in bp.drawings do
if bI.Visible then bI.Visible=false end
end
end

local bH=bp.info.tool and bj and bs.holder or al.cache
if bs.weapon.Parent~=bH then
bs.weapon.Parent=bH
bp.refresh_offsets()
end

local bI=t(bC.X,bC.Y)
if bI~=bv.Position then
bv.Position=bI
end

local bJ=t(bB.X,bB.Y)
if bJ~=bv.Size then
bv.Size=bJ
end

if bi then
local bK=bs.distance
local bL=aY(bA/3.28).."M"
if bK.Text~=bL then
bK.Text=bL
end
end
end
end)

function al.unload(be)
for bf,bg in b:GetPlayers()do
al:remove_object(bg)
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

for aX,aY in b:GetPlayers()do
al:create_object(aY)
end

al.player_added=b.PlayerAdded:Connect(function(aX)
al:create_object(aX)
end)

al.player_removed=b.PlayerRemoving:Connect(function(aX)
al:remove_object(aX)
end)

task.wait()
al.refresh_elements()
