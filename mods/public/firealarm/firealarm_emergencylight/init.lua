minetest.register_node(":firealarm:emergencylight_off",{
	description = "Emergency Light",
	groups = { oddly_breakable_by_hand = 1 },
	tiles = {
		"firealarm_emergencylight_side.png",
		"firealarm_emergencylight_bottom.png",
		"firealarm_emergencylight_side.png",
		"firealarm_emergencylight_side.png",
		"firealarm_emergencylight_side.png",
		"firealarm_emergencylight_front.png",
	},
	paramtype = "light",
	paramtype2 = "facedir",
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.25,-0.2,0.40625,0.25,0.2,0.5}, -- wall conection

			{-0.25,0.2,0.40625,-0.15,0.3,0.5}, -- l lamp conection
			{-0.435,0.25,0.25,-0.22,0.45,0.40625}, -- l lamp

			{0.15,0.2,0.40625,0.25,0.3,0.5}, -- r lamp conection
			{0.435,0.25,0.25,0.22,0.45,0.40625}, -- r lamp
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

local animationTexture = "[combine:32x320"..
                                 ":0,0=firealarm_emergencylight_bottom_on.png"..
                                 ":0,32=firealarm_emergencylight_bottom.png"..
                                 ":0,64=firealarm_emergencylight_bottom.png"..
                                 ":0,96=firealarm_emergencylight_bottom.png"..
                                 ":0,128=firealarm_emergencylight_bottom.png"..
                                 ":0,160=firealarm_emergencylight_bottom.png"..
                                 ":0,192=firealarm_emergencylight_bottom.png"..
                                 ":0,224=firealarm_emergencylight_bottom.png"..
                                 ":0,256=firealarm_emergencylight_bottom.png"..
                                 ":0,288=firealarm_emergencylight_bottom.png"

minetest.register_node(":firealarm:emergencylight_on",{
	drop = "firealarm:emergencylight_off",
	description = "Emergency Light (wait, why do you have this?)",
	groups = { oddly_breakable_by_hand = 1,not_in_creative_inventory = 1 },
	tiles = {
		"firealarm_emergencylight_side.png",
		{
			name = animationTexture,
			animation = {
				type = "vertical_frames",
				aspect_w = 32,
				aspect_h = 32,
				length = 1,
			},
		},
		"firealarm_emergencylight_side.png",
		"firealarm_emergencylight_side.png",
		"firealarm_emergencylight_side.png",
		"firealarm_emergencylight_front_on.png",

	},
	paramtype = "light",
	paramtype2 = "facedir",
	light_source = 14,
	use_texture_alpha = "blend",
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.25,-0.2,0.40625,0.25,0.2,0.5}, -- wall conection

			{-0.25,0.2,0.40625,-0.15,0.3,0.5}, -- l lamp conection
			{-0.435,0.25,0.25,-0.22,0.45,0.40625}, -- l lamp

			{0.15,0.2,0.40625,0.25,0.3,0.5}, -- r lamp conection
			{0.435,0.25,0.25,0.22,0.45,0.40625}, -- r lamp
		},
	},
})

minetest.register_abm({
	label = "Update emergencylight state",
	nodenames = {"firealarm:emergencylight_off","firealarm:emergencylight_on"},
	interval = 1,
	chance = 1,
	action = function(pos,node)
		local devInfo = firealarm.getDevInfo("notification",pos)
		if not devInfo then return end
		if node.name == "firealarm:emergencylight_off" and devInfo.strobeActive then
			node.name = "firealarm:emergencylight_on"
			minetest.set_node(pos,node)
		elseif node.name == "firealarm:emergencylight_on" and not devInfo.strobeActive then
			node.name = "firealarm:emergencylight_off"
			minetest.set_node(pos,node)
		end
	end,
})

minetest.register_craft({
	output = "firealarm:emergencylight_off",
	recipe = {
		{"mesecons_lightstone:lightstone_white_off","","mesecons_lightstone:lightstone_white_off",},
		{"dye:white","plasticbox:plasticbox","dye:white",},
		{"","homedecor:ic","",},
	}
})