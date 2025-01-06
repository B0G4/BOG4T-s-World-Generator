extends Node2D


var noise
const TILES = {
	"waterdark": Vector2i(0, 2),
	"water": Vector2i(1, 1),
	"sand": Vector2i(2, 0),
	"grass": Vector2i(0, 0),
	"grassdark": Vector2i(1, 0),
	"rock": Vector2i(0, 1),
	"snow": Vector2i(2, 2)
}
# Nice seeds
# - 41223532
# - 9124
# Nice zooms
# - 0.11892


func _generate_world(size=100, seed=1234, octaves=5, lucanarity=2, offset=Vector3.ZERO, frequency=0.01) -> void:
	# Init
	$"Ground".clear()
	randomize()
	noise = FastNoiseLite.new()
	noise.noise_type = FastNoiseLite.TYPE_PERLIN  # TYPE_VALUE is good for large worlds
	noise.seed = seed
	noise.fractal_octaves = octaves
	noise.fractal_lacunarity = lucanarity
	noise.offset = offset
	noise.frequency = frequency
	# Generate
	for x in size:
		for y in size:
			#         _Position                     _Tileset ID
			#        |                             |  |-Tile position on atlas
			$"Ground".set_cell(Vector2i(x-size/2, y-size/2), 1, _get_tile_index(noise.get_noise_2d(float(x), float(y))))
			# Center == (x-size/2, y-size/2)


func _get_tile_index(noise_sample):
	if noise_sample < -0.15:
		return TILES.waterdark
	elif noise_sample < 0:
		return TILES.water
	elif noise_sample < 0.06:
		return TILES.sand
	elif noise_sample < 0.2:
		return TILES.grass
	elif noise_sample < 0.34:
		return TILES.grassdark
	elif noise_sample < 0.6:
		return TILES.rock
	elif noise_sample < 0.7:
		return TILES.snow
	return TILES.snow
