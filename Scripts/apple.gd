extends Area2D

signal eaten

@onready var tracker = %Tracker
@onready var audio_eat = $AudioStreamPlayer2D


func _on_body_entered(body):
	eaten.emit()
	tracker.increment()
	audio_eat.play()
