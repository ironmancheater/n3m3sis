local clipboard = require("gamesense/clipboard") or error("Missing Clipboard: https://gamesense.pub/forums/viewtopic.php?id=28678", 2)
local base64 = require("gamesense/base64") or error("Missing Base64: https://gamesense.pub/forums/viewtopic.php?id=21619", 2)
local vector = require("vector") or error("Missing Vector", 2)
local ffi = require("ffi") or error("Please turn on Allow unsafe scripts!", 2)
local http = require("gamesense/http") or error("Missing http: https://gamesense.pub/forums/viewtopic.php?id=19253", 2)

local function gradient_rgb(r1, g1, b1, a1, text)
    if #text == 0 then
        return "" -- Return an empty string if the text is empty
    end

    local r2, g2, b2, a2 = 255, 255, 255, 255 -- Default final RGB and A values
    local output = ""
    local len = #text - 1
    if len <= 0 then
        -- If the text length is too short, handle it accordingly
        return ("\a%02x%02x%02x%02x%s"):format(r1, g1, b1, a1, text)
    end

    local rinc = (r2 - r1) / len
    local ginc = (g2 - g1) / len
    local binc = (b2 - b1) / len
    local ainc = (a2 - a1) / len

    for i = 1, len + 1 do
        output = output .. ("\a%02x%02x%02x%02x%s"):format(r1, g1, b1, a1, text:sub(i, i))
        r1 = r1 + rinc
        g1 = g1 + ginc
        b1 = b1 + binc
        a1 = a1 + ainc
    end

    return output
end

local lua_enable = ui.new_checkbox("AA", "Anti-aimbot angles", "❖ " ..gradient_rgb(206, 193, 139, 255, "nemesis"))

local refs = {
	enabled = ui.reference("AA", "Anti-aimbot angles", "Enabled"),
	pitch = {ui.reference("AA", "Anti-aimbot angles", "pitch")},
	roll = ui.reference("AA", "Anti-aimbot angles", "roll"),
	yawbase = ui.reference("AA", "Anti-aimbot angles", "Yaw base"),
	yaw = {ui.reference("AA", "Anti-aimbot angles", "Yaw")},
	fsbodyyaw = ui.reference("AA", "anti-aimbot angles", "Freestanding body yaw"),
	edgeyaw = ui.reference("AA", "Anti-aimbot angles", "Edge yaw"),
	maxproccessticks = ui.reference("MISC", "Settings", "sv_maxusrcmdprocessticks2"),
	yawjitter = {ui.reference("AA", "Anti-aimbot angles", "Yaw jitter")},
	bodyyaw = {ui.reference("AA", "Anti-aimbot angles", "Body yaw")},
	freestand = {ui.reference("AA", "Anti-aimbot angles", "Freestanding")},
	onshotaa = {ui.reference("AA", "Other", "On shot anti-aim")},
	slowmotion = {ui.reference("AA", "Other", "Slow motion")},
	doubletap = {ui.reference("RAGE", "Aimbot", "Double tap")},
	leg_movement = ui.reference("AA", "Other", "Leg movement"),
    minimumdamageoverride = {ui.reference("RAGE", "Aimbot", "Minimum damage override")}
}

local state_vars = {
    player_states = {"stand", "move", "slowwalk", "air", "duck", "airduck", "fakelag"},

    state_int = {
        stand = 1,
        move = 2,
        slowwalk = 3,
        air = 4,
        duck = 5,
        airduck = 6,
		fakelag = 7
    },

    state_to_int = {
        S = 1,
        M = 2,
        SW = 3,
        A = 4,
        D = 5,
        AD = 6,
		FL = 7
    },

    short_player_states = {"S", "M", "SW", "A", "D", "AD", "FL"},

    player_state_holder = 1
}

local function does_contain(tbl, val)
    for i=1, #tbl do
        if tbl[i] == val then
            return true
        end
    end
    return false
end

local lua_menu = ui.new_slider("AA", "Anti-aimbot angles", "\n", 1, 3, 1, true, '', 1, { [1] = '\aCEC18BFF♯ aa', [2] = '\aCEC18BFF♯ vis', [3] = '\aCEC18BFF♯ misc' })
--local lua_menu = ui.new_combobox("AA", "Anti-aimbot angles", "\n", "♯ aa", "♯ vis", "♯ misc")
local lua_menu_spacer = ui.new_label("AA", "Anti-aimbot angles", "\n")

local defensive = ui.new_combobox("AA", "Anti-aimbot angles", "⋇ \aCEC18BFFexploit tickbase", "-", "velocity swap", "always", "air")
local antiaim_state = ui.new_combobox("AA", "Anti-aimbot angles", "⋇ \aCEC18BFFanti-aim", "-", "builder")
local keybinds_multi = ui.new_multiselect("AA", "Anti-aimbot angles", "⋇ \aCEC18BFFbinds", "freestand", "edgeyaw")
local freestand_key = ui.new_hotkey("AA", "Anti-aimbot angles", "» \aCEC18BFFfs")
local edgeyaw_key = ui.new_hotkey("AA", "Anti-aimbot angles", "» \aCEC18BFFey")

local Builder = {}
local builder_spacer = ui.new_label("AA", "Anti-aimbot angles", "\n")
local current_state_select = ui.new_combobox("AA", "Anti-aimbot angles", "\n", "stand", "move", "slowwalk", "air", "duck", "airduck", "fakelag")
local builder_label = ui.new_label("AA", "Anti-aimbot angles", "\n")

for i=1, 7 do
	Builder[i] = {
		benable =  ui.new_checkbox("AA", "Anti-aimbot angles", "user-state"..gradient_rgb(206, 193, 139, 255, " ")..""..state_vars.player_states[i]),
		pitch = ui.new_combobox("AA", "Anti-aimbot angles",gradient_rgb(206, 193, 139, 255, "pitch").." ⋇ \a0000000"..state_vars.player_states[i], "off", "down", "up", "random", "exploit"),
		yawbase = ui.new_combobox("AA", "Anti-aimbot angles",gradient_rgb(206, 193, 139, 255, "yaw base").." ⋇ \a0000000"..state_vars.player_states[i], "local view", "at targets"),
		yaw = ui.new_combobox("AA", "Anti-aimbot angles",gradient_rgb(206, 193, 139, 255, "yaw").." ⋇ \a0000000"..state_vars.player_states[i], "off", "180", "exploit180", "exploit360"),
		yawleft = ui.new_slider("AA", "Anti-aimbot angles",gradient_rgb(206, 193, 139, 255, "left").." ⋇ \a0000000"..state_vars.player_states[i], -180, 180, 0),
		yawright = ui.new_slider("AA", "Anti-aimbot angles",gradient_rgb(206, 193, 139, 255, "right").." ⋇ \a0000000"..state_vars.player_states[i], -180, 180, 0),
		yawjitter = ui.new_combobox("AA", "Anti-aimbot angles",gradient_rgb(206, 193, 139, 255, "jitter").." ⋇ \a0000000"..state_vars.player_states[i], "off", "offset", "center", "skitter"),
		yawjitterslider = ui.new_slider("AA", "Anti-aimbot angles", "\n \a0000000"..state_vars.player_states[i], -180, 180, 0),
		bodyoptions = ui.new_combobox("AA", "Anti-aimbot angles",gradient_rgb(206, 193, 139, 255, "body").." ⋇ \a0000000"..state_vars.player_states[i], "off", "opposite", "jitter", "static"),
		bodyoptionsinfo = ui.new_label("AA", "Anti-aimbot angles", "hey user, while using jitter please set 1 or -1"),
		bodyoptionsinfo1 = ui.new_label("AA", "Anti-aimbot angles", "to avoid body swap bug caused by esoterik"),
		bodyoptionsslider = ui.new_slider("AA", "Anti-aimbot angles", "\n \a0000000", -180, 180, 1),
		fsbody = ui.new_checkbox("AA", "Anti-aimbot angles",gradient_rgb(206, 193, 139, 255, "fs body").." ⋇ \a0000000"..state_vars.player_states[i])
	}
end

local main_colour_label = ui.new_label("AA", "Anti-aimbot angles", "⋇ \aCEC18BFFmain colour")
local main_colour = ui.new_color_picker("AA", "Anti-aimbot angles", "⋇ \aCEC18BFFmain colour", 206, 193, 139, 255)
local clrvis_label = ui.new_label("AA", "Anti-aimbot angles", "\n")
local watermark = ui.new_combobox("AA", "Anti-aimbot angles", "⋇ \aCEC18BFFwatermark", "-", "modern", "performance mode", "voidness.lua")
local dmg_indicator = ui.new_combobox("AA", "Anti-aimbot angles", "⋇ \aCEC18BFFminimum damage", "-", "modern")

local antibackstab = ui.new_combobox("AA", "Anti-aimbot angles", "⋇ \aCEC18BFFavoid backstab", "-", "simple", "velocity swap")
local shittalk = ui.new_combobox("AA", "Anti-aimbot angles", "⋇ \aCEC18BFFtrash talk", "-", "default")
local hitlogs = ui.new_combobox("AA", "Anti-aimbot angles", "⋇ \aCEC18BFFshot logger", "-", "default")
local animbrk = ui.new_multiselect("AA", "Anti-aimbot angles", "⋇ \aCEC18BFFanimation breaker", "-", "air legs", "ground legs", "0 pitch")
local animbrkair = ui.new_combobox("AA", "Anti-aimbot angles", "      ⋇ \aCEC18BFFair options", "-", "modern", "moonwalk")
local animbrkground = ui.new_combobox("AA", "Anti-aimbot angles", "      ⋇ \aCEC18BFFground options", "-", "modern", "moonwalk")

local function og_apply(state)
	ui.set_visible(refs.pitch[1], state)
	ui.set_visible(refs.pitch[2], state)
	ui.set_visible(refs.roll, state)
	ui.set_visible(refs.yawbase, state)
	ui.set_visible(refs.yaw[1], state)
	ui.set_visible(refs.yaw[2], state)
	ui.set_visible(refs.yawjitter[1], state)
	ui.set_visible(refs.yawjitter[2], state)
	ui.set_visible(refs.bodyyaw[1], state)
	ui.set_visible(refs.bodyyaw[2], state)
	ui.set_visible(refs.freestand[1], state)
	ui.set_visible(refs.freestand[2], state)
	ui.set_visible(refs.fsbodyyaw, state)
	ui.set_visible(refs.edgeyaw, state)
end

local function lua_apply()
	state_vars.active_section = state_vars.state_int[ui.get(current_state_select)]
	local is_enabled = ui.get(lua_enable)
	local is_aa = ui.get(lua_menu) == 1
	local is_vis = ui.get(lua_menu) == 2
	local is_misc = ui.get(lua_menu) == 3
	local is_aabden = ui.get(antiaim_state) == "builder"

	if is_enabled then
		ui.set_visible(lua_menu, true)
		ui.set_visible(lua_menu_spacer, true)
	else
		ui.set_visible(lua_menu, false)
		ui.set_visible(lua_menu_spacer, false)
	end

	if is_aa and is_enabled then
		ui.set_visible(antiaim_state, true)
		ui.set_visible(keybinds_multi, true)
		ui.set_visible(freestand_key, true)
		ui.set_visible(edgeyaw_key, true)
		ui.set_visible(current_state_select, true)
		ui.set_visible(defensive, true)
	else
		ui.set_visible(antiaim_state, false)
		ui.set_visible(keybinds_multi, false)
		ui.set_visible(freestand_key, false)
		ui.set_visible(edgeyaw_key, false)
		ui.set_visible(current_state_select, false)
		ui.set_visible(defensive, false)
	end

	if is_vis and is_enabled then
		ui.set_visible(watermark, true)
		ui.set_visible(dmg_indicator, true)
		ui.set_visible(clrvis_label, true)
		ui.set_visible(main_colour, true)
		ui.set_visible(main_colour_label, true)
	else
		ui.set_visible(watermark, false)
		ui.set_visible(dmg_indicator, false)
		ui.set_visible(clrvis_label, false)
		ui.set_visible(main_colour, false)
		ui.set_visible(main_colour_label, false)
	end

	if is_misc and is_enabled then
		ui.set_visible(antibackstab, true)
		ui.set_visible(hitlogs, true)
		ui.set_visible(animbrk, true)
		ui.set_visible(shittalk, true)
	else
		ui.set_visible(antibackstab, false)
		ui.set_visible(hitlogs, false)
		ui.set_visible(animbrk, false)
		ui.set_visible(shittalk, false)
	end

	if is_misc and does_contain(ui.get(animbrk), "ground legs") and is_enabled then
		ui.set_visible(animbrkground, true)
	else
		ui.set_visible(animbrkground, false)
	end

	if is_misc and does_contain(ui.get(animbrk), "air legs") and is_enabled then
		ui.set_visible(animbrkair, true)
	else
		ui.set_visible(animbrkair, false)
	end

	if does_contain(ui.get(keybinds_multi), "freestand") and is_aa and is_enabled then
		ui.set_visible(freestand_key, true)
	else
		ui.set_visible(freestand_key, false)
	end

	if does_contain(ui.get(keybinds_multi), "edgeyaw") and is_aa and is_enabled then
		ui.set_visible(edgeyaw_key, true)
	else
		ui.set_visible(edgeyaw_key, false)
	end

	if is_aabden and is_enabled then
		for i=1, 7 do
			ui.set_visible(Builder[i].benable, state_vars.active_section == i and is_aa)
			ui.set_visible(current_state_select, is_aa)
			ui.set_visible(builder_spacer, is_aa)
			if is_aabden then
				ui.set_visible(builder_label, is_aa)
				ui.set_visible(Builder[i].pitch, state_vars.active_section == i and is_aa)
				ui.set_visible(Builder[i].yawbase, state_vars.active_section == i and is_aa)
				ui.set_visible(Builder[i].yaw, state_vars.active_section == i and is_aa)
				ui.set_visible(Builder[i].yawleft, state_vars.active_section == i and is_aa)
				ui.set_visible(Builder[i].yawright, state_vars.active_section == i and is_aa)
				ui.set_visible(Builder[i].yawjitter, state_vars.active_section == i and is_aa)
				ui.set_visible(Builder[i].yawjitterslider, state_vars.active_section == i and ui.get(Builder[state_vars.active_section].yawjitter) ~= "off" and is_aa)
				ui.set_visible(Builder[i].bodyoptions, state_vars.active_section == i and is_aa)
				ui.set_visible(Builder[i].bodyoptionsinfo, state_vars.active_section == i and is_aa and ui.get(Builder[state_vars.active_section].bodyoptions) == "jitter")
				ui.set_visible(Builder[i].bodyoptionsinfo1, state_vars.active_section == i and is_aa and ui.get(Builder[state_vars.active_section].bodyoptions) == "jitter")
				ui.set_visible(Builder[i].bodyoptionsslider, state_vars.active_section == i and ui.get(Builder[i].bodyoptions) ~= "off" and ui.get(Builder[i].bodyoptions) ~= "opposite" and is_aa)
				ui.set_visible(Builder[i].fsbody, state_vars.active_section == i and is_aa)
			else
				ui.set_visible(builder_label, false)
				ui.set_visible(Builder[i].pitch, false)
				ui.set_visible(Builder[i].yawbase, false)
				ui.set_visible(Builder[i].yaw, false)
				ui.set_visible(Builder[i].yawleft, false)
				ui.set_visible(Builder[i].yawright, false)
				ui.set_visible(Builder[i].yawjitter, false)
				ui.set_visible(Builder[i].yawjitterslider, false)
				ui.set_visible(Builder[i].bodyoptions, false)
				ui.set_visible(Builder[i].bodyoptionsinfo, false)
				ui.set_visible(Builder[i].bodyoptionsinfo1, false)
				ui.set_visible(Builder[i].bodyoptionsslider, false)
				ui.set_visible(Builder[i].fsbody, false)
			end
		end
	else
		for i=1, 7 do
			ui.set_visible(builder_spacer, false)
			ui.set_visible(builder_label, false)
			ui.set_visible(Builder[i].benable,false)
			ui.set_visible(current_state_select,false)
			ui.set_visible(Builder[i].pitch, false)
			ui.set_visible(Builder[i].yawbase, false)
			ui.set_visible(Builder[i].yaw, false)
			ui.set_visible(Builder[i].yawleft, false)
			ui.set_visible(Builder[i].yawright, false)
			ui.set_visible(Builder[i].yawjitter, false)
			ui.set_visible(Builder[i].yawjitterslider, false)
			ui.set_visible(Builder[i].bodyoptions, false)
			ui.set_visible(Builder[i].bodyoptionsinfo, false)
			ui.set_visible(Builder[i].bodyoptionsinfo1, false)
			ui.set_visible(Builder[i].bodyoptionsslider, false)
			ui.set_visible(Builder[i].fsbody, false)
		end
	end
end

local function processColor(main_colour)
    local r, g, b = ui.get(main_colour)
    return r, g, b
end

local logs = {}
local dynamic = {}
dynamic.__index = dynamic function dynamic.new(f, z, r, xi) f = math.max(f, 0.001) z = math.max(z, 0) local pif = math.pi * f local twopif = 2 * pif local a = z / pif local b = 1 / ( twopif * twopif ) local c = r * z / twopif return setmetatable({ a = a, b = b, c = c, px = xi, y = xi, dy = 0 }, dynamic) end function dynamic:update(dt, x, dx) if dx == nil then dx = ( x - self.px ) / dt self.px = x end self.y = self.y + dt * self.dy self.dy = self.dy + dt * ( x + self.c * dx - self.y - self.a * self.dy ) / self.b return self end function dynamic:get() return self.y end local function roundedRectangle(b, c, d, e, f, g, h, i, j, k) renderer.rectangle(b, c, d, e, f, g, h, i) renderer.circle(b, c, f - 8, g - 8, h - 8, i, k, -180, 0.25) renderer.circle(b + d, c, f - 8, g - 8, h - 8, i, k, 90, 0.25) renderer.rectangle(b, c - k, d, k, f, g, h, i) renderer.circle(b + d, c + e, f - 8, g - 8, h - 8, i, k, 0, 0.25) renderer.circle(b, c + e, f - 8, g - 8, h - 8, i, k, -90, 0.25) renderer.rectangle(b, c + e, d, k, f, g, h, i) renderer.rectangle(b - k, c, k, e, f, g, h, i) renderer.rectangle(b + d, c, k, e, f, g, h, i) end

client.set_event_callback('paint', function()
    local screen = {client.screen_size()}
    for i = 1, #logs do
        if not logs[i] then return end
        if not logs[i].init then
            logs[i].y = dynamic.new(2, 2, 0.01, -10)
            logs[i].time = globals.tickcount() + 164
            logs[i].init = true
        end

        local rr, gg, bb = processColor(main_colour)
        local string_size = renderer.measure_text("c", logs[i].text)

		roundedRectangle(screen[1]/2-string_size/2-25, screen[2]-logs[i].y:get(), string_size+10, 16, rr, gg, bb, 35,"", 8)
		roundedRectangle(screen[1]/2-string_size/2-25, screen[2]-logs[i].y:get(), string_size+10, 16, rr, gg, bb, 45,"", 7)
		roundedRectangle(screen[1]/2-string_size/2-25, screen[2]-logs[i].y:get(), string_size+10, 16, rr, gg, bb, 55,"", 6)
		roundedRectangle(screen[1]/2-string_size/2-25, screen[2]-logs[i].y:get(), string_size+10, 16, rr, gg, bb, 155,"", 5)
        roundedRectangle(screen[1]/2-string_size/2-25, screen[2]-logs[i].y:get(), string_size+10, 16, 11, 11, 11, 255, "", 4)
        renderer.text(screen[1]/2-20, screen[2]-logs[i].y:get()+8, 255,255,255,255, "c", 0, logs[i].text)

        if tonumber(logs[i].time) < globals.tickcount() then
            if logs[i].y:get() < -10 then
                table.remove(logs, i)
            else
                logs[i].y:update(globals.frametime(), -50, nil)
            end
        else
            logs[i].y:update(globals.frametime(), 20+(i*28), nil)
        end
		
    end
end)

slide_animation = function(s, v, t)
    return s + (v - s) * t
end

rgba_to_hex = function(b, c, d, e)
    return string.format('%02x%02x%02x%02x', b, c, d, e)
end

clamp = function(x, minval, maxval)
    if x < minval then
        return minval
    elseif x > maxval then
        return maxval
    else
        return x
    end
end

client.set_event_callback("paint", function()
    local localplayer = entity.get_local_player()
	local screen_size = {client.screen_size()}
	local rr, gg, bb = processColor(main_colour)
	
    if not entity.is_alive(entity.get_local_player()) then return end

    if ui.get(refs.minimumdamageoverride[2]) and ui.get(dmg_indicator) == "modern" then
        renderer.text(screen_size[1] / 2 + 2, screen_size[2] / 2 - 14, rr, gg, bb, 225, "d", 0, ui.get(refs.minimumdamageoverride[3]) .. "")
    end
end)

client.set_event_callback("setup_command", function(cmd)
	local user_ground = bit.band(entity.get_prop(entity.get_local_player(), "m_fFlags"), 1) == 1
	local lt = {[1] = true, [2] = false , [3] = true, [4] = false}
	local vel_x, vel_y = entity.get_prop(entity.get_local_player(), "m_vecVelocity")
	local speed = math.sqrt(vel_x * vel_x + vel_y * vel_y)

	if ui.get(defensive) == "always" then
		cmd.force_defensive = true
	elseif ui.get(defensive) == "velocity swap" and speed < 100 then
		cmd.force_defensive = lt[math.random(1,4)]
	elseif ui.get(defensive) == "velocity swap" and speed > 100 then
		cmd.force_defensive = true
	elseif ui.get(defensive) == "air" and not user_ground then
		cmd.force_defensive = true
	else
		return end
end)

local ground_ticks = 0
local char_ptr = ffi.typeof('char*')
local class_ptr = ffi.typeof('void***')
local nullptr = ffi.new('void*')
local native_GetClientEntity = vtable_bind('client.dll', 'VClientEntityList003', 3, 'void*(__thiscall*)(void*, int)')
local animation_layer_t = ffi.typeof([[
	struct {										char pad0[0x18];
		uint32_t	sequence;
		float		prev_cycle;
		float		weight;
		float		weight_delta_rate;
		float		playback_rate;
		float		cycle;
		void		*entity;						char pad1[0x4];
	} **
]])

client.set_event_callback("pre_render", function()
	
	if not entity.is_alive(entity.get_local_player()) then return end

	local pEnt = ffi.cast(class_ptr, native_GetClientEntity(entity.get_local_player()))
	if pEnt == nullptr then
		return
	end

	local anim_layers = ffi.cast(animation_layer_t, ffi.cast(char_ptr, pEnt) + 0x2990)[0][6]
	
	local user_ground = bit.band(entity.get_prop(entity.get_local_player(), "m_fFlags"), 1) == 1

	local lt = {[1] = "Off", [2] = "Always slide" , [3] = "Never slide"}

	if entity.get_prop(entity.get_local_player(), 'm_hGroundEntity') then
        ground_ticks = ground_ticks + 1
    else
        ground_ticks = 0
    end

	if does_contain(ui.get(animbrk), "air legs") then
		if ui.get(animbrkair) == "modern" and not user_ground then
			entity.set_prop(entity.get_local_player(), 'm_flPoseParameter', 1, 6)
		elseif ui.get(animbrkair) == "moonwalk" and not user_ground then
			anim_layers.weight = 1
		end
	end

	if does_contain(ui.get(animbrk), "ground legs") then
		if ui.get(animbrkground) == "modern" then
			ui.set(refs.leg_movement, lt[math.random(2,3)])
			entity.set_prop(entity.get_local_player(), "m_flPoseParameter", math.random(0.1, 2), math.random(0,1)) 
		elseif ui.get(animbrkground) == "moonwalk" then
			entity.set_prop(entity.get_local_player(), 'm_flPoseParameter', 0.5, 7)
			ui.set(refs.leg_movement, lt[3])
		end
	end

	if does_contain(ui.get(animbrk), "0 pitch") and ground_ticks > 5 and ground_ticks < 230 then
		entity.set_prop(entity.get_local_player(), 'm_flPoseParameter', 0.5, 12)
	end

end)

function anti_knife_dist(x1, y1, z1, x2, y2, z2)
    return math.sqrt((x2 - x1)^2 + (y2 - y1)^2 + (z2 - z1)^2)
end

client.set_event_callback("setup_command", function()
        local players = entity.get_players(true)

        local localoriginx, localoriginy, localoriginz = entity.get_prop(entity.get_local_player(), "m_vecOrigin")

        for i=1, #players do
            local playeroriginx, playeroriginy, playeroriginz = entity.get_prop(players[i], "m_vecOrigin")
			local vel_x, vel_y = entity.get_prop(entity.get_local_player(), "m_vecVelocity")
            local distance = anti_knife_dist(localoriginx, localoriginy, localoriginz, playeroriginx, playeroriginy, playeroriginz)

            local weapon = entity.get_player_weapon(players[i])
			if ui.get(antibackstab) == "simple" then
				if entity.get_classname(weapon) == "CKnife" and distance <= 250 then
					ui.set(refs.yaw[2], 180)
					ui.set(refs.pitch[1], "Off")
				end
			elseif ui.get(antibackstab) == "velocity swap" then
				if entity.get_classname(weapon) == "CKnife" and distance <= 250 + math.abs(math.floor(math.sqrt(vel_x * vel_x + vel_y * vel_y + 1000))) / 3 then
					ui.set(refs.yaw[2], 180)
					ui.set(refs.pitch[1], "Off")
			end
		end
	end
end)

local function voidness_watermark_render(x, y, w, r, g, b, a)
	renderer.rectangle(x+1, y-2, w-5, 2.5, 15, 15, 15, 50)
	renderer.rectangle(x-2, y-3, w+3, 1.5, 10, 10, 10, 50)
	renderer.rectangle(x-2, y-2, 2, 20, 10, 10, 10, 50)
	renderer.rectangle(x, y-2, 2.5, 20, 15, 15, 15, 50)
	renderer.rectangle(x+w-3, y-2, 2.5, 20, 15, 15, 15, 50)
	renderer.rectangle(x+w-1, y-2, 2, 20, 10, 10, 10, 50)
	renderer.rectangle(x+2, y+16, w-5, 2.5, 15, 15, 15, 50)
	renderer.rectangle(x-2, y+18, w+3, 1.5, 10, 10, 10, 50)
	renderer.rectangle(x+2, y, w-5, 16, 0, 0, 0, 85)
end

local x_before = 0 

local function text_fade(x, y, s, c1, c2, text)
    local texxt = ''
    local curtime = globals.curtime()
    for i = 0, #text do
        local color = rgba_to_hex(
            slide_animation(c1.r, c2.r, clamp(math.cos(1 * s * curtime / 4 + i * 10  / 15), 0, 1)),
            slide_animation(c1.g, c2.g, clamp(math.cos(1 * s * curtime / 4 + i * 10  / 15), 0, 1)),
            slide_animation(c1.b, c2.b, clamp(math.cos(1 * s * curtime / 4 + i * 10  / 15), 0, 1)),
            c1.a
        ) 
        texxt = texxt .. '\a' .. color .. text:sub(i, i) 
    end
    renderer.text(x, y, c1.r, c1.g, c1.b, c1.a, "b", nil, texxt)
end

client.set_event_callback("paint", function()
	local pulse_value = math.floor(math.sin(globals.realtime() * 3) * (180 / 2 - 1) + 280 / 2) or 180 -- 10 -> 178
	local local_player = entity.get_local_player()
	local vel_x, vel_y = entity.get_prop(local_player, "m_vecVelocity")
	local h, m, s, mst = client.system_time()
	local actual_time = ('%2d:%02d'):format(h, m)
	local latency = client.latency()*1000
	local latency_text = ('  %d'):format(latency) or ''
	local czit = gradient_rgb(206, 193, 139, 255, "nemesis")
	local wersja = "debug"
	local nazwa = "user"
	text = (" %s \aFFFFFFFF~ \aFFFFFFFF%s \a5b5d63FF| \aFFFFFFFF%s \a5b5d63FF| \aFFFFFFFFdelay:%sms \a5b5d63FF|\aFFFFFFFF%s "):format(czit, wersja, nazwa, latency_text, actual_time)
		
	local h, w = 18, renderer.measure_text(nil, text) + 8
	local x, y = client.screen_size(), 10 + (-3)
	local rr, gg, bb = processColor(main_colour)
		
	x = x - w - 10

	if ui.get(watermark) == "voidness.lua" then
		voidness_watermark_render(x, y, w, 65, 65, 65, 180, 2)
		renderer.text(x+4, y + 1, 255, 255, 255, 255, '', 0, text)
	elseif ui.get(watermark) == "performance mode" then
		renderer.text(x+135, y + 552, 255, 255, 255, 255, 'b-', 0, gradient_rgb(rr, gg, bb, 255, "N  E  M  E  S  I  S"))
	elseif ui.get(watermark) == "modern" then
		text_fade(x+135, y + 552, 15, {r=rr, g=gg, b=bb, a=255}, {r=255, g=255, b=255, a=255}, "N  E  M  E  S  I  S")
	end
end)

local clamp = function(x) if x == nil then return 0 end x = (x % 360 + 360) % 360 return x > 180 and x - 360 or x end

client.set_event_callback("setup_command", function(c)

	if ui.get(freestand_key) then
		ui.set(refs.freestand[1], true)
		ui.set(refs.freestand[2], "Always on")
	else
		ui.set(refs.freestand[1], false)
		ui.set(refs.freestand[2], "Always on")
	end

	if ui.get(edgeyaw_key) then
		ui.set(refs.edgeyaw, true)
	else
		ui.set(refs.edgeyaw, false)
	end	

	local local_player = entity.get_local_player()
	local vel_x, vel_y = entity.get_prop(local_player, "m_vecVelocity")
	local user_standing = math.sqrt(vel_x ^ 2 + vel_y ^ 2) < 5
	local user_ground = bit.band(entity.get_prop(local_player, "m_fFlags"), 1) == 1 and c.in_jump == 0
	local user_slowmotion = ui.get(refs.slowmotion[1]) and ui.get(refs.slowmotion[2])
	local is_os = ui.get(refs.onshotaa[1]) and ui.get(refs.onshotaa[2])
	local is_dt = ui.get(refs.doubletap[1]) and ui.get(refs.doubletap[2])

	if not is_dt and not is_os then
		state_vars.player_state_holder = 7
	elseif c.in_duck == 1 and user_ground then
		state_vars.player_state_holder = 5
	elseif c.in_duck == 1 and not user_ground then
		state_vars.player_state_holder = 6
	elseif not user_ground then
		state_vars.player_state_holder = 4
	elseif user_slowmotion then
		state_vars.player_state_holder = 3
	elseif user_standing then
		state_vars.player_state_holder = 1
	elseif not user_standing then
		state_vars.player_state_holder = 2
	end

	local bodyyaw = entity.get_prop(entity.get_local_player(), "m_flPoseParameter", 11) * 120 - 60
	local side = bodyyaw > 0 and 1 or -1

	--local pitchvalue = {[1] = -89, [2] = -65, [3] = -55, [4] = -55, [5] = -65, [6] = -70, [7] = -81}
	local pitchvalue2 = {[1] = 89, [2] = math.random(-89, 0), [3] = 89, [4] = math.random(-89, 0), [5] = 89, [6] = math.random(-89, 0), [7] = 89, [8] = math.random(-89, 0)}
	local yawvaluer = {[1] = math.random(-50,50), [2] = math.random(-90,90), [3] = math.random(-120,120)}
	local tickcount = globals.tickcount()

	if ui.get(Builder[state_vars.player_state_holder].benable) and ui.get(antiaim_state) == "builder" and ui.get(lua_enable) then
		ui.set(refs.yawbase, ui.get(Builder[state_vars.player_state_holder].yawbase))
		ui.set(refs.yawjitter[1], ui.get(Builder[state_vars.player_state_holder].yawjitter))
		ui.set(refs.yawjitter[2], ui.get(Builder[state_vars.player_state_holder].yawjitterslider))
		ui.set(refs.bodyyaw[1], ui.get(Builder[state_vars.player_state_holder].bodyoptions))
		ui.set(refs.bodyyaw[2], ui.get(Builder[state_vars.player_state_holder].bodyoptionsslider))
		ui.set(refs.fsbodyyaw, ui.get(Builder[state_vars.player_state_holder].fsbody))

		if ui.get(Builder[state_vars.player_state_holder].pitch) == "exploit" then
			ui.set(refs.pitch[1], "Custom")
			ui.set(refs.pitch[2], pitchvalue2[math.random(1,8)])
		else
			ui.set(refs.pitch[1], ui.get(Builder[state_vars.player_state_holder].pitch))
		end

		if ui.get(Builder[state_vars.player_state_holder].yaw) == "exploit180" then
			ui.set(refs.yaw[2], yawvaluer[math.random(1,3)])
			ui.set(refs.yaw[1], "180")

		elseif ui.get(Builder[state_vars.player_state_holder].yaw) == "exploit360" then
			local randomyaw = client.random_int(16,179)
			ui.set(refs.yaw[2], clamp((tickcount % 6 < 3 and randomyaw or -randomyaw)))
			ui.set(refs.yaw[1], "180")
		else
			if c.chokedcommands == 0 then
				ui.set(refs.yaw[2], (side == 1 and ui.get(Builder[state_vars.player_state_holder].yawleft) or ui.get(Builder[state_vars.player_state_holder].yawright)))
				ui.set(refs.yaw[1], ui.get(Builder[state_vars.player_state_holder].yaw))
			end
		end

	end
end)

local hitgroup_names = {
    "generic", "head", "chest", "stomach", "left arm", "right arm", "left leg", "right leg", "neck", "unknown"
}

client.set_event_callback("aim_fire", function(event)
    stored_shot = {
		id = event.id,
        damage = event.damage,
        hitbox = hitgroup_names[event.hitgroup + 1],
        lagcomp = event.teleported,
        backtrack = globals.tickcount() - event.tick,
		hitchance = event.hit_chance,
		flags = {
			event.teleported and 'T' or '',
			event.interpolated and 'I' or '',
			event.extrapolated and 'E' or '',
			event.boosted and 'B' or '',
			event.high_priority and 'H' or ''
		}
    }
end)

client.set_event_callback("aim_miss", function(event)
	local output = {}
	local actualhc = math.floor(event.hit_chance)
	
    if ui.get(hitlogs) == "default" then
		if event.reason == "?" then
			output = string.format("[%s] Missed %s's %s for %s(%s) due to resolver (%s remaining) aimed=%s(%sprc) bt=%s lc=%s fg=%s", stored_shot.id, entity.get_player_name(event.target), stored_shot.hitbox, stored_shot.damage, stored_shot.damage, entity.get_prop(event.target, 'm_iHealth'), hitgroup_names[event.hitgroup + 1], actualhc, stored_shot.backtrack, stored_shot.lagcomp, table.concat(stored_shot.flags))
		else
			output = string.format("[%s] Missed %s's %s for %s(%s) due to %s (%s remaining) aimed=%s(%sprc) bt=%s lc=%s fg=%s", stored_shot.id, entity.get_player_name(event.target), stored_shot.hitbox, stored_shot.damage, stored_shot.damage, event.reason, entity.get_prop(event.target, 'm_iHealth'), hitgroup_names[event.hitgroup + 1], actualhc, stored_shot.backtrack, stored_shot.lagcomp, table.concat(stored_shot.flags))
		end

	print(output)
	table.insert(logs, { text = output })
  end
end)

client.set_event_callback("aim_hit", function(event)
	local output = {}
	local actualhc = math.floor(event.hit_chance)

	if ui.get(hitlogs) == "default" then
		output = string.format("[%s] Hit %s's %s for %s(%s) (%s remaining) aimed=%s(%sprc) bt=%s lc=%s fg=%s", stored_shot.id, entity.get_player_name(event.target), hitgroup_names[event.hitgroup + 1], event.damage, stored_shot.damage, entity.get_prop(event.target, 'm_iHealth'), stored_shot.hitbox, actualhc, stored_shot.backtrack, stored_shot.lagcomp, table.concat(stored_shot.flags))

	print(output)
	table.insert(logs, { text = output })
  end
end)

local killphrases = {
    'helo my naim ist WEKE me is use DEVELOPER VERSION of nemesis.lat!!!!!!',
	'helo my naim ist WEKE me is use DEVELOPER VERSION of nemesis.lat!!!!!!',
	'helo my naim ist WEKE me is use DEVELOPER VERSION of nemesis.lat!!!!!!',
	'helo my naim ist WEKE me is use DEVELOPER VERSION of nemesis.lat!!!!!!',
	'𝖊𝖓𝖏𝖔𝖞 𝖉𝖎𝖊 𝖙𝖔 nemesis 𝖑𝖚𝖆 𝖘𝖐𝖗𝖎𝖕𝖙',
	'nemesis 𝓋𝓈 𝓃𝓃 𝒾𝓈 𝓌𝒾𝓃 𝓈𝑜 𝑒𝒶𝓈𝓎',
	'𝕞𝕪 𝕔𝕙𝕖𝕒𝕥 𝕚𝕤 𝕦𝕤𝕖 𝕟𝕖𝕞𝕖𝕤𝕚𝕤 𝕣𝕖𝕤𝕠𝕝𝕧𝕖𝕣 𝕒𝕟𝕕 𝕙𝕖𝕕𝕤𝕙𝕠𝕥',
	'ｎｉｃｅ ｍｉｓｓ ｄｏｇ ｏｗｎｅｄ １',
	'ʙʏ ɴᴇᴍᴇꜱɪꜱ',
	'ʷʰᵉⁿ ᵍᵃᵐᵉ ˢᵗᵃʳᵗ ʸᵒᵘ ⁱˢ ˡᵒˢᵉ ᵃˡʳᵉᵃᵈʸ',
	'𝐮𝐫 𝐥𝐮𝐚 𝐜𝐫𝐚𝐜𝐤𝐞𝐝 𝐥𝐢𝐤𝐞 𝐞𝐠𝐠',
	'YӨЦ ΛЯΣПƬ ЩIП ƧЯY.',
	'♥ after contact sigma i hs and smile ♥',
	'𝖋𝖗𝖊𝖊 𝖍𝖛𝖍 2020-2022 𝖑𝖊𝖘𝖘𝖔𝖓 𝖞𝖔𝖚𝖙𝖚𝖇𝖊.𝖈𝖔𝖒/makihvh',
	'ｇｏｄ ｉｓ ｇｉｖｅ ｍｅ ｐｏｗｅｒ ｔｏ ｈｅａｄｓｈｏｔ ｙｏｕ',
	'you is owned by nemesis lua for 𝖌𝖆𝖒𝖊𝖘𝖊𝖓𝖘𝖊',
	'1',
	'privat doubltap peak solution ◣_◢',
	'𝖚𝖗 𝖆𝖓𝖙𝖎𝖆𝖎𝖒𝖇𝖔𝖙 𝖎𝖘 𝖘𝖔𝖑𝖛𝖊 𝖇𝖞 𝖗𝖊𝖘𝖔𝖑𝖛𝖊𝖗 𝕟𝕖𝕞𝕖𝕤𝕚𝕤 ◣_◢◣_◢◣_◢',
	'sowwy >_<',
	'𝕨𝕙𝕖𝕟 𝕚 𝕣𝕖𝕔𝕖𝕚𝕧 𝕓𝕖𝕥𝕒 𝕟𝕖𝕞𝕖𝕤𝕚𝕤 LUASH 𝕚 +𝕨 𝕚𝕟𝕥𝕠 𝕦 (◣_◢)',
	'ｅｘｅｃｕｔｅ ｒａｔ．ｅｘｅ ｄｏｎｅ．',
	'𝖙𝖗𝖔𝖑𝖑𝖊𝖉◣__◢',
	'𝕨𝕙𝕖𝕟 𝕚 𝕤𝕖𝕖 𝕨𝕖𝕜𝕖 𝕚 𝕣𝕖𝕡𝕠𝕣𝕥 𝕡𝕣𝕚𝕞𝕠𝕣𝕕𝕚𝕒𝕝 𝕒𝕔c𝕠𝕟𝕥 (◣_◢)',
	'𝕨𝕙𝕖𝕟 𝕚 𝕤𝕖𝕖 𝕨𝕖𝕜𝕖 𝕚 𝕣𝕖𝕡𝕠𝕣𝕥 𝕡𝕣𝕚𝕞𝕠𝕣𝕕𝕚𝕒𝕝 𝕒𝕔c𝕠𝕟𝕥 (◣_◢)',
	'𝕨𝕙𝕖𝕟 𝕚 𝕤𝕖𝕖 𝕨𝕖𝕜𝕖 𝕚 𝕣𝕖𝕡𝕠𝕣𝕥 𝕡𝕣𝕚𝕞𝕠𝕣𝕕𝕚𝕒𝕝 𝕒𝕔c𝕠𝕟𝕥 (◣_◢)',
	'𝕨𝕙𝕖𝕟 𝕚 𝕤𝕖𝕖 𝕨𝕖𝕜𝕖 𝕚 𝕣𝕖𝕡𝕠𝕣𝕥 𝕡𝕣𝕚𝕞𝕠𝕣𝕕𝕚𝕒𝕝 𝕒𝕔c𝕠𝕟𝕥 (◣_◢)',
	'when i see weke uid 386 on primordial i report his prim account axaxax (◣_◢)',
	'when i see weke uid 386 on primordial i report his prim account axaxax (◣_◢)',
	'when i see weke uid 386 on primordial i report his prim account axaxax (◣_◢)',
	'when i see weke uid 386 on primordial i report his prim account axaxax (◣_◢)',
	'when i see weke uid 386 on primordial i report his prim account axaxax (◣_◢)',
	'when i see weke uid 386 on primordial i report his prim account axaxax (◣_◢)',
	'uu ʇǝǝʞs ʎnq oɓ ǝsn ǝʇsɐd ɓop ǝɔıu',
	'𝔽ℝ𝔼𝔼 𝕃𝕌𝔸 𝕋𝕆𝕄𝕆ℝℝ𝕆𝕎!',
	'𝕘𝕨𝕒𝕞𝕖𝕤𝕨𝕖𝕟𝕤𝕖 𝔸ℕ𝕋𝕀-𝔸𝕀𝕄 ℍ𝔼𝔸𝔻𝕊ℍ𝕆𝕋 ℙℝ𝔼𝔻𝕀ℂ𝕋',
	'𝔂𝓸𝓾 𝓱𝓪𝓿𝓮 𝓾𝓷𝓾𝓼𝓮𝓭 𝓲𝓷𝓿𝓲𝓽𝓪𝓽𝓲𝓸𝓷 𝓬𝓸𝓭𝓮𝓼 ◣_◢',
	'ᴡᴀʀɴɪɴɢ: ɢᴏɪɴɢ ᴛᴏ ꜱʟᴇᴇᴘ ᴏɴ ꜱᴜɴᴅᴀʏ ᴡɪʟʟ ᴄᴀᴜꜱᴇ ᴍᴏɴᴅᴀʏ',
	'𝕝𝕖𝕘𝕚𝕥 𝕚𝕤 𝕥𝕦𝕣𝕟 𝕚𝕟 𝕙𝕧𝕙 𝕞𝕒𝕥𝕔𝕙𝕒𝕞𝕜𝕚𝕟𝕘 𝕗𝕥. 𝕠𝕥𝕔𝕧𝟚 (◣_◢)',
	'𝓼𝓸 𝓲 𝓶𝓲𝓰𝓱𝓽 𝓫𝓮 𝓼𝓮𝓵𝓵𝓲𝓷𝓰 𝓷𝓮𝓿𝓮𝓻𝓵𝓸𝓼𝓮 𝓲𝓷𝓿𝓲𝓽𝓪𝓽𝓲𝓸𝓷...',
	'𝟙𝕧𝟙 𝕧𝕤 𝕕𝕖𝕕𝕡𝕠𝕝 𝕚𝕤 𝕨𝕚𝕟 𝕓𝕖𝕔𝕦𝕤 𝕙𝕖 𝕒𝕣𝕖 𝕟𝕠𝕥 𝕦𝕤𝕖 𝕒𝕕𝕒𝕡𝕥𝕚𝕧𝕖 ◣_◢',
	'𝕨𝕙𝕖𝕟 𝕚 𝕖𝕩𝕚𝕥𝕤𝕔𝕒𝕞 𝕒𝕟𝕕 𝕓𝕒𝕟 𝕥𝕙𝕖 𝕔𝕠𝕕𝕖𝕣 𝕚 𝕙𝕤 𝕒𝕟𝕕 𝕤𝕞𝕚𝕝𝕖',
	'𝕨𝕙𝕖𝕟 𝕚 𝕖𝕩𝕚𝕥𝕤𝕔𝕒𝕞 𝕒𝕟𝕕 𝕓𝕒𝕟 𝕥𝕙𝕖 𝕔𝕠𝕕𝕖𝕣 𝕚 𝕙𝕤 𝕒𝕟𝕕 𝕤𝕞𝕚𝕝𝕖',
	'𝕨𝕙𝕖𝕟 𝕚 𝕖𝕩𝕚𝕥𝕤𝕔𝕒𝕞 𝕒𝕟𝕕 𝕓𝕒𝕟 𝕥𝕙𝕖 𝕔𝕠𝕕𝕖𝕣 𝕚 𝕙𝕤 𝕒𝕟𝕕 𝕤𝕞𝕚𝕝𝕖',
	'𝕨𝕙𝕖𝕟 𝕚 𝕖𝕩𝕚𝕥𝕤𝕔𝕒𝕞 𝕒𝕟𝕕 𝕓𝕒𝕟 𝕥𝕙𝕖 𝕔𝕠𝕕𝕖𝕣 𝕚 𝕙𝕤 𝕒𝕟𝕕 𝕤𝕞𝕚𝕝𝕖',
	'𝕨𝕙𝕖𝕟 𝕚 𝕖𝕩𝕚𝕥𝕤𝕔𝕒𝕞 𝕒𝕟𝕕 𝕓𝕒𝕟 𝕥𝕙𝕖 𝕔𝕠𝕕𝕖𝕣 𝕚 𝕙𝕤 𝕒𝕟𝕕 𝕤𝕞𝕚𝕝𝕖',
	'𝕨𝕙𝕖𝕟 𝕚 𝕖𝕩𝕚𝕥𝕤𝕔𝕒𝕞 𝕒𝕟𝕕 𝕓𝕒𝕟 𝕥𝕙𝕖 𝕔𝕠𝕕𝕖𝕣 𝕚 𝕙𝕤 𝕒𝕟𝕕 𝕤𝕞𝕚𝕝𝕖',
	'𝕨𝕙𝕖𝕟 𝕚 𝕖𝕩𝕚𝕥𝕤𝕔𝕒𝕞 𝕒𝕟𝕕 𝕓𝕒𝕟 𝕥𝕙𝕖 𝕔𝕠𝕕𝕖𝕣 𝕚 𝕙𝕤 𝕒𝕟𝕕 𝕤𝕞𝕚𝕝𝕖',
	'LUCKBOOST.CFG <-- UR CFG RN',
	'LUCKBOOST.CFG <-- UR CFG RN',
	'LUCKBOOST.CFG <-- UR CFG RN',
	"𝕙𝕖𝕙𝕖𝕙𝕖, 𝕦 𝕘𝕣𝕒𝕓 𝕞𝕪 𝕗𝕒𝕝𝕝 𝕘𝕦𝕪𝕤 𝕔𝕙𝕒𝕣𝕒𝕔𝕥𝕖�",
	"𝕙𝕖𝕙𝕖𝕙𝕖, 𝕦 𝕘𝕣𝕒𝕓 𝕞𝕪 𝕗𝕒𝕝𝕝 𝕘𝕦𝕪𝕤 𝕔𝕙𝕒𝕣𝕒𝕔𝕥𝕖�",
	"𝕔𝕠𝕞𝕖 𝕞𝕖𝕖𝕥 𝕞𝕪 𝕙𝕖𝕝𝕝𝕠 𝕜𝕚𝕥𝕥𝕪 𝕥𝕖𝕒𝕞 >.<",
	"𝕔𝕠𝕞𝕖 𝕞𝕖𝕖𝕥 𝕞𝕪 𝕙𝕖𝕝𝕝𝕠 𝕜𝕚𝕥𝕥𝕪 𝕥𝕖𝕒𝕞 >.<",
	"𝕔𝕠𝕞𝕖 𝕞𝕖𝕖𝕥 𝕞𝕪 𝕙𝕖𝕝𝕝𝕠 𝕜𝕚𝕥𝕥𝕪 𝕥𝕖𝕒𝕞 >.<",
	"𝒸𝑜𝓂𝑒 𝓂𝑒𝑒𝓉 𝓂𝓎 𝒽𝑒𝓁𝓁𝑜 𝓀𝒾𝓉𝓉𝓎 𝓉𝑒𝒶𝓂 >.<",
	"𝒸𝑜𝓂𝑒 𝓂𝑒𝑒𝓉 𝓂𝓎 𝒽𝑒𝓁𝓁𝑜 𝓀𝒾𝓉𝓉𝓎 𝓉𝑒𝒶𝓂 >.<",
	"𝒸𝑜𝓂𝑒 𝓂𝑒𝑒𝓉 𝓂𝓎 𝒽𝑒𝓁𝓁𝑜 𝓀𝒾𝓉𝓉𝓎 𝓉𝑒𝒶𝓂 >.<",
	"WHEN IM MAKIHVH I EXITSCAM FOR 1 EURO AND SMILE☹☹",
	"WHEN IM MAKIHVH I EXITSCAM FOR 1 EURO AND SMILE☹☹",
	"WHEN IM MAKIHVH I EXITSCAM FOR 1 EURO AND SMILE☹☹",
	"WHEN IM MAKIHVH I EXITSCAM FOR 1 EURO AND SMILE☹☹",
	"WHEN IM MAKIHVH I EXITSCAM FOR 1 EURO AND SMILE☹☹",
	"WHEN IM MAKIHVH I EXITSCAM FOR 1 EURO AND SMILE☹☹",
	"𝕨𝕙𝕖𝕟 𝕚 𝕞𝕖𝕖𝕥 𝕓𝕣𝕒𝕥𝕧𝕒 𝕚 𝕤𝕒𝕪 𝟙 𝕓𝕚𝕔𝕦𝕫 𝕚𝕞 𝕤𝕚𝕘𝕞𝕒",
	"𝕨𝕙𝕖𝕟 𝕚 𝕞𝕖𝕖𝕥 𝕓𝕣𝕒𝕥𝕧𝕒 𝕚 𝕤𝕒𝕪 𝟙 𝕓𝕚𝕔𝕦𝕫 𝕚𝕞 𝕤𝕚𝕘𝕞𝕒",
	"𝕨𝕙𝕖𝕟 𝕚 𝕞𝕖𝕖𝕥 𝕓𝕣𝕒𝕥𝕧𝕒 𝕚 𝕤𝕒𝕪 𝟙 𝕓𝕚𝕔𝕦𝕫 𝕚𝕞 𝕤𝕚𝕘𝕞𝕒",
	"𝕨𝕙𝕖𝕟 𝕚 𝕞𝕖𝕖𝕥 𝕓𝕣𝕒𝕥𝕧𝕒 𝕚 𝕤𝕒𝕪 𝟙 𝕓𝕚𝕔𝕦𝕫 𝕚𝕞 𝕤𝕚𝕘𝕞𝕒",
	"WHEN I SEE ORCUS.RAT/BRATVA POP UP ON MY PC I DIE FROM LAUGHTER",
	"WHEN I SEE ORCUS.RAT/BRATVA POP UP ON MY PC I DIE FROM LAUGHTER",
	"WHEN I SEE ORCUS.RAT/BRATVA POP UP ON MY PC I DIE FROM LAUGHTER",
	"WHEN I SEE ORCUS.RAT/BRATVA POP UP ON MY PC I DIE FROM LAUGHTER",
	"WHEN I SEE ORCUS.RAT/BRATVA POP UP ON MY PC I DIE FROM LAUGHTER",
	"GAMSNZ ACCUNT STOLEN SUCESSFULLY BY LIMEPOLISH",
	"GAMSNZ ACCUNT STOLEN SUCESSFULLY BY LIMEPOLISH",
	"GAMSNZ ACCUNT STOLEN SUCESSFULLY BY LIMEPOLISH",
	"GAMSNZ ACCUNT STOLEN SUCESSFULLY BY LIMEPOLISH",
	"𝐿𝐼𝑀𝐸𝒫𝒪𝐿𝐼𝒮𝐻: !𝒮𝒞𝑅𝐸𝐸𝒩𝒮𝐻𝒪𝒯",
	"𝐿𝐼𝑀𝐸𝒫𝒪𝐿𝐼𝒮𝐻: !𝒮𝒞𝑅𝐸𝐸𝒩𝒮𝐻𝒪𝒯",
	"𝐿𝐼𝑀𝐸𝒫𝒪𝐿𝐼𝒮𝐻: !𝒮𝒞𝑅𝐸𝐸𝒩𝒮𝐻𝒪𝒯",
	"*DEAD* ☂ nossa vei : i need a good wanheda.red cfg",
	"*DEAD* ☂ nossa vei : i need a good wanheda.red cfg",
	"*DEAD* ☂ nossa vei : i need a good wanheda.red cfg",
	"*DEAD* ☂ nossa vei : i need a good wanheda.red cfg"
}

local function get_table_length(data)
  if type(data) ~= 'table' then
    return 0
  end
  local count = 0
  for _ in pairs(data) do
    count = count + 1
  end
  return count
end

local killphrases_length = get_table_length(killphrases)

local function on_player_death(e)
	if not ui.get(shittalk) == "default" then return end
	local victim_userid, attacker_userid = e.userid, e.attacker
	if victim_userid == nil or attacker_userid == nil then return end

	local victim_entindex = client.userid_to_entindex(victim_userid)
	local attacker_entindex = client.userid_to_entindex(attacker_userid)

	if attacker_entindex == entity.get_local_player() and entity.is_enemy(victim_entindex) then
		local commandbaim = 'say ' .. killphrases[math.random(killphrases_length)]
		client.exec(commandbaim)
	end
end

client.set_event_callback("player_death", on_player_death)

local key = {0xAA, 0xBB, 0xCC}

local function xorObfuscate(input)
    local obfuscated = {}
    local keyLength = #key
    
    for i = 1, #input do
        local byte = input:byte(i)
        local obfByte = bit.bxor(byte, key[(i - 1) % keyLength + 1])
        table.insert(obfuscated, string.char(obfByte))
    end
    
    return table.concat(obfuscated)
end

local function xorDeobfuscate(input)
    return xorObfuscate(input)
end

local function system_export()
	local alphabet = "base64"
	local export = {}
	for key, value in pairs(state_vars.short_player_states) do
		export[tostring(value)] = {}
		for k, v in pairs(Builder[key]) do
			export[value][k] = ui.get(v)
		end
	end
	
	local xorenc = xorObfuscate(json.stringify(export))
	local encoded = base64.encode(xorenc, alphabet)
	clipboard.set(encoded)
	print("You have sucessfully exported your nemesis configuration!")
	table.insert(logs, {
		text = "You have sucessfully exported your nemesis configuration!"
	})
end

local function system_import()
	local alphabet = "base64"
	local decoded = base64.decode(clipboard.get())
	local xordec = xorDeobfuscate(decoded)
	local import = json.parse(xordec)

	for key, value in pairs(state_vars.short_player_states) do
		for k, v in pairs(Builder[key]) do
			local current = import[value][k]
			if (current ~= nil) then
				ui.set(v, current)
			end
		end
	end
	print("You have sucessfully imported your nemesis configuration!")
	table.insert(logs, {
		text = "You have sucessfully imported your nemesis configuration!"
	})
end

--[[local function system_export_pastebin()
	local alphabet = "base64"
	local export = {}
	for key, value in pairs(state_vars.short_player_states) do
		export[tostring(value)] = {}
		for k, v in pairs(Builder[key]) do
			export[value][k] = ui.get(v)
		end
	end
	
	local xorenc = xorObfuscate(json.stringify(export))
	local encoded = base64.encode(xorenc, alphabet)
	clipboard.set(encoded)
	http.post("https://pastebin.com/api/api_post.php", { body = "api_dev_key=azR38jGTSKUv170Kk9JNgawTH2qnSMaV&api_option=paste&api_paste_code="..encoded, headers = { ['Content-Type'] = 'application/x-www-form-urlencoded' } }, function(success, response)
        if success then
            print("Content successfully uploaded to Pastebin!")
            print("Pastebin URL:", response.body)
        else
            print("Failed to upload content to Pastebin.")
            print("Error status code:", response.status)
            print("Error response:", response.body)
        end
    end)
	print("You have sucessfully exported your nemesis configuration!")
	table.insert(logs, {
		text = "You have sucessfully exported your nemesis configuration!"
	})
end]]

local function extractKey(jsonString)
    local keyStart = string.find(jsonString, ':"') -- Find the position where the key starts
    local keyEnd = string.find(jsonString, '"}', keyStart + 2) -- Find the position where the key ends

    if keyStart and keyEnd then
        return string.sub(jsonString, keyStart + 2, keyEnd - 1) -- Extract the substring containing the key value
    else
        return nil
    end
end

local function system_export_pastebin()
	local alphabet = "base64"
	local export = {}
	for key, value in pairs(state_vars.short_player_states) do
		export[tostring(value)] = {}
		for k, v in pairs(Builder[key]) do
			export[value][k] = ui.get(v)
		end
	end
	
	local xorenc = xorObfuscate(json.stringify(export))
	local encoded = base64.encode(xorenc, alphabet)
	clipboard.set(encoded)
	http.post("https://hastebin.skyra.pw/documents", { body = ""..encoded.."", headers = { ['Content-Type'] = 'application/x-www-form-urlencoded' } }, function(success, response)
        if success then
            print("Content successfully uploaded to Pastebin!")
			print("https://hastebin.skyra.pw/"..extractKey(response.body)..".txt")
        else
            print("Failed to upload content to Pastebin.")
        end
    end)
	print("You have sucessfully exported your nemesis configuration!")
	table.insert(logs, {
		text = "You have sucessfully exported your nemesis configuration!"
	})
	table.insert(logs, {
		text = "Content successfully uploaded to Pastebin!"
	})
	table.insert(logs, {
		text = "Link is in the console!"
	})
end

local button_import = ui.new_button("AA", "Other", "\aCEC18BFFimport from clipboard", system_import)
local button_export = ui.new_button("AA", "Other", "\aCEC18BFFexport to clipboard", system_export)
local button_export = ui.new_button("AA", "Other", "\aCEC18BFFexport and upload to pastebin", system_export_pastebin)

local function config_apply()
	if ui.get(antiaim_state) == "builder" and ui.get(lua_enable) then
		ui.set_visible(button_import, true)
		ui.set_visible(button_export, true)
	else
		ui.set_visible(button_import, false)
		ui.set_visible(button_export, false)
	end
end

client.set_event_callback("paint_ui", lua_apply)
client.set_event_callback("paint_ui", og_apply)
client.set_event_callback("paint_ui", config_apply)
client.set_event_callback("shutdown", function()
	og_apply(true)
end)

client.set_event_callback("paint_ui", function()
	if ui.get(lua_enable) == true then
		og_apply(false)
	else
		og_apply(true)
	end
end)