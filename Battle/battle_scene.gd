extends Control

signal ui_select_pressed

#temporary setup: must create an enemy team
@onready var MovesBox = $AttackMenu/MovesBox
@onready var team : Array[Monster] = SaveData.load_team()
@onready var player : Monster = team[0]
@onready var enemy : Monster = team[1]
@onready var rng : RandomNumberGenerator = RandomNumberGenerator.new()

const CRIT_CHANCE : int = 25
const HP_BAR_SPEED : float = 1.5

func _ready() -> void:
	init_monsters(player, enemy)
	init_moves(player)
	rng.randomize()

	start_encounter()

func init_monsters(player : Monster = player, enemy : Monster = enemy) -> void:
	$Enemy/Name.text = str(enemy.nickname) + " lvl." + str(enemy.level)
	$Enemy/HP.max_value = enemy.hp
	$Player/Name.text = str(player.nickname) + " lvl." + str(player.level)
	$Player/HP.max_value = player.hp

func init_moves(player : Monster = player) -> void:
	if player.moves == null:
		return
	for i in range(0,4):
		if player.moves[i] != null:
			MovesBox.get_node("Move" + str(i)).text = player.moves[i].nickname

func start_encounter() -> void:
	await self.ui_select_pressed
	$DescriptionBox.text = "Battle with " + enemy.nickname + " begins!"
	await get_tree().create_timer(3.0).timeout
	$DescriptionBox.visible = false
	$AttackMenu.visible = true

func _process(delta) -> void:
#OPTIMIZE Looks like it's irrelevant for the performance if I use is_action_just_pressed()
	if Input.is_action_just_pressed("ui_select"):
		emit_signal("ui_select_pressed")

func compute_attack(attacker : Monster, attacked : Monster, move : Move) -> void:
	if move == null:
		print("Move doesn't exist")
		return
	if rng.randi_range(0,100) <= move.accuracy:
		$DescriptionBox.text = attacker.nickname + " used " + move.nickname + "!"
		$DescriptionBox.visible = true
		if attacker == player:
			$PlayerSprite.animate()
		else:
			$EnemySprite.animate()
		await get_tree().create_timer(1).timeout
		damage_calculation(move, attacker, attacked)
	else:
		attack_missed(attacker)

func damage_calculation(move : Move, attacker : Monster = player, attacked : Monster = enemy) -> void:
	var critical_hit : float = 1.0
	if (rng.randi_range(0, 100) <= CRIT_CHANCE):
		critical_hit += 0.5
	
	var first_par : float = 2 * attacker.level * 0.2  + 2
	var second_par : float = first_par * move.power * attacker.attack / attacked.defense * 0.02 + 2
	var third_par : int = int(second_par * (rng.randf_range(85,100) / 100) * critical_hit)
	# match to see if the attacker is player or enemy
	match attacked == enemy:
		true:
			register_damage(player, enemy, third_par, $Enemy/HP)
		false:
			register_damage(enemy, player, third_par, $Player/HP)

func register_damage(attacker : Monster, attacked : Monster, damage : int, health_bar : ProgressBar) -> void:
	var tw : Tween = create_tween()
	attacked.hp -= damage
#I don't know if tween_property emits signal when it changes healthbar value, but I don't think it is much relevant
	tw.tween_property(health_bar, "value", health_bar.value - damage, HP_BAR_SPEED)
	await get_tree().create_timer(HP_BAR_SPEED).timeout
	if attacked.hp <= 0:
		end_battle(attacker)
	elif attacker == enemy:
		$AttackMenu.visible = true

func end_battle(winner : Monster) -> void:
	var tw : Tween = create_tween()
	$AttackMenu.visible = false
	$DescriptionBox.text = winner.nickname + " won the battle!"
	$DescriptionBox.visible = true
	
	tw.tween_property($BattleMusic, "volume_db", -80, 3)
	await get_tree().create_timer(HP_BAR_SPEED).timeout
	self.visible = false
	
func enemy_turn() -> void:
	$AttackMenu.visible = false
	compute_attack(enemy, player, enemy.moves[rng.randi_range(0,3)])
	$DescriptionBox.visible = false

#OPTIMIZE Maybe can be optimized?
#NULL move could not exist
func _on_move_1_pressed() -> void:
	generic_move_pressed(0)
func _on_move_2_pressed() -> void:
	generic_move_pressed(1)
func _on_move_3_pressed() -> void:
	generic_move_pressed(2)
func _on_move_4_pressed() -> void:
	generic_move_pressed(3)

func generic_move_pressed(index : int) -> void:
	$AttackMenu.visible = false
	compute_attack(player, enemy, player.moves[index])
	await get_tree().create_timer(HP_BAR_SPEED + 1).timeout
	print(enemy.hp)
	if enemy.hp > 0:
		enemy_turn()

func attack_missed(attacker : Monster) -> void:
	$DescriptionBox.text = attacker.nickname + " missed!"
	await get_tree().create_timer(HP_BAR_SPEED).timeout
