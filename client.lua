
-----------------------------------------------------------------------------------------------------------------------------------------
-- FUNÇÃO
-----------------------------------------------------------------------------------------------------------------------------------------
local menuactive = false
function ToggleActionMenu()
	menuactive = not menuactive
	if menuactive then
		SetNuiFocus(true,true)
		SendNUIMessage({ showmenu = true })
	else
		SetNuiFocus(false)
		SendNUIMessage({ hidemenu = true })
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- BOTÃO
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("ButtonClick",function(data,cb)
	if data == "comprar-portearmas" then
		ToggleActionMenu()
		TriggerServerEvent("comprar-portearmas")
	elseif data == "fechar" then
		ToggleActionMenu()
	end
end)


-----------------------------------------------------------------------------------------------------------------------------------------
-- COORDENADA PRA O BLIP DE COMPRA
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	SetNuiFocus(false,false)
	while true do
		local distance = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()),447.25619506836,-975.93994140625,30.689657211304,true)
		if distance <= 5 then
			DrawMarker(21,447.25619506836,-975.93994140625,30.689657211304-0.6,0,0,0,0.0,0,0,0.5,0.5,0.4,0,0,255,50,0,0,0,1)
			if distance <= 1.1 then
				if IsControlJustPressed(0,38) then
					ToggleActionMenu()
				end
			end
		end
		Citizen.Wait(nero)
	end
end)
