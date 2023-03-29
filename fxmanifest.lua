fx_version 'bodacious'
game 'gta5'

author 'Mocko'
version '1.0.0'

client_scripts {
    'client/main.lua',
    'client/cl_busfahrer.lua',
    'client/cl_elektriker.lua',
    'client/cl_containercarrier.lua',
}

server_scripts {
    'server/main.lua',
    'server/sv_busfahrer.lua',
    'server/sv_elektriker.lua',
    'server/sv_containercarrier.lua',
    '@oxmysql/lib/MySQL.lua',
}

shared_scripts {
    'config.lua',
    '@es_extended/imports.lua',
}

lua54 "yes"

ui_page 'html/index.html'

files {
    "html/index.html",
    'html/css/style.css',
    'html/script.js',
}