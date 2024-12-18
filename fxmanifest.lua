fx_version('cerulean')
games({ 'gta5' })
author 'Emma & Ludaro'

shared_script('shared.lua');

server_scripts({
    'server/*.lua',
    '@oxmysql/lib/MySQL.lua'
});

client_scripts({
    'client/*.lua'
});

dependencies {
    'oxmysql',
    'es_extended'
}

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/style.css',
    'html/script.js'
}
