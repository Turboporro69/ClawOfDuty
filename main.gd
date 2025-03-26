extends Node
@onready var main = $Menu/Main
@onready var vs1 = $Menu/vs1
@onready var menu = $Menu
@onready var join = $Menu/Join
@onready var host = $Menu/Host
@export var ip : String
var port : int = 621
var addresses: Array = []
const Player = preload("res://player_2.tscn")
var enet_peer = ENetMultiplayerPeer.new()
var ip_assigned : bool = false
var port_assigned : bool = false

func _ready() -> void:
	main.visible = true
	vs1.visible = false
	multiplayer.peer_connected.connect($MultiplayerSpawner.spawn)

	$MultiplayerSpawner.spawn(multiplayer.get_unique_id())
	
	join.hide()
	vs1.hide()
	host.hide()
	$Map.hide()

 	  
func _process(delta: float) -> void:
	if join.visible == true:
		if port_assigned == false:
			$Menu/Join/TextInput/PORT.text = str(port)
			port_assigned = true
			
		port = int(float($Menu/Join/TextInput/PORT.text))
		ip = $Menu/Join/TextInput/IP.text
			
		
	elif $Menu/Host.visible == true:
		if ip_assigned == false:
			ip = IP.resolve_hostname(str(OS.get_environment("COMPUTERNAME")),1)
			$Menu/Host/TextInput/IP.text = ip
			$Menu/Host/TextInput/PORT.text = str(port)
			ip_assigned = true
			
		
func _on_button_pressed() -> void:
	main.visible = false
	vs1.visible = true

func _on_button_2_pressed() -> void:
	get_tree().change_scene_to_file("res://test_world_2.tscn")

func _on_host_pressed() -> void:
	vs1.hide()
	host.show()

func _on_join_pressed() -> void:
	vs1.hide()
	join.show()
	

func _add_player(id = 1):
	var player = Player.instantiate()
	player.name = str(id)
	call_deferred("add_child", player)

func _on_join_2_pressed() -> void:
	menu.hide()
	enet_peer.create_client(ip, port)
	multiplayer.multiplayer_peer = enet_peer
	$Map.show()

func _on_host_2_pressed() -> void:
	menu.hide()
	enet_peer.create_server(port)
	multiplayer.multiplayer_peer = enet_peer
	multiplayer.peer_connected.connect(_add_player)
	_add_player()
	$Map.show()
