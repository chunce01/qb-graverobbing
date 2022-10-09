## qb-graverobbing

This script allows you to rob graves for loot after 21:00 and before 06:00. You will need to decide how you want to give your players the item "shovel" to start. I have pre-configured all of the "Large" headstones in the Hill Valley Church Cemetary in Northern Los Santos for looting on a cooldown timer.

This was quickly written for an event on our server, as other options were encrypted or had limited config options. I have also added a few Halloween candies with visual and ps-buff effects. The ps-buff effects can be turned off in the config if you don't want to use them.

## Credit:
Giving credit to the QBCore team for always being open source. I have used their qb-houserobbery reset timer to prevent people from repeatedly hitting the same headstones, as well as their ped model spawning config options from the taxi job so the dead locals are not always the same. Not to mention everything else I have learned from working on the framework so far.

## BTW the cooldown timer for headstones is in the top of the server file.
```lua
    local function ResetGraveTimer(OldGrave)
    local num = 345000  -- 5 minutes 45 seconds
```

## QBCore Items: 
```lua
-- Halloween custom candies:
['ccorn']  			 		 	 = {['name'] = 'ccorn', 						['label'] = 'Candy Corn', 				['weight'] = 100, 		['type'] = 'item',  	['image'] = 'ccorn.png', 					['unique'] = false, 		['useable'] = true, 	['shouldClose'] = true,    ['combinable'] = nil,   ['description'] = 'Some candy corn.'},
['hcandyg']  			 		 = {['name'] = 'hcandyg', 						['label'] = 'Halloween Candy', 			['weight'] = 100, 		['type'] = 'item',  	['image'] = 'hcandyg.png', 					['unique'] = false, 		['useable'] = true, 	['shouldClose'] = true,    ['combinable'] = nil,   ['description'] = 'Halloween candy in a green wrapper.'},
['hcandyr']  			 		 = {['name'] = 'hcandyr', 						['label'] = 'Halloween Candy', 			['weight'] = 100, 		['type'] = 'item',  	['image'] = 'hcandyr.png', 					['unique'] = false, 		['useable'] = true, 	['shouldClose'] = true,    ['combinable'] = nil,   ['description'] = 'Halloween candy in a red wrapper.'},
['agraphicnovel']  			 	 = {['name'] = 'agraphicnovel', 				['label'] = 'Ancient Graphic Novel', 	['weight'] = 1000, 		['type'] = 'item',  	['image'] = 'agraphicnovel.png', 			['unique'] = true, 		['useable'] = true, 	['shouldClose'] = true,    ['combinable'] = nil,   ['description'] = 'an ancient book with a odd leathery skin binding.'},
['shovel']  			 		 = {['name'] = 'shovel', 						['label'] = 'Shovel', 					['weight'] = 5000, 		['type'] = 'item',  	['image'] = 'shovel.png', 					['unique'] = true, 		['useable'] = true, 	['shouldClose'] = true,    ['combinable'] = nil,   ['description'] = 'I can dig things with this..'},

```
