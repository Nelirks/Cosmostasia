extends RefCounted
class_name Character

var player : Player

var template : CharacterInfo

var char_name : String
var quote : String
var texture : Texture2D

var max_health : int
var current_health : int

var _armor : int

var is_dead : bool = false

var _statuses : Array[StatusEffect]

func _init(template : CharacterInfo, player : Player) :
	self.template = template
	char_name = template.character_name
	quote = template.character_quote
	texture = template.character_texture
	
	max_health = template.max_health
	current_health = max_health
	
	self.player = player

func start_turn() -> void :
	_armor = 0
	for status in _statuses :
		status.decay()

func deal_damage(target : Character, amount : int) -> void :
	target.take_damage(self, amount)

func take_damage(source : Character, amount : int) -> void :
	var remaining_amount : int = amount
	if _armor > 0 :
		if _armor > remaining_amount :
			_armor -= remaining_amount
			remaining_amount = 0
		else : 
			remaining_amount -= _armor
			_armor = 0
	current_health -= remaining_amount
	GameManager.combat.emit_combat_event(DamageDealtEvent.new(source, self, remaining_amount))

func update_is_dead() -> void:
	if current_health <= 0 :
		is_dead = true
		GameManager.combat.emit_combat_event(CharacterDeathEvent.new(self))

func apply_armor(amount : int) -> void :
	_armor += amount

func apply_status(status : StatusEffect) -> void :
	var owned_status : StatusEffect = get_status(status.id)
	if owned_status != null :
		owned_status.stacks += status.stacks
	else :
		_statuses.append(status.duplicate(true))
		status.owner = self
		status.on_apply()

func remove_status(id : String) -> void :
	for i in range(_statuses.size()) :
		if _statuses[i].id == id :
			_statuses.remove_at(i)
			_statuses[i].on_remove()

func has_status(id : String) -> bool :
	return get_status(id) != null

func get_status(id : String) -> StatusEffect :
	for status in _statuses :
		if id == status.id :
			return status
	return null

func on_combat_event(event : CombatEvent) -> void :
	for status in _statuses :
		status.on_combat_event(event)

func get_allies(include_self : bool = true, include_dead : bool = false) -> Array[Character] :
	if include_self : 
		return player.get_characters(include_dead)
	else :
		var allies : Array[Character] = player.get_characters(include_dead)
		allies.remove_at(allies.find(self))
		return allies

func get_enemies(include_dead : bool = false) -> Array[Character] :
	return player.get_opponent().get_characters(include_dead)
