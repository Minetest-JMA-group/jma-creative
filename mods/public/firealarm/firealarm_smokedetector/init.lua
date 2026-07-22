local smokeDetectorOffBottomTexture = "[combine:32x320"..
                                      ":0,0=firealarm_smokedetector_bottom_on.png"..
                                      ":0,32=firealarm_smokedetector_bottom_off.png"..
                                      ":0,64=firealarm_smokedetector_bottom_off.png"..
                                      ":0,96=firealarm_smokedetector_bottom_off.png"..
                                      ":0,128=firealarm_smokedetector_bottom_off.png"..
                                      ":0,160=firealarm_smokedetector_bottom_off.png"..
                                      ":0,192=firealarm_smokedetector_bottom_off.png"..
                                      ":0,224=firealarm_smokedetector_bottom_off.png"..
                                      ":0,256=firealarm_smokedetector_bottom_off.png"..
                                      ":0,288=firealarm_smokedetector_bottom_off.png"

minetest.register_node(":firealarm:smokedetector_off",{
	description = "Fire Alarm Smoke Detector",
	groups = { oddly_breakable_by_hand = 1 },
	tiles = {
		"firealarm_smokedetector_sides.png",
		{
			name = smokeDetectorOffBottomTexture,
			animation = {
				type = "vertical_frames",
				aspect_w = 32,
				aspect_h = 32,
				length = 5,
			},
		},
		"firealarm_smokedetector_sides.png",
		"firealarm_smokedetector_sides.png",
		"firealarm_smokedetector_sides.png",
		"firealarm_smokedetector_sides.png",
	},
	paramtype = "light",
	paramtype2 = "facedir",
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.2,0.4,-0.2,0.2,0.5,0.2},
			{-0.075,0.35,-0.075,0.075,0.4,0.075},
		},
	},
	on_punch = function(pos,_,player)
		local name = player:get_player_name()
		minetest.chat_send_player(name,string.format("Position: %d,%d,%d",pos.x,pos.y,pos.z))
		local item = player:get_wielded_item()
		if item and string.find(item:get_name(),"magnet") then
			--Simulate the effect of the old beehive smoker
			minetest.get_meta(pos):set_int("agressive",0)
		end
	end,
	after_place_node = function(pos)
		firealarm.setDevInfo("signaling",pos,{active = false,manualReset = false})
		minetest.get_meta(pos):set_int("agressive",1)
	end,
	after_dig_node = function(pos)
		firealarm.setDevInfo("signaling",pos,nil)
	end,
})

minetest.register_node(":firealarm:smokedetector_on",{
	drop = "firealarm:smokedetector_off",
	description = "Fire Alarm Smoke Detector (on state - you hacker you!)",
	groups = { oddly_breakable_by_hand = 1,not_in_creative_inventory = 1 },
	tiles = {
		"firealarm_smokedetector_sides.png",
		"firealarm_smokedetector_bottom_on.png",
		"firealarm_smokedetector_sides.png",
		"firealarm_smokedetector_sides.png",
		"firealarm_smokedetector_sides.png",
		"firealarm_smokedetector_sides.png",
	},
	paramtype = "light",
	paramtype2 = "facedir",
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.2,0.4,-0.2,0.2,0.5,0.2},
			{-0.075,0.35,-0.075,0.075,0.4,0.075},
		},
	},
	on_punch = function(pos,_,player)
		local name = player:get_player_name()
		minetest.chat_send_player(name,string.format("Position: %d,%d,%d",pos.x,pos.y,pos.z))
	end,
	after_dig_node = function(pos)
		firealarm.setDevInfo("signaling",pos,nil)
	end,
})

minetest.register_abm({
	label = "Check for fire",
	nodenames = {"firealarm:smokedetector_off"},
	interval = 5,
	chance = 1,
	action = function(pos,node)
		local devInfo = firealarm.getDevInfo("signaling",pos)
		if not devInfo then return end
		local minheight
		for i=-1,-10,-1 do
			local checkpos = vector.add(pos,vector.new(0,i,0))
			local ndef = minetest.registered_nodes[minetest.get_node(checkpos).name]
			if ndef and ndef.drawtype == "normal" then
				minheight = i
				break
			end
		end
		minheight = minheight or -10
		local minp = vector.add(pos,vector.new(-4,minheight,-4))
		local maxp = vector.add(pos,vector.new(4,0,4))
		local fire_nodes = {"fire:permanent_flame","fire:basic_flame","tnt:gunpowder_burning","default:lava_source","default:lava_flowing"}
		local fire = #minetest.find_nodes_in_area(minp,maxp,fire_nodes) > 0
		if fire or minetest.get_meta(pos):get_int("agressive") == 0 then
			devInfo.active = true
			firealarm.setDevInfo("signaling",pos,devInfo)
			node.name = "firealarm:smokedetector_on"
			minetest.set_node(pos,node)
			if devInfo.associated then
				local panelPos = minetest.get_position_from_hash(devInfo.associated)
				if panelPos then firealarm.loadNode(panelPos) end
				if type(firealarm.panelABM) == "function" then firealarm.panelABM(pos) end
			end
		end
	end,
})

minetest.register_abm({
	label = "Reset LED",
	nodenames = {"firealarm:smokedetector_on"},
	interval = 1,
	chance = 1,
	action = function(pos,node)
		local devInfo = firealarm.getDevInfo("signaling",pos)
		if (not devInfo) or devInfo.active then return end
		node.name = "firealarm:smokedetector_off"
		minetest.set_node(pos,node)
		minetest.get_meta(pos):set_int("agressive",1)
	end,
})

minetest.register_craft({
	output = "firealarm:smokedetector_off",
	recipe = {
		{"plasticbox:plasticbox","homedecor:ic","plasticbox:plasticbox",},
		{"homedecor:copper_strip","technic:uranium_lump","homedecor:copper_strip",},
		{"","plasticbox:plasticbox","mesecons_lightstone:lightstone_red_off",},
	}
})

minetest.register_craft({
	output = "firealarm:smokedetector_off",
	recipe = {
		{"plasticbox:plasticbox","homedecor:ic","plasticbox:plasticbox",},
		{"mesecons_lamp:lamp_off","","mesecons_solarpanel:solar_panel_off",},
		{"","plasticbox:plasticbox","mesecons_lightstone:lightstone_red_off",},
	}
})
