if not Config.Modules['qb-inventory'].active then return end

local ox = exports.ox_inventory

local function exportHandler(exportName, func)
    AddEventHandler(
        ('__cfx_export_%s_%s'):format(Config.Modules['qb-inventory'].resource_name, exportName),
        function(setCB) setCB(func) end
    )
end

local function safe(fn)
    return function(...)
        local ok, result = pcall(fn, ...)
        if not ok and Config.Debug then
            print('[ox_compact:qb-inventory client] Error: ' .. tostring(result))
        end
        return ok and result or nil
    end
end

exportHandler('openInventory', safe(function()
    ox:openInventory('player')
end))

exportHandler('closeInventory', safe(function()
    LocalPlayer.state:set('invBusy', false, false) 
    SendNUIMessage({ action = 'closeInventory' })
end))

exportHandler('HasItem', safe(function(items, amount)
    if not items then return false end

    if type(items) == 'string' then
        return ox:GetItemCount(items) >= (tonumber(amount) or 1)

    elseif type(items) == 'table' then
        local isArr = table.type(items) == 'array'

        if isArr then
            
            local needed = tonumber(amount) or 1
            for _, name in ipairs(items) do
                if ox:GetItemCount(name) < needed then return false end
            end
            return true
        else        
            for name, needed in pairs(items) do
                if type(name) == 'string' then
                    if ox:GetItemCount(name) < (tonumber(needed) or 1) then
                        return false
                    end
                end
            end
            return true
        end
    end

    return false
end))

exportHandler('GetItemCount', safe(function(itemName, metadata, strict)
    if not itemName then return 0 end
    return ox:GetItemCount(itemName, metadata, strict) or 0
end))

exportHandler('GetPlayerItems', safe(function()
    local items  = ox:GetPlayerItems()
    if not items then return {} end
    local result = {}
    for _, item in pairs(items) do
        result[item.slot] = {
            name        = item.name,
            amount      = item.count,
            info        = item.metadata or {},
            label       = item.label,
            weight      = item.weight,
            slot        = item.slot,  
            count       = item.count,
            metadata    = item.metadata or {},
        }
    end
    return result
end))

local function getItemBySlotNumber(slotNum)
    local items = ox:GetPlayerItems()
    if not items then return nil end
    for _, item in pairs(items) do
        if item.slot == slotNum then
            return {
                name     = item.name,
                amount   = item.count,
                info     = item.metadata or {},
                label    = item.label,
                weight   = item.weight,
                slot     = item.slot,
                count    = item.count,
                metadata = item.metadata or {},
            }
        end
    end
    return nil
end

exportHandler('GetItemBySlot', safe(function(slot)
    if not slot then return nil end
    return getItemBySlotNumber(tonumber(slot))
end))

exportHandler('GetFreeWeight', safe(function()
    local current = ox:GetPlayerWeight()    or 0
    local max     = ox:GetPlayerMaxWeight() or 0
    return math.max(0, max - current)
end))

exportHandler('GetMaxWeight', safe(function()
    return ox:GetPlayerMaxWeight() or 0
end))

exportHandler('GetCurrentWeight', safe(function()
    return ox:GetPlayerWeight() or 0
end))

exportHandler('Search', safe(function(search, item, metadata)
    if not search or not item then return nil end
    return ox:Search(search, item, metadata)
end))

exportHandler('GetSlotWithItem', safe(function(itemName, metadata, strict)
    if not itemName then return nil end
    local slot = ox:GetSlotWithItem(itemName, metadata, strict)
    if not slot then return nil end
    return {
        name     = slot.name,
        amount   = slot.count,
        info     = slot.metadata or {},
        label    = slot.label,
        slot     = slot.slot,
        count    = slot.count,
        metadata = slot.metadata or {},
    }
end))

exportHandler('GetSlotsWithItem', safe(function(itemName, metadata, strict)
    if not itemName then return {} end
    local slots = ox:GetSlotsWithItem(itemName, metadata, strict)
    if not slots then return {} end
    local result = {}
    for i, slot in ipairs(slots) do
        result[i] = {
            name     = slot.name,
            amount   = slot.count,
            info     = slot.metadata or {},
            label    = slot.label,
            slot     = slot.slot,
            count    = slot.count,
            metadata = slot.metadata or {},
        }
    end
    return result
end))

exportHandler('GetSlotIdWithItem', safe(function(itemName, metadata, strict)
    if not itemName then return nil end
    return ox:GetSlotIdWithItem(itemName, metadata, strict)
end))

exportHandler('GetSlotIdsWithItem', safe(function(itemName, metadata, strict)
    if not itemName then return {} end
    return ox:GetSlotIdsWithItem(itemName, metadata, strict) or {}
end))

exportHandler('GetCurrentWeapon', safe(function()
    return ox:getCurrentWeapon()
end))

exportHandler('useItem', safe(function(itemData, cb)
    if not itemData then return end
    ox:useItem(itemData, cb)
end))


exportHandler('useSlot', safe(function(slot)
    if not slot then return end
    ox:useSlot(tonumber(slot))
end))

RegisterNetEvent('qb-inventory:client:ItemBox', function(itemData, add)
    if not itemData then return end  
    if not Config.ShowItemBox then return end

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

exportHandler('suppressItemNotifications', safe(function(value)
    ox:suppressItemNotifications(value)
end))


exportHandler('setStashTarget', safe(function(id, owner)
    ox:setStashTarget(id, owner)
end))

RegisterNetEvent('qb-inventory:client:openInventory', function()
    local ok, err = pcall(function() ox:openInventory('player') end)
    if not ok and Config.Debug then print('[ox_compact] openInventory error: ' .. tostring(err)) end
end)

RegisterNetEvent('qb-inventory:client:closeInventory', function()
    LocalPlayer.state:set('invBusy', false, false)
    SendNUIMessage({ action = 'closeInventory' })
end)
