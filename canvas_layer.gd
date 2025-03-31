extends CanvasLayer
var shop_open = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Shop.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("shop") and shop_open == false:
		$Shop.visible = true
		shop_open = true
	elif Input.is_action_just_pressed("shop") and shop_open == true:
		$Shop.visible = false
		shop_open = false
	
	$Control/tiger/Label.text = str(Global2Vs2.tiger_score)
	$Control/fox/Label.text = str(Global2Vs2.fox_score)
	
		
	
