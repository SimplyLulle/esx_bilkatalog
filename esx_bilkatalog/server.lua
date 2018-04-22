--[[
------------------
- made by Stadus -
-    StadusRP    -
-   client.lua   -
-  stadus.party  -
------------------
]]--

local tax = 0.90 -- 0.9 = 10% Tax

ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent("wash:BlanchirCash")
AddEventHandler("wash:BlanchirCash", function(source, amount)
		local newamount = tonumber(amount)
		local _source = source
		local xPlayer = ESX.GetPlayerFromId(_source)
		local cash = xPlayer.get('money') --xPlayer.get('money')
		local account = xPlayer.getAccount('black_money')
		local accountmoney = tonumber(account.money)
	--	print(newamount)
	--	print(xPlayer.getGroup())
	--	print(cash)
	--  print(account.money)
	    if xPlayer.getGroup() == "user" then
			TriggerClientEvent('esx:showNotification', _source, "~y~Du är inte VIP, så vi kan inte hjälpa dig...")
		else
		local ablanchir = newamount
		if (accountmoney == 0 ) then
			 TriggerClientEvent('esx:showNotification', _source, "~y~Du har inga pengar att tvätta...")
		elseif (accountmoney >= 0 ) then
			local washedcash = newamount * tax
			local doneWash = math.floor(washedcash)
			local total = cash + washedcash
			local totald = accountmoney - newamount
			local jamntotal = tonumber(totald)
			print("(VIP) Spelare: ".. xPlayer.getName() .. " washed $" .. newamount)
			xPlayer.addMoney(doneWash)
			xPlayer.setAccountMoney('black_money', jamntotal)
			TriggerClientEvent('esx:showNotification', _source, "Du tvättade ~r~".. tonumber(ablanchir) .."$~s~ smutsiga pengar.~s~ Du fick ~g~".. doneWash .."$")
		elseif ( accountmoney <= 0 ) then
		TriggerClientEvent('esx:showNotification', _source, "Kom tillbaka när du har betalat din skuld!")
	
	    end
	end
		
end)
