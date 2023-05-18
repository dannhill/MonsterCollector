extends Control

signal ui_select_pressed

@onready var MovesBox = $AttackMenu/MovesBox
@onready var enemy : Monster = Monster.new("Goblino", Typ.e.GOBLIN, Typ.e.GOBLIN, 0.5)
@onready var player : Monster = Monster.new("Eroe", Typ.e.KNIGHT, Typ.e.KNIGHT, 0.5)
@onready var rng : RandomNumberGenerator = RandomNumberGenerator.new()

const CRIT_CHANCE : int = 25

func _ready():
	init_monsters(player, enemy)
	init_moves(player)
	rng.randomize()
	
	start_encounter()

# I have to find a way to remove this check or see if it impacts in the performance or is irrelevant
func _process(delta):
	if Input.is_action_pressed("ui_select"):
		emit_signal("ui_select_pressed")

func init_monsters(player : Monster = player, enemy : Monster = enemy):
	$Enemy/Name.text = enemy.nickname
	$Enemy/HP.max_value = enemy.hp
	$Player/Name.text = player.nickname
	$Player/HP.max_value = player.hp
	

func init_moves(player : Monster = player):
	MovesBox.get_node("Move1").text = player.moves.first.nickname
	MovesBox.get_node("Move2").text = player.moves.second.nickname
	MovesBox.get_node("Move3").text = player.moves.third.nickname
	MovesBox.get_node("Move4").text = player.moves.fourth.nickname

func damage_calculation(move : Move, player : Monster = player, enemy : Monster = enemy):
	var critical_hit : float = 1.0
	if (rng.randi_range(0, 100) <= CRIT_CHANCE):
		critical_hit += 0.5
	
	var first_par : float = 2 * player.level * 0.2  + 2
	var second_par : float = first_par * move.power * player.attack / enemy.defense * 0.02 + 2
	var third_par : int = int(second_par * (rng.randf_range(85,100) / 100) * critical_hit)
	print(third_par)
	$Enemy/HP.value -= third_par

func start_encounter():
	await self.ui_select_pressed
	$DescriptionBox.text = "Battle with " + enemy.nickname + " begins!"
	await get_tree().create_timer(3.0).timeout
	$DescriptionBox.visible = false
	$AttackMenu.visible = true
	

func _on_move_1_pressed():
	if rng.randi_range(0,100) <= player.moves.first.accuracy:
		damage_calculation(player.moves.first, player, enemy)

func _on_move_2_pressed():
	if rng.randi_range(0,100) <= player.moves.second.accuracy:
		damage_calculation(player.moves.second, player, enemy)

func _on_move_3_pressed():
	if rng.randi_range(0,100) <= player.moves.third.accuracy:
		damage_calculation(player.moves.third, player, enemy)

func _on_move_4_pressed():
	if rng.randi_range(0,100) <= player.moves.fourth.accuracy:
		damage_calculation(player.moves.fourth, player, enemy)
		
