extends Control

@onready var _options: UI_Window = $Options
@onready var _options_menu: Menu = $Options/Margin/Options
@onready var _battle_manager: BattleManager = $BattleManager

func _ready() -> void:
	_options_menu.connect_to_button(self)
	_options.opened.connect(func(): _options_menu.button_focus(0))

	_battle_manager.turn_started.connect(_on_turn_started)
	_battle_manager.battle_won.connect(_on_battle_won)
	_battle_manager.battle_lost.connect(_on_battle_lost)

	# Placeholder combatants until real party/enemy data exists
	var party: Array[Combatant] = [_make_test_combatant("Hero", Combatant.Team.PLAYER, 30, 12)]
	var enemies: Array[Combatant] = [_make_test_combatant("Cultist", Combatant.Team.ENEMY, 20, 8)]
	_battle_manager.start_battle(party, enemies)

func _on_turn_started(combatant: Combatant) -> void:
	if combatant.team == Combatant.Team.PLAYER:
		_options.open()
	else:
		_options.close()
		# TODO: enemy AI picks an action, then call _battle_manager.end_turn(combatant)

func _on_options_button_focused(button: BaseButton) -> void:
	pass

func _on_options_button_pressed(button: BaseButton) -> void:
	match button.name:
		"Attack":
			pass
		"Use":
			pass
		"Psychokinesis":
			pass
		"Retreat":
			pass
		"Sin":
			pass
	# once the chosen action fully resolves:
	# _battle_manager.end_turn(_battle_manager.get_current_combatant())

func _on_battle_won() -> void:
	print("Victory!")

func _on_battle_lost() -> void:
	print("Defeat...")

func _make_test_combatant(display_name: String, team: Combatant.Team, hp: int, speed: int) -> Combatant:
	var c := Combatant.new()
	c.display_name = display_name
	c.team = team
	c.max_hp = hp
	c.speed = speed
	c.reset_hp()
	return c
