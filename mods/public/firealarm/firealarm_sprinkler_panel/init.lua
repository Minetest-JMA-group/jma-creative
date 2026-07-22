local function setFormspec(pos)
	local devInfo = sprinkler.getDevInfo("panel",pos)
	local meta = minetest.get_meta(pos)
	local fs = "size[10,10]label[0.5,0.5;Sprinkler Panel]"
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
				for k,v in pairs(devInfo.associatedSignalingDevices) do
					local dev = {type = "signaling",hash = k}
					table.insert(devInfo.removeMenuDevList,dev)
					fs = fs..minetest.formspec_escape(v.name)..","
				end
				for k,v in pairs(devInfo.associatedNotificationDevices) do
					local dev = {type = "notification",hash = k}
					table.insert(devInfo.removeMenuDevList,dev)
					fs = fs..minetest.formspec_escape(v.name)..","
				end
				for k,v in pairs(devInfo.associatedAnnunciators) do
					local dev = {type = "annunciator",hash = k}
					table.insert(devInfo.removeMenuDevList,dev)
					fs = fs..minetest.formspec_escape(v.name)..","
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
	local devInfo = sprinkler.getDevInfo("panel",pos)
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
	table.insert(devInfo.alarm,{initiator = initiatorHash,name = name})
	devInfo.acked = false
	devInfo.silenced = false
	sprinkler.setDevInfo("panel",pos,devInfo)
	setFormspec(pos)
end

local function supervisory(pos,initiator)
	local devInfo = sprinkler.getDevInfo("panel",pos)
	local initiatorHash = minetest.hash_node_position(initiator)
	for _,i in ipairs(devInfo.supervisory) do
		if i.initiator == initiatorHash then return end
	end
	local name = "Unknown Device"
	if devInfo.associatedSignalingDevices[initiatorHash] then
		name = devInfo.associatedSignalingDevices[initiatorHash].name
	end
	table.insert(devInfo.supervisory,{initiator = initiatorHash,name = name})
	devInfo.acked = false
	sprinkler.setDevInfo("panel",pos,devInfo)
	setFormspec(pos)
end

local function trouble(pos,initiator)
	local devInfo = sprinkler.getDevInfo("panel",pos)
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
	table.insert(devInfo.trouble,{initiator = initiatorHash,name = name})
	devInfo.acked = false
	sprinkler.setDevInfo("panel",pos,devInfo)
	setFormspec(pos)
end

local function handleFields(pos,_,fields,sender)
	local devInfo = sprinkler.getDevInfo("panel",pos)
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
				local dev = sprinkler.getDevInfo("signaling",minetest.get_position_from_hash(i))
				if not dev then
					trouble(pos,minetest.get_position_from_hash(i))
				elseif not dev.manualReset then
					dev.active = false
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
				local targetInfo = sprinkler.getDevInfo("signaling",targetPos)
				if targetInfo then
					if (minetest.is_protected(pos,name) and not minetest.check_player_privs(name,"protection_bypass")) or targetInfo.associated then
						minetest.chat_send_player(name,"Device is protected or already associated")
					else
						targetInfo.associated = minetest.hash_node_position(pos)
                                                sprinkler.setDevInfo("signaling", targetPos, targetInfo)
						local devParams = {}
						devParams.name = fields.name
						devParams.action = fields.action
						devInfo.associatedSignalingDevices[minetest.hash_node_position(targetPos)] = devParams
					end
				else
					targetInfo = sprinkler.getDevInfo("notification",targetPos)
					if targetInfo then
						if (minetest.is_protected(pos,name) and not minetest.check_player_privs(name,"protection_bypass")) or targetInfo.associated then
							minetest.chat_send_player(name,"Device is protected or already associated")
						else
							targetInfo.associated = minetest.hash_node_position(pos)
                                                        sprinkler.setDevInfo("notification", targetPos, targetInfo)
							local devParams = {}
							devParams.name = fields.name
							devInfo.associatedNotificationDevices[minetest.hash_node_position(targetPos)] = devParams
						end
					else
						targetInfo = sprinkler.getDevInfo("annunciator",targetPos)
						if targetInfo then
							if (minetest.is_protected(pos,name) and not minetest.check_player_privs(name,"protection_bypass")) or targetInfo.associated then
								minetest.chat_send_player(name,"Device is protected or already associated")
							else
								targetInfo.associated = minetest.hash_node_position(pos)
                                                                sprinkler.setDevInfo("annunciator", targetPos, targetInfo)
								local devParams = {}
								devParams.name = fields.name
								if not devInfo.associatedAnnunciators then
									devInfo.associatedAnnunciators = {}
								end
								devInfo.associatedAnnunciators[minetest.hash_node_position(targetPos)] = devParams
							end
						else
							minetest.chat_send_player(name,"Not a valid fire alarm device")
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
					local targetInfo = sprinkler.getDevInfo("signaling",targetPos)
					if targetInfo then
						targetInfo.associated = nil
						sprinkler.setDevInfo("signaling",targetPos,targetInfo)
					end
				elseif dev.type == "notification" then
					devInfo.associatedNotificationDevices[dev.hash] = nil
					local targetPos = minetest.get_position_from_hash(dev.hash)
					local targetInfo = sprinkler.getDevInfo("notification",targetPos)
					if targetInfo then
						targetInfo.associated = nil
						targetInfo.hornActive = false
						targetInfo.strobeActive = false
						sprinkler.setDevInfo("notification",targetPos,targetInfo)
					end
				elseif dev.type == "annunciator" then
					devInfo.associatedAnnunciators[dev.hash] = nil
					local targetPos = minetest.get_position_from_hash(dev.hash)
					local targetInfo = sprinkler.getDevInfo("annunciator",targetPos)
					if targetInfo then
						targetInfo.associated = nil
						sprinkler.setDevInfo("annunciator",targetPos,targetInfo)
					end
				end
			end
		end
	end
	sprinkler.setDevInfo("panel",pos,devInfo)
	setFormspec(pos)
end

minetest.register_node(":firealarm:sprinkler_panel",{
	description = "Sprinkler Panel",
	groups = { oddly_breakable_by_hand = 1,sprinkler_panel = 1},
	tiles = {
		"firealarm_sprinkler_panel_sides.png",
		"firealarm_sprinkler_panel_sides.png",
		"firealarm_sprinkler_panel_sides.png",
		"firealarm_sprinkler_panel_sides.png",
		"firealarm_sprinkler_panel_sides.png",
		"firealarm_sprinkler_panel_front_normal.png",
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
                sprinkler.setDevInfo("panel", pos, {
                        associatedSignalingDevices = {},
                        associatedNotificationDevices = {},
                        associatedAnnunciators = {},
                        removeMenuDevList = {},
                        alarm = {},
                        supervisory = {},
                        trouble = {},
                        acked = false,
                        silenced = false,
                        screen = "main",
                        active = false,
                        facp = nil,
                })
                setFormspec(pos)
        end,
        after_dig_node = function(pos)
                    sprinkler.setDevInfo("panel", pos, nil)
        end,
	on_receive_fields = handleFields,
})

minetest.register_node(":firealarm:sprinkler_panel_alarm",{
	description = "Sprinkler Panel (LEDs on - you hacker you!)",
	drop = "firealarm:sprinkler_panel",
	groups = { oddly_breakable_by_hand = 1,sprinkler_panel = 1,not_in_creative_inventory = 1},
	tiles = {
		"firealarm_sprinkler_panel_sides.png",
		"firealarm_sprinkler_panel_sides.png",
		"firealarm_sprinkler_panel_sides.png",
		"firealarm_sprinkler_panel_sides.png",
		"firealarm_sprinkler_panel_sides.png",
		{
			name = "[combine:64x128"..
			       ":0,0=firealarm_sprinkler_panel_front_normal.png"..
			       ":0,64=firealarm_sprinkler_panel_front_normal.png"..
			       ":0,64=firealarm_sprinkler_panel_led_alarm.png",
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
		sprinkler.setDevInfo("panel",pos,nil)
	end,
	on_receive_fields = handleFields,
})

minetest.register_node(":firealarm:sprinkler_panel_supervisory",{
	description = "Sprinkler Panel (LEDs on - you hacker you!)",
	drop = "firealarm:sprinkler_panel",
	groups = { oddly_breakable_by_hand = 1,sprinkler_panel = 1,not_in_creative_inventory = 1},
	tiles = {
		"firealarm_sprinkler_panel_sides.png",
		"firealarm_sprinkler_panel_sides.png",
		"firealarm_sprinkler_panel_sides.png",
		"firealarm_sprinkler_panel_sides.png",
		"firealarm_sprinkler_panel_sides.png",
		{
			name = "[combine:64x128"..
			       ":0,0=firealarm_sprinkler_panel_front_normal.png"..
			       ":0,64=firealarm_sprinkler_panel_front_normal.png"..
			       ":0,64=firealarm_sprinkler_panel_led_supervisory.png",
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
		sprinkler.setDevInfo("panel",pos,nil)
	end,
	on_receive_fields = handleFields,
})

minetest.register_node(":firealarm:sprinkler_panel_trouble",{
	description = "Sprinkler Panel (LEDs on - you hacker you!)",
	drop = "firealarm:sprinkler_panel",
	groups = { oddly_breakable_by_hand = 1,sprinkler_panel = 1,not_in_creative_inventory = 1},
	tiles = {
		"firealarm_sprinkler_panel_sides.png",
		"firealarm_sprinkler_panel_sides.png",
		"firealarm_sprinkler_panel_sides.png",
		"firealarm_sprinkler_panel_sides.png",
		"firealarm_sprinkler_panel_sides.png",
		{
			name = "[combine:64x128"..
			       ":0,0=firealarm_sprinkler_panel_front_normal.png"..
			       ":0,64=firealarm_sprinkler_panel_front_normal.png"..
			       ":0,64=firealarm_sprinkler_panel_led_trouble.png",
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
		sprinkler.setDevInfo("panel",pos,nil)
	end,
	on_receive_fields = handleFields,
})

minetest.register_node(":firealarm:sprinkler_panel_alarm_trouble",{
	description = "Sprinkler Panel (LEDs on - you hacker you!)",
	drop = "firealarm:sprinkler_panel",
	groups = { oddly_breakable_by_hand = 1,sprinkler_panel = 1,not_in_creative_inventory = 1},
	tiles = {
		"firealarm_sprinkler_panel_sides.png",
		"firealarm_sprinkler_panel_sides.png",
		"firealarm_sprinkler_panel_sides.png",
		"firealarm_sprinkler_panel_sides.png",
		"firealarm_sprinkler_panel_sides.png",
		{
			name = "[combine:64x128"..
			       ":0,0=firealarm_sprinkler_panel_front_normal.png"..
			       ":0,64=firealarm_sprinkler_panel_front_normal.png"..
			       ":0,64=firealarm_sprinkler_panel_led_alarm.png"..
			       ":0,64=firealarm_sprinkler_panel_led_trouble.png",
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
		sprinkler.setDevInfo("panel",pos,nil)
	end,
	on_receive_fields = handleFields,
})

minetest.register_node(":firealarm:sprinkler_panel_alarm_supervisory",{
	description = "Sprinkler Panel (LEDs on - you hacker you!)",
	drop = "firealarm:sprinkler_panel",
	groups = { oddly_breakable_by_hand = 1,sprinkler_panel = 1,not_in_creative_inventory = 1},
	tiles = {
		"firealarm_sprinkler_panel_sides.png",
		"firealarm_sprinkler_panel_sides.png",
		"firealarm_sprinkler_panel_sides.png",
		"firealarm_sprinkler_panel_sides.png",
		"firealarm_sprinkler_panel_sides.png",
		{
			name = "[combine:64x128"..
			       ":0,0=firealarm_sprinkler_panel_front_normal.png"..
			       ":0,64=firealarm_sprinkler_panel_front_normal.png"..
			       ":0,64=firealarm_sprinkler_panel_led_alarm.png"..
			       ":0,64=firealarm_sprinkler_panel_led_supervisory.png",
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
		sprinkler.setDevInfo("panel",pos,nil)
	end,
	on_receive_fields = handleFields,
})

minetest.register_node(":firealarm:sprinkler_panel_supervisory_trouble",{
	description = "Sprinkler Panel (LEDs on - you hacker you!)",
	drop = "firealarm:sprinkler_panel",
	groups = { oddly_breakable_by_hand = 1,sprinkler_panel = 1,not_in_creative_inventory = 1},
	tiles = {
		"firealarm_sprinkler_panel_sides.png",
		"firealarm_sprinkler_panel_sides.png",
		"firealarm_sprinkler_panel_sides.png",
		"firealarm_sprinkler_panel_sides.png",
		"firealarm_sprinkler_panel_sides.png",
		{
			name = "[combine:64x128"..
			       ":0,0=firealarm_sprinkler_panel_front_normal.png"..
			       ":0,64=firealarm_sprinkler_panel_front_normal.png"..
			       ":0,64=firealarm_sprinkler_panel_led_supervisory.png"..
			       ":0,64=firealarm_sprinkler_panel_led_trouble.png",
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
		sprinkler.setDevInfo("panel",pos,nil)
	end,
	on_receive_fields = handleFields,
})

minetest.register_node(":firealarm:sprinkler_panel_alarm_supervisory_trouble",{
	description = "Sprinkler Panel (LEDs on - you hacker you!)",
	drop = "firealarm:sprinkler_panel",
	groups = { oddly_breakable_by_hand = 1,sprinkler_panel = 1,not_in_creative_inventory = 1},
	tiles = {
		"firealarm_sprinkler_panel_sides.png",
		"firealarm_sprinkler_panel_sides.png",
		"firealarm_sprinkler_panel_sides.png",
		"firealarm_sprinkler_panel_sides.png",
		"firealarm_sprinkler_panel_sides.png",
		{
			name = "[combine:64x128"..
			       ":0,0=firealarm_sprinkler_panel_front_normal.png"..
			       ":0,64=firealarm_sprinkler_panel_front_normal.png"..
			       ":0,64=firealarm_sprinkler_panel_led_alarm.png"..
			       ":0,64=firealarm_sprinkler_panel_led_supervisory.png"..
			       ":0,64=firealarm_sprinkler_panel_led_trouble.png",
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
		sprinkler.setDevInfo("panel",pos,nil)
	end,
	on_receive_fields = handleFields,
})

function sprinkler.panelABM(pos)
	local devInfo = sprinkler.getDevInfo("panel", pos)
	if not devInfo then return end

        if devInfo.associatedSprinklerPanels then
                for hash in pairs(devInfo.associatedSprinklerPanels) do
                        local spos = minetest.get_position_from_hash(hash)
                        local spsp = sprinkler.getDevInfo("panel", spos)
                        if spsp then
                                spsp.external_alarm = (#devInfo.alarm > 0)
                                sprinkler.setDevInfo("panel", spos, spsp)
                        end
                end
        end

	if devInfo.external_alarm then
		local controller_pos = devInfo.controller_pos

		if controller_pos then
			local ctrl = sprinkler.getDevInfo("controller", controller_pos)

			if ctrl then
				ctrl.active = true
				sprinkler.setDevInfo("controller", controller_pos, ctrl)
			end
		end
	end

	local node = minetest.get_node(pos)
	local devInfo = sprinkler.getDevInfo("panel",pos)
	if not devInfo then return end

	if not devInfo.associatedAnnunciators then devInfo.associatedAnnunciators = {} end
	local hornsActive = #devInfo.alarm > 0 and not devInfo.silenced
	local strobesActive = #devInfo.alarm > 0
	for i in pairs(devInfo.associatedNotificationDevices) do
		local devPos = minetest.get_position_from_hash(i)
		local dev = sprinkler.getDevInfo("notification", devPos)
		if not dev then
			trouble(pos, devPos)
		else
			dev.hornActive = hornsActive
			dev.strobeActive = strobesActive
			sprinkler.setDevInfo("notification", devPos, dev)
		end
	end
	for i,v in pairs(devInfo.associatedSignalingDevices) do
		local dev = sprinkler.getDevInfo("signaling",minetest.get_position_from_hash(i))
		if not dev then
			trouble(pos,minetest.get_position_from_hash(i))
			else				if dev.active then
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
		local dev = sprinkler.getDevInfo("annunciator",minetest.get_position_from_hash(i))
		if not dev then
			trouble(pos,minetest.get_position_from_hash(i))
		end
	end
	local currentName = node.name
	local newName = "firealarm:sprinkler_panel"
	if #devInfo.alarm > 0 then newName = newName.."_alarm" end
	if #devInfo.supervisory > 0 then newName = newName.."_supervisory" end
	if #devInfo.trouble > 0 then newName = newName.."_trouble" end
	if newName ~= "firealarm:sprinkler_panel" and not devInfo.acked then
		minetest.sound_play("firealarm_sprinkler_panel_piezo",{pos = pos,gain = 0.5})
                devInfo.active = true
                sprinkler.setDevInfo("panel", pos, devInfo)
	end
	if currentName ~= newName then
		node.name = newName
		minetest.set_node(pos,node)
	end
	setFormspec(pos)
end

minetest.register_abm({
	label = "Poll devices and update panel status",
	nodenames = {"group:sprinkler_panel"},
	interval = 1,
	chance = 1,
	action = sprinkler.panelABM,
})

minetest.register_craft({
	output = "firealarm:sprinkler_panel",
	recipe = {
		{"moreblocks:slab_steelblock_1","moreblocks:slab_steelblock_1","moreblocks:slab_steelblock_1",},
		{"moreblocks:slab_steelblock_1","firealarm:sprinkler_annunciator","moreblocks:slab_steelblock_1",},
		{"moreblocks:slab_steelblock_1","mesecons:wire_00000000_off","moreblocks:slab_steelblock_1",},
	}
})

minetest.register_abm({
    nodenames = {"group:sprinkler_panel"},
    interval = 1,
    chance = 1,
    action = function(pos)
        local panel = sprinkler.getDevInfo("panel", pos)
        if not panel then return end

        panel.active = (#panel.alarm > 0)
        sprinkler.setDevInfo("panel", pos, panel)
    end
})

minetest.register_abm({
    label = "Send SPSP external alarm",
    nodenames = {"group:sprinkler_panel"},
    interval = 1,
    chance = 1,

    action = function(pos)
        local panel = sprinkler.getDevInfo("panel", pos)
        if not panel then return end

        local alarm_active = (#panel.alarm > 0)

        panel.external_alarm = alarm_active

        if panel.controller_pos then
            local ctrl = sprinkler.getDevInfo("controller", panel.controller_pos)

            if ctrl then
                ctrl.active = alarm_active
                ctrl.last_update = minetest.get_gametime()

                sprinkler.setDevInfo("controller", panel.controller_pos, ctrl)
            end
        end

        sprinkler.setDevInfo("panel", pos, panel)
    end
})
