extends Node
@onready var main = $Menu/Main
@onready var vs1 = $Menu/vs1
@onready var menu = $Menu
@onready var join = $Menu/Join
@onready var host = $Menu/Host
@export var ip : String
var port : int = 621
var addresses: Array = []

@onready var fox = preload("res://fox.tscn")
@onready var tiger = preload("res://tiger.tscn")

var enet_peer = ENetMultiplayerPeer.new()
var ip_assigned : bool = false
var port_assigned : bool = false
var player_character : String

func _ready() -> void:
	main.visible = true
	vs1.visible = false
	
	join.hide()
	vs1.hide()
	host.hide()
	$Map.hide()
	$Player.hide()

 	  
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

func _on_host_pressed() -> void:
	enet_peer = ENetMultiplayerPeer.new()
	enet_peer.create_server(port)
	multiplayer.multiplayer_peer = enet_peer
	multiplayer.peer_connected.connect(peer_connected)
	vs1.hide()
	host.show()
	$Menu/Host/VBoxContainer2.show()

func _on_join_pressed() -> void:
	vs1.hide()
	join.show()

func _on_button_pressed_connect() -> void:
	enet_peer = ENetMultiplayerPeer.new()
	enet_peer.create_client(ip, port)
	
	multiplayer.multiplayer_peer = enet_peer
	$Menu/Join/VBoxContainer2.hide()
	$Menu/Join/VBoxContainer3.show()

@rpc("any_peer")
func _load_player(id, character):
	if is_multiplayer_authority():
		var pl
		var spawn_node = get_tree().current_scene.get_node("Player")

		if character == "fox":
			if Global2Vs2.fox_players.size() >= 2:
				return
			pl = fox.instantiate()
			pl.player_id = id
			pl.name = "Player_" + str(id)
			add_child(pl, true)
			pl.global_position = $Map/SpawnPoints/Marker2D.global_position
			Global2Vs2.fox_players.append(pl)
			
		elif character == "tiger":
			if Global2Vs2.tiger_players.size() >= 2:
				return
			pl = tiger.instantiate()
			pl.player_id = id
			pl.name = "Player_" + str(id)
			add_child(pl, true)
			pl.global_position = $Map/SpawnPoints/Marker2D.global_position
			Global2Vs2.tiger_players.append(pl)



func peer_connected(id):
	pass


func _on_fox_pressed() -> void:
	player_character = "fox"
	await get_tree().create_timer(0.2).timeout
	if multiplayer.is_server():
		_load_player(multiplayer.get_unique_id(), player_character)
	else:
		_load_player.rpc(multiplayer.get_unique_id(), player_character)
	menu.hide()
	$Map.show()
	$Player.show()

func _on_tiger_pressed() -> void:
	player_character = "tiger"
	await get_tree().create_timer(0.2).timeout
	if multiplayer.is_server():
		_load_player(multiplayer.get_unique_id(), player_character)
	else:
		_load_player.rpc(multiplayer.get_unique_id(), player_character)
	menu.hide()
	$Map.show()
	$Player.show()
	
