extends Area2D

signal eaten

func _on_body_entered(body):
	eaten.emit()
