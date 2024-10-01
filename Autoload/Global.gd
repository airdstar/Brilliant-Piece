extends Node

var colorDict : Dictionary = {"White" : Color(1,1,1,1), "Black" : Color(0,0,0,1),
								"Gray" : Color(0.5,0.5,0.5,1), "Blue" : Color(0.63,0.72,0.86,1),
								"Red" : Color(0.86,0.63,0.72,1), "Orange" : Color(0.86,0.72,0.63,1),
								"Green" : Color(0.63,0.86,0.72,1), "Test" : Color(0.2,0.8,0.8,1)}

var tileBlackColor : Array = [Color8(37,24,26)]
var tileWhiteColor : Array = [Color8(214,209,177)]


var levelDict : Dictionary

func _ready():
	
	var expArray : Array[int] = [10, 20, 30, 40, 50]
	var healthArray : Array[int] = [2, 2, 2, 1, 2]
	
	levelDict = {"exp" : expArray, "health" : healthArray}
