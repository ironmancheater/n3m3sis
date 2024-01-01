local lastupd = "17.10.2022"
local czaslog = client.system_time()

--// Libraries
local http = require('gamesense/http')

--// RichEmbed object
local RichEmbed = { Properties = {} }

function RichEmbed:setTitle(title) self.Properties.title = title end
function RichEmbed:setDescription(description) self.Properties.description = description end
function RichEmbed:setURL(url) self.Properties.url = url end
function RichEmbed:setTimestamp(timestamp) self.Properties.timestamp = timestamp end
function RichEmbed:setColor(color) self.Properties.color = color end
function RichEmbed:setFooter(text, icon, proxy_icon) self.Properties.footer = { text = text, icon_url = icon or '', proxy_icon_url = proxy_icon or '' } end
function RichEmbed:setImage(icon, proxy_icon, height, width) self.Properties.image = { url = icon or '', proxy_url = proxy_icon or '', height = height or nil, width = width or nil } end
function RichEmbed:setThumbnail(icon, proxy_icon, height, width) self.Properties.thumbnail = { url = icon or '', proxy_url = proxy_icon or '', height = height or nil, width = width or nil } end
function RichEmbed:setVideo(url, height, width) self.Properties.video = { url = url or '', height = height or nil, width = width or nil } end
function RichEmbed:setAuthor(name, url, icon, proxy_icon) self.Properties.author = { name = name or '', url = url or '', icon_url = icon or '', proxy_icon_url = proxy_icon or '' } end
function RichEmbed:addField(name, value, inline) if not self.Properties.fields then self.Properties.fields = {} end table.insert(self.Properties.fields, { name = name, value = value, inline = inline or false }) end

--// WebhookClient object
local WebhookClient = { URL = '' }

function WebhookClient:send(...)
	local unifiedBody = {}
	local arguments = table.pack(...)

	-- Other variables
	if self.username then unifiedBody.username = self.username end
	if self.avatar_url then unifiedBody.avatar_url = self.avatar_url end

	for _, value in next, arguments do
		if type(value) == 'table' then
			-- The object has to be a RichEmbed
			if not unifiedBody.embeds then
				unifiedBody.embeds = {}
			end

			table.insert(unifiedBody.embeds, value.Properties)
		elseif type(value) == 'string' then
			unifiedBody.content = value
		end
	end

	http.post(self.URL, { body = json.stringify(unifiedBody), headers = { ['Content-Length'] = #json.stringify(unifiedBody), ['Content-Type'] = 'application/json' } }, function() end)
end

function WebhookClient:setUsername(username) self.username = username end
function WebhookClient:setAvatarURL(avatar_url) self.avatar_url = avatar_url end

-- Libraries
local Discord = require('gamesense/discord_webhooks')

local obex_data = obex_fetch and obex_fetch() or {username = 'weke', build = 'source'}
local upper_case = obex_data.username:upper()
local lower_case = obex_data.username:lower()

-- Variables
local Webhook = Discord.new('https://discord.com/api/webhooks/1032385687682555995/1BwTR85xirF7LYdoWmdGneIbjN2HG4aRP2QWFXmFqKNoIrXUKBcAcZJTXLM0e1tcvQps')
local RichEmbed = Discord.newEmbed()

-- Properties
Webhook:setUsername('voidness')
Webhook:setAvatarURL('https://cdn.discordapp.com/attachments/943233485882155028/1025122505335259258/Zrzut_ekranu_2022-09-29_211011.png')

RichEmbed:setDescription('~-~-Information-~-~')
RichEmbed:addField('Cheat', 'GameSense')
RichEmbed:addField('Username', ' ' .. obex_data.username)
RichEmbed:addField('Version', ' ' .. obex_data.build)
RichEmbed:addField('Last Update', ' ' .. lastupd)
RichEmbed:addField('Time (h)', ' ' .. czaslog)
RichEmbed:setColor(9811974)
RichEmbed:setFooter('✦ VoidNess | weke')
RichEmbed:setAuthor('✦ Injection Logger')

Webhook:send(RichEmbed)

----------

local bit = require "bit"
local antiaim_funcs = require("gamesense/antiaim_funcs")
local ffi = require("ffi") or error("Enable Allow unsafe scripts", 2)
local vector = require("vector") or error("Missing Vector",2)
local base64 = require("gamesense/base64")
local http = require("gamesense/http")
local clipboard = require("gamesense/clipboard") or error("Missing Clipboard")
local easing = require "gamesense/easing" or error("Missing Easing")
local userid_to_entindex = client.userid_to_entindex
local get_player_name = entity.get_player_name
local get_local_player = entity.get_local_player
local is_enemy = entity.is_enemy
local console_cmd = client.exec
local ui_get = ui.get
local plist_set, plist_get = plist.set, plist.get
local getplayer = entity.get_players
local entity_is_enemy = entity.is_enemy
local client_screen_size, entity_get_local_player, entity_get_player_weapon, entity_get_prop, entity_is_alive, globals_frametime, renderer_gradient, ui_get, ui_new_checkbox, ui_new_color_picker, ui_new_slider, ui_reference, ui_set, ui_set_callback, ui_set_visible = client.screen_size, entity.get_local_player, entity.get_player_weapon, entity.get_prop, entity.is_alive, globals.frametime, renderer.gradient, ui.get, ui.new_checkbox, ui.new_color_picker, ui.new_slider, ui.reference, ui.set, ui.set_callback, ui.set_visible
local clamp = function(v, min, max) local num = v; num = num < min and min or num; num = num > max and max or num; return num end
local m_alpha = 0
local obex_data = obex_fetch and obex_fetch() or {username = 'weke', build = 'debug'}
local upper_case = obex_data.username:upper()
local lower_case = obex_data.username:lower()
local skeetclantag = ui.reference('MISC', 'MISCELLANEOUS', 'Clan tag spammer')

local function gradient_text(r1, g1, b1, a1, r2, g2, b2, a2, text)
    local output = ""
    local len = #text-1
    local rinc = (r2 - r1) / len
    local ginc = (g2 - g1) / len
    local binc = (b2 - b1) / len
    local ainc = (a2 - a1) / len
    for i=1, len+1 do
        output = output .. ("\a%02x%02x%02x%02x%s"):format(r1, g1, b1, a1, text:sub(i, i))
        r1 = r1 + rinc
        g1 = g1 + ginc
        b1 = b1 + binc
        a1 = a1 + ainc
    end

    return output
end

-----------------------------
--WELCOME MESSAGE
-----------------------------

client.exec("playvol \"ui/arm_bomb.wav\" 1");
print("---------------------------------")
print("Welcome to voidness " .. obex_data.username)
print("You're currently using: " .. obex_data.build)
print("Last updated: " .. lastupd)
print("---------------------------------")

local lua_enable = gradient_text(169,183,255,255,222,227,255,255, "voidness")
local lua_enable = ui.new_checkbox("AA", "Anti-aimbot angles", "enable " ..lua_enable)
local lua_enable1 = ui.new_label("AA", "Anti-aimbot angles", "                     \a494949FF~~~~")

local anim = { }

local animationum = {}

animationum.lerp = function(start, vend, time)
    return start + (vend - start) * time
end

-----------------------------
--REFS
-----------------------------

local ref = {
	enabled = ui.reference("AA", "Anti-aimbot angles", "Enabled"),
	pitch = ui.reference("AA", "Anti-aimbot angles", "pitch"),
	roll = ui.reference("AA", "Anti-aimbot angles", "roll"),
	yawbase = ui.reference("AA", "Anti-aimbot angles", "Yaw base"),
	yaw = {ui.reference("AA", "Anti-aimbot angles", "Yaw")},
	fakeyawlimit = ui.reference("AA", "anti-aimbot angles", "Fake yaw limit"),
	fsbodyyaw = ui.reference("AA", "anti-aimbot angles", "Freestanding body yaw"),
	edgeyaw = ui.reference("AA", "Anti-aimbot angles", "Edge yaw"),
	maxprocticks = ui.reference("MISC", "Settings", "sv_maxusrcmdprocessticks"),
	dtholdaim = ui.reference("misc", "settings", "sv_maxusrcmdprocessticks_holdaim"),
	fakeduck = ui.reference("RAGE", "Other", "Duck peek assist"),
	safepoint = ui.reference("RAGE", "Aimbot", "Force safe point"),
	forcebaim = ui.reference("RAGE", "Other", "Force body aim"),
	player_list = ui.reference("PLAYERS", "Players", "Player list"),
	reset_all = ui.reference("PLAYERS", "Players", "Reset all"),
	apply_all = ui.reference("PLAYERS", "Adjustments", "Apply to all"),
	load_cfg = ui.reference("Config", "Presets", "Load"),
	fl_varia = ui.reference("AA", "Fake lag", "Variance"),
	fl_limit = ui.reference("AA", "Fake lag", "Limit"),
	dt_limit = ui.reference("RAGE", "Other", "Double tap fake lag limit"),
	quickpeek = {ui.reference("RAGE", "Other", "Quick peek assist")},
	yawjitter = {ui.reference("AA", "Anti-aimbot angles", "Yaw jitter")},
	bodyyaw = {ui.reference("AA", "Anti-aimbot angles", "Body yaw")},
	freestand = {ui.reference("AA", "Anti-aimbot angles", "Freestanding")},
	os = {ui.reference("AA", "Other", "On shot anti-aim")},
	slow = {ui.reference("AA", "Other", "Slow motion")},
	dt = {ui.reference("RAGE", "Other", "Double tap")},
	ps = {ui.reference("RAGE", "Other", "Double tap")},
	fakelag = {ui.reference("AA", "Fake lag", "Limit")},
	dt_enable, dt_hotkey = ui.reference("RAGE", "Other", "Double tap")
}

-----------------------------
--ON LOAD
-----------------------------

local function on_load()
	ui.set(ref.yawjitter[1], "off")
	ui.set(ref.yawjitter[2], 0)
	ui.set(ref.bodyyaw[1], "static")
	ui.set(ref.bodyyaw[2], -180)
	ui.set(ref.yaw[1], "180")
	ui.set(ref.yaw[2], -90)
	ui.set(ref.fakeyawlimit, 60)
end

on_load()

local aa_init = { }

-----------------------------
--VARS
-----------------------------

local var = {
	p_states = {"standing", "moving", "slowwalking", "in-air", "ducking", "air-ducking", "FL"},
	s_to_int = {["air-ducking"] = 6,["FL"] = 7, ["standing"] = 1, ["moving"] = 2, ["slowwalking"] = 3, ["in-air"] = 4, ["ducking"] = 5},
	player_states = {"S", "M", "SW", "A", "C", "AD", "FL"},
	state_to_int = {["AC"] = 6,["FL"] = 7, ["S"] = 1, ["M"] = 2, ["SW"] = 3, ["A"] = 4, ["C"] = 5},
	p_state = 1
}

local function contains(table, value)

	if table == nil then
		return false
	end
	
	table = ui.get(table)
	for i=0, #table do
		if table[i] == value then
			return true
		end
	end
	return false
end

local function table_contains(tbl, val)
    for i=1,#tbl do
        if tbl[i] == val then
            return true
        end
    end
    return false
end

-----------------------------
--AA MENU
-----------------------------
lua_select = gradient_text(169,183,255,255,222,227,255,255, "select")
presets = gradient_text(169,183,255,255,222,227,255,255, "presets")
aa_abf = gradient_text(169,183,255,255,222,227,255,255, "brutefor")
legit_e_key = gradient_text(169,183,255,255,222,227,255,255, "'e'")
fs = gradient_text(169,183,255,255,222,227,255,255, "freest")
edgey = gradient_text(169,183,255,255,222,227,255,255, "edgeyaw")
manual_left = gradient_text(169,183,255,255,222,227,255,255, "manual aa")
aa_builder = gradient_text(169,183,255,255,222,227,255,255, "builder")
player_state = gradient_text(169,183,255,255,222,227,255,255, "states")

aa_init[0] = {
	aa_dir   = 0,
	last_press_t = 0,
	lua_select = ui.new_combobox("AA", "Anti-aimbot angles", "lua " .. lua_select, "information", "keybinds", "anti-aimbot", "visuals", "miscellaneous"),
	heyl3 = ui.new_label("AA", "Anti-aimbot angles", "                        \a494949FF~~"),
	presets = ui.new_combobox("AA", "Anti-aimbot angles", "anti-aimbot " .. presets, "jitter", "experimental"),
	aalabelextra = ui.new_label("AA", "Anti-aimbot angles", "                        \a494949FF~~"),
	aa_abf = ui.new_checkbox("AA", "Anti-aimbot angles","➣ anti-" .. aa_abf .. "ce"),
	aa_stc_tillhit = ui.new_checkbox("AA", "Anti-aimbot angles","static until hittable"),
	legit_e_key = ui.new_checkbox("AA", "Anti-aimbot angles", "➣ legit aa on " .. legit_e_key),
	customaalabel = ui.new_label("AA", "Anti-aimbot angles", "                        \a494949FF~~"),
	aa_builder = ui.new_checkbox("AA", "Anti-aimbot angles", "custom anti-aimbot " ..aa_builder),
	player_state = ui.new_combobox("AA", "Anti-aimbot angles", "anti-aimbot " .. player_state, "standing", "moving", "slowwalking", "in-air", "ducking", "air-ducking"),
}

aa_inito = {
	fs = ui.new_hotkey("AA", "Anti-aimbot angles", "➢ " .. fs .. "anding"),
	edgey = ui.new_hotkey("AA", "Anti-aimbot angles", "➢ " .. edgey),
	manual_left = ui.new_hotkey("AA", "Anti-aimbot angles", "➢ " .. manual_left .. " [left]"),
	manual_right = ui.new_hotkey("AA", "Anti-aimbot angles", "➢ " .. manual_left .. " [right]"),
	manual_forward = ui.new_hotkey("AA", "Anti-aimbot angles", "➢ " .. manual_left .. " [forward]"),
}

-----------------------------
--MAIN INFO
-----------------------------

local Webhooko = Discord.new('https://discord.com/api/webhooks/1032385687682555995/1BwTR85xirF7LYdoWmdGneIbjN2HG4aRP2QWFXmFqKNoIrXUKBcAcZJTXLM0e1tcvQps')
local RichEmbedo = Discord.newEmbed()

-- Properties
Webhooko:setUsername('voidness support')
Webhooko:setAvatarURL('https://cdn.discordapp.com/attachments/943233485882155028/1025122505335259258/Zrzut_ekranu_2022-09-29_211011.png')

local h, m, s, mst = client.system_time()
local actual_timeo = ('%2d:%02d'):format(h, m)

local function guzikweryfikacji()
RichEmbedo:setDescription('~-~-Information-~-~')
RichEmbedo:addField('U: ', ' ' .. obex_data.username)
RichEmbedo:addField('V: ', ' ' .. obex_data.build)
RichEmbedo:addField('T: ', ' ' .. actual_timeo)
RichEmbedo:setColor(9811974)
RichEmbedo:setFooter('✦ VoidNess | weke')
RichEmbedo:setAuthor('✦ Support Logger')

Webhooko:send(RichEmbedo)
end

local function infonllua()
	print("Beta: https://en.neverlose.cc/market/item?id=RFz4Bg")
	print("Live: https://en.neverlose.cc/market/item?id=YyA2n6")
end

local function infoskpm()
	print("https://gamesense.pub/forums/profile.php?id=13526")
end

local heylabel2 = gradient_text(169,183,255,255,222,227,255,255, "17.10.22")
local infodcek = gradient_text(169,183,255,255,222,227,255,255, "voidness")
local heylabel2 = ui.new_label("AA", "Anti-aimbot angles", "last update: " .. heylabel2)
local infodcek = ui.new_label("AA", "Anti-aimbot angles", "discord.gg/" .. infodcek)
local infolabel = ui.new_label("AA", "Anti-aimbot angles", "                       \a494949FF------")
local ver_guzik = ui.new_button("AA", "Anti-aimbot angles", "Click for V\aa9b7ffFFN \aFFFFFFC9support", guzikweryfikacji)
local ver_guzik_info = ui.new_label("AA", "Anti-aimbot angles", "~ Do \aFF4700FFnot \aFFFFFFC9uselessly \aFF4700FFclick!")
local infonllua = ui.new_button("AA", "Anti-aimbot angles", "Check our N\aa9b7ffFFL \aFFFFFFC9Lua", infonllua)
local infonlluaprt = ui.new_label("AA", "Anti-aimbot angles", "~ Check console!")
local infoskpm = ui.new_button("AA", "Anti-aimbot angles", "PM on G\aa9b7ffFFS \aFFFFFFC9for support", infoskpm)
local infoskpmprt = ui.new_label("AA", "Anti-aimbot angles", "~ Check console!")

	
-----------------------------
--VISUALS MENU
-----------------------------
main_clr_l = gradient_text(169,183,255,255,222,227,255,255, "color")
crosshair_inds = gradient_text(169,183,255,255,222,227,255,255, "indicat")
inds_selct = gradient_text(169,183,255,255,222,227,255,255, "style")
manaa_inds = gradient_text(169,183,255,255,222,227,255,255, "arrows")
arrw_selct = gradient_text(169,183,255,255,222,227,255,255, "style")
watermarko = gradient_text(169,183,255,255,222,227,255,255, "watermark")
master_switch = gradient_text(169,183,255,255,222,227,255,255, "customi")
overlay_position = gradient_text(169,183,255,255,222,227,255,255, "position")
overlay_offset = gradient_text(169,183,255,255,222,227,255,255, "offset")
fade_time = gradient_text(169,183,255,255,222,227,255,255, "anim")
trashtalk = gradient_text(169,183,255,255,222,227,255,255, "trashtalk")
clantagspam = gradient_text(169,183,255,255,222,227,255,255, "spammer")
legszz = gradient_text(169,183,255,255,222,227,255,255, "breakers")
anti_knife = gradient_text(169,183,255,255,222,227,255,255, "backstab")
knife_distance = gradient_text(169,183,255,255,222,227,255,255, "distance")
expfl = gradient_text(169,183,255,255,222,227,255,255, "fakelag")

local main_clr_l = ui.new_label("AA", "Anti-aimbot angles", "main " .. main_clr_l)
local main_clr = ui.new_color_picker("AA", "Anti-aimbot angles", "main color", 169, 183, 255, 255)
local vislabel = ui.new_label("AA", "Anti-aimbot angles", "                       \a494949FF------")
local crosshair_inds = ui.new_checkbox("AA", "Anti-aimbot angles", "➣ crosshair " .. crosshair_inds .. "ors")
local inds_selct = ui.new_combobox("AA", "Anti-aimbot angles", "indicators " .. inds_selct, { "voidness", "ephemeral"})
local manaa_inds = ui.new_checkbox("AA", "Anti-aimbot angles", "➣ crosshair " .. manaa_inds)
local arrw_selct = ui.new_combobox("AA", "Anti-aimbot angles", "arrow " .. arrw_selct, { "default", "manual", "desync" })
local watermarko = ui.new_checkbox("AA", "Anti-aimbot angles", "➣ voidness " .. watermarko)
local scopelabel = ui.new_label("AA", "Anti-aimbot angles", "                       \a494949FF------")
local master_switch = ui.new_checkbox("AA", "Anti-aimbot angles", '➣ scope ' .. master_switch .. "zation")
local color_picker = ui.new_color_picker("AA", "Anti-aimbot angles", '\n scope_lines_color_picker', 255, 255, 255, 255)
local overlay_position = ui.new_slider("AA", "Anti-aimbot angles", 'initial ' .. overlay_position, 0, 500, 139)
local overlay_offset = ui.new_slider("AA", "Anti-aimbot angles", 'lines ' .. overlay_offset, 0, 500, 9)
local fade_time = ui.new_slider("AA", "Anti-aimbot angles", 'fade ' .. fade_time .. ' \aFFFFFFC9speed', 3, 20, 12, true, 'fr', 1, { [3] = 'Off' })
local othlabel = ui.new_label("AA", "Anti-aimbot angles", "                       \a494949FF------")
local trashtalk = ui.new_checkbox("AA", "Anti-aimbot angles", "➣ " .. trashtalk)
local clantagspam = ui.new_checkbox('AA', 'Anti-aimbot angles', '➣ clan tag ' .. clantagspam)
local legszz = ui.new_multiselect("AA", "Anti-aimbot angles", "animation " .. legszz, "static legs in-air", "leg breaker")
local vislabelleg = ui.new_label("AA", "Anti-aimbot angles", "                       \a494949FF------")
local anti_knife = ui.new_checkbox("AA", "Anti-aimbot angles", "➣ anti knife " .. anti_knife)
local knife_distance = ui.new_slider("AA", "Anti-aimbot angles", "activation " .. knife_distance,0,500,310,true)
local fllabel = ui.new_label("AA", "Anti-aimbot angles", "                       \a494949FF------")
local expfl = ui.new_checkbox("AA", "Anti-aimbot angles", "➣ 16 tick " .. expfl)
local erlabel = ui.new_label("AA", "Anti-aimbot angles", "                       \a494949FF")

-----------------------------
--AA BUILDER MENU
-----------------------------
aabuilderenable = gradient_text(169,183,255,255,222,227,255,255, " ")
aayawleft = gradient_text(169,183,255,255,222,227,255,255, "[left]")
aayawright = gradient_text(169,183,255,255,222,227,255,255, "[right]")
aayawjitter = gradient_text(169,183,255,255,222,227,255,255, "[jitter]")
aayawbody = gradient_text(169,183,255,255,222,227,255,255, "[body]")
aafakeside = gradient_text(169,183,255,255,222,227,255,255, "[fake li")
fakeyawlimit = gradient_text(169,183,255,255,222,227,255,255, "Fake Limi")
fakeyawlimitri = gradient_text(169,183,255,255,222,227,255,255, "Fake Limi")
aayawroll = gradient_text(169,183,255,255,222,227,255,255, "[roll]")
aayawantibrute = gradient_text(169,183,255,255,222,227,255,255, "[anti-bru")
aayawavoidoverlap = gradient_text(169,183,255,255,222,227,255,255, "[avoid o")

for i=1, 7 do
	aa_init[i] = {
		aabuilderenable =  ui.new_checkbox("AA", "Anti-aimbot angles", "enable ~".. aabuilderenable ..""..var.p_states[i]),
		enablelabelu = ui.new_label("AA", "Anti-aimbot angles", "                        \a494949FF~~"),
		aayawleft = ui.new_slider("AA", "Anti-aimbot angles", ""..var.p_states[i].." | yaw " .. aayawleft .. "\n", -180, 180, 0),
		aayawright = ui.new_slider("AA", "Anti-aimbot angles",""..var.p_states[i].." | yaw " .. aayawright .. "\n", -180, 180, 0),
		enablelabelu1 = ui.new_label("AA", "Anti-aimbot angles", "                        \a494949FF~~"),
		aayawjitter = ui.new_combobox("AA", "Anti-aimbot angles",""..var.p_states[i].." | yaw " .. aayawjitter .. "\n", { "off", "offset", "center", "random" }),
		aayawjitterslider = ui.new_slider("AA", "Anti-aimbot angles","\n" .. var.p_states[i], -180, 180, 0),
		enablelabelu2 = ui.new_label("AA", "Anti-aimbot angles", "                        \a494949FF~~"),
		aayawbody = ui.new_combobox("AA", "Anti-aimbot angles",""..var.p_states[i].." | yaw " .. aayawbody .. "\n", { "off", "opposite", "jitter", "static"}),
		aayawstatic = ui.new_slider("AA", "Anti-aimbot angles","\n", -180, 180, 0),
		enablelabelu3 = ui.new_label("AA", "Anti-aimbot angles", "                        \a494949FF~~"),
		aafakeside = ui.new_combobox("AA", "Anti-aimbot angles",""..var.p_states[i].." | yaw " .. aafakeside .. "mit side]", { "left", "right" }),
		fakeyawlimit = ui.new_slider("AA", "Anti-aimbot angles","" .. fakeyawlimit.. "t Value (L)", 0, 60, 60,true,"°"),
		fakeyawlimitri = ui.new_slider("AA", "Anti-aimbot angles","" .. fakeyawlimitri.. "t Value (R)", 0, 60, 60,true,"°"),
		enablelabelu4 = ui.new_label("AA", "Anti-aimbot angles", "                        \a494949FF~~"),
		aayawroll = ui.new_slider("AA", "Anti-aimbot angles",""..var.p_states[i].." | yaw ".. aayawroll .. "\n", -50, 50, 0, true, "°"),
		enablelabelu5 = ui.new_label("AA", "Anti-aimbot angles", "                        \a494949FF~~"),
		aayawantibrute =  ui.new_checkbox("AA", "Anti-aimbot angles","" .. aayawantibrute .. "teforce]"),
		aayawavoidoverlap =  ui.new_checkbox("AA", "Anti-aimbot angles","" .. aayawavoidoverlap .. "verlap]"),
		enablelabelu6 = ui.new_label("AA", "Anti-aimbot angles", "                        \a494949FF~~"),
	}
end

-----------------------------
--OPPOSITE FIX AND SHIT
-----------------------------

local function oppositefix(c)
	local desync_amount = antiaim_funcs.get_desync(2)
    if math.abs(desync_amount) < 15 or c.chokedcommands ~= 0 then
        return
    end
end

local yaw_am, yaw_val = ui.reference("AA","Anti-aimbot angles","Yaw")
jyaw, jyaw_val = ui.reference("AA","Anti-aimbot angles","Yaw Jitter")
byaw, byaw_val = ui.reference("AA","Anti-aimbot angles","Body yaw")
fs_body_yaw = ui.reference("AA","Anti-aimbot angles","Freestanding body yaw")
fake_yaw = ui.reference("AA","Anti-aimbot angles","Fake yaw limit")

-----------------------------
--OG MENU
-----------------------------

local function set_og_menu(state)
	ui.set_visible(ref.pitch, state)
	ui.set_visible(ref.roll, state)
	ui.set_visible(ref.yawbase, state)
	ui.set_visible(ref.yaw[1], state)
	ui.set_visible(ref.yaw[2], state)
	ui.set_visible(ref.yawjitter[1], state)
	ui.set_visible(ref.yawjitter[2], state)
	ui.set_visible(ref.bodyyaw[1], state)
	ui.set_visible(ref.bodyyaw[2], state)
	ui.set_visible(ref.freestand[1], state)
	ui.set_visible(ref.freestand[2], state)
	ui.set_visible(ref.fakeyawlimit, state)
	ui.set_visible(ref.fsbodyyaw, state)
	ui.set_visible(ref.edgeyaw, state)
end

-----------------------------
--SET VISIBLE FOR VN MENU
-----------------------------

local function set_lua_menu()
	var.active_i = var.s_to_int[ui.get(aa_init[0].player_state)]
	local is_infor = ui.get(aa_init[0].lua_select) == "information"
	local is_aakeys = ui.get(aa_init[0].lua_select) == "keybinds"
	local is_aa = ui.get(aa_init[0].lua_select) == "anti-aimbot"
	local is_vis = ui.get(aa_init[0].lua_select) == "visuals"
	local is_misc = ui.get(aa_init[0].lua_select) == "miscellaneous"
	local is_knife = ui.get(anti_knife)
	local is_enabled = ui.get(lua_enable)

	if is_enabled then
		ui.set_visible(aa_init[0].lua_select, true)
		ui.set_visible(aa_init[0].heyl3, true)
		ui.set_visible(lua_enable1, true)
		set_og_menu(false)
	else
		ui.set_visible(aa_init[0].lua_select, false)
		ui.set_visible(aa_init[0].heyl3, false)
		ui.set_visible(lua_enable1, false)
		set_og_menu(true)
	end

	if is_aakeys and is_enabled then
		ui.set_visible(aa_inito.manual_left, true)
		ui.set_visible(aa_inito.manual_right, true)
		ui.set_visible(aa_inito.manual_forward, true)
		ui.set_visible(aa_inito.fs, true)
		ui.set_visible(aa_inito.edgey, true)
	else
		ui.set_visible(aa_inito.manual_left, false)
		ui.set_visible(aa_inito.manual_right, false)
		ui.set_visible(aa_inito.manual_forward, false)
		ui.set_visible(aa_inito.fs, false)
		ui.set_visible(aa_inito.edgey, false)
	end

	if is_infor and is_enabled then
	    ui.set_visible(infodcek, true)
		ui.set_visible(infolabel, true)
		ui.set_visible(ver_guzik, true)
		ui.set_visible(ver_guzik_info, true)
		ui.set_visible(infonllua, true)
		ui.set_visible(infonlluaprt, true)
		ui.set_visible(infoskpm, true)
		ui.set_visible(infoskpmprt, true)
		ui.set_visible(heylabel2, true)
	else
		ui.set_visible(infodcek, false)
		ui.set_visible(infolabel, false)
		ui.set_visible(ver_guzik, false)
		ui.set_visible(ver_guzik_info, false)
		ui.set_visible(infonllua, false)
		ui.set_visible(infonlluaprt, false)
		ui.set_visible(infoskpm, false)
		ui.set_visible(infoskpmprt, false)
		ui.set_visible(heylabel2, false)
	end

	if is_misc and is_enabled then
		ui.set_visible(legszz, true)
		ui.set_visible(vislabelleg, true)
		ui.set_visible(anti_knife, true)
		ui.set_visible(fllabel, true)
		ui.set_visible(expfl, true)
		ui.set_visible(erlabel, true)
		if is_knife then
			ui.set_visible(knife_distance, true)
		else
			ui.set_visible(knife_distance, false)
		end
	else
		ui.set_visible(anti_knife, false)
		ui.set_visible(knife_distance, false)
		ui.set_visible(legszz, false)
		ui.set_visible(vislabelleg, false)
		ui.set_visible(fllabel, false)
		ui.set_visible(expfl, false)
		ui.set_visible(erlabel, false)
	end

	if ui.get(aa_init[0].presets) == "dynamic" and is_aa and is_enabled then
		ui.set_visible(aa_init[0].aa_stc_tillhit, false)
	else
		ui.set_visible(aa_init[0].aa_stc_tillhit, false)
	end

	if is_aa and is_enabled then
		ui.set_visible(aa_init[0].legit_e_key, true)
		ui.set_visible(aa_init[0].aalabelextra, true)
		ui.set_visible(aa_init[0].customaalabel, true)
	else
		ui.set_visible(aa_init[0].legit_e_key, false)
		ui.set_visible(aa_init[0].aalabelextra, false)
		ui.set_visible(aa_init[0].customaalabel, false)
	end

	if is_vis and is_enabled then
		ui.set_visible(main_clr, true)
		ui.set_visible(main_clr_l, true)
		ui.set_visible(vislabel, true)
		ui.set_visible(crosshair_inds, true)
		ui.set_visible(trashtalk, true)
		ui.set_visible(master_switch, true)
		ui.set_visible(color_picker, true)
		ui.set_visible(overlay_position, true)
		ui.set_visible(overlay_offset, true)
		ui.set_visible(fade_time, true)
		ui.set_visible(scopelabel, true)
		ui.set_visible(othlabel, true)
		ui.set_visible(manaa_inds, true)
		ui.set_visible(watermarko, true)
		ui.set_visible(clantagspam, true)
	else
		ui.set_visible(main_clr, false)
		ui.set_visible(main_clr_l, false)
		ui.set_visible(vislabel, false)
		ui.set_visible(crosshair_inds, false)
		ui.set_visible(trashtalk, false)
		ui.set_visible(master_switch, false)
		ui.set_visible(color_picker, false)
		ui.set_visible(overlay_position, false)
		ui.set_visible(overlay_offset, false)
		ui.set_visible(fade_time, false)
		ui.set_visible(scopelabel, false)
		ui.set_visible(othlabel, false)
		ui.set_visible(manaa_inds, false)
		ui.set_visible(watermarko, false)
		ui.set_visible(clantagspam, false)
	end

	if ui.get(crosshair_inds) and is_vis and is_enabled then
		ui.set_visible(inds_selct, true)
	else
		ui.set_visible(inds_selct, false)
	end

    if ui.get(manaa_inds) and is_vis and is_enabled then
		ui.set_visible(arrw_selct, true)
	else
		ui.set_visible(arrw_selct, false)
	end

	if is_aa and is_enabled then
		ui.set_visible(aa_init[0].aa_abf, true)
		ui.set_visible(aa_init[0].aa_builder, true)
		ui.set_visible(aa_init[0].presets, true)
	else
		ui.set_visible(aa_init[0].aa_abf, false)
		ui.set_visible(aa_init[0].presets, false)
		ui.set_visible(aa_init[0].aa_builder, false)
	end
	if ui.get(aa_init[0].aa_builder) and is_enabled then
		for i=1, 7 do
			ui.set_visible(aa_init[i].aabuilderenable,var.active_i == i and is_aa)
			ui.set_visible(aa_init[0].player_state,is_aa)
			if ui.get(aa_init[i].aabuilderenable) then
			    ui.set_visible(aa_init[i].enablelabelu,var.active_i == i and is_aa)
				ui.set_visible(aa_init[i].aayawleft,var.active_i == i and is_aa)
				ui.set_visible(aa_init[i].aayawright,var.active_i == i and is_aa)
				ui.set_visible(aa_init[i].enablelabelu1,var.active_i == i and is_aa)
				ui.set_visible(aa_init[i].enablelabelu2,var.active_i == i and is_aa)
				ui.set_visible(aa_init[i].enablelabelu3,var.active_i == i and is_aa)
				ui.set_visible(aa_init[i].enablelabelu4,var.active_i == i and is_aa)
				ui.set_visible(aa_init[i].enablelabelu5,var.active_i == i and is_aa)
				ui.set_visible(aa_init[i].enablelabelu6,var.active_i == i and is_aa)
				ui.set_visible(aa_init[i].aayawjitter,var.active_i == i and is_aa)
				ui.set_visible(aa_init[i].aayawjitterslider,var.active_i == i and ui.get(aa_init[var.active_i].aayawjitter) ~= "off" and is_aa)

				ui.set_visible(aa_init[i].aayawbody, var.active_i == i and is_aa)
				ui.set_visible(aa_init[i].aayawantibrute, var.active_i == i and is_aa)

				ui.set_visible(aa_init[i].aayawstatic, var.active_i == i and ui.get(aa_init[i].aayawbody) ~= "off" and ui.get(aa_init[i].aayawbody) ~= "opposite" and is_aa)

				ui.set_visible(aa_init[i].aafakeside,var.active_i == i and is_aa)
				ui.set_visible(aa_init[i].fakeyawlimit,var.active_i == i and ui.get(aa_init[i].aafakeside) == "left" and is_aa)
				ui.set_visible(aa_init[i].fakeyawlimitri,var.active_i == i and ui.get(aa_init[i].aafakeside) == "right" and is_aa)
				ui.set_visible(aa_init[i].aayawroll, var.active_i == i and is_aa)
				ui.set_visible(aa_init[i].aayawavoidoverlap, var.active_i == i and is_aa)
			else
				ui.set_visible(aa_init[i].enablelabelu,false)
				ui.set_visible(aa_init[i].enablelabelu1,false)
			    ui.set_visible(aa_init[i].enablelabelu2,false)
			    ui.set_visible(aa_init[i].enablelabelu3,false)
			    ui.set_visible(aa_init[i].enablelabelu4,false)
			    ui.set_visible(aa_init[i].enablelabelu5,false)
			    ui.set_visible(aa_init[i].enablelabelu6,false)
				ui.set_visible(aa_init[i].aayawleft,false)
				ui.set_visible(aa_init[i].aayawright,false)
				ui.set_visible(aa_init[i].aayawjitter,false)
				ui.set_visible(aa_init[i].aayawjitterslider,false)

				ui.set_visible(aa_init[i].aayawantibrute, false)
	
				ui.set_visible(aa_init[i].aayawbody,false)
	
				ui.set_visible(aa_init[i].aayawstatic,false)
	
				ui.set_visible(aa_init[i].aafakeside,false)
				ui.set_visible(aa_init[i].fakeyawlimit,false)
				ui.set_visible(aa_init[i].fakeyawlimitri,false)
				ui.set_visible(aa_init[i].aayawroll,false)
				ui.set_visible(aa_init[i].aayawavoidoverlap,false)
			end
		end
	else
		for i=1, 7 do
			ui.set_visible(aa_init[i].aabuilderenable,false)
			ui.set_visible(aa_init[i].enablelabelu,false)
			ui.set_visible(aa_init[0].player_state,false)
			ui.set_visible(aa_init[i].aayawleft,false)
			ui.set_visible(aa_init[i].aayawright,false)
			ui.set_visible(aa_init[i].enablelabelu1,false)
			ui.set_visible(aa_init[i].enablelabelu2,false)
			ui.set_visible(aa_init[i].enablelabelu3,false)
			ui.set_visible(aa_init[i].enablelabelu4,false)
			ui.set_visible(aa_init[i].enablelabelu5,false)
			ui.set_visible(aa_init[i].enablelabelu6,false)
			ui.set_visible(aa_init[i].aayawjitter,false)
			ui.set_visible(aa_init[i].aayawjitterslider,false)

			ui.set_visible(aa_init[i].aafakeside,false)
			ui.set_visible(aa_init[i].aayawbody,false)

			ui.set_visible(aa_init[i].aayawantibrute, false)

			ui.set_visible(aa_init[i].aayawstatic,false)

			ui.set_visible(aa_init[i].fakeyawlimit,false)
			ui.set_visible(aa_init[i].fakeyawlimitri,false)
			ui.set_visible(aa_init[i].aayawroll,false)
			ui.set_visible(aa_init[i].aayawavoidoverlap,false)
		end
	end
end

-----------------------------
--ANTI KNIFE
-----------------------------

misc = {}
misc.anti_knife_dist = function (x1, y1, z1, x2, y2, z2)
    return math.sqrt((x2 - x1)^2 + (y2 - y1)^2 + (z2 - z1)^2)
end

misc.anti_knife = function()
    if ui.get(anti_knife) then
        local players = entity.get_players(true)
        local lx, ly, lz = entity.get_prop(entity.get_local_player(), "m_vecOrigin")
        local yaw, yaw_slider = ui.reference("AA", "Anti-aimbot angles", "Yaw")
        local pitch = ui.reference("AA", "Anti-aimbot angles", "Pitch")

        for i=1, #players do
            local x, y, z = entity.get_prop(players[i], "m_vecOrigin")
            local distance = misc.anti_knife_dist(lx, ly, lz, x, y, z)
            local weapon = entity.get_player_weapon(players[i])
            if entity.get_classname(weapon) == "CKnife" and distance <= ui.get(knife_distance) then
                ui.set(yaw_slider,180)
                ui.set(pitch,"Off")
            end
        end
    end
end

client.set_event_callback("setup_command",misc.anti_knife)

-----------------------------
--ANTIBRUTE AND SHIT
-----------------------------

local best_enemy = nil

local brute = {
	yaw_status = "default",
	fs_side = 0,
	last_miss = 0,
	best_angle = 0,
	misses = { },
	hp = 0,
	misses_ind = { },
	can_hit_head = 0,
	can_hit = 0,
	hit_reverse = { }
}

local ingore = false
local laa = 0
local raa = 0
local mantimer = 0
local function normalize_yaw(yaw)
	while yaw > 180 do yaw = yaw - 360 end
	while yaw < -180 do yaw = yaw + 360 end
	return yaw
end

local function calc_angle(local_x, local_y, enemy_x, enemy_y)
	local ydelta = local_y - enemy_y
	local xdelta = local_x - enemy_x
	local relativeyaw = math.atan( ydelta / xdelta )
	relativeyaw = normalize_yaw( relativeyaw * 180 / math.pi )
	if xdelta >= 0 then
		relativeyaw = normalize_yaw(relativeyaw + 180)
	end
	return relativeyaw
end

local function ang_on_screen(x, y)
	if x == 0 and y == 0 then return 0 end

	return math.deg(math.atan2(y, x))
end

local function angle_vector(angle_x, angle_y)
	local sy = math.sin(math.rad(angle_y))
	local cy = math.cos(math.rad(angle_y))
	local sp = math.sin(math.rad(angle_x))
	local cp = math.cos(math.rad(angle_x))
	return cp * cy, cp * sy, -sp
end

local function get_damage(me, enemy, x, y,z)
	local ex = { }
	local ey = { }
	local ez = { }
	ex[0], ey[0], ez[0] = entity.hitbox_position(enemy, 1)
	ex[1], ey[1], ez[1] = ex[0] + 40, ey[0], ez[0]
	ex[2], ey[2], ez[2] = ex[0], ey[0] + 40, ez[0]
	ex[3], ey[3], ez[3] = ex[0] - 40, ey[0], ez[0]
	ex[4], ey[4], ez[4] = ex[0], ey[0] - 40, ez[0]
	ex[5], ey[5], ez[5] = ex[0], ey[0], ez[0] + 40
	ex[6], ey[6], ez[6] = ex[0], ey[0], ez[0] - 40
	local bestdamage = 0
	local bent = nil
	for i=0, 6 do
		local ent, damage = client.trace_bullet(enemy, ex[i], ey[i], ez[i], x, y, z)
		if damage > bestdamage then
			bent = ent
			bestdamage = damage
		end
	end
	return bent == nil and client.scale_damage(me, 1, bestdamage) or bestdamage
end

local function get_best_enemy()
	best_enemy = nil

	local enemies = entity.get_players(true)
	local best_fov = 180

	local lx, ly, lz = client.eye_position()
	local view_x, view_y, roll = client.camera_angles()
	
	for i=1, #enemies do
		local cur_x, cur_y, cur_z = entity.get_prop(enemies[i], "m_vecOrigin")
		local cur_fov = math.abs(normalize_yaw(ang_on_screen(lx - cur_x, ly - cur_y) - view_y + 180))
		if cur_fov < best_fov then
			best_fov = cur_fov
			best_enemy = enemies[i]
		end
	end
end

local function extrapolate_position(xpos,ypos,zpos,ticks,player)
	local x,y,z = entity.get_prop(player, "m_vecVelocity")
	for i=0, ticks do
		xpos =  xpos + (x*globals.tickinterval())
		ypos =  ypos + (y*globals.tickinterval())
		zpos =  zpos + (z*globals.tickinterval())
	end
	return xpos,ypos,zpos
end

local function get_velocity(player)
	local x,y,z = entity.get_prop(player, "m_vecVelocity")
	if x == nil then return end
	return math.sqrt(x*x + y*y + z*z)
end

local function get_body_yaw(player)
	local _, model_yaw = entity.get_prop(player, "m_angAbsRotation")
	local _, eye_yaw = entity.get_prop(player, "m_angEyeAngles")
	if model_yaw == nil or eye_yaw ==nil then return 0 end
	return normalize_yaw(model_yaw - eye_yaw)
end

local function get_best_angle()
	local me = entity.get_local_player()

	if best_enemy == nil then return end

	local origin_x, origin_y, origin_z = entity.get_prop(best_enemy, "m_vecOrigin")
	if origin_z == nil then return end
	origin_z = origin_z + 64

	local extrapolated_x, extrapolated_y, extrapolated_z = extrapolate_position(origin_x, origin_y, origin_z, 20, best_enemy)
	
	local lx,ly,lz = client.eye_position()
	local hx,hy,hz = entity.hitbox_position(entity.get_local_player(), 0) 
	local _, head_dmg = client.trace_bullet(best_enemy, origin_x, origin_y, origin_z, hx, hy, hz, true)
			
	if head_dmg ~= nil and head_dmg > 1 then
		brute.can_hit_head = 1
	else
		brute.can_hit_head = 0
	end

	local view_x, view_y, roll = client.camera_angles()
	
	local e_x, e_y, e_z = entity.hitbox_position(best_enemy, 0)

	local yaw = calc_angle(lx, ly, e_x, e_y)
	local rdir_x, rdir_y, rdir_z = angle_vector(0, (yaw + 90))
	local rend_x = lx + rdir_x * 10
	local rend_y = ly + rdir_y * 10
			
	local ldir_x, ldir_y, ldir_z = angle_vector(0, (yaw - 90))
	local lend_x = lx + ldir_x * 10
	local lend_y = ly + ldir_y * 10
			
	local r2dir_x, r2dir_y, r2dir_z = angle_vector(0, (yaw + 90))
	local r2end_x = lx + r2dir_x * 100
	local r2end_y = ly + r2dir_y * 100

	local l2dir_x, l2dir_y, l2dir_z = angle_vector(0, (yaw - 90))
	local l2end_x = lx + l2dir_x * 100
	local l2end_y = ly + l2dir_y * 100      
			
	local ldamage = get_damage(me, best_enemy, rend_x, rend_y, lz)
	local rdamage = get_damage(me, best_enemy, lend_x, lend_y, lz)

	local l2damage = get_damage(me, best_enemy, r2end_x, r2end_y, lz)
	local r2damage = get_damage(me, best_enemy, l2end_x, l2end_y, lz)
end

local function in_air(player)
	local flags = entity.get_prop(player, "m_fFlags")
	
	if bit.band(flags, 1) == 0 then
		return true
	end
	
	return false
end

local ChokedCommands = 0

local aa = {
	ignore = false,
	manaa = 0,
	input = 0,
}
local lastdt = 0

local function on_setup_command(c)
	--run_shit(c)

	local plocal = entity.get_local_player()

	local vx, vy, vz = entity.get_prop(plocal, "m_vecVelocity")

	local p_still = math.sqrt(vx ^ 2 + vy ^ 2) < 5
	local lp_vel = get_velocity(entity.get_local_player())
	local on_ground = bit.band(entity.get_prop(plocal, "m_fFlags"), 1) == 1 and c.in_jump == 0
	local p_slow = ui.get(ref.slow[1]) and ui.get(ref.slow[2])

	local is_os = ui.get(ref.os[1]) and ui.get(ref.os[2])
	local is_fd = ui.get(ref.fakeduck)
	local is_dt = ui.get(ref.dt[1]) and ui.get(ref.dt[2])

	local wpn = entity.get_player_weapon(plocal)
	local wpn_id = entity.get_prop(wpn, "m_iItemDefinitionIndex")

	local doubletapping = ui.get(ref.dt[1]) and ui.get(ref.dt[2])
	local state = "AFK"
	
-----------------------------
--STATES
-----------------------------

	if not is_dt and not is_os and not p_still and ui.get(aa_init[7].aabuilderenable) and ui.get(aa_init[0].aa_builder) then
		var.p_state = 7
	elseif c.in_duck == 1 and on_ground then
		var.p_state = 5
	elseif c.in_duck == 1 and not on_ground then
		var.p_state = 6
	elseif not on_ground then
		var.p_state = 4
	elseif p_slow then
		var.p_state = 3
	elseif p_still then
		var.p_state = 1
	elseif not p_still then
		var.p_state = 2
	end

	if var.p_state == 6 then
		c.roll = ui.get(aa_init[6].aayawroll)
	elseif var.p_state == 1 then
		c.roll = ui.get(aa_init[1].aayawroll)
	elseif var.p_state == 1 then
		c.roll = ui.get(aa_init[7].aayawroll)
	elseif var.p_state == 2 then
		c.roll = ui.get(aa_init[2].aayawroll)
	elseif var.p_state == 3 then
		c.roll = ui.get(aa_init[3].aayawroll)
	elseif var.p_state == 4 then
		c.roll = ui.get(aa_init[4].aayawroll)
	elseif var.p_state == 5 then
		c.roll = ui.get(aa_init[5].aayawroll)
	end

	local weaponn = entity.get_player_weapon()
	if ui.get(aa_init[0].legit_e_key) then
		if weaponn ~= nil and entity.get_classname(weaponn) == "CC4" then
			if c.in_attack == 1 then
				c.in_attack = 0 
				c.in_use = 1
			end
		else
			if c.chokedcommands == 0 then
				c.in_use = 0
			end
		end
	end

-----------------------------
--NEW FAKELAG
-----------------------------

local fllag1 = {
	fllag2 = ui.reference("AA", "Fake lag", "Limit"),
}

local fllag3 = {[1] = 15, [2] = 16}

if not ui.get(expfl) then
        ui.set(ref.maxprocticks, 16)
elseif ui.get(expfl) then
        ui.set(ref.maxprocticks, 17)
		ui.set(fllag1.fllag2, fllag3[math.random(1,2)])
    end
end
-----------------------------
--ANIM BREAKERS
-----------------------------

local antiaim = {
	leg_movement = ui.reference("AA", "Other", "Leg movement"),
}

client.set_event_callback("pre_render", function ()

	if not entity.is_alive(entity.get_local_player()) then return end

	if table_contains(ui.get(legszz),"static legs in-air") then
		entity.set_prop(entity.get_local_player(), "m_flPoseParameter", 2, 6) 
	end

	local legs_types = {[1] = "Off", [2] = "Always slide" , [3] = "Never slide"}

	if table_contains(ui.get(legszz),"leg breaker") then
		ui.set(antiaim.leg_movement, legs_types[2])
		entity.set_prop(entity.get_local_player(), "m_flPoseParameter", math.random(0.1, 0.9), math.random(0,1)) 
	end

end)

client.set_event_callback("setup_command", function(c)

-----------------------------
--BINDS
-----------------------------

	local me = entity.get_local_player()

	if not entity.is_alive(me) then return end

	local localp = entity.get_local_player()

	local is_os = ui.get(ref.os[1]) and ui.get(ref.os[2])
	local is_fd = ui.get(ref.fakeduck)
	local is_dt = ui.get(ref.dt[1]) and ui.get(ref.dt[2])

	ui.set(aa_inito.manual_left, "On hotkey")
	ui.set(aa_inito.manual_right, "On hotkey")

	if ui.get(aa_inito.fs) then
		ui.set(ref.freestand[1], "Default")
		ui.set(ref.freestand[2], "Always on")
	else
		ui.set(ref.freestand[1], "-")
		ui.set(ref.freestand[2], "On hotkey")
	end

	if ui.get(aa_inito.edgey) then
        ui.set(ref.edgeyaw, true)
	else
        ui.set(ref.edgeyaw, false)
	end

	local l = 1

-----------------------------
--MANUAL AA
-----------------------------

	if aa.input + 0.22 < globals.curtime() then
		if aa.manaa == 0 then
			if ui.get(aa_inito.manual_left) then
				aa.manaa = 1
				aa.input = globals.curtime()
			elseif ui.get(aa_inito.manual_right) then
				aa.manaa = 2
				aa.input = globals.curtime()
			elseif ui.get(aa_inito.manual_forward) then
				aa.manaa = 3
				aa.input = globals.curtime()
			end
		elseif aa.manaa == 1 then
			if ui.get(aa_inito.manual_right) then
				aa.manaa = 2
				aa.input = globals.curtime()
			elseif ui.get(aa_inito.manual_forward) then
				aa.manaa = 3
				aa.input = globals.curtime()
			elseif ui.get(aa_inito.manual_left) then
				aa.manaa = 0
				aa.input = globals.curtime()
			end
		elseif aa.manaa == 2 then
			if ui.get(aa_inito.manual_left) then
				aa.manaa = 1
				aa.input = globals.curtime()
			elseif ui.get(aa_inito.manual_forward) then
				aa.manaa = 3
				aa.input = globals.curtime()
			elseif ui.get(aa_inito.manual_right) then
				aa.manaa = 0
				aa.input = globals.curtime()
			end
		elseif aa.manaa == 3 then
			if ui.get(aa_inito.manual_forward) then
				aa.manaa = 0
				aa.input = globals.curtime()
			elseif ui.get(aa_inito.manual_left) then
				aa.manaa = 1
				aa.input = globals.curtime()
			elseif ui.get(aa_inito.manual_right) then
				aa.manaa = 2
				aa.input = globals.curtime()
			end
		end
	end
	if aa.manaa == 1 or aa.manaa == 2 or aa.manaa == 3 then
		aa.ignore = true
		if aa.manaa == 1 then
			ui.set(ref.yawjitter[1], "off")
			ui.set(ref.yawjitter[2], 0)
			ui.set(ref.bodyyaw[1], "static")
			ui.set(ref.bodyyaw[2], -180)
			ui.set(ref.yawbase, "local view")
			ui.set(ref.yaw[1], "180")
			ui.set(ref.yaw[2], -90)
			ui.set(ref.fakeyawlimit, 60)
		elseif aa.manaa == 2 then
			ui.set(ref.yawjitter[1], "off")
			ui.set(ref.yawjitter[2], 0)
			ui.set(ref.bodyyaw[1], "static")
			ui.set(ref.bodyyaw[2], -180)
			ui.set(ref.yawbase, "local view")
			ui.set(ref.yaw[1], "180")
			ui.set(ref.yaw[2], 90)
			ui.set(ref.fakeyawlimit, 60)
		elseif aa.manaa == 3 then
			ui.set(ref.yawjitter[1], "off")
			ui.set(ref.yawjitter[2], 0)
			ui.set(ref.bodyyaw[1], "static")
			ui.set(ref.bodyyaw[2], -180)
			ui.set(ref.yawbase, "at targets")
			ui.set(ref.yaw[1], "180")
			ui.set(ref.yaw[2], 180)
			ui.set(ref.fakeyawlimit, 60)
		end
	else
		aa.ignore = false
		ui.set(ref.yawbase, "at targets")
	end

-----------------------------
--ANTIAIM
-----------------------------
local antiaim12 = {
	leg_movement12 = ui.reference("AA", "anti-aimbot angles", "Fake yaw limit"),
}

local legs_types12 = {[1] = 0, [2] = 60}


	local bodyyaw = entity.get_prop(entity.get_local_player(), "m_flPoseParameter", 11) * 120 - 60
	local side = bodyyaw > 0 and 1 or -1

	if aa.ignore == false then
		ui.set(ref.bodyyaw[2], ui.get(aa_init[var.p_state].aayawstatic))
		ui.set(byaw, ui.get(aa_init[var.p_state].aayawbody))
		if ui.get(aa_init[var.p_state].aabuilderenable) and ui.get(aa_init[0].aa_builder) then
            if var.p_state == 6 then
                ui.set(ref.pitch, "Default")
            else
                ui.set(ref.pitch, "Minimal")
            end
			ui.set(jyaw, ui.get(aa_init[var.p_state].aayawjitter))
			ui.set(jyaw_val, ui.get(aa_init[var.p_state].aayawjitterslider))
			if c.chokedcommands ~= 0 then
			else
				ui.set(yaw_val,(side == 1 and ui.get(aa_init[var.p_state].aayawleft) or ui.get(aa_init[var.p_state].aayawright)))
			end
			local bodyyaw = entity.get_prop(entity.get_local_player(), "m_flPoseParameter", 11) * 120 - 60

			if bodyyaw > 0 then
				ui.set(fake_yaw, ui.get(aa_init[var.p_state].fakeyawlimitri))
			elseif bodyyaw < 0 then
				ui.set(fake_yaw,ui.get(aa_init[var.p_state].fakeyawlimit))
			end
		else
			ui.set(ref.pitch, "Minimal")
			if ui.get(aa_init[0].presets) == "jitter" then
				if var.p_state == 1 then
					ui.set(ref.yawjitter[1], "Offset")
					ui.set(ref.yawjitter[2], 30)
					ui.set(ref.bodyyaw[1], "Jitter")
					ui.set(ref.bodyyaw[2], 0)
					ui.set(ref.yawbase, "At targets")
					if c.chokedcommands ~= 0 then
					else
						ui.set(ref.yaw[2],(side == 1 and -7 or 12))
					end
					ui.set(ref.fakeyawlimit, 60)
				elseif var.p_state == 2 then
					ui.set(ref.yawjitter[1], "Offset")
					ui.set(ref.yawjitter[2], 24)
					ui.set(ref.bodyyaw[1], "Jitter")
					ui.set(ref.bodyyaw[2], 0)
					if c.chokedcommands ~= 0 then
					else
						ui.set(ref.yaw[2],(side == 1 and -14 or 16))
					end
					ui.set(ref.fakeyawlimit, 60)
				elseif var.p_state == 3 then
					ui.set(ref.yawjitter[1], "Offset")
					ui.set(ref.yawjitter[2], 24)
					ui.set(ref.bodyyaw[1], "Jitter")
					ui.set(ref.bodyyaw[2], 0)
					if c.chokedcommands ~= 0 then
					else
						ui.set(ref.yaw[2],(side == 1 and -24 or 28))
					end
					ui.set(ref.fakeyawlimit, 60)
				elseif var.p_state == 4 then
					ui.set(ref.yawjitter[1], "Center")
					ui.set(ref.yawjitter[2], 24)
					ui.set(byaw, "Jitter")
					ui.set(ref.bodyyaw[2], 0)
					if c.chokedcommands ~= 0 then
					else
						ui.set(ref.yaw[2],(side == 1 and -4 or 5))
					end
					ui.set(ref.fakeyawlimit, 60)
				elseif var.p_state == 5 then
					ui.set(ref.yawjitter[1], "Offset")
					ui.set(ref.yawjitter[2], 22)
					ui.set(ref.bodyyaw[1], "Jitter")
					ui.set(ref.bodyyaw[2], 0)
					if c.chokedcommands ~= 0 then
					else
						ui.set(ref.yaw[2],(side == 1 and -38 or 27))
					end
					ui.set(ref.fakeyawlimit, 60)
				elseif var.p_state == 6 then
					ui.set(ref.yawjitter[1], "Center")
					ui.set(ref.yawjitter[2], 24)
					ui.set(byaw, "Jitter")
					ui.set(ref.bodyyaw[2], 0)
					if c.chokedcommands ~= 0 then
					else
						ui.set(ref.yaw[2],(side == 1 and -7 or 8))
					end
					ui.set(ref.fakeyawlimit, 60)
				end
			elseif ui.get(aa_init[0].presets) == "experimental" then
				if var.p_state == 1 then
					ui.set(ref.yawjitter[1], "Off")
					ui.set(ref.yawjitter[2], 180)
					ui.set(ref.bodyyaw[1], "Opposite")
					ui.set(ref.bodyyaw[2], 90)
					ui.set(ref.yawbase, "At targets")
					if c.chokedcommands ~= 0 then
					else
						ui.set(ref.yaw[2],(side == 1 and -0 or 0))
					end
					ui.set(antiaim12.leg_movement12, legs_types12[math.random(1,2)])
				elseif var.p_state == 2 then
					ui.set(ref.yawjitter[1], "Off")
					ui.set(ref.yawjitter[2], 180)
					ui.set(ref.bodyyaw[1], "Opposite")
					ui.set(ref.bodyyaw[2], 90)
					ui.set(ref.yawbase, "At targets")
					if c.chokedcommands ~= 0 then
					else
						ui.set(ref.yaw[2],(side == 1 and -0 or 0))
					end
					ui.set(antiaim12.leg_movement12, legs_types12[math.random(1,2)])
				elseif var.p_state == 3 then
					ui.set(ref.yawjitter[1], "Off")
					ui.set(ref.yawjitter[2], 0)
					ui.set(ref.bodyyaw[1], "Opposite")
					ui.set(ref.bodyyaw[2], 90)
					ui.set(ref.yawbase, "At targets")
					if c.chokedcommands ~= 0 then
					else
						ui.set(ref.yaw[2],(side == 1 and -0 or 0))
					end
					ui.set(ref.fakeyawlimit, math.random(0,60))
				elseif var.p_state == 4 then
					ui.set(ref.yawjitter[1], "Off")
					ui.set(ref.yawjitter[2], 180)
					ui.set(ref.bodyyaw[1], "Opposite")
					ui.set(ref.bodyyaw[2], 90)
					ui.set(ref.yawbase, "At targets")
					if c.chokedcommands ~= 0 then
					else
						ui.set(ref.yaw[2],(side == 1 and -0 or 0))
					end
					ui.set(ref.fakeyawlimit, math.random(0,60))
				elseif var.p_state == 5 then
					ui.set(ref.yawjitter[1], "Off")
					ui.set(ref.yawjitter[2], 180)
					ui.set(ref.bodyyaw[1], "Opposite")
					ui.set(ref.bodyyaw[2], 90)
					ui.set(ref.yawbase, "At targets")
					if c.chokedcommands ~= 0 then
					else
						ui.set(ref.yaw[2],(side == 1 and -0 or 0))
					end
					ui.set(ref.fakeyawlimit, math.random(0,60))
				elseif var.p_state == 6 then
					ui.set(ref.yawjitter[1], "Off")
					ui.set(ref.yawjitter[2], 180)
					ui.set(ref.bodyyaw[1], "Opposite")
					ui.set(ref.bodyyaw[2], 90)
					ui.set(ref.yawbase, "At targets")
					if c.chokedcommands ~= 0 then
					else
						ui.set(ref.yaw[2],(side == 1 and -0 or 0))
					end
					ui.set(ref.fakeyawlimit, math.random(0,60))
				end
			end
		end
	end
end)

-----------------------------
--BRUTE2
-----------------------------

local function brute_impact(e)

	local me = entity.get_local_player()

	if not entity.is_alive(me) then return end

	local shooter_id = e.userid
	local shooter = client.userid_to_entindex(shooter_id)

	if not entity.is_enemy(shooter) or entity.is_dormant(shooter) then return end

	local lx, ly, lz = entity.hitbox_position(me, "head_0")
	
	local ox, oy, oz = entity.get_prop(me, "m_vecOrigin")
	local ex, ey, ez = entity.get_prop(shooter, "m_vecOrigin")

	local dist = ((e.y - ey)*lx - (e.x - ex)*ly + e.x*ey - e.y*ex) / math.sqrt((e.y-ey)^2 + (e.x - ex)^2)
	
	if math.abs(dist) <= 35 and globals.curtime() - brute.last_miss > 0.015 then

		brute.last_miss = globals.curtime()
		if brute.misses[shooter] == nil then
			brute.misses[shooter] = 1 
			brute.misses_ind[shooter] = 1
		elseif brute.misses[shooter] >= 2 then
			brute.misses[shooter] = nil
		else
			brute.misses_ind[shooter] = brute.misses_ind[shooter] + 1
			brute.misses[shooter] = brute.misses[shooter] + 1
		end
	end
end

brute.reset = function()
	brute.fs_side = 0
	brute.last_miss = 0
	brute.best_angle = 0
	brute.misses_ind = { }
	brute.misses = { }
end

local function brute_death(e)
	
	local victim_id = e.userid
	local victim = client.userid_to_entindex(victim_id)

	if victim ~= entity.get_local_player() then return end

	local attacker_id = e.attacker
	local attacker = client.userid_to_entindex(attacker_id)

	if not entity.is_enemy(attacker) then return end

	if not e.headshot then return end

	if brute.misses[attacker] == nil or (globals.curtime() - brute.last_miss < 0.06 and brute.misses[attacker] == 1) then
		if brute.hit_reverse[attacker] == nil then
			brute.hit_reverse[attacker] = true
		else
			brute.hit_reverse[attacker] = nil
		end
	end
end

local value = 0
local once1 = false
local once2 = false
local dt_a = 0
local dt_y = 45
local dt_x = 0
local dt_w = 0
local os_a = 0
local os_y = 45
local os_x = 0
local os_w = 0
local fs_a = 0
local fs_y = 45
local fs_x = 0
local fs_w = 0
local n_x = 0
local n2_x = 0
local n3_x = 0
local n4_x = 0

local round = function(value, multiplier) local multiplier = 10 ^ (multiplier or 0); return math.floor(value * multiplier + 0.5) / multiplier end

local was_on_ground = false

-----------------------------
--INDICATORS
-----------------------------

local function renderer_shit(x, y, w, r, g, b, a, edge_h)
	if edge_h == nil then edge_h = 0 end
	local local_player = entity.get_local_player()
	local velocity = string.format('%.2f', vector(entity.get_prop(local_player, 'm_vecVelocity')):length2d())		
	local pos_x, pos_y, pos_z = entity.get_origin(local_player)
	renderer.rectangle(x+1, y-2, w-5, 2.5, 15, 15, 15, 50) --
	renderer.rectangle(x-2, y-3, w+3, 1.5, 10, 10, 10, 50) --
	renderer.rectangle(x-2, y-2, 2, 20, 10, 10, 10, 50) --
	renderer.rectangle(x, y-2, 2.5, 20, 15, 15, 15, 50) -- 
	renderer.rectangle(x+w-3, y-2, 2.5, 20, 15, 15, 15, 50) --
	renderer.rectangle(x+w-1, y-2, 2, 20, 10, 10, 10, 50) -- 
	renderer.rectangle(x+2, y+16, w-5, 2.5, 15, 15, 15, 50) -- 
	renderer.rectangle(x-2, y+18, w+3, 1.5, 10, 10, 10, 50) --
	renderer.rectangle(x+2, y, w-5, 16, 0, 0, 0, 85) ---
	local me = entity.get_local_player()
	local desync_type = antiaim_funcs.get_overlap(float)
	local r,g,b = ui.get(main_clr)
end

-----------------------------
--WATERMARK
-----------------------------

local function watermark()
	local h, m, s, mst = client.system_time()

	local actual_time = ('%2d:%02d'):format(h, m)

	local latency = client.latency()*1000

	local latency_text = ('  %d'):format(latency) or ''

	local czit = gradient_text(169,183,255,255,222,227,255,255, "voidness")

	local wersja = obex_data.build

	local nazwa = obex_data.username

	local ticki = "64tick"

	local r,g,b = ui.get(main_clr)

	text = (" %s \aFFFFFFFF~ \aFFFFFFFF%s \a5b5d63FF| \aFFFFFFFF%s \a5b5d63FF| \aFFFFFFFFdelay:%sms \a5b5d63FF| \aFFFFFFFF%s \a5b5d63FF| \aFFFFFFFF%s "):format(czit, wersja, nazwa, latency_text, ticki, actual_time)
		
	local h, w = 18, renderer.measure_text(nil, text) + 8
	local x, y = client.screen_size(), 10 + (-3)
		
	x = x - w - 10

	if ui.get(watermarko) then
		renderer_shit(x, y, w, 65, 65, 65, 180, 2)
		renderer.text(x+4, y + 1, 255, 255, 255, 255, '', 0, text)
	else
		renderer.text(x+160, y + 1, 255, 255, 255, 255, '', 0, "")
	end
end

client.set_event_callback("paint", watermark)

-----------------------------
--CROSSHAIR INDS
-----------------------------

animationum.lerp = function(start, vend, time)
    return start + (vend - start) * time
end

linear_interpolation = function(start, _end, time)
	return (_end - start) * time + start
end

clamp = function(value, minimum, maximum)
	if minimum > maximum then
		return math.min(math.max(value, maximum), minimum)
	else
		return math.min(math.max(value, minimum), maximum)
	end
end

local function clamp2(val, min_val, max_val)
	return math.max(min_val, math.min(max_val, val))
end

lerp2 = function(start, _end, time)
	time = time or 0.005;
	time = clamp(globals.frametime() * time * 175.0, 0.01, 1.0)
	local a = linear_interpolation(start, _end, time)
	if _end == 0.0 and a < 0.01 and a > -0.01 then
		a = 0.0
	elseif _end == 1.0 and a < 1.01 and a > 0.99 then
		a = 1.0
	end
	return a
end

local testx = 0
local aaa = 0
local lele = 0

local function round(num, decimals)
	local mult = 10^(decimals or 0)
	return math_floor(num * mult + 0.5) / mult
end

local function draw()
	local screen = {client.screen_size()}
    local center = {screen[1]/2, screen[2]/2}

	local bodyyaw = entity.get_prop(entity.get_local_player(), "m_flPoseParameter", 11) * 120 - 60
	local side = bodyyaw > 0 and 1 or -1

	local mr,mg,mb,ma = ui.get(main_clr)

	local x, y = client.screen_size()

	local me = entity.get_local_player()

	if not entity.is_alive(me) then return end

	local is_charged = antiaim_funcs.get_double_tap()
	local is_dt = ui.get(ref.dt[1]) and ui.get(ref.dt[2])
	local is_os = ui.get(ref.os[1]) and ui.get(ref.os[2])
	local is_fs = ui.get(aa_inito.fs)
	local is_ba = ui.get(ref.forcebaim)
	local is_sp = ui.get(ref.safepoint)
	local is_qp = ui.get(ref.quickpeek[2])

	if is_charged then dr,dg,db,da=167, 252, 121,255 elseif is_os then dr,dg,db,da=255,255,255,255 else dr,dg,db,da=255,0,0,255 end;if is_qp then qr,qg,qb,qa=255,255,255,255 else qr,qg,qb,qa=255,255,255,150 end;if is_ba then br,bg,bb,ba=255,255,255,255 else br,bg,bb,ba=255,255,255,150 end;if is_fs then fr,fg,fb,fa=255,255,255,255 else fr,fg,fb,fa=255,255,255,150 end;if is_sp then sr,sg,sb,sa=255,255,255,255 else sr,sg,sb,sa=255,255,255,150 end
	--sine_in
	value = value + globals.frametime() * 9

	local _, y2 = client.screen_size()

	local state = "MOVING"

	--states [for searching]
	if ui.get(aa_init[0].aa_stc_tillhit) then
		if brute.can_hit == 0 then
			state = "INDEXED"
		end
	else
		if brute.yaw_status == "brute L" and brute.misses[best_enemy] ~= nil then
			state = "BRUTE ["..brute.misses[best_enemy].."] [L]"
		elseif brute.yaw_status == "brute R" and brute.misses[best_enemy] ~= nil then
			state = "BRUTE ["..brute.misses[best_enemy].."] [R]"
		elseif var.p_state == 7 and ui.get(aa_init[0].aa_builder) then
			state = "FL"
		elseif var.p_state == 5 then
			state = "DUCK"
		elseif var.p_state == 6 then
			state = "AIRDUCK"
		elseif var.p_state == 4 then
			state = "AIR"
		elseif var.p_state == 3 then
			state = "SLOWWALK"
		elseif var.p_state == 1 then
			state = "STAND"
		elseif var.p_state == 2 then
			state = "MOVE"
		end
	end

	local realtime = globals.realtime() % 3
	local alpha = math.floor(math.sin(realtime * 4) * (180 / 2 - 1) + 180 / 2) or 180

	local exp_ind = ""

	if is_dt then
		exp_ind = "DT"
	elseif is_os then
		exp_ind = "HS"
	end

	local me = entity.get_local_player()
	local wpn = entity.get_player_weapon(me)

	local scope_level = entity.get_prop(wpn, 'm_zoomLevel')
	local scoped = entity.get_prop(me, 'm_bIsScoped') == 1
	local resume_zoom = entity.get_prop(me, 'm_bResumeZoom') == 1

	local is_valid = entity.is_alive(me) and wpn ~= nil and scope_level ~= nil
	local act = is_valid and scope_level > 0 and scoped and not resume_zoom

	local flag = "c-"
	local ting = 0
	local testting = 0

	--animation shit

	if is_dt or is_os then
		n4_x = animationum.lerp(n4_x, 8, globals.frametime() * 8)
	else
		n4_x = animationum.lerp(n4_x, -1, globals.frametime() * 8)
	end

	if act then
		flag = "-"
		ting = 23
		testting = 11

		testx = animationum.lerp(testx, 30, globals.frametime() * 5)

		n2_x = animationum.lerp(n2_x, 11, globals.frametime() * 5)

		n3_x = animationum.lerp(n3_x, 5, globals.frametime() * 5)

	else
		testx = animationum.lerp(testx, 0, globals.frametime() * 5)

		n2_x = animationum.lerp(n2_x, -1, globals.frametime() * 5)

		n3_x = animationum.lerp(n3_x, 0, globals.frametime() * 5)

		flag = "c-"
		ting = 28
	end

	if is_dt then if dt_a<255 then dt_a=dt_a+5 end;if dt_w<10 then dt_w=dt_w+0.28 end;if dt_y<36 then dt_y=dt_y+1 end;if fs_x<11 then fs_x=fs_x+0.25 end elseif not is_dt then if dt_a>0 then dt_a=dt_a-5 end;if dt_w>0 then dt_w=dt_w-0.2 end;if dt_y>25 then dt_y=dt_y-1 end;if fs_x>0 then fs_x=fs_x-0.25 end end;if is_os and not is_dt then if os_a<255 then os_a=os_a+5 end;if os_w<12 then os_w=os_w+0.28 end;if os_y<36 then os_y=os_y+1 end;if fs_x<12 then fs_x=fs_x+0.5 end elseif not is_os and not is_dt then if os_a>0 then os_a=os_a-5 end;if os_w>0 then os_w=os_w-0.2 end;if os_y>25 then os_y=os_y-1 end;if fs_x>0 then fs_x=fs_x-0.5 end end;if is_fs then if fs_w<10 then fs_w=fs_w+0.35 end;if fs_a<255 then fs_a=fs_a+5 end;if dt_x>-7 then dt_x=dt_x-0.5 end;if os_x>-7 then os_x=os_x-0.5 end;if fs_y<36 then fs_y=fs_y+1 end elseif not is_fs then if fs_a>0 then fs_a=fs_a-5 end;if fs_w>0 then fs_w=fs_w-0.2 end;if dt_x<0 then dt_x=dt_x+0.5 end;if os_x<0 then os_x=os_x+0.5 end;if fs_y>25 then fs_y=fs_y-1 end end

	if ui.get(inds_selct) == "ephemeral" and ui.get(crosshair_inds) then
		if is_dt then
			renderer.text(x / 2 - 0.5 + os_x, y2 / 2 + os_y + 10, dr, dg, db, os_a, "c-", os_w, " ")
		else
			renderer.text(x / 2 - 0.5 + n3_x, y2 / 2 + os_y+ 13, dr, dg, db, os_a, "c-", os_w, "OS ")
		end
		renderer.text(x / 2 - 0.5 + n3_x, y2 / 2 + dt_y+ 13, dr, dg, db, dt_a, "c-", dt_w, "DT")

		renderer.text(x / 2 - 0.5 + fs_x + n3_x, y2 / 2 + fs_y+ 13, 255, 255, 255, fs_a, "c-", fs_w, "FS")

		local wx, wy = client.screen_size()
		
		--round_rect(wx - 30, wy - wy - 180, 89, 52, 235)

		local desync_type = antiaim_funcs.get_overlap(float)
		local desync_type2 = antiaim_funcs.get_desync(2)

		renderer.text(x / 2-30 + testx, y / 2 + 25, mr,mg,mb, 255, "-", 0, 'VOIDNESS')
		renderer.text(x / 2+7 + testx, y / 2 + 25, 255,255,255, alpha, "-", 0, '' .. obex_data.build:upper())
		renderer.text(x / 2 + n2_x - testting, y / 2 + ting + 11 , 255, 255, 255, 180, flag, 0, state)
	end

	if ui.get(inds_selct) == "voidness" and ui.get(crosshair_inds) then
		if entity.get_local_player() == nil or not entity.is_alive(entity.get_local_player()) then return end

		wojdnes = gradient_text(169,183,255,255,222,227,255,255, "VOIDNESS")
		renderer.text(center[1] + 17, center[2] + 25, mr,mg,mb,255,  "-c", nil, "" .. wojdnes)
		renderer.text(center[1] + 46, center[2] + 25, 255,255,255, alpha, "-c", nil, "BETA")
		renderer.text(center[1] + 28, center[2] + 39, 255,255,255,180, "-c", nil, state)
		renderer.text(center[1] + 27, center[2] + 31, 255,255,255,255,  "-c", nil, "·")
		renderer.text(center[1] + 16, center[2] + 28, 255,255,255,100, "-c", 0, "⏤⏤")
		renderer.text(center[1] + 41, center[2] + 28, 255,255,255,100, "-c", 0, "⏤⏤")
		if bodyyaw > 0 then
			renderer.text(center[1] + 16, center[2] + 28, mr,mg,mb,255, "-c", 0, "⏤⏤")
		else
            renderer.text(center[1] + 41, center[2] + 28, mr,mg,mb,255, "-c", 0, "⏤⏤")
		end
		if ui.get(ref.forcebaim) then
			renderer.text(center[1] + 18, center[2] + 59, 255,255,255,255, "-c", nil, "BAIM")
		else
			renderer.text(center[1] + 18, center[2] + 59, 255,255,255, 170, "-c", nil, "BAIM")
		end
		if is_qp then
		    renderer.text(center[1] + 37, center[2] + 59, 255,255,255,255, "-c", nil, "QPA")
		else
		    renderer.text(center[1] + 37, center[2] + 59, 255,255,255, 170, "-c", nil, "QPA")
		end
		if is_dt then
		    renderer.text(center[1] + 34, center[2] + 49, 255,255,255,255, "-c", nil, "DT")
		else
		    renderer.text(center[1] + 34, center[2] + 49, 255,255,255, 170, "-c", nil, "DT")
		end
		if is_os then
		    renderer.text(center[1] + 47, center[2] + 49, 255,255,255,255, "-c", nil, "OS")
		else
		    renderer.text(center[1] + 47, center[2] + 49, 255,255,255, 170, "-c", nil, "OS")
		end
		if is_sp then
			renderer.text(center[1] + 10, center[2] + 49, 255,255,255,255, "-c", nil, "SP")
		else
			renderer.text(center[1] + 10, center[2] + 49, 255,255,255, 170, "-c", nil, "SP")
		end
		if ui.get(ref.freestand[2]) then
			renderer.text(center[1] + 22, center[2] + 49, 255,255,255,255, "-c", nil, "FS")
		else
			renderer.text(center[1] + 22, center[2] + 49, 255,255,255, 170, "-c", nil, "FS")
		end  
	end

-----------------------------
--CROSSHAIR ARROWS
-----------------------------
	
	if ui.get(arrw_selct) == "default" and ui.get(manaa_inds) then
		renderer.triangle(x / 2 + 55, y / 2 + 2, x / 2 + 42, y / 2 - 7, x / 2 + 42, y / 2 + 11, 
		aa.manaa == 2 and mr or 25, 
		aa.manaa == 2 and mg or 25, 
		aa.manaa == 2 and mb or 25, 
		aa.manaa == 2 and ma or 160)

		renderer.triangle(x / 2 - 55, y / 2 + 2, x / 2 - 42, y / 2 - 7, x / 2 - 42, y / 2 + 11, 
		aa.manaa == 1 and mr or 25, 
		aa.manaa == 1 and mg or 25, 
		aa.manaa == 1 and mb or 25, 
		aa.manaa == 1 and ma or 160)
	
		renderer.rectangle(x / 2 + 38, y / 2 - 7, 2, 18, 
		bodyyaw < -10 and mr or 25,
		bodyyaw < -10 and mg or 25,
		bodyyaw < -10 and mb or 25,
		bodyyaw < -10 and ma or 160)
		renderer.rectangle(x / 2 - 40, y / 2 - 7, 2, 18,			
		bodyyaw > 10 and mr or 25,
		bodyyaw > 10 and mg or 25,
		bodyyaw > 10 and mb or 25,
		bodyyaw > 10 and ma or 160)
		end
	--renderer.rectangle(x / 2 - 20, y / 2 + 50, 43, 2, 16, 16, 16, 255)
	--renderer.gradient(x / 2 - 20, y / 2 + 50, desync_strength, 2, 255, 255, 255, 180, mr,mg,mb, 255, true)

	if ui.get(arrw_selct) == "manual" and ui.get(manaa_inds) then
		renderer.triangle(x / 2 + 55, y / 2 + 2, x / 2 + 42, y / 2 - 7, x / 2 + 42, y / 2 + 11, 
		aa.manaa == 2 and mr or 25, 
		aa.manaa == 2 and mg or 25, 
		aa.manaa == 2 and mb or 25, 
		aa.manaa == 2 and ma or 160)

		renderer.triangle(x / 2 - 55, y / 2 + 2, x / 2 - 42, y / 2 - 7, x / 2 - 42, y / 2 + 11, 
		aa.manaa == 1 and mr or 25, 
		aa.manaa == 1 and mg or 25, 
		aa.manaa == 1 and mb or 25, 
		aa.manaa == 1 and ma or 160)
		end
	--renderer.rectangle(x / 2 - 20, y / 2 + 50, 43, 2, 16, 16, 16, 255)
	--renderer.gradient(x / 2 - 20, y / 2 + 50, desync_strength, 2, 255, 255, 255, 180, mr,mg,mb, 255, true)

	if ui.get(arrw_selct) == "desync" and ui.get(manaa_inds) then
        renderer.rectangle(x / 2 + 38, y / 2 - 7, 2, 18, 
		bodyyaw < -10 and mr or 25,
		bodyyaw < -10 and mg or 25,
		bodyyaw < -10 and mb or 25,
		bodyyaw < -10 and ma or 160)
		renderer.rectangle(x / 2 - 40, y / 2 - 7, 2, 18,			
		bodyyaw > 10 and mr or 25,
		bodyyaw > 10 and mg or 25,
		bodyyaw > 10 and mb or 25,
		bodyyaw > 10 and ma or 160)
		end
	--renderer.rectangle(x / 2 - 20, y / 2 + 50, 43, 2, 16, 16, 16, 255)
	--renderer.gradient(x / 2 - 20, y / 2 + 50, desync_strength, 2, 255, 255, 255, 180, mr,mg,mb, 255, true)
end

-----------------------------
--CONFIGS
-----------------------------

local function export_config()
	local settings = {}
	for key, value in pairs(var.player_states) do
		settings[tostring(value)] = {}
		for k, v in pairs(aa_init[key]) do
			settings[value][k] = ui.get(v)
		end
	end
	
	clipboard.set(json.stringify(settings))
	print("You have sucessfully exported your voidness configuration! It's ready for your friends to use.")
end

export_btn = gradient_text(169,183,255,255,222,227,255,255, "voidness")
local export_btn = ui.new_button("AA", "Other", "export " .. export_btn .. " \aFFFFFFC9configuration", export_config)

local function import_config()

	local settings = json.parse(clipboard.get())

	for key, value in pairs(var.player_states) do
		for k, v in pairs(aa_init[key]) do
			local current = settings[value][k]
			if (current ~= nil) then
				ui.set(v, current)
			end
		end
	end
	print("You have sucessfully imported your voidness configuration! Enjoy using this config.")
end

import_btn = gradient_text(169,183,255,255,222,227,255,255, "voidness")
local import_btn = ui.new_button("AA", "Other", "import " .. import_btn .. " \aFFFFFFC9configuration", import_config)

local function config_menu()
	local is_enabled = ui.get(lua_enable)
	if ui.get(aa_init[0].aa_builder) and is_enabled then
		ui.set_visible(export_btn, true)
		ui.set_visible(import_btn, true)
	else
		ui.set_visible(export_btn, false)
		ui.set_visible(import_btn, false)
	end
end

client.set_event_callback("paint", draw)
client.set_event_callback("paint_ui", set_lua_menu)
client.set_event_callback("paint_ui", set_og_menu)
client.set_event_callback("paint_ui", config_menu)

-----------------------------
--KILLSAY/TRASHTALK
-----------------------------

local baimtable = {
    'helo my naim ist ' .. obex_data.username .. ' me is use ' .. obex_data.build .. ' of voidness!!!!!!',
	'𝖊𝖓𝖏𝖔𝖞 𝖉𝖎𝖊 𝖙𝖔 𝖛𝖔𝖎𝖉𝖓𝖊𝖘𝖘 𝖑𝖚𝖆 𝖘𝖐𝖗𝖎𝖕𝖙',
	'𝓋𝑜𝒾𝒹𝓃𝑒𝓈𝓈 𝓋𝓈 𝓃𝓃 𝒾𝓈 𝓌𝒾𝓃 𝓈𝑜 𝑒𝒶𝓈𝓎',
	'𝕞𝕪 𝕔𝕙𝕖𝕒𝕥 𝕚𝕤 𝕦𝕤𝕖 𝕧𝕠𝕚𝕕𝕟𝕖𝕤𝕤 𝕣𝕖𝕤𝕠𝕝𝕧𝕖𝕣 𝕒𝕟𝕕 𝕙𝕖𝕕𝕤𝕙𝕠𝕥',
	'ｎｉｃｅ ｍｉｓｓ ｄｏｇ ｏｗｎｅｄ １',
	'ʙʏ ᴠᴏɪᴅɴᴇꜱꜱ',
	'ʷʰᵉⁿ ᵍᵃᵐᵉ ˢᵗᵃʳᵗ ʸᵒᵘ ⁱˢ ˡᵒˢᵉ ᵃˡʳᵉᵃᵈʸ',
	'𝐮𝐫 𝐥𝐮𝐚 𝐜𝐫𝐚𝐜𝐤𝐞𝐝 𝐥𝐢𝐤𝐞 𝐞𝐠𝐠',
	'YӨЦ ΛЯΣПƬ ЩIП ƧЯY.',
	'♥ after contact sigma i hs and smile ♥',
	'𝖋𝖗𝖊𝖊 𝖍𝖛𝖍 2020-2022 𝖑𝖊𝖘𝖘𝖔𝖓 𝖞𝖔𝖚𝖙𝖚𝖇𝖊.𝖈𝖔𝖒/𝖒𝖆𝖐𝖎𝖍𝖛𝖍',
	'ｇｏｄ ｉｓ ｇｉｖｅ ｍｅ ｐｏｗｅｒ ｔｏ ｈｅａｄｓｈｏｔ ｙｏｕ',
	'you is owned by voidness lua for 𝖌𝖆𝖒𝖊𝖘𝖊𝖓𝖘𝖊',
	'1',
	'privat doubltap peak solution ◣_◢',
	'𝖚𝖗 𝖆𝖓𝖙𝖎𝖆𝖎𝖒𝖇𝖔𝖙 𝖎𝖘 𝖘𝖔𝖑𝖛𝖊 𝖇𝖞 𝖗𝖊𝖘𝖔𝖑𝖛𝖊𝖗 𝖛𝖔𝖎𝖉𝖓𝖊𝖘𝖘 ◣_◢◣_◢◣_◢',
	'sowwy >_<',
	'𝕨𝕙𝕖𝕟 𝕚 𝕣𝕖𝕔𝕖𝕚𝕧 𝕓𝕖𝕥𝕒 𝕧𝕠𝕚𝕕𝕟𝕖𝕤𝕤 𝕚 +𝕨 𝕚𝕟𝕥𝕠 𝕦 (◣_◢)',
	'ｅｘｅｃｕｔｅ ｒａｔ．ｅｘｅ ｄｏｎｅ．',
	'𝖙𝖗𝖔𝖑𝖑𝖊𝖉◣__◢',
	'𝕨𝕙𝕖𝕟 𝕚 𝕤𝕖𝕖 𝕨𝕖𝕜𝕖 𝕚 𝕣𝕖𝕡𝕠𝕣𝕥 𝕡𝕣𝕚𝕞𝕠𝕣𝕕𝕚𝕒𝕝 𝕒𝕔c𝕠𝕟𝕥 (◣_◢)',
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
}
local hstable = baimtable

local deathtable = {
    'you think you win?',
	'you is defeat voidness lua but i not lose ◣_◢',
	'lucky monkey.',
	'my teammate bait for you.',
	'𝓁𝒶𝑔 𝒹𝒾𝑒',
	'𝖞𝖔𝖚 𝖐𝖎𝖑 𝖒𝖊 𝖇𝖚𝖙 𝖎 𝖘𝖍𝖔𝖙 𝖚 𝖍𝖊𝖆𝖉𝖘𝖍𝖔𝖗𝖙 𝖓𝖊𝖝𝖙 𝖗𝖔𝖚𝖓𝖉',
	'ｈｏｗ ｙｏｕ ｌｅｖｅ ｏｎ ｌｕｃｋ？？',
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

local num_quotes_baim = get_table_length(baimtable)
local num_quotes_hs = get_table_length(hstable)
local num_quotes_death = get_table_length(deathtable)

local function on_player_death(e)
	if not ui_get(trashtalk) then
		return
	end
	local victim_userid, attacker_userid = e.userid, e.attacker
	if victim_userid == nil or attacker_userid == nil then
		return
	end

	local victim_entindex   = userid_to_entindex(victim_userid)
	local attacker_entindex = userid_to_entindex(attacker_userid)
	if attacker_entindex == get_local_player() and is_enemy(victim_entindex) then
		if e.headshot then
			    local commandhs = 'say ' .. hstable[math.random(num_quotes_hs)]
                console_cmd(commandhs)
		else
			    local commandbaim = 'say ' .. baimtable[math.random(num_quotes_baim)]
                console_cmd(commandbaim)
		end
	end
	if victim_entindex == get_local_player() and attacker_entindex ~= get_local_player() then
          local commandbaim = 'say ' .. deathtable[math.random(num_quotes_death)]
          console_cmd(commandbaim)
	elseif victim_entindex == get_local_player() and attacker_entindex == get_local_player() then
			console_cmd("say I had to die to make it fair.")
	end
end

client.set_event_callback("player_death", on_player_death)

-----------------------------
--CUSTOM SCOPE
-----------------------------

local scope_overlay = ui_reference('VISUALS', 'Effects', 'Remove scope overlay')

local g_paint_ui = function()
	ui_set(scope_overlay, true)
end

local g_paint = function()
	ui_set(scope_overlay, false)

	local width, height = client_screen_size()
	local offset, initial_position, speed, color =
		ui_get(overlay_offset) * height / 1080, 
		ui_get(overlay_position) * height / 1080, 
		ui_get(fade_time), { ui_get(color_picker) }

	local me = entity_get_local_player()
	local wpn = entity_get_player_weapon(me)

	local scope_level = entity_get_prop(wpn, 'm_zoomLevel')
	local scoped = entity_get_prop(me, 'm_bIsScoped') == 1
	local resume_zoom = entity_get_prop(me, 'm_bResumeZoom') == 1

	local is_valid = entity_is_alive(me) and wpn ~= nil and scope_level ~= nil
	local act = is_valid and scope_level > 0 and scoped and not resume_zoom

	local FT = speed > 3 and globals_frametime() * speed or 1
	local alpha = easing.linear(m_alpha, 0, 1, 1)

	renderer_gradient(width/2 - initial_position + 2, height / 2, initial_position - offset, 1, color[1], color[2], color[3], 0, color[1], color[2], color[3], alpha*color[4], true)
	renderer_gradient(width/2 + offset, height / 2, initial_position - offset, 1, color[1], color[2], color[3], alpha*color[4], color[1], color[2], color[3], 0, true)

	renderer_gradient(width / 2, height/2 - initial_position + 2, 1, initial_position - offset, color[1], color[2], color[3], 0, color[1], color[2], color[3], alpha*color[4], false)
	renderer_gradient(width / 2, height/2 + offset, 1, initial_position - offset, color[1], color[2], color[3], alpha*color[4], color[1], color[2], color[3], 0, false)
	
	m_alpha = clamp(m_alpha + (act and FT or -FT), 0, 1)
end

local ui_callback = function(c)
	local master_switch, addr = ui_get(c), ''

	if not master_switch then
		m_alpha, addr = 0, 'un'
	end
	
	local _func = client[addr .. 'set_event_callback']

	ui_set_visible(scope_overlay, not master_switch)
	ui_set_visible(overlay_position, master_switch)
	ui_set_visible(overlay_offset, master_switch)
	ui_set_visible(fade_time, master_switch)

	_func('paint_ui', g_paint_ui)
	_func('paint', g_paint)
end

ui_set_callback(master_switch, ui_callback)
ui_callback(master_switch)

---------------------------------------------
--CLAN TAG SPAMMER
---------------------------------------------

local duration = 14
local clantags = {

	"",
	"v",
	"v0",
	"vo",
	"vo1",
	"voi",
	"voio|",
	"void",
	"void|>|",
	"voidn",
	"voidn3",
	"voidne",
	"voidne5",
	"voidnes",
	"voidnes5",
	"voidness",
	"voidness.",
	"voidness.<",
	"voidness.l<",
	"voidness.lu<",
	"voidness.lua",
	"voidness.lua",
	"voidness.lua",
	"voidness.lua",
	"voidness.lua",
	"voidness.lu<",
	"voidness.l<",
	"voidness.<",
	"voidness.",
	"voidnes5",
	"voidnes",
	"voidne5",
	"voidne",
	"voidn3",
	"voidn",
	"void|>|",
	"void",
	"voio|",
	"voi",
	"vo1",
	"vo",
	"v0",
	"v",
	""
}

local empty = {''}
local clantag_prev
client.set_event_callback('net_update_end', function()
    if ui.get(skeetclantag) then 
        return 
    end

    local cur = math.floor(globals.tickcount() / duration) % #clantags
    local clantag = clantags[cur+1]

    if ui.get(clantagspam) then
        if clantag ~= clantag_prev then
            clantag_prev = clantag
            client.set_clan_tag(clantag)
        end
    end
end)
ui.set_callback(clantagspam, function() client.set_clan_tag('\0') end)

ffi.cdef[[
	struct cusercmd
	{
		struct cusercmd (*cusercmd)();
		int     command_number;
		int     tick_count;
	};
	typedef struct cusercmd*(__thiscall* get_user_cmd_t)(void*, int, int);
]]

-----------------------------
--BASE64
-----------------------------

local signature_ginput = base64.decode("uczMzMyLQDj/0ITAD4U=")
local match = client.find_signature("client.dll", signature_ginput) or error("Missing sig1")
local g_input = ffi.cast("void**", ffi.cast("char*", match) + 1)[0] or error("Match is nil")
local g_inputclass = ffi.cast("void***", g_input)
local g_inputvtbl = g_inputclass[0]
local rawgetusercmd = g_inputvtbl[8]
local get_user_cmd = ffi.cast("get_user_cmd_t", rawgetusercmd)
local lastlocal = 0
local function reduce(e)
	local cmd = get_user_cmd(g_inputclass , 0, e.command_number)
	if lastlocal + 0.9 > globals.curtime() then
		cmd.tick_count = cmd.tick_count + 8
	else
		cmd.tick_count = cmd.tick_count + 1
	end
end

client.set_event_callback("setup_command", reduce)


local function fire(e)
	if client.userid_to_entindex(e.userid) == entity.get_local_player() then
		lastlocal = globals.curtime()
		if ui.get(ref.dt[1]) and ui.get(ref.dt[2]) then
			lastdt = globals.curtime() + 1.1
		end
	end
end

client.set_event_callback("weapon_fire", fire)

-----------------------------
--LUA FUNCS
-----------------------------

local function main()
	client.set_event_callback("run_command", function()
		get_best_enemy()
		get_best_angle()
	end)

	client.set_event_callback("bullet_impact", function(e)
		brute_impact(e)
	end)

	client.set_event_callback("shutdown", function()
		set_og_menu(true)
	end)

	client.set_event_callback("player_death", function(e)
		brute_death(e)
		if client.userid_to_entindex(e.userid) == entity.get_local_player() then
			brute.reset()
		end
	end)

	client.set_event_callback("round_start", function()
		aa.input = 0
		aa.ignore = false
		lastlocal = 0
		lastdt = 0
		brute.reset()
		local me = entity.get_local_player()
		if not entity.is_alive(me) then return end
	end)

	client.set_event_callback("client_disconnect", function()
		aa.input = 0
		aa.ignore = false
		brute.reset()
	end)

	client.set_event_callback("game_newmap", function()
		aa.input = 0
		aa.ignore = false
		brute.reset()
	end)

	client.set_event_callback("cs_game_disconnected", function()
		aa.input = 0
		aa.ignore = false
		brute.reset()
	end)
end
client.set_event_callback("setup_command", on_setup_command)
main()