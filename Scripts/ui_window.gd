class_name UI_Window
extends NinePatchRect

signal opened
signal closed

func _ready() -> void:
	visible = false

func open() -> void:
	visible = true
	opened.emit()

func close() -> void:
	visible = false
	closed.emit()

func toggle() -> void:
	if visible:
		close()
	else:
		open()
