extends Camera2D

# var b = "textvar"
var target = null


func _physics_process(delta):
	if target:
		position = target.position
