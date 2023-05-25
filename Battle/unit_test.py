import unittest
from my_module import Monster, SaveData, battle_scene

class TestBattleScene(unittest.TestCase):
    def setUp(self):
        self.player = Monster("Pikachu", 25, 100, [Move("Thunderbolt", 90, 15), Move("Quick Attack", 40, 30), Move("Thunder Wave", 0, 20), Move("Agility", 0, 30)])
        self.enemy = Monster("Charmander", 25, 100, [Move("Ember", 90, 15), Move("Scratch", 40, 30), Move("Growl", 0, 20), Move("Dragon Rage", 0, 30)])
        self.team = [self.player, self.enemy]
        SaveData.save_team(self.team)

    def test_init_monsters(self):
        battle_scene.init_monsters(self.player, self.enemy)
        self.assertEqual(battle_scene.$Enemy/Name.text, "Charmander lvl.25")
        self.assertEqual(battle_scene.$Enemy/HP.max_value, 100)
        self.assertEqual(battle_scene.$Player/Name.text, "Pikachu lvl.25")
        self.assertEqual(battle_scene.$Player/HP.max_value, 100)

    def test_init_moves(self):
        battle_scene.init_moves(self.player)
        self.assertEqual(battle_scene.MovesBox.get_node("Move0").text, "Thunderbolt")
        self.assertEqual(battle_scene.MovesBox.get_node("Move1").text, "Quick Attack")
        self.assertEqual(battle_scene.MovesBox.get_node("Move2").text, "Thunder Wave")
        self.assertEqual(battle_scene.MovesBox.get_node("Move3").text, "Agility")

if __name__ == '__main__':
    unittest.main()