local Library do
    local Workspace = game:GetService("Workspace")
    local UserInputService = game:GetService("UserInputService")
    local Players = game:GetService("Players")
    local HttpService = game:GetService("HttpService")
    local RunService = game:GetService("RunService")
    local CoreGui = cloneref and cloneref(game:GetService("CoreGui")) or game:GetService("CoreGui")
    local TweenService = game:GetService("TweenService")
    local Lighting = game:GetService("Lighting")

    gethui = gethui or function()
        return CoreGui
    end

    local LocalPlayer = Players.LocalPlayer
    local Camera = Workspace.CurrentCamera
    local Mouse = LocalPlayer:GetMouse()

    local FromRGB = Color3.fromRGB
    local FromHSV = Color3.fromHSV
    local FromHex = Color3.fromHex
    local RGBSequence = ColorSequence.new
    local RGBSequenceKeypoint = ColorSequenceKeypoint.new
    local NumSequence = NumberSequence.new
    local NumSequenceKeypoint = NumberSequenceKeypoint.new
  
    local UDim2New = UDim2.new
    local UDimNew = UDim.new
    local UDim2FromOffset = UDim2.fromOffset
    local Vector2New = Vector2.new

    local MathClamp = math.clamp
    local MathFloor = math.floor
    local MathAbs = math.abs

    
    local TableInsert = table.insert
    local TableFind = table.find
    local TableRemove = table.remove
    local TableConcat = table.concat
    local TableClone = table.clone
    local TableUnpack = table.unpack

    
    local StringFormat = string.format
    local StringFind = string.find
    local StringGSub = string.gsub
    local StringLower = string.lower
    local StringLen = string.len

    local InstanceNew = Instance.new
    local RectNew = Rect.new

    
    local function DetectDevice()
        if game and game.GetService then
            local UserInputService = game:GetService("UserInputService")
            local GuiService = game:GetService("GuiService")

            if GuiService:IsTenFootInterface() then
                return "Console"
            end

            if UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled then
                return "Mobile"
            end

            if UserInputService.TouchEnabled and UserInputService.KeyboardEnabled then
                local camera = workspace.CurrentCamera
                if camera then
                    local viewportSize = camera.ViewportSize
                    if viewportSize.X < 1024 or viewportSize.Y < 768 then
                        return "Mobile"
                    end
                end
            end

            if UserInputService.KeyboardEnabled or UserInputService.MouseEnabled then
                return "PC"
            end

            if UserInputService.GamepadEnabled then
                return "Console"
            end

            return "Unknown"
        else
            return "PC"
        end
    end

    local IsMobile = (DetectDevice() == "Mobile")

    
    Library = {
        Theme = {},
        ToClean = {},
        MenuKeybind = tostring(Enum.KeyCode.RightAlt),
        Flags = {},
        Pages = {},
        Sections = {},
        Connections = {},
        Threads = {},
        ThemeMap = {},
        ThemeItems = {},
        OpenFrames = {},
        SetFlags = {},
        UnnamedConnections = 0,
        UnnamedFlags = 0,
        Holder = nil,
        NotifHolder = nil,
        UnusedHolder = nil,
        Font = nil,
        Folders = {
            Configs = "DiscordLib/Configs",
            Assets = "DiscordLib/Assets"
        }
    }

    Library.__index = Library
    Library.Sections.__index = Library.Sections
    Library.Pages.__index = Library.Pages

    
    Library.Theme = {
        
        Background = FromRGB(10, 10, 10),        
        Background2 = FromRGB(15, 15, 15),        
        Element = FromRGB(20, 20, 20),            
        ElementHover = FromRGB(25, 25, 25),       
        Section = FromRGB(18, 18, 18),            
        
        
        Accent = FromRGB(0, 120, 255),             
        AccentGradient = FromRGB(0, 150, 255),     
        AccentHover = FromRGB(30, 140, 255),       
        
        
        Text = FromRGB(220, 220, 220),              
        TextDim = FromRGB(140, 140, 140),           
        TextMuted = FromRGB(90, 90, 90),            
        
        
        Separator = FromRGB(30, 30, 30),            
        Outline = FromRGB(25, 25, 25),              
    }

    
    do
        local SemiBold = Font.new("rbxassetid://12187365364", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)
        local Regular = Font.new("rbxassetid://12187365364", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
        local Light = Font.new("rbxassetid://12187365364", Enum.FontWeight.Light, Enum.FontStyle.Normal)

        Library.Fonts = {
            SemiBold = SemiBold,
            Regular = Regular,
            Light = Light
        }
        Library.Font = SemiBold
    end

    
    Library.Holder = InstanceNew("ScreenGui")
    Library.Holder.Name = "ModernUILibrary"
    Library.Holder.Parent = gethui()
    Library.Holder.ZIndexBehavior = Enum.ZIndexBehavior.Global
    Library.Holder.DisplayOrder = 2
    Library.Holder.ResetOnSpawn = false

    Library.UnusedHolder = InstanceNew("ScreenGui")
    Library.UnusedHolder.Name = "UnusedHolder"
    Library.UnusedHolder.Parent = gethui()
    Library.UnusedHolder.ZIndexBehavior = Enum.ZIndexBehavior.Global
    Library.UnusedHolder.Enabled = false
    Library.UnusedHolder.ResetOnSpawn = false

    Library.NotifHolder = InstanceNew("Frame")
    Library.NotifHolder.Name = "NotificationHolder"
    Library.NotifHolder.Parent = Library.Holder
    Library.NotifHolder.BackgroundTransparency = 1
    Library.NotifHolder.Size = UDim2New(0, 350, 1, 0)
    Library.NotifHolder.Position = UDim2New(1, -20, 0, 20)
    Library.NotifHolder.AnchorPoint = Vector2New(1, 0)
    Library.NotifHolder.BorderSizePixel = 0

    local NotifList = InstanceNew("UIListLayout")
    NotifList.Parent = Library.NotifHolder
    NotifList.Padding = UDimNew(0, 8)
    NotifList.SortOrder = Enum.SortOrder.LayoutOrder
    NotifList.VerticalAlignment = Enum.VerticalAlignment.Top

    
    function Library:Round(Number, Float)
        local Multiplier = 1 / (Float or 1)
        return MathFloor(Number * Multiplier) / Multiplier
    end

    function Library:Thread(Function)
        local NewThread = coroutine.create(Function)
        coroutine.wrap(function() coroutine.resume(NewThread) end)()
        TableInsert(self.Threads, NewThread)
        return NewThread
    end

    function Library:SafeCall(Function, ...)
        local Arguments = { ... }
        local Success, Result = pcall(Function, TableUnpack(Arguments))
        if not Success then
            warn(Result)
            return false
        end
        return Success, Result
    end

    function Library:Connect(Event, Callback, Name)
        Name = Name or StringFormat("connection_%d", self.UnnamedConnections + 1)
        local Connection = Event:Connect(Callback)
        TableInsert(self.Connections, {Connection = Connection, Name = Name})
        self.UnnamedConnections = self.UnnamedConnections + 1
        return Connection
    end

    function Library:NextFlag()
        self.UnnamedFlags = self.UnnamedFlags + 1
        return StringFormat("flag_%d", self.UnnamedFlags)
    end

    function Library:IsMouseOverFrame(Frame)
        if not Frame then return false end
        Frame = Frame.Instance or Frame
        if not Frame or not Frame.Parent then return false end

        local MousePos = Vector2New(Mouse.X, Mouse.Y)
        return MousePos.X >= Frame.AbsolutePosition.X and 
               MousePos.X <= Frame.AbsolutePosition.X + Frame.AbsoluteSize.X and
               MousePos.Y >= Frame.AbsolutePosition.Y and 
               MousePos.Y <= Frame.AbsolutePosition.Y + Frame.AbsoluteSize.Y
    end

    
    function Library:Window(Data)
        Data = Data or {}
        
        local Window = {
            Name = Data.Name or "SHO",
            SubName = Data.SubName or "",
            Pages = {},
            IsOpen = true,
            Items = {}
        }

        
        local Main = InstanceNew("Frame")
        Main.Name = "MainWindow"
        Main.Parent = Library.Holder
        Main.BackgroundColor3 = Library.Theme.Background
        Main.BorderSizePixel = 0
        Main.Size = UDim2New(0, 800, 0, 500)
        Main.Position = UDim2New(0.5, -400, 0.5, -250)
        Main.AnchorPoint = Vector2New(0.5, 0.5)
        Main.ClipsDescendants = true
        Window.Items.Main = Main

        local MainCorner = InstanceNew("UICorner")
        MainCorner.Parent = Main
        MainCorner.CornerRadius = UDimNew(0, 6)

        
        do
            local dragging = false
            local dragStart
            local startPos

            Main.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = true
                    dragStart = input.Position
                    startPos = Main.Position
                end
            end)

            Main.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = false
                end
            end)

            Library:Connect(UserInputService.InputChanged, function(input)
                if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                    local delta = input.Position - dragStart
                    Main.Position = UDim2New(
                        startPos.X.Scale, 
                        startPos.X.Offset + delta.X,
                        startPos.Y.Scale, 
                        startPos.Y.Offset + delta.Y
                    )
                end
            end)
        end

        
        local TopBar = InstanceNew("Frame")
        TopBar.Name = "TopBar"
        TopBar.Parent = Main
        TopBar.BackgroundColor3 = Library.Theme.Background2
        TopBar.BorderSizePixel = 0
        TopBar.Size = UDim2New(1, 0, 0, 45)
        TopBar.Position = UDim2New(0, 0, 0, 0)
        Window.Items.TopBar = TopBar

        local TopBarCorner = InstanceNew("UICorner")
        TopBarCorner.Parent = TopBar
        TopBarCorner.CornerRadius = UDimNew(0, 6)

        
        local Title = InstanceNew("TextLabel")
        Title.Name = "Title"
        Title.Parent = TopBar
        Title.BackgroundTransparency = 1
        Title.Text = Window.Name
        Title.TextColor3 = Library.Theme.Text
        Title.FontFace = Library.Font
        Title.TextSize = 18
        Title.TextXAlignment = Enum.TextXAlignment.Left
        Title.Size = UDim2New(0, 100, 1, 0)
        Title.Position = UDim2New(0, 15, 0, 0)
        Window.Items.Title = Title

        
        local Tags = InstanceNew("Frame")
        Tags.Name = "Tags"
        Tags.Parent = TopBar
        Tags.BackgroundTransparency = 1
        Tags.Size = UDim2New(0, 150, 1, 0)
        Tags.Position = UDim2New(0, 120, 0, 0)
        Window.Items.Tags = Tags

        local TagsLayout = InstanceNew("UIListLayout")
        TagsLayout.Parent = Tags
        TagsLayout.FillDirection = Enum.FillDirection.Horizontal
        TagsLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
        TagsLayout.VerticalAlignment = Enum.VerticalAlignment.Center
        TagsLayout.Padding = UDimNew(0, 8)

        
        local BetaTag = InstanceNew("Frame")
        BetaTag.Name = "BetaTag"
        BetaTag.Parent = Tags
        BetaTag.BackgroundColor3 = Library.Theme.Accent
        BetaTag.BorderSizePixel = 0
        BetaTag.Size = UDim2New(0, 45, 0, 22)

        local BetaTagCorner = InstanceNew("UICorner")
        BetaTagCorner.Parent = BetaTag
        BetaTagCorner.CornerRadius = UDimNew(0, 4)

        local BetaText = InstanceNew("TextLabel")
        BetaText.Parent = BetaTag
        BetaText.BackgroundTransparency = 1
        BetaText.Text = "BETA"
        BetaText.TextColor3 = Library.Theme.Text
        BetaText.FontFace = Library.Font
        BetaText.TextSize = 12
        BetaText.Size = UDim2New(1, 0, 1, 0)

        
        local VersionTag = InstanceNew("Frame")
        VersionTag.Name = "VersionTag"
        VersionTag.Parent = Tags
        VersionTag.BackgroundColor3 = Library.Theme.Element
        VersionTag.BorderSizePixel = 0
        VersionTag.Size = UDim2New(0, 50, 0, 22)

        local VersionTagCorner = InstanceNew("UICorner")
        VersionTagCorner.Parent = VersionTag
        VersionTagCorner.CornerRadius = UDimNew(0, 4)

        local VersionText = InstanceNew("TextLabel")
        VersionText.Parent = VersionTag
        VersionText.BackgroundTransparency = 1
        VersionText.Text = "v0.0.2"
        VersionText.TextColor3 = Library.Theme.TextDim
        VersionText.FontFace = Library.Font
        VersionText.TextSize = 12
        VersionText.Size = UDim2New(1, 0, 1, 0)

        
        local PaidTag = InstanceNew("Frame")
        PaidTag.Name = "PaidTag"
        PaidTag.Parent = Tags
        PaidTag.BackgroundColor3 = Library.Theme.Element
        PaidTag.BorderSizePixel = 0
        PaidTag.Size = UDim2New(0, 45, 0, 22)

        local PaidTagCorner = InstanceNew("UICorner")
        PaidTagCorner.Parent = PaidTag
        PaidTagCorner.CornerRadius = UDimNew(0, 4)

        local PaidText = InstanceNew("TextLabel")
        PaidText.Parent = PaidTag
        PaidText.BackgroundTransparency = 1
        PaidText.Text = "PAID"
        PaidText.TextColor3 = Library.Theme.TextDim
        PaidText.FontFace = Library.Font
        PaidText.TextSize = 12
        PaidText.Size = UDim2New(1, 0, 1, 0)

        
        local CloseButton = InstanceNew("TextButton")
        CloseButton.Name = "CloseButton"
        CloseButton.Parent = TopBar
        CloseButton.BackgroundColor3 = Library.Theme.Element
        CloseButton.BorderSizePixel = 0
        CloseButton.Size = UDim2New(0, 32, 0, 32)
        CloseButton.Position = UDim2New(1, -42, 0.5, -16)
        CloseButton.Text = ""
        CloseButton.AutoButtonColor = false

        local CloseCorner = InstanceNew("UICorner")
        CloseCorner.Parent = CloseButton
        CloseCorner.CornerRadius = UDimNew(0, 4)

        local CloseIcon = InstanceNew("ImageLabel")
        CloseIcon.Parent = CloseButton
        CloseIcon.BackgroundTransparency = 1
        CloseIcon.Size = UDim2New(0, 12, 0, 12)
        CloseIcon.Position = UDim2New(0.5, -6, 0.5, -6)
        CloseIcon.Image = "rbxassetid://10747380494"
        CloseIcon.ImageColor3 = Library.Theme.TextDim

        CloseButton.MouseEnter:Connect(function()
            CloseIcon:TweenSize(UDim2New(0, 14, 0, 14), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.15, true)
        end)

        CloseButton.MouseLeave:Connect(function()
            CloseIcon:TweenSize(UDim2New(0, 12, 0, 12), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.15, true)
        end)

        CloseButton.MouseButton1Click:Connect(function()
            Window.IsOpen = false
            Main.Visible = false
        end)

        
        local Content = InstanceNew("Frame")
        Content.Name = "Content"
        Content.Parent = Main
        Content.BackgroundTransparency = 1
        Content.Size = UDim2New(1, 0, 1, -45)
        Content.Position = UDim2New(0, 0, 0, 45)
        Window.Items.Content = Content

        
        local Sidebar = InstanceNew("Frame")
        Sidebar.Name = "Sidebar"
        Sidebar.Parent = Content
        Sidebar.BackgroundColor3 = Library.Theme.Background2
        Sidebar.BorderSizePixel = 0
        Sidebar.Size = UDim2New(0, 200, 1, 0)
        Sidebar.Position = UDim2New(0, 0, 0, 0)
        Window.Items.Sidebar = Sidebar

        local SidebarCorner = InstanceNew("UICorner")
        SidebarCorner.Parent = Sidebar
        SidebarCorner.CornerRadius = UDimNew(0, 6)

        
        local SidebarSeparator = InstanceNew("Frame")
        SidebarSeparator.Parent = Sidebar
        SidebarSeparator.BackgroundColor3 = Library.Theme.Separator
        SidebarSeparator.BorderSizePixel = 0
        SidebarSeparator.Size = UDim2New(0, 1, 1, -20)
        SidebarSeparator.Position = UDim2New(1, -1, 0, 10)

        
        local SidebarContent = InstanceNew("ScrollingFrame")
        SidebarContent.Name = "SidebarContent"
        SidebarContent.Parent = Sidebar
        SidebarContent.BackgroundTransparency = 1
        SidebarContent.BorderSizePixel = 0
        SidebarContent.Size = UDim2New(1, -10, 1, -10)
        SidebarContent.Position = UDim2New(0, 5, 0, 5)
        SidebarContent.ScrollBarThickness = 2
        SidebarContent.ScrollBarImageColor3 = Library.Theme.Accent
        SidebarContent.AutomaticCanvasSize = Enum.AutomaticSize.Y
        SidebarContent.CanvasSize = UDim2New(0, 0, 0, 0)
        Window.Items.SidebarContent = SidebarContent

        local SidebarLayout = InstanceNew("UIListLayout")
        SidebarLayout.Parent = SidebarContent
        SidebarLayout.Padding = UDimNew(0, 15)
        SidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder

        
        local MainPanel = InstanceNew("Frame")
        MainPanel.Name = "MainPanel"
        MainPanel.Parent = Content
        MainPanel.BackgroundTransparency = 1
        MainPanel.Size = UDim2New(1, -210, 1, -20)
        MainPanel.Position = UDim2New(0, 205, 0, 10)
        Window.Items.MainPanel = MainPanel

        local PanelContent = InstanceNew("ScrollingFrame")
        PanelContent.Name = "PanelContent"
        PanelContent.Parent = MainPanel
        PanelContent.BackgroundTransparency = 1
        PanelContent.BorderSizePixel = 0
        PanelContent.Size = UDim2New(1, 0, 1, 0)
        PanelContent.ScrollBarThickness = 2
        PanelContent.ScrollBarImageColor3 = Library.Theme.Accent
        PanelContent.AutomaticCanvasSize = Enum.AutomaticSize.Y
        PanelContent.CanvasSize = UDim2New(0, 0, 0, 0)
        Window.Items.PanelContent = PanelContent

        local PanelLayout = InstanceNew("UIListLayout")
        PanelLayout.Parent = PanelContent
        PanelLayout.Padding = UDimNew(0, 15)
        PanelLayout.SortOrder = Enum.SortOrder.LayoutOrder

        
        local StatusBar = InstanceNew("Frame")
        StatusBar.Name = "StatusBar"
        StatusBar.Parent = Main
        StatusBar.BackgroundColor3 = Library.Theme.Background2
        StatusBar.BorderSizePixel = 0
        StatusBar.Size = UDim2New(1, 0, 0, 30)
        StatusBar.Position = UDim2New(0, 0, 1, -30)
        Window.Items.StatusBar = StatusBar

        local StatusBarCorner = InstanceNew("UICorner")
        StatusBarCorner.Parent = StatusBar
        StatusBarCorner.CornerRadius = UDimNew(0, 6)

        local StatusLayout = InstanceNew("UIListLayout")
        StatusLayout.Parent = StatusBar
        StatusLayout.FillDirection = Enum.FillDirection.Horizontal
        StatusLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
        StatusLayout.VerticalAlignment = Enum.VerticalAlignment.Center
        StatusLayout.Padding = UDimNew(0, 20)

        local StatusPadding = InstanceNew("UIPadding")
        StatusPadding.Parent = StatusBar
        StatusPadding.PaddingLeft = UDimNew(0, 15)

        
        local function CreateStatusItem(icon, text)
            local Item = InstanceNew("Frame")
            Item.Parent = StatusBar
            Item.BackgroundTransparency = 1
            Item.Size = UDim2New(0, 0, 1, 0)
            Item.AutomaticSize = Enum.AutomaticSize.X

            local Icon = InstanceNew("ImageLabel")
            Icon.Parent = Item
            Icon.BackgroundTransparency = 1
            Icon.Size = UDim2New(0, 16, 0, 16)
            Icon.Position = UDim2New(0, 0, 0.5, -8)
            Icon.Image = "rbxassetid://" .. icon
            Icon.ImageColor3 = Library.Theme.TextDim

            local Label = InstanceNew("TextLabel")
            Label.Parent = Item
            Label.BackgroundTransparency = 1
            Label.Text = text
            Label.TextColor3 = Library.Theme.TextDim
            Label.FontFace = Library.Font
            Label.TextSize = 13
            Label.Size = UDim2New(0, 0, 1, 0)
            Label.Position = UDim2New(0, 22, 0, 0)
            Label.AutomaticSize = Enum.AutomaticSize.X
            Label.TextXAlignment = Enum.TextXAlignment.Left

            return Item
        end

        CreateStatusItem("6031090990", "Equipped: Vessel")  
        CreateStatusItem("6031090990", "● Connected")       
        CreateStatusItem("6034818372", "WebServer: Active") 

        
        function Window:Category(name)
            local Category = InstanceNew("TextLabel")
            Category.Name = "Category_" .. name
            Category.Parent = SidebarContent
            Category.BackgroundTransparency = 1
            Category.Text = name
            Category.TextColor3 = Library.Theme.TextDim
            Category.FontFace = Library.Font
            Category.TextSize = 11
            Category.TextXAlignment = Enum.TextXAlignment.Left
            Category.Size = UDim2New(1, -10, 0, 20)
            Category.Position = UDim2New(0, 5, 0, 0)
            return Category
        end

        
        function Window:Page(name)
            local Page = {
                Name = name,
                Buttons = {},
                Active = false,
                Window = Window
            }

            
            local Button = InstanceNew("TextButton")
            Button.Name = "PageButton_" .. name
            Button.Parent = SidebarContent
            Button.BackgroundColor3 = Library.Theme.Element
            Button.BorderSizePixel = 0
            Button.Size = UDim2New(1, -10, 0, 32)
            Button.Position = UDim2New(0, 5, 0, 0)
            Button.Text = ""
            Button.AutoButtonColor = false

            local ButtonCorner = InstanceNew("UICorner")
            ButtonCorner.Parent = Button
            ButtonCorner.CornerRadius = UDimNew(0, 4)

            local ButtonText = InstanceNew("TextLabel")
            ButtonText.Parent = Button
            ButtonText.BackgroundTransparency = 1
            ButtonText.Text = name
            ButtonText.TextColor3 = Library.Theme.TextDim
            ButtonText.FontFace = Library.Font
            ButtonText.TextSize = 14
            ButtonText.Position = UDim2New(0, 12, 0, 0)
            ButtonText.Size = UDim2New(1, -12, 1, 0)
            ButtonText.TextXAlignment = Enum.TextXAlignment.Left

            
            Button.MouseEnter:Connect(function()
                if not Page.Active then
                    Button.BackgroundColor3 = Library.Theme.ElementHover
                end
            end)

            Button.MouseLeave:Connect(function()
                if not Page.Active then
                    Button.BackgroundColor3 = Library.Theme.Element
                end
            end)

            
            local ContentFrame = InstanceNew("Frame")
            ContentFrame.Name = "PageContent_" .. name
            ContentFrame.Parent = PanelContent
            ContentFrame.BackgroundTransparency = 1
            ContentFrame.Size = UDim2New(1, 0, 0, 0)
            ContentFrame.AutomaticSize = Enum.AutomaticSize.Y
            ContentFrame.Visible = false

            local ContentLayout = InstanceNew("UIListLayout")
            ContentLayout.Parent = ContentFrame
            ContentLayout.Padding = UDimNew(0, 10)
            ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder

            Page.Content = ContentFrame

            
            Button.MouseButton1Click:Connect(function()
                for _, p in pairs(Window.Pages) do
                    if p.Content then
                        p.Content.Visible = false
                        if p.Button then
                            p.Button.BackgroundColor3 = Library.Theme.Element
                            if p.Button.TextLabel then
                                p.Button.TextLabel.TextColor3 = Library.Theme.TextDim
                            end
                        end
                    end
                end

                Page.Active = true
                ContentFrame.Visible = true
                Button.BackgroundColor3 = Library.Theme.Accent
                ButtonText.TextColor3 = Library.Theme.Text

                
                for _, btn in pairs(Page.Buttons) do
                    if btn ~= Button then
                        btn.BackgroundColor3 = Library.Theme.Element
                        if btn.TextLabel then
                            btn.TextLabel.TextColor3 = Library.Theme.TextDim
                        end
                    end
                end
            end)

            Page.Button = Button
            Page.ButtonText = ButtonText
            TableInsert(Window.Pages, Page)

            
            function Page:Section(name)
                local Section = {
                    Name = name,
                    Page = Page,
                    Items = {}
                }

                
                local Container = InstanceNew("Frame")
                Container.Name = "Section_" .. name
                Container.Parent = ContentFrame
                Container.BackgroundColor3 = Library.Theme.Section
                Container.BorderSizePixel = 0
                Container.Size = UDim2New(1, 0, 0, 0)
                Container.AutomaticSize = Enum.AutomaticSize.Y

                local ContainerCorner = InstanceNew("UICorner")
                ContainerCorner.Parent = Container
                ContainerCorner.CornerRadius = UDimNew(0, 6)

                
                local Header = InstanceNew("Frame")
                Header.Name = "Header"
                Header.Parent = Container
                Header.BackgroundColor3 = Library.Theme.Background2
                Header.BorderSizePixel = 0
                Header.Size = UDim2New(1, 0, 0, 35)
                Header.Position = UDim2New(0, 0, 0, 0)

                local HeaderCorner = InstanceNew("UICorner")
                HeaderCorner.Parent = Header
                HeaderCorner.CornerRadius = UDimNew(0, 6)

                local HeaderText = InstanceNew("TextLabel")
                HeaderText.Parent = Header
                HeaderText.BackgroundTransparency = 1
                HeaderText.Text = name
                HeaderText.TextColor3 = Library.Theme.Text
                HeaderText.FontFace = Library.Font
                HeaderText.TextSize = 14
                HeaderText.Position = UDim2New(0, 15, 0, 0)
                HeaderText.Size = UDim2New(1, -15, 1, 0)
                HeaderText.TextXAlignment = Enum.TextXAlignment.Left

                
                local Content = InstanceNew("Frame")
                Content.Name = "Content"
                Content.Parent = Container
                Content.BackgroundTransparency = 1
                Content.Size = UDim2New(1, -20, 0, 0)
                Content.Position = UDim2New(0, 10, 0, 45)
                Content.AutomaticSize = Enum.AutomaticSize.Y

                local ContentLayout = InstanceNew("UIListLayout")
                ContentLayout.Parent = Content
                ContentLayout.Padding = UDimNew(0, 8)
                ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder

                Section.Container = Container
                Section.Content = Content

                
                local function CreateOptionRow(title, description)
                    local Row = InstanceNew("Frame")
                    Row.Name = "OptionRow_" .. title
                    Row.Parent = Content
                    Row.BackgroundTransparency = 1
                    Row.Size = UDim2New(1, 0, 0, 40)
                    Row.AutomaticSize = Enum.AutomaticSize.Y

                    local TitleLabel = InstanceNew("TextLabel")
                    TitleLabel.Parent = Row
                    TitleLabel.BackgroundTransparency = 1
                    TitleLabel.Text = title
                    TitleLabel.TextColor3 = Library.Theme.Text
                    TitleLabel.FontFace = Library.Font
                    TitleLabel.TextSize = 14
                    TitleLabel.Position = UDim2New(0, 0, 0, 0)
                    TitleLabel.Size = UDim2New(0, 200, 0, 18)
                    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left

                    if description then
                        local DescLabel = InstanceNew("TextLabel")
                        DescLabel.Parent = Row
                        DescLabel.BackgroundTransparency = 1
                        DescLabel.Text = description
                        DescLabel.TextColor3 = Library.Theme.TextDim
                        DescLabel.FontFace = Library.Font
                        DescLabel.TextSize = 12
                        DescLabel.Position = UDim2New(0, 0, 0, 18)
                        DescLabel.Size = UDim2New(0, 200, 0, 16)
                        DescLabel.TextXAlignment = Enum.TextXAlignment.Left
                    end

                    
                    local Controls = InstanceNew("Frame")
                    Controls.Name = "Controls"
                    Controls.Parent = Row
                    Controls.BackgroundTransparency = 1
                    Controls.Size = UDim2New(0, 150, 1, 0)
                    Controls.Position = UDim2New(1, -150, 0, 0)

                    local ControlsLayout = InstanceNew("UIListLayout")
                    ControlsLayout.Parent = Controls
                    ControlsLayout.FillDirection = Enum.FillDirection.Horizontal
                    ControlsLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
                    ControlsLayout.VerticalAlignment = Enum.VerticalAlignment.Center
                    ControlsLayout.Padding = UDimNew(0, 8)

                    return Row, Controls, TitleLabel
                end

                
                function Section:Toggle(data)
                    data = data or {}
                    local title = data.Name or "Toggle"
                    local desc = data.Description
                    local flag = data.Flag or Library:NextFlag()
                    local default = data.Default or false
                    local callback = data.Callback or function() end

                    local Row, Controls, TitleLabel = CreateOptionRow(title, desc)

                    local ToggleButton = InstanceNew("TextButton")
                    ToggleButton.Name = "Toggle"
                    ToggleButton.Parent = Controls
                    ToggleButton.BackgroundColor3 = Library.Theme.Element
                    ToggleButton.BorderSizePixel = 0
                    ToggleButton.Size = UDim2New(0, 18, 0, 18)
                    ToggleButton.Text = ""
                    ToggleButton.AutoButtonColor = false

                    local ToggleCorner = InstanceNew("UICorner")
                    ToggleCorner.Parent = ToggleButton
                    ToggleCorner.CornerRadius = UDimNew(0, 4)

                    local Checkmark = InstanceNew("ImageLabel")
                    Checkmark.Parent = ToggleButton
                    Checkmark.BackgroundTransparency = 1
                    Checkmark.Size = UDim2New(0, 12, 0, 12)
                    Checkmark.Position = UDim2New(0.5, -6, 0.5, -6)
                    Checkmark.Image = "rbxassetid://10734902493"
                    Checkmark.ImageColor3 = Library.Theme.Text
                    Checkmark.Visible = default

                    local ToggleObj = {
                        Value = default,
                        Button = ToggleButton,
                        Checkmark = Checkmark
                    }

                    function ToggleObj:Set(value)
                        self.Value = value
                        Checkmark.Visible = value
                        Library.Flags[flag] = value
                        Library:SafeCall(callback, value)
                    end

                    ToggleButton.MouseButton1Click:Connect(function()
                        ToggleObj:Set(not ToggleObj.Value)
                    end)

                    ToggleButton.MouseEnter:Connect(function()
                        ToggleButton.BackgroundColor3 = Library.Theme.ElementHover
                    end)

                    ToggleButton.MouseLeave:Connect(function()
                        ToggleButton.BackgroundColor3 = Library.Theme.Element
                    end)

                    ToggleObj:Set(default)

                    return ToggleObj
                end

                
                function Section:Slider(data)
                    data = data or {}
                    local title = data.Name or "Slider"
                    local desc = data.Description
                    local flag = data.Flag or Library:NextFlag()
                    local min = data.Min or 0
                    local max = data.Max or 100
                    local default = data.Default or 0
                    local suffix = data.Suffix or ""
                    local callback = data.Callback or function() end

                    local Row, Controls, TitleLabel = CreateOptionRow(title, desc)

                    
                    local ValueLabel = InstanceNew("TextLabel")
                    ValueLabel.Parent = Controls
                    ValueLabel.BackgroundTransparency = 1
                    ValueLabel.Text = tostring(default) .. suffix
                    ValueLabel.TextColor3 = Library.Theme.Accent
                    ValueLabel.FontFace = Library.Font
                    ValueLabel.TextSize = 13
                    ValueLabel.Size = UDim2New(0, 40, 0, 20)

                    
                    local SliderTrack = InstanceNew("Frame")
                    SliderTrack.Name = "SliderTrack"
                    SliderTrack.Parent = Controls
                    SliderTrack.BackgroundColor3 = Library.Theme.Element
                    SliderTrack.BorderSizePixel = 0
                    SliderTrack.Size = UDim2New(0, 100, 0, 4)

                    local TrackCorner = InstanceNew("UICorner")
                    TrackCorner.Parent = SliderTrack
                    TrackCorner.CornerRadius = UDimNew(1, 0)

                    
                    local SliderFill = InstanceNew("Frame")
                    SliderFill.Name = "SliderFill"
                    SliderFill.Parent = SliderTrack
                    SliderFill.BackgroundColor3 = Library.Theme.Accent
                    SliderFill.BorderSizePixel = 0
                    SliderFill.Size = UDim2New((default - min) / (max - min), 0, 1, 0)

                    local FillCorner = InstanceNew("UICorner")
                    FillCorner.Parent = SliderFill
                    FillCorner.CornerRadius = UDimNew(1, 0)

                    
                    local SliderButton = InstanceNew("TextButton")
                    SliderButton.Name = "SliderButton"
                    SliderButton.Parent = SliderTrack
                    SliderButton.BackgroundTransparency = 1
                    SliderButton.Size = UDim2New(1, 0, 1, 0)
                    SliderButton.Text = ""
                    SliderButton.AutoButtonColor = false

                    local SliderObj = {
                        Value = default,
                        Sliding = false,
                        Track = SliderTrack,
                        Fill = SliderFill,
                        ValueLabel = ValueLabel,
                        Min = min,
                        Max = max,
                        Suffix = suffix
                    }

                    function SliderObj:Set(value)
                        self.Value = MathClamp(value, self.Min, self.Max)
                        local percent = (self.Value - self.Min) / (self.Max - self.Min)
                        self.Fill.Size = UDim2New(percent, 0, 1, 0)
                        self.ValueLabel.Text = tostring(self.Value) .. self.Suffix
                        Library.Flags[flag] = self.Value
                        Library:SafeCall(callback, self.Value)
                    end

                    local function updateFromInput(input)
                        local pos = input.Position.X
                        local trackPos = SliderTrack.AbsolutePosition.X
                        local trackSize = SliderTrack.AbsoluteSize.X
                        local percent = MathClamp((pos - trackPos) / trackSize, 0, 1)
                        SliderObj:Set(min + (max - min) * percent)
                    end

                    SliderButton.InputBegan:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.MouseButton1 then
                            SliderObj.Sliding = true
                            updateFromInput(input)
                        end
                    end)

                    SliderButton.InputEnded:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.MouseButton1 then
                            SliderObj.Sliding = false
                        end
                    end)

                    Library:Connect(UserInputService.InputChanged, function(input)
                        if SliderObj.Sliding and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                            updateFromInput(input)
                        end
                    end)

                    SliderObj:Set(default)

                    return SliderObj
                end

                
                function Section:Dropdown(data)
                    data = data or {}
                    local title = data.Name or "Dropdown"
                    local desc = data.Description
                    local flag = data.Flag or Library:NextFlag()
                    local items = data.Items or {}
                    local default = data.Default
                    local callback = data.Callback or function() end

                    local Row, Controls, TitleLabel = CreateOptionRow(title, desc)

                    
                    local DropButton = InstanceNew("TextButton")
                    DropButton.Name = "Dropdown"
                    DropButton.Parent = Controls
                    DropButton.BackgroundColor3 = Library.Theme.Element
                    DropButton.BorderSizePixel = 0
                    DropButton.Size = UDim2New(0, 100, 0, 24)
                    DropButton.Text = ""
                    DropButton.AutoButtonColor = false

                    local ButtonCorner = InstanceNew("UICorner")
                    ButtonCorner.Parent = DropButton
                    ButtonCorner.CornerRadius = UDimNew(0, 4)

                    local ButtonText = InstanceNew("TextLabel")
                    ButtonText.Parent = DropButton
                    ButtonText.BackgroundTransparency = 1
                    ButtonText.Text = default or items[1] or "Select"
                    ButtonText.TextColor3 = Library.Theme.Text
                    ButtonText.FontFace = Library.Font
                    ButtonText.TextSize = 13
                    ButtonText.Size = UDim2New(1, -20, 1, 0)
                    ButtonText.Position = UDim2New(0, 8, 0, 0)
                    ButtonText.TextXAlignment = Enum.TextXAlignment.Left

                    local Arrow = InstanceNew("ImageLabel")
                    Arrow.Parent = DropButton
                    Arrow.BackgroundTransparency = 1
                    Arrow.Size = UDim2New(0, 12, 0, 12)
                    Arrow.Position = UDim2New(1, -16, 0.5, -6)
                    Arrow.Image = "rbxassetid://6031090990"
                    Arrow.ImageColor3 = Library.Theme.TextDim
                    Arrow.Rotation = 0

                    
                    local Menu = InstanceNew("Frame")
                    Menu.Name = "DropdownMenu"
                    Menu.Parent = Library.Holder
                    Menu.BackgroundColor3 = Library.Theme.Background2
                    Menu.BorderSizePixel = 0
                    Menu.Size = UDim2New(0, 100, 0, 0)
                    Menu.Position = UDim2New(0, 0, 0, 0)
                    Menu.Visible = false
                    Menu.AutomaticSize = Enum.AutomaticSize.Y
                    Menu.ZIndex = 10

                    local MenuCorner = InstanceNew("UICorner")
                    MenuCorner.Parent = Menu
                    MenuCorner.CornerRadius = UDimNew(0, 4)

                    local MenuLayout = InstanceNew("UIListLayout")
                    MenuLayout.Parent = Menu
                    MenuLayout.Padding = UDimNew(0, 2)
                    MenuLayout.SortOrder = Enum.SortOrder.LayoutOrder

                    local MenuPadding = InstanceNew("UIPadding")
                    MenuPadding.Parent = Menu
                    MenuPadding.PaddingTop = UDimNew(0, 4)
                    MenuPadding.PaddingBottom = UDimNew(0, 4)
                    MenuPadding.PaddingLeft = UDimNew(0, 4)
                    MenuPadding.PaddingRight = UDimNew(0, 4)

                    local DropdownObj = {
                        Value = default or items[1],
                        Items = {},
                        Menu = Menu,
                        Button = DropButton,
                        ButtonText = ButtonText,
                        Arrow = Arrow,
                        IsOpen = false
                    }

                    
                    for _, item in ipairs(items) do
                        local ItemButton = InstanceNew("TextButton")
                        ItemButton.Parent = Menu
                        ItemButton.BackgroundTransparency = 1
                        ItemButton.Size = UDim2New(1, 0, 0, 24)
                        ItemButton.Text = ""
                        ItemButton.AutoButtonColor = false

                        local ItemText = InstanceNew("TextLabel")
                        ItemText.Parent = ItemButton
                        ItemText.BackgroundTransparency = 1
                        ItemText.Text = item
                        ItemText.TextColor3 = Library.Theme.TextDim
                        ItemText.FontFace = Library.Font
                        ItemText.TextSize = 13
                        ItemText.Size = UDim2New(1, -8, 1, 0)
                        ItemText.Position = UDim2New(0, 8, 0, 0)
                        ItemText.TextXAlignment = Enum.TextXAlignment.Left

                        ItemButton.MouseEnter:Connect(function()
                            ItemText.TextColor3 = Library.Theme.Text
                        end)

                        ItemButton.MouseLeave:Connect(function()
                            ItemText.TextColor3 = Library.Theme.TextDim
                        end)

                        ItemButton.MouseButton1Click:Connect(function()
                            DropdownObj.Value = item
                            ButtonText.Text = item
                            DropdownObj:SetOpen(false)
                            Library.Flags[flag] = item
                            Library:SafeCall(callback, item)
                        end)

                        DropdownObj.Items[item] = ItemButton
                    end

                    function DropdownObj:SetOpen(open)
                        self.IsOpen = open
                        self.Menu.Visible = open
                        self.Arrow.Rotation = open and 180 or 0

                        if open then
                            local pos = self.Button.AbsolutePosition
                            self.Menu.Position = UDim2New(0, pos.X, 0, pos.Y + self.Button.AbsoluteSize.Y + 4)
                        end
                    end

                    DropButton.MouseButton1Click:Connect(function()
                        DropdownObj:SetOpen(not DropdownObj.IsOpen)
                    end)

                    DropButton.MouseEnter:Connect(function()
                        DropButton.BackgroundColor3 = Library.Theme.ElementHover
                    end)

                    DropButton.MouseLeave:Connect(function()
                        DropButton.BackgroundColor3 = Library.Theme.Element
                    end)

                    
                    Library:Connect(UserInputService.InputBegan, function(input)
                        if input.UserInputType == Enum.UserInputType.MouseButton1 and DropdownObj.IsOpen then
                            if not Library:IsMouseOverFrame(DropdownObj.Menu) and not Library:IsMouseOverFrame(DropdownObj.Button) then
                                DropdownObj:SetOpen(false)
                            end
                        end
                    end)

                    return DropdownObj
                end

                
                function Section:Button(data)
                    data = data or {}
                    local title = data.Name or "Button"
                    local desc = data.Description
                    local callback = data.Callback or function() end

                    local Row, Controls, TitleLabel = CreateOptionRow(title, desc)

                    local GearIcon = InstanceNew("ImageLabel")
                    GearIcon.Parent = Controls
                    GearIcon.BackgroundTransparency = 1
                    GearIcon.Size = UDim2New(0, 16, 0, 16)
                    GearIcon.Image = "rbxassetid://6031090990"
                    GearIcon.ImageColor3 = Library.Theme.TextDim
                    GearIcon.Visible = false  

                    return { GearIcon = GearIcon }
                end

                return Section
            end

            return Page
        end

        
        Window:Category("MAIN")
        Window:Page("General")
        Window:Page("Combat")

        Window:Category("MACROS")
        Window:Page("Auto Moves")
        Window:Page("QTE Assist")

        Window:Category("EXTRAS")
        Window:Page("Misc")
        Window:Page("ESP")
        Window:Page("Info")

        Window:Category("SETTINGS")
        Window:Page("Interface")
        Window:Page("Configuration")

        return Window
    end

    
    function Library:Notification(data)
        data = data or {}

        local Notification = InstanceNew("Frame")
        Notification.Name = "Notification"
        Notification.Parent = self.NotifHolder
        Notification.BackgroundColor3 = self.Theme.Background2
        Notification.BorderSizePixel = 0
        Notification.Size = UDim2New(0, 300, 0, 0)
        Notification.AutomaticSize = Enum.AutomaticSize.Y
        Notification.Position = UDim2New(0, 0, 0, 0)

        local NotifCorner = InstanceNew("UICorner")
        NotifCorner.Parent = Notification
        NotifCorner.CornerRadius = UDimNew(0, 6)

        local Padding = InstanceNew("UIPadding")
        Padding.Parent = Notification
        Padding.PaddingTop = UDimNew(0, 12)
        Padding.PaddingBottom = UDimNew(0, 12)
        Padding.PaddingLeft = UDimNew(0, 12)
        Padding.PaddingRight = UDimNew(0, 12)

        local Title = InstanceNew("TextLabel")
        Title.Parent = Notification
        Title.BackgroundTransparency = 1
        Title.Text = data.Title or "Notification"
        Title.TextColor3 = self.Theme.Text
        Title.FontFace = self.Font
        Title.TextSize = 14
        Title.Size = UDim2New(1, 0, 0, 20)
        Title.TextXAlignment = Enum.TextXAlignment.Left

        local Description = InstanceNew("TextLabel")
        Description.Parent = Notification
        Description.BackgroundTransparency = 1
        Description.Text = data.Description or ""
        Description.TextColor3 = self.Theme.TextDim
        Description.FontFace = self.Font
        Description.TextSize = 13
        Description.Size = UDim2New(1, 0, 0, 20)
        Description.TextXAlignment = Enum.TextXAlignment.Left
        Description.TextWrapped = true
        Description.AutomaticSize = Enum.AutomaticSize.Y

        local Progress = InstanceNew("Frame")
        Progress.Parent = Notification
        Progress.BackgroundColor3 = self.Theme.Accent
        Progress.BorderSizePixel = 0
        Progress.Size = UDim2New(0, 0, 0, 2)
        Progress.Position = UDim2New(0, 0, 1, -2)

        local ProgressCorner = InstanceNew("UICorner")
        ProgressCorner.Parent = Progress
        ProgressCorner.CornerRadius = UDimNew(1, 0)

        
        Notification.Position = UDim2New(1, 0, 0, 0)
        Notification:TweenPosition(UDim2New(0, 0, 0, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.3, true)

        
        local duration = data.Duration or 3
        Progress:TweenSize(UDim2New(1, 0, 0, 2), Enum.EasingDirection.Out, Enum.EasingStyle.Linear, duration, true)

        
        task.wait(duration)
        if Notification.Parent then
            Notification:TweenPosition(UDim2New(1, 0, 0, 0), Enum.EasingDirection.In, Enum.EasingStyle.Quad, 0.3, true)
            task.wait(0.3)
            Notification:Destroy()
        end
    end
          
    function Library:Unload()
        for _, conn in pairs(self.Connections) do
            pcall(function() conn.Connection:Disconnect() end)
        end

        if self.Holder then
            self.Holder:Destroy()
        end

        if self.UnusedHolder then
            self.UnusedHolder:Destroy()
        end

        for _, obj in pairs(self.ToClean) do
            pcall(function() obj:Destroy() end)
        end

        Library = nil
        getgenv().Library = nil
    end

    return Library
end

getgenv().Library = Library
return Library

