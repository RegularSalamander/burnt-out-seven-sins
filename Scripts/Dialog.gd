extends Control

var dialog : Dictionary
var dialogQueue : Array
var dialogActive : bool

var textNode : RichTextLabel

export (String, FILE) var initDialog : String = ""

func _ready():
	textNode = get_node("TextArea/DialogText")
	visible = false
	if initDialog != "":
		start(initDialog)
	pass

func dialogClose():
	Engine.time_scale = 1
	visible = false
	dialogActive = false
	pass

func dialogNext():
	while !dialogQueue.empty():
		var next = dialogQueue.pop_front()
		match typeof(next):
			TYPE_STRING:
				textNode.text = next
				return null
			TYPE_ARRAY:
				dialogQueue = next + dialogQueue
	dialogClose()

func start(file : String):
	var handle : File = File.new()
	var _o = handle.open(file,File.READ)
	var fileText = handle.get_as_text()
	handle.close()
	startSpec(parse_json(fileText))

func startSpec(diaSpec):
	Engine.time_scale = 0
	visible = true
	dialogActive = true
	match typeof(diaSpec):
		TYPE_DICTIONARY:
			dialog = diaSpec
			dialogQueue = [dialog["start"]]
			dialogNext()

func _input(event):
	if dialogActive && event.is_action_pressed("ui_accept"):
		dialogNext()
