extends Node

var is_host = false
var player_scene: PackedScene

func _ready() -> void:
	player_scene = preload("res://player_2.tscn")
