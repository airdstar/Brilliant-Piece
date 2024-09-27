extends ItemResource
class_name WeaponResource

@export_category("Ammunition")
@export var reliesOnAmmo : bool
@export_enum("Pistol", "Rifle", "Sniper") var requiredAmmo : String
@export var currentAmmo : AmmoResource
