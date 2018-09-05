extends VBoxContainer

var PlayerViewScene = preload("res://PlayerView.tscn")

# viewport containers
onready var viewports1 = $viewports
onready var viewports2 = $viewports2 # only shown when there are more than 2 players

var viewports = []
export(String) var world setget set_world, get_world
var world_instance = null
var screen_num setget set_screen_num
export(int) var max_screen_num = 4


func set_screen_num(num):
	if num > max_screen_num:
		print("WARNING: tried to set screens to higher than max allowed")
		return
	screen_num = num
	

func set_world(scene):
	if not scene:
		print("WARNING: scene arg is not instance of PackedScene")
		return
	world = scene
	make_world()

func get_world():
	return world

func _ready():
	if self.world:
		make_world()
	
	if screen_num:
		setup_screens()

func _add_world_to_viewports():
	viewports[0].add_child(self.world_instance)
	if viewports.size() > 1:
		var i = 1
		while i < viewports.size():
			viewports[i].world_2d = viewports[0].world_2d
			i += 1


func make_world():
	var scene = load(self.world)
	var world_instance = scene.instance()
	self.world_instance = world_instance
	return world_instance

func setup_screens():
	if not world_instance:
		print("ERROR: you must set the world before setting up screens")
		return
	# add the row for player 3 and 4
	if screen_num > 2:
		viewports2.size_flags_vertical = Control.SIZE_EXPAND_FILL

	# add the actual viewports/cameras and huds
	for i in range(screen_num):
		var player_viewer = PlayerViewScene.instance()
		var viewportContainer = viewports1 if i < 2 else viewports2

		viewportContainer.add_child(player_viewer)
		# add a ref to the actual viewport node
		viewports.append(player_viewer.get_child(0))
		
	_add_world_to_viewports()
