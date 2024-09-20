extends Control
class_name Menu

var hasSelectedOption : bool = false
var optionCount : int
var highlightedOption : int = 0
var options = []
@onready var animation = $AnimationPlayer

func _ready():
	FloorData.floor.Handlers.UH.currentMenu = self
	addOptions()

func addOptions():
	pass

func selectOption():
	pass

func selectToggle():
	pass
