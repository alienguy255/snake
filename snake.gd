extends Node2D

var direction: Vector2i

# Called when the node enters the scene tree for the first time.
func _ready():
	print("adding snake")

func initialize(size: int, start_pos: Vector2i, start_direction: Vector2i) -> void:
	direction = start_direction
	for _i in size:
		add_child(_create_snake_segment(start_pos))
		start_pos -= (direction * 10)

func _create_snake_segment(snake_seg_pos: Vector2i) -> Node2D:
	var snake_seg_meta: PackedScene = get_meta("snake_segment")
	var snake_seg := snake_seg_meta.instantiate()
	snake_seg.set_position(snake_seg_pos)
	return snake_seg
	
func move() -> void:
	# calculate the new coords of the head based on the direction its moving
	var x:= get_head_node().get_position().x + (direction.x * 10)
	var y:= get_head_node().get_position().y + (direction.y * 10)
	
	# update the tail to be the coords of the new head
	get_tail_node().set_position(Vector2i(x, y))
	
	# move tail to the front, making it the head
	move_child(get_tail_node(), 0)

func grow() -> void:
	# calculate the new coords of the head based on the direction its moving
	var x:= get_head_node().get_position().x + (direction.x * 10)
	var y:= get_head_node().get_position().y + (direction.y * 10)
	
	# instead of moving the tail to the head, add a new snake seg node
	# and move it to the front, making it the head
	var snake_seg: Node2D = _create_snake_segment(Vector2i(x, y))
	add_child(snake_seg)
	move_child(snake_seg, 0)

func set_direction(dir: Vector2i) -> void:
	direction = dir

func is_colliding() -> bool:	
	var head_pos: Vector2 = get_head_node().get_position()
	return get_children().slice(1).any(func(n): return n.position == head_pos)

func is_eating(food_pos: Vector2i) -> bool:
	var head_pos: Vector2i = get_head_node().get_position()
	return head_pos == food_pos

#func is_eating_1(foods_pos: Array[Vector2i]) -> bool:
	#var head_pos: Vector2i = get_head_node().get_position()
	#return foods_pos.any(func(n): return n.position == head_pos)
	
func get_head_node() -> Node2D:
	return get_child(0)
	
func get_tail_node() -> Node2D:
	return get_child(-1)
