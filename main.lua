-- EasierDroneUpgrade v1.0.0
-- SmoothSpatula

-- Change golem drones to only drop 2 revivable drones instead of 3 in RevivableDroneGolem mod
mods.on_all_mods_loaded(function() for k, v in pairs(mods) do if type(v) == "table" and v.gold_drones_golem_spawn then v.gold_drones_golem_spawn = 2 end end end)

function get_upgradable_drones(player)
    local drones = {}
    for i = 0, gm.instance_number(gm.constants.pDrone) - 1 do -- for all drones
        local drone = gm.instance_find(gm.constants.pDrone, i)
        if drone.is_super == false and drone.master.id == player.id -- not a golden droned and pertains to the player
        then
            if drones[drone.object_name] ~= nil then -- if you already have that type of drone
                return drones[drone.object_name], drone -- return both drones
            end
            drones[drone.object_name] = drone -- else store the drone
        end
    end
end

gm.pre_script_hook(gm.constants.interactable_pay_cost, function(self, other, result, args)
    if args[1].value == 5.0 and args[2].value == 2.0 then -- DroneUpgrader
        local drone1, drone2 = get_upgradable_drones(other) -- find the first 2 drones
        local drone3 = gm.instance_create_depth(other.x, other.y,0, drone1.object_index) -- create a 3rd drone so that __rpc_drone_upgrade_implementation__ gets called (3rd drone will get sacrificed)
    end
end)

gm.pre_script_hook(gm.constants.interactable_init_cost, function(self, other, result, args)
    if args[1].value.object_name == "oDroneUpgrader" then 
        args[3].value = 2.0 -- change cost to 2 drones instead of 3
    end
end)
