extends HBoxContainer

func display(humanStats: HumanStats):
	%HumanName.text = humanStats.human_name
	%HumanMood.text = humanStats.mood
	%HumanAge.text = str(humanStats.age)
	%HumanHunger.text = str(humanStats.hunger)
	%HumanEnergy.text = str(humanStats.energy)
	%HumanHealth.text = str(humanStats.health)
	%HumanSanity.text = str(humanStats.sanity)
