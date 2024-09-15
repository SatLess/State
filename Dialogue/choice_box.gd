extends Control
class_name ChoiceBox

signal choice_made (choice: String)

@onready var baseButton = $VSplitContainer/testButton
@onready var v_split_container = $VSplitContainer
var choices: Array[String]

func addButton():
	for i in choices.size():
		var new_button = Button.new()
		new_button.custom_minimum_size = baseButton.get_minimum_size()
		v_split_container.add_child(new_button)
		new_button.text = choices[i]
		new_button.pressed.connect(buttonPressed.bind(new_button.text))

func parseChoices(choices_res: Array[choiceOptionRes]):
	for i  in choices_res.size():
		choices.append(choices_res[i].text)
	addButton()

func buttonPressed(button_name: String):
	choice_made.emit(button_name)
