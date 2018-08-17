extends Node

# Will be in charge of global game state values such as:
# player data
# score
# etc

var players = []
var level = null

func _ready():
	# for testing
	level = 'res://stage.tscn'

	setup_gamepad_conn_listen()

func _process(delta):
	var scene_name = get_tree().get_current_scene().get_name()
	if Input.is_key_pressed(KEY_ESCAPE):
		if scene_name == "menu.tscn":
			get_tree().quit()
		else:
			SceneSwitcher.goto_scene("res://menu.tscn")


## GAMEPADS
func setup_gamepad_conn_listen():
	Input.connect("joy_connection_changed", self, "_handle_gamepad_conn")

func _handle_gamepad_conn(id, connected):
	var is_known = Input.is_joy_known(id)
	var joy_name = Input.get_joy_name(id)
	if connected:
		print('gamepad connected %d %s %s' % [id, "true" if is_known else "false", joy_name])
	else:
		print('gamepad disconnected %d' % id)