local Library = {
    Flags = {}
    }
Library.flags = Library.Flags

--// Dependences //--

local Utilities = {}

local Mouse = game.Players.LocalPlayer:GetMouse()

local BlacklistedKeys = {Enum.KeyCode.Backspace, Enum.KeyCode.Tab, Enum.KeyCode.CapsLock, Enum.KeyCode.W, Enum.KeyCode.A, Enum.KeyCode.S, Enum.KeyCode.D, Enum.KeyCode.KeypadEnter, Enum.KeyCode.Return, Enum.KeyCode.Escape}

local DropIndex = 9999

--// Services //--
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local TextService = game:GetService("TextService")
--//

--// Utilities Functions //--
function Utilities:Create(type, properties, children)
    assert(type, "first argument is required.")
    
    properties = properties or {}
    children = children or {}
    
    local Instance = Instance.new(type)
    
    local ForcedProps = {
        BorderSizePixel = 0,
        Text = "",
        ScrollBarThickness = 0,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        Font =  Enum.Font.GothamBold,
        TextSize = 11,
        SortOrder = Enum.SortOrder.LayoutOrder,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        AutomaticCanvasSize = Enum.AutomaticSize.Y
        }
        
        for forced, value in pairs(ForcedProps) do
            pcall(function()
                Instance[forced] = value
            end)
        end
        
        for prop, value in pairs(properties) do
            Instance[prop] = value
        end
        
        for _, v in pairs(children) do
            v.Parent = Instance
        end
        
        return Instance
end

function Utilities:Tween(instance, properties, speed, style, direction)
    assert(properties, "second argument is required.")
    
    properties = properties or {}
    speed = speed or .125
    style = style or Enum.EasingStyle.Linear
    direction = direction or Enum.EasingDirection.Out
    
    local Tween = TweenService:Create(instance, TweenInfo.new(speed, style, direction), properties)
    Tween:Play()
    
    return Tween
end
--//

function Utilities:GetMouseLocation()
    return UserInputService:GetMouseLocation()
end

function Utilities:GetXY(GuiObject)
    local Max, May = GuiObject.AbsoluteSize.X, GuiObject.AbsoluteSize.Y
    local Px, Py = math.clamp(Mouse.X - GuiObject.AbsolutePosition.X, 0, Max), math.clamp(Mouse.Y - GuiObject.AbsolutePosition.Y, 0, May)
    return Px/Max, Py/May
end

function Utilities:Round(Number, Increment)
    Increment = 1 / Increment
    
    return math.round(Number * Increment) / Increment
end

local ScreenGui = Utilities:Create("ScreenGui", {
    Name = "BECK",
    ZIndexBehavior = Enum.ZIndexBehavior.Global,
    DisplayOrder = 500,
    Parent = CoreGui
})

local NotificationScreen = Utilities:Create("ScreenGui", {
    Name = "BECKNotifications",
    ZIndexBehavior = Enum.ZIndexBehavior.Global,
    DisplayOrder = 501,
    Parent = CoreGui
    }, {
    Utilities:Create("Frame", {
        Name = "NotificationHolder",
        Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1
        }, {
        Utilities:Create("UIListLayout", {
            HorizontalAlignment = Enum.HorizontalAlignment.Right,
            VerticalAlignment = Enum.VerticalAlignment.Bottom,
            Padding = UDim.new(0, 3)
            }),
        Utilities:Create("UIPadding", {
            PaddingRight = UDim.new(0, 5),
            PaddingBottom = UDim.new(0, 5)
            })
        })
    })

--//

function Library:Notify(Info)
    Info.Text = Info.Text or "Lorem Ipsum"
    Info.Timeout = Info.Timeout or nil
    
    local Notification = Utilities:Create("Frame", {
        Name = "Notification",
        Parent = NotificationScreen.NotificationHolder,
        AnchorPoint = Vector2.new(.5, .5),
        ClipsDescendants = true,
        Active = true,
        Size = UDim2.fromOffset(0, 30),
        BackgroundColor3 = Color3.fromRGB(14, 14, 14)
        }, {
        Utilities:Create("Frame", {
            Name = "BlackoutFrame",
            Size = UDim2.fromScale(1, 1),
            BackgroundColor3 = Color3.fromRGB(14, 14, 14),
            BackgroundTransparency = 1,
            ZIndex = 2
            }, {
            Utilities:Create("UICorner", {
                CornerRadius = UDim.new(0, 6)
                })
            }),
        Utilities:Create("UICorner", {
            CornerRadius = UDim.new(0, 6)
            }),
        Utilities:Create("Frame", {
            Name = "NotificationFrame",
            Size = UDim2.new(1, -6, 1, -6),
            AnchorPoint = Vector2.new(.5, .5),
            Position = UDim2.fromScale(.5, .5),
            BackgroundTransparency = 1
            }, {
            Utilities:Create("UIStroke", {
                Color = Color3.fromRGB(25, 25, 25)
                }),
            Utilities:Create("UICorner", {
                CornerRadius = UDim.new(0, 6)
                }),
            Utilities:Create("TextLabel", {
                Name = "NotificationText",
                Text = Info.Text,
                TextXAlignment = Enum.TextXAlignment.Center,
                BackgroundTransparency = 1,
                Size = UDim2.fromScale(1, 1)
                })
            })
        })
    
    local Closed = false
    
    local TextX = Notification.NotificationFrame.NotificationText.TextBounds.X
    
    Utilities:Tween(Notification, {Size = UDim2.fromOffset(TextX + 12, 30)}, .3, Enum.EasingStyle.Quad)
    task.spawn(function()
        task.wait(.1)
        Utilities:Tween(Notification.NotificationFrame.UIStroke, {Color = Color3.fromRGB(31, 156, 100)}, .3, Enum.EasingStyle.Linear)
        task.wait(.3)
        Utilities:Tween(Notification.NotificationFrame.UIStroke, {Color = Color3.fromRGB(25, 25, 25)}, .6, Enum.EasingStyle.Linear)
    end)
    
    local function Close()
        Closed = true
        local Tween = Utilities:Tween(Notification, {Size = UDim2.fromOffset(0, 30)}, .3, Enum.EasingStyle.Quad)
        Tween.Completed:Connect(function()
            task.wait(.1)
            Notification:Destroy()
        end)
    end
    
    if Info.Timeout then
        task.delay(Info.Timeout, function()
            if not Closed then
                Close()
            end
        end)
    end
    
    Notification.MouseEnter:Connect(function()
        Utilities:Tween(Notification.BlackoutFrame, {BackgroundTransparency = .3}, .3, Enum.EasingStyle.Quad)
    end)
    
    Notification.MouseLeave:Connect(function()
        Utilities:Tween(Notification.BlackoutFrame, {BackgroundTransparency = 1}, .3, Enum.EasingStyle.Quad)
    end)
    
    Notification.InputBegan:Connect(function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseButton1 then
            Close()
        end
    end)
    
end

function Utilities:Tooltip(instance, string)
    local Tooltip = Utilities:Create("Frame", {
        Name = "Tooltip",
        Parent = ScreenGui,
        ZIndex = 10000,
        Visible = false,
        AnchorPoint = Vector2.new(.5, .5),
        BackgroundColor3 = Color3.fromRGB(14, 14, 14),
        Size = UDim2.fromOffset(6, 26)
        }, {
        Utilities:Create("UICorner", {
            CornerRadius = UDim.new(0, 5)
            }),
        Utilities:Create("Frame", {
            Name = "TooltipFrame",
            Size = UDim2.fromOffset(0, 20),
            AnchorPoint = Vector2.new(.5, .5),
            Position = UDim2.fromScale(.5, .5),
            BackgroundTransparency = 1,
            ZIndex = 10001
            }, {
            Utilities:Create("TextLabel", {
                Name = "TooltipText",
                Size = UDim2.fromOffset(6, 26),
                AnchorPoint = Vector2.new(.5, .5),
                Position = UDim2.fromScale(.5, .5),
                BackgroundTransparency = 1,
                TextXAlignment = Enum.TextXAlignment.Center,
                Text = string,
                ZIndex = 10001
                }),
            Utilities:Create("UIStroke", {
                Color = Color3.fromRGB(25, 25, 25)
                }),
            Utilities:Create("UICorner", {
                CornerRadius = UDim.new(0, 5)
                })
            })
        })
    
    local MouseMove
    
    local TooltipFrame = Tooltip.TooltipFrame
    local TextX = TooltipFrame.TooltipText.TextBounds.X
    
    Tooltip.Size = Tooltip.Size + UDim2.fromOffset(TextX + 6, 0)
    TooltipFrame.Size = TooltipFrame.Size + UDim2.fromOffset(TextX + 6, 0)
    TooltipFrame.TooltipText.Size = TooltipFrame.TooltipText.Size + UDim2.fromOffset(TextX + 6, 0)
    
    local function Update()
        local MousePosition = Utilities:GetMouseLocation()
        
        Tooltip.Position = UDim2.new(0, MousePosition.X + 3, 0, MousePosition.Y)
    end
    
    instance.MouseEnter:Connect(function()
        Tooltip.Visible = true
        
        MouseMove = Mouse.Move:Connect(function()
            Update()
        end)
    end)
    
    instance.MouseLeave:Connect(function()
        Tooltip.Visible = false
        
        if MouseMove then
            MouseMove:Disconnect()
            MouseMove = nil
        end
    end)
end

--// Window //--
function Library:Window(Info)
    Info.Keybind = Info.Keybind or Enum.KeyCode.LeftAlt
    
    local Windows = {}
    Windows.Selected = nil
    Windows.Tabs = 0
    
    local Window = Utilities:Create("Frame", {
        Name = "Window",
        Size = UDim2.new(0, 650, 0, 500),
        BackgroundColor3 = Color3.fromRGB(19, 19, 19),
        BackgroundTransparency = .01,
        AnchorPoint = Vector2.new(0.5,0.5),
        Position = UDim2.new(0.5,0,0.5,0),
        Parent = ScreenGui,
        }, {
        Utilities:Create("UICorner", {
            CornerRadius = UDim.new(0, 11)
            }),
        Utilities:Create("ScrollingFrame", {
            Name = "Containers",
            Size = UDim2.new(0, 431, 0, 480),
            BackgroundTransparency = 1,
            ClipsDescendants = false,
            Position = UDim2.new(0, 213, 0, 10)
            }),
        Utilities:Create("Frame", {
            Name = "Sidebar",
            BackgroundColor3 = Color3.fromRGB(14, 14, 14),
            AnchorPoint = Vector2.new(0, .5),
            Position = UDim2.new(0, 5, .5, 0),
            Size = UDim2.new(0, 200, 1, -10)
            }, {
            Utilities:Create("UICorner", {
                CornerRadius = UDim.new(0, 6)
                }),
            Utilities:Create("Frame", {
                Name = "BorderFrame",
                AnchorPoint = Vector2.new(.5, .5),
                Position = UDim2.fromScale(.5, .5),
                BackgroundTransparency = 1,
                Size = UDim2.new(0, 192, 0, 480)
                }, {
                Utilities:Create("UIStroke", {
                    Color = Color3.fromRGB(25, 25, 25)
                    }),
                Utilities:Create("UICorner", {
                    CornerRadius = UDim.new(0, 4)
                    })
                }),
            Utilities:Create("ScrollingFrame", {
                Name = "TabContainer",
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 5, 0, 10),
                ClipsDescendants = false,
                Size = UDim2.new(1, -10, 1, -15)
                }, {
                Utilities:Create("UIListLayout")
                })
            })
        })
    
    UserInputService.InputBegan:Connect(function(Input, GameProcessed)
        if Input.KeyCode == Info.Keybind and not GameProcessed then
            ScreenGui.Enabled = not ScreenGui.Enabled
        end
    end)
    
    local dragging = false
    local dragInput, mousePos, framePos
    
    Window.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            mousePos = input.Position
            framePos = Window.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    Window.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - mousePos
            Window.Position  = UDim2.new(framePos.X.Scale, framePos.X.Offset + delta.X, framePos.Y.Scale, framePos.Y.Offset + delta.Y)
        end
    end)
    
    local Sidebar = Window.Sidebar
    local TabContainer = Sidebar.TabContainer
    local Containers = Window.Containers
    
    function Windows:Tab(Info)
        Info.Text = Info.Text or "Tab"
        Info.Description = Info.Description or "Description"
        Info.Image = Info.Image or ""
        
        local Tabs = {}
        
        Windows.Tabs = Windows.Tabs + 1
        
        local Image
        
        if typeof(Info.Image) == "number" then
            Image = "rbxassetid://"..tostring(Info.Image)
        elseif typeof(Info.Image) == "string" then
            Image = Info.Image
        end
        
        local State = false
        
        local Tab = Utilities:Create("Frame", {
            Name = "Tab",
            Size = UDim2.new(0, 200, 0, 45),
            BackgroundTransparency = 1,
            Parent = TabContainer
            }, {
            Utilities:Create("TextButton", {
                Name = "TabButton",
                Size = UDim2.fromScale(1, 1),
                BackgroundTransparency = 1
                }),
            Utilities:Create("Frame", {
                Name = "IconHolder",
                Size = UDim2.new(0, 40, 0, 40),
                Position = UDim2.fromOffset(8, 0),
                BackgroundColor3 = Color3.fromRGB(19, 19, 19)
                }, {
                Utilities:Create("UICorner", {
                    CornerRadius = UDim.new(0, 4)
                    }),
                Utilities:Create("ImageLabel", {
                    Name = "Icon",
                    Size = UDim2.new(0, 20, 0, 20),
                    AnchorPoint = Vector2.new(.5, .5),
                    Position = UDim2.fromScale(.5, .5),
                    BackgroundTransparency = 1,
                    ImageColor3 = Color3.fromRGB(165, 165, 165),
                    Image = Image
                    })
                }),
            Utilities:Create("TextLabel", {
                Name = "TabText",
                BackgroundTransparency = 1,
                Text = Info.Text,
                TextColor3 = Color3.fromRGB(85, 85, 85),
                TextXAlignment = Enum.TextXAlignment.Left,
                Position = UDim2.new(0, 58, 0, 0),
                Size = UDim2.new(0, 20, 0, 20)
                }),
            Utilities:Create("TextLabel", {
                Name = "TabDescription",
                BackgroundTransparency = 1,
                Text = Info.Description,
                TextColor3 = Color3.fromRGB(105, 105, 105),
                TextXAlignment = Enum.TextXAlignment.Left,
                Position = UDim2.new(0, 58, 0, 20),
                Size = UDim2.new(0, 20, 0, 20)
                }),
            })
        
        local Left = Utilities:Create("ScrollingFrame", {
            Name = "Left",
            Size = UDim2.new(0, 215, 1, 0),
            Parent = Containers,
            ClipsDescendants = false,
            Visible = false,
            BackgroundTransparency = 1
            }, {
            Utilities:Create("UIListLayout"),
            Utilities:Create("UIPadding", {
                PaddingTop = UDim.new(0, 5)
                })
            })
        
        local Right = Utilities:Create("ScrollingFrame", {
            Name = "Right",
            Size = UDim2.new(0, 215, 1, 0),
            Position = UDim2.new(0, 220, 0, 0),
            Parent = Containers,
            ClipsDescendants = false,
            Visible = false,
            BackgroundTransparency = 1
            }, {
            Utilities:Create("UIListLayout"),
            Utilities:Create("UIPadding", {
                PaddingTop = UDim.new(0, 5)
                })
            })
        
        Tab.MouseEnter:Connect(function()
            if Windows.Selected == nil or Windows.Selected ~= Tab then
                Utilities:Tween(Tab.IconHolder, {BackgroundColor3 = Color3.fromRGB(23, 23, 23)})
            end
        end)
        
        Tab.MouseLeave:Connect(function()
            if Windows.Selected == nil or Windows.Selected ~= Tab then
                Utilities:Tween(Tab.IconHolder, {BackgroundColor3 = Color3.fromRGB(19, 19, 19)})
            end
        end)
        
        function Tabs:Select()
            Windows.Selected = Tab
            
            task.spawn(function()
                for _, v in pairs(Containers:GetChildren()) do
                    v.Visible = false
                end
                
                for _, v in pairs(TabContainer:GetChildren()) do
                    if v.ClassName == "Frame" and v ~= Tab then
                        Utilities:Tween(v.IconHolder, {BackgroundColor3 = Color3.fromRGB(19, 19, 19)})
                        Utilities:Tween(v.IconHolder.Icon, {ImageColor3 = Color3.fromRGB(165, 165, 165)})
                        Utilities:Tween(v.TabText, {TextColor3 = Color3.fromRGB(85, 85, 85)})
                    end
                end
            end)
            
            Left.Visible = true
            Right.Visible = true
            
            Utilities:Tween(Tab.IconHolder, {BackgroundColor3 = Color3.fromRGB(26, 194, 118)})
            Utilities:Tween(Tab.IconHolder.Icon, {ImageColor3 = Color3.fromRGB(255, 255, 255)})
            Utilities:Tween(Tab.TabText, {TextColor3 = Color3.fromRGB(205, 205, 205)})
        end
        
        if Windows.Tabs == 1 then
            Tabs:Select()
        end
            
        Tab.TabButton.MouseButton1Click:Connect(function()
                Tabs:Select()
                
                State = not State
            end)
            
        function Tabs:Section(Info)
            Info.Text = Info.Text or "Section"
            Info.Side = Info.Side or "Left"
            
            local Sections = {}
            
            local Side
            
            if Info.Side:lower() == "right" then
                Side = Right
            elseif Info.Side:lower() == "left" then
                Side = Left
            else
                error("Uh there's no "..Info.Side.." side...", 0)
            end
            
            local SectionHolder = Utilities:Create("Frame", {
                Name = "SectionHolder",
                Size = UDim2.new(0, 215, 0, 30),
                BackgroundTransparency = 1,
                Parent = Side
                })
            
            local Section = Utilities:Create("Frame", {
                Name = "Section",
                Parent = SectionHolder,
                BackgroundColor3 = Color3.fromRGB(14, 14, 14),
                Size = UDim2.new(0, 211, 0, 27)
                }, {
                Utilities:Create("Frame", {
                    Name = "SectionContainer",
                    BackgroundTransparency = 1,
                    Size = UDim2.new(0, 205, 0, 0),
                    Position = UDim2.fromOffset(3, 22)
                    }, {
                    Utilities:Create("UIListLayout", {
                        HorizontalAlignment = Enum.HorizontalAlignment.Center
                        })
                    }),
                Utilities:Create("Frame", {
                    Name = "Divider",
                    Size = UDim2.fromOffset(205, 1),
                    BackgroundColor3 = Color3.fromRGB(25, 25, 25),
                    Position = UDim2.fromOffset(3, 19)
                    }),
                Utilities:Create("TextLabel", {
                    Name = "SectionText",
                    Text = Info.Text,
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    TextColor3 = Color3.fromRGB(210, 210, 210),
                    Position = UDim2.fromOffset(6, 0),
                    Size = UDim2.new(1, -6, 0, 21)
                    }),
                Utilities:Create("UICorner", {
                    CornerRadius = UDim.new(0, 8)
                    }),
                Utilities:Create("Frame", {
                    Name = "SectionFrame",
                    Size = UDim2.new(0, 205, 0, 21),
                    AnchorPoint = Vector2.new(.5, .5),
                    Position = UDim2.fromScale(.5, .5),
                    BackgroundTransparency = 1
                    }, {
                    Utilities:Create("UICorner", {
                        CornerRadius = UDim.new(0, 4)
                        }),
                    Utilities:Create("UIStroke", {
                        Color = Color3.fromRGB(25, 25, 25)
                        })
                    })
                })
            
            local SectionContainer = Section.SectionContainer
            local SectionFrame = Section.SectionFrame
            
            SectionContainer.ChildAdded:Connect(function()
                SectionHolder.Size = UDim2.fromOffset(211, SectionHolder.Size.Y.Offset + 27)
                Section.Size = UDim2.fromOffset(211, Section.Size.Y.Offset + 27)
                SectionContainer.Size = UDim2.fromOffset(205, SectionContainer.Size.Y.Offset + 27)
                Section.SectionFrame.Size = UDim2.fromOffset(205, Section.SectionFrame.Size.Y.Offset + 27)
            end)
                
            function Sections:Label(Info)
                Info.Text = Info.Text or "Label"
                Info.Color = Info.Color or Color3.fromRGB(205, 205, 205)
                
                local Labels = {}
                
                local Label = Utilities:Create("Frame", {
                    Name = "Label",
                    Size = UDim2.new(0, 205, 0, 27),
                    Parent = SectionContainer,
                    BackgroundTransparency = 1
                    }, {
                    Utilities:Create("TextLabel", {
                        Name = "LabelText",
                        BackgroundTransparency = 1,
                        TextColor3 = Info.Color,
                        Text = Info.Text,
                        AnchorPoint = Vector2.new(0, .5),
                        Size = UDim2.fromScale(1, 1),
                        Position = UDim2.new(0, 3, .5, 0)
                        })
                    })
                
                function Labels:Set(Info2)
                    Info2.Text = Info2.Text or Label.LabelText.Text
                    Info2.Color = Info2.Color or Label.LabelText.TextColor3
                    
                    Label.LabelText.Text = Info2.Text
                    Label.LabelText.TextColor3 = Info2.Color
                end
                
            return Labels
            end
            
            function Sections:Button(Info)
                Info.Text = Info.Text or "Button"
                Info.Tooltip = Info.Tooltip or nil
                Info.Callback = Info.Callback or function() end
                
                local Button = Utilities:Create("Frame", {
                    Name = "Button",
                    Size = UDim2.new(0, 205, 0, 27),
                    Parent = SectionContainer,
                    BackgroundTransparency = 1
                    }, {
                    Utilities:Create("Frame", {
                        Name = "ButtonFrame",
                        BackgroundColor3 = Color3.fromRGB(21, 21, 21),
                        AnchorPoint = Vector2.new(.5, .5),
                        Position = UDim2.fromScale(.5, .5),
                        Size = UDim2.fromOffset(199, 23)
                        }, {
                        Utilities:Create("TextLabel", {
                            Name = "ButtonText",
                            Size = UDim2.fromScale(1, 1),
                            Text = Info.Text,
                            TextColor3 = Color3.fromRGB(205, 205, 205),
                            BackgroundTransparency = 1,
                            TextXAlignment = Enum.TextXAlignment.Center
                            }),
                        Utilities:Create("TextButton", {
                            Name = "BtnButton",
                            Size = UDim2.fromScale(1, 1),
                            BackgroundTransparency = 1,
                            }),
                        Utilities:Create("UIStroke", {
                            Color = Color3.fromRGB(25, 25, 25)
                            }),
                        Utilities:Create("UICorner", {
                            CornerRadius = UDim.new(0, 2)
                            })
                        })
                    })
                
                if Info.Tooltip then
                    Utilities:Tooltip(Button.ButtonFrame, Info.Tooltip)
                end
                
                Button.ButtonFrame.MouseEnter:Connect(function()
                    Utilities:Tween(Button.ButtonFrame.ButtonText, {TextColor3 = Color3.fromRGB(215, 215, 215)})
                    Utilities:Tween(Button.ButtonFrame, {BackgroundColor3 = Color3.fromRGB(23, 23, 23)})
                    Utilities:Tween(Button.ButtonFrame.UIStroke, {Color = Color3.fromRGB(29, 29, 29)})
                end)
                
                Button.ButtonFrame.MouseLeave:Connect(function()
                    Utilities:Tween(Button.ButtonFrame.ButtonText, {TextColor3 = Color3.fromRGB(205, 205, 205)})
                    Utilities:Tween(Button.ButtonFrame.UIStroke, {Color = Color3.fromRGB(25, 25, 25)})
                    Utilities:Tween(Button.ButtonFrame, {BackgroundColor3 = Color3.fromRGB(21, 21, 21)})
                end)
                
                local TextButton = Button.ButtonFrame.BtnButton
                
                TextButton.MouseButton1Down:Connect(function()
                    Utilities:Tween(Button.ButtonFrame, {BackgroundColor3 = Color3.fromRGB(27, 27, 27)})
                    Utilities:Tween(Button.ButtonFrame.ButtonText, {TextColor3 = Color3.fromRGB(255, 255, 255)})
                end)
                
                TextButton.MouseButton1Up:Connect(function()
                    Utilities:Tween(Button.ButtonFrame, {BackgroundColor3 = Color3.fromRGB(23, 23, 23)})
                    Utilities:Tween(Button.ButtonFrame.ButtonText, {TextColor3 = Color3.fromRGB(215, 215, 215)})
                end)
                
                TextButton.MouseButton1Click:Connect(function()
                    task.spawn(Info.Callback)
                end)
                
            end
            
            function Sections:Check(Info)
                Info.Text = Info.Text or  "Check"
                Info.Default = Info.Default or false
                Info.Keybind = Info.Keybind or nil
                Info.Flag = Info.Flag or nil
                Info.Tooltip = Info.Tooltip or nil
                Info.Callback = Info.Callback or function() end
                
                local Checks = {}
                
                local State = false
                
                local PressKey = Info.Keybind or Enum.KeyCode.End
                local Debounce = false
                
                local Format = "[%s]"
                
                local Check = Utilities:Create("Frame", {
                    Name = "Check",
                    Size = UDim2.new(0, 205, 0, 27),
                    Parent = SectionContainer,
                    BackgroundTransparency = 1
                    }, {
                    Utilities:Create("TextLabel", {
                        Name = "KeybindKeyText",
                        Position = UDim2.fromOffset(3, 2),
                        TextXAlignment = Enum.TextXAlignment.Right,
                        TextColor3 = Color3.fromRGB(165, 165, 165),
                        Visible = Info.Keybind and true or false,
                        Text = string.format(Format, PressKey.Name),
                        BackgroundTransparency = 1,
                        Size = UDim2.fromOffset(199, 23),
                        ZIndex = 2
                        }),
                    Utilities:Create("TextButton", {
                        Name = "KeybindButton",
                        BackgroundTransparency = 1,
                        Visible = Info.Keybind and true or false,
                        AnchorPoint = Vector2.new(1, .5),
                        Position = UDim2.new(1, -3, .5, 0),
                        Size = UDim2.fromOffset(0, 23),
                        ZIndex = 2
                        }),
                    Utilities:Create("Frame", {
                        Name = "CheckFrame",
                        Size = UDim2.fromOffset(20, 20),
                        AnchorPoint = Vector2.new(0, .5),
                        Position = UDim2.new(0, 3, .5, 0),
                        BackgroundColor3 = Color3.fromRGB(21, 21, 21)
                        }, {
                        Utilities:Create("UICorner", {
                            CornerRadius = UDim.new(0, 2)
                            }),
                        Utilities:Create("UIStroke", {
                            Color = Color3.fromRGB(25, 25, 25)
                            }),
                        Utilities:Create("TextLabel", {
                            Name = "CheckText",
                            BackgroundTransparency = 1,
                            TextColor3 = Color3.fromRGB(205, 205, 205),
                            Text = Info.Text,
                            AnchorPoint = Vector2.new(0, .5),
                            Size = UDim2.fromScale(1, 1),
                            Position = UDim2.new(0, 26, .5, 0)
                            }),
                        Utilities:Create("ImageLabel", {
                            Name = "CheckIcon",
                            Size = UDim2.fromOffset(14, 14),
                            AnchorPoint = Vector2.new(.5, .5),
                            Position = UDim2.new(.5, 1, .5, 0),
                            BackgroundTransparency = 1,
                            Image = "rbxassetid://7733715400",
                            ImageColor3 = Color3.fromRGB(255, 255, 255),
                            ImageTransparency = 1
                            }),
                        Utilities:Create("TextButton", {
                            Name = "CheckButton",
                            BackgroundTransparency = 1,
                            Size = UDim2.fromOffset(205, 27)
                            })
                        })
                    })
                
                if Info.Tooltip then
                    Utilities:Tooltip(Check, Info.Tooltip)
                end
                
                local CheckButton = Check.CheckFrame.CheckButton
                local CheckIcon = Check.CheckFrame.CheckIcon
                
                local KeybindText = Check.KeybindKeyText
                
                local KeybindTextX = KeybindText.TextBounds.X
                Check.KeybindButton.Size = UDim2.fromOffset(KeybindTextX, 23)
                
                Check.MouseEnter:Connect(function()
                    if not State then
                        Utilities:Tween(Check.CheckFrame, {BackgroundColor3 = Color3.fromRGB(23, 23, 23)})
                        Utilities:Tween(Check.CheckFrame.UIStroke, {Color = Color3.fromRGB(29, 29, 29)})
                    end
                end)
                
                Check.MouseLeave:Connect(function()
                    if not State then
                        Utilities:Tween(Check.CheckFrame.UIStroke, {Color = Color3.fromRGB(25, 25, 25)})
                        Utilities:Tween(Check.CheckFrame, {BackgroundColor3 = Color3.fromRGB(21, 21, 21)})
                    end
                end)
                
            function Checks:Set(bool)
                State = bool
                task.spawn(Info.Callback, State)
                if Info.Flag then
                    Library.Flags[Info.Flag] = State
                end
                
                if State then
                    Utilities:Tween(CheckIcon, {ImageTransparency = 0})
                    Utilities:Tween(Check.CheckFrame, {BackgroundColor3 = Color3.fromRGB(23, 23, 23)})
                    Utilities:Tween(Check.CheckFrame.UIStroke, {Color = Color3.fromRGB(29, 29, 29)})
                    else
                        Utilities:Tween(CheckIcon, {ImageTransparency = 1})
                        Utilities:Tween(Check.CheckFrame.UIStroke, {Color = Color3.fromRGB(25, 25, 25)})
                        Utilities:Tween(Check.CheckFrame, {BackgroundColor3 = Color3.fromRGB(21, 21, 21)})
                end
            end
            
            if Info.Default then
                Checks:Set(true)
            end
            
            CheckButton.MouseButton1Click:Connect(function()
                Checks:Set(not State)
            end)
            
            if Info.Keybind then
                Check.KeybindButton.MouseButton1Click:Connect(function()
                    if Debounce then return end
                    
                    Debounce = true
                    
                    KeybindText.Text = "[...]"
                    
                    KeybindTextX = KeybindText.TextBounds.X
                    Check.KeybindButton.Size = UDim2.fromOffset(KeybindTextX, 23)
                    
                    local Listening
                    
                    Listening = UserInputService.InputBegan:Connect(function(Input)
                        if not table.find(BlacklistedKeys, Input.KeyCode) then
                            PressKey = Input.KeyCode
                            KeybindText.Text = string.format(Format, PressKey.Name)
                            
                            KeybindTextX = KeybindText.TextBounds.X
                            Check.KeybindButton.Size = UDim2.fromOffset(KeybindTextX, 23)
                            
                            task.wait(.1)
                            Debounce = false
                            Listening:Disconnect()
                        end
                    end)
                end)
                
                UserInputService.InputBegan:Connect(function(Input)
                    if Debounce then return end
                    if Input.KeyCode == PressKey then
                        Checks:Set(not State)
                    end
                end)
            end
            
            return Checks
            end
            
            function Sections:Dropdown(Info)
                Info.Text = Info.Text or "Dropdown"
                Info.Flag = Info.Flag or nil
                Info.Default = Info.Default or nil
                Info.List = Info.List or {}
                Info.Tooltip = Info.Tooltip or nil
                Info.ChangeText = Info.ChangeText or true
                Info.MultiSelect = Info.MultiSelect or false
                Info.Callback = Info.Callback or function() end
                
                local Dropdowns = {}
                Dropdowns.Selected = nil
                
                if Info.MultiSelect then
                    Dropdowns.Selected = {}
                    if Info.Flag then
                        Library.Flags[Info.Flag] = Dropdowns.Selected
                    end
                end
                
                local State = false
                local DropdownY = 0
                
                local Dropdown = Utilities:Create("Frame", {
                    Name = "Dropdown",
                    Size = UDim2.new(0, 205, 0, 27),
                    Parent = SectionContainer,
                    BackgroundTransparency = 1,
                    ZIndex = DropIndex
                    }, {
                    Utilities:Create("Frame", {
                        Name = "DropdownFrame",
                        BackgroundColor3 = Color3.fromRGB(21, 21, 21),
                        Position = UDim2.fromOffset(3, 2),
                        ClipsDescendants = true,
                        Size = UDim2.fromOffset(199, 23),
                        ZIndex = DropIndex
                        }, {
                        Utilities:Create("UICorner", {
                            CornerRadius = UDim.new(0, 2)
                            }),
                        Utilities:Create("ScrollingFrame", {
                            Name = "DropdownContainer",
                            Size = UDim2.fromOffset(199, 0),
                            BackgroundTransparency = 1,
                            ScrollBarThickness = 0,
                            ScrollBarImageColor3 = Color3.fromRGB(209, 209, 209),
                            BottomImage = "",
                            Active = true,
                            ScrollingEnabled = false,
                            TopImage = "",
                            Position = UDim2.fromOffset(0, 23),
                            ZIndex = DropIndex
                            }, {
                            Utilities:Create("UIListLayout")
                            }),
                        Utilities:Create("UIStroke", {
                            Color = Color3.fromRGB(25, 25, 25)
                            }),
                        Utilities:Create("TextLabel", {
                            Name = "DropdownText",
                            BackgroundTransparency = 1,
                            Text = Info.Text,
                            Size = UDim2.fromOffset(168, 23),
                            ClipsDescendants = true,
                            Position = UDim2.fromOffset(6, 0),
                            TextColor3 = Color3.fromRGB(205, 205, 205),
                            ZIndex = DropIndex
                            }),
                        Utilities:Create("TextButton", {
                            Name = "DropdownButton",
                            Size = UDim2.fromOffset(199, 23),
                            BackgroundTransparency = 1,
                            ZIndex = DropIndex
                            }),
                        Utilities:Create("ImageLabel", {
                            Name = "DropdownIcon",
                            Size = UDim2.fromOffset(14, 14),
                            BackgroundTransparency = 1,
                            ImageColor3 = Color3.fromRGB(205, 205, 205),
                            Position = UDim2.fromOffset(181, 5),
                            Image = "rbxassetid://7733717447",
                            ZIndex = DropIndex
                            })
                        })
                    })
                
                if Info.Tooltip then
                    Utilities:Tooltip(Dropdown, Info.Tooltip)
                end
                
                local DropdownContainer = Dropdown.DropdownFrame.DropdownContainer
                local DropdownButton = Dropdown.DropdownFrame.DropdownButton
                local DropdownIcon = Dropdown.DropdownFrame.DropdownIcon
                
                local Wheel
                
                DropdownContainer.MouseEnter:Connect(function()
                    Wheel = UserInputService.InputChanged:Connect(function(Input)
                        if Input.UserInputType == Enum.UserInputType.MouseWheel then
                            DropdownContainer.CanvasPosition = Vector2.new(0, DropdownContainer.CanvasPosition.Y + (Input.Position.Z > 0 and -27 or 27))
                        end
                    end)
                end)
                
                DropdownContainer.MouseLeave:Connect(function()
                    if Wheel then
                        Wheel:Disconnect()
                        Wheel = nil
                    end
                end)
                
                DropdownContainer.ChildAdded:Connect(function()
                    if DropdownY < 81 then
                        DropdownY = DropdownY + 27
                        
                        if State then
                            Dropdown.DropdownFrame.Size = UDim2.new(0, 199, 0, Dropdown.DropdownFrame.Size.Y.Offset + 27)
                            DropdownContainer.Size = UDim2.new(0, 199, 0, DropdownY)
                        end
                        
                        else
                            DropdownContainer.ScrollBarThickness = 3
                    end
                end)
                
                Dropdown.DropdownFrame.MouseEnter:Connect(function()
                    Utilities:Tween(Dropdown.DropdownFrame.DropdownText, {TextColor3 = Color3.fromRGB(215, 215, 215)})
                    Utilities:Tween(Dropdown.DropdownFrame, {BackgroundColor3 = Color3.fromRGB(23, 23, 23)})
                    Utilities:Tween(Dropdown.DropdownFrame.UIStroke, {Color = Color3.fromRGB(29, 29, 29)})
                end)
                
                Dropdown.DropdownFrame.MouseLeave:Connect(function()
                    Utilities:Tween(Dropdown.DropdownFrame.DropdownText, {TextColor3 = Color3.fromRGB(205, 205, 205)})
                    Utilities:Tween(Dropdown.DropdownFrame.UIStroke, {Color = Color3.fromRGB(25, 25, 25)})
                    Utilities:Tween(Dropdown.DropdownFrame, {BackgroundColor3 = Color3.fromRGB(21, 21, 21)})
                end)
                
            function Dropdowns:Toggle(bool)
                State = bool
                
                if State then
                    Utilities:Tween(Dropdown.DropdownFrame, {Size = UDim2.new(0, 199, 0, Dropdown.DropdownFrame.Size.Y.Offset + DropdownY)})
                    Utilities:Tween(DropdownContainer, {Size = UDim2.new(0, 199, 0, DropdownY)})
                    Utilities:Tween(DropdownIcon, {Rotation = 180})
                    else
                        Utilities:Tween(Dropdown.DropdownFrame, {Size = UDim2.new(0, 199, 0, Dropdown.DropdownFrame.Size.Y.Offset - DropdownY)})
                        Utilities:Tween(DropdownContainer, {Size = UDim2.new(0, 199, 0, 0)})
                        Utilities:Tween(DropdownIcon, {Rotation = 0})
                end
                
            end
            
            local function OnPick(element, string)
                if Info.MultiSelect then
                    if not table.find(Dropdowns.Selected, string) then
                        table.insert(Dropdowns.Selected, string)
                        Utilities:Tween(element.DropdownElementText, {TextColor3 = Color3.fromRGB(26, 194, 118)})
                        task.spawn(Info.Callback, Dropdowns.Selected)
                        if Info.Flag then
                            Library.Flags[Info.Flag] = Dropdowns.Selected
                        end
                        else
                            for i, v in pairs(Dropdowns.Selected) do
                                if v == string then
                                    table.remove(Dropdowns.Selected, i)
                                end
                            end
                            task.spawn(Info.Callback, Dropdowns.Selected)
                            Utilities:Tween(element.DropdownElementText, {TextColor3 = Color3.fromRGB(209, 209, 209)})
                            if Info.Flag then
                                Library.Flags[Info.Flag] = Dropdowns.Selected
                            end
                    end
                    else
                        Dropdowns.Selected = string
                        task.spawn(Info.Callback, string)
                        if Info.Flag then
                            Library.Flags[Info.Flag] = string
                        end
                        
                        for _, v in pairs(DropdownContainer:GetChildren()) do
                            if v.ClassName == "Frame" and v ~= element then
                                Utilities:Tween(v.DropdownElementText, {TextColor3 = Color3.fromRGB(209, 209, 209)})
                            end
                        end
                        
                end
                
                if Info.ChangeText then
                    if Info.MultiSelect then
                        Dropdown.DropdownFrame.DropdownText.Text = ""
                        for i, v in pairs(Dropdowns.Selected) do
                            Dropdown.DropdownFrame.DropdownText.Text ..= i ~= #Dropdowns.Selected and v..", " or v
                        end
                        if string.len(Dropdown.DropdownFrame.DropdownText.Text) == 0 then
                            Dropdown.DropdownFrame.DropdownText.Text = Info.Text
                        end
                    else
                        Dropdown.DropdownFrame.DropdownText.Text = string
                    end
                end
                
                if State and not Info.MultiSelect then
                    Dropdowns:Toggle(false)
                end
            end
            
            function Dropdowns:Add(string)
                local DropdownElement = Utilities:Create("Frame", {
                    Name = "DropdownElement",
                    Size = UDim2.fromOffset(199, 27),
                    Parent = DropdownContainer,
                    BackgroundTransparency = 1,
                    ZIndex = DropIndex
                    }, {
                    Utilities:Create("TextLabel", {
                        Name = "DropdownElementText",
                        Size = UDim2.fromScale(1, 1),
                        Text = string,
                        BackgroundTransparency = 1,
                        Position = UDim2.fromOffset(6, 0),
                        TextColor3 = Color3.fromRGB(209, 209, 209),
                        ZIndex = DropIndex
                        }),
                    Utilities:Create("TextButton", {
                        Name = "DropdownElementButton",
                        Size = UDim2.fromScale(1, 1),
                        BackgroundTransparency = 1,
                        ZIndex = DropIndex
                        })
                    })
                
                DropdownElement.DropdownElementButton.MouseButton1Click:Connect(function()
                    OnPick(DropdownElement, DropdownElement.DropdownElementText.Text)
                end)
                
            end
            
            function Dropdowns:Pick(string)
                for _, v in pairs(DropdownContainer:GetChildren()) do
                    if v.ClassName == "Frame" and v.DropdownElementText.Text == string then
                        OnPick(v, v.DropdownElementText.Text)
                    end
                end
            end
            
            for _, v in ipairs(Info.List) do
                Dropdowns:Add(v)
            end
            
            if Info.Default then
                Dropdowns:Pick(Info.Default)
            end
            
            DropdownButton.MouseButton1Click:Connect(function()
                State = not State
                
                Dropdowns:Toggle(State)
            end)
            
            DropIndex = DropIndex - 1
            
            return Dropdowns
            end
            
            function Sections:Slider(Info)
                Info.Text = Info.Text or "Slider"
                Info.Flag = Info.Flag or nil
                Info.Tooltip = Info.Tooltip or nil
                Info.Default = Info.Default or 5
                Info.Minimum = Info.Minimum or 0
                Info.Maximum = Info.Maximum or 10
                Info.Incrementation = Info.Incrementation or 1
                Info.Postfix = Info.Postfix or ""
                Info.Callback = Info.Callback or function() end
                
                if Info.Minimum > Info.Maximum then
                    local ValueBefore = Info.Minimum
                    Info.Minimum, Info.Maximum = Info.Maximum, ValueBefore
                end
                
                local DefaultValue = math.clamp(Info.Default, Info.Minimum, Info.Maximum)
                local Rounded = Utilities:Round(DefaultValue, Info.Incrementation)
                
                local DefaultScale = (Rounded - Info.Minimum) / (Info.Maximum - Info.Minimum)
                
                local StepFormat = "%d"
                local Step = Info.Incrementation
                
                for i = 1, 10 do
                    if Step == 1 then break end
                    
                    StepFormat = '%.' .. i .. 'f'
                    if StepFormat:format(Step) == tostring(Step) then
                        break
                    end
                end
                
                local Slider = Utilities:Create("Frame", {
                    Name = "Slider",
                    Size = UDim2.new(0, 205, 0, 27),
                    Parent = SectionContainer,
                    BackgroundTransparency = 1
                    }, {
                    Utilities:Create("Frame", {
                        Name = "SliderFrame",
                        BackgroundColor3 = Color3.fromRGB(21, 21, 21),
                        Position = UDim2.fromOffset(3, 2),
                        Size = UDim2.fromOffset(199, 23)
                        }, {
                        Utilities:Create("UIStroke", {
                            Color = Color3.fromRGB(25, 25, 25)
                            }),
                        Utilities:Create("UICorner", {
                            CornerRadius = UDim.new(0, 2)
                            }),
                        Utilities:Create("TextButton", {
                            Name = "SliderButton",
                            Size = UDim2.fromScale(1, 1),
                            BackgroundTransparency = 1
                            }),
                        Utilities:Create("TextLabel", {
                            Name = "SliderText",
                            Position = UDim2.fromOffset(6, 0),
                            Size = UDim2.fromScale(1, 1),
                            Text = Info.Text,
                            TextColor3 = Color3.fromRGB(205, 205, 205),
                            BackgroundTransparency = 1,
                            ZIndex = 2
                            }),
                        Utilities:Create("TextLabel", {
                            Name = "SliderValueText",
                            Position = UDim2.fromOffset(-6, 0),
                            Size = UDim2.fromScale(1, 1),
                            Text = StepFormat:format(Rounded)..Info.Postfix,
                            TextXAlignment = Enum.TextXAlignment.Right,
                            TextColor3 = Color3.fromRGB(205, 205, 205),
                            BackgroundTransparency = 1,
                            ZIndex = 2
                            }),
                        Utilities:Create("Frame", {
                            Name = "SliderInner",
                            Size = UDim2.fromScale(DefaultScale, 1),
                            BackgroundColor3 = Color3.fromRGB(31, 31, 31),
                            }, {
                            Utilities:Create("UICorner", {
                                CornerRadius = UDim.new(0, 2)
                                }),
                            })
                        })
                    })
                
                if Info.Tooltip then
                    Utilities:Tooltip(Slider.SliderFrame, Info.Tooltip)
                end
                
                local SliderOuter = Slider.SliderFrame
                local SliderInner = SliderOuter.SliderInner
                local SliderButton = SliderOuter.SliderButton
                
                SliderOuter.MouseEnter:Connect(function()
                    Utilities:Tween(SliderOuter.SliderText, {TextColor3 = Color3.fromRGB(215, 215, 215)})
                    Utilities:Tween(SliderOuter, {BackgroundColor3 = Color3.fromRGB(23, 23, 23)})
                    Utilities:Tween(SliderOuter.UIStroke, {Color = Color3.fromRGB(29, 29, 29)})
                end)
                
                SliderOuter.MouseLeave:Connect(function()
                    Utilities:Tween(SliderOuter.SliderText, {TextColor3 = Color3.fromRGB(205, 205, 205)})
                    Utilities:Tween(SliderOuter.UIStroke, {Color = Color3.fromRGB(25, 25, 25)})
                    Utilities:Tween(SliderOuter, {BackgroundColor3 = Color3.fromRGB(21, 21, 21)})
                end)
                
                SliderButton.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        Utilities:Tween(SliderInner, {BackgroundColor3 = Color3.fromRGB(35, 35, 35)})
                        
                        input.Changed:Connect(function()
                            if input.UserInputState == Enum.UserInputState.End then
                                Utilities:Tween(SliderInner, {BackgroundColor3 = Color3.fromRGB(31, 31, 31)})
                            end
                        end)
                    end
                end)
                
                task.spawn(Info.Callback, Info.Default)
                if Info.Flag then
                    Library.Flags[Info.Flag] = Info.Default
                end
                
                local MinSize = 0
                local MaxSize = 1
                
                local SizeFromScale = (MinSize +  (MaxSize - MinSize)) * DefaultScale
                SizeFromScale = SizeFromScale - (SizeFromScale % 2)
                
                SliderButton.MouseButton1Down:Connect(function()
                    local MouseMove, MouseKill
                    MouseMove = Mouse.Move:Connect(function()
                        local Px = Utilities:GetXY(SliderOuter)
                        local ScaledValue = Px * (Info.Maximum - Info.Minimum) + Info.Minimum
                        local RoundedValue = Utilities:Round(ScaledValue, Info.Incrementation)
                        local FinalValue = math.clamp(RoundedValue, Info.Minimum, Info.Maximum)
                        local SizeX = (FinalValue - Info.Minimum) / (Info.Maximum - Info.Minimum)
                        Utilities:Tween(SliderInner, {Size = UDim2.new(SizeX,0,1,0)}, 0.09)
                        if Info.Flag then
                            Library.Flags[Info.Flag] = FinalValue
                        end
                        SliderOuter.SliderValueText.Text = StepFormat:format(FinalValue)..Info.Postfix
                        task.spawn(Info.Callback, FinalValue)
                    end)
                    MouseKill = UserInputService.InputEnded:Connect(function(UserInput)
                        if UserInput.UserInputType == Enum.UserInputType.MouseButton1 or UserInput.UserInputType == Enum.UserInputType.Touch then
                            MouseMove:Disconnect()
                            MouseKill:Disconnect()
                        end
                    end)
                end)
            end
            
            function Sections:Input(Info)
                Info.Text = Info.Text or "Input"
                Info.Flag = Info.Flag or nil
                Info.Tooltip = Info.Tooltip or nil
                Info.Callback = Info.Callback or function() end
                
                local Input = Utilities:Create("Frame", {
                    Name = "Input",
                    Size = UDim2.new(0, 205, 0, 27),
                    Parent = SectionContainer,
                    BackgroundTransparency = 1
                    }, {
                    Utilities:Create("Frame", {
                        Name = "InputFrame",
                        BackgroundColor3 = Color3.fromRGB(21, 21, 21),
                        Position = UDim2.fromOffset(3, 2),
                        ClipsDescendants = true,
                        Size = UDim2.fromOffset(199, 23)
                        }, {
                        Utilities:Create("TextBox", {
                            Name = "InputTextBox",
                            PlaceholderText = Info.Text,
                            PlaceholderColor3 = Color3.fromRGB(170, 170, 170),
                            TextColor3 = Color3.fromRGB(205, 205, 205),
                            TextXAlignment = Enum.TextXAlignment.Center,
                            BackgroundTransparency = 1,
                            Size = UDim2.fromScale(1, 1)
                            }),
                        Utilities:Create("UICorner", {
                            CornerRadius = UDim.new(0, 2)
                            }),
                        Utilities:Create("UIStroke", {
                            Color = Color3.fromRGB(25, 25, 25)
                            })
                        })
                    })
                
                if Info.Tooltip then
                    Utilities:Tooltip(Input.InputFrame, Info.Tooltip)
                end
                
                local Activated = false
                
                Input.InputFrame.MouseEnter:Connect(function()
                    if not Activated then
                        Utilities:Tween(Input.InputFrame, {BackgroundColor3 = Color3.fromRGB(23, 23, 23)})
                        Utilities:Tween(Input.InputFrame.UIStroke, {Color = Color3.fromRGB(29, 29, 29)})
                    end
                end)
                
                Input.InputFrame.MouseLeave:Connect(function()
                    if not Activated then
                        Utilities:Tween(Input.InputFrame.UIStroke, {Color = Color3.fromRGB(25, 25, 25)})
                        Utilities:Tween(Input.InputFrame, {BackgroundColor3 = Color3.fromRGB(21, 21, 21)})
                    end
                end)
                
                local Activated = false
                Input.InputFrame.InputTextBox.Focused:Connect(function()
                    Activated = true
                    
                    Utilities:Tween(Input.InputFrame, {BackgroundColor3 = Color3.fromRGB(23, 23, 23)})
                    Utilities:Tween(Input.InputFrame.UIStroke, {Color = Color3.fromRGB(29, 29, 29)})
                end)
                
                Input.InputFrame.InputTextBox.FocusLost:Connect(function()
                    task.spawn(Info.Callback, Input.InputFrame.InputTextBox.Text)
                    if Info.Flag ~= nil then
                        Library.Flags[Info.Flag] = Input.InputFrame.InputTextBox.Text
                    end
                    
                    Activated = false
                    
                    Utilities:Tween(Input.InputFrame.UIStroke, {Color = Color3.fromRGB(25, 25, 25)})
                    Utilities:Tween(Input.InputFrame, {BackgroundColor3 = Color3.fromRGB(21, 21, 21)})
                end)
            end
            
            function Sections:Keybind(Info)
                Info.Text = Info.Text or "Keybind"
                Info.Tooltip = Info.Tooltip or nil
                Info.Default = Info.Default or Enum.KeyCode.End
                Info.Callback = Info.Callback or function() end
                
                local PressKey = Info.Default
                
                local Debounce = false
                
                local Format = "[%s]"
                
                local Keybind = Utilities:Create("Frame", {
                    Name = "Keybind",
                    Size = UDim2.new(0, 205, 0, 27),
                    Parent = SectionContainer,
                    BackgroundTransparency = 1
                    }, {
                    Utilities:Create("TextButton", {
                        Name = "KeybindButton",
                        Size = UDim2.fromScale(1, 1),
                        BackgroundTransparency = 1
                        }),
                    Utilities:Create("TextLabel", {
                        Name = "KeybindText",
                        Position = UDim2.fromOffset(3, 2),
                        Text = Info.Text,
                        TextColor3 = Color3.fromRGB(205, 205, 205),
                        BackgroundTransparency = 1,
                        Size = UDim2.fromOffset(199, 23)
                        }),
                    Utilities:Create("TextLabel", {
                        Name = "KeybindKeyText",
                        Position = UDim2.fromOffset(3, 2),
                        TextXAlignment = Enum.TextXAlignment.Right,
                        TextColor3 = Color3.fromRGB(165, 165, 165),
                        Text = string.format(Format, PressKey.Name),
                        BackgroundTransparency = 1,
                        Size = UDim2.fromOffset(199, 23)
                        })
                    })
                
                if Info.Tooltip then
                    Utilities:Tooltip(Keybind, Info.Tooltip)
                end
                
                local KeybindButton = Keybind.KeybindButton
                local KeybindKeyText = Keybind.KeybindKeyText
                
                KeybindButton.MouseButton1Click:Connect(function()
                    if Debounce then return end
                    
                    Debounce = true
                    
                    KeybindKeyText.Text = "[...]"
                    
                    local Listening
                    
                    Listening = UserInputService.InputBegan:Connect(function(Input)
                        if not table.find(BlacklistedKeys, Input.KeyCode) then
                            PressKey = Input.KeyCode
                            KeybindKeyText.Text = string.format(Format, PressKey.Name)
                            
                            task.wait(.1)
                            Debounce = false
                            Listening:Disconnect()
                        end
                    end)
                end)
                
                UserInputService.InputBegan:Connect(function(Input)
                    if Debounce then return end
                    if Input.KeyCode == PressKey then
                        task.spawn(Info.Callback)
                    end
                end)
                
            end
            
            function Sections:ColorPicker(Info)
                Info.Text = Info.Text or "Color Picker"
                Info.Default = Info.Default or Color3.fromRGB(255, 0, 0)
                Info.Callback = Info.Callback or function() end
                
                local State = false
                
                local ColorPickers = {}
                
                local H = 0
                local S = 1
                local V = 1
                
                local Color = Color3.fromHSV(H, S, V)
                
                local R = Color.R * 255
                local G = Color.G * 255
                local B = Color.B * 255
                
                
                
                return ColorPickers
            end
            
            return Sections
        end
            
        return Tabs
    end

    return Windows
end

function Library:Exit()
    ScreenGui:Destroy()
end
--//



return Library
