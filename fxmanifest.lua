fx_version 'cerulean'
game 'gta5'

author 'picus'
description 'CarPlay System (ox + xsound)'
version '1.0.0'

shared_script '@ox_lib/init.lua'

client_scripts {
    'client.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server.lua'
}