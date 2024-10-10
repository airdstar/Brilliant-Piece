extends Resource
class_name ItemPoolResource

## Possible drops
@export var items : Array[ItemResource]
## Values must add up to 1, position in chance array determines chance in item array
@export var itemChances : Array[float]

func getItem():
	if checkChances():
		var roll := randf_range(0,1)
		var currentTotal := 0.00
		for n in range(itemChances.size()):
			if roll <= currentTotal + itemChances[n]:
				return items[n]
			else:
				currentTotal += itemChances[n]
	

func checkChances():
	var total : float = 0
	
	if itemChances.size() != items.size():
		return false
	
	for n in range(itemChances.size()):
		if itemChances[n] <= 0:
			return false
		total += itemChances[n]
	
	if total != 1:
		return false
	return true
