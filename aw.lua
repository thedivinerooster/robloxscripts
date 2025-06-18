local Players=game:GetService('Players')local ReplicatedStorage=game:GetService(
'ReplicatedStorage')local LocalPlayer=Players.LocalPlayer local function
getHitbox()local char=LocalPlayer.Character if char then return char:
FindFirstChild('Hitbox')end end getgenv().punchHitbox=Vector3.new(1.5,1.5,2)
getgenv().punchHitboxVisible=false local function applyPunchHitboxVisuals()local
hitbox=getHitbox()if hitbox then if getgenv().punchHitboxVisible then hitbox.
Transparency=0 hitbox.Material=Enum.Material.ForceField hitbox.Color=Color3.
fromRGB(255,0,0)else hitbox.Transparency=1 hitbox.Material=Enum.Material.Plastic
hitbox.Color=Color3.fromRGB(163,162,165)end end end local function
togglePunchHitbox(bool)getgenv().punchHitboxVisible=bool
applyPunchHitboxVisuals()end local function setPunchHitbox(x,y,z)getgenv().
punchHitbox=Vector3.new(x,y,z)end task.spawn(function()while true do local
hitbox=getHitbox()if hitbox then hitbox.Size=getgenv().punchHitbox
applyPunchHitboxVisuals()end task.wait(0.05)end end)LocalPlayer.CharacterAdded:
Connect(function()repeat task.wait()until getHitbox()applyPunchHitboxVisuals()
end)task.spawn(function()while true do for _,player in ipairs(Players:
GetPlayers())do if player~=LocalPlayer and player.Character then local hrp=
player.Character:FindFirstChild('HumanoidRootPart')if hrp then local h=getgenv()
.playerHitbox pcall(function()hrp.Size=h.Size hrp.Transparency=h.Transparency
hrp.Color=h.Color hrp.Material=h.Material end)end end end task.wait(0.05)end end
)local function setPlayerHitboxes(sx,sy,sz)local defaultH={Size=Vector3.new(2,2,
1),Transparency=1,Color=Color3.fromRGB(163,162,165),Material=Enum.Material.
Plastic}if sx>0 and sy>0 and sz>0 then getgenv().playerHitbox.Size=Vector3.new(
sx,sy,sz)getgenv().playerHitbox.Transparency=0 getgenv().playerHitbox.Material=
Enum.Material.ForceField getgenv().playerHitbox.Color=Color3.fromRGB(0,0,255)
else getgenv().playerHitbox=defaultH end end getgenv().kAura={Speed=0,Enabled=
false}task.spawn(function()while true do if getgenv().kAura.Enabled and getgenv(
).kAura.Speed>0 then for _,player in ipairs(Players:GetPlayers())do if player~=
LocalPlayer and player.Character then local hrp=player.Character:FindFirstChild(
'HumanoidRootPart')if hrp then pcall(function()ReplicatedStorage:WaitForChild(
'Remote Events'):WaitForChild('Punch'):FireServer(314159265359,player.Character,
Vector3.new(0,0,0),1,hrp)end)end end end task.wait(1/getgenv().kAura.Speed)else
task.wait(0.001)end end end)local function setKillAuraSpeed(n)if n>0 then
getgenv().kAura.Speed=n getgenv().kAura.Enabled=true elseif n==0 then getgenv().
kAura.Speed=0 getgenv().kAura.Enabled=false end end local MacLib=loadstring(game
:HttpGet(
[[https://github.com/biggaboy212/Maclib/releases/latest/download/maclib.txt]]))(
)local Window=MacLib:Window({Title='Ability Wars Gui',Subtitle=
'By thedivinerooster',Size=UDim2.fromOffset(850,640),DragStyle=2,ShowUserInfo=
false,Keybind=Enum.KeyCode.K})local TabGroup=Window:TabGroup()local MainTab=
TabGroup:Tab({Name='Main'})local function nInput(section,name,placeholder,
callback)return section:Input({Name=name,Placeholder=placeholder,Callback=
callback})end local function notify(t,d)Window:Notify({Title=t,Description=d,
Lifetime=3})end local s1=MainTab:Section({Side='Left'})s1:Label({Text=
'Punch Hitbox'})nInput(s1,'X','1.5',function(x)setPunchHitbox(tonumber(x)or 1.5,
getgenv().punchHitbox.Y,getgenv().punchHitbox.Z)end):UpdateText('1.5')nInput(s1,
'Y','1.5',function(y)setPunchHitbox(getgenv().punchHitbox.X,tonumber(y)or 1.5,
getgenv().punchHitbox.Z)end):UpdateText('1.5')nInput(s1,'Z','2',function(z)
setPunchHitbox(getgenv().punchHitbox.X,getgenv().punchHitbox.Y,tonumber(z)or 2)
end):UpdateText('2')s1:Toggle({Name='Enable Punch Hitbox Visibility',Default=
false,Callback=togglePunchHitbox})local s2=MainTab:Section({Side='Right'})s2:
Label({Text='Player Hitboxes'})nInput(s2,'X','0',function(x)setPlayerHitboxes(
tonumber(x)or 0,getgenv().playerHitbox.Size.Y,getgenv().playerHitbox.Size.Z)end)
:UpdateText('0')nInput(s2,'Y','0',function(y)setPlayerHitboxes(getgenv().
playerHitbox.Size.X,tonumber(y)or 0,getgenv().playerHitbox.Size.Z)end):
UpdateText('0')nInput(s2,'Z','0',function(z)setPlayerHitboxes(getgenv().
playerHitbox.Size.X,getgenv().playerHitbox.Size.Y,tonumber(z)or 0)end):
UpdateText('0')local s3=MainTab:Section({Side='Left'})s3:Label({Text='Kill Aura'
})s3:Slider({Name='KillAura Speed',Default=0,Minimum=0,Maximum=100,DisplayMethod
='Value',Callback=setKillAuraSpeed})local s4=MainTab:Section({Side='Right'})s4:
Label({Text='Target Aura'})getgenv().targetPlayer={Name='',Enabled=false,
FacingDirection=Vector3.new(0,0,-1),Offset=3,OriginalPos=nil}local function
notify(t,d)Window:Notify({Title=t,Description=d,Lifetime=3})end local function
findTarget(name)name=name:lower()for _,player in ipairs(Players:GetPlayers())do
if player~=LocalPlayer then local uname=player.Name:lower()local dname=player.
DisplayName:lower()if uname:sub(1,#name)==name or dname:sub(1,#name)==name then
return player end end end return nil end local function setFacingDirection(x,y,z
)local vec=Vector3.new(tonumber(x)or 0,tonumber(y)or 0,tonumber(z)or-1)if vec.
Magnitude>0 then getgenv().targetPlayer.FacingDirection=vec end end
local function getFacingCFrame(targetCFrame,direction,dist)local offsetPos=
targetCFrame.Position+direction.Unit*dist return CFrame.lookAt(offsetPos,
targetCFrame.Position)end s4:Input({Name='Target Name',Placeholder=
'Username or DisplayName',Callback=function(name)getgenv().targetPlayer.Name=
name notify('Target Name Set',name)end})s4:Label({Text=
'Facing Direction (Vector3)'})s4:Input({Name='Facing X',Placeholder='0',Callback
=function(x)setFacingDirection(x,getgenv().targetPlayer.FacingDirection.Y,
getgenv().targetPlayer.FacingDirection.Z)end}):UpdateText('0')s4:Input({Name=
'Facing Y',Placeholder='0',Callback=function(y)setFacingDirection(getgenv().
targetPlayer.FacingDirection.X,y,getgenv().targetPlayer.FacingDirection.Z)end}):
UpdateText('0')s4:Input({Name='Facing Z',Placeholder='-1',Callback=function(z)
setFacingDirection(getgenv().targetPlayer.FacingDirection.X,getgenv().
targetPlayer.FacingDirection.Y,z)end}):UpdateText('-1')s4:Slider({Name=
'Offset Distance',Minimum=1,Maximum=20,Default=3,DisplayMethod='Value',Callback=
function(v)getgenv().targetPlayer.Offset=v end})s4:Button({Name=
'Start Target Aura',Callback=function()local lHRP=LocalPlayer.Character and
LocalPlayer.Character:FindFirstChild('HumanoidRootPart')if lHRP then getgenv().
targetPlayer.OriginalPos=lHRP.CFrame getgenv().targetPlayer.Enabled=true notify(
'Target Aura','Activated')else notify('Error','HumanoidRootPart not found')end
end})task.spawn(function()while true do local tp=getgenv().targetPlayer if tp.
Enabled and tp.Name~=''then local target=findTarget(tp.Name)if target and target
.Character then local tHRP=target.Character:FindFirstChild('HumanoidRootPart')
local humanoid=target.Character:FindFirstChildWhichIsA('Humanoid')local lHRP=
LocalPlayer.Character and LocalPlayer.Character:FindFirstChild(
'HumanoidRootPart')if tHRP and lHRP then if humanoid and humanoid.Health<=0 then
tp.Enabled=false if tp.OriginalPos then lHRP.CFrame=tp.OriginalPos end notify(
'Target Aura','Target died. Returning to original position.')continue end lHRP.
CFrame=getFacingCFrame(tHRP.CFrame,tp.FacingDirection,tp.Offset)pcall(function()
ReplicatedStorage:WaitForChild('Remote Events'):WaitForChild('Punch'):
FireServer(314159265359,target.Character,Vector3.new(0,0,0),1,tHRP)end)end end
task.wait(0.005)else task.wait(0.01)end end end)