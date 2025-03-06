extends Node
@onready var main = $Menu/Main
@onready var vs1 = $Menu/vs1
@onready var menu = $Menu

const port = 9999
const Player = preload("res://player_2.tscn")
var enet_peer = ENetMultiplayerPeer.new()


func _ready() -> void:
	main.visible = true
	vs1.visible = false
 	  
func _process(delta: float) -> void:
	pass

func _on_button_pressed() -> void:
	main.visible = false
	vs1.visible = true

func _on_button_2_pressed() -> void:
	get_tree().change_scene_to_file("res://test_world_2.tscn")

func _on_host_pressed() -> void:
	menu.hide()
	
	enet_peer.create_server(port)
	multiplayer.multiplayer_peer = enet_peer
	multiplayer.peer_connected.connect(_add_player)
	_add_player()

func _on_join_pressed() -> void:
	menu.hide()
	
	enet_peer.create_client("localhost", port)
	multiplayer.multiplayer_peer = enet_peer

func _on_bot_pressed() -> void:
	menu.hide()

func _add_player(id = 1):
	var player = Player.instantiate()
	player.name = str(id)
	call_deferred("add_child", player)
