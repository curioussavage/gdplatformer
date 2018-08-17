extends VBoxContainer

var PlayerViewScene = preload("res://PlayerView.tscn")
var Player = preload("res://player.tscn")

# viewport containers
onready var viewports1 = $viewports
onready var viewports2 = $viewports2 # only added when there are more than 2 players

var viewports = []

func _ready():
	setup_screens()
	var level = make_world()

	## add the map scene to the main viewport
	viewports[0].add_child(level)
	if viewports.size() > 1:
		var i = 1
		while i < viewports.size():
			viewports[i].world_2d = viewports[0].world_2d
			i += 1

func set_camera_limits():
	var map_limits = viewports[0].get_node("tile_map").get_used_rect()
	var map_cellsize = viewports[0].get_node("tile_map").cell_size

	for viewport in viewports:
		var cam = viewport.get_node("Camera2D")
		cam.limit_left = map_limits.position.x * map_cellsize.x
		cam.limit_right = map_limits.end.x * map_cellsize.x
		cam.limit_top = map_limits.position.y * map_cellsize.y
		cam.limit_bottom = map_limits.end.y * map_cellsize.y

func make_world():
	## might want to keep a ref to this... or maybe not
	var scene = load(game_state.level)
	var map = scene.instance()
	var spawner = map.get_node("spawner")
	# add player instances
	for player in game_state.players:
		var player_node = Player.instance()
		player_node.id = player.id
		map.add_child(player_node)
		player_node.position = spawner.position + Vector2(player.id + 10, 0)
		viewports[player.id].get_node("Camera2D").target = player_node
	return map

func get_world():
	# gets the world_2d of the first viewport
	return $Viewports/PlayerView/viewport.world_2d

func setup_screens():
	# add the row for player 3 and 4
	if game_state.players.size() > 2:
		viewports2.size_flags_vertical = Control.SIZE_EXPAND_FILL
		# var container = HBoxContainer.new()
		# container.alignment = HBoxContainer.ALIGN_CENTER
		# container.size_flags_vertical = Control.SIZE_EXPAND_FILL
		# viewports2 = Container
		# add_child(container)

	# add the actual viewports/cameras and huds
	for player in game_state.players:
		var player_viewer = PlayerViewScene.instance()
		var viewportContainer = viewports1 if player.id < 2 else viewports2

		viewportContainer.add_child(player_viewer)
		viewports.append(player_viewer.get_child(0))
		player_viewer.init(player.id)
