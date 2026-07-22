minetest.register_node(":firealarm:mesecons_input_off",{
	description = "Fire Alarm Mesecons Input Module",
	groups = { oddly_breakable_by_hand = 1 },
	tiles = {
		"firealarm_meseconsio_input_off.png",
		"firealarm_meseconsio_sides.png",
		"firealarm_meseconsio_sides.png",
		"firealarm_meseconsio_sides.png",
		"firealarm_meseconsio_sides.png",
		"firealarm_meseconsio_sides.png",
	},
	paramtype = "light",
	paramtype2 = "facedir",
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.5,-0.5,-0.5,0.5,-0.4,0.5},
		},
	},
	on_punch = function(pos,_,player)
		local name = player:get_player_name()
		minetest.chat_send_player(name,string.format("Position: %d,%d,%d",pos.x,pos.y,pos.z))
	end,
	mesecons = {
		effector = {
			action_on = function(pos,node)
				local devInfo = firealarm.getDevInfo("signaling",pos)
				if devInfo then
					devInfo.active = true
					node.name = "firealarm:mesecons_input_on"
					minetest.set_node(pos,node)
					if devInfo.associated then
						local panelPos = minetest.get_position_from_hash(devInfo.associated)
						if panelPos then firealarm.loadNode(panelPos) end
						if type(firealarm.panelABM) == "function" then firealarm.panelABM(pos) end
					end
				end
			end,
		},
	},
	after_place_node = function(pos)
		firealarm.setDevInfo("signaling",pos,{active = false,manualReset = true})
	end,
	after_dig_node = function(pos)
		firealarm.setDevInfo("signaling",pos,nil)
	end,
})

minetest.register_node(":firealarm:mesecons_input_on",{
	description = "Fire Alarm Mesecons Input Module (on state - you hacker you!)",
	drop = "firealarm:mesecons_input_off",
	groups = { oddly_breakable_by_hand = 1, not_in_creative_inventory = 1 },
	tiles = {
		"firealarm_meseconsio_input_on.png",
		"firealarm_meseconsio_sides.png",
		"firealarm_meseconsio_sides.png",
		"firealarm_meseconsio_sides.png",
		"firealarm_meseconsio_sides.png",
		"firealarm_meseconsio_sides.png",
	},
	paramtype = "light",
	paramtype2 = "facedir",
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.5,-0.5,-0.5,0.5,-0.4,0.5},
		},
	},
	on_punch = function(pos,_,player)
		local name = player:get_player_name()
		minetest.chat_send_player(name,string.format("Position: %d,%d,%d",pos.x,pos.y,pos.z))
	end,
	mesecons = {
		effector = {
			action_off = function(pos,node)
				local devInfo = firealarm.getDevInfo("signaling",pos)
				if devInfo then
					devInfo.active = false
					node.name = "firealarm:mesecons_input_off"
					minetest.set_node(pos,node)
				end
			end,
		},
	},
	after_dig_node = function(pos)
		firealarm.setDevInfo("signaling",pos,nil)
	end,
})

minetest.register_node(":firealarm:mesecons_output_off",{
	description = "Fire Alarm Mesecons Output Module",
	groups = { oddly_breakable_by_hand = 1 },
	tiles = {
		"firealarm_meseconsio_output_off.png",
		"firealarm_meseconsio_sides.png",
		"firealarm_meseconsio_sides.png",
		"firealarm_meseconsio_sides.png",
		"firealarm_meseconsio_sides.png",
		"firealarm_meseconsio_sides.png",
	},
	paramtype = "light",
	paramtype2 = "facedir",
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.5,-0.5,-0.5,0.5,-0.4,0.5},
		},
	},
	mesecons = {
		receptor = {
			state = mesecon.state.off,
		},
	},
	on_punch = function(pos,_,player)
		local name = player:get_player_name()
		minetest.chat_send_player(name,string.format("Position: %d,%d,%d",pos.x,pos.y,pos.z))
	end,
	after_place_node = function(pos)
		firealarm.setDevInfo("notification",pos,{strobeActive = false,hornActive = false})
	end,
	after_dig_node = function(pos)
		firealarm.setDevInfo("notification",pos,nil)
	end,
})

minetest.register_node(":firealarm:mesecons_output_on",{
	drop = "firealarm:mesecons_output_off",
	description = "Fire Alarm Mesecons Output Module (on state - you hacker you!)",
	groups = { oddly_breakable_by_hand = 1,not_in_creative_inventory = 1 },
	tiles = {
		"firealarm_meseconsio_output_on.png",
		"firealarm_meseconsio_sides.png",
		"firealarm_meseconsio_sides.png",
		"firealarm_meseconsio_sides.png",
		"firealarm_meseconsio_sides.png",
		"firealarm_meseconsio_sides.png",
	},
	paramtype = "light",
	paramtype2 = "facedir",
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.5,-0.5,-0.5,0.5,-0.4,0.5},
		},
	},
	mesecons = {
		receptor = {
			state = mesecon.state.on,
		},
	},
})

minetest.register_abm({
	label = "Update mesecons output state",
	nodenames = {"firealarm:mesecons_output_off","firealarm:mesecons_output_on"},
	interval = 2,
	chance = 1,
	action = function(pos,node)
		local devInfo = firealarm.getDevInfo("notification",pos)
		if not devInfo then return end
		if node.name == "firealarm:mesecons_output_off" and devInfo.strobeActive then
			node.name = "firealarm:mesecons_output_on"
			minetest.set_node(pos,node)
			mesecon.receptor_on(pos)
		elseif node.name == "firealarm:mesecons_output_on" and not devInfo.strobeActive then
			node.name = "firealarm:mesecons_output_off"
			minetest.set_node(pos,node)
			mesecon.receptor_off(pos)
		end
	end,
})

minetest.register_craft({
	output = "firealarm:mesecons_input_off",
	recipe = {
		{"","dye:red","",},
		{"mesecons:wire_00000000_off","mesecons_luacontroller:luacontroller0000","",},
		{"","","",},
	}
})

minetest.register_craft({
	output = "firealarm:mesecons_output_off",
	recipe = {
		{"","dye:red","",},
		{"","mesecons_luacontroller:luacontroller0000","mesecons:wire_00000000_off",},
		{"","","",},
	}
})
