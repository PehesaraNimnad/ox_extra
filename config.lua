QBCore = exports['qb-core']:GetCoreObject()
Config = {}

Config.Modules = {
    ['qb-menu'] = {
        active        = true,
        resource_name = 'qb-menu'
    },
    ['qb-input'] = {
        active        = true,
        resource_name = 'qb-input'
    },
    ['qb-target'] = {
        active        = true,
        resource_name = 'qb-target'
    },
    ['qb-inventory'] = {
        active        = true,
        resource_name = 'qb-inventory'
    },
}

Config.InventoryName = 'ox_inventory'

-- Set to true if you want lib.notify popups when qb-inventory:client:ItemBox fires.
-- Leave false if ox_inventory's own NUI notification is enough (avoids double notifications).
Config.ShowItemBox = false

Config.Debug = false
