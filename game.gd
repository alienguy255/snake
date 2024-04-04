extends MarginContainer

signal game_over()
signal food_eaten()

#@onready
#var _snake: PackedScene = get_meta("snake")

var _random:= RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	print("Game _ready() called")

func _on_start_game_button_pressed():
	# TODO: might be better to switch scenes at this point
	get_node("HUDContainer").get_node("ButtonContainer").visible = false
	add_child(_create_snake(_generate_snake_position()))
	
	# create multiple food objects
	for i in 5:
		var food : Node2D = _create_food(_generate_food_position())
		add_child(food)
		food.add_to_group("food", false)
		
	$Timer.start()

func _create_snake(snake_pos: Vector2i) -> Node2D:
	var snake_meta: PackedScene = get_meta("snake")
	var snake := snake_meta.instantiate()
	snake.initialize(3, snake_pos, Vector2i.UP)
	return snake

func _create_food(food_pos: Vector2i) -> Node2D:
	var snake_food_meta: PackedScene = get_meta("snake_food")
	var snake_food := snake_food_meta.instantiate()
	snake_food.set_position(food_pos)
	return snake_food
	
func _on_timer_timeout():
	$Snake.move()
	
	if $Snake.is_colliding():
		print("snake collided, need to signal game over")
	
	# check if snake is eating any of the food nodes placed on the board
	# TODO: gotta be a more efficient way to do this, dict?
	for n in get_tree().get_nodes_in_group("food"):
		if n.get_position() == $Snake.get_head_node().get_position():
			n.set_position(_generate_food_position())
			$Snake.grow()
			food_eaten.emit()
			break

func _generate_snake_position() -> Vector2i:
	return Vector2i(_random.randi_range(1, 20) * 10, _random.randi_range(1, 20) * 10)

func _generate_food_position() -> Vector2i:
	# TODO: need to place food in a new cell not part of snake or not already food
	# TODO: need to determine grid size in order to specify the right numbers below
	return Vector2i(_random.randi_range(1, 20) * 10, _random.randi_range(1, 20) * 10)
	
func _input(event):
	if event.is_action_pressed("right"):
		$Snake.set_direction(Vector2i.RIGHT)
	elif event.is_action_pressed("left"):
		$Snake.set_direction(Vector2i.LEFT)
	elif event.is_action_pressed("up"):
		$Snake.set_direction(Vector2i.UP)
	elif event.is_action_pressed("down"):
		$Snake.set_direction(Vector2i.DOWN)

