extends CharacterBody2D

var health = 100
var max_health = 100
var regen_health = 10

var stamina = 100
var max_stamina = 100
var regen_stamina = 25

signal health_updated
signal stamina_updated

signal ammo_amount_updated
signal health_amount_updated
signal stamina_amount_updated

enum Pickups { AMMO, STAMINA, HEALTH }
var health_pickup_updated
var stamina_pickup_updated

var ammo_amount = 10000

@export var speed = 50.0
@export var recoil = -5.0
@export var stamina_decrease = 0.8
@onready var animation_sprite = $AnimatedSprite2D
var new_direction: Vector2 = Vector2.ZERO
var animation
var is_attacking = false

#@onready var bullet_scene = preload("res://bullet.tscn")
var bullet_damage = 30
var bullet_reload_time = 1000
var bullet_fired_time = 0.5


func _process(delta):
	var updated_health = min(health + regen_health * delta, 100, max_health)
	if updated_health != health:
		health = updated_health
		health_updated.emit(health, max_health)
		
	var updated_stamina = min(stamina + regen_stamina * delta, 100, max_stamina)
	if updated_stamina != stamina:
		stamina= updated_stamina
		stamina_updated.emit(stamina, max_stamina)
	
	
	
func _physics_process(delta):
	var direction: Vector2 = Vector2.ZERO
	direction.x = Input.get_action_strength("right") - Input.get_action_strength("left") 
	direction.y = Input.get_action_strength("down") - Input.get_action_strength("up") 
	
	if abs(direction.x) == 1 and abs(direction.y) == 1:
		direction = direction.normalized()
	
	if Input.is_action_pressed("sprint") && stamina >= 0:
		if stamina >= 0:
			speed = 100
		animation_sprite.speed_scale = 2
		stamina = stamina - stamina_decrease
		stamina_updated.emit(stamina, max_stamina)
		
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
	
	
	return default_return
	
	
	
func _input(event):
	if event.is_action_pressed("shoot"):
		
		var now = Time.get_ticks_msec()
		if now >= bullet_fired_time and ammo_amount > 0:
			is_attacking = true 
		animation = "attack_" + returned_direction(new_direction)
		animation_sprite.play(animation)
		bullet_fired_time = now + bullet_reload_time
		ammo_amount = ammo_amount - 1
		ammo_amount_updated.emit(ammo_amount)
		
		
func _on_animated_sprite_2d_animation_finished():

	is_attacking = false
	if animation_sprite.animation.begins_with("attack_"):
		var bullet = Global.bullet_scene.instantiate()
		bullet_damage = bullet_damage
		bullet.direction = new_direction.normalized()
		bullet.position = position + new_direction.normalized() * 4
		get_tree().root.get_node("Main").add_child(bullet)
	
	
func add_pickup(item):
	if item == Pickups.AMMO:
		ammo_amount = ammo_amount
		ammo_amount_updated.emit(ammo_amount)
