extends CharacterBody2D


@export var speed = 50.0


func _physics_process(delta):
	var direction: Vector2 = Vector2.ZERO
	direction.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	direction.y = Input.get_action_strength("up") - Input.get_action_strength("down")
	
	if abs(direction.x) == 1 and abs(direction.y) == 1

	move_and_slide()
