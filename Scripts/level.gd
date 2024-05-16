extends Node

var segments = []
var segment_scene = preload("res://Scenes/segment.tscn")
var new_texture_right = preload("res://Assets/head.png")
var new_texture_left = preload("res://Assets/head_left.png")
var new_texture_up = preload("res://Assets/head_up.png")
var new_texture_down = preload("res://Assets/head_down.png")
var old_texture = preload("res://Assets/segment.png")
@onready var destroy_audio = $DestroyAudio
@onready var yay_audio = $YayAudio
@onready var tracker = %Tracker

var direction = 1
var isGrowing = false
var isMoving = true
var gameOver = false

# Called when the node enters the scene tree for the first time.
func _ready():
	var segment1 = segment_scene.instantiate()
	segment1.position = Vector2(128, 256)
	segments.append(segment1)
	add_child(segment1)
	var segment2 = segment_scene.instantiate()
	segment2.position = Vector2(64, 256)
	segments.append(segment2)
	add_child(segment2)
	var segment3 = segment_scene.instantiate()
	segment3.position = Vector2(0, 256)
	segments.append(segment3)
	add_child(segment3)
	
	var isSame = true
	$Apple.position = respawn_apple()
	
	$VictoryMessage.visible = false

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
	if(tracker.points == 9*18-3):
		$VictoryMessage.visible = true
		$moveTimer.stop()

	if(isMoving):
		if(Input.is_action_just_pressed("right") && direction != 2):
			direction = 1
			isMoving = false
		elif(Input.is_action_just_pressed("left") && direction != 1):
			direction = 2
			isMoving = false
		elif(Input.is_action_just_pressed("down") && direction != 4):
			direction = 3
			isMoving = false
		elif(Input.is_action_just_pressed("up") && direction != 3):
			direction = 4
			isMoving = false
	if(!gameOver):
		for i in range(1, segments.size()):
			if(segments[0].position == segments[i].position):
				game_over()
	if(segments.size() == 0):
		$deathTimer.stop()
		if (!$DestroyAudio.playing):
			get_tree().change_scene_to_file("res://Scenes/game_over.tscn")

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
	
	var texture_rect = segment.get_node("Texture")
	if(direction == 1):
		texture_rect.texture = new_texture_right
	elif(direction == 2):
		texture_rect.texture = new_texture_left
	elif(direction == 3):
		texture_rect.texture = new_texture_down
	else:
		texture_rect.texture = new_texture_up
	
	var texture_rect_prev = segments[0].get_node("Texture")
	texture_rect_prev.texture = old_texture
	
	remove_child(segments.pop_back())
	add_child(segment)
	segments.push_front(segment)
	if(isGrowing):
		grow()
		isGrowing = false
	isMoving = true


func _on_apple_eaten():
	$Apple.position = respawn_apple()
	isGrowing = true



func _on_death_timer_timeout():
	remove_child(segments.pop_front())
	destroy_audio.play()



func _on_border_body_entered(body):
	game_over()


func _on_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/level.tscn")


func _on_button_2_pressed():
	get_tree().change_scene_to_file("res://Scenes/menu.tscn")
