extends DialogueRes
class_name ChoicesRes

@export var choices_text: Array[TextRes]

func changeState(sig : Signal, args: Array):
	sig.emit()
