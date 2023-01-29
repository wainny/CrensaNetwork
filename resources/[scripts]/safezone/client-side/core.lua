-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
Creative = {}
Tunnel.bindInterface("safezone",Creative)
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local Active = false
-----------------------------------------------------------------------------------------------------------------------------------------
-- SAFEZONE
-----------------------------------------------------------------------------------------------------------------------------------------
local Safezone = {
	["1"] = {
		["Revive"] = true,
		["Center"] = vec3(161.68,-990.42,30.09),
		["PolyZone"] = PolyZone:Create({
			vector2(205.79,-1024.9),
			vector2(208.78,-1025.24),
			vector2(211.59,-1023.95),
			vector2(213.45,-1021.75),
			vector2(265.77,-877.37),
			vector2(265.96,-872.18),
			vector2(263.66,-867.45),
			vector2(260.59,-865.25),
			vector2(253.69,-862.65),
			vector2(250.3,-863.26),
			vector2(246.89,-864.0),
			vector2(196.15,-845.44),
			vector2(194.17,-843.28),
			vector2(191.79,-840.11),
			vector2(186.61,-840.59),
			vector2(183.84,-843.67),
			vector2(174.82,-866.8),
			vector2(169.77,-877.06),
			vector2(162.94,-886.97),
			vector2(159.76,-893.61),
			vector2(126.22,-985.71),
			vector2(126.45,-990.34),
			vector2(129.62,-993.36),
			vector2(152.5,-1001.3),
			vector2(155.39,-1006.91),
			vector2(157.51,-1008.65),
			vector2(162.7,-1010.22),
			vector2(169.57,-1007.15),
			vector2(192.45,-1014.76),
			vector2(195.25,-1020.51),
			vector2(198.78,-1022.51)
		},{ name = "Praça" })
	}
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADSAFEZONE
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		if LocalPlayer["state"]["Route"] < 900000 then
			local Ped = PlayerPedId()
			local Coords = GetEntityCoords(Ped)

			for Index,v in pairs(Safezone) do
				if v["PolyZone"]:isPointInside(Coords) then
					if exports["inventory"]:Weapons() ~= "" then
						TriggerEvent("inventory:CleanWeapons")
					end

					if not Active then
						Active = Index

						NetworkSetFriendlyFireOption(false)
						LocalPlayer["state"]:set("SafeZone",true,true)
						TriggerEvent("Notify","Zona Segura","Você está seguro.","verde",5000)
					end
				else
					if Active and not Banned then
						Active = false

						NetworkSetFriendlyFireOption(true)
						LocalPlayer["state"]:set("SafeZone",false,true)
						TriggerEvent("Notify","Zona Segura","Você não está mais seguro.","amarelo",5000)
					end
				end
			end
		end

		Wait(1000)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADACTIVE
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		local TimeDistance = 999
		if Active then
			TimeDistance = 1

			local Ped = PlayerPedId()

			DisableControlAction(0,24,true)
			DisableControlAction(0,25,true)
			DisableControlAction(0,68,true)
			DisableControlAction(0,69,true)
			DisableControlAction(0,70,true)
			DisableControlAction(0,75,true)
			DisableControlAction(0,91,true)
			DisableControlAction(0,92,true)
			DisableControlAction(0,140,true)
			DisableControlAction(0,142,true)
			DisableControlAction(0,257,true)
			DisablePlayerFiring(Ped,true)

			if Safezone[Active] and Safezone[Active]["Revive"] and GetEntityHealth(Ped) <= 100 then
				vRP.Revive(110)
			end
		end

		Wait(TimeDistance)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ACTIVE
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Active()
	return Active
end