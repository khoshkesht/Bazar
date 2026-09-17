extends Control

@onready var start_button: Button = $Content/StartButton
@onready var status_label: Label = $Content/Status

func _ready() -> void:
	start_button.pressed.connect(_on_start_pressed)

func _on_start_pressed() -> void:
	status_label.text = "گام بعد: ساخت نمونهٔ محیط حجره"
	start_button.disabled = true

