antigrief = {}
local storage = minetest.get_mod_storage()

minetest.register_privilege("no_timed_restrictions", {
	description = "The privilage bypasses item restrictions for immediate use",
	give_to_admin = true,
})

-- Node overrides
minetest.override_item("default:lava_source", {
	groups = {lava = 3, liquid = 2, igniter = 1, not_in_creative_inventory = 1},
	on_place = function(_, placer)
		local wielded_item = placer:get_wielded_item()
		wielded_item:replace(ItemStack("bucket:bucket_lava"))
		placer:set_wielded_item(wielded_item)
    end,
})

minetest.override_item("default:water_source", {
	groups = {water = 3, liquid = 3, cools_lava = 1, not_in_creative_inventory = 1},
	on_place = function(_, placer)
		local wielded_item = placer:get_wielded_item()
		wielded_item:replace(ItemStack("bucket:bucket_water"))
		placer:set_wielded_item(wielded_item)
    end,
})

minetest.override_item("default:river_water_source", {
	groups = {water = 3, liquid = 3, cools_lava = 1, not_in_creative_inventory = 1},
	on_place = function(_, placer)
		local wielded_item = placer:get_wielded_item()
		wielded_item:replace(ItemStack("bucket:bucket_river_water"))
		placer:set_wielded_item(wielded_item)
    end,
})

-- Timed restrictions
function antigrief.is_playtime_passed(player_name, time)
	local total_playtime = playtime.get_total_playtime(player_name)
	if total_playtime < time and storage:get_int("whitelist:" .. player_name) == 0 and not minetest.check_player_privs(player_name, "no_timed_restrictions") then
		minetest.chat_send_player(player_name, "You must play for " ..  playtime.seconds_to_clock(math.abs(total_playtime - time)) .. " to use this item.")
		return false
	end
	return true
end

minetest.register_chatcommand("antigrief_ignore", {
	description = "",
	params = "<name>",
	privs = {server = true},
	func = function(name, param)
		if param ~= "" and minetest.player_exists(param) then
			storage:set_int("whitelist:" .. param, 1)
			return true, "Ok."
		else
			return false, "Player does not exist or name is not provided"
		end
	end
})

minetest.register_chatcommand("antigrief_remove", {
	description = "",
	params = "<name>",
	privs = {server = true},
	func = function(name, param)
		if param ~= "" and minetest.player_exists(param) then
			storage:set_int("whitelist:" .. param, 0)
			return true, "Removed from whitelist"
		else
			return false, "Player does not exist or name is not provided"
		end
	end
})