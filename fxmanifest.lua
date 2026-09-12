fx_version 'cerulean'
game 'gta5'
lua54 'yes'
use_experimental_fxv2_oal 'yes'

name 'ox_extra'
author 'Pehesara'
description 'QB compatibility layer for ox_lib and ox_inventory'
version '1.0.0'

dependencies {
    'ox_lib',
    'ox_inventory',
}

shared_scripts {
    'config.lua',
    '@ox_lib/init.lua',
}

client_script 'client/*.lua'

server_scripts {
    'server/*.lua',
}

ox_lib 'context'
ox_lib 'table'

provide 'qb-menu'
provide 'qb-input'
provide 'qb-target'
provide 'qb-inventory'
