--[[
------------------
- made by Stadus -
-    StadusRP    -
-   client.lua   -
-  stadus.party  -
------------------

-   Fineedited by -
-      MLr        -
]]--
local Keys = {
  ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
  ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
  ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
  ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
  ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
  ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
  ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
  ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
  ["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

local IsInShopMenu = false
local Categories   = {}
local Vehicles     = {}
local LastVehicles = {}

ESX                = nil

--- Draw marker & action
Citizen.CreateThread(function()

	while true do
		Citizen.Wait(0)

		local playerPos = GetEntityCoords(PlayerPedId(), true)
		if Vdist(playerPos.x, playerPos.y, playerPos.z, Config.Zones.ShopOutside.Pos.x, Config.Zones.ShopOutside.Pos.y, Config.Zones.ShopOutside.Pos.z) < Config.DrawDistance then
			DrawMarker(Config.MarkerType, Config.Zones.ShopOutside.Pos.x, Config.Zones.ShopOutside.Pos.y, Config.Zones.ShopOutside.Pos.z - 1, 0, 0, 0, 0, 0, 0, 1.0001, 1.0001, 1.0001, 255, 10, 10, 165, 0, 0, 0, 0)

			if Vdist(playerPos.x, playerPos.y, playerPos.z, Config.Zones.ShopOutside.Pos.x, Config.Zones.ShopOutside.Pos.y, Config.Zones.ShopOutside.Pos.z) < 2.0 then

				ESX.ShowHelpNotification('Tryck på ~INPUT_CONTEXT~ för att gå till bilhandlarens showroom')

				if IsControlJustReleased(0, Keys['E']) then

					DoScreenFadeOut(2000)
					Citizen.Wait(3000)
					DoScreenFadeIn(2000)
					OpenShopMenu()

				end
			end

		else
			Citizen.Wait(500)
		end
	end
end)

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	ESX.TriggerServerCallback('esx_vehicleshop:getCategories', function (categories)
		Categories = categories
	end)

	ESX.TriggerServerCallback('esx_vehicleshop:getVehicles', function (vehicles)
		Vehicles = vehicles
	end)
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)

		if IsInShopMenu then
			DisableControlAction(0, 75, true)  -- Disable exit vehicle
			DisableControlAction(27, 75, true) -- Disable exit vehicle
		else
			Citizen.Wait(500)
		end
	end
end)

RegisterNetEvent('esx_vehicleshop:sendCategories')
AddEventHandler('esx_vehicleshop:sendCategories', function (categories)
	Categories = categories
end)

RegisterNetEvent('esx_vehicleshop:sendVehicles')
AddEventHandler('esx_vehicleshop:sendVehicles', function (vehicles)
	Vehicles = vehicles
end)

function DeleteShopInsideVehicles()
	while #LastVehicles > 0 do
		local vehicle = LastVehicles[1]
		ESX.Game.DeleteVehicle(vehicle)
		table.remove(LastVehicles, 1)
	end
end

function OpenShopMenu()
	IsInShopMenu = true
	SetEntityVisible(playerPed, false)

	local playerPed = PlayerPedId()

	FreezeEntityPosition(playerPed, true)
	SetEntityVisible(playerPed, false)
	SetEntityCoords(playerPed, Config.Zones.ShopInside.Pos.x, Config.Zones.ShopInside.Pos.y, Config.Zones.ShopInside.Pos.z)

	local vehiclesByCategory = {}
	local elements           = {}
	local firstVehicleData   = nil

	for i=1, #Categories, 1 do
		vehiclesByCategory[Categories[i].name] = {}
	end

	for i=1, #Vehicles, 1 do
		table.insert(vehiclesByCategory[Vehicles[i].category], Vehicles[i])
	end

	for i=1, #Categories, 1 do
		local category         = Categories[i]
		local categoryVehicles = vehiclesByCategory[category.name]
		local options          = {}

		for j=1, #categoryVehicles, 1 do
			local vehicle = categoryVehicles[j]

			if i == 1 and j == 1 then
				firstVehicleData = vehicle
			end

			table.insert(options, vehicle.name)
		end

		table.insert(elements, {
			name    = category.name,
			label   = category.label,
			value   = 0,
			type    = 'slider',
			max     = #Categories[i],
			options = options
		})
	end

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vehicle_shop',
	{
		title    = 'Utställningsbilar',
		align    = 'top-left',
		elements = elements,
	}, function (data, menu)
		local vehicleData  = vehiclesByCategory[data.current.name][data.current.value + 1]
		local vehiclePrice = math.floor(vehicleData.price * 2)

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'shop_confirm',
		{
			title = vehicleData.name,
			align = 'top-left',
			elements = { { label = (string.format('Pris: <span style="color: green;">%s SEK</span>', vehiclePrice)) } }
		}, function (data2, menu2)

		end, function (data2, menu2)
			menu2.close()
		end)

	end, function (data, menu)

		menu.close()
		DeleteShopInsideVehicles()

		local playerPed = PlayerPedId()

		FreezeEntityPosition(playerPed, false)
		SetEntityVisible(playerPed, true)

		DoScreenFadeOut(2000)
		Citizen.Wait(3000)
		DoScreenFadeIn(2000)

		SetEntityCoords(playerPed, Config.Zones.ShopEntering.Pos.x, Config.Zones.ShopEntering.Pos.y, Config.Zones.ShopEntering.Pos.z)

		IsInShopMenu = false

	end, function (data, menu)

		local vehicleData = vehiclesByCategory[data.current.name][data.current.value + 1]
		local playerPed   = PlayerPedId()

		DeleteShopInsideVehicles()

		ESX.Game.SpawnLocalVehicle(vehicleData.model, Config.Zones.ShopInside.Pos, Config.Zones.ShopInside.Heading, function(vehicle)
			table.insert(LastVehicles, vehicle)
			TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
			FreezeEntityPosition(vehicle, true)
		end)

	end)

	DeleteShopInsideVehicles()

	ESX.Game.SpawnLocalVehicle(firstVehicleData.model, Config.Zones.ShopInside.Pos, Config.Zones.ShopInside.Heading, function (vehicle)
		table.insert(LastVehicles, vehicle)
		TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
		FreezeEntityPosition(vehicle, true)
	end)

end