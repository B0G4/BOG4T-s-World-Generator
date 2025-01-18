extends Node2D

var noise
var vegetation_noise  # Separate noise generator for tree placement

const TILES = {
    "waterdark": Vector2i(0, 2),
    "water": Vector2i(1, 1),
    "sand": Vector2i(2, 0),
    "grass": Vector2i(0, 0),
    "grassdark": Vector2i(1, 0),
    "rock": Vector2i(0, 1),
    "snow": Vector2i(2, 2)
}

const TREE_TYPES = {
    "pine": Vector2i(3, 0),  # Assuming pine tree sprite is at position (3,0) in tileset
    "oak": Vector2i(3, 1),   # Assuming oak tree sprite is at position (3,1) in tileset
}

# Configuration for tree placement
const TREE_DENSITY = 0.6  # Higher values = more trees
const MIN_TREE_NOISE = 0.3  # Minimum vegetation noise value for tree placement
const TREE_SPACING = 2  # Minimum tiles between trees

func generate_world(size=100, seed=1234, octaves=5, lucanarity=2, offset=Vector3.ZERO, frequency=0.01) -> void:
    # Clear existing tiles
    $"Ground".clear()
    $"Trees".clear()  # Clear the tree layer
    
    # Initialize main terrain noise
    randomize()
    noise = FastNoiseLite.new()
    noise.noise_type = FastNoiseLite.TYPE_PERLIN
    noise.seed = seed
    noise.fractal_octaves = octaves
    noise.fractal_lacunarity = lucanarity
    noise.offset = offset
    noise.frequency = frequency
    
    # Initialize vegetation noise with different parameters
    vegetation_noise = FastNoiseLite.new()
    vegetation_noise.noise_type = FastNoiseLite.TYPE_PERLIN
    vegetation_noise.seed = seed + 1  # Different seed for variety
    vegetation_noise.fractal_octaves = 3  # Fewer octaves for smoother tree distribution
    vegetation_noise.fractal_lacunarity = lucanarity
    vegetation_noise.frequency = frequency * 2  # Higher frequency for more local variation
    
    # Generate base terrain
    for x in size:
        for y in size:
            var pos = Vector2i(x-size/2, y-size/2)
            var noise_val = noise.get_noise_2d(float(x), float(y))
            
            # Place ground tiles
            $"Ground".set_cell(pos, 1, get_tile_index(noise_val))
            
            # Try to place trees on grass and dark grass areas
            if can_place_tree(pos, noise_val):
                place_tree(pos, vegetation_noise.get_noise_2d(float(x), float(y)))

func get_tile_index(noise_sample):
    if noise_sample < -0.1:
        return TILES.waterdark
    elif noise_sample < -0.02:
        return TILES.water
    elif noise_sample < 0.02:
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

func can_place_tree(pos: Vector2i, noise_val: float) -> bool:
    # Check if we're on suitable terrain (grass or dark grass)
    if noise_val < 0.02 or noise_val >= 0.6:
        return false
        
    # Check for nearby trees to maintain spacing
    for dx in range(-TREE_SPACING, TREE_SPACING + 1):
        for dy in range(-TREE_SPACING, TREE_SPACING + 1):
            var check_pos = pos + Vector2i(dx, dy)
            if $"Trees".get_cell_source_id(check_pos) != -1:  # -1 means no tile
                return false
                
    return true

func place_tree(pos: Vector2i, vegetation_val: float) -> void:
    # Only place trees if vegetation noise is above threshold and passes density check
    if vegetation_val > MIN_TREE_NOISE and randf() < TREE_DENSITY:
        # Choose tree type based on elevation (noise value)
        var tile = TREE_TYPES.pine if vegetation_val > 0.5 else TREE_TYPES.oak
        $"Trees".set_cell(pos, 1, tile)

# Optional: Add seasonal variations
func update_season(season: String) -> void:
    match season:
        "summer":
            # Normal colors
            pass
        "autumn":
            # Change tree colors to autumn variations
            # You would need autumn variants in your tileset
            pass
        "winter":
            # Add snow effects
            pass
        "spring":
            # Add flowering effects
            pass
