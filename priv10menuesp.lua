-- finobe didnt make this, all me. 
    local uis = game:GetService("UserInputService") 
    local players = game:GetService("Players") 
    local ws = game:GetService("Workspace")
    local rs = game:GetService("ReplicatedStorage")
    local http_service = game:GetService("HttpService")
    local gui_service = game:GetService("GuiService")
    local lighting = game:GetService("Lighting")
    local run = game:GetService("RunService")
    local stats = game:GetService("Stats")
    local coregui = game:GetService("CoreGui")
    local debris = game:GetService("Debris")
    local tween_service = game:GetService("TweenService")
    local sound_service = game:GetService("SoundService")

    local vec2 = Vector2.new
    local vec3 = Vector3.new
    local dim2 = UDim2.new
    local dim = UDim.new 
    local rect = Rect.new
    local cfr = CFrame.new
    local empty_cfr = cfr()
    local point_object_space = empty_cfr.PointToObjectSpace
    local angle = CFrame.Angles
    local dim_offset = UDim2.fromOffset

    local color = Color3.new
    local rgb = Color3.fromRGB
    local hex = Color3.fromHex
    local hsv = Color3.fromHSV
    local rgbseq = ColorSequence.new
    local rgbkey = ColorSequenceKeypoint.new
    local numseq = NumberSequence.new
    local numkey = NumberSequenceKeypoint.new

    local camera = ws.CurrentCamera
    local lp = players.LocalPlayer 
    local mouse = lp:GetMouse() 
    local gui_offset = gui_service:GetGuiInset().Y

    lp:GetPropertyChangedSignal("Team"):Connect(function()
        if esp then
            esp.refresh_elements()
        end
    end)

    local max = math.max 
    local floor = math.floor 
    local min = math.min 
    local abs = math.abs 
    local noise = math.noise
    local rad = math.rad 
    local random = math.random 
    local pow = math.pow 
    local sin = math.sin 
    local pi = math.pi 
    local tan = math.tan 
    local atan2 = math.atan2 
    local clamp = math.clamp 

    local insert = table.insert 
    local find = table.find 
    local remove = table.remove
    local concat = table.concat

    local freecam = {}

    do
        local pi    = math.pi
        local abs   = math.abs
        local clamp = math.clamp
        local exp   = math.exp
        local rad   = math.rad
        local sign  = math.sign
        local sqrt  = math.sqrt
        local tan   = math.tan

        local ContextActionService = game:GetService("ContextActionService")
        local Players = game:GetService("Players")
        local RunService = game:GetService("RunService")
        local StarterGui = game:GetService("StarterGui")
        local UserInputService = game:GetService("UserInputService")
        local Workspace = game:GetService("Workspace")

        local LocalPlayer = Players.LocalPlayer
        if not LocalPlayer then
            Players:GetPropertyChangedSignal("LocalPlayer"):Wait()
            LocalPlayer = Players.LocalPlayer
        end

        local Camera = Workspace.CurrentCamera
        Workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
            local newCamera = Workspace.CurrentCamera
            if newCamera then
                Camera = newCamera
            end
        end)

        local TOGGLE_INPUT_PRIORITY = Enum.ContextActionPriority.Low.Value
        local INPUT_PRIORITY = Enum.ContextActionPriority.High.Value
        local FREECAM_MACRO_KB = {Enum.KeyCode.LeftShift, Enum.KeyCode.P}

        local NAV_GAIN = Vector3.new(1, 1, 1)*64
        local PAN_GAIN = Vector2.new(0.75, 1)*8
        local FOV_GAIN = 300

        local PITCH_LIMIT = rad(90)

        local VEL_STIFFNESS = 10
        local PAN_STIFFNESS = 10
        local FOV_STIFFNESS = 10

        local Spring = {} do
            Spring.__index = Spring

            function Spring.new(freq, pos)
                local self = setmetatable({}, Spring)
                self.f = freq
                self.p = pos
                self.v = pos*0
                return self
            end

            function Spring:Update(dt, goal)
                local f = self.f*2*pi
                local p0 = self.p
                local v0 = self.v

                local offset = goal - p0
                local decay = exp(-f*dt)

                local p1 = goal + (v0*dt - offset*(f*dt + 1))*decay
                local v1 = (f*dt*(offset*f - v0) + v0)*decay

                self.p = p1
                self.v = v1

                return p1
            end

            function Spring:Reset(pos)
                self.p = pos
                self.v = pos*0
            end
        end

        local cameraPos = Vector3.new()
        local cameraRot = Vector2.new()
        local cameraFov = 0

        local freecam_override = nil

        local velSpring = Spring.new(VEL_STIFFNESS, Vector3.new())
        local panSpring = Spring.new(PAN_STIFFNESS, Vector2.new())
        local fovSpring = Spring.new(FOV_STIFFNESS, 0)

        local Input = {} do
            local thumbstickCurve do
                local K_CURVATURE = 2.0
                local K_DEADZONE = 0.15

                local function fCurve(x)
                    return (exp(K_CURVATURE*x) - 1)/(exp(K_CURVATURE) - 1)
                end

                local function fDeadzone(x)
                    return fCurve((x - K_DEADZONE)/(1 - K_DEADZONE))
                end

                function thumbstickCurve(x)
                    return sign(x)*clamp(fDeadzone(abs(x)), 0, 1)
                end
            end

            local gamepad = {
                ButtonX = 0,
                ButtonY = 0,
                DPadDown = 0,
                DPadUp = 0,
                ButtonL2 = 0,
                ButtonR2 = 0,
                Thumbstick1 = Vector2.new(),
                Thumbstick2 = Vector2.new(),
            }

            local keyboard = {
                W = 0,
                A = 0,
                S = 0,
                D = 0,
                E = 0,
                Q = 0,
                U = 0,
                H = 0,
                J = 0,
                K = 0,
                I = 0,
                Y = 0,
                Up = 0,
                Down = 0,
                LeftShift = 0,
                RightShift = 0,
            }

            local mouse = {
                Delta = Vector2.new(),
                MouseWheel = 0,
            }

            local NAV_GAMEPAD_SPEED  = Vector3.new(1, 1, 1)
            local NAV_KEYBOARD_SPEED = Vector3.new(1, 1, 1)
            local PAN_MOUSE_SPEED    = Vector2.new(1, 1)*(pi/64)
            local PAN_GAMEPAD_SPEED  = Vector2.new(1, 1)*(pi/8)
            local FOV_WHEEL_SPEED    = 1.0
            local FOV_GAMEPAD_SPEED  = 0.25
            local NAV_ADJ_SPEED      = 0.75
            local NAV_SHIFT_MUL      = 0.25

            local navSpeed = 1

            function Input.Vel(dt)
                navSpeed = clamp(navSpeed + dt*(keyboard.Up - keyboard.Down)*NAV_ADJ_SPEED, 0.01, 4)

                local kGamepad = Vector3.new(
                    thumbstickCurve(gamepad.Thumbstick1.X),
                    thumbstickCurve(gamepad.ButtonR2) - thumbstickCurve(gamepad.ButtonL2),
                    thumbstickCurve(-gamepad.Thumbstick1.Y)
                )*NAV_GAMEPAD_SPEED

                local kKeyboard = Vector3.new(
                    keyboard.D - keyboard.A + keyboard.K - keyboard.H,
                    keyboard.E - keyboard.Q + keyboard.I - keyboard.Y,
                    keyboard.S - keyboard.W + keyboard.J - keyboard.U
                )*NAV_KEYBOARD_SPEED

                local shift = UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) or UserInputService:IsKeyDown(Enum.KeyCode.RightShift)

                return (kGamepad + kKeyboard)*(navSpeed*(shift and NAV_SHIFT_MUL or 1))
            end

            function Input.Pan(dt)
                local kGamepad = Vector2.new(
                    thumbstickCurve(gamepad.Thumbstick2.Y),
                    thumbstickCurve(-gamepad.Thumbstick2.X)
                )*PAN_GAMEPAD_SPEED
                local kMouse = mouse.Delta*PAN_MOUSE_SPEED
                mouse.Delta = Vector2.new()
                return kGamepad + kMouse
            end

            function Input.Fov(dt)
                local kGamepad = (gamepad.ButtonX - gamepad.ButtonY)*FOV_GAMEPAD_SPEED
                local kMouse = mouse.MouseWheel*FOV_WHEEL_SPEED
                mouse.MouseWheel = 0
                return kGamepad + kMouse
            end

            do
                local function Keypress(action, state, input)
                    keyboard[input.KeyCode.Name] = state == Enum.UserInputState.Begin and 1 or 0
                    return Enum.ContextActionResult.Sink
                end

                local function GpButton(action, state, input)
                    gamepad[input.KeyCode.Name] = state == Enum.UserInputState.Begin and 1 or 0
                    return Enum.ContextActionResult.Sink
                end

                local function MousePan(action, state, input)
                    local delta = input.Delta
                    mouse.Delta = Vector2.new(-delta.y, -delta.x)
                    return Enum.ContextActionResult.Sink
                end

                local function Thumb(action, state, input)
                    gamepad[input.KeyCode.Name] = input.Position
                    return Enum.ContextActionResult.Sink
                end

                local function Trigger(action, state, input)
                    gamepad[input.KeyCode.Name] = input.Position.z
                    return Enum.ContextActionResult.Sink
                end

                local function MouseWheel(action, state, input)
                    mouse[input.UserInputType.Name] = -input.Position.z
                    return Enum.ContextActionResult.Sink
                end

                local function Zero(t)
                    for k, v in pairs(t) do
                        t[k] = v*0
                    end
                end

                function Input.StartCapture()
                    ContextActionService:BindActionAtPriority("FreecamKeyboard", Keypress, false, INPUT_PRIORITY,
                        Enum.KeyCode.W, Enum.KeyCode.U,
                        Enum.KeyCode.A, Enum.KeyCode.H,
                        Enum.KeyCode.S, Enum.KeyCode.J,
                        Enum.KeyCode.D, Enum.KeyCode.K,
                        Enum.KeyCode.E, Enum.KeyCode.I,
                        Enum.KeyCode.Q, Enum.KeyCode.Y,
                        Enum.KeyCode.Up, Enum.KeyCode.Down
                    )
                    ContextActionService:BindActionAtPriority("FreecamMousePan",          MousePan,   false, INPUT_PRIORITY, Enum.UserInputType.MouseMovement)
                    ContextActionService:BindActionAtPriority("FreecamMouseWheel",        MouseWheel, false, INPUT_PRIORITY, Enum.UserInputType.MouseWheel)
                    ContextActionService:BindActionAtPriority("FreecamGamepadButton",     GpButton,   false, INPUT_PRIORITY, Enum.KeyCode.ButtonX, Enum.KeyCode.ButtonY)
                    ContextActionService:BindActionAtPriority("FreecamGamepadTrigger",    Trigger,    false, INPUT_PRIORITY, Enum.KeyCode.ButtonR2, Enum.KeyCode.ButtonL2)
                    ContextActionService:BindActionAtPriority("FreecamGamepadThumbstick", Thumb,      false, INPUT_PRIORITY, Enum.KeyCode.Thumbstick1, Enum.KeyCode.Thumbstick2)
                end

                function Input.StopCapture()
                    navSpeed = 1
                    Zero(gamepad)
                    Zero(keyboard)
                    Zero(mouse)
                    ContextActionService:UnbindAction("FreecamKeyboard")
                    ContextActionService:UnbindAction("FreecamMousePan")
                    ContextActionService:UnbindAction("FreecamMouseWheel")
                    ContextActionService:UnbindAction("FreecamGamepadButton")
                    ContextActionService:UnbindAction("FreecamGamepadTrigger")
                    ContextActionService:UnbindAction("FreecamGamepadThumbstick")
                end
            end
        end

        local function GetFocusDistance(cameraFrame)
            local znear = 0.1
            local viewport = Camera.ViewportSize
            local projy = 2*tan(cameraFov/2)
            local projx = viewport.x/viewport.y*projy
            local fx = cameraFrame.rightVector
            local fy = cameraFrame.upVector
            local fz = cameraFrame.lookVector

            local minVect = Vector3.new()
            local minDist = 512

            for x = 0, 1, 0.5 do
                for y = 0, 1, 0.5 do
                    local cx = (x - 0.5)*projx
                    local cy = (y - 0.5)*projy
                    local offset = fx*cx - fy*cy + fz
                    local origin = cameraFrame.p + offset*znear
                    local _, hit = Workspace:FindPartOnRay(Ray.new(origin, offset.unit*minDist))
                    local dist = (hit - origin).magnitude
                    if minDist > dist then
                        minDist = dist
                        minVect = offset.unit
                    end
                end
            end

            return fz:Dot(minVect)*minDist
        end

        local function StepFreecam(dt)

            if freecam_override then
                local vel = velSpring:Update(dt, Input.Vel(dt))
                local fov = fovSpring:Update(dt, Input.Fov(dt))

                local zoomFactor = sqrt(tan(rad(70/2))/tan(rad(cameraFov/2)))
                cameraFov = clamp(cameraFov + fov*FOV_GAIN*(dt/zoomFactor), 1, 120)

                local cameraCFrame = freecam_override * CFrame.new(vel*NAV_GAIN*dt)
                cameraPos = cameraCFrame.Position
                cameraRot = Vector2.new(cameraCFrame:toEulerAnglesYXZ())

                Camera.CFrame = cameraCFrame
                Camera.Focus = cameraCFrame*CFrame.new(0, 0, -GetFocusDistance(cameraCFrame))
                Camera.FieldOfView = cameraFov
                return
            end

            local vel = velSpring:Update(dt, Input.Vel(dt))
            local pan = panSpring:Update(dt, Input.Pan(dt))
            local fov = fovSpring:Update(dt, Input.Fov(dt))

            local zoomFactor = sqrt(tan(rad(70/2))/tan(rad(cameraFov/2)))

            cameraFov = clamp(cameraFov + fov*FOV_GAIN*(dt/zoomFactor), 1, 120)
            cameraRot = cameraRot + pan*PAN_GAIN*(dt/zoomFactor)
            cameraRot = Vector2.new(clamp(cameraRot.x, -PITCH_LIMIT, PITCH_LIMIT), cameraRot.y%(2*pi))

            local cameraCFrame = CFrame.new(cameraPos)*CFrame.fromOrientation(cameraRot.x, cameraRot.y, 0)*CFrame.new(vel*NAV_GAIN*dt)
            cameraPos = cameraCFrame.p

            Camera.CFrame = cameraCFrame
            Camera.Focus = cameraCFrame*CFrame.new(0, 0, -GetFocusDistance(cameraCFrame))
            Camera.FieldOfView = cameraFov
        end

        local PlayerState = {} do
            local mouseBehavior
            local mouseIconEnabled
            local cameraType
            local cameraFocus
            local cameraCFrame
            local cameraFieldOfView
            local screenGuis = {}
            local coreGuis = {
                Backpack = true,
                Chat = true,
                Health = true,
                PlayerList = true,
            }
            local setCores = {
                BadgesNotificationsActive = true,
                PointsNotificationsActive = true,
            }

            function PlayerState.Push()

                cameraFieldOfView = Camera.FieldOfView
                Camera.FieldOfView = 70

                cameraType = Camera.CameraType
                Camera.CameraType = Enum.CameraType.Custom

                cameraCFrame = Camera.CFrame
                cameraFocus = Camera.Focus

                mouseIconEnabled = UserInputService.MouseIconEnabled
                UserInputService.MouseIconEnabled = true

                mouseBehavior = UserInputService.MouseBehavior
                UserInputService.MouseBehavior = Enum.MouseBehavior.Default
            end

            function PlayerState.Pop()
                for name, isEnabled in pairs(coreGuis) do
                    StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType[name], isEnabled)
                end
                for name, isEnabled in pairs(setCores) do
                    StarterGui:SetCore(name, isEnabled)
                end
                for _, gui in pairs(screenGuis) do
                    if gui.Parent then
                        gui.Enabled = true
                    end
                end

                Camera.FieldOfView = cameraFieldOfView
                cameraFieldOfView = nil

                Camera.CameraType = cameraType
                cameraType = nil

                Camera.CFrame = cameraCFrame
                cameraCFrame = nil

                Camera.Focus = cameraFocus
                cameraFocus = nil

                UserInputService.MouseIconEnabled = true
                UserInputService.MouseBehavior = Enum.MouseBehavior.Default
                mouseBehavior = nil
                mouseIconEnabled = nil
            end
        end

        local function StartFreecam()
            local cameraCFrame = Camera.CFrame
            cameraRot = Vector2.new(cameraCFrame:toEulerAnglesYXZ())
            cameraPos = cameraCFrame.p
            cameraFov = Camera.FieldOfView

            velSpring:Reset(Vector3.new())
            panSpring:Reset(Vector2.new())
            fovSpring:Reset(0)

            PlayerState.Push()
            RunService:BindToRenderStep("Freecam", Enum.RenderPriority.Camera.Value, StepFreecam)
            Input.StartCapture()
        end

        local function StopFreecam()
            Input.StopCapture()
            RunService:UnbindFromRenderStep("Freecam")
            PlayerState.Pop()

            task.spawn(function()
                for _ = 1, 45 do
                    task.wait()
                    UserInputService.MouseBehavior = Enum.MouseBehavior.Default
                    UserInputService.MouseIconEnabled = true
                end
            end)
        end

        function freecam:EnableFreecam()
            StartFreecam()
        end

        function freecam:StopFreecam()
            StopFreecam()
        end

        local freecamActive = false

        function freecam:IsActive()
            return freecamActive
        end

        function freecam:SetOverride(cframe)
            freecam_override = cframe
        end

        function freecam:ClearOverride()
            freecam_override = nil
        end

        function freecam.set_active(bool)
            bool = not not bool

            if bool == freecamActive then
                return
            end

            freecamActive = bool

            if bool then
                freecam:EnableFreecam()
            else
                freecam:StopFreecam()
            end

            if library.freecam_keybind then
                library.freecam_keybind.set(bool)
            end
        end

        UserInputService.InputBegan:Connect(function(input, gameProcessed)
            if gameProcessed then return end
            if input.KeyCode == Enum.KeyCode.P then
                local shiftDown = UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) or
                                  UserInputService:IsKeyDown(Enum.KeyCode.RightShift)
                if shiftDown then
                    freecam.set_active(not freecamActive)
                end
            end
        end)
    end

    getgenv().library = {
        directory = "priv9",
        folders = {
            "/fonts",
            "/configs",
        },
        flags = {},
        config_flags = {},

        connections = {},   
        notifications = {},
        playerlist_data = {
            players = {},
            player = {}, 
        },
        colorpicker_open = false; 
        gui; 
    }

    local themes = {
        preset = {
            outline = rgb(10, 10, 10),
            inline = rgb(35, 35, 35),
            text = rgb(180, 180, 180),
            text_outline = rgb(0, 0, 0),
            background = rgb(20, 20, 20),
            ["1"] = hex("#245771"), 
            ["2"] = hex("#215D63"),
            ["3"] = hex("#1E6453"),
        },

        utility = {
            inline = {
                BackgroundColor3 = {} 	
            },
            text = {
                TextColor3 = {}	
            },
            text_outline = {
                Color = {} 	
            },
            ["1"] = {
                BackgroundColor3 = {}, 
                TextColor3 = {}, 
                ImageColor3 = {}, 
                ScrollBarImageColor3 = {}, 
                BorderColor3 = {},
            },
            ["2"] = {
                BackgroundColor3 = {}, 
                TextColor3 = {}, 
                ImageColor3 = {}, 
                ScrollBarImageColor3 = {}, 
                BorderColor3 = {},
            },
            ["3"] = {
                BackgroundColor3 = {}, 
                TextColor3 = {}, 
                ImageColor3 = {}, 
                ScrollBarImageColor3 = {}, 
                BorderColor3 = {},
            },
        }
    }

    local keys = {
        [Enum.KeyCode.LeftShift] = "LShift",
        [Enum.KeyCode.RightShift] = "RShift",
        [Enum.KeyCode.LeftControl] = "LCtrl",
        [Enum.KeyCode.RightControl] = "RCtrl",
        [Enum.KeyCode.Insert] = "INSERT",
        [Enum.KeyCode.Backspace] = "BACK",
        [Enum.KeyCode.Return] = "Enter",
        [Enum.KeyCode.LeftAlt] = "LAlt",
        [Enum.KeyCode.RightAlt] = "RAlt",
        [Enum.KeyCode.CapsLock] = "CAPS",
        [Enum.KeyCode.One] = "1",
        [Enum.KeyCode.Two] = "2",
        [Enum.KeyCode.Three] = "3",
        [Enum.KeyCode.Four] = "4",
        [Enum.KeyCode.Five] = "5",
        [Enum.KeyCode.Six] = "6",
        [Enum.KeyCode.Seven] = "7",
        [Enum.KeyCode.Eight] = "8",
        [Enum.KeyCode.Nine] = "9",
        [Enum.KeyCode.Zero] = "0",
        [Enum.KeyCode.KeypadOne] = "Num1",
        [Enum.KeyCode.KeypadTwo] = "Num2",
        [Enum.KeyCode.KeypadThree] = "Num3",
        [Enum.KeyCode.KeypadFour] = "Num4",
        [Enum.KeyCode.KeypadFive] = "Num5",
        [Enum.KeyCode.KeypadSix] = "Num6",
        [Enum.KeyCode.KeypadSeven] = "Num7",
        [Enum.KeyCode.KeypadEight] = "Num8",
        [Enum.KeyCode.KeypadNine] = "Num9",
        [Enum.KeyCode.KeypadZero] = "Num0",
        [Enum.KeyCode.Minus] = "-",
        [Enum.KeyCode.Equals] = "=",
        [Enum.KeyCode.Tilde] = "~",
        [Enum.KeyCode.LeftBracket] = "[",
        [Enum.KeyCode.RightBracket] = "]",
        [Enum.KeyCode.RightParenthesis] = ")",
        [Enum.KeyCode.LeftParenthesis] = "(",
        [Enum.KeyCode.Semicolon] = ",",
        [Enum.KeyCode.Quote] = "'",
        [Enum.KeyCode.BackSlash] = "\\",
        [Enum.KeyCode.Comma] = ",",
        [Enum.KeyCode.Period] = ".",
        [Enum.KeyCode.Slash] = "/",
        [Enum.KeyCode.Asterisk] = "*",
        [Enum.KeyCode.Plus] = "+",
        [Enum.KeyCode.Period] = ".",
        [Enum.KeyCode.Backquote] = "`",
        [Enum.UserInputType.MouseButton1] = "MB1",
        [Enum.UserInputType.MouseButton2] = "MB2",
        [Enum.UserInputType.MouseButton3] = "MB3",
        [Enum.KeyCode.Escape] = "ESCAPE",
        [Enum.KeyCode.Space] = "SPACE",
    }

    library.__index = library

    for _, path in next, library.folders do 
        makefolder(library.directory .. path)
    end

    local flags = library.flags 
    local config_flags = library.config_flags
    library.keybinds = {}

        local fonts = {}; do
            function Register_Font(Name, Weight, Style, Asset)
                if not isfile(Asset.Id) then
                    writefile(Asset.Id, Asset.Font)
                end

                if isfile(Name .. ".font") then
                    delfile(Name .. ".font")
                end

                local Data = {
                    name = Name,
                    faces = {
                        {
                            name = "Regular",
                            weight = Weight,
                            style = Style,
                            assetId = getcustomasset(Asset.Id),
                        },
                    },
                }

                writefile(Name .. ".font", game:GetService("HttpService"):JSONEncode(Data))

                return getcustomasset(Name .. ".font");
            end

            local ProggyTiny = Register_Font("Tahoma", 200, "Normal", {
                Id = "Tahoma.ttf",
                Font = game:HttpGet("https://github.com/i77lhm/storage/raw/refs/heads/main/fonts/tahoma_bold.ttf"),
            })

            local ProggyClean = Register_Font("ProggyClean", 200, "normal", {
                Id = "ProggyClean.ttf",
                Font = game:HttpGet("https://github.com/i77lhm/storage/raw/refs/heads/main/fonts/ProggyClean.ttf")
            })

            local SmallestPixel = Register_Font("SmallestPixel", 400, "Normal", {
                Id = "SmallestPixel.ttf",
                Font = game:HttpGet("https://github.com/i77lhm/storage/raw/refs/heads/main/fonts/smallest_pixel-7.ttf"),
            })

            fonts = {
                ["TahomaBold"] = Font.new(ProggyTiny, Enum.FontWeight.Regular, Enum.FontStyle.Normal);
                ["ProggyClean"] = Font.new(ProggyClean, Enum.FontWeight.Regular, Enum.FontStyle.Normal);
                ["SmallestPixel"] = Font.new(SmallestPixel, Enum.FontWeight.Regular, Enum.FontStyle.Normal);
            }
        end

        function library:tween(obj, properties) 
            local tween = tween_service:Create(obj, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut, 0, false, 0), properties):Play()

            return tween
        end 

        function library:close_current_element(cfg) 
            local path = library.current_element_open

            if path then
                path.set_visible(false)
                path.open = false 
            end
        end 

        function library:resizify(frame) 
            local Frame = Instance.new("TextButton")
            Frame.Position = dim2(1, -10, 1, -10)
            Frame.BorderColor3 = rgb(0, 0, 0)
            Frame.Size = dim2(0, 10, 0, 10)
            Frame.BorderSizePixel = 0
            Frame.BackgroundColor3 = rgb(255, 255, 255)
            Frame.Parent = frame
            Frame.BackgroundTransparency = 1 
            Frame.Text = ""

            local resizing = false 
            local start_size 
            local start 
            local og_size = frame.Size  

            Frame.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    resizing = true
                    start = input.Position
                    start_size = frame.Size
                end
            end)

            Frame.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    resizing = false
                end
            end)

            library:connection(uis.InputChanged, function(input, game_event) 
                if resizing and input.UserInputType == Enum.UserInputType.MouseMovement then
                    local viewport_x = camera.ViewportSize.X
                    local viewport_y = camera.ViewportSize.Y

                    local current_size = dim2(
                        start_size.X.Scale,
                        math.clamp(
                            start_size.X.Offset + (input.Position.X - start.X),
                            og_size.X.Offset,
                            viewport_x
                        ),
                        start_size.Y.Scale,
                        math.clamp(
                            start_size.Y.Offset + (input.Position.Y - start.Y),
                            og_size.Y.Offset,
                            viewport_y
                        )
                    )
                    frame.Size = current_size
                end
            end)
        end

        function library:mouse_in_frame(uiobject)
            local y_cond = uiobject.AbsolutePosition.Y <= mouse.Y and mouse.Y <= uiobject.AbsolutePosition.Y + uiobject.AbsoluteSize.Y
            local x_cond = uiobject.AbsolutePosition.X <= mouse.X and mouse.X <= uiobject.AbsolutePosition.X + uiobject.AbsoluteSize.X

            return (y_cond and x_cond)
        end

        library.lerp = function(start, finish, t)
            t = t or 1 / 8

            return start * (1 - t) + finish * t
        end

        function library:draggify(frame)
            local dragging = false 
            local start_size = frame.Position
            local start 

            frame.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = true
                    start = input.Position
                    start_size = frame.Position
                end
            end)

            frame.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = false
                end
            end)

            library:connection(uis.InputChanged, function(input, game_event) 
                if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                    local viewport_x = camera.ViewportSize.X
                    local viewport_y = camera.ViewportSize.Y

                    local current_position = dim2(
                        0,
                        clamp(
                            start_size.X.Offset + (input.Position.X - start.X),
                            0,
                            viewport_x - frame.Size.X.Offset
                        ),
                        0,
                        math.clamp(
                            start_size.Y.Offset + (input.Position.Y - start.Y),
                            0,
                            viewport_y - frame.Size.Y.Offset
                        )
                    )

                    frame.Position = current_position
                end
            end)
        end 

        function library:convert(str)
            local values = {}

            for value in string.gmatch(str, "[^,]+") do
                insert(values, tonumber(value))
            end

            if #values == 4 then              
                return unpack(values)
            else 
                return
            end
        end

        function library:convert_enum(enum)
            local enum_parts = {}

            for part in string.gmatch(enum, "[%w_]+") do
                insert(enum_parts, part)
            end

            local enum_table = Enum
            for i = 2, #enum_parts do
                local enum_item = enum_table[enum_parts[i]]

                enum_table = enum_item
            end

            return enum_table
        end

        local config_holder;
        function library:update_config_list() 
            if not config_holder then 
                return 
            end

            local list = {}

            for idx, file in listfiles(library.directory .. "/configs") do
                local name = file:gsub(library.directory .. "/configs\\", ""):gsub(".cfg", ""):gsub(library.directory .. "\\configs\\", "")
                list[#list + 1] = name
            end

            config_holder.refresh_options(list)
        end 

        function library:get_config()
            local Config = {}

            for _, v in flags do
                if type(v) == "table" and v.key then
                    Config[_] = {active = v.active, mode = v.mode, key = tostring(v.key)}
                elseif type(v) == "table" and v["Transparency"] and v["Color"] then
                    Config[_] = {Transparency = v["Transparency"], Color = v["Color"]:ToHex()}
                else
                    Config[_] = v
                end
            end 

            return http_service:JSONEncode(Config)
        end

        function library:load_config(config_json) 
            local config = http_service:JSONDecode(config_json)

            for _, v in next, config do 
                local function_set = library.config_flags[_]

                if _ == "config_name_list" then 
                    continue
                end

                if function_set then 
                    if type(v) == "table" and v["Transparency"] and v["Color"] then
                        function_set(hex(v["Color"]), v["Transparency"])
                        print("set cp!")
                    elseif type(v) == "table" and v["active"] then 
                        function_set(v)
                    else
                        function_set(v)
                    end
                end 
            end 
        end 

        function library:round(number, float) 
            local multiplier = 1 / (float or 1)

            return floor(number * multiplier + 0.5) / multiplier
        end 

        function library:apply_theme(instance, theme, property) 
            insert(themes.utility[theme][property], instance)
        end

        function library:update_theme(theme, color)
            for propertyName, objects in next, themes.utility[theme] do
                for _, object in next, objects do
                    if object:GetAttribute("PrivToggleState") == false and propertyName == "BackgroundColor3" then

                        object[propertyName] = themes.preset.inline
                    else
                        object[propertyName] = color
                    end
                end
            end

            themes.preset[theme] = color
        end

        function library:create_visuals_selection_box(selection_section)
            local selection_box = library:create("Frame", {
                Parent = selection_section.elements;
                BorderColor3 = themes.preset[tostring(selection_section.count)];
                BorderSizePixel = 1;
                BackgroundColor3 = rgb(35, 35, 35);
                Size = dim2(1, 0, 0, 0);
                AutomaticSize = Enum.AutomaticSize.Y;
            })
            library:apply_theme(selection_box, tostring(selection_section.count), "BorderColor3")

            library:create("UIPadding", {
                Parent = selection_box;
                PaddingTop = dim(0, 4);
                PaddingBottom = dim(0, 4);
                PaddingLeft = dim(0, 6);
                PaddingRight = dim(0, 6);
            })

            library:create("UIListLayout", {
                Parent = selection_box;
                Padding = dim(0, 4);
                SortOrder = Enum.SortOrder.LayoutOrder;
            })

            return selection_box
        end

        function library:create_visuals_page(visuals_center, visuals_right, page)
            local center_name = page.center_label or page.label
            local right_name = page.right_label or (page.label .. " options")

            local center_section = visuals_center:section({name = center_name, auto_fill = true, size = 1})
            local right_section = visuals_right:section({name = right_name, auto_fill = true, size = 1})

            center_section.frame.Visible = false
            right_section.frame.Visible = false

            return {
                center = center_section,
                right = right_section,
            }
        end

        library.visuals_registry = library.visuals_registry or { pages = {}, selection_box = nil }

        function library:create_visuals_selection(selection_section)
            local selection_inner = library:create_visuals_selection_box(selection_section)
            library.visuals_registry.selection_box = selection_inner
            return selection_inner
        end

        function library:create_visuals_placeholder(column, name)
            local placeholder = column:section({name = name or "placeholder", auto_fill = false, size = 1})
            placeholder.frame.Visible = false
            return placeholder
        end

        function library:register_visuals_page(id, label, center_section, right_section)
            library.visuals_registry.pages[id] = library.visuals_registry.pages[id] or {}
            local entry = library.visuals_registry.pages[id]
            entry.label = label
            entry.center = center_section
            entry.right = right_section

            local sel = library.visuals_registry.selection_box
            if sel and not entry.button then
                local btn = library:create("TextButton", {
                    FontFace = fonts["ProggyClean"];
                    TextColor3 = rgb(170, 170, 170);
                    BorderColor3 = rgb(0, 0, 0);
                    Text = label;
                    Parent = sel;
                    BackgroundTransparency = 1;
                    BorderSizePixel = 0;
                    AutomaticSize = Enum.AutomaticSize.XY;
                    TextSize = 12;
                    TextXAlignment = Enum.TextXAlignment.Left;
                    BackgroundColor3 = rgb(255, 255, 255)
                })

                entry.button = btn

                btn.MouseButton1Click:Connect(function()
                    library:set_visuals_page(id)
                end)
            end

            return entry
        end

        function library:get_visuals_page(id)
            library.visuals_registry = library.visuals_registry or { pages = {}, selection_box = nil }
            return library.visuals_registry.pages[id]
        end

        function library:set_visuals_page(id)
            library.visuals_registry = library.visuals_registry or { pages = {}, selection_box = nil }
            local function set_visible(obj, visible)
                if not obj then return end

                if type(obj) == "table" and obj.frame then
                    obj.frame.Visible = visible
                    return
                end

                if type(obj) == "table" then
                    for _, v in next, obj do
                        if v and v.frame then
                            v.frame.Visible = visible
                        end
                    end
                end
            end

            for page_id, page_data in next, library.visuals_registry.pages do
                local selected = page_id == id

                set_visible(page_data.center, selected)
                set_visible(page_data.right, selected)

                if page_data.button then
                    page_data.button.TextColor3 = selected and rgb(255, 255, 255) or rgb(170, 170, 170)
                end
            end
        end

        function library:connection(signal, callback)
            local connection = signal:Connect(callback)

            insert(library.connections, connection)

            return connection 
        end

        function library:apply_stroke(parent) 
            local STROKE = library:create("UIStroke", {
                Parent = parent,
                Color = themes.preset.text_outline, 
                LineJoinMode = Enum.LineJoinMode.Miter
            }) 

            library:apply_theme(STROKE, "text_outline", "Color")
        end

        function library:create(instance, options)
            local ins = Instance.new(instance) 

            for prop, value in next, options do 
                ins[prop] = value
            end

            if instance == "TextLabel" or instance == "TextButton" or instance == "TextBox" then 	
                library:apply_theme(ins, "text", "TextColor3")
                library:apply_stroke(ins)
            end

            return ins 
        end

        function library:update_keybind_visualizer()
            local container = self.active_keybind_container
            if not container then
                return
            end

            local actives = {}
            for _, cfg in ipairs(self.keybinds or {}) do
                if cfg.active and not cfg.ignore_key and cfg.flag ~= "menu_key" then
                    insert(actives, cfg)
                end
            end

            for _, label in ipairs(self.active_keybind_labels or {}) do
                label:Destroy()
            end
            self.active_keybind_labels = {}

            if #actives == 0 then
                container.Visible = false
                return
            end

            container.Visible = true
            for _, cfg in ipairs(actives) do
                local label = library:create("TextLabel", {
                    Parent = container;
                    Text = "";
                    FontFace = fonts["SmallestPixel"];
                    TextColor3 = hex("#8AD4BF");
                    BackgroundTransparency = 1;
                    BorderSizePixel = 0;
                    AutomaticSize = Enum.AutomaticSize.XY;
                    TextSize = 9;
                    TextStrokeTransparency = 0;
                    TextXAlignment = Enum.TextXAlignment.Center;
                })

                local mode = cfg.mode or ""
                label.Text = string.format("%s [%s]", cfg.name or cfg.flag or "keybind", string.lower(mode))
                insert(self.active_keybind_labels, label)
            end
        end

        function library:unload_menu() 
            if library.gui then 
                library.gui:Destroy()
            end

            for index, connection in next, library.connections do 
                connection:Disconnect() 
                connection = nil 
            end     

            if library.sgui then 
                library.sgui:Destroy()
            end 

            library = nil 
        end 

        function library:window(properties)
            local cfg = {
                name = properties.name or properties.Name or "priv9",
                size = properties.size or properties.Size or dim2(0, 450, 0, 350), 
                selected_tab = nil,
                tabs = {}
            }

            library.gui = library:create("ScreenGui", {
                Parent = coregui,
                Name = "\0",
                Enabled = true,
                ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
                IgnoreGuiInset = true,
                DisplayOrder = 2147483647,
            })

                local window_outline = library:create("Frame", {
                    Parent = library.gui;
                    Position = dim2(0.5, -cfg.size.X.Offset / 2, 0.5, -cfg.size.Y.Offset / 2);
                    BorderColor3 = rgb(0, 0, 0);
                    Size = cfg.size;
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(255, 255, 255)
                });
                window_outline.Position = dim2(0, window_outline.AbsolutePosition.Y, 0, window_outline.AbsolutePosition.Y)
                cfg.main_outline = window_outline

                library:resizify(window_outline)
                library:draggify(window_outline)

                local title_holder = library:create("Frame", {
                    Parent = window_outline;
                    BackgroundTransparency = 0.800000011920929;
                    Position = dim2(0, 2, 0, 2);
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(1, -4, 0, 20);
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(0, 0, 0)
                });

                local ui_title = library:create("TextLabel", {
                    FontFace = fonts["TahomaBold"];
                    TextColor3 = rgb(255, 255, 255);
                    BorderColor3 = rgb(0, 0, 0);
                    Text = cfg.name;
                    Parent = title_holder;
                    BackgroundTransparency = 1;
                    Size = dim2(1, 0, 1, 0);
                    BorderSizePixel = 0;
                    TextSize = 12;
                    BackgroundColor3 = rgb(255, 255, 255)
                });

                library.gradient = library:create("UIGradient", {
                    Color = rgbseq{
                        rgbkey(0, themes.preset["1"]), 
                        rgbkey(0.5, themes.preset["2"]),
                        rgbkey(1, themes.preset["3"]),
                    };
                    Parent = window_outline
                });

                local tab_button_holder = library:create("Frame", {
                    AnchorPoint = vec2(0, 1);
                    Parent = window_outline;
                    BackgroundTransparency = 0.800000011920929;
                    Position = dim2(0, 2, 1, -2);
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(1, -4, 0, 20);
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(0, 0, 0)
                }); cfg.tab_button_holder = tab_button_holder

                library:create("UIListLayout", {
                    VerticalAlignment = Enum.VerticalAlignment.Center;
                    FillDirection = Enum.FillDirection.Horizontal;
                    HorizontalAlignment = Enum.HorizontalAlignment.Center;
                    HorizontalFlex = Enum.UIFlexAlignment.Fill;
                    Parent = tab_button_holder;
                    SortOrder = Enum.SortOrder.LayoutOrder;
                    VerticalFlex = Enum.UIFlexAlignment.Fill
                });

            function cfg.toggle_menu(bool) 
                window_outline.Visible = bool 
            end

            return setmetatable(cfg, library)
        end 

        function library:tab(properties)
            local cfg = {
                name = properties.name or "visuals", 
                count = 0
            }

            self.tabs = self.tabs or {}
            insert(self.tabs, cfg)

                    local tab_button = library:create("TextButton", {
                        FontFace = fonts["ProggyClean"];
                        TextColor3 = rgb(170, 170, 170);
                        BorderColor3 = rgb(0, 0, 0);
                        Text = cfg.name;
                        Parent = self.tab_button_holder;
                        BackgroundTransparency = 1;
                        BorderSizePixel = 0;
                        AutomaticSize = Enum.AutomaticSize.XY;
                        TextSize = 12;
                        BackgroundColor3 = rgb(255, 255, 255)
                    });

                    local Page = library:create("Frame", {
                        Parent = self.main_outline;
                        BackgroundTransparency = 0.6;
                        Position = dim2(0, 2, 0, 24);
                        BorderColor3 = rgb(0, 0, 0);
                        Size = dim2(1, -4, 1, -48);
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(0, 0, 0),
                        Visible = false,
                    }); cfg.page = Page

                    library:create("UIListLayout", {
                        FillDirection = Enum.FillDirection.Horizontal;
                        HorizontalFlex = Enum.UIFlexAlignment.Fill;
                        Parent = Page;
                        Padding = dim(0, 2);
                        SortOrder = Enum.SortOrder.LayoutOrder;
                        VerticalFlex = Enum.UIFlexAlignment.Fill
                    });

                    library:create("UIPadding", {
                        PaddingTop = dim(0, 2);
                        PaddingBottom = dim(0, 2);
                        Parent = Page;
                        PaddingRight = dim(0, 2);
                        PaddingLeft = dim(0, 2)
                    });

            function cfg.open_tab() 
                local selected_tab = self.selected_tab

                if selected_tab then 
                    selected_tab[1].Visible = false 
                    selected_tab[2].TextColor3 = rgb(170, 170, 170)

                    selected_tab = nil 
                end

                Page.Visible = true
                tab_button.TextColor3 = rgb(255, 255, 255)

                self.selected_tab = {Page, tab_button}
            end

            tab_button.MouseButton1Down:Connect(function()
                cfg.open_tab()
            end)

            if not self.selected_tab then 
                cfg.open_tab(true) 
            end

            return setmetatable(cfg, library)    
        end 

        local notifications = {notifs = {}} 

        library.sgui = library:create("ScreenGui", {
            Name = "Hi",
            Parent = gethui();
            IgnoreGuiInset = false;
            DisplayOrder = 2147483646;
        })

        library.active_keybind_container = library:create("Frame", {
            Parent = library.sgui;
            AnchorPoint = vec2(0.5, 0);
            Position = dim2(0.5, 0, 0.5, 30);
            BackgroundTransparency = 1;
            BorderSizePixel = 0;
            AutomaticSize = Enum.AutomaticSize.XY;
            Visible = false;
        })
        library.active_keybind_labels = {}

        library:create("UIListLayout", {
            Parent = library.active_keybind_container;
            Padding = dim(0, 4);
            SortOrder = Enum.SortOrder.LayoutOrder;
            HorizontalAlignment = Enum.HorizontalAlignment.Center;
        })

        function notifications:refresh_notifs()
            local wm = library.watermark_outline
            local baseX = (wm and wm.AbsolutePosition and wm.AbsolutePosition.X) and wm.AbsolutePosition.X or 18
            local baseY = (wm and wm.AbsolutePosition and wm.AbsolutePosition.Y) and wm.AbsolutePosition.Y or 0

            local idxs = {}
            for k in pairs(notifications.notifs) do
                if type(k) == "number" then
                    insert(idxs, k)
                end
            end

            table.sort(idxs)

            local gap = 30
            local wmHeight = (wm and wm.AbsoluteSize and wm.AbsoluteSize.Y) and wm.AbsoluteSize.Y or 24
            for order, key in ipairs(idxs) do
                local v = notifications.notifs[key]
                if v then
                    local targetY = baseY + wmHeight + (order * gap)
                    tween_service:Create(v, TweenInfo.new(1, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {Position = dim_offset(baseX, targetY)}):Play()
                end
            end
        end

        function notifications:fade(path, is_fading)
            local fading = is_fading and 1 or 0 

            tween_service:Create(path, TweenInfo.new(1, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {BackgroundTransparency = fading}):Play()

            for _, instance in path:GetDescendants() do 
                if not instance:IsA("GuiObject") then 
                    if instance:IsA("UIStroke") then
                        tween_service:Create(instance, TweenInfo.new(1, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {Transparency = fading}):Play()
                    end

                    continue
                end 

                if instance:IsA("TextLabel") then
                    tween_service:Create(instance, TweenInfo.new(1, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {TextTransparency = fading}):Play()
                elseif instance:IsA("Frame") then
                    tween_service:Create(instance, TweenInfo.new(1, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {BackgroundTransparency = instance.Transparency and 0.6 and is_fading and 1 or 0.6}):Play()
                end
            end
        end 

        function notifications:create_notification(options)
            local cfg = {
                name = options.name or "Hit: retard (retard) in the Head for 100 Damage!",
                outline; 
            }

                local wm = library.watermark_outline
                local baseX = (wm and wm.AbsolutePosition and wm.AbsolutePosition.X) and wm.AbsolutePosition.X or 18
                local baseY = (wm and wm.AbsolutePosition and wm.AbsolutePosition.Y) and wm.AbsolutePosition.Y or 0

                local gap = 8
                local wmHeight = (wm and wm.AbsoluteSize and wm.AbsoluteSize.Y) and wm.AbsoluteSize.Y or 24

                local outline = library:create("Frame", {
                    Parent = library.sgui;
                    Position = dim_offset(baseX, baseY + wmHeight + ((#notifications.notifs + 1) * gap)); 
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(0, 0, 0, 24);
                    BorderSizePixel = 0;
                    AutomaticSize = Enum.AutomaticSize.X;
                    BackgroundColor3 = rgb(255, 255, 255)
                });

                local dark = library:create("Frame", {
                    Parent = outline;
                    BackgroundTransparency = 1;
                    Position = dim2(0, 2, 0, 2);
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(1, -4, 1, -4);
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(0, 0, 0)
                });

                library:create("UIPadding", {
                    PaddingTop = dim(0, 7);
                    PaddingBottom = dim(0, 6);
                    Parent = dark;
                    PaddingRight = dim(0, 7);
                    PaddingLeft = dim(0, 4)
                });

                library:create("TextLabel", {
                    FontFace = fonts["ProggyClean"];
                    TextColor3 = rgb(255, 255, 255);
                    BorderColor3 = rgb(0, 0, 0);
                    Text = cfg.name;
                    Parent = dark;
                    Size = dim2(0, 0, 1, 0);
                    Position = dim2(0, 1, 0, -1);
                    BackgroundTransparency = 1;
                    TextXAlignment = Enum.TextXAlignment.Left;
                    BorderSizePixel = 0;
                    AutomaticSize = Enum.AutomaticSize.X;
                    TextSize = 12;
                    BackgroundColor3 = rgb(255, 255, 255)
                }); 

                library:create("UIGradient", {
                    Color = rgbseq{
                        rgbkey(0, themes.preset["1"]), 
                        rgbkey(0.5, themes.preset["2"]),
                        rgbkey(1, themes.preset["3"]),
                    };
                    Parent = outline
                });

            local index = #notifications.notifs + 1
            notifications.notifs[index] = outline

            notifications:refresh_notifs()
            tween_service:Create(outline, TweenInfo.new(1, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {AnchorPoint = vec2(0, 0)}):Play()

            notifications:fade(outline, false)

            task.spawn(function()
                task.wait(3)

                notifications.notifs[index] = nil

                notifications:fade(outline, true)

                task.wait(3)

                outline:Destroy() 
            end)
        end

        function library:watermark(options)
            local cfg = {
                name = options.name or "nebulahax";
            }

                local outline = library:create("Frame", {
                    Parent = library.sgui;
                    Position = dim2(0, 18, 0, 0); 
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(0, 0, 0, 24);
                    BorderSizePixel = 0;
                    AutomaticSize = Enum.AutomaticSize.X;
                    BackgroundColor3 = rgb(255, 255, 255)
                }); library.watermark_outline = outline; library:draggify(outline);

                local dark = library:create("Frame", {
                    Parent = outline;
                    BackgroundTransparency = 0.6;
                    Position = dim2(0, 2, 0, 2);
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(1, -4, 1, -4);
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(0, 0, 0)
                });

                library:create("UIPadding", {
                    PaddingTop = dim(0, 7);
                    PaddingBottom = dim(0, 6);
                    Parent = dark;
                    PaddingRight = dim(0, 7);
                    PaddingLeft = dim(0, 4)
                });

                local text_title = library:create("TextLabel", {
                    FontFace = fonts["ProggyClean"];
                    TextColor3 = rgb(255, 255, 255);
                    BorderColor3 = rgb(0, 0, 0);
                    Text = cfg.name;
                    Parent = dark;
                    Size = dim2(0, 0, 1, 0);
                    Position = dim2(0, 1, 0, -1);
                    BackgroundTransparency = 1;
                    TextXAlignment = Enum.TextXAlignment.Left;
                    BorderSizePixel = 0;
                    AutomaticSize = Enum.AutomaticSize.X;
                    TextSize = 12;
                    BackgroundColor3 = rgb(255, 255, 255)
                }); 

                library.watermark_gradient = library:create("UIGradient", {
                    Color = rgbseq{
                        rgbkey(0, themes.preset["1"]), 
                        rgbkey(0.5, themes.preset["2"]),
                        rgbkey(1, themes.preset["3"]),
                    };
                    Parent = outline
                });

            function cfg.update_text(text)
                text_title.Text = text
            end

            cfg.update_text(cfg.name)

            return setmetatable(cfg, library)
        end 

        local watermark = library:watermark({name = "priv9.net alpha"})
        local fps = 0
        local watermark_delay = tick() 

        run.RenderStepped:Connect(function()
            fps += 1

            if tick() - watermark_delay > 1 then 
                watermark_delay = tick()
                local ping = math.floor(stats.PerformanceStats.Ping:GetValue()) .. "ms"                
                watermark.update_text(string.format("priv9.net alpha | fps: %s", fps, ping))
                fps = 0
            end
        end)

        function library:column(properties)
            self.count += 1

            local cfg = {color = library.gradient.Color.Keypoints[self.count].Value, count = self.count} 

            local scrolling_frame = library:create("ScrollingFrame", {
                ScrollBarImageColor3 = rgb(0, 0, 0);
                Active = true;
                AutomaticCanvasSize = Enum.AutomaticSize.Y;
                ScrollBarThickness = 0;
                Parent = self.page;
                LayoutOrder = -1;
                BackgroundTransparency = 1;
                ScrollBarImageTransparency = 1;
                BorderColor3 = rgb(0, 0, 0);
                BackgroundColor3 = rgb(0, 0, 0);
                BorderSizePixel = 0;
                CanvasSize = dim2(0, 0, 0, 0)
            }); cfg.column = scrolling_frame

            library:create("UIListLayout", {
                Parent = scrolling_frame;
                Padding = dim(0, 2);
                SortOrder = Enum.SortOrder.LayoutOrder
            });

            return setmetatable(cfg, library)            
        end 

        function library:section(properties)            
            local cfg = {
                name = properties.name or properties.Name or "section",
                size = properties.size or 1, 
                autofill = properties.auto_fill or false,
                count = self.count;
                color = self.color;
            }

                local accent = library:create("Frame", {
                    Parent = self.column;
                    ClipsDescendants = true;
                    BorderColor3 = rgb(0, 0, 0);
                    BorderSizePixel = 0;
                    BackgroundColor3 = themes.preset[tostring(self.count)]
                }); library:apply_theme(accent, tostring(self.count), "BackgroundColor3");

                local dark = library:create("Frame", {
                    Parent = accent;
                    BackgroundTransparency = 0.6;
                    Position = dim2(0, 1, 0, 16);
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(1, -2, 1, -17);
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(0, 0, 0)
                });

                local elements = library:create("Frame", {
                    Parent = dark;
                    Position = dim2(0, 4, 0, 5);
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(1, -8, 0, 0);
                    BackgroundTransparency = 1;
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(255, 255, 255)
                }); cfg.elements = elements
                cfg.frame = accent

                if cfg.autofill == false then 
                    elements.AutomaticSize = Enum.AutomaticSize.Y;
                    accent.AutomaticSize = Enum.AutomaticSize.Y;
                    accent.Size = dim2(1, 0, 0, 0);

                    local UIPadding = library:create("UIPadding", {
                        Parent = elements,
                        Name = "",
                        PaddingBottom = dim(0, 7)
                    })
                else 

                    local marker = Instance.new("BoolValue")
                    marker.Name = "__autofill"
                    marker.Value = true
                    marker.Parent = accent

                    accent.Size = dim2(1, 0, 0, 24)

                    local function find_listlayout(col)
                        for _, v in pairs(col:GetChildren()) do
                            if v:IsA("UIListLayout") then
                                return v
                            end
                        end
                    end

                    local function apply_autofill()
                        local col = accent.Parent
                        if not col then return end

                        local layout = find_listlayout(col)
                        if not layout then return end

                        local contentY = layout.AbsoluteContentSize.Y
                        local thisH = accent.AbsoluteSize.Y

                        local lastAutofill
                        local maxY = -math.huge
                        for _, child in pairs(col:GetChildren()) do
                            local m = child:FindFirstChild("__autofill")
                            if m and m.Value then
                                if child.AbsolutePosition.Y > maxY then
                                    maxY = child.AbsolutePosition.Y
                                    lastAutofill = child
                                end
                            end
                        end

                        if lastAutofill ~= accent then
                            return
                        end

                        local remaining = col.AbsoluteSize.Y - (contentY - thisH)
                        remaining = math.floor(remaining)
                        if remaining < 24 then
                            remaining = 24
                        end

                        if remaining and remaining > 0 then
                            accent.Size = UDim2.new(1, 0, 0, remaining)
                        end
                    end

                    local scheduled = false
                    local function schedule()
                        if scheduled then return end
                        scheduled = true
                        task.delay(0.04, function()
                            scheduled = false
                            pcall(apply_autofill)
                        end)
                    end

                    local col = accent.Parent
                    local layout = find_listlayout(col)
                    if layout then
                        library:connection(layout:GetPropertyChangedSignal("AbsoluteContentSize"), schedule)
                    end
                    library:connection(col:GetPropertyChangedSignal("AbsoluteSize"), schedule)

                    library:connection(accent:GetPropertyChangedSignal("AbsoluteSize"), schedule)

                    schedule()
                end

                library:create("UIListLayout", {
                    Parent = elements;
                    Padding = dim(0, 6);
                    SortOrder = Enum.SortOrder.LayoutOrder
                });

                local title = library:create("TextLabel", {
                    FontFace = fonts["TahomaBold"];
                    TextColor3 = rgb(255, 255, 255);
                    BorderColor3 = rgb(0, 0, 0);
                    Text = cfg.name;
                    Parent = accent;
                    Size = dim2(1, 0, 0, 0);
                    Position = dim2(0, 4, 0, 2);
                    BackgroundTransparency = 1;
                    TextXAlignment = Enum.TextXAlignment.Left;
                    BorderSizePixel = 0;
                    AutomaticSize = Enum.AutomaticSize.Y;
                    TextSize = 12;
                    BackgroundColor3 = rgb(255, 255, 255)
                });

                library:create("UIListLayout", {
                    Parent = ScrollingFrame;
                    Padding = dim(0, 5);
                    SortOrder = Enum.SortOrder.LayoutOrder
                });

            return setmetatable(cfg, library)
        end 

            function library:toggle(options) 
                local cfg = {
                    name = options.name or "Toggle",
                    flag = options.flag or options.name or "Flag",

                    default = options.default or false,
                    folding = options.folding or false, 
                    callback = options.callback or function() end,

                    color = self.color;
                    count = self.count;
                }

                if options.enabled ~= nil then
                    cfg.enabled = options.enabled
                else
                    cfg.enabled = cfg.default
                end

                        local toggle = library:create("TextButton", {
                            Parent = self.elements;
                            BackgroundTransparency = 1;
                            Text = "";
                            BorderColor3 = rgb(0, 0, 0);
                            Size = dim2(1, 0, 0, 12);
                            BorderSizePixel = 0;
                            BackgroundColor3 = rgb(255, 255, 255)
                        });

                        library:create("TextLabel", {
                            FontFace = fonts["ProggyClean"];
                            TextColor3 = rgb(255, 255, 255);
                            BorderColor3 = rgb(0, 0, 0);
                            Text = cfg.name;
                            Parent = toggle;
                            Size = dim2(1, 0, 1, 0);
                            Position = dim2(0, 1, 0, -1);
                            BackgroundTransparency = 1;
                            TextXAlignment = Enum.TextXAlignment.Left;
                            BorderSizePixel = 0;
                            AutomaticSize = Enum.AutomaticSize.X;
                            TextSize = 12;
                            BackgroundColor3 = rgb(255, 255, 255)
                        }); 

                        local accent = library:create("Frame", {
                            AnchorPoint = vec2(1, 0);
                            Parent = toggle;
                            Position = dim2(1, 0, 0, 0);
                            BorderColor3 = rgb(0, 0, 0);
                            Size = dim2(0, 12, 0, 12);
                            BorderSizePixel = 0;
                            BackgroundColor3 = themes.preset[tostring(self.count)]
                        }); library:apply_theme(accent, tostring(self.count), "BackgroundColor3");    

                        local fill = library:create("Frame", {
                            Parent = accent;
                            Position = dim2(0, 1, 0, 1);
                            BorderColor3 = rgb(0, 0, 0);
                            Size = dim2(1, -2, 1, -2);
                            BorderSizePixel = 0;
                            BackgroundColor3 = themes.preset[tostring(self.count)]
                        }); library:apply_theme(fill, tostring(self.count), "BackgroundColor3");                

                        library:create("UIListLayout", {
                            FillDirection = Enum.FillDirection.Horizontal;
                            HorizontalAlignment = Enum.HorizontalAlignment.Right;
                            Parent = right_components;
                            Padding = dim(0, 4);
                            SortOrder = Enum.SortOrder.LayoutOrder
                        });

                        local elements;

                        if cfg.folding then
                            elements = library:create("Frame", {
                                Parent = self.elements;
                                BackgroundTransparency = 1;
                                Position = dim2(0, 4, 0, 21);
                                Size = dim2(1, 0, 0, 0);
                                BorderSizePixel = 0;
                                Visible = false;
                                AutomaticSize = Enum.AutomaticSize.Y;
                                BackgroundColor3 = rgb(255, 255, 255)
                            }); cfg.elements = elements

                            library:create("UIListLayout", {
                                Parent = elements;
                                Padding = dim(0, 6);
                                HorizontalAlignment = Enum.HorizontalAlignment.Right;
                                SortOrder = Enum.SortOrder.LayoutOrder
                            });                            
                        end 

                    function cfg.set(bool)                        
                        fill.BackgroundColor3 = bool and themes.preset[tostring(self.count)] or themes.preset.inline
                        fill:SetAttribute("PrivToggleState", bool)

                        flags[cfg.flag] = bool

                        cfg.callback(bool)

                        if cfg.folding then 
                            elements.Visible = bool
                        end
                    end 

                    cfg.set(cfg.enabled)

                    config_flags[cfg.flag] = cfg.set

                    toggle.MouseButton1Click:Connect(function()
                        cfg.enabled = not cfg.enabled 
                        cfg.set(cfg.enabled)
                    end)

                return setmetatable(cfg, library)
            end 

            function library:list(options)
                local cfg = {
                    callback = options and options.callback or function() end, 
                    name = options.name or nil, 

                    scale = options.size or 90, 
                    items = options.items or {"1", "2", "3"}, 

                    visible = options.visible or true,

                    option_instances = {}, 
                    current_instance = nil, 
                    flag = options.flag or "flag", 
                }

                    local accent = library:create("Frame", {
                        BorderColor3 = rgb(0, 0, 0);
                        AnchorPoint = vec2(1, 0);
                        Parent = self.elements;
                        Position = dim2(1, 0, 0, 0);
                        Size = dim2(1, 0, 0, cfg.scale);
                        BorderSizePixel = 0;
                        AutomaticSize = Enum.AutomaticSize.Y;
                        BackgroundColor3 = themes.preset[tostring(self.count)]
                    }); library:apply_theme(accent, tostring(self.count), "BackgroundColor3")

                    local inline = library:create("Frame", {
                        Parent = accent;
                        Position = dim2(0, 1, 0, 1);
                        BorderColor3 = rgb(0, 0, 0);
                        Size = dim2(1, -2, 1, -2);
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(35, 35, 35)
                    }); library:apply_theme(inline, "inline", "BackgroundColor3")

                    local scrollingframe = library:create("ScrollingFrame", {
                        ScrollBarImageColor3 = rgb(0, 0, 0);
                        Active = true;
                        AutomaticCanvasSize = Enum.AutomaticSize.Y;
                        ScrollBarThickness = 0;
                        Parent = inline;
                        Size = dim2(1, 0, 1, 0);
                        LayoutOrder = -1;
                        BackgroundTransparency = 1;
                        ScrollBarImageTransparency = 1;
                        BorderColor3 = rgb(0, 0, 0);
                        BackgroundColor3 = rgb(0, 0, 0);
                        BorderSizePixel = 0;
                        CanvasSize = dim2(0, 0, 0, 0)
                    });

                    library:create("UIListLayout", {
                        Parent = scrollingframe;
                        Padding = dim(0, 6);
                        SortOrder = Enum.SortOrder.LayoutOrder
                    });

                    library:create("UIPadding", {
                        PaddingTop = dim(0, 2);
                        PaddingBottom = dim(0, 4);
                        Parent = scrollingframe;
                        PaddingRight = dim(0, 5);
                        PaddingLeft = dim(0, 5)
                    });

                    function cfg.render_option(text) 
                        local text = library:create("TextButton", {
                            FontFace = fonts["ProggyClean"];
                            TextColor3 = rgb(170, 170, 170);
                            BorderColor3 = rgb(0, 0, 0);
                            Text = text;
                            AutoButtonColor = false;
                            BackgroundTransparency = 1;
                            Parent = scrollingframe;
                            BorderSizePixel = 0;
                            Size = dim2(1, 0, 0, 0);
                            AutomaticSize = Enum.AutomaticSize.Y;
                            TextSize = 12;
                            TextXAlignment = Enum.TextXAlignment.Center;
                            TextYAlignment = Enum.TextYAlignment.Center;
                            BackgroundColor3 = rgb(255, 255, 255)
                        }); 

                        return text 
                    end 

                    function cfg.refresh_options(options)
                        for _, v in cfg.option_instances do 
                            v:Destroy() 
                        end 

                        for _, option in next, options do 
                            local button = cfg.render_option(option) 

                            insert(cfg.option_instances, button)

                            button.MouseButton1Click:Connect(function()
                                if cfg.current_instance and cfg.current_instance ~= button then 
                                    cfg.current_instance.TextColor3 = rgb(170, 170, 170)
                                end 

                                cfg.current_instance = button
                                button.TextColor3 = rgb(255, 255, 255) 

                                flags[cfg.flag] = button.text

                                cfg.callback(button.text)
                            end)
                        end 
                    end

                    function cfg.filter_options(text)
                        for _, v in next, cfg.option_instances do 
                            if string.find(v.Text, text) then 
                                v.Visible = true 
                            else 
                                v.Visible = false
                            end
                        end
                    end

                    local function update_label()
                        if cfg.open then

                            local highlighted = nil
                            for _, opt in next, cfg.option_instances do
                                if opt.TextColor3 == rgb(255, 255, 255) then
                                    highlighted = opt.Text
                                    break
                                end
                            end

                            if highlighted then
                                text.Text = highlighted
                            else
                                local fallback = flags[cfg.flag] or (cfg.option_instances[1] and cfg.option_instances[1].Text) or "..."
                                text.Text = fallback
                            end

                            return
                        end

                        local display = ""
                        if cfg.multi then
                            display = concat(cfg.multi_items, ", ")
                        else
                            display = flags[cfg.flag] or cfg.default or ""
                        end

                        text.Text = display
                    end

                    function cfg.set(value)
                        for _, buttons in next, cfg.option_instances do 
                            if buttons.Text == value then 
                                buttons.TextColor3 = rgb(255, 255, 255) 
                            else 
                                buttons.TextColor3 = rgb(170, 170, 170)
                            end 
                        end 

                        flags[cfg.flag] = value
                        cfg.callback(value)
                    end 

                    cfg.refresh_options(cfg.items) 

                return setmetatable(cfg, library)
            end     

            function library:slider(options) 
                local cfg = {
                    name = options.name or nil,
                    suffix = options.suffix or "",
                    flag = options.flag or options.name or "Flag",
                    callback = options.callback or function() end, 

                    min = options.min or options.minimum or 0,
                    max = options.max or options.maximum or 100,
                    intervals = options.interval or options.decimal or 1,
                    default = options.default or 10,
                    value = options.default or 10, 

                    ignore = options.ignore or false, 
                    dragging = false,
                } 

                    local slider = library:create("Frame", {
                        Parent = self.elements;
                        BackgroundTransparency = 1;
                        BorderColor3 = rgb(0, 0, 0);
                        Size = dim2(1, 0, 0, 25);
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(255, 255, 255)
                    });

                    local eeeee = library:create("TextLabel", {
                        FontFace = fonts["ProggyClean"];
                        TextColor3 = rgb(255, 255, 255);
                        RichText = true;
                        BorderColor3 = rgb(0, 0, 0);
                        Text = "max distance : 5000";
                        Parent = slider;
                        Size = dim2(1, 0, 0, 0);
                        Position = dim2(0, 1, 0, -2);
                        BackgroundTransparency = 1;
                        TextXAlignment = Enum.TextXAlignment.Left;
                        BorderSizePixel = 0;
                        AutomaticSize = Enum.AutomaticSize.XY;
                        TextSize = 12;
                        BackgroundColor3 = rgb(255, 255, 255)
                    });

                    local outline = library:create("TextButton", {
                        Parent = slider;
                        Text = "";
                        AutoButtonColor = false;
                        Position = dim2(0, 0, 0, 13);
                        BorderColor3 = rgb(0, 0, 0);
                        Size = dim2(1, 0, 0, 12);
                        BorderSizePixel = 0;
                        BackgroundColor3 = themes.preset[tostring(self.count)]
                    }); library:apply_theme(outline, tostring(self.count), "BackgroundColor3")

                    local inline = library:create("Frame", {
                        Parent = outline;
                        Position = dim2(0, 1, 0, 1);
                        BorderColor3 = rgb(0, 0, 0);
                        Size = dim2(1, -2, 1, -2);
                        BorderSizePixel = 0;
                        BackgroundColor3 = themes.preset.inline
                    }); library:apply_theme(outline, "inline", "BackgroundColor3")

                    local accent = library:create("Frame", {
                        Parent = inline;
                        BorderColor3 = rgb(0, 0, 0);
                        Size = dim2(0.5, 0, 1, 0);
                        BorderSizePixel = 0;
                        BackgroundColor3 = themes.preset[tostring(self.count)]
                    }); library:apply_theme(accent, tostring(self.count), "BackgroundColor3")

                    function cfg.set(value)
                        local valuee = tonumber(value)

                        if valuee == nil then 
                            return 
                        end 

                        cfg.value = clamp(library:round(valuee, cfg.intervals), cfg.min, cfg.max)

                        accent.Size = dim2((cfg.value - cfg.min) / (cfg.max - cfg.min), 0, 1, 0)
                        eeeee.Text = cfg.name ..  "<font color='#AAAAAA'>" .. ' - ' .. tostring(cfg.value) .. cfg.suffix .. "</font>"

                        flags[cfg.flag] = cfg.value

                        cfg.callback(flags[cfg.flag])
                    end 

                    cfg.set(cfg.default)

                    outline.MouseButton1Down:Connect(function()
                        cfg.dragging = true 
                    end)

                    library:connection(uis.InputChanged, function(input)
                        if cfg.dragging and input.UserInputType == Enum.UserInputType.MouseMovement then 
                            local size_x = (input.Position.X - inline.AbsolutePosition.X) / inline.AbsoluteSize.X
                            local value = ((cfg.max - cfg.min) * size_x) + cfg.min

                            cfg.set(value)
                        end
                    end)

                    library:connection(uis.InputEnded, function(input)
                        if input.UserInputType == Enum.UserInputType.MouseButton1 then
                            cfg.dragging = false 
                        end 
                    end)

                cfg.set(cfg.default)

                config_flags[cfg.flag] = cfg.set

                return setmetatable(cfg, library)
            end 

            function library:dropdown(options) 
                local cfg = {
                    name = options.name or nil,
                    flag = options.flag or options.name or "Flag",
                    items = options.items or {""},
                    callback = options.callback or function() end,
                    multi = options.multi or false, 
                    scrolling = options.scrolling or false, 

                    open = false, 
                    option_instances = {}, 
                    multi_items = {}, 
                    ignore = options.ignore or false, 
                }   

                cfg.default = options.default or (cfg.multi and {cfg.items[1]}) or cfg.items[1] or "None"

                flags[cfg.flag] = {} 

                        local dropdown = library:create("Frame", {
                            Parent = self.elements;
                            BackgroundTransparency = 1;
                            BorderColor3 = rgb(0, 0, 0);
                            Size = dim2(1, 0, 0, 16);
                            BorderSizePixel = 0;
                            BackgroundColor3 = rgb(255, 255, 255)
                        }); cfg.frame = dropdown

                        local dropdown_holder = library:create("TextButton", {
                            AnchorPoint = vec2(1, 0);
                            AutoButtonColor = false; 
                            Text = "";
                            Parent = dropdown;
                            Position = dim2(1, 0, 0, 0);
                            BorderColor3 = rgb(0, 0, 0);
                            Size = dim2(0, 68, 0, 16);
                            BorderSizePixel = 0;
                            BackgroundColor3 = themes.preset[tostring(self.count)]
                        }); library:apply_theme(dropdown_holder, tostring(self.count), "BackgroundColor3")

                        local inline = library:create("Frame", {
                            Parent = dropdown_holder;
                            Position = dim2(0, 1, 0, 1);
                            BorderColor3 = rgb(0, 0, 0);
                            Size = dim2(1, -2, 1, -2);
                            BorderSizePixel = 0;
                            BackgroundColor3 = rgb(35, 35, 35)
                        });

                        local text = library:create("TextLabel", {
                            FontFace = fonts["ProggyClean"];
                            TextColor3 = rgb(255, 255, 255);
                            BorderColor3 = rgb(0, 0, 0);
                            Text = cfg.name;
                            Parent = inline;
                            Size = dim2(1, 0, 1, 0);
                            BackgroundTransparency = 1;
                            Position = dim2(0, 0, 0, 0);
                            BorderSizePixel = 0;
                            AutomaticSize = Enum.AutomaticSize.X;
                            TextSize = 12;
                            BackgroundColor3 = rgb(255, 255, 255)
                        });

                        local title = library:create("TextLabel", {
                            FontFace = fonts["ProggyClean"];
                            TextColor3 = rgb(255, 255, 255);
                            BorderColor3 = rgb(0, 0, 0);
                            Text = cfg.name;
                            Parent = dropdown;
                            Size = dim2(1, 0, 1, 0);
                            Position = dim2(0, 1, 0, 0);
                            BackgroundTransparency = 1;
                            TextXAlignment = Enum.TextXAlignment.Left;
                            BorderSizePixel = 0;
                            AutomaticSize = Enum.AutomaticSize.X;
                            TextSize = 12;
                            BackgroundColor3 = rgb(255, 255, 255)
                        });

                        local accent = library:create("Frame", {
                            Parent = library.gui;
                            Size = dim2(0.0907348021864891, 0, 0.006218905560672283, 20);
                            Position = dim2(0, 500, 0, 100);
                            BorderColor3 = rgb(0, 0, 0);
                            BorderSizePixel = 0;
                            Visible = false;
                            AutomaticSize = Enum.AutomaticSize.Y;
                            BackgroundColor3 = themes.preset[tostring(self.count)]
                        });	library:apply_theme(accent, tostring(self.count), "BackgroundColor3")

                        local inline = library:create("Frame", {
                            Parent = accent;
                            Size = dim2(1, -2, 1, -2);
                            Position = dim2(0, 1, 0, 1);
                            BorderColor3 = rgb(0, 0, 0);
                            BorderSizePixel = 0;
                            AutomaticSize = Enum.AutomaticSize.Y;
                            BackgroundColor3 = themes.preset.inline
                        });	library:apply_theme(inline, "inline", "BackgroundColor3")

                        library:create("UIListLayout", {
                            Parent = inline;
                            Padding = dim(0, 6);
                            SortOrder = Enum.SortOrder.LayoutOrder
                        });

                        library:create("UIPadding", {
                            PaddingTop = dim(0, 5);
                            PaddingBottom = dim(0, 2);
                            Parent = inline;
                            PaddingRight = dim(0, 1);
                            PaddingLeft = dim(0, 1)
                        });

                        local padding = library:create("UIPadding", {
                            PaddingBottom = dim(0, 2);
                            Parent = accent
                        });

                    function cfg.render_option(text) 
                        local title = library:create("TextButton", {
                            FontFace = fonts["ProggyClean"];
                            AutoButtonColor = false;
                            TextColor3 = rgb(170, 170, 170);
                            BorderColor3 = rgb(0, 0, 0);
                            Text = text;
                            Parent = inline;
                            Size = dim2(1, 0, 0, 0);
                            Position = dim2(0, 0, 0, 1);
                            BackgroundTransparency = 1;
                            TextXAlignment = Enum.TextXAlignment.Left;
                            BorderSizePixel = 0;
                            AutomaticSize = Enum.AutomaticSize.Y;
                            TextSize = 12;
                            BackgroundColor3 = rgb(255, 255, 255)
                        });

                        return title
                    end 

                    function cfg.set_visible(bool) 
                        accent.Visible = bool
                    end

                    local function update_label()
                        if cfg.open then
                            text.Text = "..."
                            return
                        end

                        local display = ""
                        if cfg.multi then
                            display = concat(cfg.multi_items, ", ")
                        else
                            display = flags[cfg.flag] or cfg.default or ""
                        end

                        text.Text = display
                    end

                    function cfg.set(value)
                        local selected = {}
                        local isTable = type(value) == "table"

                        if value == nil then 
                            return 
                        end

                        for _, option in next, cfg.option_instances do 
                            if option.Text == value or (isTable and find(value, option.Text)) then 
                                insert(selected, option.Text)
                                cfg.multi_items = selected
                                option.TextColor3 = rgb(255, 255, 255)
                            else
                                option.TextColor3 = rgb(170, 170, 170)
                            end
                        end

                        flags[cfg.flag] = if isTable then selected else selected[1]
                        cfg.callback(flags[cfg.flag])

                        update_label()
                    end

                    function cfg.refresh_options(list) 
                        for _, option in next, cfg.option_instances do 
                            option:Destroy() 
                        end

                        cfg.option_instances = {} 

                        for _, option in next, list do 
                            local button = cfg.render_option(option)

                            insert(cfg.option_instances, button)

                            button.MouseButton1Down:Connect(function()
                                if cfg.multi then 
                                    local selected_index = find(cfg.multi_items, button.Text)

                                    if selected_index then 
                                        remove(cfg.multi_items, selected_index)
                                    else
                                        insert(cfg.multi_items, button.Text)
                                    end

                                    cfg.set(cfg.multi_items) 				
                                else 
                                    cfg.set_visible(false)
                                    cfg.open = false 

                                    cfg.set(button.Text)
                                end
                            end)
                        end
                    end

                    cfg.refresh_options(cfg.items)

                    cfg.set(cfg.default)

                    config_flags[cfg.flag] = cfg.set

                    dropdown_holder.MouseButton1Click:Connect(function()
                        cfg.open = not cfg.open 

                        local absX = dropdown_holder.AbsolutePosition.X
                        local absY = dropdown_holder.AbsolutePosition.Y
                        local absH = dropdown_holder.AbsoluteSize.Y

                        accent.Size = UDim2.new(0, dropdown_holder.AbsoluteSize.X, accent.Size.Y.Scale, accent.Size.Y.Offset)
                        accent.Position = UDim2.new(0, absX, 0, absY + absH + 57)

                        cfg.set_visible(cfg.open)
                        update_label()
                    end)

                    uis.InputEnded:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.MouseButton1 then
                            if not (library:mouse_in_frame(accent) or library:mouse_in_frame(dropdown)) then 
                                cfg.open = false
                                cfg.set_visible(false)
                                update_label()
                            end
                        end
                    end)

                return setmetatable(cfg, library)
            end 

            function library:colorpicker(options) 
                local cfg = {
                    name = options.name or "Color", 
                    flag = options.flag or options.name or "Flag",

                    color = options.color or color(1, 1, 1), 
                    alpha = options.alpha and 1 - options.alpha or 0,

                    open = false, 
                    callback = options.callback or function() end,
                }

                        local colorpicker_element = library:create("TextButton", {
                            Parent = self.elements;
                            BackgroundTransparency = 1;
                            Text = "";
                            AutoButtonColor = false;
                            BorderColor3 = rgb(0, 0, 0);
                            Size = dim2(1, 0, 0, 12);
                            BorderSizePixel = 0;
                            BackgroundColor3 = rgb(255, 255, 255)
                        }); cfg.frame = colorpicker_element

                        local accent = library:create("Frame", {
                            AnchorPoint = vec2(1, 0);
                            Parent = colorpicker_element;
                            Position = dim2(1, 0, 0, 0);
                            BorderColor3 = rgb(0, 0, 0);
                            Size = dim2(0, 30, 0, 12);
                            BorderSizePixel = 0;
                            BackgroundColor3 = themes.preset[tostring(self.count)]
                        }); library:apply_theme(accent, tostring(self.count), "BackgroundColor3")

                        local colorpicker_element_color = library:create("Frame", {
                            Parent = accent;
                            Position = dim2(0, 1, 0, 1);
                            BorderColor3 = rgb(0, 0, 0);
                            Size = dim2(1, -2, 1, -2);
                            BorderSizePixel = 0;
                            BackgroundColor3 = rgb(255, 255, 255)
                        });

                        library:create("TextLabel", {
                            FontFace = fonts["ProggyClean"];
                            TextColor3 = rgb(255, 255, 255);
                            BorderColor3 = rgb(0, 0, 0);
                            Text = cfg.name;
                            Parent = colorpicker_element;
                            Size = dim2(1, 0, 1, 0);
                            Position = dim2(0, 1, 0, 0);
                            BackgroundTransparency = 1;
                            TextXAlignment = Enum.TextXAlignment.Left;
                            BorderSizePixel = 0;
                            AutomaticSize = Enum.AutomaticSize.X;
                            TextSize = 12;
                            BackgroundColor3 = rgb(255, 255, 255)
                        });

                        local colorpicker = library:create("Frame", {
                            Parent = library.gui;
                            Position = dim2(0.6888179183006287, 0, 0.24751244485378265, 0);
                            BorderColor3 = rgb(0, 0, 0);
                            Visible = false;
                            Size = dim2(0, 150, 0, 150);
                            BorderSizePixel = 0;
                            BackgroundColor3 = themes.preset[tostring(self.count)]
                        });	library:apply_theme(colorpicker, tostring(self.count), "BackgroundColor3")

                        local a = library:create("Frame", {
                            Parent = colorpicker;
                            BorderColor3 = rgb(0, 0, 0);
                            Size = dim2(1, 0, 1, 0);
                            BorderSizePixel = 0;
                            BackgroundColor3 = themes.preset[tostring(self.count)]
                        }); library:apply_theme(a, tostring(self.count), "BackgroundColor3")

                        local e = library:create("Frame", {
                            Parent = a;
                            Position = dim2(0, 1, 0, 1);
                            BorderColor3 = rgb(0, 0, 0);
                            Size = dim2(1, -2, 1, -2);
                            BorderSizePixel = 0;
                            BackgroundColor3 = rgb(0, 0, 0);
                            BackgroundTransparency = 0.6;
                            ZIndex = -1
                        }); 

                        local _ = library:create("UIPadding", {
                            PaddingTop = dim(0, 7);
                            PaddingBottom = dim(0, -13);
                            Parent = e;
                            PaddingRight = dim(0, 6);
                            PaddingLeft = dim(0, 7)
                        });

                        local textbox_holder = library:create("Frame", {
                            Parent = e;
                            Position = dim2(0, 0, 1, -36);
                            BorderColor3 = rgb(0, 0, 0);
                            Size = dim2(1, -1, 0, 16);
                            BorderSizePixel = 0;
                            BackgroundColor3 = themes.preset[tostring(self.count)]
                        }); library:apply_theme(textbox_holder, tostring(self.count), "BackgroundColor3")

                        local textbox = library:create("TextBox", {
                            FontFace = fonts["ProggyClean"];
                            TextColor3 = rgb(255, 255, 255);
                            BorderColor3 = rgb(0, 0, 0);
                            Text = "";
                            Parent = textbox_holder;
                            BackgroundTransparency = 0;
                            ClearTextOnFocus = false;
                            PlaceholderColor3 = rgb(255, 255, 255);
                            Size = dim2(1, -2, 1, -2);
                            Position = dim2(0, 1, 0, 1);
                            BorderSizePixel = 0;
                            TextSize = 12;
                            TextXAlignment = Enum.TextXAlignment.Center;
                            BackgroundColor3 = themes.preset.inline
                        }); library:apply_theme(textbox, "inline", "BackgroundColor3")

                        local hue_button = library:create("TextButton", {
                            AnchorPoint = vec2(1, 0);
                            Text = "";
                            AutoButtonColor = false;
                            Parent = e;
                            Position = dim2(1, -1, 0, 0);
                            BorderColor3 = rgb(0, 0, 0);
                            Size = dim2(0, 14, 1, -60);
                            BorderSizePixel = 0;
                            BackgroundColor3 = themes.preset.inline
                        }); library:apply_theme(hue_button, "inline", "BackgroundColor3")

                        local hue_drag = library:create("Frame", {
                            Parent = hue_button;
                            Position = dim2(0, 1, 0, 1);
                            BorderColor3 = rgb(0, 0, 0);
                            Size = dim2(1, -2, 1, -2);
                            BorderSizePixel = 0;
                            BackgroundColor3 = rgb(255, 255, 255)
                        });

                        library:create("UIGradient", {
                            Rotation = 90;
                            Parent = hue_drag;
                            Color = rgbseq{rgbkey(0, rgb(255, 0, 0)), rgbkey(0.17, rgb(255, 255, 0)), rgbkey(0.33, rgb(0, 255, 0)), rgbkey(0.5, rgb(0, 255, 255)), rgbkey(0.67, rgb(0, 0, 255)), rgbkey(0.83, rgb(255, 0, 255)), rgbkey(1, rgb(255, 0, 0))}
                        });

                        local hue_picker = library:create("Frame", {
                            Parent = hue_drag;
                            BorderMode = Enum.BorderMode.Inset;
                            BorderColor3 = rgb(0, 0, 0);
                            Size = dim2(1, 2, 0, 3);
                            Position = dim2(0, -1, 0, -1);
                            BackgroundColor3 = rgb(255, 255, 255)
                        });

                        local alpha_button = library:create("TextButton", {
                            AnchorPoint = vec2(0, 0.5);
                            Text = "";
                            AutoButtonColor = false;
                            Parent = e;
                            Position = dim2(0, 0, 1, -48);
                            BorderColor3 = rgb(0, 0, 0);
                            Size = dim2(1, -1, 0, 14);
                            BorderSizePixel = 0;
                            BackgroundColor3 = themes.preset.inline
                        }); library:apply_theme(alpha_button, "inline", "BackgroundColor3")

                        local alpha_color = library:create("Frame", {
                            Parent = alpha_button;
                            Position = dim2(0, 1, 0, 1);
                            BorderColor3 = rgb(0, 0, 0);
                            Size = dim2(1, -2, 1, -2);
                            BorderSizePixel = 0;
                            BackgroundColor3 = rgb(0, 221, 255)
                        });

                        local alphaind = library:create("ImageLabel", {
                            ScaleType = Enum.ScaleType.Tile;
                            BorderColor3 = rgb(0, 0, 0);
                            Parent = alpha_color;
                            Image = "rbxassetid://18274452449";
                            BackgroundTransparency = 1;
                            Size = dim2(1, 0, 1, 0);
                            TileSize = dim2(0, 4, 0, 4);
                            BorderSizePixel = 0;
                            BackgroundColor3 = rgb(255, 255, 255)
                        });

                        library:create("UIGradient", {
                            Parent = alphaind;
                            Transparency = numseq{numkey(0, 0), numkey(1, 1)}
                        });

                        local alpha_picker = library:create("Frame", {
                            Parent = alpha_color;
                            BorderMode = Enum.BorderMode.Inset;
                            BorderColor3 = rgb(0, 0, 0);
                            Size = dim2(0, 3, 1, 2);
                            Position = dim2(0, -1, 0, -1);
                            BackgroundColor3 = rgb(255, 255, 255)
                        });

                        local saturation_value_button = library:create("TextButton", {
                            Parent = e;
                            BorderColor3 = rgb(0, 0, 0);
                            Size = dim2(1, -20, 1, -60);
                            Text = "";
                            AutoButtonColor = false;
                            BorderSizePixel = 0;
                            BackgroundColor3 = themes.preset.inline
                        }); library:apply_theme(saturation_value_button, "inline", "BackgroundColor3")

                        local colorpicker_color = library:create("Frame", {
                            Parent = saturation_value_button;
                            Position = dim2(0, 1, 0, 1);
                            BorderColor3 = rgb(0, 0, 0);
                            Size = dim2(1, -2, 1, -2);
                            BorderSizePixel = 0;
                            BackgroundColor3 = rgb(0, 221, 255)
                        });

                        local val = library:create("TextButton", {
                            Parent = colorpicker_color;
                            Text = "";
                            AutoButtonColor = false;
                            BorderColor3 = rgb(0, 0, 0);
                            Size = dim2(1, 0, 1, 0);
                            BorderSizePixel = 0;
                            BackgroundColor3 = rgb(255, 255, 255)
                        });

                        library:create("UIGradient", {
                            Parent = val;
                            Transparency = numseq{numkey(0, 0), numkey(1, 1)}
                        });

                        local saturation_value_picker = library:create("Frame", {
                            Parent = colorpicker_color;
                            BorderColor3 = rgb(0, 0, 0);
                            Size = dim2(0, 3, 0, 3);
                            BorderSizePixel = 0;
                            BackgroundColor3 = rgb(0, 0, 0)
                        });

                        local inline = library:create("Frame", {
                            Parent = saturation_value_picker;
                            Position = dim2(0, 1, 0, 1);
                            BorderColor3 = rgb(0, 0, 0);
                            Size = dim2(1, -2, 1, -2);
                            BorderSizePixel = 0;
                            BackgroundColor3 = rgb(255, 255, 255)
                        });

                        local saturation_button = library:create("TextButton", {
                            Parent = colorpicker_color;
                            Text = "";
                            AutoButtonColor = false;
                            Size = dim2(1, 0, 1, 0);
                            BorderColor3 = rgb(0, 0, 0);
                            ZIndex = 2;
                            BorderSizePixel = 0;
                            BackgroundColor3 = rgb(255, 255, 255)
                        });

                        library:create("UIGradient", {
                            Rotation = 270;
                            Transparency = numseq{numkey(0, 0), numkey(1, 1)};
                            Parent = saturation_button;
                            Color = rgbseq{rgbkey(0, rgb(0, 0, 0)), rgbkey(1, rgb(0, 0, 0))}
                        });

                    local dragging_sat = false 
                    local dragging_hue = false 
                    local dragging_alpha = false 

                    local h, s, v = cfg.color:ToHSV() 
                    local a = cfg.alpha 

                    flags[cfg.flag] = {} 

                    function cfg.set_visible(bool) 
                        colorpicker.Visible = bool

                        colorpicker.Position = dim_offset(colorpicker_element_color.AbsolutePosition.X - 1, colorpicker_element_color.AbsolutePosition.Y + colorpicker_element_color.AbsoluteSize.Y + 65)
                    end

                    function cfg.set(color, alpha)
                        if color then
                            h, s, v = color:ToHSV()
                        end

                        if alpha then 
                            a = alpha
                        end 

                        local Color = Color3.fromHSV(h, s, v)

                        hue_picker.Position = dim2(0, -1, h, -1)
                        alpha_picker.Position = dim2(1 - a, -1, 0, -1)
                        saturation_value_picker.Position = dim2(s, -1, 1 - v, -1)

                        alpha_color.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
                        colorpicker_element_color.BackgroundColor3 = Color
                        colorpicker_color.BackgroundColor3 = Color3.fromHSV(h, 1, 1)

                        flags[cfg.flag] = {
                            Color = Color;
                            Transparency = a 
                        }

                        local color = colorpicker_element_color.BackgroundColor3
                        textbox.Text = string.format("%s, %s, %s, ", library:round(color.R * 255), library:round(color.G * 255), library:round(color.B * 255))
                        textbox.Text ..= library:round(1 - a, 0.01)

                        cfg.callback(Color, a)
                    end

                    function cfg.update_color() 
                        local mouse = uis:GetMouseLocation() 
                        local offset = vec2(mouse.X, mouse.Y - gui_offset) 

                        if dragging_sat then	
                            s = math.clamp((offset - saturation_value_button.AbsolutePosition).X / saturation_value_button.AbsoluteSize.X, 0, 1)
                            v = 1 - math.clamp((offset - saturation_value_button.AbsolutePosition).Y / saturation_value_button.AbsoluteSize.Y, 0, 1)
                        elseif dragging_hue then
                            h = math.clamp((offset - hue_button.AbsolutePosition).Y / hue_button.AbsoluteSize.Y, 0, 1)
                        elseif dragging_alpha then
                            a = 1 - math.clamp((offset - alpha_button.AbsolutePosition).X / alpha_button.AbsoluteSize.X, 0, 1)
                        end

                        cfg.set(nil, nil)
                    end

                    cfg.set(cfg.color, cfg.alpha)

                    config_flags[cfg.flag] = cfg.set

                    colorpicker_element.MouseButton1Click:Connect(function()
                        cfg.open = not cfg.open 

                        cfg.set_visible(cfg.open)            
                    end)

                    uis.InputChanged:Connect(function(input)
                        if (dragging_sat or dragging_hue or dragging_alpha) and input.UserInputType == Enum.UserInputType.MouseMovement then
                            cfg.update_color() 
                        end
                    end)

                    library:connection(uis.InputEnded, function(input)
                        if input.UserInputType == Enum.UserInputType.MouseButton1 then
                            dragging_sat = false
                            dragging_hue = false
                            dragging_alpha = false  

                            if not (library:mouse_in_frame(colorpicker_element) or library:mouse_in_frame(colorpicker)) then 
                                cfg.open = false
                                cfg.set_visible(false)
                            end
                        end
                    end)

                    alpha_button.MouseButton1Down:Connect(function()
                        dragging_alpha = true 
                    end)

                    hue_button.MouseButton1Down:Connect(function()
                        dragging_hue = true 
                    end)

                    saturation_button.MouseButton1Down:Connect(function()
                        print("hiu")
                        dragging_sat = true  
                    end)

                    textbox.FocusLost:Connect(function()
                        local r, g, b, a = library:convert(textbox.Text)

                        if r and g and b and a then 
                            cfg.set(rgb(r, g, b), 1 - a)
                        end 
                    end)

                return setmetatable(cfg, library)
            end

            function library:textbox(options) 
                local cfg = {
                    name = options.name or "...",
                    placeholder = options.placeholder or options.placeholdertext or options.holder or options.holdertext or "type here...",
                    default = options.default,
                    flag = options.flag or options.name or "Flag",
                    callback = options.callback or function() end,
                    visible = options.visible or true,
                }

                    local frame = library:create("TextButton", {
                        AnchorPoint = vec2(1, 0);
                        Text = "";
                        AutoButtonColor = false;
                        Parent = self.elements;
                        Position = dim2(1, 0, 0, 0);
                        BorderColor3 = rgb(0, 0, 0);
                        Size = dim2(1, 0, 0, 16);
                        BorderSizePixel = 0;
                        BackgroundColor3 = themes.preset[tostring(self.count)]
                    }); library:apply_theme(frame, tostring(self.count), "BackgroundColor3")

                    local frame_inline = library:create("Frame", {
                        Parent = frame;
                        Position = dim2(0, 1, 0, 1);
                        BorderColor3 = rgb(0, 0, 0);
                        Size = dim2(1, -2, 1, -2);
                        BorderSizePixel = 0;
                        BackgroundColor3 = themes.preset.inline
                    }); library:apply_theme(frame_inline, "inline", "BackgroundColor3")

                    local input = library:create("TextBox", {
                        Parent = frame,
                        Name = "",
                        FontFace = fonts["ProggyClean"],
                        TextTruncate = Enum.TextTruncate.AtEnd,
                        TextSize = 12,
                        Text = "",
                        Size = dim2(1, -6, 1, 0),
                        RichText = true,
                        TextColor3 = rgb(255, 255, 255),
                        BorderColor3 = rgb(0, 0, 0),
                        CursorPosition = -1,
                        BackgroundTransparency = 1,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        Position = dim2(0, 6, 0, 0),
                        BorderSizePixel = 0,
                        PlaceholderColor3 = rgb(170, 170, 170),
                    })

                    function cfg.set(text) 
                        flags[cfg.flag] = text

                        input.Text = text

                        cfg.callback(text)
                    end 

                    config_flags[cfg.flag] = cfg.set

                    if cfg.default then 
                        cfg.set(cfg.default) 
                    end

                    input:GetPropertyChangedSignal("Text"):Connect(function()
                        cfg.set(input.Text) 
                    end)

                return setmetatable(cfg, library)
            end 

            function library:keybind(options) 
                local cfg = {
                    flag = options.flag or options.name or "Flag",
                    callback = options.callback or function() end,
                    open = false,
                    binding = nil, 
                    name = options.name or nil, 
                    ignore_key = options.ignore or false, 

                    key = options.key or nil, 
                    force_toggle = options.force_toggle or false,
                    mode = options.force_toggle and "toggle" or (options.mode or "toggle"),
                    active = options.default or false, 

                    hold_instances = {},
                }

                flags[cfg.flag] = {} 
                insert(library.keybinds, cfg)

                        local keybind = library:create("Frame", {
                            Parent = self.elements;
                            BackgroundTransparency = 1;
                            BorderColor3 = rgb(0, 0, 0);
                            Size = dim2(1, 0, 0, 16);
                            BorderSizePixel = 0;
                            BackgroundColor3 = rgb(255, 255, 255)
                        });

                        local keybind_holder = library:create("TextButton", {
                            AnchorPoint = vec2(1, 0);
                            AutoButtonColor = false; 
                            Text = "";
                            Parent = keybind;
                            Position = dim2(1, 0, 0, 0);
                            BorderColor3 = rgb(0, 0, 0);
                            Size = dim2(0, 68, 0, 16);
                            BorderSizePixel = 0;
                            BackgroundColor3 = themes.preset[tostring(self.count)]
                        }); library:apply_theme(keybind_holder, tostring(self.count), "BackgroundColor3")

                        local inline = library:create("Frame", {
                            Parent = keybind_holder;
                            Position = dim2(0, 1, 0, 1);
                            BorderColor3 = rgb(0, 0, 0);
                            Size = dim2(1, -2, 1, -2);
                            BorderSizePixel = 0;
                            BackgroundColor3 = rgb(35, 35, 35)
                        });

                        local text = library:create("TextLabel", {
                            FontFace = fonts["ProggyClean"];
                            TextColor3 = rgb(255, 255, 255);
                            BorderColor3 = rgb(0, 0, 0);
                            Text = cfg.name;
                            Parent = inline;
                            Size = dim2(1, 0, 1, 0);
                            BackgroundTransparency = 1;
                            Position = dim2(0, 0, 0, -1);
                            BorderSizePixel = 0;
                            AutomaticSize = Enum.AutomaticSize.X;
                            TextSize = 12;
                            BackgroundColor3 = rgb(255, 255, 255)
                        });

                        local title = library:create("TextLabel", {
                            FontFace = fonts["ProggyClean"];
                            TextColor3 = rgb(255, 255, 255);
                            BorderColor3 = rgb(0, 0, 0);
                            Text = cfg.name;
                            Parent = keybind;
                            Size = dim2(1, 0, 1, 0);
                            Position = dim2(0, 1, 0, 0);
                            BackgroundTransparency = 1;
                            TextXAlignment = Enum.TextXAlignment.Left;
                            BorderSizePixel = 0;
                            AutomaticSize = Enum.AutomaticSize.X;
                            TextSize = 12;
                            BackgroundColor3 = rgb(255, 255, 255)
                        });

                        local accent = library:create("Frame", {
                            Parent = library.gui;
                            Visible = false;
                            Size = dim2(0.0907348021864891, 0, 0.006218905560672283, 20);
                            Position = dim2(0, 500, 0, 100);
                            BorderColor3 = rgb(0, 0, 0);
                            BorderSizePixel = 0;
                            AutomaticSize = Enum.AutomaticSize.Y;
                            BackgroundColor3 = themes.preset[tostring(self.count)]
                        });	library:apply_theme(accent, tostring(self.count), "BackgroundColor3")

                        local inline = library:create("Frame", {
                            Parent = accent;
                            Size = dim2(1, -2, 1, -2);
                            Position = dim2(0, 1, 0, 1);
                            BorderColor3 = rgb(0, 0, 0);
                            BorderSizePixel = 0;
                            AutomaticSize = Enum.AutomaticSize.Y;
                            BackgroundColor3 = themes.preset.inline
                        });	library:apply_theme(inline, "inline", "BackgroundColor3")

                        library:create("UIListLayout", {
                            Parent = inline;
                            Padding = dim(0, 6);
                            SortOrder = Enum.SortOrder.LayoutOrder
                        });

                        library:create("UIPadding", {
                            PaddingTop = dim(0, 5);
                            PaddingBottom = dim(0, 2);
                            Parent = inline;
                            PaddingRight = dim(0, 6);
                            PaddingLeft = dim(0, 6)
                        });

                        local padding = library:create("UIPadding", {
                            PaddingBottom = dim(0, 2);
                            Parent = accent
                        });

                            local options = cfg.force_toggle and {"Toggle"} or {"Hold", "Toggle", "Always"}

                        for _, v in options do
                            local option = library:create("TextButton", {
                                FontFace = fonts["ProggyClean"];
                                TextColor3 = rgb(170, 170, 170);
                                BorderColor3 = rgb(0, 0, 0);
                                Text = v;
                                Parent = inline;
                                Position = dim2(0, 0, 0, 1);
                                BackgroundTransparency = 1;
                                TextXAlignment = Enum.TextXAlignment.Left;
                                BorderSizePixel = 0;
                                AutomaticSize = Enum.AutomaticSize.XY;
                                TextSize = 12;
                                BackgroundColor3 = rgb(255, 255, 255)
                            }); cfg.hold_instances[v] = option

                            option.MouseButton1Click:Connect(function()
                                cfg.set(v)

                                cfg.set_visible(false)

                                cfg.open = false
                            end)
                        end

                    function cfg.modify_mode_color(path) 
                        for _, v in cfg.hold_instances do 
                            v.TextColor3 = rgb(170, 170, 170)
                        end

                        if cfg.hold_instances[path] then 
                            cfg.hold_instances[path].TextColor3 = rgb(255, 255, 255)
                        end
                    end 

                    function cfg.set_mode(mode) 
                        cfg.mode = cfg.force_toggle and "Toggle" or mode 

                        if cfg.mode == "Always" then
                            cfg.set(true)
                        elseif cfg.mode == "Hold" then
                            cfg.set(false)
                        end

                        flags[cfg.flag]["mode"] = cfg.mode
                        cfg.modify_mode_color(cfg.mode)
                    end 

                    function cfg.set(input)
                        if type(input) == "boolean" then 
                            local __cached = input 

                            if cfg.mode == "Always" then 
                                __cached = true 
                            end 

                            cfg.active = __cached 
                            cfg.callback(__cached)
                        elseif tostring(input):find("Enum") then 
                            input = input.Name == "Escape" and nil or input

                            cfg.key = input

                            cfg.callback(cfg.active or false)
                        elseif find({"Toggle", "Hold", "Always"}, input) then 
                            cfg.set_mode(input)

                            if input == "Always" then 
                                cfg.active = true 
                            end 

                            cfg.callback(cfg.active or false)
                        elseif type(input) == "table" then 
                            input.key = type(input.key) == "string" and input.key ~= "..." and library:convert_enum(input.key) or input.key

                            input.key = input.key == Enum.KeyCode.Escape and nil or input.key
                            cfg.key = input.key

                            input.mode = cfg.force_toggle and "Toggle" or (input.mode or "Toggle")
                            cfg.mode = input.mode
                            cfg.set_mode(input.mode)

                            if input.active then
                                cfg.active = input.active
                            end
                        end 

                        flags[cfg.flag] = {
                            name = cfg.name,
                            mode = cfg.mode,
                            key = cfg.key, 
                            active = cfg.active
                        }

                        library:update_keybind_visualizer()

                        local _text = cfg.key and tostring(cfg.key) ~= "Enums" and (keys[cfg.key] or tostring(cfg.key):gsub("Enum.", "")) or nil
                        local __text = _text and (tostring(_text):gsub("KeyCode.", ""):gsub("UserInputType.", "")) or "none"

                        text.Text = " ".. __text .." "

                    end

                    function cfg.set_visible(bool)
                        accent.Visible = bool

                        accent.Size = dim2(0, keybind_holder.AbsoluteSize.X, 0, accent.Size.Y.Offset)
                        accent.Position = dim2(0, keybind_holder.AbsolutePosition.X, 0, keybind_holder.AbsolutePosition.Y + 77)
                    end

                local function get_input_key(input)
                    if input.UserInputType == Enum.UserInputType.Keyboard then
                        return input.KeyCode
                    end

                    return input.UserInputType
                end

                    keybind_holder.MouseButton1Down:Connect(function()
                        task.wait()
                        text.Text = "..."    

                        cfg.binding = library:connection(uis.InputBegan, function(input, game_event)  
                            cfg.set(get_input_key(input))

                            cfg.binding:Disconnect() 
                            cfg.binding = nil
                        end)
                    end)

                    keybind_holder.MouseButton2Down:Connect(function()
                        cfg.open = not cfg.open 

                        cfg.set_visible(cfg.open) 
                    end)

                    library:connection(uis.InputBegan, function(input, game_event) 
                        if game_event then return end

                        local selected_key = get_input_key(input)
                        if selected_key == cfg.key then 
                            if cfg.mode == "Toggle" then 
                                cfg.active = not cfg.active
                                cfg.set(cfg.active)
                            elseif cfg.mode == "Hold" then 
                                cfg.set(true)
                            end
                        end
                    end)

                    library:connection(uis.InputEnded, function(input, game_event) 
                        if game_event then 
                            return 
                        end 

                        local selected_key = get_input_key(input)
                        if selected_key == cfg.key then
                            if cfg.mode == "Hold" then 
                                cfg.set(false)
                            end
                        end

                        if input.UserInputType == Enum.UserInputType.MouseButton1 then 
                            if not (library:mouse_in_frame(keybind_holder) or library:mouse_in_frame(accent)) then 
                                cfg.open = false
                                cfg.set_visible(false)
                            end
                        end
                    end)

                config_flags[cfg.flag] = cfg.set
                cfg.set({mode = cfg.mode, active = cfg.active, key = cfg.key})

                return setmetatable(cfg, library)
            end

            function library:button(options) 
                local cfg = {
                    name = options.name or "button",
                    callback = options.callback or function() end,
                }

                    local frame = library:create("TextButton", {
                        AnchorPoint = vec2(1, 0);
                        Text = "";
                        AutoButtonColor = false;
                        Parent = self.elements;
                        Position = dim2(1, 0, 0, 0);
                        BorderColor3 = rgb(0, 0, 0);
                        Size = dim2(0, 136, 0, 16);
                        BorderSizePixel = 0;
                        BackgroundColor3 = themes.preset[tostring(self.count)]
                    }); library:apply_theme(frame, tostring(self.count), "BackgroundColor3")

                    local frame_inline = library:create("Frame", {
                        Parent = frame;
                        Position = dim2(0, 1, 0, 1);
                        BorderColor3 = rgb(0, 0, 0);
                        Size = dim2(1, -2, 1, -2);
                        BorderSizePixel = 0;
                        BackgroundColor3 = themes.preset.inline
                    }); library:apply_theme(frame_inline, "inline", "BackgroundColor3")

                    local text = library:create("TextLabel", {
                        FontFace = fonts["ProggyClean"];
                        TextColor3 = rgb(255, 255, 255);
                        BorderColor3 = rgb(0, 0, 0);
                        Text = cfg.name;
                        Parent = frame;
                        Size = dim2(1, 0, 1, 0);
                        BackgroundTransparency = 1;
                        Position = dim2(0, 1, 0, -1);
                        BorderSizePixel = 0;
                        AutomaticSize = Enum.AutomaticSize.X;
                        TextSize = 12;
                        BackgroundColor3 = rgb(255, 255, 255)
                    });

                    frame.MouseButton1Click:Connect(function()
                        cfg.callback()
                    end)

                return setmetatable(cfg, library)
            end 

            function library:init_config(window) 
                local textbox;
                local misc_tab

                for _, tab in next, window.tabs or {} do
                    if type(tab.name) == "string" and tab.name:lower() == "misc" then
                        misc_tab = tab
                        break
                    end
                end

                if not misc_tab then
                    misc_tab = window:tab({name = "misc"})
                end

                local misc_left = misc_tab:column({}) 
                local misc_center = misc_tab:column({}) 
                local config_column = misc_tab:column({})

                local misc_section = misc_left:section({name = "misc", size = 1, default = true})
                library.freecam_keybind = misc_section:keybind({
                    name = "freecam",
                    flag = "freecam_key",
                    key = Enum.KeyCode.F4,
                    mode = "toggle",
                    force_toggle = true,
                    callback = function(active)
                        freecam.set_active(active)
                    end,
                })
                misc_section:dropdown({name = "fov", flag = "aimbot_fov_circle", items = {"off", "circle"}, default = "circle"})
                misc_section:colorpicker({name = "fov color", flag = "aimbot_fov_color", color = rgb(255, 255, 255)})

                local movement_section = misc_left:section({name = "movement", size = 1, default = true})
                movement_section:keybind({
                    name = "speedhack",
                    flag = "speedhack_key",
                    key = Enum.KeyCode.X,
                    mode = "toggle",
                })
                movement_section:slider({name = "speed", flag = "speedhack_speed", min = 12, max = 200, default = 16, interval = 1, suffix = "studs/s"})
                movement_section:toggle({name = "jump restriction", flag = "no_jump_restrictions", default = false, enabled = false})

                local fov_section = misc_center:section({name = "fov changer", auto_fill = true, size = 1})
                fov_section:toggle({name = "enabled", flag = "fov_changer_enabled", default = false, enabled = false})
                fov_section:slider({name = "amount", flag = "fov_changer_amount", min = 60, max = 140, default = 90, interval = 1, suffix = ""})
                fov_section:keybind({
                    name = "zoom key",
                    flag = "fov_changer_zoom_key",
                    key = Enum.KeyCode.Z,
                    mode = "Hold",
                })
                fov_section:slider({name = "zoom amount", flag = "fov_changer_zoom_amount", min = 0, max = 120, default = 60, interval = 1, suffix = ""})

                local section = config_column:section({name = "config", size = 1, default = true})
                section:keybind({
                    name = "menu key",
                    flag = "menu_key",
                    key = Enum.KeyCode.Insert,
                    mode = "toggle",
                    force_toggle = true,
                    ignore = true,
                    callback = function(active)
                        window.toggle_menu(active)
                    end,
                })
                config_holder = section:dropdown({name = "config", options = {"Report", "This", "Error", "To", "Finobe"}, callback = function(option) if textbox then textbox.set(option) end end, flag = "config_name_list"}); library:update_config_list()
                textbox = section:textbox({name = "Config name:", flag = "config_name_text"})
                section:button({name = "Save", callback = function() writefile(library.directory .. "/configs/" .. flags["config_name_text"] .. ".cfg", library:get_config()) library:update_config_list() end}) 
                section:button({name = "Load", callback = function() library:load_config(readfile(library.directory .. "/configs/" .. flags["config_name_text"] .. ".cfg"))  library:update_config_list() end})
                section:button({name = "Delete", callback = function() delfile(library.directory .. "/configs/" .. flags["config_name_text"] .. ".cfg")  library:update_config_list() end})

                local section = config_column:section({name = "theme", size = 1, default = true})
                section:dropdown({
                    name = "theme",
                    flag = "theme",
                    items = {"morytania", "ancient", "new", "dark"},
                    callback = function(value)
                        if value == "ancient" then
                            local a1 = rgb(109, 78, 110)
                            local a2 = rgb(54, 82, 114)
                            local a3 = rgb(0, 88, 126)

                            library:update_theme("1", a1)
                            library:update_theme("2", a2)
                            library:update_theme("3", a3)

                            library.gradient.Color = rgbseq{
                                rgbkey(0, a1),
                                rgbkey(0.5, a2),
                                rgbkey(1, a3),
                            };

                            library.watermark_gradient.Color = rgbseq{
                                rgbkey(0, a1),
                                rgbkey(0.5, a2),
                                rgbkey(1, a3),
                            };
                        elseif value == "new" then
                            local n1 = hex("#360820")
                            local n2 = hex("#360820")
                            local n3 = hex("#360820")

                            library:update_theme("1", n1)
                            library:update_theme("2", n2)
                            library:update_theme("3", n3)

                            library.gradient.Color = rgbseq{
                                rgbkey(0, n1),
                                rgbkey(0.5, n2),
                                rgbkey(1, n3),
                            };

                            library.watermark_gradient.Color = rgbseq{
                                rgbkey(0, n1),
                                rgbkey(0.5, n2),
                                rgbkey(1, n3),
                            };
                        elseif value == "dark" then
                            local g = hex("#1D1D1D")

                            library:update_theme("1", g)
                            library:update_theme("2", g)
                            library:update_theme("3", g)

                            library.gradient.Color = rgbseq{
                                rgbkey(0, g),
                                rgbkey(0.5, g),
                                rgbkey(1, g),
                            };

                            library.watermark_gradient.Color = rgbseq{
                                rgbkey(0, g),
                                rgbkey(0.5, g),
                                rgbkey(1, g),
                            };
                        else
                            local m1 = hex("#245771")
                            local m2 = hex("#215D63")
                            local m3 = hex("#1E6453")

                            library:update_theme("1", m1)
                            library:update_theme("2", m2)
                            library:update_theme("3", m3)

                            library.gradient.Color = rgbseq{
                                rgbkey(0, m1), 
                                rgbkey(0.5, m2),
                                rgbkey(1, m3),
                            };

                            library.watermark_gradient.Color = rgbseq{
                                rgbkey(0, m1), 
                                rgbkey(0.5, m2),
                                rgbkey(1, m3),
                            };
                        end
                    end,
                    default = "morytania"
                })
            end

local window = library:window({
	name = "priv9.net | " .. game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name,
})

library:connection(uis.InputBegan, function(input, gameProcessed)

    local menu_key = flags.menu_key

    if menu_key and menu_key.key then
        if input.KeyCode == menu_key.key then
            window.toggle_menu(not window.main_outline.Visible)
        end
    elseif input.KeyCode == Enum.KeyCode.Insert then
        window.toggle_menu(not window.main_outline.Visible)
    end
end)

local esp 

local aimbot_enabled = false
local aimbot_silent = false
local aimbot_target_team = false

local rage = window:tab({name = "rage"})
local column = rage:column({})
local section = column:section({name = "aimbot", auto_fill = false, size = 0.3})
local section2 = column:section({name = "target selection", auto_fill = true, size = 0.7})
local aimbot_enabled_toggle = section:toggle({name = "enabled", flag = "aimbot_enabled", default = false, enabled = false, callback = function(value)
    aimbot_enabled = value
    flags["aimbot_enabled"] = value
end})
aimbot_enabled_toggle.set(false)
flags["aimbot_enabled"] = false
section:keybind({name = "aim key", flag = "aim_key", key = Enum.UserInputType.MouseButton2, mode = "Hold"})
section:toggle({name = "silent", flag = "aimbot_silent", default = false, enabled = false, callback = function(value)
    aimbot_silent = value
    flags["aimbot_silent"] = value
end})
section:slider({name = "smooth", flag = "aimbot_smooth", min = 0, max = 10, default = 1, interval = 0.1, suffix = ""})

section2:toggle({name = "target team", flag = "aimbot_target_team", default = false, enabled = false, callback = function(value)
    aimbot_target_team = value
    flags["aimbot_target_team"] = value
end})
section2:dropdown({name = "hitbox", flag = "aimbot_hitbox", items = {"head","body"}, default = "body"})
section2:slider({name = "fov", flag = "aimbot_fov", min = 0, max = 360, default = 40, interval = 1, suffix = ""})
section2:slider({name = "max distance", flag = "aimbot_max_distance", min = 0, max = 5000, default = 0, interval = 1, suffix = ""})

local column = rage:column({})
local section = column:section({name = "weapon modifications"})

section:toggle({name = "no-spread", flag = "no_spread", default = false, enabled = false})
section:slider({name = "recoil multiplier", min = 0, max = 10, default = 10, interval = 0.1, suffix = ""})
section:slider({name = "bullet thickness", min = 0, max = 10, default = 10, interval = 0.1, suffix = ""})
section:slider({name = "bullet speed", min = 0, max = 10, default = 10, interval = 0.1, suffix = ""})

local section2 = column:section({name = "other", auto_fill = true, size = 0.7})

section:button({name = "Test notification", callback = function()
    notifications:create_notification({name = "NOTIFICATION TESTING"})
end})

local visuals_tab = window:tab({name = "visuals"})
local visuals_left = visuals_tab:column({})
local visuals_center = visuals_tab:column({})
local visuals_right = visuals_tab:column({})

local selection_section = visuals_left:section({name = "selection", size = 1, default = true})
local selection_inner = library:create_visuals_selection(selection_section)
library:apply_theme(selection_section.frame, tostring(selection_section.count), "BackgroundColor3")
local visuals_pages = {}
local pages = {
    {id = "player", label = "player", center_label = "filter (players)", right_label = "options (player)"},
    {id = "misc", label = "misc"},
}

for _, page in next, pages do

    if page.id == "scientist" then

        local rnd = function() return tostring(math.random(1000, 9999)) end

        local c1 = visuals_center:section({name = "filter_" .. rnd(), auto_fill = false, size = 0.5})
        local c2 = visuals_center:section({name = "details_" .. rnd(), auto_fill = false, size = 0.5})

        local r1 = visuals_right:section({name = "options_" .. rnd(), auto_fill = false, size = 0.5})
        local r2 = visuals_right:section({name = "meta_" .. rnd(), auto_fill = false, size = 0.5})

        c1:toggle({name = "enable scientist", flag = "scientist_enable"})
        c2:slider({name = "scientist power", min = 0, max = 100, default = 50, interval = 1, suffix = ""})

        r1:button({name = "Apply", callback = function() notifications:create_notification({name = "Applied scientist settings"}) end})
        r2:dropdown({name = "mode", flag = "scientist_mode", items = {"Alpha", "Beta", "Gamma"}, default = "Alpha"})

        local page_entry = library:register_visuals_page(page.id, page.label, {c1, c2}, {r1, r2})
        visuals_pages[page.id] = page_entry
    else
        local page_data = library:create_visuals_page(visuals_center, visuals_right, page)

        local page_entry = library:register_visuals_page(page.id, page.label, page_data.center, page_data.right)
        visuals_pages[page.id] = page_entry
    end
end

do
    local player_page = visuals_pages["player"]
    if player_page and player_page.center and player_page.right then
        local c = player_page.center
        local r = player_page.right

        c:slider({name = "max distance", flag = "player_max_distance", min = 0, max = 5000, default = 0, interval = 1, suffix = ""})
        c:toggle({name = "enabled", flag = "Enabled", default = true, callback = function() if esp then esp.refresh_elements() end end})
        c:toggle({name = "teammates", flag = "player_teammates", default = true, callback = function() if esp then esp.refresh_elements() end end})
        c:toggle({name = "local", flag = "player_local", default = true, callback = function() if esp then esp.refresh_elements() end end})

        r:toggle({name = "box", flag = "Boxes", default = true, callback = function() if esp then esp.refresh_elements() end end})
        r:toggle({name = "skeleton", flag = "Skeletons", default = true, callback = function() if esp then esp.refresh_elements() end end})
        r:colorpicker({name = "box/skel color", flag = "Box_Color", callback = function(Color)
            flags["Skeletons_Color"] = { Color = Color }
            if esp then esp.refresh_elements() end
        end})
        r:toggle({name = "health bar", flag = "Healthbar", default = true, callback = function() if esp then esp.refresh_elements() end end})
        r:toggle({name = "name", flag = "Names", default = true, callback = function() if esp then esp.refresh_elements() end end})
        r:colorpicker({name = "text color", flag = "Name_Color", callback = function(Color)
            flags["Distance_Color"] = { Color = Color }
            flags["Weapon_Color"] = { Color = Color }
            if esp then esp.refresh_elements() end
        end})
        r:toggle({name = "weapon", flag = "Weapon", default = true, callback = function() if esp then esp.refresh_elements() end end})
        r:toggle({name = "distance", flag = "Distance", default = true, callback = function() if esp then esp.refresh_elements() end end})
        r:toggle({name = "flags", flag = "player_flags", callback = function() if esp then esp.refresh_elements() end end})
        r:toggle({name = "offscreen arrow", flag = "player_offscreen"})
        r:colorpicker({name = "offscreen color", flag = "player_offscreen_color"})

        local model_fill, model_outline

        r:dropdown({name = "model", flag = "player_model", items = {"off", "ontop", "occluded"}, default = "off", callback = function(mode)
            local show = mode ~= "off"

            if model_fill and model_fill.frame then
                model_fill.frame.Visible = show
                if not show then
                    model_fill.open = false
                    model_fill.set_visible(false)
                end
            end

            if model_outline and model_outline.frame then
                model_outline.frame.Visible = show
                if not show then
                    model_outline.open = false
                    model_outline.set_visible(false)
                end
            end

            if esp then esp.refresh_elements() end
        end})

        model_fill = r:colorpicker({name = "fill", flag = "player_highlight_fill", color = rgb(255, 255, 255), callback = function()
            if esp then esp.refresh_elements() end
        end})

        model_outline = r:colorpicker({name = "outline", flag = "player_highlight_outline", color = rgb(0, 0, 0), callback = function()
            if esp then esp.refresh_elements() end
        end})

        model_fill.frame.Visible = false
        model_outline.frame.Visible = false
    end
end

library:set_visuals_page("player")

local misc_tab = window:tab({name = "misc"})

library:init_config(window)

run.Stepped:Connect(function()
    if not flags["fov_changer_enabled"] then
        return
    end

    local fov = flags["fov_changer_amount"] or 90

    local zoom_key = flags["fov_changer_zoom_key"]
    if type(zoom_key) == "table" and zoom_key.active then
        fov = flags["fov_changer_zoom_amount"] or 60
    end

    if type(fov) == "number" then
        camera.FieldOfView = math.max(1, fov)
    end
end)

local jump_original = { autojump = nil, jumppower = nil, jumpheight = nil }
local jump_was_active = false

run.Stepped:Connect(function(_, dt)
    local character = lp.Character
    if not character then
        return
    end

    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid then
        return
    end

    local speedhack_key = flags["speedhack_key"]
    local speedhack_active = type(speedhack_key) == "table" and speedhack_key.active or false

    if speedhack_active then
        local rootpart = humanoid.RootPart or character:FindFirstChild("HumanoidRootPart")
        if rootpart and humanoid.Health > 0 then
            local move_dir = humanoid.MoveDirection
            if move_dir.Magnitude > 0 then

                local speed = clamp(flags["speedhack_speed"] or 16, 1, 200)
                rootpart.CFrame = rootpart.CFrame + move_dir * (speed * dt)
            end
        end
    end

    local no_jump_active = flags["no_jump_restrictions"] == true

    if no_jump_active then
        if not jump_was_active then
            jump_original.autojump = humanoid.AutoJumpEnabled
            if humanoid.UseJumpPower then
                jump_original.jumppower = humanoid.JumpPower
            else
                jump_original.jumpheight = humanoid.JumpHeight
            end
            jump_was_active = true
        end

        humanoid.AutoJumpEnabled = true
        humanoid.JumpHeight = 50
        humanoid.JumpPower = 50

        if uis:IsKeyDown(Enum.KeyCode.Space) then
            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    elseif jump_was_active then
        humanoid.AutoJumpEnabled = jump_original.autojump
        if humanoid.UseJumpPower then
            humanoid.JumpPower = jump_original.jumppower
        else
            humanoid.JumpHeight = jump_original.jumpheight
        end
        jump_was_active = false
    end
end)

local aimbot_circle = nil
local aimbot_aiming = false

local function get_aimbot_color()
    local value = flags["aimbot_fov_color"]
    if type(value) == "table" and value.Color then
        return value.Color
    elseif typeof(value) == "Color3" then
        return value
    end
    return rgb(255, 255, 255)
end

local function get_aimbot_hit_part(character)
    local hitbox = flags["aimbot_hitbox"] or "body"
    if hitbox == "head" and character:FindFirstChild("Head") then
        return character.Head
    end
    return character:FindFirstChild("HumanoidRootPart")
end

local function is_valid_aimbot_target(player)
    if player == lp then
        return false
    end

    if not player.Character or not player.Character.Parent then
        return false
    end

    local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
    if not humanoid or humanoid.Health <= 0 then
        return false
    end

    local rootpart = player.Character:FindFirstChild("HumanoidRootPart")
    if not rootpart then
        return false
    end

    local local_team = lp.Team
    if local_team and player.Team == local_team then
        return aimbot_target_team == true
    end

    return true
end

local function get_closest_aimbot_target()
    local best = nil
    local best_distance = math.huge
    local fov = flags["aimbot_fov"] or 0
    local max_distance = flags["aimbot_max_distance"] or 0
    local center_pos = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2)

    for _, player in ipairs(players:GetPlayers()) do
        if is_valid_aimbot_target(player) and player.Character then
            local target_part = get_aimbot_hit_part(player.Character)
            if target_part then
                local rootpart = player.Character:FindFirstChild("HumanoidRootPart")
                if rootpart then
                    local world_distance = (rootpart.Position - camera.CFrame.Position).Magnitude
                    if max_distance > 0 and world_distance > max_distance then
                        continue
                    end

                    local screen_pos, on_screen = camera:WorldToScreenPoint(target_part.Position)
                    if not on_screen then
                        continue
                    end

                    local inset = gui_service:GetGuiInset()
                    screen_pos = Vector2.new(screen_pos.X + inset.X, screen_pos.Y + inset.Y)

                    local screen_distance = (screen_pos - center_pos).Magnitude
                    if screen_distance <= fov and screen_distance < best_distance then
                        best_distance = screen_distance
                        best = player
                    end
                end
            end
        end
    end

    return best
end

local function update_aimbot_circle()
    local show_mode = flags["aimbot_fov_circle"] or "off"

    if show_mode == "circle" then
        if not aimbot_circle then
            aimbot_circle = Drawing.new("Circle")
            aimbot_circle.Thickness = 1
            aimbot_circle.NumSides = 64
            aimbot_circle.Filled = false
            aimbot_circle.Transparency = 1
        end

        aimbot_circle.Visible = true
        aimbot_circle.Position = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2)
        aimbot_circle.Radius = flags["aimbot_fov"] or 0
        aimbot_circle.Color = get_aimbot_color()
    else
        if aimbot_circle then
            aimbot_circle:Remove()
            aimbot_circle = nil
        end
    end
end

local function is_aim_key_active()
    local keybind = flags["aim_key"]
    return keybind and keybind.active
end

local function get_aim_part_name()
    local hitbox = flags["aimbot_hitbox"] or "body"
    if hitbox == "head" then
        return "Head"
    end
    return "HumanoidRootPart"
end

if flags["aimbot_enabled"] == nil then flags["aimbot_enabled"] = false end
if flags["aimbot_silent"] == nil then flags["aimbot_silent"] = false end
if flags["aimbot_target_team"] == nil then flags["aimbot_target_team"] = false end
if flags["aimbot_fov"] == nil then flags["aimbot_fov"] = 40 end
if flags["aimbot_max_distance"] == nil then flags["aimbot_max_distance"] = 0 end
if flags["aimbot_smooth"] == nil then flags["aimbot_smooth"] = 10 end
if flags["aimbot_fov_circle"] == nil then flags["aimbot_fov_circle"] = "circle" end
if flags["aimbot_fov_color"] == nil then flags["aimbot_fov_color"] = { Color = rgb(255, 255, 255) } end

run:BindToRenderStep("PrivAimbot", Enum.RenderPriority.Character.Value, function()
    update_aimbot_circle()

    local locked = false

    if aimbot_enabled and is_aim_key_active() then
        local target = get_closest_aimbot_target()
        if target and target.Character then
            local part = get_aimbot_hit_part(target.Character)
            if part and not aimbot_silent then
                local camera_cframe = camera.CFrame
                local camera_pos = camera_cframe.Position
                local target_position = part.Position

                local new_cframe = CFrame.lookAt(camera_pos, target_position, camera_cframe.UpVector)

                local smooth_value = flags["aimbot_smooth"] or 0
                local smooth_factor = smooth_value <= 0 and 1 or math.clamp(1 / (smooth_value + 1), 0.01, 1)
                camera.CFrame = camera.CFrame:Lerp(new_cframe, smooth_factor)

                if freecam:IsActive() then
                    freecam:SetOverride(camera.CFrame)
                end

                locked = true
            end
        end
    end

    if not locked then
        freecam:ClearOverride()
    end
end)

task.spawn(function()
    task.wait(1)
    notifications:create_notification({name = "welcome " .. string.lower(game.Players.LocalPlayer.Name) .. "!"})
end)

    local bones = {

        {"Head", "UpperTorso"},
        {"UpperTorso", "LowerTorso"},
        {"UpperTorso", "LeftUpperArm"},
        {"UpperTorso", "RightUpperArm"},
        {"LeftUpperArm", "LeftLowerArm"},
        {"RightUpperArm", "RightLowerArm"},
        {"LeftLowerArm", "LeftHand"},
        {"RightLowerArm", "RightHand"},
        {"LowerTorso", "LeftUpperLeg"},
        {"LowerTorso", "RightUpperLeg"},
        {"LeftUpperLeg", "LeftLowerLeg"},
        {"RightUpperLeg", "RightLowerLeg"},
        {"LeftLowerLeg", "LeftFoot"},
        {"RightLowerLeg", "RightFoot"},

    }

    flags["Health_High"] = flags["Health_High"] or { Color = rgb(0, 255, 0) }
    flags["Health_Low"] = flags["Health_Low"] or { Color = rgb(255, 0, 0) }
    flags["Box_Type"] = flags["Box_Type"] or "Normal"
    if flags["Boxes"] == nil then flags["Boxes"] = true end
    if flags["Names"] == nil then flags["Names"] = true end
    if flags["Distance"] == nil then flags["Distance"] = true end
    if flags["Weapon"] == nil then flags["Weapon"] = true end
    if flags["Skeletons"] == nil then flags["Skeletons"] = true end
    if flags["player_flags"] == nil then flags["player_flags"] = false end
    if flags["player_local"] == nil then flags["player_local"] = true end
    if flags["player_teammates"] == nil then flags["player_teammates"] = false end
    if flags["player_max_distance"] == nil then flags["player_max_distance"] = 0 end

    if flags["player_model"] == nil then flags["player_model"] = "off" end
    flags["player_highlight_fill"] = flags["player_highlight_fill"] or { Color = rgb(255, 255, 255), Transparency = 0 }
    flags["player_highlight_outline"] = flags["player_highlight_outline"] or { Color = rgb(0, 0, 0), Transparency = 0 }

    local esp_fonts = {}; do
        local TahomaBold = Register_Font("TahomaBold", 700, "Normal", {
            Id = "TahomaBold.ttf",
            Font = game:HttpGet("https://github.com/i77lhm/storage/raw/refs/heads/main/fonts/tahoma_bold.ttf"),
        })

        local SmallestPixel = Register_Font("SmallestPixel", 400, "Normal", {
            Id = "SmallestPixel.ttf",
            Font = game:HttpGet("https://github.com/i77lhm/storage/raw/refs/heads/main/fonts/smallest_pixel-7.ttf"),
        })

        esp_fonts = {
            main = Font.new(TahomaBold, Enum.FontWeight.Regular, Enum.FontStyle.Normal);
            secondary = Font.new(SmallestPixel, Enum.FontWeight.Regular, Enum.FontStyle.Normal);
        }
    end

    esp = { players = {}, screengui = Instance.new("ScreenGui", gethui()), cache = Instance.new("ScreenGui", gethui()), connections = {}}; do
        esp.screengui.IgnoreGuiInset = true
        esp.screengui.DisplayOrder = -1000
        esp.screengui.Name = "\0"

        esp.cache.Enabled = false

            function esp:get_screen_pos(world_position)
                local viewport_size = camera.ViewportSize
                local local_position = camera.CFrame:pointToObjectSpace(world_position) 

                local aspect_ratio = viewport_size.x / viewport_size.y
                local half_height = -local_position.z * math.tan(math.rad(camera.FieldOfView / 2))
                local half_width = aspect_ratio * half_height

                local far_plane_corner = Vector3.new(-half_width, half_height, local_position.z)
                local relative_position = local_position - far_plane_corner

                local screen_x = relative_position.x / (half_width * 2)
                local screen_y = -relative_position.y / (half_height * 2)

                local is_on_screen = -local_position.z > 0 and screen_x >= 0 and screen_x <= 1 and screen_y >= 0 and screen_y <= 1

                return Vector3.new(screen_x * viewport_size.x, screen_y * viewport_size.y, -local_position.z), is_on_screen
            end

            function esp:box_solve(torso)
                if not torso then
                    return nil, nil, nil
                end

                local ViewportTop = torso.Position + (torso.CFrame.UpVector * 1.8) + camera.CFrame.UpVector
                local ViewportBottom = torso.Position - (torso.CFrame.UpVector * 2.5) - camera.CFrame.UpVector
                local Distance = (torso.Position - camera.CFrame.p).Magnitude

                local Top, TopIsRendered = esp:get_screen_pos(ViewportTop)
                local Bottom, BottomIsRendered = esp:get_screen_pos(ViewportBottom)

                local Width = math.max(math.floor(math.abs(Top.X - Bottom.X)), 3)
                local Height = math.max(math.floor(math.max(math.abs(Bottom.Y - Top.Y), Width / 2)), 3)
                local BoxSize = Vector2.new(math.floor(math.max(Height / 1.5, Width)), Height)
                local BoxPosition = Vector2.new(math.floor(Top.X * 0.5 + Bottom.X * 0.5 - BoxSize.X * 0.5), math.floor(math.min(Top.Y, Bottom.Y)))

                return BoxSize, BoxPosition, TopIsRendered, Distance

            end

            function esp:create(instance, options)
                local ins = Instance.new(instance) 

                for prop, value in options do 
                    ins[prop] = value
                end

                return ins 
            end

            function esp:create_object( player )
                esp[ player.Name ] = {
                    objects = {},
                    info = {
                        character = nil,
                        humanoid = nil,
                        rootpart = nil,
                    },
                    drawings = {},
                    connections = {},          
                    player_connections = {},   
                }
                local data = esp[ player.Name ]

                local objects = data.objects; do
                    objects[ "holder" ] = esp:create( "Frame" , {
                        Parent = esp.screengui;
                        Name = "\0";
                        BackgroundTransparency = 1;
                        Position = dim2(0, 0, 0, 0);
                        BorderColor3 = rgb(0, 0, 0);
                        Size = dim2(0, 0, 0, 0);
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(255, 255, 255)
                    });

                    objects[ "box_outline" ] = esp:create( "UIStroke" , {
                        Parent = (flags["Boxes"] and flags["Box_Type"] ~= "Corner" and objects["holder"]) or esp.cache;
                        LineJoinMode = Enum.LineJoinMode.Miter
                    });

                    objects[ "name" ] = esp:create( "TextLabel" , {
                        FontFace = esp_fonts.main;
                        Parent = objects[ "holder" ];
                        TextColor3 = flags["Name_Color"].Color;
                        BorderColor3 = rgb(0, 0, 0);
                        Text = player.Name;
                        Name = "\0";
                        TextStrokeTransparency = 0;
                        AnchorPoint = vec2(0.5, 1);
                        Size = dim2(1, 0, 0, 0);
                        BackgroundTransparency = 1;
                        Position = dim2(0.5, 0, 0, -4);
                        BorderSizePixel = 0;
                        AutomaticSize = Enum.AutomaticSize.Y;
                        TextSize = 12;
                    });

                    objects[ "box_handler" ] = esp:create( "Frame" , {
                        Parent = (flags["Boxes"] and flags["Box_Type"] ~= "Corner" and objects["holder"]) or esp.cache;
                        Name = "\0";
                        BackgroundTransparency = 1;
                        Position = dim2(0, 1, 0, 1);
                        BorderColor3 = rgb(0, 0, 0);
                        Size = dim2(1, -2, 1, -2);
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(255, 255, 255)
                    });

                    objects[ "box_color" ] = esp:create( "UIStroke" , {
                        Color = flags["Box_Color"] and flags["Box_Color"].Color or rgb(255, 255, 255);
                        LineJoinMode = Enum.LineJoinMode.Miter;
                        Name = "\0";
                        Parent = objects[ "box_handler" ]
                    });

                    objects[ "outline" ] = esp:create( "Frame" , {
                        Parent = objects[ "box_handler" ];
                        Name = "\0";
                        BackgroundTransparency = 1;
                        Position = dim2(0, 1, 0, 1);
                        BorderColor3 = rgb(0, 0, 0);
                        Size = dim2(1, -2, 1, -2);
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(255, 255, 255)
                    });

                    objects[ "outline_stroke" ] = esp:create( "UIStroke" , {
                        Parent = objects[ "outline" ];
                        LineJoinMode = Enum.LineJoinMode.Miter;
                        Transparency = 0;
                    });  

                        objects[ "corners" ] = esp:create( "Frame" , {
                            Visible = true;
                            BorderColor3 = rgb(0, 0, 0);
                            Parent = flags["Boxes"] and flags["Box_Type"] == "Corner" and objects["holder"] or esp.cache;
                            BackgroundTransparency = 1;
                            Position = dim2(0, -1, 0, 2);
                            Name = "\0";
                            Size = dim2(1, 0, 1, 0);
                            BorderSizePixel = 0;
                            BackgroundColor3 = rgb(255, 255, 255)
                        });

                        objects[ "1" ] = esp:create( "Frame" , {
                            Parent = objects[ "corners" ];
                            Name = "line";
                            Position = dim2(0, 0, 0, -2);
                            BorderColor3 = rgb(0, 0, 0);
                            Size = dim2(0.4, 0, 0, 3);
                            BorderSizePixel = 0;
                            BackgroundColor3 = rgb(0, 0, 0)
                        });

                        esp:create( "Frame" , {
                            Parent = objects[ "1" ];
                            Position = dim2(0, 1, 0, 1);
                            BorderColor3 = rgb(0, 0, 0);
                            Size = dim2(1, -2, 1, -2);
                            BorderSizePixel = 0;
                            BackgroundColor3 = flags["Box_Color"].Color
                        });

                        objects[ "2" ] = esp:create( "Frame" , {
                            Parent = objects[ "corners" ];
                            Name = "line";
                            Position = dim2(0, 0, 0, 1);
                            BorderColor3 = rgb(0, 0, 0);
                            Size = dim2(0, 3, 0.25, 0);
                            BorderSizePixel = 0;
                            BackgroundColor3 = rgb(0, 0, 0)
                        });

                        esp:create( "Frame" , {
                            Parent = objects[ "2" ];
                            Position = dim2(0, 1, 0, -2);
                            BorderColor3 = rgb(0, 0, 0);
                            Size = dim2(1, -2, 1, 1);
                            BorderSizePixel = 0;
                            BackgroundColor3 = flags["Box_Color"].Color
                        });

                        objects[ "3" ] = esp:create( "Frame" , {
                            AnchorPoint = vec2(1, 0);
                            Parent = objects[ "corners" ];
                            Name = "line";
                            Position = dim2(1, 0, 0, -2);
                            BorderColor3 = rgb(0, 0, 0);
                            Size = dim2(0.4, 0, 0, 3);
                            BorderSizePixel = 0;
                            BackgroundColor3 = rgb(0, 0, 0)
                        });

                        esp:create( "Frame" , {
                            Parent = objects[ "3" ];
                            Position = dim2(0, 1, 0, 1);
                            BorderColor3 = rgb(0, 0, 0);
                            Size = dim2(1, -2, 1, -2);
                            BorderSizePixel = 0;
                            BackgroundColor3 = flags["Box_Color"].Color
                        });

                        objects[ "4" ] = esp:create( "Frame" , {
                            AnchorPoint = vec2(1, 0);
                            Parent = objects[ "corners" ];
                            Name = "line";
                            Position = dim2(1, 0, 0, 1);
                            BorderColor3 = rgb(0, 0, 0);
                            Size = dim2(0, 3, 0.25, 0);
                            BorderSizePixel = 0;
                            BackgroundColor3 = rgb(0, 0, 0)
                        });

                        esp:create( "Frame" , {
                            Parent = objects[ "4" ];
                            Position = dim2(0, 1, 0, -2);
                            BorderColor3 = rgb(0, 0, 0);
                            Size = dim2(1, -2, 1, 1);
                            BorderSizePixel = 0;
                            BackgroundColor3 = flags["Box_Color"].Color
                        });

                        objects[ "5" ] = esp:create( "Frame" , {
                            AnchorPoint = vec2(0, 1);
                            Parent = objects[ "corners" ];
                            Name = "line";
                            Position = dim2(0, 0, 1, -2);
                            BorderColor3 = rgb(0, 0, 0);
                            Size = dim2(0.4, 0, 0, 3);
                            BorderSizePixel = 0;
                            BackgroundColor3 = rgb(0, 0, 0)
                        });

                        esp:create( "Frame" , {
                            Parent = objects[ "5" ];
                            Position = dim2(0, 1, 0, 1);
                            BorderColor3 = rgb(0, 0, 0);
                            Size = dim2(1, -2, 1, -2);
                            BorderSizePixel = 0;
                            BackgroundColor3 = flags["Box_Color"].Color
                        });

                        objects[ "6" ] = esp:create( "Frame" , {
                            BorderColor3 = rgb(0, 0, 0);
                            Rotation = 180;
                            Parent = objects[ "corners" ];
                            Name = "line";
                            Position = dim2(0, 0, 1, -5);
                            AnchorPoint = vec2(0, 1);
                            Size = dim2(0, 3, 0.25, 0);
                            BorderSizePixel = 0;
                            BackgroundColor3 = rgb(0, 0, 0)
                        });

                        esp:create( "Frame" , {
                            Parent = objects[ "6" ];
                            Position = dim2(0, 1, 0, -2);
                            BorderColor3 = rgb(0, 0, 0);
                            Size = dim2(1, -2, 1, 1);
                            BorderSizePixel = 0;
                            BackgroundColor3 = flags["Box_Color"].Color
                        });

                        objects[ "7" ] = esp:create( "Frame" , {
                            AnchorPoint = vec2(1, 1);
                            Parent = objects[ "corners" ];
                            Name = "line";
                            Position = dim2(1, 0, 1, -2);
                            BorderColor3 = rgb(0, 0, 0);
                            Size = dim2(0.4, 0, 0, 3);
                            BorderSizePixel = 0;
                            BackgroundColor3 = rgb(0, 0, 0)
                        });

                        esp:create( "Frame" , {
                            Parent = objects[ "7" ];
                            Position = dim2(0, 1, 0, 1);
                            BorderColor3 = rgb(0, 0, 0);
                            Size = dim2(1, -2, 1, -2);
                            BorderSizePixel = 0;
                            BackgroundColor3 = flags["Box_Color"].Color
                        });

                        objects[ "7" ] = esp:create( "Frame" , {
                            BorderColor3 = rgb(0, 0, 0);
                            Rotation = 180;
                            Parent = objects[ "corners" ];
                            Name = "line";
                            Position = dim2(1, 0, 1, -5);
                            AnchorPoint = vec2(1, 1);
                            Size = dim2(0, 3, 0.25, 0);
                            BorderSizePixel = 0;
                            BackgroundColor3 = rgb(0, 0, 0)
                        });

                        esp:create( "Frame" , {
                            Parent = objects[ "7" ];
                            Position = dim2(0, 1, 0, -2);
                            BorderColor3 = rgb(0, 0, 0);
                            Size = dim2(1, -2, 1, 1);
                            BorderSizePixel = 0;
                            BackgroundColor3 = flags["Box_Color"].Color
                        });

                        objects[ "healthbar_holder" ] = esp:create( "Frame" , {
                            AnchorPoint = vec2(1, 0);
                            Parent = flags["Healthbar"] and objects[ "holder" ] or esp.cache;
                            Name = "\0";
                            Position = dim2(0, -2, 0, -1);
                            BorderColor3 = rgb(0, 0, 0);
                            Size = dim2(0, 4, 1, 2);
                            BorderSizePixel = 0;
                            ClipsDescendants = true;
                            BackgroundColor3 = rgb(0, 0, 0)
                        });

                        objects[ "healthbar" ] = esp:create( "Frame" , {
                            Parent = objects[ "healthbar_holder" ];
                            Name = "\0";
                            Position = dim2(0, 1, 0, 1);
                            BorderColor3 = rgb(0, 0, 0);
                            Size = dim2(1, -2, 1, -2);
                            BorderSizePixel = 0;
                            BackgroundColor3 = rgb(255, 255, 255)
                        });

                        objects[ "distance" ] = esp:create( "TextLabel" , {
                            FontFace = esp_fonts.secondary;
                            TextColor3 = flags["Distance_Color"].Color;
                            BorderColor3 = rgb(0, 0, 0);
                            Text = "38M";
                            Parent = flags[ "Distance" ] and objects[ "holder" ] or esp.cache;
                            TextStrokeTransparency = 1;
                            Name = "\0";
                            Size = dim2(1, 0, 0, 0);
                            BackgroundTransparency = 1;
                            Position = dim2(0, 0, 1, 8);
                            BorderSizePixel = 0;
                            AutomaticSize = Enum.AutomaticSize.Y;
                            TextSize = 9;
                        });
                        esp:create( "UIStroke", {
                            Parent = objects[ "distance" ];
                            Color = rgb(0, 0, 0);
                            LineJoinMode = Enum.LineJoinMode.Miter;
                        });

                        objects[ "flag" ] = esp:create( "TextLabel" , {
                            FontFace = esp_fonts.secondary;
                            TextColor3 = flags["Distance_Color"].Color;
                            BorderColor3 = rgb(0, 0, 0);
                            Text = "INVIS";
                            Parent = flags[ "player_flags" ] and objects[ "holder" ] or esp.cache;
                            TextStrokeTransparency = 1;
                            Name = "\0";
                            AnchorPoint = vec2(1, 0);
                            Size = dim2(0, 0, 0, 0);
                            BackgroundTransparency = 1;
                            Position = dim2(1, 25, 0, 2);
                            BorderSizePixel = 0;
                            AutomaticSize = Enum.AutomaticSize.X;
                            TextSize = 9;
                            TextXAlignment = Enum.TextXAlignment.Right;
                            Visible = false;
                        });
                        esp:create( "UIStroke", {
                            Parent = objects[ "flag" ];
                            Color = rgb(0, 0, 0);
                            LineJoinMode = Enum.LineJoinMode.Miter;
                        });

                        objects[ "weapon" ] = esp:create( "TextLabel" , {
                            FontFace = esp_fonts.secondary;
                            TextColor3 = flags["Weapon_Color"].Color;
                            BorderColor3 = rgb(0, 0, 0);
                            Text = "[ak-47]";
                            Parent = esp.cache;
                            TextStrokeTransparency = 1;
                            Name = "\0";
                            Size = dim2(1, 0, 0, 0);
                            BackgroundTransparency = 1;
                            Position = dim2(0, 0, 1, 0);
                            BorderSizePixel = 0;
                            AutomaticSize = Enum.AutomaticSize.Y;
                            TextSize = 9;
                        });
                        esp:create( "UIStroke", {
                            Parent = objects[ "weapon" ];
                            Color = rgb(0, 0, 0);
                            LineJoinMode = Enum.LineJoinMode.Miter;
                        });

                        for _, bone in bones do
                            local line = Drawing.new("Line")
                            line.Color = flags["Skeletons_Color"].Color;
                            line.Thickness = 1;
                            line.Visible = false;

                            data.drawings[#data.drawings + 1] = line;
                        end

                end

                do 
                    data.health_changed = function( value )
                        if not flags[ "Healthbar" ] then 
                            return 
                        end

                        local humanoid = data.info.humanoid
                        if not humanoid then
                            return
                        end

                        local multiplier = math.max(value / humanoid.MaxHealth, 0.001)
                        local color = flags[ "Health_Low" ].Color:Lerp( flags["Health_High"].Color, multiplier )

                        objects[ "healthbar" ].Size = UDim2.new(1, -2, multiplier, -2)
                        objects[ "healthbar" ].Position = UDim2.new(0, 1, 1 - multiplier, 1)
                        objects[ "healthbar" ].BackgroundColor3 = color
                    end

                    data.tool_added = function( item )
                        if not item:IsA("Tool") then 
                            return 
                        end 

                        local exists = data.info.character:FindFirstChild(item.Name) 
                        objects[ "weapon" ].Text = item.Name
                        objects[ "weapon" ].Parent = exists and objects[ "holder" ] or esp.cache
                        data.refresh_offsets()
                    end

                    data.refresh_offsets = function()
                        local has_weapon = objects[ "weapon" ].Parent == objects[ "holder" ]

                        if has_weapon then
                            objects[ "distance" ].Position = dim2(0, 0, 1, 8)
                            objects[ "weapon" ].Position = dim2(0, 0, 1, 0)
                        else
                            objects[ "distance" ].Position = dim2(0, 0, 1, 0)
                        end
                    end 

                    data.refresh_descendants = function(character)

                        character = character or player.Character
                        if not character or not character.Parent then
                            return
                        end

                        local humanoid = character:WaitForChild("Humanoid", 15)
                        if not humanoid then
                            return
                        end

                        local rootpart = character:FindFirstChild("HumanoidRootPart")

                        for _, connection in data.connections do
                            connection:Disconnect()
                        end
                        data.connections = {}

                        data.info.character = character
                        data.info.humanoid = humanoid
                        data.info.rootpart = rootpart

                        if objects["highlight"] then
                            objects["highlight"]:Destroy()
                            objects["highlight"] = nil
                        end

                        local highlight = Instance.new("Highlight")
                        highlight.Name = "\0"
                        highlight.Adornee = character
                        highlight.DepthMode = Enum.HighlightDepthMode.Occluded
                        highlight.Enabled = false
                        highlight.Parent = character
                        objects["highlight"] = highlight

                        data.connections[#data.connections + 1] = humanoid.HealthChanged:Connect(data.health_changed)
                        data.connections[#data.connections + 1] = character.ChildAdded:Connect(data.tool_added)
                        data.connections[#data.connections + 1] = character.ChildRemoved:Connect(data.tool_added)

                        data.health_changed(data.info.humanoid.Health)
                        esp.refresh_elements()
                    end
                end 

                do   

                    if player.Character then
                        task.spawn(data.refresh_descendants, player.Character)
                    end

                    data.player_connections[#data.player_connections + 1] = player.CharacterAdded:Connect(function(character)
                        task.spawn(data.refresh_descendants, character)
                    end)

                    data.player_connections[#data.player_connections + 1] = player.CharacterRemoving:Connect(function()

                        data.info.character = nil
                        data.info.humanoid = nil
                        data.info.rootpart = nil

                        if objects["holder"] then
                            objects["holder"].Visible = false
                        end

                        if objects["highlight"] then
                            objects["highlight"].Enabled = false
                        end

                        for _, line in data.drawings do
                            line.Visible = false
                        end
                    end)

                    data.player_connections[#data.player_connections + 1] = player:GetPropertyChangedSignal("Team"):Connect(function()
                        if esp then
                            esp.refresh_elements()
                        end
                    end)

                    local tool = player.Character and player.Character:FindFirstChildOfClass("Tool")

                    if tool then
                        data.tool_added( tool )
                    end 
                end 
            end

            function esp:remove_object(player)
                local holder = esp[player.Name]

                if not holder then return end 

                for _, connection in holder.connections do
                    connection:Disconnect()
                end
                holder.connections = {}

                for _, connection in holder.player_connections do
                    connection:Disconnect()
                end
                holder.player_connections = {}

                local objects = holder.objects

                for _, line in holder.drawings do 
                    line:Remove()
                end

                if objects["highlight"] then
                    objects["highlight"]:Destroy()
                end

                objects[ "holder" ]:Destroy() 
                esp[player.Name] = nil
            end

            local function should_render_player(v)
                if v == players.LocalPlayer then
                    return flags["player_local"]
                end

                local local_team = players.LocalPlayer.Team
                if local_team and v.Team == local_team then
                    return flags["player_teammates"]
                end

                return true
            end

            function esp.refresh_elements( )
                for _,v in players:GetPlayers() do 
                    local path = esp[v.Name]

                    if not path then

                        esp:create_object(v)
                        path = esp[v.Name]
                    end

                    local objects = path and path.objects

                    if not path or not objects then
                        continue
                    end

                    local can_render = should_render_player(v) and v.Character

                    if not can_render then
                        objects.holder.Parent = esp.cache
                        objects[ "name" ].Parent = esp.cache
                        objects[ "corners" ].Parent = esp.cache
                        objects[ "box_handler" ].Parent = esp.cache
                        objects[ "box_outline" ].Parent = esp.cache
                        objects[ "healthbar_holder" ].Parent = esp.cache
                        objects[ "weapon" ].Parent = esp.cache
                        objects[ "distance" ].Parent = esp.cache

                        if objects["highlight"] then
                            objects["highlight"].Enabled = false
                        end

                        for _, line in path.drawings do
                            line.Visible = false
                        end

                        path.refresh_offsets()
                        continue
                    end

                    local is_enabled = flags["Enabled"] and true or false
                    objects.holder.Parent = is_enabled and esp.screengui or esp.cache

                    objects[ "name" ].Parent = flags["Names"] and objects["holder"] or esp.cache
                    objects[ "name" ].TextColor3 = flags["Name_Color"].Color

                    local is_corner = flags[ "Box_Type" ] == "Corner"

                    if flags["Boxes"] then 
                        objects[ "corners" ].Parent = (is_corner and objects["holder"]) or esp.cache
                        objects[ "box_handler" ].Parent = (is_corner and esp.cache or objects[ "holder" ])
                        objects[ "box_outline" ].Parent = (is_corner and esp.cache or objects[ "holder" ]) 
                    else
                        objects[ "corners" ].Parent =  esp.cache
                        objects[ "box_handler" ].Parent = esp.cache
                        objects[ "box_outline" ].Parent = esp.cache
                    end 

                    objects[ "box_color" ].Color = flags["Box_Color"].Color 
                    objects[ "outline_stroke" ].Transparency = 0
                    objects[ "flag" ].TextColor3 = flags["Distance_Color"].Color
                    objects[ "flag" ].Parent = flags[ "player_flags" ] and objects[ "holder" ] or esp.cache

                    local model_mode = flags["player_model"] or "off"
                    if objects["highlight"] then
                        objects["highlight"].Enabled = is_enabled and model_mode ~= "off"
                        objects["highlight"].DepthMode = model_mode == "ontop" and Enum.HighlightDepthMode.AlwaysOnTop or Enum.HighlightDepthMode.Occluded

                        local fill_flag = flags["player_highlight_fill"] or { Color = rgb(255, 255, 255), Transparency = 0 }
                        local outline_flag = flags["player_highlight_outline"] or { Color = rgb(0, 0, 0), Transparency = 0 }

                        objects["highlight"].FillColor = fill_flag.Color
                        objects["highlight"].FillTransparency = fill_flag.Transparency or 0
                        objects["highlight"].OutlineColor = outline_flag.Color
                        objects["highlight"].OutlineTransparency = outline_flag.Transparency or 0
                    end

                    local function is_character_invisible(character)
                        for _, descendant in ipairs(character:GetDescendants()) do
                            if descendant:IsA("BasePart") then
                                local totalTransparency = descendant.Transparency + (descendant.LocalTransparencyModifier or 0)
                                if totalTransparency < 1 then
                                    return false
                                end
                            end
                        end
                        return true
                    end

                    objects[ "flag" ].Visible = flags[ "player_flags" ] and is_character_invisible(v.Character)

                    for _, corner in objects[ "corners" ]:GetChildren() do
                        if corner:IsA("GuiObject") then
                            corner.BackgroundColor3 = flags["Box_Color"].Color
                        end
                    end

                    local menu_open = window.main_outline and window.main_outline.Visible

                    for _, line in path.drawings do
                        line.Color = flags["Skeletons_Color"].Color
                        line.Visible = flags["Skeletons"] and is_enabled and not menu_open
                    end

                    objects[ "healthbar_holder" ].Parent = flags[ "Healthbar" ] and objects[ "holder" ] or esp.cache

                    objects[ "weapon" ].TextColor3 = flags["Weapon_Color"].Color
                    objects[ "weapon" ].Parent = flags["Weapon"] and v.Character:FindFirstChildOfClass("Tool") and objects[ "holder" ] or esp.cache

                    objects[ "distance" ].TextColor3 = flags["Distance_Color"].Color
                    objects[ "distance" ].Parent = flags["Distance"] and objects[ "holder" ] or esp.cache

                    path.refresh_offsets()
                end
            end

            esp.connection = run:BindToRenderStep("PrivESP", Enum.RenderPriority.Last.Value, function()
                if not flags["Enabled"] then 
                    return
                end

                local function set_highlight(data, enabled)
                    local hl = data and data.objects and data.objects["highlight"]
                    if hl then
                        hl.Enabled = enabled
                    end
                end

                for _, player in players:GetPlayers() do 

                    if not esp[player.Name] then
                        esp:create_object(player)
                    end

                    if not should_render_player(player) then
                        local data = esp[player.Name]
                        if data then
                            if data.objects and data.objects["holder"] then
                                data.objects["holder"].Visible = false
                            end
                            set_highlight(data, false)
                            for _, line in data.drawings do
                                line.Visible = false
                            end
                        end
                        continue
                    end

                    local data = esp[player.Name]

                    if not data then 
                        continue 
                    end 

                    local character = data.info.character
                    local humanoid = data.info.humanoid 

                    if not (character and humanoid) then 
                        if data.objects and data.objects["holder"] then
                            data.objects["holder"].Visible = false
                        end
                        set_highlight(data, false)
                        for _, line in data.drawings do
                            line.Visible = false
                        end
                        continue 
                    end 

                    local objects = data.objects 

                    if not objects then 
                        continue 
                    end 

                    local humanoid_state = humanoid:GetState()
                    if humanoid.Health <= 0 or humanoid_state == Enum.HumanoidStateType.Dead then
                        local holder = objects[ "holder" ]
                        holder.Visible = false
                        set_highlight(data, false)
                        for _, line in data.drawings do
                            line.Visible = false
                        end
                        continue
                    end

                    local rootpart = humanoid.RootPart or character:FindFirstChild("HumanoidRootPart")
                    if not rootpart then
                        local holder = objects[ "holder" ]
                        if holder then
                            holder.Visible = false
                        end
                        set_highlight(data, false)
                        for _, line in data.drawings do
                            line.Visible = false
                        end
                        continue
                    end

                    local box_size, box_pos, on_screen, distance = esp:box_solve(rootpart)
                    local holder = objects[ "holder" ]

                    local max_distance = flags["player_max_distance"] or 0
                    if max_distance > 0 and distance and distance > max_distance then
                        holder.Visible = false
                        set_highlight(data, false)
                        for _, line in data.drawings do
                            line.Visible = false
                        end
                        continue
                    end

                    if not on_screen then
                        holder.Visible = false
                        set_highlight(data, false)
                        for _, line in data.drawings do
                            line.Visible = false
                        end
                        continue
                    end

                    if holder.Visible ~= on_screen then 
                        holder.Visible = on_screen
                    end 

                    set_highlight(data, (flags["player_model"] or "off") ~= "off")

                    local meter_distance = distance and distance / 3.28 or 0
                    if meter_distance > 250 then
                        objects[ "outline_stroke" ].Transparency = 1
                    else
                        objects[ "outline_stroke" ].Transparency = 0
                    end

                    local function is_character_invisible(character)
                        for _, descendant in ipairs(character:GetDescendants()) do
                            if descendant:IsA("BasePart") then
                                local totalTransparency = descendant.Transparency + (descendant.LocalTransparencyModifier or 0)
                                if totalTransparency < 1 then
                                    return false
                                end
                            end
                        end
                        return true
                    end

                    objects[ "flag" ].Visible = flags[ "player_flags" ] and is_character_invisible(character)

                    local menu_open = window.main_outline and window.main_outline.Visible

                    if flags["Skeletons"] and not menu_open then 
                        for i = 1, #bones do
                            local origin, destination = bones[i][1], bones[i][2]

                            if not data.drawings[i] then 
                                continue  
                            end 

                            local path = data.drawings[i]

                            local origin_3d = character:FindFirstChild(origin) 
                            local destination_3d = character:FindFirstChild(destination) 

                            if origin_3d and destination_3d then 
                                local origin_2d, on_screen_start = esp:get_screen_pos(origin_3d.Position)
                                local destination_2d, on_screen_end = esp:get_screen_pos(destination_3d.Position)

                                if on_screen_start and on_screen_end then 
                                    path.Visible = true
                                    path.From = Vector2.new(origin_2d.X, origin_2d.Y)
                                    path.To = Vector2.new(destination_2d.X, destination_2d.Y)
                                else
                                    path.Visible = false
                                end 
                            else
                                path.Visible = false
                            end
                        end 
                    else
                        for i = 1, #bones do
                            if data.drawings[i] then
                                data.drawings[i].Visible = false
                            end
                        end
                    end 

                    data.refresh_offsets()

                    local pos = dim_offset(box_pos.X, box_pos.Y) 
                    if pos ~= holder.Position then 
                        holder.Position = dim_offset(box_pos.X, box_pos.Y)
                    end 

                    local size = dim_offset(box_size.X, box_size.Y) 
                    if size ~= holder.Size then 
                        holder.Size = size
                    end 

                    local distance_label = objects[ "distance" ]
                    local distance_m = math.round(distance / 3.28)
                    if distance_label.Text ~= tostring(distance_m) .. "M" then 
                        distance_label.Text = tostring(distance_m) .. "M"
                    end 
                end
            end)

            function esp:unload() 
                for _, player in players:GetPlayers() do 
                    esp:remove_object(player)
                end 

                esp.connection:Disconnect() 
                run:UnbindFromRenderStep("PrivESP")
                esp.player_added:Disconnect() 
                esp.player_removed:Disconnect() 

                esp.cache:Destroy() 
                esp.screengui:Destroy()

                esp = nil
            end 

    end

    for _,v in players:GetPlayers() do 
        esp:create_object(v)
    end 

    esp.player_added = players.PlayerAdded:Connect(function(v)
        esp:create_object(v)
    end)

    esp.player_removed = players.PlayerRemoving:Connect(function(v)
        esp:remove_object(v)
    end)

    task.wait()
    esp.refresh_elements()
