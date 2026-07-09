class_name Menu
extends Container

signal button_focused(button: BaseButton)
signal button_pressed(button: BaseButton)

## If true, focus wraps between buttons using arrow keys based on container type.
@export var auto_wrap: bool = true

var index: int = 0

func _ready() -> void:
	for button in get_buttons():
		button.focus_entered.connect(_on_button_focused.bind(button))
		button.pressed.connect(_on_button_pressed.bind(button))

	if auto_wrap:
		_apply_focus_neighbors()

## Only returns actual BaseButton children (ignores labels, margins, etc.)
func get_buttons() -> Array[BaseButton]:
	var buttons: Array[BaseButton] = []
	for child in get_children():
		if child is BaseButton:
			buttons.append(child)
	return buttons

## Connects this menu's signals to target's "_on_<name>_button_focused/pressed" methods.
## Matches the convention used in battle.gd (e.g. node "Options" -> "_on_options_button_focused").
func connect_to_button(target: Object, _name: String = name.to_lower()) -> void:
	var focus_method := "_on_%s_button_focused" % _name
	var press_method := "_on_%s_button_pressed" % _name
	if target.has_method(focus_method):
		button_focused.connect(Callable(target, focus_method))
	if target.has_method(press_method):
		button_pressed.connect(Callable(target, press_method))

func button_focus(n: int = index) -> void:
	var buttons := get_buttons()
	if buttons.is_empty():
		return
	n = clamp(n, 0, buttons.size() - 1)
	index = n
	buttons[n].grab_focus()

func _on_button_focused(button: BaseButton) -> void:
	index = get_buttons().find(button)
	button_focused.emit(button)

func _on_button_pressed(button: BaseButton) -> void:
	button_pressed.emit(button)

## Wires up focus_neighbor_* so arrow keys move between buttons,
## wrapping around at the ends. Direction depends on container layout.
func _apply_focus_neighbors() -> void:
	var buttons := get_buttons()
	var count := buttons.size()
	if count == 0:
		return
	var is_horizontal := is_instance_of(self, HBoxContainer) or is_instance_of(self, GridContainer)
	for i in range(count):
		var current := buttons[i]
		var next_btn := buttons[(i + 1) % count]
		var prev_btn := buttons[(i - 1 + count) % count]
		if is_horizontal:
			current.focus_neighbor_right = current.get_path_to(next_btn)
			current.focus_neighbor_left = current.get_path_to(prev_btn)
		else:
			current.focus_neighbor_bottom = current.get_path_to(next_btn)
			current.focus_neighbor_top = current.get_path_to(prev_btn)
