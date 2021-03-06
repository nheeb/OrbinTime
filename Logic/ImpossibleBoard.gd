extends Spatial

export var dim_x = 3
export var dim_y = 3

export var texture: Texture

# tile references
onready var tiles = [[$Tile11, $Tile12, $Tile13], [$Tile21, $Tile22, $Tile23], [$Tile31, $Tile32, $Tile33]]

signal puzzle_won

func _ready() -> void:
	for tile_row in tiles:
		for tile in tile_row:
			tile.get_node("Mesh/Sprite3D").texture = texture
			tile.connect("flipped", self, "register_tile_change")

func check_victory() -> bool:
	for tile_row in tiles:
		for tile in tile_row:
			if not tile.is_flipped:
				return false
	return true

func reset():
	for tile_row in tiles:
		for tile in tile_row:
			if tile.is_flipped != tile.flipped_in_beginning:
				tile.flip()

func diagonal_condition(x_flipped, y_flipped, x_other, y_other):
	# possible to solve in 3x3 but pretty difficult, easy with a weight
	if y_flipped-1 == y_other and x_flipped + 1 == x_other:
		return true
	if y_flipped-1 == y_other and x_flipped - 1 == x_other:
		return true
	if y_flipped+1 == y_other and x_flipped + 1 == x_other:
		return true
	if y_flipped+1 == y_other and x_flipped - 1 == x_other:
		return true
	return false
	
func cardinal_condition(x_flipped, y_flipped, x_other, y_other):
	if y_flipped-1 == y_other and x_flipped == x_other:
		return true
	if y_flipped+1 == y_other and x_flipped == x_other:
		return true
	if y_flipped == y_other and x_flipped + 1 == x_other:
		return true
	if y_flipped == y_other and x_flipped - 1 == x_other:
		return true

func check_flip_condition(x_flipped, y_flipped, x_other, y_other) -> bool:
	# flip everything
	if x_flipped != x_other or y_flipped != y_other:
		return true
	else:
		return false

func register_tile_change(x, y):
	# changing rule, which tiles will flip as well
	for tile_row in tiles:
		for tile in tile_row:
			if check_flip_condition(x, y, tile.x, tile.y):
				# if there's a weight on here don't flip
				if Game.weight_x == tile.x and Game.weight_y == tile.y:
					pass # don't flip
				else:
					tile.flip()
	
	if check_victory():
		emit_signal("puzzle_won")
