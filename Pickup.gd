extends Area2D


enum Pickups { AMMO, STAMINA, HEALTH }
@export var item : Pickups

@onready var sprite = $Sprite2D

var ammo_texture = preload("res://Assets/Icons/pearl_01b.png")
var stamina_texture = preload("res://Assets/Icons/pearl_01b.png")
var health_texture = preload("res://Assets/Icons/pearl_01b.png")

signal health_updated
signal stamina_updated
signal ammo_amount_updated
signal health_amount_updated
signal stamina_amount_updated


func _ready():
	if not Engine.is_editor_hint():
		if item == Pickups.AMMO:
			sprite.set_texture(ammo_texture)
		elif item == Pickups.HEALTH:
			sprite.set_texture(health_texture)
		elif item == Pickups.STMAINA:
			sprite.set_texture(stamina_texture)

func _process(delta):
	if Engine.is_editor_hint():
		if item == Pickups.AMMO:
			sprite.set_texture(ammo_texture)
		elif item == Pickups.HEALTH:
			sprite.set_texture(health_texture)
		elif item == Pickups.STMAINA:
			sprite.set_texture(stamina_texture)


func _on_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	if body.name == "Player"
