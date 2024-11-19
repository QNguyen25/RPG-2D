extends Area2D

@onready var tilemap = get_tree().root.get_node("Main")
var direction : Vector2
var speed = 80


@onready var animated_sprite = $AnimatedSprite2D
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position = position + speed * delta * direction
	

func _on_body_entered(body):
	if body.name == "Player":
		return
		
	#f tilemap.get_layer_name("Water"):
		#eturn
		#f tilemap.get_layer_name("Object"):
			#eturn
	
	if body.name == "Items":
		return
		
	if body.is.in_group("enemies"):
		return
		
	direction= Vector2.ZERO
	animated_sprite.play("impact")


func _on_animated_sprite_2d_animation_finished():
	if animated_sprite.animation == "impact":
		get_tree().queue_delete(self)


func _on_timer_timeout():
	animated_sprite.play("impact")
