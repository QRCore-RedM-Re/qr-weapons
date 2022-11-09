local QRCore = exports['qr-core']:GetCoreObject()
local CurrentWeaponData = {}
local currentSerial = nil

RegisterNetEvent('qr-weapons:client:UseWeapon', function(weaponData, shootbool)
    local ped = PlayerPedId()
    local weaponName = tostring(weaponData.name)
    local weaponHash = GetHashKey(weaponData.name)
	local weaponSerial = tostring(weaponData.info.serie)
	local ammo = tonumber(weaponData.info.ammo) or 0
	if Citizen.InvokeNative(0x8425C5F057012DAB,ped) ~= GetHashKey("WEAPON_UNARMED") then
		SetCurrentPedWeapon(ped, `WEAPON_UNARMED`, true)
	local getammo = GetAmmoInPedWeapon(ped, weaponHash)
	local getammoclip = GetAmmoInClip(ped, weaponHash)
	TriggerServerEvent('qr-weapons:server:SaveAmmo', weaponSerial, getammo, getammoclip)
	currentSerial = weaponSerial
	else 
		Citizen.InvokeNative(0xB282DC6EBD803C75, ped, weaponHash, ammo, true, 0)
	end
end)

-- load ammo
RegisterNetEvent('qr-weapons:client:AddAmmo', function(type, amount, itemData)
    local ped = PlayerPedId()
    local weapon = Citizen.InvokeNative(0x8425C5F057012DAB, ped)
	local weapongroup = GetWeapontypeGroup(weapon)
	if Config.Debug == true then
		print(weapon)
		print(weapongroup)
	end
	if currentSerial ~= nil then
		if weapongroup == -1101297303 then -- revolver weapon group
			local total = Citizen.InvokeNative(0x015A522136D7F951, PlayerPedId(), weapon, Citizen.ResultAsInteger())
			if total + (amount/2) < Config.MaxRevolverAmmo then
				if QRCore.Shared.Weapons[weapon] then
					Citizen.InvokeNative(0x106A811C6D3035F3, ped, GetHashKey(type), amount, 0xCA3454E6)
					TriggerServerEvent('weapons:server:removeWeaponAmmoItem', itemData)
				end
			else
				QRCore.Functions.Notify('Max Ammo Capacity', 'error')
			end
		elseif weapongroup == 416676503 then -- pistol weapon group
			local total = Citizen.InvokeNative(0x015A522136D7F951, PlayerPedId(), weapon, Citizen.ResultAsInteger())
			if total + (amount/2) < Config.MaxPistolAmmo then
				if QRCore.Shared.Weapons[weapon] then
					Citizen.InvokeNative(0x106A811C6D3035F3, ped, GetHashKey(type), amount, 0xCA3454E6)
					TriggerServerEvent('weapons:server:removeWeaponAmmoItem', itemData)
				end
			else
				QRCore.Functions.Notify('Max Ammo Capacity', 'error')
			end
		elseif weapongroup == -594562071 then -- repeater weapon group
			local total = Citizen.InvokeNative(0x015A522136D7F951, PlayerPedId(), weapon, Citizen.ResultAsInteger())
			if total + (amount/2) < Config.MaxRepeaterAmmo then
				if QRCore.Shared.Weapons[weapon] then
					Citizen.InvokeNative(0x106A811C6D3035F3, ped, GetHashKey(type), amount, 0xCA3454E6)
					TriggerServerEvent('weapons:server:removeWeaponAmmoItem', itemData)
				end
			else
				QRCore.Functions.Notify('Max Ammo Capacity', 'error')
			end
		elseif weapongroup == 970310034 then -- rifle weapon group
			local total = Citizen.InvokeNative(0x015A522136D7F951, PlayerPedId(), weapon, Citizen.ResultAsInteger())
			if total + (amount/2) < Config.MaxRifleAmmo then
				if QRCore.Shared.Weapons[weapon] then
					Citizen.InvokeNative(0x106A811C6D3035F3, ped, GetHashKey(type), amount, 0xCA3454E6)
					TriggerServerEvent('weapons:server:removeWeaponAmmoItem', itemData)
				end
			else
				QRCore.Functions.Notify('Max Ammo Capacity', 'error')
			end
		elseif weapongroup == -1212426201 then -- sniper rifle weapon group
			local total = Citizen.InvokeNative(0x015A522136D7F951, PlayerPedId(), weapon, Citizen.ResultAsInteger())
			if total + (amount/2) < Config.MaxRifleAmmo then
				if QRCore.Shared.Weapons[weapon] then
					Citizen.InvokeNative(0x106A811C6D3035F3, ped, GetHashKey(type), amount, 0xCA3454E6)
					TriggerServerEvent('weapons:server:removeWeaponAmmoItem', itemData)
				end
			else
				QRCore.Functions.Notify('Max Ammo Capacity', 'error')
			end
		elseif weapongroup == 860033945 then -- shotgun weapon group
			local total = Citizen.InvokeNative(0x015A522136D7F951, PlayerPedId(), weapon, Citizen.ResultAsInteger())
			if total + (amount/2) < Config.MaxShotgunAmmo then
				if QRCore.Shared.Weapons[weapon] then
					Citizen.InvokeNative(0x106A811C6D3035F3, ped, GetHashKey(type), amount, 0xCA3454E6)
					TriggerServerEvent('weapons:server:removeWeaponAmmoItem', itemData)
				end
			else
				QRCore.Functions.Notify('Max Ammo Capacity', 'error')
			end
		elseif weapongroup == -1241684019 then -- arrow weapon group
			local total = Citizen.InvokeNative(0x015A522136D7F951, PlayerPedId(), weapon, Citizen.ResultAsInteger())
			if total + (amount/2) < Config.MaxArrowAmmo then
				if QRCore.Shared.Weapons[weapon] then
					Citizen.InvokeNative(0x106A811C6D3035F3, ped, GetHashKey(type), amount, 0xCA3454E6)
					TriggerServerEvent('weapons:server:removeWeaponAmmoItem', itemData)
				end
			else
				QRCore.Functions.Notify('max ammo capacity!', 'error')
			end
		else
			QRCore.Functions.Notify('wrong ammo for weapon!', 'error')
		end
    else
		QRCore.Functions.Notify('you are not holding a weapon!', 'error')
    end
end)

-- update ammo loop
CreateThread(function()
    while true do
        Wait(1000)
		local ped = PlayerPedId()
		local heldWeapon = Citizen.InvokeNative(0x8425C5F057012DAB, ped)
		local getammo = GetAmmoInPedWeapon(ped, heldWeapon)
		local getammoclip = GetAmmoInClip(ped, heldWeapon)
		if currentSerial ~= nil and heldWeapon ~= -1569615261 then
			TriggerServerEvent('qr-weapons:server:SaveAmmo', currentSerial, getammo, getammoclip)
		end		
	end
end)