-- NexusLib 2 – glassmorphic, resizable, draggable, smooth-animated
-- loadstring(game:HttpGet("https://raw.githubusercontent.com/coryuo/raw/refs/heads/main/roblox.luau"))():Window({Name="NexusLib 2"}):Show()

local NexusLib = {}
local ts = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local tween = function(obj,info,props)
    ts:Create(obj,TweenInfo.new(info.t or .35,Enum.EasingStyle[info.s or "Quint"],Enum.EasingDirection.Out),props):Play()
end
local colors = {
    bg = Color3.fromRGB(18,18,18),
    glass = Color3.fromRGB(255,255,255),
    accent = Color3.fromRGB(0,150,255),
    text = Color3.fromRGB(230,230,230)
}

-- Core container
local gui = Instance.new("ScreenGui")
gui.Name = "NexusLib2"
gui.IgnoreGuiInset = true
gui.ResetOnSpawn = false
gui.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")

-- Utilities
local clamp = math.clamp
local minSize = Vector2.new(260,200)
local maxSize = Vector2.new(800,600)

-- Glass frame maker
local function makeGlass(name,parent,size,pos)
    local f = Instance.new("Frame")
    f.Name = name
    f.Size = size
    f.Position = pos
    f.AnchorPoint = Vector2.new(.5,.5)
    f.BackgroundColor3 = colors.bg
    f.BackgroundTransparency = .2
    f.BorderSizePixel = 0
    f.ClipsDescendants = true
    f.Visible = false
    f.Parent = parent

    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0,12)
    c.Parent = f

    local glass = Instance.new("Frame")
    glass.Name = "Glass"
    glass.Size = UDim2.new(1,0,1,0)
    glass.BackgroundColor3 = colors.glass
    glass.BackgroundTransparency = .92
    glass.BorderSizePixel = 0
    glass.Parent = f
    glass.ZIndex = 1

    local cg = Instance.new("UICorner")
    cg.CornerRadius = UDim.new(0,12)
    cg.Parent = glass

    local stroke = Instance.new("UIStroke")
    stroke.Color = colors.accent
    stroke.Thickness = 2
    stroke.Transparency = .6
    stroke.Parent = f

    return f
end

-- Main window
function NexusLib:Window(cfg)
    cfg = cfg or {}
    local title = cfg.Name or "NexusLib 2"
    local default = cfg.Default or false

    local main = makeGlass(title,gui,UDim2.new(0,520,0,380),UDim2.new(.5,-260,.5,-190))
    main.Visible = default
    main.Active = true
    main.Selectable = true

    -- Title bar
    local top = Instance.new("Frame")
    top.Name = "Top"
    top.Size = UDim2.new(1,0,0,38)
    top.BackgroundTransparency = 1
    top.Parent = main
    top.ZIndex = 10

    local titleTxt = Instance.new("TextLabel")
    titleTxt.Text = title
    titleTxt.Size = UDim2.new(1,-100,1,0)
    titleTxt.Position = UDim2.new(0,12,0,0)
    titleTxt.BackgroundTransparency = 1
    titleTxt.TextColor3 = colors.text
    titleTxt.Font = Enum.Font.Gotham
    titleTxt.TextSize = 16
    titleTxt.Parent = top
    titleTxt.ZIndex = 11

    -- Control buttons container
    local controls = Instance.new("Frame")
    controls.Size = UDim2.new(0,90,1,0)
    controls.Position = UDim2.new(1,-95,0,0)
    controls.BackgroundTransparency = 1
    controls.Parent = top
    controls.ZIndex = 11

    local btnList = Instance.new("UIListLayout")
    btnList.FillDirection = Enum.FillDirection.Horizontal
    btnList.Padding = UDim.new(0,6)
    btnList.Parent = controls

    local function makeBtn(iconId,tip)
        local btn = Instance.new("ImageButton")
        btn.Image = iconId
        btn.Size = UDim2.new(0,22,0,22)
        btn.BackgroundTransparency = 1
        btn.ImageColor3 = Color3.new(1,1,1)
        btn.ScaleType = Enum.ScaleType.Fit
        btn.AutoButtonColor = false
        btn.Parent = controls
        btn.ZIndex = 12
        btn.MouseEnter:Connect(function() tween(btn,{t=.2},{ImageColor3=colors.accent}) end)
        btn.MouseLeave:Connect(function() tween(btn,{t=.2},{ImageColor3=Color3.new(1,1,1)}) end)
        return btn
    end

    -- Minimize / Maximize / Close
    local minimizeBtn = makeBtn("rbxassetid://3926305904","Minimize")
    local maximizeBtn = makeBtn("rbxassetid://3926307971","Maximize")
    local closeBtn     = makeBtn("rbxassetid://3926305904","Close")

    closeBtn.ImageRectOffset = Vector2.new(284,4)
    closeBtn.ImageRectSize   = Vector2.new(24,24)

    minimizeBtn.ImageRectOffset = Vector2.new(884,284)
    minimizeBtn.ImageRectSize   = Vector2.new(36,36)

    maximizeBtn.ImageRectOffset = Vector2.new(804,444)
    maximizeBtn.ImageRectSize   = Vector2.new(36,36)

    -- Resize handles (8 small invisible grips)
    local handles = {}
    local gripSize = 6
    for _,side in ipairs({"Top","Bottom","Left","Right","TopLeft","TopRight","BottomLeft","BottomRight"}) do
        local h = Instance.new("Frame")
        h.Name = side
        h.BackgroundTransparency = 1
        h.Parent = main
        h.ZIndex = 20
        handles[side] = h
    end
    -- layout handles
    handles.Top.Size    = UDim2.new(1,-gripSize*2,0,gripSize)
    handles.Top.Position= UDim2.new(0,gripSize,0,-gripSize/2)

    handles.Bottom.Size = UDim2.new(1,-gripSize*2,0,gripSize)
    handles.Bottom.Position= UDim2.new(0,gripSize,1,-gripSize/2)

    handles.Left.Size   = UDim2.new(0,gripSize,1,-gripSize*2)
    handles.Left.Position= UDim2.new(0,-gripSize/2,0,gripSize)

    handles.Right.Size  = UDim2.new(0,gripSize,1,-gripSize*2)
    handles.Right.Position= UDim2.new(1,-gripSize/2,0,gripSize)

    handles.TopLeft.Size    = UDim2.new(0,gripSize,0,gripSize)
    handles.TopLeft.Position= UDim2.new(0,-gripSize/2,0,-gripSize/2)

    handles.TopRight.Size   = UDim2.new(0,gripSize,0,gripSize)
    handles.TopRight.Position= UDim2.new(1,-gripSize/2,0,-gripSize/2)

    handles.BottomLeft.Size = UDim2.new(0,gripSize,0,gripSize)
    handles.BottomLeft.Position= UDim2.new(0,-gripSize/2,1,-gripSize/2)

    handles.BottomRight.Size= UDim2.new(0,gripSize,0,gripSize)
    handles.BottomRight.Position= UDim2.new(1,-gripSize/2,1,-gripSize/2)

    -- Resize logic
    local resizing, sideData
    local function startResize(side)
        resizing = true
        sideData = side
    end
    for name,h in pairs(handles) do
        h.InputBegan:Connect(function(inp)
            if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
                startResize(name)
            end
        end)
    end
    UIS.InputEnded:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
            resizing = false
        end
    end)
    UIS.InputChanged:Connect(function(inp)
        if resizing and (inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch) then
            local delta = inp.Delta
            local abs = main.AbsoluteSize
            local newX, newY = abs.X, abs.Y
            -- horizontal
            if sideData:find("Left") then
                newX = clamp(abs.X - delta.X, minSize.X, maxSize.X)
            elseif sideData:find("Right") then
                newX = clamp(abs.X + delta.X, minSize.X, maxSize.X)
            end
            -- vertical
            if sideData:find("Top") then
                newY = clamp(abs.Y - delta.Y, minSize.Y, maxSize.Y)
            elseif sideData:find("Bottom") then
                newY = clamp(abs.Y + delta.Y, minSize.Y, maxSize.Y)
            end
            tween(main,{t=.1},{Size = UDim2.new(0,newX,0,newY)})
        end
    end)

    -- Min / Max / Close actions
    local isMinimized = false
    minimizeBtn.MouseButton1Click:Connect(function()
        if isMinimized then
            tween(main,{t=.3},{Size=UDim2.new(0,520,0,380)})
            isMinimized = false
        else
            tween(main,{t=.3},{Size=UDim2.new(0,520,0,38)})
            isMinimized = true
        end
    end)

    maximizeBtn.MouseButton1Click:Connect(function()
        tween(main,{t=.3},{Size=UDim2.new(0,maxSize.X,0,maxSize.Y)})
    end)

    closeBtn.MouseButton1Click:Connect(function()
        tween(main,{t=.3,s="Back"},{BackgroundTransparency=1,Size=UDim2.new(0,0,0,0)})
        wait(.35)
        main.Visible = false
    end)

    -- Tabs & pages
    local tabs = Instance.new("Frame")
    tabs.Name = "Tabs"
    tabs.Size = UDim2.new(0,140,1,-38)
    tabs.Position = UDim2.new(0,0,0,38)
    tabs.BackgroundTransparency = 1
    tabs.Parent = main

    local tabList = Instance.new("UIListLayout")
    tabList.Padding = UDim.new(0,5)
    tabList.Parent = tabs

    local pages = Instance.new("Frame")
    pages.Name = "Pages"
    pages.Size = UDim2.new(1,-150,1,-38)
    pages.Position = UDim2.new(0,145,0,38)
    pages.BackgroundTransparency = 1
    pages.Parent = main

    local pageList = Instance.new("UIPageLayout")
    pageList.FillDirection = Enum.FillDirection.Vertical
    pageList.SortOrder = Enum.SortOrder.LayoutOrder
    pageList.Parent = pages

    -- Drag logic (title bar)
    local dragging, dragInput, startPos, startGuiPos
    top.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            startPos = inp.Position
            startGuiPos = main.Position
            inp.Changed:Connect(function()
                if inp.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    UIS.InputChanged:Connect(function(inp)
        if dragging and (inp == dragInput or inp.UserInputType == Enum.UserInputType.Touch) then
            local delta = inp.Position - startPos
            main.Position = UDim2.new(startGuiPos.X.Scale, startGuiPos.X.Offset + delta.X,
                                      startGuiPos.Y.Scale, startGuiPos.Y.Offset + delta.Y)
        end
    end)

    -- API
    local api = {}
    function api:Tab(name)
        local btn = Instance.new("TextButton")
        btn.Text = name
        btn.Size = UDim2.new(1,0,0,30)
        btn.BackgroundColor3 = colors.bg
        btn.BorderSizePixel = 0
        btn.Font = Enum.Font.Gotham
        btn.TextColor3 = colors.text
        btn.TextSize = 14
        btn.Parent = tabs
        local c = Instance.new("UICorner")
        c.CornerRadius = UDim.new(0,8)
        c.Parent = btn
        local stroke = Instance.new("UIStroke")
        stroke.Color = colors.accent
        stroke.Transparency = 1
        stroke.Parent = btn

        local page = Instance.new("ScrollingFrame")
        page.Size = UDim2.new(1,0,1,0)
        page.BackgroundTransparency = 1
        page.ScrollBarThickness = 4
        page.ScrollBarImageColor3 = colors.accent
        page.Visible = false
        page.Parent = pages
        pageList:AddLayout(page)
        local list = Instance.new("UIListLayout")
        list.Padding = UDim.new(0,6)
        list.Parent = page

        btn.MouseButton1Click:Connect(function()
            pageList:JumpTo(page)
            for _,v in pairs(tabs:GetChildren()) do if v:IsA("TextButton") then tween(v.stroke,{t=.2},{Transparency=1}) end end
            tween(stroke,{t=.2},{Transparency=0})
        end)

        local sec = {}
        function sec:Section(name)
            local lbl = Instance.new("TextLabel")
            lbl.Text = name
            lbl.Size = UDim2.new(1,0,0,25)
            lbl.BackgroundTransparency = 1
            lbl.Font = Enum.Font.GothamSemibold
            lbl.TextColor3 = colors.accent
            lbl.TextSize = 16
            lbl.Parent = page
            local grp = {}
            function grp:Button(text,callback)
                local b = Instance.new("TextButton")
                b.Text = text
                b.Size = UDim2.new(1,-10,0,32)
                b.BackgroundColor3 = colors.bg
                b.BorderSizePixel = 0
                b.Font = Enum.Font.Gotham
                b.TextColor3 = colors.text
                b.TextSize = 14
                b.Parent = page
                local c = Instance.new("UICorner")
                c.CornerRadius = UDim.new(0,6)
                c.Parent = b
                local stroke = Instance.new("UIStroke")
                stroke.Color = colors.accent
                stroke.Transparency = .8
                stroke.Parent = b
                b.MouseEnter:Connect(function() tween(stroke,{t=.2},{Transparency=.2}) end)
                b.MouseLeave:Connect(function() tween(stroke,{t=.2},{Transparency=.8}) end)
                b.MouseButton1Click:Connect(callback)
            end
            function grp:Toggle(text,default,callback)
                default = default or false
                local val = default
                local b = Instance.new("TextButton")
                b.Text = text .. ": " .. tostring(val)
                b.Size = UDim2.new(1,-10,0,32)
                b.BackgroundColor3 = colors.bg
                b.BorderSizePixel = 0
                b.Font = Enum.Font.Gotham
                b.TextColor3 = colors.text
                b.TextSize = 14
                b.Parent = page
                local c = Instance.new("UICorner")
                c.CornerRadius = UDim.new(0,6)
                c.Parent = b
                local stroke = Instance.new("UIStroke")
                stroke.Color = val and colors.accent or Color3.new(.4,.4,.4)
                stroke.Transparency = .8
                stroke.Parent = b
                b.MouseButton1Click:Connect(function()
                    val = not val
                    b.Text = text .. ": " .. tostring(val)
                    tween(stroke,{t=.2},{Color = val and colors.accent or Color3.new(.4,.4,.4)})
                    callback(val)
                end)
            end
            return grp
        end
        return sec
    end

    function api:Show()
        main.Visible = true
        main.Size = UDim2.new(0,0,0,0)
        main.BackgroundTransparency = 1
        tween(main,{t=.45,s="Back"},{Size=UDim2.new(0,520,0,380),BackgroundTransparency=.25})
    end

    function api:Hide()
        tween(main,{t=.3,s="Back"},{BackgroundTransparency=1,Size=UDim2.new(0,0,0,0)})
        wait(.35)
        main.Visible = false
    end
    return api
end

return NexusLib
