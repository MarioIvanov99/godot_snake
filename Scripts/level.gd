extends Node

var segments = []
var segment_scene = preload("res://Scenes/segment.tscn")
var direction = 1
var isGrowing = false
var gameOver = false
# Called when the node enters the scene tree for the first time.
func _ready():
	var segment1 = segment_scene.instantiate()
	segment1.position = Vector2(128, 0)
	segments.append(segment1)
	add_child(segment1)
	var segment2 = segment_scene.instantiate()
	segment2.position = Vector2(64, 0)
	segments.append(segment2)
	add_child(segment2)
	var segment3 = segment_scene.instantiate()
	segment3.position = Vector2(0, 0)
	segments.append(segment3)
	add_child(segment3)
	
	var isSame = true
	$Apple.position = respawn_apple()

func respawn_apple():
	var rng = RandomNumberGenerator.new()
	var randomX = rng.randi_range(0, 17)
	var randomY = rng.randi_range(0, 8)
	var apple_position = Vector2(randomX*64, randomY*64)
	
	while(check_apple(apple_position)):
		randomX = rng.randi_range(0, 17)
		randomY = rng.randi_range(0, 8)
		apple_position = Vector2(randomX*64, randomY*64)
	
	return apple_position

func check_apple(apple_position):
	for i in range(segments.size()):
			if(apple_position == segments[i].position):
				return true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(Input.is_action_just_pressed("right")):
		direction = 1
	if(Input.is_action_just_pressed("left")):
		direction = 2
	if(Input.is_action_just_pressed("down")):
		direction = 3
	if(Input.is_action_just_pressed("up")):
		direction = 4
	if(!gameOver):
		for i in range(1, segments.size()):
			if(segments[0].position == segments[i].position):
				game_over()
	if(segments.size() == 0):
		$deathTimer.stop()

func move_snake():
	if(direction == 1): #Right
		return Vector2(segments[0].position.x + 64, segments[0].position.y)
	elif(direction == 2): #Left
		return Vector2(segments[0].position.x - 64, segments[0].position.y)
	elif(direction == 3): #Down
		return Vector2(segments[0].position.x, segments[0].position.y + 64)
	else:
		return Vector2(segments[0].position.x, segments[0].position.y - 64)

func grow_snake(localDirection):
	if(localDirection == 2): #Right
		return Vector2(segments.back().position.x + 64, segments.back().position.y)
	elif(localDirection == 1): #Left
		return Vector2(segments.back().position.x - 64, segments.back().position.y)
	elif(localDirection == 4): #Down
		return Vector2(segments.back().position.x, segments.back().position.y + 64)
	else:
		return Vector2(segments.back().position.x, segments.back().position.y - 64)

func grow():
	var segment = segment_scene.instantiate()
	segment.position = grow_snake(segments.back().localDirection)
	segment.localDirection = segments.back().localDirection
	add_child(segment)
	segments.append(segment)

func game_over():
	gameOver = true
	$moveTimer.stop()
	$deathTimer.start()

func _on_timer_timeout():
	var segment = segment_scene.instantiate()
	segment.position = move_snake()
	segment.localDirection = direction
	remove_child(segments.pop_back())
	add_child(segment)
	segments.push_front(segment)
	if(isGrowing):
		grow()
		isGrowing = false


func _on_apple_eaten():
	$Apple.position = respawn_apple()
	isGrowing = true



func _on_death_timer_timeout():
	remove_child(segments.pop_front())
