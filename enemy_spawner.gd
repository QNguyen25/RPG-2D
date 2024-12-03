extends Node2D


@onready var spawned_enemies = $SpawnedEnemies
@onready var tilemap = get_tree().root.get_node("Main/tilemap")

@export var max_enemies = 20
var enemy_count = 0
var rng = RandomNumberGenerator.new()



func _ready():
	pass # Replace with function body.
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
