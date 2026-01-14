extends CanvasLayer

@onready var label: Label = $MarginContainer/CenterContainer/Label

func set_fuel_label(amount) ->void:
	label.text = "Fuel: "+ str(amount)
