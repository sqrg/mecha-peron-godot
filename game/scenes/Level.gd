class_name Level
extends Node2D

const AirplaneScene = preload("res://game/enemies/Airplane.tscn")
const BombScene = preload("res://game/enemies/Bomb.tscn")
const EnemyBuildingScene = preload("res://game/enemies/EnemyBuilding.tscn")

enum { PRE_INTRO, INTRO, POST_INTRO }
var intro_state = PRE_INTRO

@onready var main_layer = $Camera2D/ParallaxBackground/MainLayer
@onready var front_layer = $Camera2D/ParallaxBackground/FrontLayer
@onready var foreground = $Camera2D/ParallaxBackground/FrontLayer/Foreground
@onready var peron: Peron = $Camera2D/ParallaxBackground/MainLayer/Peron as Peron
@onready var camera = $Camera2D

func _ready():
	foreground.target = peron
	foreground.main_layer = weakref(self.main_layer)

func _process(_delta: float):
	update_intro()
	update_foreground()

	if intro_state != POST_INTRO:
		return

	camera.position.x = peron.position.x
	input()

func update_intro():
	match intro_state:
		PRE_INTRO:
			if peron.position.x > 0:
				intro_state = INTRO
				Engine.time_scale = 1
				peron.idle()
			if Input.is_action_just_pressed("ui_accept"):
				Engine.time_scale = 4;
		INTRO:
			if Input.is_action_just_pressed("ui_accept"):
				intro_state = POST_INTRO
				Engine.time_scale = 1
				peron.walk()

func input():
	var mouse_pressed = Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT)

	if peron.shooting_laser:
		if mouse_pressed:
			rotate_laser()
		else:
			end_laser()

	if peron.is_attacking():
		return
	
	if Input.is_action_just_pressed("attack_fist"):
		peron.attack_fist()
	if Input.is_action_just_pressed("attack_arm"):
		peron.attack_arm()
	if mouse_pressed:
		laser()

func laser():
	peron.laser()
	rotate_laser()

func end_laser():
	peron.laser_reverse()

func rotate_laser():
	peron.point_laser(get_viewport().get_mouse_position())

func update_foreground():
	var screen_right = (camera.position.x + get_viewport_rect().size.x) *  front_layer.motion_scale.x
	foreground.update_buildings(screen_right)

func _on_AIDirector_enemy_needed(enemy_type, x):
	match enemy_type:
		"plane":
			spawn_plane(x)
		"building":
			spawn_building(x)
		"cannon":
			foreground.prepare_cannon()

func spawn_plane(x: float):
	var plane: Airplane = AirplaneScene.instantiate() as Airplane
	plane.position.x = get_viewport_rect().size.x + x
	plane.target = peron
	plane.drop_bomb.connect(_on_plane_drop_bomb)
	main_layer.add_child(plane)

func spawn_building(x: float):
	var enemy_building: EnemyBuilding = EnemyBuildingScene.instantiate() as EnemyBuilding
	enemy_building.main_layer = weakref(self.main_layer) 
	enemy_building.position.y = get_viewport_rect().size.y
	enemy_building.position.x = get_viewport_rect().size.x + x
	main_layer.add_child(enemy_building)

func _on_plane_drop_bomb(bomb_position: Vector2):
	var bomb: Bomb = BombScene.instantiate() as Bomb
	bomb.position = bomb_position
	main_layer.add_child(bomb)
