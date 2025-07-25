-- NexusLib 4 – minimal self-contained demo
-- Paste this **entire block** into Delta **→ Execute**
-- One window, one tab, one button – no external files

local gui = Instance.new("ScreenGui")
gui.Name = "NexusTest"
gui.ResetOnSpawn = false
gui.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")

local main = Instance.new("Frame")
main.Name = "Main"
main.Size = UDim2.new(0,400,0,300)
main.Position = UDim2.new(.5,-200,.5,-150)
main.AnchorPoint = Vector2.new(.5,.5)
main.BackgroundColor3 = Color3.fromRGB(20,20,20)
main.BorderSizePixel = 0
main.ClipsDescendants = true
main.Visible = true
main.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0,12)
corner.Parent = main

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(0,150,255)
stroke.Thickness = 2
stroke.Parent = main

-- Title bar
local top = Instance.new("Frame")
top.Size = UDim2.new(1,0,0,35)
top.BackgroundTransparency = 1
top.Parent = main

local title = Instance.new("TextLabel")
title.Text = "NexusLib 4"
title.Size = UDim2.new(1,-40,1,0)
title.Position = UDim2.new(0,10,0,0)
title.BackgroundTransparency = 1
title.Font = Enum.Font.Gotham
title.TextSize = 16
title.TextColor3 = Color3.new(1,1,1)
title.Parent = top

local close = Instance.new("TextButton")
close.Text = "X"
close.Size = UDim2.new(0,25,0,25)
close.Position = UDim2.new(1,-30,0,5)
close.BackgroundTransparency = 1
close.Font = Enum.Font.Gotham
close.TextSize = 18
close.TextColor3 = Color3.new(1,1,1)
close.Parent = top
close.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

-- Simple tab
local tabBtn = Instance.new("TextButton")
tabBtn.Text = "Main"
tabBtn.Size = UDim2.new(1,0,0,30)
tabBtn.Position = UDim2.new(0,0,0,35)
tabBtn.BackgroundColor3 = Color3.fromRGB(30,30,30)
tabBtn.BorderSizePixel = 0
tabBtn.Font = Enum.Font.Gotham
tabBtn.TextSize = 14
tabBtn.TextColor3 = Color3.new(1,1,1)
tabBtn.Parent = main

local content = Instance.new("Frame")
content.Size = UDim2.new(1,0,1,-65)
content.Position = UDim2.new(0,0,0,65)
content.BackgroundTransparency = 1
content.Parent = main

local scroll = Instance.new("ScrollingFrame")
scroll.Size = UDim2.new(1,0,1,0)
scroll.BackgroundTransparency = 1
scroll.ScrollBarThickness = 4
scroll.ScrollBarImageColor3 = Color3.fromRGB(0,150,255)
scroll.Parent = content

local list = Instance.new("UIListLayout")
list.Padding = UDim.new(0,6)
list.Parent = scroll

-- Sample button
local btn = Instance.new("TextButton")
btn.Text = "Click me!"
btn.Size = UDim2.new(1,-20,0,30)
btn.BackgroundColor3 = Color3.fromRGB(30,30,30)
btn.Font = Enum.Font.Gotham
btn.TextSize = 14
btn.TextColor3 = Color3.new(1,1,1)
btn.Parent = scroll
btn.MouseButton1Click:Connect(function()
    print("Hello from NexusLib 4!")
    btn.Text = "Pressed ✔"
end)

-- Drag title bar
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
game:GetService("UserInputService").InputChanged:Connect(function(inp)
    if dragging and (inp == dragInput or inp.UserInputType == Enum.UserInputType.Touch) then
        local delta = inp.Position - startPos
        main.Position = UDim2.new(startGuiPos.X.Scale, startGuiPos.X.Offset + delta.X,
                                  startGuiPos.Y.Scale, startGuiPos.Y.Offset + delta.Y)
    end
end)
