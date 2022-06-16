extends Spatial

export var dim_x = 3
export var dim_y = 3

# tile references
onready var tiles = [[$Tile11, $Tile12, $Tile13], [$Tile21, $Tile22, $Tile23], [$Tile31, $Tile32, $Tile33]]


func _ready() -> void:
	for tile_row in tiles:
		for tile in tile_row:
			tile.connect("flipped", self, "register_tile_change")

func check_victory() -> bool:
	for tile_row in tiles:
		for tile in tile_row:
			if not tile.is_flipped:
				return false
	return true

func check_flip_condition(x_flipped, y_flipped, x_other, y_other) -> bool:
	# als erstes: rechts davon wird geflippt
	if y_flipped == y_other and x_flipped + 1 == x_other:
		return true
	return false

func register_tile_change(x, y):
	# changing rule, which tiles will flip as well
	for tile_row in tiles:
		for tile in tile_row:
			if check_flip_condition(x, y, tile.x, tile.y):
				tile.flip()
	
	if check_victory():
		print("wow you won")
