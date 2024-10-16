extends CharacterBody2D


@export var speed = 50.0
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

	var movement = direction * speed * delta 

	if is_attacking == false:
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
	
	if normalized_direction.y > 0:
		return "front"
		
	elif normalized_direction.y < 0:
		return "back"
		
	elif normalized_direction.x > 0:
		animation_sprite.flip_h = false
		return "side"
		
	elif normalized_direction.x < 0:
		animation_sprite.flip_h = true
		return "side"
		
	return default_return
	
func _input(event):
	if event.is_action_pressed("shoot"):
		is_attacking = true 
		animation = "attack_" + returned_direction(new_direction)
