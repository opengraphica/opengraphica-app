extends ViewportContainer

var bounds: Control
var background: ColorRect
var child_container: Node2D

var display_name: String setget set_display_name, get_display_name
var dimensions: Vector2 = Vector2(40, 40) setget set_dimensions, get_dimensions

func set_display_name(new_display_name: String):
	display_name = new_display_name
	
func get_display_name():
	return display_name

func set_dimensions(new_dimensions: Vector2):
	rect_size = new_dimensions
	bounds.rect_size = new_dimensions
	background.rect_size = new_dimensions
	dimensions = new_dimensions
	
func get_dimensions():
	return dimensions

func _ready():
	bounds = $ArtboardViewport/Bounds
	child_container = $ArtboardViewport/Bounds/Children



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
