local s_ = [[
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local hrp = LocalPlayer.Character:WaitForChild("HumanoidRootPart")
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local tycoons = workspace.Tycoons.Tycoons:GetChildren()
local function d(obj)
	local d,s,p;obj.InputBegan:Connect(function(i)if i.UserInputType.Name=="MouseButton1"then d=true s=i.Position p=obj.Position i.Changed:Connect(function()if i.UserInputState.Name=="End"then d=false end end)end end)obj.InputChanged:Connect(function(i)if i.UserInputType.Name=="MouseMovement"then i.Changed:Connect(function()if d then local o=i.Position-s obj.Position=UDim2.new(p.X.Scale,p.X.Offset+o.X,p.Y.Scale,p.Y.Offset+o.Y)end end)end end)return obj
end
local function c(x,y)
    local c=Instance.new("UICorner");c.CornerRadius=UDim.new(0,x);c.Parent=y
end
local function a(x,y)
    local a_=Instance.new("UIAspectRatioConstraint");a_.Parent=y;a_.AspectRatio=x 
end
local function pGoto(e)
    local oldPos = hrp.Position
    hrp.Position = e.Position
    task.wait(0.001)
    hrp.Position = oldPos
end
local function getPlayerPos()
    return hrp.Position
end
local function giveWeapon(x)
    for _,tycoon in ipairs(tycoons) do 
        local PurchasedObjects = tycoon:WaitForChild("PurchasedObjects")
        for _,obj in PurchasedObjects:GetChildren() do 
            if obj.Name:find("Giver") then
                local weapon = obj.WeaponName.Value
                if weapon == x then
                    pGoto(obj.Giver)
                end
            end
        end
    end
end
local function getHeldTool()
    local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    for _, child in ipairs(character:GetChildren()) do
        if child:IsA("Tool") then
            return child
        end
    end
    return nil
end
local function getWeapons() 
    local weapons = {}
    for _,tycoon in ipairs(tycoons) do 
        local PurchasedObjects = tycoon:WaitForChild("PurchasedObjects")
        for _,obj in PurchasedObjects:GetChildren() do 
            if obj.Name:find("Giver") then
                local weapon = obj.WeaponName.Value
                table.insert(weapons,weapon)
            end
        end
    end
    return weapons
end
local function setReach(n)
    local currentTool = getHeldTool()
    if currentTool and currentTool:FindFirstChild("Handle") then
        local handle = currentTool.Handle
        handle.Size = Vector3.new(n,n,n)
        handle.Material = Enum.Material.ForceField
        handle.Color = Color3.new(0, 0.615686, 1)
        handle.Massless = true
    end
end
local Icons = loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/Footagesus/Icons/main/Main.lua"))()
Icons.SetIconsType("lucide")
local closeIcon = Icons.Icon("x")
local function getTycoon()
    for _,tycoon in ipairs(tycoons) do
        if tycoon.Owner.Value == LocalPlayer then
            return tycoon
        end
    end
end
local currentTycoon = getTycoon()
local moneyGiver = currentTycoon.Essentials.Giver
local moneyGiverPos = moneyGiver.Position
function getMoney(oldPos)
    moneyGiver.CanCollide = false
    moneyGiver.Position = getPlayerPos()
    moneyGiver.Transparency = 1
    task.wait(0.01)
    moneyGiver.Position = oldPos
    moneyGiver.CanCollide = true
    moneyGiver.Transparency = 0
end

local container = Instance.new("ScreenGui",PlayerGui)
container.ResetOnSpawn = true
local frame = d(Instance.new("Frame",container))
frame.Size = UDim2.new(0.3,0,0.3,0)
frame.Position = UDim2.new(0.5,0,0.5,0)
frame.BackgroundColor3 = Color3.fromRGB(0,0,40)
a(1.5,frame)
c(4,frame)
local close = Instance.new("ImageButton",frame)
close.Image = closeIcon[1]
close.Position = UDim2.new(0.95,0,0,0)
close.Size = UDim2.fromOffset(20, 20)
close.BackgroundTransparency = 1
close.ImageRectSize = closeIcon[2].ImageRectSize
close.ImageRectOffset = closeIcon[2].ImageRectPosition
close.ImageColor3 = Color3.fromRGB(125,0,0)
close.MouseButton1Click:Connect(function() container:Destroy() end)

local titleLabel = Instance.new("TextLabel",frame)
titleLabel.Text = "God Tycoon Script"
titleLabel.TextSize = 21
titleLabel.Font = Enum.Font.GothamBlack
titleLabel.Position = UDim2.new(0.5,0,0.05,0)

getgenv().auto = false
task.spawn(function()
    while true do 
        if getgenv().auto == true then
            getMoney(moneyGiverPos)
        end
        task.wait(0.001)
    end
end)
local autoCollect = Instance.new('TextButton',frame)
autoCollect.Size = UDim2.new(0.38,0,0.14,0)
autoCollect.Text = "Enable Auto Collect"
autoCollect.BackgroundColor3 = Color3.fromRGB(40,0,40)
autoCollect.Font = Enum.Font.GothamBlack
autoCollect.TextSize = 13
autoCollect.Position = UDim2.new(0.31,0,0.15,0)
c(9,autoCollect)
autoCollect.MouseButton1Click:Connect(function()
    getgenv().auto = not getgenv().auto
    autoCollect.Text = getgenv().auto and "Disable Auto Collect" or "Enable Auto Collect"
end)

local weapons_ = Instance.new('TextButton',frame)
weapons_.Size = UDim2.new(0.38,0,0.14,0)
weapons_.Text = "Display Weapon List"
weapons_.BackgroundColor3 = Color3.fromRGB(40,0,40)
weapons_.Font = Enum.Font.GothamBlack
weapons_.TextSize = 13
weapons_.Position = UDim2.new(0.31,0,0.30,0)
c(9,weapons_)

local list=Instance.new("Frame",frame)
list.Active=false
list.Visible=false
list.Size=UDim2.new(1,0,1,0)
list.Position = UDim2.new(1,0,0,0)
c(6,list)
list.BackgroundColor3 = Color3.fromRGB(0,0,40)

local listTitle = Instance.new("TextLabel",list)
listTitle.Text = "Weapon List"
listTitle.TextSize = 21
listTitle.Font = Enum.Font.GothamBlack
listTitle.Position = UDim2.new(0.5,0,0.05,0)

local listText = Instance.new("TextLabel",list)
listText.Size = UDim2.new(1,0,1,0)
listText.TextWrapped=true
listText.Text = ""
listText.BackgroundTransparency=1
listText.Font=Enum.Font.GothamBlack
listText.TextSize=16

task.spawn(function()
	while true do 
		listText.Text = table.concat(getWeapons(),", ")
		task.wait(1)
	end
end)

weapons_.MouseButton1Click:Connect(function()
	list.Active = not list.Active
	list.Visible = not list.Visible
	weapons_.Text = list.Active and "Undisplay Weapon List" or "Display Weapon List"
end)

LocalPlayer.CharacterRemoving:Connect(function()
	getgenv().auto = false
	autoCollect.Text = "Enable Auto Collect"
	list.Active = false
	list.Visible = false
end)

local weaponInput = Instance.new('TextBox',frame)
weaponInput.Size = UDim2.new(0.38,0,0.14,0)
weaponInput.Text = ""
weaponInput.PlaceholderText = "Select Weapon"
weaponInput.BackgroundColor3 = Color3.fromRGB(40,0,40)
weaponInput.Font = Enum.Font.GothamBlack
weaponInput.TextSize = 13
weaponInput.Position = UDim2.new(0.31,0,0.45,0)
c(9,weaponInput)
weaponInput.FocusLost:Connect(function(enterPressed)
	if enterPressed then
		local input = weaponInput.Text
		giveWeapon(input)
	end
end)

local reachInput = Instance.new('TextBox',frame)
reachInput.Size = UDim2.new(0.38,0,0.14,0)
reachInput.Text = ""
reachInput.PlaceholderText = "Tool Reach Number"
reachInput.BackgroundColor3 = Color3.fromRGB(40,0,40)
reachInput.Font = Enum.Font.GothamBlack
reachInput.TextSize = 13
reachInput.Position = UDim2.new(0.31,0,0.60,0)
c(9,reachInput)
reachInput.FocusLost:Connect(function(enterPressed)
	if enterPressed then
		local input = tonumber(reachInput.Text)
		if input then setReach(input) end
	end
end)
]]
loadstring(s_)()
game:GetService("Players").LocalPlayer.CharacterAdded:Connect(function()
	task.wait(1)
	loadstring(s_)()
end)
