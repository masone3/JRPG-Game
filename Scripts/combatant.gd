class_name Combatant
extends Resource

enum Team { PLAYER, ENEMY }

@export var display_name: String = "Combatant"
@export var team: Team = Team.PLAYER
@export var max_hp: int = 10
@export var speed: int = 10
@export var level: int = 1
@export var is_boss: bool = false

var current_hp: int

func _init() -> void:
	reset_hp()

func reset_hp() -> void:
	current_hp = max_hp

func is_alive() -> bool:
	return current_hp > 0

func take_damage(amount: int) -> void:
	current_hp = max(current_hp - amount, 0)

func heal(amount: int) -> void:
	current_hp = min(current_hp + amount, max_hp)
