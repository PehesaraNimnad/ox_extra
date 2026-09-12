
if not Config.Modules['qb-inventory'].active then return end

local ox = exports.ox_inventory

local function exportHandler(exportName, func)
    AddEventHandler(('__cfx_export_%s_%s'):format(Config.Modules['qb-inventory'].resource_name, exportName), function(setCB)
        setCB(func)
    end)
end

local function toQBItem(item)
    if not item then return false end
    return { 
        name        = item.name,
        amount      = item.count,
        info        = item.metadata or {},
        type        = 'item',
        unique      = not (item.stack or false),
        useable     = true,
        shouldClose = item.close or true,
        weight      = item.weight,
        label       = item.label,
        count       = item.count,
        metadata    = item.metadata or {},
        slot        = item.slot,
    }
end

exportHandler('AddItem', function(source, item, amount, slot, info)
    if not source or not item or not amount then return false end
    local meta    = type(info) == 'table' and info or nil
    local slotNum = type(slot) == 'number' and slot or nil
    local success = ox:AddItem(source, item, amount, meta, slotNum)
    return success and true or false
end)

exportHandler('RemoveItem', function(source, item, amount, slot, info)
    if not source or not item or not amount then return false end
    local meta    = type(info) == 'table' and info or nil
    local slotNum = type(slot) == 'number' and slot or nil
    local success = ox:RemoveItem(source, item, amount, meta, slotNum)
    return success and true or false
end)

exportHandler('AddItems', function(source, items)
    if not source or type(items) ~= 'table' then return false end
    local allOk = true
    for _, v in pairs(items) do
        local name  = v.name  or v[1]
        local count = v.amount or v.count or v[2] or 1
        local meta  = v.info  or v.metadata or v[3] or nil
        if name and count then
            local ok = ox:AddItem(source, name, count, meta)
            if not ok then allOk = false end
        end
    end
    return allOk
end)

exportHandler('GetItemByName', function(source, item)
    if not source or not item then return false end
    local found = ox:GetItem(source, item, nil, false)
    return toQBItem(found)
end)


exportHandler('GetItemsByName', function(source, item)
    if not source or not item then return false end
    local slots = ox:GetSlotsWithItem(source, item, nil, false)
    if not slots or not next(slots) then return false end
    local result = {}
    for i, slot in ipairs(slots) do
        result[i] = toQBItem(slot)
    end
    return result
end)

exportHandler('GetInventoryItemByName',  function(s, i) return toQBItem(ox:GetItem(s, i, nil, false)) end)
exportHandler('GetInventoryItemsByName', function(s, i)
    local slots = ox:GetSlotsWithItem(s, i, nil, false)
    if not slots or not next(slots) then return false end
    local r = {}
    for idx, slot in ipairs(slots) do r[idx] = toQBItem(slot) end
    return r
end)

exportHandler('HasItem', function(source, items, amount)
    if not source or not items then return false end
    amount = tonumber(amount) or 1
    if type(items) == 'string' then
        return ox:GetItemCount(source, items) >= amount
    elseif type(items) == 'table' then
        for _, name in ipairs(items) do
            if ox:GetItemCount(source, name) < amount then
                return false
            end
        end
        return true
    end
    return false
end)

exportHandler('GetInventory', function(source)
    if not source then return {} end
    local items   = ox:GetInventoryItems(source)
    if not items then return {} end
    local result  = {}
    for _, item in pairs(items) do
        result[#result + 1] = toQBItem(item)
    end
    return result
end)

exportHandler('GetPlayerInventory', function(source)
    if not source then return {} end
    local items  = ox:GetInventoryItems(source)
    if not items then return {} end
    local result = {}
    for _, item in pairs(items) do result[#result + 1] = toQBItem(item) end
    return result
end)

exportHandler('ClearInventory', function(source, keep)
    if not source then return false end
    ox:ClearInventory(source, keep)
    return true
end)

exportHandler('SetInventory', function(source, items)
    if not source or type(items) ~= 'table' then return false end
    ox:ClearInventory(source)
    for _, v in pairs(items) do
        local name  = v.name
        local count = v.amount or v.count or 1
        local meta  = v.info or v.metadata or nil
        if name and count and count > 0 then
            ox:AddItem(source, name, count, meta)
        end
    end
    return true
end)

exportHandler('CanCarryItem', function(source, item, amount)
    if not source then return false end
    return ox:CanCarryItem(source, item, amount or 1)
end)

exportHandler('CanCarryWeight', function(source, weight)
    if not source then return false end
    local can, free = ox:CanCarryWeight(source, weight)
    return can, free
end)

exportHandler('CreateStash', function(stashData)
    if not stashData then return end
    ox:RegisterStash(
        stashData.id       or stashData.name,
        stashData.label    or stashData.id or stashData.name,
        stashData.slots    or 50,
        stashData.maxWeight or 500000,
        stashData.owner,
        stashData.groups   or stashData.jobs or nil,
        stashData.coords   or nil
    )
end)
local invTypeMap = {
    player   = 'player',
    stash    = 'stash',
    trunk    = 'trunk',
    glovebox = 'glovebox',
    drop     = 'drop',
    dumpster = 'dumpster',
}
exportHandler('OpenInventory', function(source, invType, data)
    if not source then return end
    ox:forceOpenInventory(source, invTypeMap[invType] or invType, data)
end)

exportHandler('GetItem', function(itemName)
    if not itemName then return false end
    local item = ox:Items(itemName)
    if not item then return false end
    return {
        name        = item.name,
        label       = item.label,
        weight      = item.weight,
        type        = 'item',
        unique      = not (item.stack or false),
        useable     = true,
        image       = item.name .. '.png',
        description = item.description or '',
    }
end)

exportHandler('GetItemLabel', function(itemName)
    if not itemName then return false end
    local data = ox:Items(itemName)
    return data and data.label or false
end)

RegisterNetEvent('qb-inventory:server:GiveItem', function(targetId, name, amount, fromSlot)
    local src = source
    amount    = tonumber(amount)
    targetId  = tonumber(targetId)
    if not targetId or not name or not amount or amount <= 0 then return end

    if ox:GetItemCount(src, name) < amount then
        TriggerClientEvent('ox_lib:notify', src, {
            type        = 'error',
            description = 'Not enough items to give.',
        })
        return
    end

    local removed = ox:RemoveItem(src, name, amount, nil, type(fromSlot) == 'number' and fromSlot or nil)
    if not removed then
        TriggerClientEvent('ox_lib:notify', src, { type = 'error', description = 'Failed to remove item.' })
        return
    end

    local added = ox:AddItem(targetId, name, amount)
    if not added then
        ox:AddItem(src, name, amount)  
        TriggerClientEvent('ox_lib:notify', src, {
            type        = 'error',
            description = 'Target player cannot carry that item.',
        })
        return
    end

    local label = (ox:Items(name) or {}).label or name
    TriggerClientEvent('ox_lib:notify', src,      { type = 'success', description = ('Gave %sx %s'):format(amount, label) })
    TriggerClientEvent('ox_lib:notify', targetId, { type = 'success', description = ('Received %sx %s from a player'):format(amount, label) })
    local itemDef = { name = name, label = label, amount = amount }
    TriggerClientEvent('qb-inventory:client:ItemBox', src,      itemDef, false)
    TriggerClientEvent('qb-inventory:client:ItemBox', targetId, itemDef, true)
end)

RegisterNetEvent('QBCore:Server:AddItem', function(src, item, amount)
    if not src or not item or not amount then return end
    ox:AddItem(src, item, amount)
end)

RegisterNetEvent('QBCore:Server:RemoveItem', function(src, item, amount)
    if not src or not item or not amount then return end
    ox:RemoveItem(src, item, amount)
end)
