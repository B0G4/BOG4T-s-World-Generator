extends Node2D

@onready var camera = $"Camera2D"
@onready var ui = $"UserInterfaceLayer/User Interface"
var new = Vector2i.ZERO


func _ready() -> void:
	$"Map"._generate_world(200, 1, 5, 2, Vector3(0, 0, 0))


func _process(delta) -> void:
	camera_movement(delta)
	camera_fixing()


func camera_movement(delta):
	ui.get_node("FPS").text = "FPS " + str(Engine.get_frames_per_second())
	if Input.is_action_pressed("scrollup"):
		camera.zoom += Vector2(1 * delta, 1 * delta) * camera.zoom.length()
		ui.get_node("Options/Map Scale/TextEdit").text = str(_round(camera.zoom.x, 5))
	elif Input.is_action_pressed("scrolldown"):
		camera.zoom -= Vector2(1 * delta, 1 * delta) * camera.zoom.length()
		ui.get_node("Options/Map Scale/TextEdit").text = str(_round(camera.zoom.x, 5))
	if Input.is_action_pressed("up"):
		camera.position.y -= 500 * delta
	elif Input.is_action_pressed("down"):
		camera.position.y += 500 * delta
	if Input.is_action_pressed("left"):
		camera.position.x -= 500 * delta
	elif Input.is_action_pressed("right"):
		camera.position.x += 500 * delta


func _on_button_pressed() -> void:
	var size = int(ui.get_node("Options/World Size/TextEdit").text)
	var seed = int(ui.get_node("Options/Seed/TextEdit").text)
	var octaves = int(ui.get_node("Options/Octaves/TextEdit").text)
	var lucanarity= 2
	var frequency = float(ui.get_node("Options/Frequency/TextEdit").text)
	var offset = Vector3(int(ui.get_node("Options/OffsetX/TextEdit").text),  int(ui.get_node("Options/OffsetY/TextEdit").text), 0)
	
	var zom = float(ui.get_node("Options/Map Scale/TextEdit").text)
	camera.zoom = Vector2(zom, zom)
	
	$"Map"._generate_world(size, seed, octaves, lucanarity, offset)


func camera_fixing() -> void:
	if camera.zoom < Vector2(0.01, 0.01):
		camera.zoom = Vector2(0.01, 0.01)
	if camera.zoom > Vector2(40, 40):
		camera.zoom = Vector2(40, 40)


func generate_random_world() -> void:
	# Info gather
	var world_size = int(ui.get_node("Options/World Size/TextEdit").text)
	var octaves = int(ui.get_node("Options/Octaves/TextEdit").text)
	# Generation
	new = Vector2i.ZERO
	for i in range(world_size * world_size):
		$"Map/Ground".set_cell(new, 1, Vector2i(randi_range(0, 2), randi_range(0, 2)))
		new.x += 1
		if new.x > world_size - 1:
			new.x = 0
			new.y += 1


func _round(number, point) -> float:
	var factor = pow(10, point)
	return round(number * factor) / factor
