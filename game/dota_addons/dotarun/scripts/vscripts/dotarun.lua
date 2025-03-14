function Set (list)
	local set = {}
	for _, l in ipairs(list) do set[l] = true end
	return set
  end

local chargeBasedSpells = Set {
	"obsidian_destroyer_astral_imprisonment_custom",
	"vengefulspirit_nether_swap_custom"
}

--When / if Shiva's returns the random shall be 1, 6 again
function GiveRandomItem(hero)  
 	
 	local itemSlotsFull = GameRules.dotaRun:DoesHeroHaveMaxItems(hero)	
 	if (itemSlotsFull) then
 		print("No item slots!")
 		return
 	end

	local alreadyHas = false
	local alreadyHasBanana = false
	local itemNew = CreateItem(GameRules.dotaRun.itemList[RandomInt(1, #GameRules.dotaRun.itemList)], hero, hero)
	for i=0,5 do 
		itemOld = hero:GetItemInSlot(i)
		if(itemOld ~= nil and itemOld:GetClassname() == itemNew:GetClassname()) then
			if (itemOld:GetClassname() == "item_banana") then -- You can stack up bananas
				break
			end
			print("Hero already has: " .. itemNew:GetClassname())
			alreadyHas = true
			break
	    end
	end
	
	if (alreadyHas) then 
		GiveRandomItem(hero)
	else
		print("Adding item: " .. itemNew:GetClassname())
	    hero:AddItem(itemNew)
	end
end

function GiveRandomAbility(hero)

	local removeAbil = 0
	local hasMaxAbilities = true;
	( function () 
		for i = 0,6 do -- ability 0,1,2,3,4 and 6
			--if hero:GetAbilityByIndex(i) == nil then
			--print("Ability name:" .. hero:GetAbilityByIndex(i):GetAbilityName()) 
			if hero:GetAbilityByIndex(i) ~= nil then
				for j = 1,6 do
					ability = "empty_ability" .. j
					if(hero:GetAbilityByIndex(i):GetAbilityName() == ability) then
						removeAbil = ability
						hasMaxAbilities = false
						return
					end
				end
			end
		end
	end ) ()
	

	if (not hasMaxAbilities) then
		-- See https://stackoverflow.com/questions/9613322/lua-table-getn-returns-0
		abilityName = GameRules.dotaRun.spellList[RandomInt(1, #GameRules.dotaRun.spellList)]
		if(hero:FindAbilityByName(abilityName) == nil) then
			print("Adding ability: "..abilityName)
    	    hero:RemoveAbility(removeAbil) 
			hero:AddAbility(abilityName)
			hero:SetAbilityPoints(1)

			ability = hero:FindAbilityByName(abilityName)
			ability:UpgradeAbility(true)
			if (chargeBasedSpells[abilityName]) then
				print("Giving charge")
				modifier = ability:GetIntrinsicModifierName()
				hero:FindModifierByName(modifier):IncrementStackCount()
			end
		else 
			print("Hero already had ability: "..abilityName)
			GiveRandomAbility(hero)
   		end
	else
		print("Hero already has six abilities")
	end

end

function ItemZoneOne(trigger)
	playerID = trigger.activator:GetPlayerID()
	print("PlayerID: " .. playerID) 
	hero = trigger.activator

	if (GameRules.dotaRun.zoneOpen[hero:GetPlayerID()] == true) then
		GiveRandomAbility(hero)
		GiveRandomItem(hero)
		GameRules.dotaRun.zoneOpen[hero:GetPlayerID()] = false
		GameRules.dotaRun:StartZoneTimer(hero)

		local particle = ParticleManager:CreateParticleForPlayer("particles/econ/items/lanaya/lanaya_epit_trap/templar_assassin_epit_trap_ring_inner_start.vpcf",
		 PATTACH_ABSORIGIN_FOLLOW, hero, PlayerResource:GetPlayer(playerID))
		ParticleManager:SetParticleControl(particle, 0, trigger.activator:GetAbsOrigin())
    end
end

function WaterSlow(trigger)
	print("Slowing")
	hero = trigger.activator
	GiveUnitSlow(hero, hero, "modifier_slow")
end

function WaterUnslow(trigger)
	print("Unslowing")
	hero = trigger.activator
	hero:RemoveModifierByName("modifier_slow")
	
end

function GiveUnitSlow(source, target, modifier)
    --source and target should be hscript-units. The same unit can be in both source and target
    local item = CreateItem( "item_apply_slow", source, source)
    item:ApplyDataDrivenModifier( source, target, modifier, {} )
end
