extends "res://tests/test_case.gd"


func test_a_tick_moves_the_dragon_head() -> void:
	var session := Session.new(Vector2i(10, 10))
	session.started = true
	session.tick()
	assert_eq(session.dragon.body[0], Vector2i(6, 5))


func test_the_dragon_starts_on_open_floor_inside_a_wall() -> void:
	var session := Session.new(Vector2i(10, 10))
	assert_true(session.board.is_solid(Vector2i(0, 0)))
	assert_true(not session.board.is_solid(session.dragon.body[0]))

func test_food_grows_dragon() -> void:
	var session := Session.new(Vector2i(10, 10))
	var start_length := session.dragon.body.size()
	session.started = true
	session.food = Vector2i(6, 5);
	session.tick()
	assert_eq(session.dragon.body[0], Vector2i(6, 5))
	assert_eq(session.dragon.body.size(), start_length + 1);

	
func test_food_spawns_on_free() -> void:
	var session:= Session.new(Vector2i(10,10))
	for i in 60:
		session.food_spawn()
		assert_true(session.food not in session.dragon.body)
		assert_true(not session.board.is_solid(session.food))

func test_hitting_wall_ends_run() -> void:
	var session:= Session.new(Vector2i(10,10))
	session.started = true
	session.dragon.body = [
		Vector2i(8,5),
		Vector2i(7,5),
		Vector2i(6,5),
		Vector2i(5,5)
	]
	session.tick()
	assert_true(session.game_over)
	assert_eq(session.dragon.body[0], Vector2i(8,5))
	
	

func test_biting_the_body_ends_the_run() -> void:
	var session := Session.new(Vector2i(10, 10))
	session.started = true
	session.dragon.body = [
		Vector2i(3, 3),
		Vector2i(3, 4),
		Vector2i(4, 4),
		Vector2i(4, 3),
		Vector2i(5, 3),
	]
	session.tick()
	assert_true(session.game_over)

func test_chasing_old_tail_cell_is_safe() -> void:
	var session:= Session.new(Vector2i(10,10))
	session.food = Vector2i(8,8)
	session.dragon.body = [Vector2i(5, 5), Vector2i(4, 5), Vector2i(4, 6), Vector2i(5, 6)]
	session.turn(Vector2i.DOWN)
	session.tick()
	assert_true(not session.game_over)
	assert_eq(session.dragon.body[0], Vector2i(5, 6))