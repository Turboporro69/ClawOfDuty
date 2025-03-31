extends Node
class_name Global_2vs2

var tiger_score = 0
var fox_score = 0

var tiger_players = []
var fox_players = []

var bomb_defused : bool = false

var fox_death = 0
var tiger_death = 0

var round_finished = false

var fox_spawn_point = Vector2(-746.3301, -2411.22)
var tiger_spawn_point = Vector2(3921.67, -2099.22)



@onready var reset_timer = Timer.new()

func _ready() -> void:
	pass


@rpc("any_peer")
func update_scores(new_tiger_score: int, new_fox_score: int) -> void:
	tiger_score = new_tiger_score
	fox_score = new_fox_score

func _process(delta: float) -> void:
	if fox_death == 1:
		tiger_score += 1
		round_finished = true
		update_scores.rpc(tiger_score, fox_score) # Sincroniza los puntajes
		reset_all_players.rpc()
		fox_death = 0
		
	elif tiger_death == 1:
		fox_score += 1
		round_finished = true
		update_scores.rpc(tiger_score, fox_score) # Sincroniza los puntajes
		reset_all_players.rpc()
		tiger_death = 0

	elif bomb_defused == true:
		tiger_score += 1
		update_scores.rpc(tiger_score, fox_score) # Sincroniza los puntajes

@rpc("any_peer")
func reset_all_players():
	for player in get_tree().get_nodes_in_group("players"):
		player.reset_round()

#func _reset_game():
	#if round_finished == true:
		#fox_death = 0
		#tiger_death = 0
		#bomb_defused = false
		#round_finished = false
		#score_updated = false
