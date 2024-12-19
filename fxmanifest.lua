fx_version('cerulean')
games({ 'gta5' })
author 'Emma & Ludaro'
lua54("yes")
shared_scripts {
    '@ox_lib/init.lua',
    'shared/**/*',
    'config/**/*',

}
server_scripts({
    'server/**/*',
    '@oxmysql/lib/MySQL.lua'
});

client_scripts({
    'client/**/*'
});

dependencies {
    'ox_lib',
    'oxmysql',
    'es_extended'
}

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/style.css',
    'html/script.js'
}
