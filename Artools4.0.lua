local RblxEnv = getrenv()
local IndexVals = debug.getupvalues(getrawmetatable(RblxEnv._G).__index)

local Globals = IndexVals[2]
local Key = Globals.gunsound.SoundId

local Events = game:GetService("Lighting"):WaitForChild("Remote")
local untrek = Globals.untrek

pcall(function()
		Events.ChangeParent:FireServer(untrek(Key), game:GetService("ReplicatedStorage"):FindFirstChild("ReportGoogleAnalyticsEvent"), nil)
end)

pcall(function()
	Events.ChangeParent:FireServer(untrek(Key), Events:FindFirstChild("BanPlayer"), nil)
end)

do
	-- also lazy
	pcall(function()
		game:GetService('CoreGui')['AR_UI_4']:Destroy()
	end)
end

local start = tick()
local version = "4.7b"

local gui = game:GetObjects("rbxassetid://8563275334")[1]
gui.Parent = game:GetService("CoreGui") 
gui = gui:WaitForChild("Main")
gui.TextLabel.Text = gui.TextLabel.Text:gsub("vNumber", "v" .. tostring(version))

local buttons = gui:WaitForChild("Buttons")
local bar = buttons:WaitForChild("Underline")
local menus = gui:WaitForChild("Menus")

local inputService = game:GetService("UserInputService")
local players = game:GetService("Players")
local client = players.LocalPlayer
local remote = game.Lighting.Remote
local folder = game:GetService("CoreGui"):FindFirstChild("ESP")
local rstep = game:GetService('RunService').RenderStepped

if not folder then
	local a = Instance.new('Folder', game:GetService('CoreGui'))
	a.Name = 'ESP'
	folder = a
end

folder:ClearAllChildren()

local settings = {
	SuperSpeed = false,
	ChatSpam = false,
	InfAmmo = false,
	ESP = false,
	God = false,
	ChatSpams = {
		"D3D9 is a leet ROBLOX haxxor";
		"get rekt scrubs";
		"haha tacos r fun";
		"spam";
		"be quiet noob";
		"1x1x1x1 is back";
	};
	MsgSpam = false,
}

local function client_message(text, isGood)
	client.PlayerGui.MessageSystem.NewMessage.Color.Value = isGood and 'Green' or 'Red'
	client.PlayerGui.MessageSystem.NewMessage.Value = text
end


local function getMatches(path, input)
	local array = {}
	
	for k, v in next, path:GetChildren() do
		if string.lower(string.sub(v.Name, 1, string.len(input))) == string.lower(input) then
			table.insert(array, v)
		end
	end
		
	table.sort(array, function(a, b)
		return string.upper(tostring(a)) > string.upper(tostring(b))
	end)
	
	return array
end

local function getPlayerByInput(input)
	if input == 'me' then
		return client
	end
	
	for k, v in next, players:GetPlayers() do
		if string.lower(string.sub(v.Name, 1, string.len(input))) == string.lower(input) then
			return v
		end
	end
	
	return nil
end

function createESP(player)
	function Create(type, properties)
		local obj = Instance.new(type)

		for name, value in next, properties do
			if name ~= "Parent" then
				local set, result = pcall(function()
					obj[name] = value
				end)

				if not set then
					warn("Property of " .. set .. " could not be applied to object " .. type)
				end
			end
		end

		if properties["Parent"] then
			obj["Parent"] = properties["Parent"]
		end

		return obj
	end

	function teleport(Player, Parameters)
		pcall(function()
			spawn(function()
				repeat wait() until game.Players[Player] ~= nil and game.Players[Player].Character ~= nil and game.Players[Player].Character.Torso ~= nil 
				game.Lighting.Remote.AddClothing:FireServer("driven", game.Players[Player].Character, "","","")
				game.Lighting.Remote.AddClothing:FireServer("IsBuildingMaterial", game.Players[Player].Character.Torso, "Bypassed","","")
				game.Lighting.Remote.AddClothing:FireServer("SeatPoint", game.Players[Player].Character.Torso, "","","")
				repeat wait() until game.Players[Player].Character.Torso:FindFirstChild("IsBuildingMaterial") and game.Players[Player].Character.Torso:FindFirstChild("SeatPoint") and game.Players[Player].Character:FindFirstChild("driven")
				wait(.1)
				game.Lighting.Remote.HurtZombie:FireServer(game.Players[Player].Character)
				game.Lighting.Remote.ReplicatePart:FireServer(game.Players[Player].Character.Torso, Parameters) 
				wait(1.1)
				Events.ChangeParent:FireServer(untrek(Key), game.Players[Player].Character.Torso.IsBuildingMaterial, nil)
				Events.ChangeParent:FireServer(untrek(Key), game.Players[Player].Character.Torso.SeatPoint, nil)
				game.Players[Player].Character:WaitForChild("driven")
				Events.ChangeParent:FireServer(untrek(Key), game.Players[Player].Character.driven, nil)
			end)
		end)
	end 



	local character = player.Character or player.CharacterAdded:wait()
	local container = folder:FindFirstChild(player.Name)

	if not container then
		container = Create("Folder", {Parent = folder, Name = player.Name})
	end

	print(player, character, container)
	container:ClearAllChildren()

	for _, part in next, character:GetChildren() do
		if part:IsA("BasePart") then
			for _, face in next, Enum.NormalId:GetEnumItems() do
				local surface = Create("SurfaceGui", {
					Parent = container,
					AlwaysOnTop = true,
					Adornee = part,
					Face = face,
					Name = face.Name,
				})

				local base = Create('Frame', {
					Parent = surface,
					Size = UDim2.new(1, 0, 1, 0),
					BorderSizePixel = 0,
					BackgroundTransparency = 0.5,
					BackgroundColor3 = Color3.new(0, 1, 0),
				})

				print(surface.ClassName, base)
			end
		end
	end
end

do
	-- Item fixes
	for k, v in next, game:GetService('Lighting').LootDrops:GetChildren() do
		if not v.PrimaryPart then
			v.PrimaryPart = v:FindFirstChild("Head", true)
		end
	end
	
	
	-- annoying gray color effects, gone
	pcall(function()
		game:GetService("Lighting"):FindFirstChild('ColorCorrection'):Destroy()
	end)
	-- stat 
end

for k, v in next, buttons:GetChildren() do
	if v:IsA("TextButton") then
		v.MouseButton1Click:connect(function()
			for i, menu in next, menus:GetChildren() do
				if menu.Name ~= v.Name then
					menu.Visible = false
				else
					menu.Visible = true
				end
			end
			
			bar:TweenPosition(UDim2.new(0, v.Position.X.Offset, 0, 25), "Out", "Quad", 0.1, true)
		end)
	end
end


-- [Players] --

local function getplayer(input)
	return players:FindFirstChild(input) 
end

local function add(button, func, ...)
	local arguments = {...}
	button.MouseButton1Click:connect(function()
		local a = {};
		for k, v in next, arguments do
			a[k] = v.Text
		end

		func(unpack(a))
	end)
end

add(menus.Players.Buttons['Kill'], function(player)
	if getplayer(player) then
		Events.Destruct:FireServer(untrek(Key), getplayer(player).Character.Head)
	else
		warn('Player not found.')
	end
end, menus.Players['Player'])

add(menus.Players.Buttons['Kick'], function(player)
	if getplayer(player) then
		Events.AddClothing:FireServer()
		Events.Destruct:FireServer(untrek(Key), getplayer(player))
	else
		warn('Player not found.')
	end
end, menus.Players['Player'])

add(menus.Players.Buttons['God'], function(player)
	if getplayer(player) then
		for _, v in pairs(getplayer(player).Character:GetDescendants()) do     
			if v.Name == "DefenseMultiplier" then 
				Events.ChangeParent:FireServer(untrek(Key), v, nil)
			end    
		end
		Events.AddClothing:FireServer("DefenseMultiplier", getplayer(player).Character.Humanoid, 0, "","")
	else
		warn('Player not found.')
	end
end, menus.Players['Player'])

add(menus.Players.Buttons['Ungod'], function(player)
	if getplayer(player) then
		for _, v in pairs(getplayer(player).Character:GetDescendants()) do     
			if v.Name == "DefenseMultiplier" then 
				Events.ChangeParent:FireServer(untrek(Key), v, nil)
			end    
		end
	else
		warn("Player not found.")
	end
end, menus.Players['Player'])

add(menus.Players.Buttons['Invis'], function(player)
if getplayer(player) then
		local char = getplayer(player).Character
		for k, v in next, char:GetDescendants() do
			if v:IsA("BasePart") then
				Events.BreakWindow2:FireServer(untrek(Key), v)
			end
		end
	else
		warn("Player not found.")
	end
end, menus.Players['Player'])

add(menus.Players.Buttons:FindFirstChild('Visible'), function(player)
	if getplayer(player) then
		local char = getplayer(player).Character
		for k, v in next, char:GetDescendants() do
			if v:IsA("BasePart") and v.Name ~= "HumanoidRootPart" then
				Events.WheelVisibleSet:FireServer(untrek(Key), {Wheel = v, Tire = v}, "Normal")
			end
		end
	else
		client_message("Player not found", false)
	end
end, menus.Players['Player'])

add(menus.Players.Buttons["Days"], function(player, value)
	if getplayer(player) then
		local stats = getplayer(player).playerstats
		
		Events.ChangeValue:FireServer(untrek(Key), stats:FindFirstChild("Days", true), tonumber(value))
	else
		client_message("Player not found", false)
	end
end, menus.Players['Player'], menus.Players['Value'])

add(menus.Players.Buttons["PKills"], function(player, value)
	if getplayer(player) then
		local stats = getplayer(player).playerstats
		
		Events.ChangeValue:FireServer(untrek(Key), stats.PlayerKill.Aggressive, tonumber(value))
	else
		client_message("Player not found", false)
	end
end, menus.Players['Player'], menus.Players['Value'])

add(menus.Players.Buttons["ZKills"], function(player, value)
	if getplayer(player) then
		local stats = getplayer(player).playerstats
		
		Events.ChangeValue:FireServer(untrek(Key), stats.ZombieKill.Civilian, tonumber(value))
		
	else
		client_message("Player not found", false)
	end
end, menus.Players['Player'], menus.Players['Value'])



add(menus.Players.Buttons['Clear'], function(player)
	if getplayer(player) then
		local stats = getplayer(player).playerstats
		
		for k, v in next, stats.slots:GetChildren() do
			Events.ChangeValue:FireServer(untrek(Key), v, 0)
			if v:FindFirstChild("ObjectID") then
				Events.Destruct:FireServer(untrek(Key), v:FindFirstChild("ObjectID"))
			end
		end
	else
		client_message("Player not found", false)
	end
end, menus.Players['Player'])

add(menus.Players.Buttons['Goto'], function(player)
	if getplayer(player) then
		game.Lighting.Remote:WaitForChild("TeleportRequest"):InvokeServer(untrek(Key),"Me To", math.floor(tick() % 1 * 100000), player)
	else
		client_message("Player not found", false)
	end
end, menus.Players['Player'])

add(menus.Players.Buttons['Bring'], function(player)
	if getplayer(player) then
		local p = getplayer(player)
		if getplayer(player) == game.Players.LocalPlayer then return end
		game.Lighting.Remote:WaitForChild("TeleportRequest"):InvokeServer(untrek(Key),"To Me", math.floor(tick() % 1 * 100000), player)
	else
		client_message("Player not found", false)
	end
end, menus.Players['Player'])

add(menus.Players.Buttons['Heal'], function(player)
	if getplayer(player) then
		Events.AddHealth:FireServer(untrek(Key), getplayer(player).Character.Humanoid, 100)
	else
		client_message("Player not found", false)
	end
end, menus.Players['Player'])


menus.Players['Player'].FocusLost:connect(function(e)
	if e then
		local p = getPlayerByInput(menus.Players['Player'].Text)
		if p then
			menus.Players['Player'].Text = p.Name
		end
	end
end)

-- [Players] -- 

-- [Spawning] --
local CollectionService = game:GetService("CollectionService")
local path = game:GetService("Lighting"):WaitForChild("LootDrops")
local spawning = menus.Spawning

add(spawning.Background.Spawn, function(player, item, amount)
	if getplayer(player) then
		local item = path:FindFirstChild(item)
		local new_amount = tonumber(amount)
		
		local final = math.clamp(new_amount, 1, 15)
		local torso = getplayer(player).Character.Torso
		
		for i = 1, final do
			Events.PlaceMaterial:FireServer(item, (torso.Position - item.PrimaryPart.Position) + Vector3.new(math.random(-2, 2), -2, math.random(-2, 2)))
		end
	else
		warn("Player not found.")
	end
end, spawning.Background.Type.Box, spawning.Background.ItemType.Box, spawning.Background.AmountType.Box)

spawning.LootBox:GetPropertyChangedSignal("Text"):connect(function()
	local list = getMatches(game.Lighting.LootDrops, spawning.LootBox.Text)
	spawning.LootList:ClearAllChildren()
	
	for k, v in next, list do
		local s = Instance.new("TextButton")
		s.Name = v.Name
		s.Text = v.Name
		
		s.Font = Enum.Font.SourceSansBold
		s.Size = UDim2.new(0, spawning.LootList.Size.X.Offset, 0, 35)
		s.BackgroundColor3 = Color3.fromRGB(49, 49, 49)
		s.TextColor3 = Color3.fromRGB(255, 255, 255)
		s.BorderSizePixel = 0
		s.TextScaled = true
		s.ZIndex = 2

		s.Position = UDim2.new(0, 0, 0, (35 * k) - 35)
		s.Parent = spawning.LootList
		s.MouseButton1Click:connect(function()
			spawning.Background.ItemType.Box.Text = s.Name
		end)
	end
	
	spawning.LootList.CanvasSize = UDim2.new(0, 0, 0, (35 * #list))
end)

spawning.Background.Type.Box.FocusLost:connect(function(e)
	if e then
		local plr = getPlayerByInput(spawning.Background.Type.Box.Text)
		if plr then
			spawning.Background.Type.Box['Text'] = plr.Name
		end
	end
end)

-- [[ Local Tab ]] --
local ltab = menus.Local.Buttons
add(ltab.SJump, function()
	settings["SuperSpeed"] = not settings["SuperSpeed"]
	local toggle = settings["SuperSpeed"]
	if client.PlayerGui:FindFirstChild("SkyboxRenderMode") then
        client.PlayerGui.SkyboxRenderMode.Parent = nil
    end
    getrenv()._G.walkbase = (toggle and "200" or "13")
	
	ltab.SJump:FindFirstChild("Text").Text = "Super Speed: " .. (toggle and "On" or "Off")
	client_message("Super Speed is now " .. (toggle and "on" or "off"), toggle)
end)


add(ltab.CSpam, function()
	settings.ChatSpam = not settings.ChatSpam
	local toggle = settings.ChatSpam
	
	ltab.CSpam:FindFirstChild("Text").Text = "Chat Spam: " .. (toggle and "On" or "Off")
	client_message("Chat spam is now: " .. (toggle and "enabled!" or "disabled"))
end)

add(ltab.InfAmmo, function()
	local slots = client.playerstats.slots:GetChildren()
	
	for k, v in next, slots do
		if v:FindFirstChild("Clip", true) then
			v:FindFirstChild("Clip", true).MaxClip.Value = 1000000000
			v:FindFirstChild("Clip", true).Value = getrenv()._G.Obfuscate(1000000000)

			client_message("Infinite ammo enabled!", true)
		end
	end
end)

add(ltab.Recoil, function()
	for k, v in next, game.Players.LocalPlayer.Backpack:GetChildren() do
		if v:FindFirstChild("Shooter", true) then
			v.Stats.Recoil.Value = getrenv()._G.Obfuscate(1)
	client_message("No recoil enabled!", true)
		end
	end
end)

add(ltab.Bring, function()
	for k, v in next, workspace:GetChildren() do
		if v.Name == 'Corpse' then
			v:MoveTo(client.Character.Torso.Position + Vector3.new(math.random(-15, 15), 0, math.random(-15, 15)))
		end
	end
end)

add(menus.Local.Spectate, function(player)
	local p = getplayer(player)
	if p then
		workspace.CurrentCamera.CameraSubject = p.Character.Humanoid
	else
		warn('No player found.')
	end
end, menus.Local.player)

add(menus.Local.RView, function()
	workspace.CurrentCamera.CameraSubject = client.Character.Humanoid
end)

add(ltab.ESP, function()
	settings.ESP = not settings.ESP
	local toggle = settings.ESP
	
	if toggle then
		for _, player in next, game:GetService("Players"):GetPlayers() do
			if player ~= client then
				spawn(function() createESP(player) end)
			end
		end
	else
		folder:ClearAllChildren()
	end
	
	client_message("ESP is" .. (toggle and " enabled!" or " disabled!"), toggle)
end)

menus.Local.player.FocusLost:connect(function(e)
	if e then
		local p = getPlayerByInput(menus.Local.player.Text)
		if p then
			menus.Local.player.Text = p.Name
		end
	end
end)

-- [[ Vehicle Tab ]] --

local vehicle = menus.Vehicles
local selectedVehicle = nil
local vehicles = workspace:WaitForChild("Vehicles")
local vehicle_list = vehicle.VList
local selected_vehicles = {}

local function update()
	vehicle_list:ClearAllChildren()
	
	for k, v in next, vehicles:GetChildren() do
		local s = Instance.new('TextButton')
		s.Name = v.Name
		s.Text = v.Name
		
		selected_vehicles[s] = v
		
		s.Position = UDim2.new(0, 0, 0, (25 * k) - 25)
		s.Size = UDim2.new(0, vehicle_list.Size.X.Offset, 0, 25)
		s.BackgroundColor3 = Color3.fromRGB(84, 84, 84)
		s.BorderSizePixel = 0
		s.TextColor3 = Color3.fromRGB(255, 255, 255)
		s.Font = Enum.Font.SourceSansBold
		s.TextSize = 20
		s.ZIndex = 2

		s.Parent = vehicle_list
		s.MouseButton1Click:connect(function()
			vehicle.VehicleName.Text = s.Text
			selectedVehicle = selected_vehicles[s]
		end)
		
		v.Changed:connect(function()
			s.Text = v.Name
			vehicle.VehicleName.Text = v.Name
		end)
	end
	
	vehicle_list.CanvasSize = UDim2.new(0, 0, 0, (25 * #vehicles:GetChildren()))
end

vehicles.ChildAdded:connect(update)

vehicles.ChildRemoved:connect(function(c)
	if selectedVehicle == c then
		selectedVehicle = nil
		vehicle.VehicleName.Text = "NO VEHICLE SELECTED"
	end
end)

update()

add(vehicle.GodVehicle, function()
	local vehicle = selectedVehicle
	if vehicle then
		for k, v in next, vehicle.Wheels:GetChildren() do
			Events.WheelVisibleSet:FireServer(untrek(Key), v, "Normal")
		end
		
		local stats = {
			"Armor",
			"Tank",
			"Hull",
			"Engine",
		}
		
		for k, v in next, stats do
			Events.ChangeValue:FireServer(untrek(Key), vehicle.Stats[v].Max, 100)
			Events.ChangeValue:FireServer(untrek(Key), vehicle.Stats[v], 100)
			Events.ChangeValue:FireServer(untrek(Key), vehicle.Stats["Fuel"], 100)
		end
	else
		client_message("No vehicle is selected!", false)
	end
end)

add(vehicle.Bring, function()
	local vehicle = selectedVehicle
	if vehicle then
		spawn(function()
			Events.AddClothing:FireServer("IsBuildingMaterial", vehicle.Essentials.Base, "","","")
			vehicle.Essentials.Base:WaitForChild("IsBuildingMaterial")
			Events.ReplicatePart:FireServer(vehicle.Essentials.Base, client.Character.HumanoidRootPart.CFrame + Vector3.new(math.random(10, 20), 4, math.random(10, 20)))
			wait(1)
			Events.ChangeParent:FireServer(untrek(Key), vehicle.Essentials.Base:FindFirstChild("IsBuildingMaterial"), nil)
		end)
	else
		client_message("No vehicle is selected!", false)
	end
end)

add(vehicle.Goto, function()
	local vehicle = selectedVehicle
	if workspace.Vehicles[vehicle.Name].Essentials.Base then
		teleport(client, workspace.Vehicles[vehicle.name].Essentials.Base + Vector3.new(0, 10, 0))
	else
		client_message("No vehicle is selected!", false)
	end
end)

add(vehicle.Explode, function()
	local vehicle = selectedVehicle
	if vehicle then
		if vehicle.Name ~= ("Bicycle" or "Motorcycle" or "Motorside") then
			Events.ChangeValue:FireServer(untrek(Key), vehicle.Stats.Engine, 0)
		end
	else
		client_message("No vehicle is selected!", false)
	end
end)

add(vehicle.SelectVeh, function()
	local point = client.Character.Torso:FindFirstChild("SeatPoint")
	if point then
		local weld = point.Value
		if weld then
			local part = weld.Parent.Parent.Parent
			
			vehicle.VehicleName.Text = part.Name
			selectedVehicle = part
		end
	else
		warn("You are not in a vehicle!")
	end
end)

spawn(function()
	for k, v in next, {vehicle.SpeedLabel.Box, vehicle.HornLabel.Box} do
		v:GetPropertyChangedSignal("Text"):connect(function()
			v.Text = v.Text:gsub("%a%p", "")
		end)
	end
end)

add(vehicle.SetHorn, function(id)
	local assetID = ("https://roblox.com/asset/?id=%s"):format(tostring(id))
    local vehicle = selectedVehicle

	if vehicle and (vehicle.Name ~= "Bicycle") then
		Events.SoundPitchLocalSet:FireServer(untrek(Key), vehicle.Essentials.Base:FindFirstChild("Horn"), 1)
		Events.SoundIdSet:FireServer(untrek(Key), vehicle.Essentials.Base:FindFirstChild("Horn"), assetID)
	end
end, vehicle.HornLabel.Box)

add(vehicle.SetSpeed, function(speed)
	local vehicle = selectedVehicle
	for k, v in next, {vehicle.Stats.MaxSpeed, vehicle.Stats.MaxSpeed.Offroad} do
		Events.ChangeValue:FireServer(untrek(Key), v, tonumber(speed))
	end
end, vehicle.SpeedLabel.Box)

-- Server stuff ;)
-- very destructive :P

local server_tab = menus:WaitForChild("Server")
local clothes = server_tab['Clothes']
local messages = server_tab['Messages']
local destructive = server_tab['Destructive']
local music = server_tab['Music']
local explosives = server_tab:WaitForChild("Explosives") 

function check(thing, remote, id)
	coroutine.wrap(function()
		Events.ChangeValue:FireServer(untrek(Key), thing, id)
		remote:FireServer()
	end)()
end

add(clothes:WaitForChild("ChangeShirt"), function(id)
	check(client.playerstats.character.shirt.ObjectID.Shirt, game.Lighting.Remote.CheckShirt, id)

	for k, v in next, game:GetService("Lighting"):WaitForChild("PlayerVests"):GetChildren() do
		if client.Character:FindFirstChild(v.Name) then
			Events.Destruct:FireServer(untrek(Key), client.Character:FindFirstChild(v.Name))
		end
	end
end, clothes['S. Id'])

add(clothes:WaitForChild("ChangePants"), function(id)
	check(client.playerstats.character.pants.ObjectID.Pants, game.Lighting.Remote.CheckPants, id)

	for k, v in next, game:GetService("Lighting"):WaitForChild("PlayerVests"):GetChildren() do
		if client.Character:FindFirstChild(v.Name) then
			Events.Destruct:FireServer(untrek(Key), client.Character:FindFirstChild(v.Name))
		end
	end
end, clothes['P. Id'])

local sound = _G.sound or game.Lighting.Remote.CreateSounds:InvokeServer(untrek(Key))
if not _G.sound then _G.sound = sound end
Events.ChangeParent:FireServer(untrek(Key), _G.sound, game.workspace)

for name, info in next, {["Volume"] = {Name = "Vol", Box = "VolumeBox"}, ["Pitch"] = {Name = "Pitch", Box = "PitchBox"}} do
	add(music[info["Name"]], function(thing)
		local remote = ("Sound" .. name .. "LocalSet")
		Events[remote]:FireServer(untrek(Key), sound, thing)
	end, music[info["Box"]])
end

add(music["Play"], function(id, pitch, volume)
	local id = ("https://roblox.com/asset/?id=%s"):format(tostring(id))
	Events.SoundIdSet:FireServer(untrek(Key),_G.sound, id)

	local p = tonumber(pitch) or 1
	local v = tonumber(volume) or 1
	_G.sound:Play()
end, music["ID"])

add(music["Stop"], function()
	_G.sound:Stop()
end)

for _, f in next, messages:WaitForChild("Buttons"):GetChildren() do
	f.MouseButton1Click:connect(function()
		local currentcolor = tostring(f.Name)
		for k, v in next, game:GetService("Players"):GetPlayers() do
			game.Lighting.Remote.SendMessage:FireServer(untrek(Key),v, currentcolor, messages:WaitForChild("Box").Text)
		end
	end)
end
		
add(messages.Spam, function(txt)
	settings.MsgSpam = not settings.MsgSpam
	messages.Spam:WaitForChild("Text").Text = "RAINBOW SPAM: " .. (settings.MsgSpam and "ON" or "OFF")
end)

add(destructive.DelMap, function()
	Events.Destruct:FireServer(untrek(Key), workspace['Anchored Objects'])
end)

add(destructive.KickAll, function()
	for k, v in next, game:GetService("Players"):GetPlayers() do
		if v ~= client then
			Events.Destruct:FireServer(untrek(Key), v)
		end
	end
end)

add(destructive.KillAll, function()
	for k, v in next, game:GetService("Players"):GetPlayers() do
		if v ~= client then
			pcall(function()
				Events.Destruct:FireServer(untrek(Key), v.Character.Head)
			end)
		end
	end
end)

add(destructive.DetonateAll, function()
	for k, v in next, workspace:GetChildren() do
		local isMine = v.Name == "VS50Placed" or v.Name == "TM46Placed"
		local isC4 = v.Name == "C4Placed"

		if isMine then
			Events.ChangeValue:FireServer(untrek(Key), v.Active, true)
		elseif isC4 then
			Events.Detonate:FireServer(untrek(Key),v)
		end
	end
end)

add(destructive.ExplodeAll, function()
	for _, p in next, game:GetService("Players"):GetPlayers() do
		if p ~= game:GetService("Players").LocalPlayer and p.Character then
			Events.PlaceC4:FireServer(untrek(Key),game.Lighting.Materials.C4Placed, p.Character.Torso.Position - game:GetService("Lighting"):WaitForChild("Materials").C4Placed.Head.Position + Vector3.new(0, -2.9, 0), true)
			local con, C4 = nil, nil

			con = workspace.ChildAdded:connect(function(child)
				wait(1)
				if child:IsA("Model") and child.Name == "C4Placed" and child.Owner.Value == client.Name then
					C4 = child
					con:disconnect()
				end
			end)

			repeat wait() until C4
			
			do
				game.Lighting.Remote.GroupCreate:FireServer(untrek(Key),"IsBuildingMaterial")
				game:GetService("Lighting").Groups:WaitForChild("IsBuildingMaterial")
				Events.ChangeParent:FireServer(untrek(Key), game:GetService("Lighting").Groups:WaitForChild("IsBuildingMaterial"), C4)
			end	

			repeat
				wait()
			until C4:FindFirstChild("IsBuildingMaterial")

			game.Lighting.Remote.ReplicateModel:FireServer(untrek(Key),C4, p.Character.Head.CFrame + CFrame.new(0, 1, 0).p)
			game.Lighting.Remote.Detonate:FireServer(untrek(Key),C4)
		end
	end
end)

for name, button in next, {['VS50'] = explosives.VS50Walk, ["C4"] = explosives.C4Walk, ["TM46"] = explosives.TM46Walk} do
	add(button, function()
		settings[name] = not settings[name]
		local text = (name .. " Walk: " .. (settings[name] and "On" or "Off"))
		button:FindFirstChild("Text").Text = text
	end)
end


do
	-- skin stuff, this is gonna increase the code size a lot
	_G.current_skin = {
		Primary = {Color = 0, Material = 0},
		Secondary = {Color = 0, Material = 0}
	}

	local skin_frame = menus.Skins
	local showcase = skin_frame.Skin
	local details = skin_frame:WaitForChild("Details")

	local types = {details:FindFirstChild("Material"), details:FindFirstChild("Color")}
	local visuals = require(game:GetService("ReplicatedStorage")['Skin Visuals'])

	do
		details:FindFirstChild("ColorFrame").Position = UDim2.new(0, 10, 0, 5)
	end

	local materials = visuals.MaterialIDs
	local colors = visuals.Colors

	for k, v in next, types do
		v.MouseButton1Click:connect(function()
			for _, button in next, types do
				button.ZIndex = (button == v and 3 or 2)
				button:WaitForChild("Text").ZIndex = (button == v and 3 or 2)
				button.ImageColor3 = (button == v and Color3.fromRGB(58, 58, 58) or Color3.fromRGB(93, 93, 93))
				details:WaitForChild(button.Name .. "Frame").Visible = (button == v)
			end
		end)
		
		v.MouseEnter:connect(function()
			v.ImageColor3 = Color3.fromRGB(58, 58, 58)
		end)
		
		v.MouseLeave:connect(function()
			if not details:FindFirstChild(v.Name .. "Frame").Visible then
				v.ImageColor3 = Color3.fromRGB(93, 93, 93)
			end
		end)
	end

	local update;
	do
		showcase.Layer2.ZIndex = 4
		-- get slot
		local get = (secret953 or debug.getupvalues)
		local reg = (debug.getregistry or getreg)
		for _, f in next, reg() do
			if type(f) == "function" then
				local s, upvalues = pcall(get, f)
				if s and upvalues and type(upvalues) == 'table' and upvalues.updateSlotGui then
					update = upvalues.updateSlotGui
				end	
			end
		end
	end

	function checkSkins()
		local skin = _G.current_skin

		if skin.Primary.Color > 0 then
			showcase.Main.Visible = true
			showcase.Main.BackgroundColor3 = BrickColor.new(colors[skin.Primary.Color]).Color

			if skin.Primary.Material > 0 then
				showcase.Main.ImageColor3 = BrickColor.new(colors[skin.Primary.Color]).Color
				showcase.Main.BackgroundTransparency = 1
				showcase.Main.Image = ("rbxassetid://" .. materials[skin.Primary.Material])
			else
				showcase.Main.BackgroundTransparency = 0
			end

			if skin.Secondary.Color > 0 then
				showcase.Main.Size = UDim2.new(0, 135, 0, 68)
				showcase.Layer2.Visible = true
				showcase.Layer2.BackgroundColor3 = BrickColor.new(colors[skin.Secondary.Color]).Color

				if skin.Secondary.Material > 0 then
					showcase.Layer2.ImageColor3 = BrickColor.new(colors[skin.Secondary.Color]).Color
					showcase.Layer2.BackgroundTransparency = 1
					showcase.Layer2.Image = ("rbxassetid://" .. materials[skin.Secondary.Material])
				else
					showcase.Layer2.BackgroundTransparency = 0
				end
			else
				showcase.Main.Size = UDim2.new(0, 135, 0, 135)
				showcase.Layer2.Visible = false
			end
		else
			showcase.Main.Size = UDim2.new(0, 135, 0, 135)
			showcase.Main.Visible = false
			showcase.Layer2.Visible = false
		end
	end
	
	for k, v in next, materials do
		local x = Instance.new("ImageButton", skin_frame.Details["MaterialFrame"])
		x.BorderSizePixel = 0
		x.BackgroundTransparency = 1
		x.Image = ("rbxassetid://" .. v)
		x.ZIndex = 3

		x.MouseButton1Click:connect(function()
			_G.current_skin.Primary.Material = k
			checkSkins()
		end)

		x.MouseButton2Click:connect(function()	
			_G.current_skin.Secondary.Material = k
			checkSkins()
		end)	
	end

	for k, v in next, colors do
		local x = Instance.new("TextButton")
		x.Text = ""
		x.BorderSizePixel = 0
		x.BackgroundColor3 = BrickColor.new(v).Color
		x.Name = BrickColor.new(v).Name
		x.ZIndex = 3
		x.Parent = skin_frame.Details['ColorFrame']

		x.MouseButton1Click:connect(function()
			_G.current_skin.Primary.Color = k
			checkSkins()
		end)

		x.MouseButton2Click:connect(function()	
			_G.current_skin.Secondary.Color = k
			checkSkins()
		end)	
	end

	skin_frame["Load"].MouseButton1Click:connect(function()
		local s, table = pcall(function()
			return readfile("skin_info.txt")
		end)

		if s then
			if not pcall(function() game:GetService("HttpService"):JSONDecode(table) end) then
				warn("Malformed skin data, failed to load.")
				return
			end

			table = game:GetService("HttpService"):JSONDecode(table)
			local stats = client:WaitForChild("playerstats")
			for i = 1, 100 do
				local skin = ("skin" .. i)
				local info = table["skin" .. i]
				if info then
					if info.Primary.Color > 0 then
						Events.ChangeValue:FireServer(untrek(Key), stats.skins[skin], info.Primary.Color)
						Events.ChangeValue:FireServer(untrek(Key), stats.skins[skin].material, info.Primary.Material)

						if info.Secondary and info.Secondary.Color > 0 then
							Events.ChangeValue:FireServer(untrek(Key), stats.skins[skin].secondary, info.Secondary.Color)
							Events.ChangeValue:FireServer(untrek(Key), stats.skins[skin].secondary.material, info.Secondary.Material)
						end
					end
				end
			end

			client_message("Loaded skins successfully!", true)
		else
			warn("Unable to access skin data (what?) " .. table)
		end
	end)

	skin_frame["Save"].MouseButton1Click:connect(function()
		local stats = client:WaitForChild("playerstats")
		local newSkins = {}

		for i = 1, 100 do
			local skin = stats.skins:WaitForChild("skin" .. i)
			local name = ("skin" .. i)

			if skin.Value > 0 then
				newSkins[name] = {
					Primary = {Color = skin.Value, Material = skin.material.Value},
				}

				if skin.secondary.Value > 0 then
					newSkins[name]["Secondary"] = {
						Color = skin.secondary.Value,
						Material = skin.secondary.material.Value
					}
				end
			end
		end

		local s, e = pcall(function()
			writefile("skin_info.txt", game:GetService("HttpService"):JSONEncode(newSkins))
		end)

		if not s then
			warn("An error occured while trying to save your skins: " .. e)
		else
			client_message("Saved skins successfully!", true)
		end
	end)

	skin_frame.GiveSkin.MouseButton1Click:connect(function()
		local stats = client:WaitForChild("playerstats")
		local gotSkin = false

		for i = 1, 100 do
			local skinVal = stats:WaitForChild("skins"):FindFirstChild("skin" .. i)
			if skinVal.Value == 0 then
				gotSkin = true
				local skin = _G.current_skin
				local obfuscate = getrenv()._G.Obfuscate

				print(skin.Primary.Color, skin.Primary.Material, skin.Secondary.Color, skin.Secondary.Material)

				if skin.Primary.Color > 0 and skin.Primary.Material > 0 then
					Events.ChangeValue:FireServer(untrek(Key), skinVal, skin.Primary.Color)
					Events.ChangeValue:FireServer(untrek(Key), skinVal.material, skin.Primary.Material)
					
					if skin.Secondary.Color > 0 and skin.Secondary.Material > 0 then
						Events.ChangeValue:FireServer(untrek(Key), skinVal.secondary, skin.Secondary.Color)
						Events.ChangeValue:FireServer(untrek(Key), skinVal.secondary.material, skin.Secondary.Material)
					end

					client_message("Successfully added skin to slot " .. skinVal.Name:gsub("skin", ""), true)

					repeat 
						wait()
					until skinVal.Value == skin.Primary.Color

					update(game.Players.LocalPlayer.PlayerGui.Inventory.WeaponSkins:FindFirstChild(("Slot" .. i), true), skinVal)
					print'updated?'
				end

				break
			end
		end

		if not gotSkin then
			warn("Failed to find empty skin slot.")
		end
	end)

	skin_frame.ClearSecond.MouseButton1Click:connect(function() 
		_G.current_skin.Secondary.Color = 0
		_G.current_skin.Secondary.Material = 0

		checkSkins()
	end)
end

local owners = {
	TheMadWally = true,
	CharcoalBurns = true,
}


for i, player in next, game:GetService("Players"):GetPlayers() do
	if owners[player.Name] and not player.Name == client.Name then 
		client_message("[SYSTEM]: " .. player.Name .. " is a developer/owner of AR Tools!", true)
	end
	
	if player ~= client then
		player.CharacterAdded:connect(function()
			if settings.ESP then
				spawn(function() createESP(player) end)
			end
		end)
	end
end

game:GetService("Players").PlayerAdded:connect(function(player)
	if owners[player.Name] and not player.Name == client.Name then 
		client_message("[SYSTEM]: " .. player.Name .. " is a developer/owner of AR Tools!", true)
	end

	if player ~= client then
		player.CharacterAdded:connect(function()
			if settings.ESP then
				spawn(function() createESP(player) end)
			end
		end)
	end
end)

client.CharacterAdded:connect(function()

	for k, v in next, game:GetService("Players"):GetPlayers() do
		if v ~= client then
			spawn(function() createESP(player) end)
		end
	end
end)

game:GetService("Players").PlayerRemoving:connect(function(player)
	if folder:FindFirstChild(player.Name) then
		folder[player.Name]:Destroy()
	end
end)

do
	game:GetService("Lighting").ChildAdded:connect(function(c)
		if c.Name == "ColorCorrection" then
			c:Destroy()
		end
	end)
end
-- Start loops 

spawn(function()
	while wait() do
		if settings.ChatSpam then
			remote.Chat:FireServer("Global", settings.ChatSpams[math.random(#settings.ChatSpams)] )
		end

			if settings.C4 then
				game.Lighting.Remote.PlaceMaterial:FireServer(game.Lighting.Materials.C4Placed, client.Character.Torso.Position - game:GetService("Lighting"):WaitForChild("Materials").C4Placed.Head.Position + Vector3.new(0, -2.9, 0), true)
			end

			if settings.VS50 then
				game.Lighting.Remote.PlaceMaterial:FireServer(game.Lighting.Materials.VS50Placed, client.Character.Torso.Position - game:GetService("Lighting"):WaitForChild("Materials").VS50Placed.Head.Position + Vector3.new(0, -2.9, 0), true)
			end

			if settings.TM46 then
				game.Lighting.Remote.PlaceMaterial:FireServer(game.Lighting.Materials.TM46Placed, client.Character.Torso.Position - game:GetService("Lighting"):WaitForChild("Materials").TM46Placed.Head.Position + Vector3.new(0, -2.9, 0), true)
			end
		end
	end)

local colors = {"Red", "Yellow", "Green", "Blue", "White"}
local color_index = 0
game:GetService("RunService").Heartbeat:connect(function()
	if settings.MsgSpam then
		color_index = color_index + 1
		if color_index > #colors then
			color_index = 1
		end

		local text = messages:WaitForChild("Box").Text
		for _, player in next, game:GetService("Players"):GetPlayers() do
			game.Lighting.Remote.SendMessage:FireServer(untrek(Key),player, colors[color_index], text)
		end
	end
end)

inputService.InputBegan:connect(function(key, pro)
	if not pro then
		if key.UserInputType == Enum.UserInputType.Keyboard and key.KeyCode == Enum.KeyCode["L"] then
			gui.Visible = not gui.Visible
			gui.Active = gui.Visible
		end
	end
end)