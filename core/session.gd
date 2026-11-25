## One run at the game: the board and the dragon on it, from the first tick until the
## run ends. Rules that involve more than the dragon (food, score, what the dragon can
## run into) belong here, so Dragon stays about movement and app/ only draws.
class_name Session
extends RefCounted

var board: Board
var dragon: Dragon

var food: Vector2i = Vector2i(-1,-1)
var score:= 0
var random:= RandomNumberGenerator.new()

func _init(grid_size: Vector2i) -> void:
	board = Board.bordered(grid_size)
	dragon = Dragon.new(grid_size)
	random.seed = 121;
	food_spawn()

func food_spawn() -> void:
	var cells_free: Array[Vector2i] = []
	for cell in board.tiles:
		if not board.is_solid(cell) and cell not in dragon.body:
			cells_free.append(cell)

	if cells_free.is_empty():
		food = Vector2i(-1,-1)
		return
	food = cells_free[random.randi_range(0, cells_free.size()-1)]


## One step of the rules. TODO for D4: food, growth, and collisions with the dragon's
## own body and with solid tiles (board.is_solid). Each needs the dragon and something
## else, which is why they go here rather than in Dragon.tick.
func tick() -> void:
	var last_tail: Vector2i = dragon.body.back()
	dragon.tick()
	if dragon.body[0] == food:
		dragon.body.append(last_tail)
		score +=1
		food_spawn()
