-- Manifest
resource_manifest_version '77731fab-63ca-442c-a67b-abc70f28dfa5'

dependency 'essentialmode'

client_script {
    'client.lua',
    'config.lua',
	'GUI.lua'
}

server_scripts {
	'server.lua',
	'config.lua'
}

