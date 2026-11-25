extends "res://tests/test_case.gd"


func test_a_tick_moves_the_dragon_head() -> void:
	var session := Session.new(Vector2i(10, 10))
	session.tick()
	assert_eq(session.dragon.body[0], Vector2i(6, 5))


func test_the_dragon_starts_on_open_floor_inside_a_wall() -> void:
	var session := Session.new(Vector2i(10, 10))
	assert_true(session.board.is_solid(Vector2i(0, 0)))
	assert_true(not session.board.is_solid(session.dragon.body[0]))

func test_food_grows_dragon() -> void:
	var session := Session.new(Vector2i(10, 10))
	var start_length := session.dragon.body.size()
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
	