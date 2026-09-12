if not Config.Modules['qb-inventory'].active then return end

local function exportHandler(exportName, func)
    AddEventHandler(('__cfx_export_%s_%s'):format(Config.Modules['qb-inventory'].resource_name, exportName), function(setCB)
        setCB(func)
    end)
end

exportHandler('openInventory', function()
    TriggerEvent('ox_inventory:openInventory')
end)


exportHandler('closeInventory', function()
    TriggerEvent('ox_inventory:closeInventory')
end)

exportHandler('GetSlot', function(slot)
    return exports.ox_inventory:GetSlot(slot)
end)

exportHandler('GetCurrentWeapon', function()
    return exports.ox_inventory:GetCurrentWeapon(cache.playerId)
end)

RegisterNetEvent('qb-inventory:client:ItemBox', function(itemData, add)
    if not itemData then return end
    local label = itemData.label or itemData.name or 'Item'
    local count = itemData.amount or itemData.count or 1

    lib.notify({
        id          = 'qb_itembox_' .. (itemData.name or 'item'),
        title       = label,
        description = (add and ('+%s'):format(count) or ('-%s'):format(count)),
        type        = add and 'success' or 'error',
        duration    = 3000,
    })
end)

exportHandler('useItem', function(itemData, cb)
    if type(cb) == 'function' then
        cb(itemData)
    end
end)

RegisterNetEvent('qb-inventory:client:openInventory', function()
    TriggerEvent('ox_inventory:openInventory')
end)

RegisterNetEvent('qb-inventory:client:closeInventory', function()
    TriggerEvent('ox_inventory:closeInventory')
end)
