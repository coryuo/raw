-- NexusLib – 100 % blur-free for Delta mobile
-- loadstring(game:HttpGet("https://raw.githubusercontent.com/coryuo/raw/refs/heads/main/roblox.luau"))():Window({Name="Test"}):Show()

local NexusLib = {}
local ts = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local tween = function(obj,info,props)
    ts:Create(obj,TweenInfo.new(info.t or .35,Enum.EasingStyle[info.s or "Quint"],Enum.EasingDirection.Out),props):Play()
end
local colors = {
    bg = Color3.fromRGB(20,20,20),
    glass = Color3.fromRGB(255,255,255),
    accent = Color3.fromRGB(0,150,255)
}

-- Core container
local gui = Instance.new("ScreenGui")
gui.Name = "NexusLib"
gui.IgnoreGuiInset = true
gui.ResetOnSpawn = false
gui.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")

-- NO BLUR
local blur = nil

-- Pre-built glass panel
local function makeGlass(name,parent,size,pos)
    local f = Instance.new("Frame")
    f.Name = name
    f.Size = size or UDim2.new(0,400,0,300)
    f.Position = pos or UDim2.new(.5,-200,.5,-150)
    f.AnchorPoint = Vector2.new(.5,.5)
    f.BackgroundColor3 = colors.bg
    f.BackgroundTransparency = .25
    f.BorderSizePixel = 0
    f.ClipsDescendants = true
    f.Visible = false
    f.Parent = parent

    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0,12)
    c.Parent = f

    local g = Instance.new("Frame")
    g.Name = "Glass"
    g.Size = UDim2.new(1,0,1,0)
    g.BackgroundColor3 = colors.glass
    g.BackgroundTransparency = .9
    g.BorderSizePixel = 0
    g.Parent = f

    local cg = Instance.new("UICorner")
    cg.CornerRadius = UDim.new(0,12)
    cg.Parent = g

    local stroke = Instance.new("UIStroke")
    stroke.Color = colors.accent
    stroke.Thickness = 2
    stroke.Transparency = .7
    stroke.Parent = f
    return f
end

-- Main window
function NexusLib:Window(cfg)
    cfg = cfg or {}
    local title = cfg.Name or "NexusLib"
    local default = cfg.Default or false

    local main = makeGlass(title,gui,UDim2.new(0,500,0,350),UDim2.new(.5,-250,.5,-175))
    main.Visible = default

    local top = Instance.new("Frame")
    top.Size = UDim2.new(1,0,0,40)
    top.BackgroundTransparency = 1
    top.Parent = main

    local t = Instance.new("TextLabel")
    t.Text = title
    t.Size = UDim2.new(1,-50,1,0)
    t.Position = UDim2.new(0,10,0,0)
    t.BackgroundTransparency = 1
    t.TextColor3 = Color3.new(1,1,1)
    t.Font = Enum.Font.Gotham
    t.TextSize = 16
    t.Parent = top

    local close = Instance.new("ImageButton")
    close.Image = "rbxassetid://11163831585"
    close.Size = UDim2.new(0,24,0,24)
    close.Position = UDim2.new(1,-30,0,8)
    close.BackgroundTransparency = 1
    close.ImageColor3 = colors.accent
    close.Parent = top
    close.MouseButton1Click:Connect(function()
        tween(main,{t=.3,s="Back"},{BackgroundTransparency=1,Size=UDim2.new(0,0,0,0)})
        wait(.35)
        main.Visible = false
    end)

    local tabs = Instance.new("Frame")
    tabs.Name = "Tabs"
    tabs.Size = UDim2.new(0,140,1,-40)
    tabs.Position = UDim2.new(0,0,0,40)
    tabs.BackgroundTransparency = 1
    tabs.Parent = main

    local tabList = Instance.new("UIListLayout")
    tabList.Padding = UDim.new(0,5)
    tabList.Parent = tabs

    local pages = Instance.new("Frame")
    pages.Name = "Pages"
    pages.Size = UDim2.new(1,-150,1,-45)
    pages.Position = UDim2.new(0,145,0,40)
    pages.BackgroundTransparency = 1
    pages.Parent = main

    local pageList = Instance.new("UIPageLayout")
    pageList.FillDirection = Enum.FillDirection.Vertical
    pageList.SortOrder = Enum.SortOrder.LayoutOrder
    pageList.Parent = pages

    -- Drag logic
    local dragging, dragInput, startPos, startGuiPos
    main.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.Touch or inp.UserInputType == Enum.UserInputType.MouseButton1 then
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

    local api = {}
    function api:Tab(name)
        local btn = Instance.new("TextButton")
        btn.Text = name
        btn.Size = UDim2.new(1,0,0,30)
        btn.BackgroundColor3 = colors.bg
        btn.BorderSizePixel = 0
        btn.Font = Enum.Font.Gotham
        btn.TextColor3 = Color3.new(1,1,1)
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
        page.ScrollBarThickness = 3
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
                b.Size = UDim2.new(1,-10,0,30)
                b.BackgroundColor3 = colors.bg
                b.BorderSizePixel = 0
                b.Font = Enum.Font.Gotham
                b.TextColor3 = Color3.new(1,1,1)
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
                b.Size = UDim2.new(1,-10,0,30)
                b.BackgroundColor3 = colors.bg
                b.BorderSizePixel = 0
                b.Font = Enum.Font.Gotham
                b.TextColor3 = Color3.new(1,1,1)
                b.TextSize = 14
                b.Parent = page

                local c = Instance.new("UICorner")
                c.CornerRadius = UDim.new(0,6)
                c.Parent = b

                local stroke = Instance.new("UIStroke")
                stroke.Color = val and colors.accent or Color3.new(.5,.5,.5)
                stroke.Transparency = .8
                stroke.Parent = b

                b.MouseButton1Click:Connect(function()
                    val = not val
                    b.Text = text .. ": " .. tostring(val)
                    tween(stroke,{t=.2},{Color = val and colors.accent or Color3.new(.5,.5,.5)})
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
        tween(main,{t=.45,s="Back"},{Size=UDim2.new(0,500,0,350),BackgroundTransparency=.25})
    end

    function api:Hide()
        tween(main,{t=.3,s="Back"},{BackgroundTransparency=1,Size=UDim2.new(0,0,0,0)})
        wait(.35)
        main.Visible = false
    end
    return api
end

return NexusLib
