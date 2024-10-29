extends CharacterBody2D


@export var speed = 50.0
@export var recoil = -5.0
@onready var animation_sprite = $AnimatedSprite2D
var new_direction: Vector2 = Vector2.ZERO
var animation
var is_attacking = false


func _physics_process(delta):
	var direction: Vector2 = Vector2.ZERO
	direction.x = Input.get_action_strength("right") - Input.get_action_strength("left") 
	direction.y = Input.get_action_strength("down") - Input.get_action_strength("up") 
	
	if abs(direction.x) == 1 and abs(direction.y) == 1:
		direction = direction.normalized()
	
	if Input.is_action_pressed("sprint"):
		speed = 100
		animation_sprite.speed_scale = 2
	elif Input.is_action_just_released("sprint"):
		speed = 50
		animation_sprite.speed_scale = 1
		
	#var movement = direction * speed * delta 
	print(is_attacking)
	if is_attacking == false:
		var movement = direction * speed * delta
		move_and_collide(movement)
		player_animations(direction)
	
	
func player_animations(direction: Vector2):
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
		
		#### diagonal movement
		
	elif normalized_direction.y > 0 and normalized_direction.x > 0 :
		animation_sprite.flip_h = true
		return "angleDown"
		
	elif normalized_direction.y > 0 and normalized_direction.x < 0 :
		animation_sprite.flip_h = true
		return "angleDown"
		
	elif normalized_direction.x > 0 and normalized_direction.y > 0 :
		animation_sprite.flip_h = true
		return "angleUp"
		
	elif normalized_direction.x > 0 and normalized_direction.y < 0 :
		animation_sprite.flip_h = true
		return "angleUp"
		
		
		
		
		
	return default_return
	
func _input(event):
	if event.is_action_pressed("shoot"):
		print("shooting")
		is_attacking = true 
		animation = "attack_" + returned_direction(new_direction)
		animation_sprite.play(animation)
		
func _on_animated_sprite_2d_animation_finished():
	print("Finished animation")
	is_attacking = false
