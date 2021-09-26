extends Control

var dialog : Dictionary
var dialogQueue : Array
var dialogActive : bool

var textNode : RichTextLabel
var portraitNode : TextureRect

var textPeriod : float = 0.01
var textTime : float
var textInd : int
var text : String

export (String, FILE) var initDialog : String = ""

func _ready():
	textNode = get_node("TextArea/DialogText")
	portraitNode = get_node("TextArea/PortraitPicture")
	visible = false
	if initDialog != "":
		start(initDialog)
	pass

func dialogClose():
	# Engine.time_scale = 1
	visible = false
	dialogActive = false
	portraitNode.texture = null
	pass

func dialogNext():
	while !dialogQueue.empty():
		var next = dialogQueue.pop_front()
		match typeof(next):
			TYPE_STRING:
				if textPeriod <= 0:
					textNode.text = next
					text = next
				else:
					textInd = 0
					textNode.text = ""
					text = next
					textTime = textPeriod
				return null
			TYPE_ARRAY:
				dialogQueue = next + dialogQueue
			TYPE_DICTIONARY:
				match next["type"]:
					"set-portrait":
						var texture : ImageTexture = ImageTexture.new()
						texture.load("res://" + next["res"])
						portraitNode.texture = texture
	dialogClose()

func start(file : String):
	var handle : File = File.new()
	var _o = handle.open(file,File.READ)
	var fileText = handle.get_as_text()
	handle.close()
	startSpec(parse_json(fileText))

func startSpec(diaSpec):
	# Engine.time_scale = 0
	visible = true
	dialogActive = true
	portraitNode.texture = null
	match typeof(diaSpec):
		TYPE_DICTIONARY:
			dialog = diaSpec
			dialogQueue = [dialog["start"]]
			dialogNext()

func _process(delta):
	if textInd < text.length():
		textTime -= delta
		while textTime < 0:
			textTime += textPeriod
			textInd += 1
			textNode.text = text.left(textInd)

func _input(event):
	if dialogActive && event.is_action_pressed("ui_accept"):
		dialogNext()
