class_name BattleManager
extends Node

signal turn_started(combatant: Combatant)
signal turn_ended(combatant: Combatant)
signal battle_won
signal battle_lost

enum State { IDLE, PLAYER_TURN, ENEMY_TURN, VICTORY, DEFEAT }

var state: State = State.IDLE
var party: Array[Combatant] = []
var enemies: Array[Combatant] = []
var turn_order: Array[Combatant] = []
var turn_index: int = 0
var round_number: int = 0

func start_battle(p_party: Array[Combatant], p_enemies: Array[Combatant]) -> void:
	party = p_party
	enemies = p_enemies
	round_number = 0
	_start_new_round()

func end_turn(combatant: Combatant) -> void:
	turn_ended.emit(combatant)
	turn_index += 1
	if not _check_battle_over():
		_advance_turn()

func get_current_combatant() -> Combatant:
	return turn_order[turn_index] if turn_index < turn_order.size() else null

func is_boss_battle() -> bool:
	return enemies.any(func(e): return e.is_boss)

func _start_new_round() -> void:
	round_number += 1
	turn_order = _build_turn_order()
	turn_index = 0
	_advance_turn()

func _build_turn_order() -> Array[Combatant]:
	var combatants: Array[Combatant] = []
	combatants.append_array(party)
	combatants.append_array(enemies)
	combatants = combatants.filter(func(c): return c.is_alive())
	combatants.sort_custom(func(a, b): return a.speed > b.speed)
	return combatants

func _advance_turn() -> void:
	if _check_battle_over():
		return
	if turn_index >= turn_order.size():
		_start_new_round()
		return
	var current := turn_order[turn_index]
	if not current.is_alive():
		turn_index += 1
		_advance_turn()
		return
	state = State.PLAYER_TURN if current.team == Combatant.Team.PLAYER else State.ENEMY_TURN
	turn_started.emit(current)

func _check_battle_over() -> bool:
	if not enemies.any(func(e): return e.is_alive()):
		state = State.VICTORY
		battle_won.emit()
		return true
	if not party.any(func(p): return p.is_alive()):
		state = State.DEFEAT
		battle_lost.emit()
		return true
	return false
