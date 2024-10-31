extends CharacterBody2D


@export var speed = 100.0
var direction: Vector2
var new_direction = Vector2(0, 1)

var rng = RandomNumberGenerator.new()

var timer = 0

var animation 
@onready var animation_sprite = $AnimatedSprite2D
@onready var player = $"../Player"
var is_attacking = false

func _ready():
	rng.randomize()


func _physics_process(delta):
	var movement = speed * direction * delta
	var collision = move_and_collide(movement)
	
	if collision != null and collision.get_collider().name != "Player":
		direction = direction.rotated(rng.randf_range(PI/4, PI/2))
		timer = rng.randf_range(2, 5)
		
	else:
		timer = 0
		
	if !is_attacking:
		enemy_animations(direction)

func _on_timer_timeout():
	
	print(player)
	var player_distance = player.position - position
	#attack
	if player_distance.length() <= 20:
		new_direction = player_distance.normalized()
		sync_new_direction()
		direction = Vector2.ZERO
	#chasea
	
	elif  player_distance.length() <= 100 and timer == 0:
		direction = player_distance.normalized()
		sync_new_direction()
		
	#random room
	
	elif timer ==0:
		var random_direction = rng.randf()
		#chill
		if random_direction < 0.05:
			direction = Vector2.ZERO
		#hustle
		elif random_direction < 0.1:
			direction = Vector2.DOWN.rotated(rng.randf() * 2 * PI)
		sync_new_direction()
		
func enemy_animations(direction: Vector2):
	if direction != Vector2.ZERO:
		new_direction = direction
		animation = "walk_" + returned_direction(new_direction)
		animation_sprite.play(animation)
	else:
		animation = "idle_" + returned_direction(new_direction)
		animation_sprite.play(animation)
		
func returned_direction(direction: Vector2):
	var normalized_direction = direction.normalized()
	var default_return = "side"
	
	if normalized_direction.y > 0 and normalized_direction.x == 0 :
		return "front"
		
	elif normalized_direction.y < 0 and normalized_direction.x == 0 :
		return "back"
		
	elif normalized_direction.x > 0 and normalized_direction.y == 0 :
		animation_sprite.flip_h = false
		return "side"
		
	elif normalized_direction.x < 0 and normalized_direction.y == 0 :
		animation_sprite.flip_h = true
		return "side"
		
		
	return default_return
	
	
func sync_new_direction():
		if direction != Vector2.ZERO:
			new_direction = direction.normalized()

