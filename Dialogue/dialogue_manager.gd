extends Node
class_name DialogueManager

@onready var dialogue_box = preload("res://Dialogue/dialogue_box.tscn")
@onready var choice_box = preload("res://Dialogue/choice_box.tscn")
@onready var dialogue_instance: DialogueBox
@onready var choice_instance: ChoiceBox

@export var conversation_obj: DialogueRes

#region Instancing and Deletion
func create_dialogue(text: String):
	dialogue_instance = dialogue_box.instantiate()
	add_child(dialogue_instance)
	dialogue_instance.line_finished.connect(_dialogue_parse)
	dialogue_instance.set_text(text)
func delete_dialogue():
	dialogue_instance.queue_free()

func create_choices(choices: Array[choiceOptionRes]):
	choice_instance = choice_box.instantiate() 
	add_child(choice_instance)
	choice_instance.parseChoices(choices)
	choice_instance.choice_made.connect(_branch_out)
func delete_choices(): choice_instance.queue_free()
#endregion

func _dialogue_parse():
	if conversation_obj == null: 
		delete_dialogue()
		return
	if conversation_obj is TextRes:
		if dialogue_instance: dialogue_instance.set_text(conversation_obj.text)
		else: create_dialogue(conversation_obj.text)
	conversation_obj = conversation_obj.next_node

	if conversation_obj is ChoicesRes:
		dialogue_instance.togglePause()
		create_choices(conversation_obj.choices_text)

func _branch_out(choice_text: String):
	if conversation_obj is ChoicesRes:
		for i in conversation_obj.choices_text:
			if i.text == choice_text:
				conversation_obj = i.next_node
	dialogue_instance.togglePause()
	delete_choices()
	_dialogue_parse()

##each dialogueManager gets its own csv file to parse, in order to make translations easier
#Want to use dictionaries for this one, gets ID and Selected Language


func _ready():
	_dialogue_parse()
