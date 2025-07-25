-- NexusLib 3 – glowing resizable, smart toggle, 60 FPS
local NexusLib = {}
local ts = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local tween = function(obj,i,p) ts:Create(obj,TweenInfo.new(i.t or .3,Enum.EasingStyle.Quint),p):Play() end
local colors = {bg = Color3.fromRGB(18,18,18), accent = Color3.fromRGB(0,150,255), edge = colors.accent}
local gui = Instance.new("ScreenGui"); gui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
local std = Vector2.new(520,380); local minS,maxS = Vector2.new(260,200),Vector2.new(800,600)

local function makeGlass(n,s,p)
    local f = Instance.new("Frame"); f.Name=n; f.Size=s; f.Position=p; f.AnchorPoint=Vector2.new(.5,.5)
    f.BackgroundColor3=colors.bg; f.BackgroundTransparency=.2; f.ClipsDescendants=true; f.Visible=false
    f.Parent=gui; local c=Instance.new("UICorner"); c.CornerRadius=UDim.new(0,12); c.Parent=f
    local stroke=Instance.new("UIStroke"); stroke.Color=colors.accent; stroke.Thickness=2; stroke.Parent=f
    return f
end

function NexusLib:Window(cfg)
    cfg = cfg or {}
    local main = makeGlass(cfg.Name or "NexusLib 3",UDim2.new(0,std.X,0,std.Y),UDim2.new(.5,-std.X/2,.5,-std.Y/2))
    main.Visible = cfg.Default or false

    -- Title & controls
    local top = Instance.new("Frame"); top.Size=UDim2.new(1,0,0,38); top.BackgroundTransparency=1; top.Parent=main
    local title=Instance.new("TextLabel"); title.Text=cfg.Name or "NexusLib 3"; title.Size=UDim2.new(1,-100,1,0)
    title.Position=UDim2.new(0,12,0,0); title.BackgroundTransparency=1; title.Font=Enum.Font.Gotham
    title.TextSize=16; title.TextColor3=Color3.new(1,1,1); title.Parent=top

    local function makeBtn(icon,tip)
        local b=Instance.new("ImageButton"); b.Image=icon; b.Size=UDim2.new(0,22,0,22); b.BackgroundTransparency=1
        b.ScaleType=Enum.ScaleType.Fit; b.Parent=top; b.Position=UDim2.new(1,-30-(tip*28),0,8)
        b.MouseEnter:Connect(function() b.ImageColor3=colors.accent end)
        b.MouseLeave:Connect(function() b.ImageColor3=Color3.new(1,1,1) end)
        return b
    end
    local minBtn = makeBtn("rbxassetid://3926305904",0)
    local maxBtn = makeBtn("rbxassetid://3926307971",1)
    local closeBtn = makeBtn("rbxassetid://3926305904",2)

    -- Resize edges (glow)
    local grips={}
    for _,side in ipairs{"Top","Bottom","Left","Right","TopLeft","TopRight","BottomLeft","BottomRight"}do
        local g=Instance.new("Frame"); g.Name=side; g.Parent=main; g.BackgroundColor3=colors.edge
        g.BackgroundTransparency=.7; g.BorderSizePixel=0; g.ZIndex=25
        grips[side]=g
    end
    local gs=6
    grips.Top.Size=UDim2.new(1,-gs*2,0,gs); grips.Top.Position=UDim2.new(0,gs,0,0)
    grips.Bottom.Size=UDim2.new(1,-gs*2,0,gs); grips.Bottom.Position=UDim2.new(0,gs,1,-gs)
    grips.Left.Size=UDim2.new(0,gs,1,-gs*2); grips.Left.Position=UDim2.new(0,0,0,gs)
    grips.Right.Size=UDim2.new(0,gs,1,-gs*2); grips.Right.Position=UDim2.new(1,-gs,0,gs)
    grips.TopLeft.Size=UDim2.new(0,gs,0,gs); grips.TopLeft.Position=UDim2.new(0,0,0,0)
    grips.TopRight.Size=UDim2.new(0,gs,0,gs); grips.TopRight.Position=UDim2.new(1,-gs,0,0)
    grips.BottomLeft.Size=UDim2.new(0,gs,0,gs); grips.BottomLeft.Position=UDim2.new(0,0,1,-gs)
    grips.BottomRight.Size=UDim2.new(0,gs,0,gs); grips.BottomRight.Position=UDim2.new(1,-gs,1,-gs)

    -- Resize logic
    local resizing,sideData
    for _,g in pairs(grips)do
        g.InputBegan:Connect(function(inp)
            if inp.UserInputType==Enum.UserInputType.MouseButton1 or inp.UserInputType==Enum.UserInputType.Touch then
                resizing=true; sideData=g.Name
            end
        end)
    end
    UIS.InputEnded:Connect(function(inp)
        if inp.UserInputType==Enum.UserInputType.MouseButton1 or inp.UserInputType==Enum.UserInputType.Touch then resizing=false
    end end)
    UIS.InputChanged:Connect(function(inp)
        if resizing and(inp.UserInputType==Enum.UserInputType.MouseMovement or inp.UserInputType==Enum.UserInputType.Touch)then
            local delta=inp.Delta
            local abs=main.AbsoluteSize
            local newX,newY=abs.X,abs.Y
            if sideData:find("Left")then newX=math.clamp(abs.X-delta.X,minS.X,maxS.X)end
            if sideData:find("Right")then newX=math.clamp(abs.X+delta.X,minS.X,maxS.X)end
            if sideData:find("Top")then newY=math.clamp(abs.Y-delta.Y,minS.Y,maxS.Y)end
            if sideData:find("Bottom")then newY=math.clamp(abs.Y+delta.Y,minS.Y,maxS.Y)end
            tween(main,{t=.1},{Size=UDim2.new(0,newX,0,newY)})
        end
    end)

    -- Smart toggle (min / std / max)
    local state=0 -- 0 std, 1 min, 2 max
    minBtn.MouseButton1Click:Connect(function()
        state=(state+1)%3
        local sizes={[0]=UDim2.new(0,std.X,0,std.Y),[1]=UDim2.new(0,std.X,0,38),[2]=UDim2.new(0,maxS.X,0,maxS.Y)}
        tween(main,{t=.3,s="Back"},sizes)
    end)
    maxBtn.MouseButton1Click:Connect(function()
        tween(main,{t=.3,s="Back"},{Size=UDim2.new(0,maxS.X,0,maxS.Y)})
    end)
    closeBtn.MouseButton1Click:Connect(function()
        tween(main,{t=.3,s="Back"},{BackgroundTransparency=1,Size=UDim2.new(0,0,0,0)})
        wait(.35); main.Visible=false
    end)

    -- Drag title
    local drag,dragInput,startPos,startGuiPos
    top.InputBegan:Connect(function(inp)
        if inp.UserInputType==Enum.UserInputType.MouseButton1 or inp.UserInputType==Enum.UserInputType.Touch then
            drag=true; startPos=inp.Position; startGuiPos=main.Position
            inp.Changed:Connect(function()
                if inp.UserInputState==Enum.UserInputState.End then drag=false end
            end)
        end
    end)
    UIS.InputChanged:Connect(function(inp)
        if drag and(inp==dragInput or inp.UserInputType==Enum.UserInputType.Touch)then
            local delta=inp.Position-startPos
            main.Position=UDim2.new(startGuiPos.X.Scale,startGuiPos.X.Offset+delta.X,
                                    startGuiPos.Y.Scale,startGuiPos.Y.Offset+delta.Y)
        end
    end)

    -- API
    local api={}
    function api:Tab(name)
        local btn=Instance.new("TextButton"); btn.Text=name; btn.Size=UDim2.new(1,0,0,30)
        btn.BackgroundColor3=colors.bg; btn.BorderSizePixel=0; btn.Font=Enum.Font.Gotham
        btn.TextColor3=Color3.new(1,1,1); btn.TextSize=14; btn.Parent=main
        local c=Instance.new("UICorner"); c.CornerRadius=UDim.new(0,8); c.Parent=btn
        return {Section=function()end}
    end
    function api:Show()
        main.Visible=true; main.Size=UDim2.new(0,0,0,0); main.BackgroundTransparency=1
        tween(main,{t=.45,s="Back"},{Size=UDim2.new(0,std.X,0,std.Y),BackgroundTransparency=.25})
    end
    return api
end

return NexusLib
