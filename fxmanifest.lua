fx_version 'cerulean'
game 'gta5'

author 'Chunce'
description 'qb-graverobbing by chunce'
version '1.0.0'

shared_scripts { 
	'config.lua'
}

client_scripts {
    'client/*.lua',
}

server_scripts {
    'server/*.lua',
    '@oxmysql/lib/MySQL.lua',
}



lua54 'yes'

dependency 'qb-target'