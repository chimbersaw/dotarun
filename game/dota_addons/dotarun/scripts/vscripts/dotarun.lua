
local zoneCount = {}

itemList = { "item_blink", "item_force_staff", "item_cyclone", "item_shivas_guard", "item_sheepstick", }
spellList = {"mirana_arrow_custom", "mirana_leap_custom", "venomancer_venomous_gale_custom", "dark_seer_surge_custom", "jakiro_ice_path_custom", 
"batrider_flamebreak_custom", "ancient_apparition_ice_vortex_custom", "gyrocopter_homing_missile_custom", "obsidian_destroyer_astral_imprisonment_custom"}

--problems:
--alchemist_unstable_concoction
--invoker_deafening_blast
--invoker_tornado

function GiveRandomItem(hero)
 	
	item = CreateItem(itemList[math.random(#itemList)], hero, hero)
	hero:AddItem(item)

end

function GiveRandomAbility(hero)

	abilityName = spellList[math.random(#spellList)]
	-- abilityName = "obsidian_destroyer_astral_imprisonment_custom"
	print("Rolled ability "..abilityName)
	if(hero:FindAbilityByName(abilityName) == nil) then
        hero:RemoveAbility("mirana_fart") 
		hero:AddAbility(abilityName)
		ability = hero:FindAbilityByName(abilityName)
		ability:SetLevel(1)
		ability:SetAbilityIndex(1)
    end
end

function ItemZoneOne(trigger)
	-- See http://stackoverflow.com/questions/18199844/lua-math-random-not-working pop dem randoms
	math.randomseed(GameRules:GetGameTime() )
	math.random()
	math.random()
	math.random()

	print("Entered Item Zone")


	hero = trigger.activator


	
	 GiveRandomAbility(hero)


	if(zoneCount[hero:GetPlayerID()] == nil) then
		zoneCount[hero:GetPlayerID()] = 0
	end

	if(zoneCount[hero:GetPlayerID()] < 5) then
		zoneCount[hero:GetPlayerID()] = zoneCount[hero:GetPlayerID()] + 1
		print("items picked up by player " .. hero:GetPlayerID()..": "..zoneCount[hero:GetPlayerID()])
		GiveRandomItem(hero)
	end
end

-- function GiveImmunity(trigger)
-- 	hero = trigger.activator
-- 	local ability = hero:FindAbilityByName("Immunity")
-- 	ability:SetLevel(1)
-- end