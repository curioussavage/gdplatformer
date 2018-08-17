extends ViewportContainer

var id = null

onready var cam = $Viewport/Camera2D
onready var hud_label = $Viewport/Camera2D/hud/Label
onready var viewport = $Viewport


func init(id):
	var id_str = str(id)
	print("initializing player " + id_str)
	hud_label.text = id_str

