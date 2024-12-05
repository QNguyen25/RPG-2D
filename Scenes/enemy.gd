extends CharacterBody2D

var health = 100
var max_health = 100
var regen_health = 1
@export var speed = 50.0
var direction: Vector2
var new_direction = Vector2(0, 1)


var rng = RandomNumberGenerator.new()

var timer = 0

var animation 
@onready var timer_node = $Timer
@onready var animation_player = $AnimationPlayer
@onready var animation_sprite = $AnimatedSprite2D
@onready var player = $"../Player"
var is_attacking = false

signal death

func _ready():
	rng.randomize()
	animation_sprite.modulate = Color(1, 1, 1, 1)


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
		direction = Vector2.ZERO
	#chasea
	
	elif  player_distance.length() <= 100 and timer == 0:
		direction = player_distance.normalized()
		
	#random room
	
	elif timer == 0:
		var random_direction = rng.randf()
		#chill
		if random_direction < 0.05:
			direction = Vector2.ZERO
		#hustle
		elif random_direction < 0.1:
			direction = Vector2.DOWN.rotated(rng.randf() * 2 * PI)
		
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
	print(normalized_direction)
	
	if abs(normalized_direction.x) > abs(normalized_direction.y):
		if normalized_direction.x > 0:
			animation_sprite.flip_h = false
			return "side"
			
		else:
			animation_sprite.flip_h = true
			return "side"
	
	if normalized_direction.y > 0 and normalized_direction.x == 0 :
		return "front"
		
	elif normalized_direction.y < 0 and normalized_direction.x == 0 :
		return "back"
		
		
	return default_return
	
func hit(damage):
	health -= damage
	if health > 0:
		is_attacking = true
		animation_sprite.play("hit_front")
		print(animation_sprite.animation)
		animation_player.play("damaged")
		await get_tree().create_timer(2).timeout
		is_attacking = false
		
	else:
		timer_node.stop()
		set_process(false)
		is_attacking = true
		direction = Vector2.ZERO
		animation_sprite.play("death_front")
		
		death.emit()
	
func _on_animated_sprite_2d_animation_finished():
	if animation_sprite.animation == "death_front":
		get_tree().queue_delete(self)
		is_attacking = false


func _on_animation_player_animation_finished(anim_name):
		animation_sprite.modulate = Color(1, 1, 1, 1)
