extends Node2D


var new = Vector2i.ZERO


func _ready() -> void:
	$"Map"._generate_world(100, 1234, 5, 2, Vector3(0, 0, 0))


func _process(delta) -> void:
	$"User Interface/FPS".text = "FPS " + str(Engine.get_frames_per_second())
	if Input.is_action_pressed("scrollup"):
		$"Map".scale += Vector2(2 * delta, 2 * delta)
		$"User Interface/Options/Map Scale/TextEdit".text = str(_round($"Map".scale.x, 5))
	elif Input.is_action_pressed("scrolldown"):
		$"Map".scale -= Vector2(2 * delta, 2 * delta)
		$"User Interface/Options/Map Scale/TextEdit".text = str(_round($"Map".scale.x, 5))
	if Input.is_action_pressed("up"):
		$"Map".position.y += 500 * delta
	elif Input.is_action_pressed("down"):
		$"Map".position.y -= 500 * delta
	if Input.is_action_pressed("left"):
		$"Map".position.x += 500 * delta
	elif Input.is_action_pressed("right"):
		$"Map".position.x -= 500 * delta


func _on_button_pressed() -> void:
	var size = int($"User Interface/Options/World Size/TextEdit".text)
	var seed = int($"User Interface/Options/Seed/TextEdit".text)
	var octaves = int($"User Interface/Options/Octaves/TextEdit".text)
	var lucanarity= 2
	var frequency = float($"User Interface/Options/Frequency/TextEdit".text)
	var offset = Vector3(int($"User Interface/Options/OffsetX/TextEdit".text),  int($"User Interface/Options/OffsetY/TextEdit".text), 0)
	
	var map_scale = float($"User Interface/Options/Map Scale/TextEdit".text)
	$"Map".scale = Vector2(map_scale, map_scale)
	
	$"Map"._generate_world(size, seed, octaves, lucanarity, offset)


func generate_random_world() -> void:
	# Info gather
	var world_size = int($"User Interface/Options/World Size/TextEdit".text)
	var octaves = int($"User Interface/Options/Octaves/TextEdit".text)
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
