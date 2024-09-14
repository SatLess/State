extends Control
class_name DialogueBox

signal line_finished

@onready var timer = $Timer
@onready var label = $RichTextLabel

@export var wait_time: float

var is_proceeding:bool = false

func proceed():
	is_proceeding = true
	label.visible_characters = 0
	while label.visible_characters < len(label.text):
		label.visible_characters +=1
		timer.start(wait_time)
		await timer.timeout
	is_proceeding = false
	

func set_text(text: String):
	label.text = text
	proceed()

func _unhandled_input(event):
	if Input.is_action_just_pressed("ui_proceed"): 
		if is_proceeding == true: label.visible_characters = len(label.text)
		else: line_finished.emit()
		
