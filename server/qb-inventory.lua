if not Config.Modules['qb-inventory'].active then return end


if GetResourceState('ox_inventory') ~= 'started' then
    print('^1[ox_extra] ox_inventory is not started — qb-inventory module disabled.^0')
    return
end

local ox = exports.ox_inventory

local function exportHandler(exportName, func)
    AddEventHandler(
        ('__cfx_export_%s_%s'):format(Config.Modules['qb-inventory'].resource_name, exportName),
        function(setCB)
            setCB(function(...)
                local ok, result = pcall(func, ...)
                if not ok then
                    if Config.Debug then
                        print(('[ox_compact:qb-inventory server] Export "%s" error: %s'):format(exportName, tostring(result)))
                    end
                    return nil
                end
                return result
            end)
        end
    )
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
        slot        = item.slot,   
        count       = item.count,
        metadata    = item.metadata or {},
    }
end

local function calcTotalWeight(items)
    local total = 0
    if not items then return total end
    for _, item in pairs(items) do
        local name   = item.name
        local amount = item.amount or item.count or 1
        local def    = ox:Items(name)
        if def and def.weight then
            total = total + (def.weight * amount)
        end
    end
    return total
end

exportHandler('LoadInventory', function(source, citizenid)
    if not source then return {} end
    local items  = ox:GetInventoryItems(source)
    if not items then return {} end
    local result = {}
    for _, item in pairs(items) do
        result[item.slot] = toQBItem(item)
    end
    return result
end)

exportHandler('SaveInventory', function(source, offline)
    return true
end)

exportHandler('OpenInventory', function(source, identifier, data)
    if not source then return end
    if not identifier then
        TriggerClientEvent('ox_inventory:openInventory', source, 'player', source)
        return
    end
    if data then
        ox:RegisterStash(
            identifier,
            data.label    or identifier,
            data.slots    or 50,
            data.maxweight or data.maxWeight or 500000,
            nil
        )
    end
    ox:forceOpenInventory(source, 'stash', identifier)
end)

exportHandler('OpenInventoryById', function(source, playerId)
    if not source or not playerId then return end
    ox:forceOpenInventory(source, 'player', tonumber(playerId))
end)

exportHandler('CloseInventory', function(source, identifier)
    if not source then return end
    TriggerClientEvent('ox_inventory:closeInventory', source)
end)

exportHandler('CreateInventory', function(identifier, data)
    if not identifier then return end
    data = data or {}
    ox:RegisterStash(
        identifier,
        data.label     or identifier,
        data.slots     or 50,
        data.maxweight or data.maxWeight or 500000,
        nil   
    )
end)

exportHandler('RemoveInventory', function(identifier)
    if not identifier then return end
    ox:RemoveInventory(identifier)
end)

exportHandler('ClearStash', function(identifier)
    if not identifier then return false end
    ox:ClearInventory(identifier)
    return true
end)

exportHandler('CreateStash', function(stashData)
    if not stashData then return end
    ox:RegisterStash(
        stashData.id        or stashData.name,
        stashData.label     or stashData.id or stashData.name,
        stashData.slots     or 50,
        stashData.maxWeight or stashData.maxweight or 500000,
        stashData.owner,
        stashData.groups    or stashData.jobs or nil,
        stashData.coords    or nil
    )
end)

local QBShops = {}

exportHandler('CreateShop', function(shopData)
    if not shopData or not shopData.name then return end
    QBShops[shopData.name] = shopData
    if Config.Debug then
        print(('[ox_extra] CreateShop "%s" stored locally. Define it in ox_inventory/data/shops.lua for full support.'):format(shopData.name))
    end
end)

exportHandler('OpenShop', function(source, name)
    if not source or not name then return end  
    TriggerClientEvent('ox_inventory:openInventory', source, 'shop', name)
end)

exportHandler('CanAddItem', function(source, item, amount)
    if not source or not item or not amount then return false, 'invalid_args' end
    local canCarry = ox:CanCarryItem(source, item, amount)
    if canCarry then return true end
    local inv = ox:GetInventory(source)
    if inv then
        local freeSlots = 0
        if inv.items then
            for i = 1, (inv.slots or 0) do
                if not inv.items[i] then freeSlots = freeSlots + 1 end
            end
        end
        if freeSlots == 0 then return false, 'inventory_full' end
    end
    return false, 'overweight'
end)

exportHandler('AddItem', function(identifier, item, amount, slot, info, reason)
    if not identifier or not item or not amount then return false end
    local meta    = type(info) == 'table'  and info or nil
    local slotNum = type(slot) == 'number' and slot or nil
    local success = ox:AddItem(identifier, item, amount, meta, slotNum)
    return success and true or false
end)

exportHandler('RemoveItem', function(identifier, item, amount, slot, reason)
    if not identifier or not item or not amount then return false end
    local slotNum = type(slot) == 'number' and slot or nil
    local success = ox:RemoveItem(identifier, item, amount, nil, slotNum)
    return success and true or false
end)

exportHandler('AddItems', function(source, items)
    if not source or type(items) ~= 'table' then return false end
    local allOk = true
    for _, v in pairs(items) do
        local name  = v.name  or v[1]
        local count = v.amount or v.count or v[2] or 1
        local meta  = v.info  or v.metadata or v[3] or nil
        if name then
            local ok = ox:AddItem(source, name, count, meta)
            if not ok then allOk = false end
        end
    end
    return allOk
end)

exportHandler('ClearInventory', function(source, filterItems)
    if not source then return false end
    ox:ClearInventory(source, filterItems)
    return true
end)

exportHandler('SetInventory', function(source, items)
    if not source or type(items) ~= 'table' then return false end
    ox:ClearInventory(source)
    for _, v in pairs(items) do
        local name  = v.name
        local count = v.amount or v.count or 1
        local meta  = v.info   or v.metadata or nil
        local slot  = v.slot   or nil
        if name and count and count > 0 then
            ox:AddItem(source, name, count, meta, slot)
        end
    end
    return true
end)

exportHandler('SetItemData', function(source, itemName, key, val, slot)
    if not source or not itemName or not key then return false end

    local targetSlot
    if type(slot) == 'number' then
        targetSlot = slot
    else
        local found = ox:GetSlotIdWithItem(source, itemName, nil, false)
        if not found then return false end
        targetSlot = found
    end

    local slotData = ox:GetSlot(source, targetSlot)
    if not slotData or slotData.name ~= itemName then return false end

    if key == 'info' or key == 'metadata' then
        local meta = slotData.metadata or {}
        if type(val) == 'table' then
            for k, v in pairs(val) do meta[k] = v end
        else
            meta = val
        end
        ox:SetMetadata(source, targetSlot, meta)

    elseif key == 'amount' or key == 'count' then
        local diff = tonumber(val) - (slotData.count or 0)
        if diff > 0 then
            ox:AddItem(source, itemName, diff, slotData.metadata, targetSlot)
        elseif diff < 0 then
            ox:RemoveItem(source, itemName, math.abs(diff), nil, targetSlot)
        end

    else
        
        local meta = slotData.metadata or {}
        meta[key]  = val
        ox:SetMetadata(source, targetSlot, meta)
    end

    return true
end)

exportHandler('UseItem', function(itemName, ...)
    if Config.Debug then
        print(('[ox_extra] UseItem called for "%s". Register usable items via exports.ox_inventory:RegisterUsableItem instead.'):format(tostring(itemName)))
    end
end)

exportHandler('HasItem', function(source, items, amount)
    if not source or not items then return false end

    if type(items) == 'string' then
        return ox:GetItemCount(source, items) >= (tonumber(amount) or 1)

    elseif type(items) == 'table' then
        local isArr = table.type(items) == 'array'

        if isArr then
            local needed = tonumber(amount) or 1
            for _, name in ipairs(items) do
                if ox:GetItemCount(source, name) < needed then return false end
            end
            return true
        else
            
            for name, needed in pairs(items) do
                if type(name) == 'string' then
                    if ox:GetItemCount(source, name) < (tonumber(needed) or 1) then
                        return false
                    end
                end
            end
            return true
        end
    end

    return false
end)

exportHandler('GetItemByName', function(source, item)
    if not source or not item then return false end
    return toQBItem(ox:GetItem(source, item, nil, false))
end)

exportHandler('GetItemsByName', function(source, item)
    if not source or not item then return false end
    local slots = ox:GetSlotsWithItem(source, item, nil, false)
    if not slots or not next(slots) then return false end
    local result = {}
    for i, slot in ipairs(slots) do result[i] = toQBItem(slot) end
    return result
end)

exportHandler('GetItemBySlot', function(source, slot)
    if not source or not slot then return nil end
    return toQBItem(ox:GetSlot(source, tonumber(slot)))
end)

exportHandler('GetItemCount', function(source, items)
    if not source or not items then return 0 end
    if type(items) == 'string' then
        return ox:GetItemCount(source, items) or 0
    elseif type(items) == 'table' then
        local total = 0
        for _, name in ipairs(items) do
            total = total + (ox:GetItemCount(source, name) or 0)
        end
        return total
    end
    return 0
end)

exportHandler('GetSlots', function(identifier)
    if not identifier then return 0, 0 end
    local inv = ox:GetInventory(identifier)
    if not inv then return 0, 0 end
    local used = 0
    if inv.items then
        for _ in pairs(inv.items) do used = used + 1 end
    end
    return used, math.max(0, (inv.slots or 0) - used)
end)

exportHandler('GetSlotsByItem', function(items, itemName)
    if not items or not itemName then return {} end
    local lower  = itemName:lower()
    local result = {}
    for slot, item in pairs(items) do
        if item and item.name and item.name:lower() == lower then
            result[#result + 1] = slot
        end
    end
    return result
end)

exportHandler('GetFirstSlotByItem', function(items, itemName)
    if not items or not itemName then return nil end
    local lower = itemName:lower()
    for slot, item in pairs(items) do
        if item and item.name and item.name:lower() == lower then
            return slot
        end
    end
    return nil
end)

exportHandler('GetFreeWeight', function(source)
    if not source then return 0 end
    local inv = ox:GetInventory(source)
    if not inv then return 0 end
    return math.max(0, (inv.maxWeight or 0) - (inv.weight or 0))
end)

exportHandler('GetTotalWeight', function(items)
    return calcTotalWeight(items)
end)

exportHandler('GetInventory', function(identifier)
    if not identifier then return nil end
    local inv = ox:GetInventory(identifier)
    if not inv then return nil end
    local items = {}
    if inv.items then
        for slot, item in pairs(inv.items) do
            if item then items[slot] = toQBItem(item) end
        end
    end
    return {
        id        = inv.id,
        label     = inv.label,
        maxweight = inv.maxWeight,
        slots     = inv.slots,
        weight    = inv.weight,
        items     = items,
    }
end)

exportHandler('GetPlayerInventory', function(source)
    if not source then return {} end
    local items  = ox:GetInventoryItems(source)
    if not items then return {} end
    local result = {}
    for _, item in pairs(items) do
        result[item.slot] = toQBItem(item)
    end
    return result
end)

exportHandler('CanCarryItem', function(source, item, amount)
    if not source then return false end
    return ox:CanCarryItem(source, item, amount or 1)
end)

exportHandler('GetInventoryItemByName',  function(src, i) return toQBItem(ox:GetItem(src, i, nil, false)) end)
exportHandler('GetInventoryItemsByName', function(src, i)
    local s = ox:GetSlotsWithItem(src, i, nil, false)
    if not s or not next(s) then return false end
    local r = {}
    for idx, slot in ipairs(s) do r[idx] = toQBItem(slot) end
    return r
end)

RegisterNetEvent('qb-inventory:server:GiveItem', function(targetId, name, amount, fromSlot)
    local src = source
    amount    = tonumber(amount)
    targetId  = tonumber(targetId)
    if not targetId or not name or not amount or amount <= 0 then return end

    if ox:GetItemCount(src, name) < amount then
        TriggerClientEvent('ox_lib:notify', src, { type = 'error', description = 'Not enough items.' })
        return
    end

    local removed = ox:RemoveItem(src, name, amount, nil, type(fromSlot) == 'number' and fromSlot or nil)
    if not removed then
        TriggerClientEvent('ox_lib:notify', src, { type = 'error', description = 'Failed to remove item.' })
        return
    end

    if not ox:CanCarryItem(targetId, name, amount) then
        ox:AddItem(src, name, amount)
        TriggerClientEvent('ox_lib:notify', src, { type = 'error', description = 'Target cannot carry that item.' })
        return
    end

    ox:AddItem(targetId, name, amount)

    local label   = (ox:Items(name) or {}).label or name
    local itemDef = { name = name, label = label, amount = amount }
    TriggerClientEvent('ox_lib:notify', src,      { type = 'success', description = ('Gave %sx %s'):format(amount, label) })
    TriggerClientEvent('ox_lib:notify', targetId, { type = 'success', description = ('Received %sx %s'):format(amount, label) })
    TriggerClientEvent('qb-inventory:client:ItemBox', src,      itemDef, false)
    TriggerClientEvent('qb-inventory:client:ItemBox', targetId, itemDef, true)
end)
RegisterNetEvent('QBCore:Server:AddItem',    function(src, item, amt) if src and item and amt then ox:AddItem(src, item, amt) end end)
RegisterNetEvent('QBCore:Server:RemoveItem', function(src, item, amt) if src and item and amt then ox:RemoveItem(src, item, amt) end end)
