extends Resource
class_name Weapons

enum Category {Primary, Secondary}

@export var name : String
@export var texture : Texture2D
@export var icon : Texture2D
@export var damage : int
@export var price : int
@export var cadence : float
@export var category : Category
@export var automatic : bool
