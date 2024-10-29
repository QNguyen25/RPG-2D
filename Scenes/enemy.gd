extends CharacterBody2D


@export var speed = 50.0
var direction: Vector2
var new_direction = Vector2(0, 1)

var rng = RandomNumberGenerator.new()

var timer = 0

var player = get_tree().root.get_node("main/player")

func _ready():
	rng.randomize()


func _physics_process(delta):
	var movement = speed * direction * delta
	var collision = move_and_collide(movement)
	
	
	


func _on_timer_timeout():
	pass # Replace with function body.
