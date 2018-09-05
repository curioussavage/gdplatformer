extends Viewport

var id = null setget set_id

onready var cam = $Viewport/Camera2D
onready var hud_label = $Viewport/Camera2D/hud/Label
onready var viewport = $Viewport


func set_id(new_id):
	var id_str = str(new_id)
	print("initializing player " + id_str)
	hud_label.text = id_str
	id = id_str