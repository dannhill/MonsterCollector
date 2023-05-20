extends Control

signal ui_select_pressed

#temporary setup: must create an enemy team
@onready var MovesBox = $AttackMenu/MovesBox
@onready var team : Array[Monster] = SaveData.load_team()
@onready var player : Monster = team[0]
@onready var enemy : Monster = team[1]
@onready var rng : RandomNumberGenerator = RandomNumberGenerator.new()

const CRIT_CHANCE : int = 25

func _ready() -> void:
	init_monsters(player, enemy)
	init_moves(player)
	rng.randomize()
	
	start_encounter()

# I have to find a way to remove this check or see if it impacts in the performance or is irrelevant
func _process(delta) -> void:
	if Input.is_action_pressed("ui_select"):
		emit_signal("ui_select_pressed")

func init_monsters(player : Monster = player, enemy : Monster = enemy) -> void:
	$Enemy/Name.text = enemy.nickname
	$Enemy/HP.max_value = enemy.hp
	$Player/Name.text = player.nickname
	$Player/HP.max_value = player.hp
	
#NULL the move array could be empty or an entry could be empty
func init_moves(player : Monster = player) -> void:
	# for loop to initialize all four moves
	for i in range(0,4):
		MovesBox.get_node("Move" + str(i)).text = player.moves[i].nickname

func damage_calculation(move : Move, attacker : Monster = player, attacked : Monster = enemy) -> void:
	var critical_hit : float = 1.0
	if (rng.randi_range(0, 100) <= CRIT_CHANCE):
		critical_hit += 0.5
	
	var first_par : float = 2 * attacker.level * 0.2  + 2
	var second_par : float = first_par * move.power * attacker.attack / attacked.defense * 0.02 + 2
	var third_par : int = int(second_par * (rng.randf_range(85,100) / 100) * critical_hit)
	print(third_par)
	# match to see if the attacker is player or enemy
	match attacked == enemy:
		true:
			register_damage(player, enemy, third_par, $Enemy/HP)
		false:
			register_damage(enemy, player, third_par, $Player/HP)

func register_damage(attacker : Monster, attacked : Monster, damage : int, health_bar : ProgressBar) -> void:
	health_bar.value -= damage
	attacked.hp -= damage
	if attacked.hp <= 0:
		end_battle(attacker)

func end_battle(winner : Monster) -> void:
	$AttackMenu.visible = false
	$DescriptionBox.text = winner.nickname + " won the battle!"
	$DescriptionBox.visible = true
	await get_tree().create_timer(3.0).timeout
	self.visible = false

func start_encounter() -> void:
	await self.ui_select_pressed
	$DescriptionBox.text = "Battle with " + enemy.nickname + " begins!"
	await get_tree().create_timer(3.0).timeout
	$DescriptionBox.visible = false
	$AttackMenu.visible = true
	
func enemy_turn():
	#remove the hud and make the enemy attack
	$AttackMenu.visible = false
	compute_attack(enemy, player, enemy.moves[rng.randi_range(0,3)])

	await get_tree().create_timer(3.0).timeout
	$AttackMenu.visible = true

#OPTIMIZE Maybe can be optimized?
#NULL move could not exist
func _on_move_1_pressed() -> void:
	$AttackMenu.visible = false
	compute_attack(player, enemy, player.moves[0])
	await get_tree().create_timer(3.0).timeout
	enemy_turn()

#NULL move could not exist
func _on_move_2_pressed() -> void:
	$AttackMenu.visible = false
	compute_attack(player, enemy, player.moves[1])
	await get_tree().create_timer(3.0).timeout
	enemy_turn()

#NULL move could not exist
func _on_move_3_pressed() -> void:
	$AttackMenu.visible = false
	compute_attack(player, enemy, player.moves[2])
	await get_tree().create_timer(3.0).timeout
	enemy_turn()

#NULL move could not exist
func _on_move_4_pressed() -> void:
	$AttackMenu.visible = false
	compute_attack(player, enemy, player.moves[3])
	await get_tree().create_timer(3.0).timeout
	enemy_turn()

func attack_missed(attacker : Monster) -> void:
	$DescriptionBox.text = attacker.nickname + " missed!"
	$DescriptionBox.visible = true
	await get_tree().create_timer(3.0).timeout
	$DescriptionBox.visible = false
	$AttackMenu.visible = true

#NULL fare controllo se la mossa esista
func compute_attack(attacker : Monster, attacked : Monster, move : Move) -> void:
	if rng.randi_range(0,100) <= move.accuracy:
		damage_calculation(move, attacker, attacked)
	else:
		attack_missed(attacker)
