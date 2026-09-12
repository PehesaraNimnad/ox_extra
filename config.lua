QBCore = exports['qb-core']:GetCoreObject()
Config = {}

Config.Modules = {
    ['qb-menu'] = {
        active = true,
        resource_name = 'qb-menu'
    },
    ['qb-input'] = {
        active = true,
        resource_name = 'qb-input'
    },
    ['qb-target'] = {
        active = true,
        resource_name = 'qb-target'
    },
    ['qb-inventory'] = {
        active = true,
        resource_name = 'qb-inventory' -- name of the resource being provided
    },
}

Config.InventoryName = 'ox_inventory'

Config.Debug = false
