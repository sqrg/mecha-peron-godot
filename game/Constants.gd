extends Node2D

export var PERON_SPEED: float = 30.0

export var LASER_PLANE_DAMAGE: int = 2
export var LASER_SOLDIER_DAMAGE: int = 3
export var LASER_SOLDIER_BOMB_DAMAGE: int = 6
export var LASER_CANNON_BOMB_DAMAGE: int = 4

export var LASER_MAX_CHARGE: int = 1200
# how much charge the laser consumes and reloads each frame
export var LASER_CHARGE_STEP: int = 10
export var LASER_RECHARGE_STEP: int = 13
export var LASER_RECHARGE_DELAY: float = 2.0 # seconds
export var LASER_ROTATION_MIN: float = deg2rad(-15)
export var LASER_ROTATION_MAX: float = deg2rad(45)

export var FIST_SPEED: float = 200.0
export var FIST_GRAVITY: float = 40.0
export var FIST_RELOAD_TIME: float = 10.0 # seconds

export var PLANE_SPEED: float = -120.0
export var PLANE_BOMB_DAMAGE: int = 5

# how many seconds waits since it's visible to release bomb
export var CANNON_ATTACK_DELAY: float = 3.0
export var CANNON_BOMB_SPEED: float = 60.0
export var CANNON_BOMB_DAMAGE: int = 10

export var SOLDIER_BULLET_SPEED: float = -50.0
export var SOLDIER_BULLET_DAMAGE: int = 2
