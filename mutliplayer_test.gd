extends Node

var peer: ENetMultiplayerPeer = ENetMultiplayerPeer.new()

func _ready() -> void:
	if Global.is_host:
		_setup_host()
	else:
		_setup_client()

func _setup_host() -> void:
	peer.create_server(135)
	multiplayer.multiplayer_peer = peer
	multiplayer.peer_connected.connect(_add_player)
	_add_player(1)
	
func _setup_client() -> void:
	peer.create_client("192.168.1.105", 135)
	multiplayer.multiplayer_peer = peer
	multiplayer.peer_connected.connect(_add_player)

func _add_player(id: int) -> void:
	var player = Global.player_scene.instantiate()
	player.name = str(id)
	player.set_multiplayer_authority(id)
	call_deferred("add_child", player)
