extends Sprite2D

@onready var bs : Control = get_node("/root/BattleScene")

#OPTIMIZE Maybe can be optimized?
#NULL move could not exist
func _on_move_0_pressed() -> void:
	generic_move_pressed(0)
func _on_move_1_pressed() -> void:
	generic_move_pressed(1)
func _on_move_2_pressed() -> void:
	generic_move_pressed(2)
func _on_move_3_pressed() -> void:
	generic_move_pressed(3)

func generic_move_pressed(index : int) -> void:
	bs.get_node("AttackMenu").visible = false
	bs.compute_attack(bs.player, bs.enemy, bs.player.moves[index])
	await get_tree().create_timer(bs.HP_BAR_SPEED + 1).timeout
	print(bs.enemy.hp)
	if bs.enemy.hp > 0:
		bs.get_node("EnemySprite").enemy_turn()

#OPTIMIZE almost same code as the EnemySprite
func animate() -> void: #ADD animation in input. Now the animation is the same for every monster
	var tw : Tween = create_tween()
	var position : Vector2
	position = self.position
	tw.tween_property(self, "position", position + Vector2(50,0), 0.2)
	position += Vector2(50,0)
	tw.tween_property(self, "position", position - Vector2(50,0), 0.3)
	await get_tree().create_timer(1).timeout


