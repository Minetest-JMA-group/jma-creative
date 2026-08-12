local function setFormspec(pos)
	local devInfo = firealarm.getDevInfo("panel",pos)
	local meta = minetest.get_meta(pos)
	local fs = "size[10,10]label[0.5,0.5;Fire Alarm Panel]"
	local screen = devInfo.screen
	if screen == "main" then
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
		fs = fs.."button[0.5,7;3,1;add;Add Device]"
		fs = fs.."button[0.5,8;3,1;remove;Remove Device]"
	elseif screen == "add" then
		fs = fs.."label[0.5,2;Add Device]"
		fs = fs.."field[1,4;1,1;x;X;]"
		fs = fs.."field[2,4;1,1;y;Y;]"
		fs = fs.."field[3,4;1,1;z;Z;]"
		fs = fs.."dropdown[0.5,5;3;action;Alarm,Supervisory,Trouble;1]"
		fs = fs.."field[1,6.5;3,1;name;Name;]"
		fs = fs.."button[1,7.5;3,1;add;Add]"
		fs = fs.."button[1,8.5;3,1;cancel;Cancel"
	elseif screen == "remove" then
		fs = fs.."label[0.5,2;Remove Device]"
		local devPresent = false
		for _ in pairs(devInfo.associatedSignalingDevices) do
			devPresent = true
		end
		for _ in pairs(devInfo.associatedNotificationDevices) do
			devPresent = true
		end
		if devPresent then
				devInfo.removeMenuDevList = {}
				fs = fs.."textlist[1,4;3,3;dev;"
				for k,v in pairs(devInfo.associatedSignalingDevices or {}) do
					local dev = {type = "signaling",hash = k}
					table.insert(devInfo.removeMenuDevList,dev)
					fs = fs..minetest.formspec_escape(v.name)..","
				end
				for k,v in pairs(devInfo.associatedNotificationDevices or {}) do
					local dev = {type = "notification",hash = k}
					table.insert(devInfo.removeMenuDevList,dev)
					fs = fs..minetest.formspec_escape(v.name)..","
				end
				for k,v in pairs(devInfo.associatedAnnunciators or {}) do
					local dev = {type = "annunciator",hash = k}
					table.insert(devInfo.removeMenuDevList,dev)
					fs = fs..minetest.formspec_escape(v.name)..","
				end
				for k,v in pairs(devInfo.associatedSprinklerPanels or {}) do
					local dev = {type = "sprinkler_panel", hash = k}
					table.insert(devInfo.removeMenuDevList, dev)
					fs = fs .. minetest.formspec_escape(v.name) .. ","
				end
				fs = string.sub(fs,1,-1).."]"
		else
			fs = fs.."label[0.5,5;No Devices Associated]"
		end
		fs = fs.."button[1,8.5;3,1;cancel;Back"
	end
	meta:set_string("formspec",fs)
end

local function alarm(pos,initiator)
	local devInfo = firealarm.getDevInfo("panel",pos)
	local posHash = minetest.hash_node_position(pos)
	local initiatorHash = minetest.hash_node_position(initiator)
	for _,i in ipairs(devInfo.alarm) do
		if i.initiator == initiatorHash then return end
	end
	local name = "Unknown Device"
	if devInfo.associatedSignalingDevices[initiatorHash] then
		name = devInfo.associatedSignalingDevices[initiatorHash].name
	elseif posHash == initiatorHash then
		name = "Panel Drill Switch"
	end
	if devInfo.associatedSprinklerPanels and devInfo.associatedSprinklerPanels[initiatorHash] then
		name = devInfo.associatedSprinklerPanels[initiatorHash].name
	end
	table.insert(devInfo.alarm,{initiator = initiatorHash,name = name})
	devInfo.acked = false
	devInfo.silenced = false
	firealarm.setDevInfo("panel",pos,devInfo)
	setFormspec(pos)
end

local function supervisory(pos,initiator)
	local devInfo = firealarm.getDevInfo("panel",pos)
	local initiatorHash = minetest.hash_node_position(initiator)
	for _,i in ipairs(devInfo.supervisory) do
		if i.initiator == initiatorHash then return end
	end
	local name = "Unknown Device"
	if devInfo.associatedSignalingDevices[initiatorHash] then
		name = devInfo.associatedSignalingDevices[initiatorHash].name
	end
	if devInfo.associatedSprinklerPanels and devInfo.associatedSprinklerPanels[initiatorHash] then
		name = devInfo.associatedSprinklerPanels[initiatorHash].name
	end
	table.insert(devInfo.supervisory,{initiator = initiatorHash,name = name})
	devInfo.acked = false
	firealarm.setDevInfo("panel",pos,devInfo)
	setFormspec(pos)
end

local function trouble(pos,initiator)
	local devInfo = firealarm.getDevInfo("panel",pos)
	local initiatorHash = minetest.hash_node_position(initiator)
	for _,i in ipairs(devInfo.trouble) do
		if i.initiator == initiatorHash then return end
	end
	local name = "Unknown Device"
	if devInfo.associatedSignalingDevices[initiatorHash] then
		name = devInfo.associatedSignalingDevices[initiatorHash].name
	end
	if devInfo.associatedNotificationDevices[initiatorHash] then
		name = devInfo.associatedNotificationDevices[initiatorHash].name
	end
	if devInfo.associatedAnnunciators[initiatorHash] then
		name = devInfo.associatedAnnunciators[initiatorHash].name
	end
	if devInfo.associatedSprinklerPanels and devInfo.associatedSprinklerPanels[initiatorHash] then
		name = devInfo.associatedSprinklerPanels[initiatorHash].name
	end
	table.insert(devInfo.trouble,{initiator = initiatorHash,name = name})
	devInfo.acked = false
	firealarm.setDevInfo("panel",pos,devInfo)
	setFormspec(pos)
end

local function handleFields(pos,_,fields,sender)
	local devInfo = firealarm.getDevInfo("panel",pos)
	if not devInfo then return end
	local screen = devInfo.screen
	if fields.quit then return end
	local name = sender:get_player_name()
	if minetest.is_protected(pos,name) and not minetest.check_player_privs(name,"protection_bypass") then
		minetest.chat_send_player(name,"You are not authorized to use this panel.")
		minetest.record_protection_violation(pos,name)
		return
	end
	if screen == "main" then
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
				if not dev then
					trouble(pos,minetest.get_position_from_hash(i))
				elseif not dev.manualReset then
					dev.active = false
					firealarm.setDevInfo(
						"signaling",
						minetest.get_position_from_hash(i),
						dev
					)
				end
			end
		elseif fields.drill then
			alarm(pos,pos)
		elseif fields.add then
			devInfo.screen = "add"
		elseif fields.remove then
			devInfo.screen = "remove"
		end
	elseif screen == "add" then
		if fields.add or fields.cancel then
			devInfo.screen = "main"
		end
		if fields.add then
			if (tonumber(fields.x) and tonumber(fields.y) and tonumber(fields.z)) then
				local targetPos = {x = fields.x,y = fields.y,z = fields.z}
				local targetInfo = firealarm.getDevInfo("signaling",targetPos)
				if targetInfo then
					if (minetest.is_protected(pos,name) and not minetest.check_player_privs(name,"protection_bypass")) or targetInfo.associated then
						minetest.chat_send_player(name,"Device is protected or already associated")
					else
						targetInfo.associated = minetest.hash_node_position(pos)
						local devParams = {}
						devParams.name = fields.name
						devParams.action = fields.action
						devInfo.associatedSignalingDevices[minetest.hash_node_position(targetPos)] = devParams
					end
				else
					targetInfo = firealarm.getDevInfo("notification",targetPos)
					if targetInfo then
						if (minetest.is_protected(pos,name) and not minetest.check_player_privs(name,"protection_bypass")) or targetInfo.associated then
							minetest.chat_send_player(name,"Device is protected or already associated")
						else
							targetInfo.associated = minetest.hash_node_position(pos)
							local devParams = {}
							devParams.name = fields.name
							devInfo.associatedNotificationDevices[minetest.hash_node_position(targetPos)] = devParams
						end
					else
						targetInfo = firealarm.getDevInfo("annunciator",targetPos)
						if targetInfo then
							if (minetest.is_protected(pos,name) and not minetest.check_player_privs(name,"protection_bypass")) or targetInfo.associated then
								minetest.chat_send_player(name,"Device is protected or already associated")
							else
								targetInfo.associated = minetest.hash_node_position(pos)
								local devParams = {}
								devParams.name = fields.name
								if not devInfo.associatedAnnunciators then
									devInfo.associatedAnnunciators = {}
								end
								devInfo.associatedAnnunciators[minetest.hash_node_position(targetPos)] = devParams
							end
						else
							targetInfo = sprinkler.getDevInfo("panel", targetPos)

							if targetInfo then
								targetInfo.facp = minetest.hash_node_position(pos)
								sprinkler.setDevInfo("panel", targetPos, targetInfo)
								if not devInfo.associatedSprinklerPanels then
									devInfo.associatedSprinklerPanels = {}
								end
								devInfo.associatedSprinklerPanels[minetest.hash_node_position(targetPos)] = { name = fields.name }
							else
								minetest.chat_send_player(name,"Not a valid fire alarm device")
							end
						end
					end
				end
			else
				minetest.chat_send_player(name,"Invalid position")
			end
		end
	elseif screen == "remove" then
		if fields.cancel then
			devInfo.screen = "main"
		end
		if fields.dev and string.sub(fields.dev,1,3) == "DCL" then
			local dev = devInfo.removeMenuDevList[tonumber(string.sub(fields.dev,5,-1))]
			if dev then
				if dev.type == "signaling" then
					devInfo.associatedSignalingDevices[dev.hash] = nil
					local targetPos = minetest.get_position_from_hash(dev.hash)
					local targetInfo = firealarm.getDevInfo("signaling",targetPos)
					if targetInfo then
						targetInfo.associated = nil
						firealarm.setDevInfo("signaling",targetPos,targetInfo)
					end
				elseif dev.type == "notification" then
					devInfo.associatedNotificationDevices[dev.hash] = nil
					local targetPos = minetest.get_position_from_hash(dev.hash)
					local targetInfo = firealarm.getDevInfo("notification",targetPos)
					if targetInfo then
						targetInfo.associated = nil
						targetInfo.hornActive = false
						targetInfo.strobeActive = false
						firealarm.setDevInfo("notification",targetPos,targetInfo)
					end
				elseif dev.type == "annunciator" then
					devInfo.associatedAnnunciators[dev.hash] = nil
					local targetPos = minetest.get_position_from_hash(dev.hash)
					local targetInfo = firealarm.getDevInfo("annunciator",targetPos)
					if targetInfo then
						targetInfo.associated = nil
						firealarm.setDevInfo("annunciator",targetPos,targetInfo)
					end
				elseif dev.type == "sprinkler_panel" then
					devInfo.associatedSprinklerPanels[dev.hash] = nil
					local targetPos = minetest.get_position_from_hash(dev.hash)
					local targetInfo = sprinkler.getDevInfo("panel", targetPos)
					if targetInfo then
						targetInfo.facp = nil
						sprinkler.setDevInfo("panel", targetPos, targetInfo)
					end
				end
			end
		end
	end
	firealarm.setDevInfo("panel",pos,devInfo)
	setFormspec(pos)
end

minetest.register_node(":firealarm:panel",{
	description = "Fire Alarm Panel",
	groups = { oddly_breakable_by_hand = 1,firealarm_panel = 1},
	tiles = {
		"firealarm_panel_sides.png",
		"firealarm_panel_sides.png",
		"firealarm_panel_sides.png",
		"firealarm_panel_sides.png",
		"firealarm_panel_sides.png",
		"firealarm_panel_front_normal.png",
	},
	paramtype = "light",
	paramtype2 = "facedir",
	light_source = 3,
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.5,-0.5,0.4,0.5,0.5,0.5},
		},
	},
	after_place_node = function(pos)
		firealarm.setDevInfo("panel",pos,{
			associatedSignalingDevices = {},
			associatedNotificationDevices = {},
			associatedAnnunciators = {},
			associatedSprinklerPanels = {},
			removeMenuDevList = {},
			alarm = {},
			supervisory = {},
			trouble = {},
			acked = false,
			silenced = false,
			screen = "main",
		})
		setFormspec(pos)
	end,
	after_dig_node = function(pos)
		firealarm.setDevInfo("panel",pos,nil)
	end,
	on_receive_fields = handleFields,
})

minetest.register_node(":firealarm:panel_alarm",{
	description = "Fire Alarm Panel (LEDs on - you hacker you!)",
	drop = "firealarm:panel",
	groups = { oddly_breakable_by_hand = 1,firealarm_panel = 1,not_in_creative_inventory = 1},
	tiles = {
		"firealarm_panel_sides.png",
		"firealarm_panel_sides.png",
		"firealarm_panel_sides.png",
		"firealarm_panel_sides.png",
		"firealarm_panel_sides.png",
		{
			name = "[combine:64x128"..
			":0,0=firealarm_panel_front_normal.png"..
			":0,64=firealarm_panel_front_normal.png"..
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
			{-0.5,-0.5,0.4,0.5,0.5,0.5},
		},
	},
	after_dig_node = function(pos)
		firealarm.setDevInfo("panel",pos,nil)
	end,
	on_receive_fields = handleFields,
})

minetest.register_node(":firealarm:panel_supervisory",{
	description = "Fire Alarm Panel (LEDs on - you hacker you!)",
	drop = "firealarm:panel",
	groups = { oddly_breakable_by_hand = 1,firealarm_panel = 1,not_in_creative_inventory = 1},
	tiles = {
		"firealarm_panel_sides.png",
		"firealarm_panel_sides.png",
		"firealarm_panel_sides.png",
		"firealarm_panel_sides.png",
		"firealarm_panel_sides.png",
		{
			name = "[combine:64x128"..
			":0,0=firealarm_panel_front_normal.png"..
			":0,64=firealarm_panel_front_normal.png"..
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
			{-0.5,-0.5,0.4,0.5,0.5,0.5},
		},
	},
	after_dig_node = function(pos)
		firealarm.setDevInfo("panel",pos,nil)
	end,
	on_receive_fields = handleFields,
})

minetest.register_node(":firealarm:panel_trouble",{
	description = "Fire Alarm Panel (LEDs on - you hacker you!)",
	drop = "firealarm:panel",
	groups = { oddly_breakable_by_hand = 1,firealarm_panel = 1,not_in_creative_inventory = 1},
	tiles = {
		"firealarm_panel_sides.png",
		"firealarm_panel_sides.png",
		"firealarm_panel_sides.png",
		"firealarm_panel_sides.png",
		"firealarm_panel_sides.png",
		{
			name = "[combine:64x128"..
			":0,0=firealarm_panel_front_normal.png"..
			":0,64=firealarm_panel_front_normal.png"..
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
			{-0.5,-0.5,0.4,0.5,0.5,0.5},
		},
	},
	after_dig_node = function(pos)
		firealarm.setDevInfo("panel",pos,nil)
	end,
	on_receive_fields = handleFields,
})

minetest.register_node(":firealarm:panel_alarm_trouble",{
	description = "Fire Alarm Panel (LEDs on - you hacker you!)",
	drop = "firealarm:panel",
	groups = { oddly_breakable_by_hand = 1,firealarm_panel = 1,not_in_creative_inventory = 1},
	tiles = {
		"firealarm_panel_sides.png",
		"firealarm_panel_sides.png",
		"firealarm_panel_sides.png",
		"firealarm_panel_sides.png",
		"firealarm_panel_sides.png",
		{
			name = "[combine:64x128"..
			":0,0=firealarm_panel_front_normal.png"..
			":0,64=firealarm_panel_front_normal.png"..
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
			{-0.5,-0.5,0.4,0.5,0.5,0.5},
		},
	},
	after_dig_node = function(pos)
		firealarm.setDevInfo("panel",pos,nil)
	end,
	on_receive_fields = handleFields,
})

minetest.register_node(":firealarm:panel_alarm_supervisory",{
	description = "Fire Alarm Panel (LEDs on - you hacker you!)",
	drop = "firealarm:panel",
	groups = { oddly_breakable_by_hand = 1,firealarm_panel = 1,not_in_creative_inventory = 1},
	tiles = {
		"firealarm_panel_sides.png",
		"firealarm_panel_sides.png",
		"firealarm_panel_sides.png",
		"firealarm_panel_sides.png",
		"firealarm_panel_sides.png",
		{
			name = "[combine:64x128"..
			":0,0=firealarm_panel_front_normal.png"..
			":0,64=firealarm_panel_front_normal.png"..
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
			{-0.5,-0.5,0.4,0.5,0.5,0.5},
		},
	},
	after_dig_node = function(pos)
		firealarm.setDevInfo("panel",pos,nil)
	end,
	on_receive_fields = handleFields,
})

minetest.register_node(":firealarm:panel_supervisory_trouble",{
	description = "Fire Alarm Panel (LEDs on - you hacker you!)",
	drop = "firealarm:panel",
	groups = { oddly_breakable_by_hand = 1,firealarm_panel = 1,not_in_creative_inventory = 1},
	tiles = {
		"firealarm_panel_sides.png",
		"firealarm_panel_sides.png",
		"firealarm_panel_sides.png",
		"firealarm_panel_sides.png",
		"firealarm_panel_sides.png",
		{
			name = "[combine:64x128"..
			":0,0=firealarm_panel_front_normal.png"..
			":0,64=firealarm_panel_front_normal.png"..
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
			{-0.5,-0.5,0.4,0.5,0.5,0.5},
		},
	},
	after_dig_node = function(pos)
		firealarm.setDevInfo("panel",pos,nil)
	end,
	on_receive_fields = handleFields,
})

minetest.register_node(":firealarm:panel_alarm_supervisory_trouble",{
	description = "Fire Alarm Panel (LEDs on - you hacker you!)",
	drop = "firealarm:panel",
	groups = { oddly_breakable_by_hand = 1,firealarm_panel = 1,not_in_creative_inventory = 1},
	tiles = {
		"firealarm_panel_sides.png",
		"firealarm_panel_sides.png",
		"firealarm_panel_sides.png",
		"firealarm_panel_sides.png",
		"firealarm_panel_sides.png",
		{
			name = "[combine:64x128"..
			":0,0=firealarm_panel_front_normal.png"..
			":0,64=firealarm_panel_front_normal.png"..
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
			{-0.5,-0.5,0.4,0.5,0.5,0.5},
		},
	},
	after_dig_node = function(pos)
		firealarm.setDevInfo("panel",pos,nil)
	end,
	on_receive_fields = handleFields,
})

function firealarm.panelABM(pos)
		local node = minetest.get_node(pos)
		local devInfo = firealarm.getDevInfo("panel",pos)
		if not devInfo then
			firealarm.markDecommissioned(pos)
			return
		end
		if not devInfo.associatedAnnunciators then devInfo.associatedAnnunciators = {} end
		local hornsActive = #devInfo.alarm > 0 and not devInfo.silenced
		local strobesActive = #devInfo.alarm > 0
		for i in pairs(devInfo.associatedNotificationDevices) do
			local devPos = minetest.get_position_from_hash(i)
			local dev = firealarm.getDevInfo("notification", devPos)
			if not dev then
				trouble(pos, devPos)
			else
				local devNode = minetest.get_node(devPos)
				if devNode.name ~= "ignore" and devNode.name:sub(1, 10) ~= "firealarm:" then
					-- The device node is gone; drop the stale entry.
					firealarm.setDevInfo("notification", devPos, nil)
				else
					dev.hornActive = hornsActive
					dev.strobeActive = strobesActive
					firealarm.setDevInfo("notification", devPos, dev)
				end
			end
		end
		for i,v in pairs(devInfo.associatedSignalingDevices) do
			local dev = firealarm.getDevInfo("signaling",minetest.get_position_from_hash(i))
			if not dev then
				trouble(pos,minetest.get_position_from_hash(i))
			else
				local devNode = minetest.get_node(minetest.get_position_from_hash(i))
				if devNode.name ~= "ignore" and devNode.name:sub(1, 10) ~= "firealarm:" then
					-- The device node is gone; drop the stale entry.
					firealarm.setDevInfo("signaling", minetest.get_position_from_hash(i), nil)
				elseif dev.active then
					if v.action == "Alarm" then
						alarm(pos,minetest.get_position_from_hash(i))
					elseif v.action == "Supervisory" then
						supervisory(pos,minetest.get_position_from_hash(i))
					elseif v.action == "Trouble" then
						trouble(pos,minetest.get_position_from_hash(i))
					end
				end
			end
		end
		for i in pairs(devInfo.associatedAnnunciators) do
			local dev = firealarm.getDevInfo("annunciator",minetest.get_position_from_hash(i))
			if not dev then
				trouble(pos,minetest.get_position_from_hash(i))
			else
				local devNode = minetest.get_node(minetest.get_position_from_hash(i))
				if devNode.name ~= "ignore" and devNode.name:sub(1, 10) ~= "firealarm:" then
					-- The device node is gone; drop the stale entry.
					firealarm.setDevInfo("annunciator", minetest.get_position_from_hash(i), nil)
				end
			end
		end
		if devInfo.associatedSprinklerPanels then
			for i in pairs(devInfo.associatedSprinklerPanels) do
				local sp = sprinkler.getDevInfo(
					"panel",
					minetest.get_position_from_hash(i)
				)
				if sp and sp.active then
					alarm(pos, minetest.get_position_from_hash(i))
				end
			end
		end
		local currentName = node.name
		local newName = "firealarm:panel"
		if #devInfo.alarm > 0 then newName = newName.."_alarm" end
		if #devInfo.supervisory > 0 then newName = newName.."_supervisory" end
		if #devInfo.trouble > 0 then newName = newName.."_trouble" end
		if newName ~= "firealarm:panel" and not devInfo.acked then
			minetest.sound_play("firealarm_panel_piezo",{pos = pos,gain = 0.5})
		end
		if currentName ~= newName then
			node.name = newName
			minetest.set_node(pos,node)
		end
		setFormspec(pos)
end

minetest.register_abm({
	label = "Poll devices and update panel status",
	nodenames = {"group:firealarm_panel"},
	interval = 1,
	chance = 1,
	action = firealarm.panelABM,
})

minetest.register_craft({
	output = "firealarm:panel",
	recipe = {
		{"moreblocks:slab_steelblock_1","moreblocks:slab_steelblock_1","moreblocks:slab_steelblock_1",},
		{"moreblocks:slab_steelblock_1","firealarm:annunciator","moreblocks:slab_steelblock_1",},
		{"moreblocks:slab_steelblock_1","mesecons:wire_00000000_off","moreblocks:slab_steelblock_1",},
	}
})
