minetest.register_privilege("firealarm",{
	description = "Can bypass area protection when pulling fire alarms",
	give_to_singleplayer = true,
})

minetest.register_node(":firealarm:pullstation_off",{
	description = "Pull Station",
	groups = { oddly_breakable_by_hand = 1 },
	tiles = {
		"firealarm_pullstation_back.png",
		"firealarm_pullstation_back.png",
		"firealarm_pullstation_back.png",
		"firealarm_pullstation_back.png",
		"firealarm_pullstation_back.png",
		"firealarm_pullstation_front_off.png",
	},
	paramtype = "light",
	paramtype2 = "facedir",
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.15,-0.5,0.4,0.18,-0.11,0.5},
		},
	},
	on_punch = function(pos,_,player)
		local name = player:get_player_name()
		minetest.chat_send_player(name,string.format("Position: %d,%d,%d",pos.x,pos.y,pos.z))
	end,
	on_rightclick = function(pos,node,clicker)
		if minetest.is_protected(pos,clicker:get_player_name())
		   and not minetest.check_player_privs(clicker,"protection_bypass")
		   and not minetest.check_player_privs(clicker,"firealarm")
		then
			minetest.record_protection_violation(pos,clicker:get_player_name())
			return
		end
		local devInfo = firealarm.getDevInfo("signaling",pos)
		if devInfo then
			devInfo.active = true
			node.name = "firealarm:pullstation_on"
			minetest.set_node(pos,node)
			minetest.sound_play("firealarm_pullstation_pull",{pos=pos})
			if devInfo.associated then
				local panelPos = minetest.get_position_from_hash(devInfo.associated)
				if panelPos then firealarm.loadNode(panelPos) end
				if type(firealarm.panelABM) == "function" then firealarm.panelABM(pos) end
				local name = clicker:get_player_name()
				minetest.log("action",string.format("%s pulled a fire alarm at (%d,%d,%d)",name,pos.x,pos.y,pos.z))
			end
		end
	end,
	after_place_node = function(pos)
		firealarm.setDevInfo("signaling",pos,{active = false,manualReset = true})
	end,
	after_dig_node = function(pos)
		firealarm.setDevInfo("signaling",pos,nil)
	end,
})

minetest.register_node(":firealarm:pullstation_on",{
	drop = "firealarm:pullstation_off",
	description = "Pull Station (pulled state - you hacker you!)",
	groups = { oddly_breakable_by_hand = 1,not_in_creative_inventory = 1 },
	tiles = {
		"firealarm_pullstation_back.png",
		"firealarm_pullstation_back.png",
		"firealarm_pullstation_back.png",
		"firealarm_pullstation_back.png",
		"firealarm_pullstation_back.png",
		"firealarm_pullstation_front_on.png",
	},
	paramtype = "light",
	paramtype2 = "facedir",
	light_source = 5,
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.15,-0.5,0.4,0.18,-0.11,0.5},
		},
	},
	on_punch = function(pos,_,player)
		local name = player:get_player_name()
		minetest.chat_send_player(name,string.format("Position: %d,%d,%d",pos.x,pos.y,pos.z))
	end,
	on_rightclick = function(pos,node,clicker)
		if minetest.is_protected(pos,clicker:get_player_name()) and not minetest.check_player_privs(clicker,"protection_bypass") then
			minetest.record_protection_violation(pos,clicker:get_player_name())
			minetest.chat_send_player(clicker:get_player_name(),"You are not authorized to reset this pull station")
			return
		end
		local devInfo = firealarm.getDevInfo("signaling",pos)
		if devInfo then
			devInfo.active = false
			node.name = "firealarm:pullstation_off"
			minetest.set_node(pos,node)
			minetest.sound_play("firealarm_pullstation_reset",{pos=pos})
		end
	end,
	after_dig_node = function(pos)
		firealarm.setDevInfo("signaling",pos,nil)
	end,
})

minetest.register_node(":firealarm:uk_pullstation_off",{
	description = "UK Pull Station",
	groups = { oddly_breakable_by_hand = 1 },
	tiles = {
		"uk_firealarm_pullstation_back.png",
		"uk_firealarm_pullstation_back.png",
		"uk_firealarm_pullstation_back.png",
		"uk_firealarm_pullstation_back.png",
		"uk_firealarm_pullstation_back.png",
		"uk_firealarm_pullstation_front_off.png",
	},
	paramtype = "light",
	paramtype2 = "facedir",
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.15,-0.5,0.4,0.18,-0.11,0.5},
		},
	},
	on_punch = function(pos,_,player)
		local name = player:get_player_name()
		minetest.chat_send_player(name,string.format("Position: %d,%d,%d",pos.x,pos.y,pos.z))
	end,
	on_rightclick = function(pos,node,clicker)
		if minetest.is_protected(pos,clicker:get_player_name())
		   and not minetest.check_player_privs(clicker,"protection_bypass")
		   and not minetest.check_player_privs(clicker,"firealarm")
		then
			minetest.record_protection_violation(pos,clicker:get_player_name())
			return
		end
		local devInfo = firealarm.getDevInfo("signaling",pos)
		if devInfo then
			devInfo.active = true
			node.name = "firealarm:uk_pullstation_on"
			minetest.set_node(pos,node)
			minetest.sound_play("firealarm_pullstation_pull",{pos=pos})
			if devInfo.associated then
				local panelPos = minetest.get_position_from_hash(devInfo.associated)
				if panelPos then firealarm.loadNode(panelPos) end
				if type(firealarm.panelABM) == "function" then firealarm.panelABM(pos) end
				local name = clicker:get_player_name()
				minetest.log("action",string.format("%s pulled a fire alarm at (%d,%d,%d)",name,pos.x,pos.y,pos.z))
			end
		end
	end,
	after_place_node = function(pos)
		firealarm.setDevInfo("signaling",pos,{active = false,manualReset = true})
	end,
	after_dig_node = function(pos)
		firealarm.setDevInfo("signaling",pos,nil)
	end,
})

minetest.register_node(":firealarm:uk_pullstation_on",{
	drop = "firealarm:uk_pullstation_off",
	description = "UK Pull Station (pulled state - you hacker you!)",
	groups = { oddly_breakable_by_hand = 1,not_in_creative_inventory = 1 },
	tiles = {
		"uk_firealarm_pullstation_back.png",
		"uk_firealarm_pullstation_back.png",
		"uk_firealarm_pullstation_back.png",
		"uk_firealarm_pullstation_back.png",
		"uk_firealarm_pullstation_back.png",
		"uk_firealarm_pullstation_front_on.png",
	},
	paramtype = "light",
	paramtype2 = "facedir",
	light_source = 5,
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.15,-0.5,0.4,0.18,-0.11,0.5},
		},
	},
	on_punch = function(pos,_,player)
		local name = player:get_player_name()
		minetest.chat_send_player(name,string.format("Position: %d,%d,%d",pos.x,pos.y,pos.z))
	end,
	on_rightclick = function(pos,node,clicker)
		if minetest.is_protected(pos,clicker:get_player_name()) and not minetest.check_player_privs(clicker,"protection_bypass") then
			minetest.record_protection_violation(pos,clicker:get_player_name())
			minetest.chat_send_player(clicker:get_player_name(),"You are not authorized to reset this pull station")
			return
		end
		local devInfo = firealarm.getDevInfo("signaling",pos)
		if devInfo then
			devInfo.active = false
			node.name = "firealarm:uk_pullstation_off"
			minetest.set_node(pos,node)
			minetest.sound_play("firealarm_pullstation_reset",{pos=pos})
		end
	end,
	after_dig_node = function(pos)
		firealarm.setDevInfo("signaling",pos,nil)
	end,
})

minetest.register_craft({
	output = "firealarm:pullstation_off",
	recipe = {
		{"dye:red","dye:white","dye:red",},
		{"","mesecons_walllever:wall_lever_off","",},
		{"","plasticbox:plasticbox","",},
	}
})

minetest.register_craft({
	output = "firealarm:uk_pullstation_off",
	recipe = {
		{"dye:red","dye:white","dye:red",},
		{"default:glass","mesecons_walllever:wall_lever_off","default:glass",},
		{"","plasticbox:plasticbox","",},
	}
})