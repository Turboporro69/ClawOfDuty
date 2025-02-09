extends CharacterBody2D

var player = null
@export var health : float
@onready var bullet_scene = preload("res://Resources/bullet.tscn")
var last_shot_time = 0.0
@export var cooldown_time : float = 0.5
@onready var raycast = $RayCast2D
@onready var nav_agent = $NavigationAgent2D

@export var speed: float = 200.0 
@export var walk_range: float = 400.0
@export var min_walk_cycle: int = 2
@export var max_walk_cycle: int = 6
signal bot_death
var walk_cycles: int
var current_walk_cycle: int
signal player_seen
var target_position: Vector2

func _ready() -> void:
	player = get_node("../player")
	raycast.add_exception(self)
	%ProgressBar.value = health
	%ProgressBar.max_value = health

	reset_walk_cycle()
	
	nav_agent.connect("navigation_finished", Callable(self, "_on_navigation_completed"))
	choose_random_position()

func _process(delta: float) -> void:
	if health == 0:
		queue_free()
		emit_signal("bot_death")
		score.player_score += 1
	
	if raycast.is_colliding():
		var collider = raycast.get_collider()
		if collider.name == "player":
			emit_signal("player_seen")

	if current_walk_cycle > 0:
		if nav_agent.is_navigation_finished():
			current_walk_cycle -= 1
			choose_random_position()
		else:
			var direction = (nav_agent.get_next_path_position() - global_position).normalized()
			move_and_collide(direction * speed * delta)
		

func choose_random_position() -> void:
	var random_offset = Vector2(randf_range(-walk_range, walk_range), randf_range(-walk_range, walk_range))
	target_position = global_position + random_offset
	nav_agent.set_target_position(target_position)

func reset_walk_cycle() -> void:
	walk_cycles = randi_range(min_walk_cycle, max_walk_cycle)
	current_walk_cycle = walk_cycles

func _on_navigation_completed() -> void:
	reset_walk_cycle()


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("bullets"):
		health -= 1
		%ProgressBar.value = health
		
