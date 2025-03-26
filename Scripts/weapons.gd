extends Resource
class_name Weapons

enum Category {primary, secondary}

@export var name : String
@export var texture : Texture2D
@export var icon : Texture2D
@export var damage : int
@export var price : int
@export var cadence : float
@export var category : Category
@export var automatic : bool
@export var recoil : int
@export var recoil_moving : int
@export var mag_bullets : int
@export var mag_max : int
@export var reload_time : float
@export var sprite_scale : float
