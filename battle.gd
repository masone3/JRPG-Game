extends Control

@onready var _options: UI_Window = $Options
@onready var _options_menu: Menu = $Options/Margin/Options

func _ready() -> void:
	_options_menu.button_focus(0)

func _on_options_button_focused(button: BaseButton) -> void:
	pass
	
func _on_options_button_pressed(button: BaseButton) -> void:
	print(button.text)
