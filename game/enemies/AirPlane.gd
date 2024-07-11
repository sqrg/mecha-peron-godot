class_name AirPlane
extends Node2D

signal bomb_dropped

@onready var width: int = $plane.texture.get_width() / $plane.hframes
@onready var health_bar: HealthBar = $HealthBar as HealthBar

var health: int = 100
var hurting = false
var falling = false
var did_drop = false

var player: Peron

# sin movement
const SIN_FACTOR: float = 0.03
const SIN_HEIGHT: float = 5.0
var sin_accum: float = 0.0
var initial_y: float = 0

func _ready():
	initial_y = 10 + randi() % 50

func _process(delta: float):
	position.x += Constants.PLANE_SPEED * delta
	sin_accum = fmod(sin_accum + SIN_FACTOR, 2 * PI)
	position.y = initial_y - SIN_HEIGHT * sin(sin_accum)

	if get_meta("destroyed", false):
		return
	if !did_drop:
		drop_bomb()

func drop_bomb():
	var origin_pos = $BombOrigin.global_position
	var target_pos = player.global_position # TODO: point to the center of the character

	# dy = 1/2*g*t^2
	# t = v(dy/(1/2*g))
	var time_to_hit_target = sqrt((target_pos.y - origin_pos.y) / (0.5 * Constants.GRAVITY))
	var pos_x_to_hit = origin_pos.x + Constants.PLANE_SPEED * time_to_hit_target
	if pos_x_to_hit < target_pos.x:
		did_drop = true
		bomb_dropped.emit(position + $BombOrigin.position)
