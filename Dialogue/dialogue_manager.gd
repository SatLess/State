extends Node
class_name DialogueManager

@onready var dialogueBox = preload("res://Dialogue/dialogue_box.tscn")
@onready var dialogue_instance: DialogueBox
@export var conversation_obj: DialogueRes
var cur_dialogue: DialogueRes

func _dialogue_parse():
	if cur_dialogue is TextRes:
		create_dialogue(conversation_obj.text)
	if cur_dialogue is ChoicesRes:
		pass
	cur_dialogue = conversation_obj.next_node

func create_dialogue(text: String):
	dialogue_instance = dialogueBox.instantiate() as DialogueBox
	add_child(dialogue_instance)
	dialogue_instance.line_finished.connect(_next_node)
	dialogue_instance.set_text(text)
	

func _next_node():
	if cur_dialogue.next_node == null: return
	if cur_dialogue is TextRes:
		if dialogue_instance: dialogue_instance.set_text(cur_dialogue.text)
	if conversation_obj is ChoicesRes:
		pass
	cur_dialogue = cur_dialogue.next_node

##each dialogueManager gets its own csv file to parse, in order to make translations easier
#Want to use dictionaries for this one, gets ID and Selected Language
func read_csv(directory: String) -> Dictionary:
	var dictionary: Dictionary
	var file := FileAccess.open(directory,FileAccess.READ)
	while not file.eof_reached():
		var line: PackedStringArray = file.get_csv_line()
		if line[0].begins_with("dl"): dictionary[str(line[0])] = line[1]
		elif line[0].begins_with("branch"): dictionary[str(line[0])] = line[1]
		elif line[0].begins_with("choice"): dictionary[str(line[0])] = line[1]
	
	return dictionary

func _ready():
	cur_dialogue = conversation_obj
	_dialogue_parse()
