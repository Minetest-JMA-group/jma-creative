local function setFormspec(pos)
	local annInfo = firealarm.getDevInfo("annunciator",pos)
	if not annInfo or not annInfo.associated then return end
	local panelPos = minetest.get_position_from_hash(annInfo.associated)
	local devInfo = firealarm.getDevInfo("panel",panelPos)
	if not devInfo then return end
	local meta = minetest.get_meta(pos)
	local fs = "size[10,10]label[0.5,0.5;Remote Fire Panel]"
	if #devInfo.alarm > 0 then
		if devInfo.silenced then
			fs = fs.."label[0.5,2;Alarm Silenced]"
		else
			if devInfo.acked then
				fs = fs.."label[0.5,2;Alarm Acknowledged]"
			else
				fs = fs.."label[0.5,2;ALARM! - "..minetest.formspec_escape(devInfo.alarm[#devInfo.alarm].name).."]"
			end
		end
	elseif #devInfo.supervisory > 0 then
		if devInfo.acked then
			fs = fs.."label[0.5,2;Supervisory Acknowledged]"
		else
			fs = fs.."label[0.5,2;Supervisory - "..minetest.formspec_escape(devInfo.supervisory[#devInfo.supervisory].name).."]"
		end
	elseif #devInfo.trouble > 0 then
		if devInfo.acked then
			fs = fs.."label[0.5,2;Trouble Acknowledged]"
		else
			fs = fs.."label[0.5,2;Trouble - "..minetest.formspec_escape(devInfo.trouble[#devInfo.trouble].name).."]"
		end
	else
		fs = fs.."label[0.5,2;System Normal]"
	end
	fs = fs.."button[0.5,3;3,1;ack;Acknowledge]"
	fs = fs.."button[0.5,4;3,1;silence;Silence]"
	fs = fs.."button[0.5,5;3,1;reset;Reset]"
	fs = fs.."button[0.5,6;3,1;drill;Drill]"
	meta:set_string("formspec",fs)
end

local function handleFields(pos,_,fields,sender)
	local annInfo = firealarm.getDevInfo("annunciator",pos)
	if not annInfo or not annInfo.associated then return end
	local panelPos = minetest.get_position_from_hash(annInfo.associated)
	firealarm.loadNode(panelPos)
	local devInfo = firealarm.getDevInfo("panel",panelPos)
	if fields.quit or not devInfo then return end
	local name = sender:get_player_name()
	if minetest.is_protected(pos,name) and not minetest.check_player_privs(name,"protection_bypass") then
		minetest.chat_send_player(name,"You are not authorized to use this remote panel.")
		minetest.record_protection_violation(pos,name)
		return
	end
	if fields.ack then
		devInfo.acked = true
	elseif fields.silence and #devInfo.alarm > 0 and devInfo.acked then
		devInfo.silenced = true
	elseif fields.reset and devInfo.acked then
		devInfo.alarm = {}
		devInfo.supervisory = {}
		devInfo.trouble = {}
		devInfo.acked = false
		devInfo.silenced = false
		for i in pairs(devInfo.associatedSignalingDevices) do
			local dev = firealarm.getDevInfo("signaling",minetest.get_position_from_hash(i))
			if dev and not dev.manualReset then
				dev.active = false
			end
		end
	elseif fields.drill then
		table.insert(devInfo.alarm,{initiator = annInfo.associated,name = "Panel Drill Switch"})
		devInfo.acked = false
		devInfo.silenced = false
	end
	firealarm.setDevInfo("panel",pos,devInfo)
	setFormspec(pos)
end

minetest.register_node(":firealarm:annunciator",{
	description = "Remote Fire Panel",
	groups = { oddly_breakable_by_hand = 1,firealarm_annunciator = 1},
	tiles = {
		"firealarm_panel_sides.png",
		"firealarm_panel_sides.png",
		"firealarm_panel_sides.png",
		"firealarm_panel_sides.png",
		"firealarm_panel_sides.png",
		"firealarm_annunciator_front_normal.png",
	},
	paramtype = "light",
	paramtype2 = "facedir",
	light_source = 3,
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.2,0.13,0.4,0.2,0.34,0.5},
		},
	},
	on_punch = function(pos,_,player)
		local name = player:get_player_name()
		minetest.chat_send_player(name,string.format("Position: %d,%d,%d",pos.x,pos.y,pos.z))
	end,
	after_place_node = function(pos)
		firealarm.setDevInfo("annunciator",pos,{})
		setFormspec(pos)
	end,
	after_dig_node = function(pos)
		firealarm.setDevInfo("annunciator",pos,nil)
	end,
	on_receive_fields = handleFields,
})

minetest.register_node(":firealarm:annunciator_alarm",{
	description = "Remote Fire Panel (LEDs on - you hacker!)",
	drop = "firealarm:annunciator",
	groups = { oddly_breakable_by_hand = 1,firealarm_annunciator = 1,not_in_creative_inventory = 1},
	tiles = {
		"firealarm_panel_sides.png",
		"firealarm_panel_sides.png",
		"firealarm_panel_sides.png",
		"firealarm_panel_sides.png",
		"firealarm_panel_sides.png",
		{
			name = "[combine:64x128"..
			       ":0,0=firealarm_annunciator_front_normal.png"..
			       ":0,64=firealarm_annunciator_front_normal.png"..
			       ":0,64=firealarm_panel_led_alarm.png",
			animation = {
				type = "vertical_frames",
				aspect_w = 64,
				aspect_h = 64,
				length = 0.5,
			},
		}
	},
	paramtype = "light",
	paramtype2 = "facedir",
	light_source = 5,
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.2,0.13,0.4,0.2,0.34,0.5},
		},
	},
	on_punch = function(pos,_,player)
		local name = player:get_player_name()
		minetest.chat_send_player(name,string.format("Position: %d,%d,%d",pos.x,pos.y,pos.z))
	end,
	after_dig_node = function(pos)
		firealarm.setDevInfo("annunciator",pos,nil)
	end,
	on_receive_fields = handleFields,
})

minetest.register_node(":firealarm:annunciator_supervisory",{
	description = "Remote Fire Panel (LEDs on - you hacker you!)",
	drop = "firealarm:annunciator",
	groups = { oddly_breakable_by_hand = 1,firealarm_annunciator = 1,not_in_creative_inventory = 1},
	tiles = {
		"firealarm_panel_sides.png",
		"firealarm_panel_sides.png",
		"firealarm_panel_sides.png",
		"firealarm_panel_sides.png",
		"firealarm_panel_sides.png",
		{
			name = "[combine:64x128"..
			       ":0,0=firealarm_annunciator_front_normal.png"..
			       ":0,64=firealarm_annunciator_front_normal.png"..
			       ":0,64=firealarm_panel_led_supervisory.png",
			animation = {
				type = "vertical_frames",
				aspect_w = 64,
				aspect_h = 64,
				length = 0.5,
			},
		}
	},
	paramtype = "light",
	paramtype2 = "facedir",
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.2,0.13,0.4,0.2,0.34,0.5},
		},
	},
	on_punch = function(pos,_,player)
		local name = player:get_player_name()
		minetest.chat_send_player(name,string.format("Position: %d,%d,%d",pos.x,pos.y,pos.z))
	end,
	after_dig_node = function(pos)
		firealarm.setDevInfo("annunciator",pos,nil)
	end,
	on_receive_fields = handleFields,
})

minetest.register_node(":firealarm:annunciator_trouble",{
	description = "Remote Fire Panel (LEDs on - you hacker you!)",
	drop = "firealarm:annunciator",
	groups = { oddly_breakable_by_hand = 1,firealarm_annunciator = 1,not_in_creative_inventory = 1},
	tiles = {
		"firealarm_panel_sides.png",
		"firealarm_panel_sides.png",
		"firealarm_panel_sides.png",
		"firealarm_panel_sides.png",
		"firealarm_panel_sides.png",
		{
			name = "[combine:64x128"..
			       ":0,0=firealarm_annunciator_front_normal.png"..
			       ":0,64=firealarm_annunciator_front_normal.png"..
			       ":0,64=firealarm_panel_led_trouble.png",
			animation = {
				type = "vertical_frames",
				aspect_w = 64,
				aspect_h = 64,
				length = 0.5,
			},
		}
	},
	paramtype = "light",
	paramtype2 = "facedir",
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.2,0.13,0.4,0.2,0.34,0.5},
		},
	},
	on_punch = function(pos,_,player)
		local name = player:get_player_name()
		minetest.chat_send_player(name,string.format("Position: %d,%d,%d",pos.x,pos.y,pos.z))
	end,
	after_dig_node = function(pos)
		firealarm.setDevInfo("annunciator",pos,nil)
	end,
	on_receive_fields = handleFields,
})

minetest.register_node(":firealarm:annunciator_alarm_trouble",{
	description = "Remote Fire Panel (LEDs on - you hacker you!)",
	drop = "firealarm:annunciator",
	groups = { oddly_breakable_by_hand = 1,firealarm_annunciator = 1,not_in_creative_inventory = 1},
	tiles = {
		"firealarm_panel_sides.png",
		"firealarm_panel_sides.png",
		"firealarm_panel_sides.png",
		"firealarm_panel_sides.png",
		"firealarm_panel_sides.png",
		{
			name = "[combine:64x128"..
			       ":0,0=firealarm_annunciator_front_normal.png"..
			       ":0,64=firealarm_annunciator_front_normal.png"..
			       ":0,64=firealarm_panel_led_alarm.png"..
			       ":0,64=firealarm_panel_led_trouble.png",
			animation = {
				type = "vertical_frames",
				aspect_w = 64,
				aspect_h = 64,
				length = 0.5,
			},
		}
	},
	paramtype = "light",
	paramtype2 = "facedir",
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.2,0.13,0.4,0.2,0.34,0.5},
		},
	},
	on_punch = function(pos,_,player)
		local name = player:get_player_name()
		minetest.chat_send_player(name,string.format("Position: %d,%d,%d",pos.x,pos.y,pos.z))
	end,
	after_dig_node = function(pos)
		firealarm.setDevInfo("annunciator",pos,nil)
	end,
	on_receive_fields = handleFields,
})

minetest.register_node(":firealarm:annunciator_alarm_supervisory",{
	description = "Remote Fire Panel (LEDs on - you hacker you!)",
	drop = "firealarm:annunciator",
	groups = { oddly_breakable_by_hand = 1,firealarm_annunciator = 1,not_in_creative_inventory = 1},
	tiles = {
		"firealarm_panel_sides.png",
		"firealarm_panel_sides.png",
		"firealarm_panel_sides.png",
		"firealarm_panel_sides.png",
		"firealarm_panel_sides.png",
		{
			name = "[combine:64x128"..
			       ":0,0=firealarm_annunciator_front_normal.png"..
			       ":0,64=firealarm_annunciator_front_normal.png"..
			       ":0,64=firealarm_panel_led_alarm.png"..
			       ":0,64=firealarm_panel_led_supervisory.png",
			animation = {
				type = "vertical_frames",
				aspect_w = 64,
				aspect_h = 64,
				length = 0.5,
			},
		}
	},
	paramtype = "light",
	paramtype2 = "facedir",
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.2,0.13,0.4,0.2,0.34,0.5},
		},
	},
	on_punch = function(pos,_,player)
		local name = player:get_player_name()
		minetest.chat_send_player(name,string.format("Position: %d,%d,%d",pos.x,pos.y,pos.z))
	end,
	after_dig_node = function(pos)
		firealarm.setDevInfo("annunciator",pos,nil)
	end,
	on_receive_fields = handleFields,
})

minetest.register_node(":firealarm:annunciator_supervisory_trouble",{
	description = "Remote Fire Panel (LEDs on - you hacker you!)",
	drop = "firealarm:annunciator",
	groups = { oddly_breakable_by_hand = 1,firealarm_annunciator = 1,not_in_creative_inventory = 1},
	tiles = {
		"firealarm_panel_sides.png",
		"firealarm_panel_sides.png",
		"firealarm_panel_sides.png",
		"firealarm_panel_sides.png",
		"firealarm_panel_sides.png",
		{
			name = "[combine:64x128"..
			       ":0,0=firealarm_annunciator_front_normal.png"..
			       ":0,64=firealarm_annunciator_front_normal.png"..
			       ":0,64=firealarm_panel_led_supervisory.png"..
			       ":0,64=firealarm_panel_led_trouble.png",
			animation = {
				type = "vertical_frames",
				aspect_w = 64,
				aspect_h = 64,
				length = 0.5,
			},
		}
	},
	paramtype = "light",
	paramtype2 = "facedir",
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.2,0.13,0.4,0.2,0.34,0.5},
		},
	},
	on_punch = function(pos,_,player)
		local name = player:get_player_name()
		minetest.chat_send_player(name,string.format("Position: %d,%d,%d",pos.x,pos.y,pos.z))
	end,
	after_dig_node = function(pos)
		firealarm.setDevInfo("annunciator",pos,nil)
	end,
	on_receive_fields = handleFields,
})

minetest.register_node(":firealarm:annunciator_alarm_supervisory_trouble",{
	description = "Remote Fire Panel (LEDs on - you hacker you!)",
	drop = "firealarm:annunciator",
	groups = { oddly_breakable_by_hand = 1,firealarm_annunciator = 1,not_in_creative_inventory = 1},
	tiles = {
		"firealarm_panel_sides.png",
		"firealarm_panel_sides.png",
		"firealarm_panel_sides.png",
		"firealarm_panel_sides.png",
		"firealarm_panel_sides.png",
		{
			name = "[combine:64x128"..
			       ":0,0=firealarm_annunciator_front_normal.png"..
			       ":0,64=firealarm_annunciator_front_normal.png"..
			       ":0,64=firealarm_panel_led_alarm.png"..
			       ":0,64=firealarm_panel_led_supervisory.png"..
			       ":0,64=firealarm_panel_led_trouble.png",
			animation = {
				type = "vertical_frames",
				aspect_w = 64,
				aspect_h = 64,
				length = 0.5,
			},
		}
	},
	paramtype = "light",
	paramtype2 = "facedir",
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.2,0.13,0.4,0.2,0.34,0.5},
		},
	},
	on_punch = function(pos,_,player)
		local name = player:get_player_name()
		minetest.chat_send_player(name,string.format("Position: %d,%d,%d",pos.x,pos.y,pos.z))
	end,
	after_dig_node = function(pos)
		firealarm.setDevInfo("annunciator",pos,nil)
	end,
	on_receive_fields = handleFields,
})

function firealarm.annunciatorABM(pos)
		local annInfo = firealarm.getDevInfo("annunciator",pos)
		if not annInfo or not annInfo.associated then return end
		local panelPos = minetest.get_position_from_hash(annInfo.associated)
		local devInfo = firealarm.getDevInfo("panel",panelPos)
		if not devInfo then return end
		local node = minetest.get_node(pos)
		local currentName = node.name
		local newName = "firealarm:annunciator"
		if #devInfo.alarm > 0 then newName = newName.."_alarm" end
		if #devInfo.supervisory > 0 then newName = newName.."_supervisory" end
		if #devInfo.trouble > 0 then newName = newName.."_trouble" end
		if newName ~= "firealarm:annunciator" and not devInfo.acked then
			minetest.sound_play("firealarm_annunciator_piezo",{pos = pos,gain = 0.5})
		end
		if currentName ~= newName then
			node.name = newName
			minetest.set_node(pos,node)
		end
		setFormspec(pos)
end

minetest.register_abm({
	label = "Poll devices and update panel status",
	nodenames = {"group:firealarm_annunciator"},
	interval = 1,
	chance = 1,
	action = firealarm.annunciatorABM,
})

minetest.register_craft({
	output = "firealarm:annunciator",
	recipe = {
		{"moreblocks:slab_steelblock_1","","moreblocks:slab_steelblock_1",},
		{"digistuff:touchscreen","mesecons_luacontroller:luacontroller0000","mesecons_lightstone:lightstone_red_off",},
		{"moreblocks:slab_steelblock_1","","moreblocks:slab_steelblock_1",},
	}
})
