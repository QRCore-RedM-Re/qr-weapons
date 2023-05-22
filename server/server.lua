local QRCore = exports['qr-core']:GetCoreObject()

-- start of use ammo

QRCore.Functions.CreateUseableItem('ammo_revolver', function(source, item)
    TriggerClientEvent('qr-weapons:client:AddAmmo', source, 'AMMO_REVOLVER', Config.AmountRevolverAmmo, item)
end)

QRCore.Functions.CreateUseableItem('ammo_pistol', function(source, item)
    TriggerClientEvent('qr-weapons:client:AddAmmo', source, 'AMMO_PISTOL', Config.AmountPistolAmmo, item)
end)

QRCore.Functions.CreateUseableItem('ammo_repeater', function(source, item)
    TriggerClientEvent('qr-weapons:client:AddAmmo', source, 'AMMO_REPEATER', Config.AmountRepeaterAmmo, item)
end)

QRCore.Functions.CreateUseableItem('ammo_rifle', function(source, item)
    TriggerClientEvent('qr-weapons:client:AddAmmo', source, 'AMMO_RIFLE', Config.AmountRifleAmmo, item)
end)

QRCore.Functions.CreateUseableItem('ammo_shotgun', function(source, item)
    TriggerClientEvent('qr-weapons:client:AddAmmo', source, 'AMMO_SHOTGUN', Config.AmountShotgunAmmo, item)
end)

-- end of use ammo

-- save ammo
RegisterNetEvent('qr-weapons:server:SaveAmmo', function(serie, ammo, ammoclip)
	local src = source
	local Player = QRCore.Functions.GetPlayer(src)
    local svslot = nil
    local itemData
    for v,k in pairs(Player.PlayerData.items) do
		if k.type == 'weapon' then
			if ''..k.info.serie..'' == ''..serie..'' then
				svslot = k.slot
				itemData = Player.Functions.GetItemBySlot(svslot)
				itemData.info.ammo = ammo
				itemData.info.ammoclip = ammoclip
				Player.Functions.RemoveItem(itemData.name, itemData.amount, slot)
				Player.Functions.AddItem(itemData.name, itemData.amount, slot, itemData.info)
			end
		end
    end
end)

-- remove ammo from player
RegisterServerEvent('qr-weapons:server:removeWeaponAmmoItem')
AddEventHandler('qr-weapons:server:removeWeaponAmmoItem', function(ammoitem)
	local src = source
    local Player = QRCore.Functions.GetPlayer(src)
	Player.Functions.RemoveItem(ammoitem, 1)
	TriggerClientEvent('inventory:client:ItemBox', src, QRCore.Shared.GetItem(ammoitem), 'remove')
	QRCore.Functions.Notify(src, 'Weapon Reloaded', 'success')
end)

RegisterNetEvent('qr-weapons:server:removeWeaponItem', function(weaponName, amount)
	local src = source
	local Player = QRCore.Functions.GetPlayer(src)

	Player.Functions.RemoveItem(weaponName, amount)
end)