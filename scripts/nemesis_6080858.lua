local base64 = require("neverlose/base64")
local clipboard = require("neverlose/clipboard")

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

local lua_enable = ui.sidebar(gradient_rgb(234, 147, 190, 255, "nemesis"))

--Referneces
local ref = {
    pitch = ui.find("Aimbot", "Anti Aim", "Angles", "Pitch"),
    yaw = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw"),
    yawbase = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Base"),
    yaw2 = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Offset"),
    yawjitter = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw Modifier"),
    yawjitterslider = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw Modifier", "Offset"),
    bodyyawenable = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw"),
    fakelimitleft = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Left Limit"),
    fakelimitright = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Right Limit"),
    bodyyawoptions = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Options"),
    fsbodyyaw = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Freestanding"),
    SlowMotion = ui.find("Aimbot", "Anti Aim", "Misc", "Slow Walk"),
    LegMovement = ui.find("Aimbot", "Anti Aim", "Misc", "Leg Movement"),
    HideShot = ui.find("Aimbot", "Ragebot", "Main", "Hide Shots"),
    DoubleTap = ui.find("Aimbot", "Ragebot", "Main", "Double Tap"),
    lagopt = ui.find("Aimbot", "Ragebot", "Main", "Double Tap", "Lag Options")
}

local antiaim = ui.create("\aEA93BEFF♯ \aFFFFFFFFaa", "Anti-Aimbot angles")
local antiaimbuilder = ui.create("\aEA93BEFF♯ \aFFFFFFFFaa","Builder")
local visuals = ui.create("\aEA93BEFF♯ \aFFFFFFFFvis \aEA93BEFF♯", "Visuals")
local miscellaneous = ui.create("\aFFFFFFFFmisc \aEA93BEFF♯", "Miscellaneous")

local menu = {
    ["aa"] = {
        EnableAA = true,
        defensive = antiaim:combo("⋇ \aEA93BEFFdefensive", {"-", "enabled"}, 0),
        antiaim_state = antiaim:combo("⋇ \aEA93BEFFanti-aim", {"-", "enabled"}, 0),
        current_state_select = antiaimbuilder:combo("\n", {"stand", "move", "slowwalk", "air", "duck", "airduck", "fakelag"}, 0),
    },
    ["vis"] = {
        EnableVis = true,
        mainclr = visuals:color_picker("⋇ \aEA93BEFFmain colour", color(234, 147, 190)),
        watermark = visuals:combo("⋇ \aEA93BEFFwatermark", {"-", "enabled"}, 0),
        indicators = visuals:selectable("⋇ \aEA93BEFFindicators", {"-", "minimum damage", "lag compensation"}, 0),
    },
    ["misc"] = {
        EnableSetts = true,
        shittalk = miscellaneous:combo("⋇ \aEA93BEFFchat spammer", {"-", "enabled"}, 0),
        hitlogs = miscellaneous:combo("⋇ \aEA93BEFFshot logger", {"-", "enabled"}, 0),
        animbrk = miscellaneous:selectable("⋇ \aEA93BEFFanimation breaker", {"-", "air", "ground", "0 pitch"}, 0),
        animbrkair = miscellaneous:combo("      ⋇ \aEA93BEFFair options", {"-", "modern"}, 0),
        animbrkground = miscellaneous:combo("      ⋇ \aEA93BEFFground options", {"-", "modern"}, 0),
    }
}

--current_state_select Function
local flags = {
    FL_ONGROUND = bit.lshift(1, 0);
    FL_DUCKING = bit.lshift(1, 1);
}

--AA Builder
local Builder = {}

local state_vars = {
    player_states = {"stand", "move", "slowwalk", "air", "duck", "airduck", "fakelag"},

    state_int = {["stand"] = 1, ["move"] = 2, ["slowwalk"] = 3, ["air"] = 4, ["duck"] = 5, ["airduck"] = 6,  ["fakelag"] = 7},

    short_player_states = {"S", "M", "SW", "A", "D", "AD", "FL"},

    player_state_holder = 1
}

for i=1, 7 do
    Builder[i] = {
        --Main
        benable = antiaimbuilder:switch("user-state"..gradient_rgb(234, 147, 190, 255, " ")..""..state_vars.player_states[i], false),
        pitch = antiaimbuilder:combo(gradient_rgb(234, 147, 190, 255, "pitch").." ⋇ \a0000000"..state_vars.player_states[i], "down", "meta"),
        yaw = antiaimbuilder:combo(gradient_rgb(234, 147, 190, 255, "yaw").." ⋇ \a0000000"..state_vars.player_states[i], "backward", "meta"),
        yawleft = antiaimbuilder:slider(gradient_rgb(234, 147, 190, 255, "left").." ⋇ \a0000000"..state_vars.player_states[i], -180, 180, 0, 1),
        yawright = antiaimbuilder:slider(gradient_rgb(234, 147, 190, 255, "right").." ⋇ \a0000000"..state_vars.player_states[i], -180, 180, 0, 1),
        yawjitter = antiaimbuilder:combo(gradient_rgb(234, 147, 190, 255, "jitter").." ⋇ \a0000000"..state_vars.player_states[i], {"disabled", "center", "spin"}, 0),
        yawjitterslider = antiaimbuilder:slider("\n \a0000000"..state_vars.player_states[i], -180, 180, 0, 1),
        bodyoptions = antiaimbuilder:selectable(gradient_rgb(234, 147, 190, 255, "body").." ⋇ \a0000000"..state_vars.player_states[i], {"jitter"}, 0),
    }
end

local cfunc = function(x) if x == nil then return 0 end x = (x % 360 + 360) % 360 return x > 180 and x - 360 or x end

events.createmove:set(function(c)
	local local_player = entity.get_local_player()

	if (bit.band(local_player["m_fFlags"], flags.FL_ONGROUND) ~= 1 and not ref.DoubleTap:get() and not ref.HideShot:get()) then
		state_vars.player_state_holder = 7
	elseif (bit.band(local_player["m_fFlags"], flags.FL_DUCKING) ~= 0 and bit.band(local_player["m_fFlags"], flags.FL_ONGROUND) == 1) then
		state_vars.player_state_holder = 5
	elseif (bit.band(local_player["m_fFlags"], flags.FL_ONGROUND) ~= 1 and bit.band(local_player["m_fFlags"], flags.FL_DUCKING) ~= 0) then
		state_vars.player_state_holder = 6
	elseif (bit.band(local_player["m_fFlags"], flags.FL_ONGROUND) ~= 1) then
		state_vars.player_state_holder = 4
	elseif (bit.band(local_player["m_fFlags"], flags.FL_ONGROUND) == 1) and ref.SlowMotion:get() then
		state_vars.player_state_holder = 3
	elseif (bit.band(local_player["m_fFlags"], flags.FL_ONGROUND) == 1 and local_player.m_vecVelocity:length2d() <= 2) then
		state_vars.player_state_holder = 1
	elseif not (bit.band(local_player["m_fFlags"], flags.FL_ONGROUND) == 1 and local_player.m_vecVelocity:length2d() <= 2) then
		state_vars.player_state_holder = 2
	end
    
    local bodyyaw = local_player.m_flPoseParameter[11] * 120 - 60
	local side = bodyyaw > 0 and 1 or -1

    local pitchside = {[1] = "Down", [2] = "Fake Up"}
    local randomyaw = utils.random_int(69,169)

    if menu["aa"].EnableAA == true and menu["aa"].antiaim_state:get() == "enabled" then
        ref.yawbase:override("At Target")
        ActiveState = state_vars.state_int[menu["aa"].current_state_select:get()]
        if Builder[state_vars.player_state_holder].benable:get() then

            if Builder[state_vars.player_state_holder].pitch:get() == "meta" then
                ref.pitch:override(pitchside[cfunc((globals.tickcount % 6 < 3 and 1 or 2))])
            else
                ref.pitch:override(Builder[state_vars.player_state_holder].pitch:get())
            end

            if Builder[state_vars.player_state_holder].yaw:get() == "meta" then
                ref.yaw2:override(cfunc((globals.tickcount % 6 < 3 and randomyaw or -randomyaw)))
                ref.yaw:override("backward")
            else
                if c.choked_commands == 0 then
                    ref.yaw2:override(side == 1 and Builder[state_vars.player_state_holder].yawleft:get() or Builder[state_vars.player_state_holder].yawright:get())
                end
            end

            ref.yaw:override(Builder[state_vars.player_state_holder].yaw:get())
            ref.yawjitter:override(Builder[state_vars.player_state_holder].yawjitter:get())
            ref.yawjitterslider:override(Builder[state_vars.player_state_holder].yawjitterslider:get())
            ref.bodyyawenable:override(true)
            ref.fakelimitleft:override(60)
            ref.fakelimitright:override(60)
            ref.bodyyawoptions:override(Builder[state_vars.player_state_holder].bodyoptions:get())
            ref.fsbodyyaw:override("Off")
        else
            if not Builder[state_vars.player_state_holder].benable:get() then return 
        end
     end
  end
end)

local function does_contain(tbl, val)
    for i=1, #tbl do
        if tbl[i] == val then
            return true
        end
    end
    return false
end

local ground_ticks = 0

events.post_update_clientside_animation:set(function()
    local local_player = entity.get_local_player()
	
	local user_ground = bit.band(local_player["m_fFlags"], flags.FL_ONGROUND) == 1

	local lt = {[1] = "Default", [2] = "Sliding" , [3] = "Walking"}

	if local_player.m_hGroundEntity then
        ground_ticks = ground_ticks + 1
    else
        ground_ticks = 0
    end

	if does_contain(menu["misc"].animbrk:get(), "air") then
		if menu["misc"].animbrkair:get() == "modern" then
            local_player.m_flPoseParameter[6] = 1
		end
	end

	if does_contain(menu["misc"].animbrk:get(), "ground") then
		if menu["misc"].animbrkground:get() == "modern" then
			ref.LegMovement:set(lt[math.random(2,3)])
            local_player.m_flPoseParameter[math.random(0,1)] = math.random(0.1, 2)
		end
	end

	if does_contain(menu["misc"].animbrk:get(), "0 pitch") and ground_ticks > 5 and ground_ticks < 900 then
        local_player.m_flPoseParameter[12] = 0.5
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
	"𝕙𝕖𝕙𝕖𝕙𝕖, 𝕦 𝕘𝕣𝕒𝕓 𝕞𝕪 𝕗𝕒𝕝𝕝 𝕘𝕦𝕪𝕤 𝕔𝕙𝕒𝕣𝕒𝕔𝕥𝕖 ",
	"𝕙𝕖𝕙𝕖𝕙𝕖, 𝕦 𝕘𝕣𝕒𝕓 𝕞𝕪 𝕗𝕒𝕝𝕝 𝕘𝕦𝕪𝕤 𝕔𝕙𝕒𝕣𝕒𝕔𝕥𝕖 ",
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
	"*DEAD* ☂ nossa vei : i need a good wanheda.red cfg",
    "LACHKICK U GOT OWNED BY FREE NEMESIS.LAT LUA FOR NEVERLOSE",
    "LACHKICK U GOT OWNED BY FREE NEMESIS.LAT LUA FOR NEVERLOSE",
    "LACHKICK U GOT OWNED BY FREE NEMESIS.LAT LUA FOR NEVERLOSE",
    "LACHKICK U GOT OWNED BY FREE NEMESIS.LAT LUA FOR NEVERLOSE",
    "LACHKICK U GOT OWNED BY FREE NEMESIS.LAT LUA FOR NEVERLOSE",
    "nemesis.lat/lua just the best.",
    "nemesis.lat/lua just the best.",
    "nemesis.lat/lua just the best."
}

events.player_death:set(function(e)
    local me = entity.get_local_player()
    local attacker = entity.get(e.attacker, true)
    local target = entity.get(e.userid, true)

    if me == attacker and target ~= me then
        if menu["misc"].shittalk:get() == "enabled" then
            local msg = string.format('say "%s"', tostring(killphrases[math.random(1, #killphrases)]))
            utils.console_exec(msg)
        end
    end 
end)

local hitgroup_names = {
    "generic", "head", "chest", "stomach", "left arm", "right arm", "left leg", "right leg", "neck", "unknown"
}

events.aim_ack:set(function(event)
	local output = {}
	local actualhc = math.floor(event.hitchance)

    if menu["misc"].hitlogs:get() == "enabled" then
        if event.state == nil then
            output = string.format("HIT / %s / %s / %s(%s) / [aim=%s bt=%s mismatch=%s]", event.target:get_name(), hitgroup_names[event.hitgroup + 1], event.damage, event.wanted_damage, hitgroup_names[event.wanted_hitgroup + 1], event.backtrack, (event.damage >= event.wanted_damage) and "FALSE" or "TRUE")
        else
            output = string.format("MISS / %s / %s / %s / %s / [aim=%s bt=%s]", event.target:get_name(), hitgroup_names[event.wanted_hitgroup + 1], event.wanted_damage, event.state, hitgroup_names[event.wanted_hitgroup + 1], event.backtrack)
        end
    end

	print_raw(output)
    print_dev(output)
end)

events.createmove:set(function(c)
    if menu["aa"].defensive:get() == "enabled" then
        ref.lagopt:set("Always On")
    end
end)

local function processColor(mainclr)
    local r, g, b = menu["vis"].mainclr:get()
    return r, g, b
end

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

local function text_fade(x, y, s, text)
    local texxt = ''
    local curtime = globals.curtime
    local colour = processColor(mainclr)
    for i = 0, #text do
        local color = rgba_to_hex(
            slide_animation(234, 255, clamp(math.cos(1 * s * curtime / 4 + i * 10  / 15), 0, 1)),
            slide_animation(147, 255, clamp(math.cos(1 * s * curtime / 4 + i * 10  / 15), 0, 1)),
            slide_animation(190, 255, clamp(math.cos(1 * s * curtime / 4 + i * 10  / 15), 0, 1)),
            255
        ) 
        texxt = texxt .. '\a' .. color .. text:sub(i, i) 
    end
    render.text(4, vector(x, y), color(255, 255, 255, 255), nil, texxt)
end

events.render:set(function()
    local local_player = entity.get_local_player()
    local screen_size = render.screen_size()
    
    if menu["vis"].watermark:get() == "enabled" then
        text_fade(screen_size.x / 2 + 860, screen_size.y / 2, 15, "N  E  M  E  S  I  S")
    end

    if not local_player:is_alive() then return end

    local binds = ui.get_binds()
    
    for i in pairs(binds) do
        if binds[i].name == "Min. Damage" then
            if binds[i].active then
                if does_contain(menu["vis"].indicators:get(), "minimum damage") then
                local dmgvalue = binds[i].value
                render.shadow(vector(screen_size.x / 2 + 13, screen_size.y / 2 - 3), vector(screen_size.x / 2 + 3, screen_size.y / 2 - 18), color(255, 196, 240, 255), 20, 1, 1)
                render.shadow(vector(screen_size.x / 2 + 13, screen_size.y / 2 - 3), vector(screen_size.x / 2 + 3, screen_size.y / 2 - 18), color(255, 196, 240, 255), 20, 1, 1)
                render.shadow(vector(screen_size.x / 2 + 13, screen_size.y / 2 - 3), vector(screen_size.x / 2 + 3, screen_size.y / 2 - 18), color(255, 196, 240, 255), 20, 1, 1)
                render.text(4, vector(screen_size.x / 2 + 5, screen_size.y / 2 - 17), color(255, 255, 255, 255), nil, dmgvalue)
            end
        end
    end
end

    if (bit.band(local_player["m_fFlags"], flags.FL_ONGROUND) ~= 1 and does_contain(menu["vis"].indicators:get(), "lag compensation")) then
        render.text(4, vector(screen_size.x / 2 - 15, screen_size.y / 2 - 17), color(160, 202, 43, 255), nil, "LC")
    end
end)

events.render:set(function()
    if menu["aa"].EnableAA == true and menu["aa"].antiaim_state:get() == "enabled" then
        menu["aa"].current_state_select:visibility(true)
        for i=1, 7 do
            ActiveStateVisual = state_vars.state_int[menu["aa"].current_state_select:get()]
            Builder[i].benable:visibility(ActiveStateVisual == i)
            if Builder[i].benable:get() then
                Builder[i].pitch:visibility(ActiveStateVisual == i)
                Builder[i].yaw:visibility(ActiveStateVisual == i)
                Builder[i].yawleft:visibility(ActiveStateVisual == i)
                Builder[i].yawright:visibility(ActiveStateVisual == i)
                Builder[i].yawjitter:visibility(ActiveStateVisual == i)
                Builder[i].yawjitterslider:visibility(ActiveStateVisual == i and Builder[ActiveStateVisual].yawjitter ~= "disabled")
                Builder[i].bodyoptions:visibility(ActiveStateVisual == i)
            else
                Builder[i].pitch:visibility(false)
                Builder[i].yaw:visibility(false)
                Builder[i].yawleft:visibility(false)
                Builder[i].yawright:visibility(false)
                Builder[i].yawjitter:visibility(false)
                Builder[i].yawjitterslider:visibility(false)
                Builder[i].bodyoptions:visibility(false)
            end
        end
    else
        menu["aa"].current_state_select:visibility(false)
        for i=1, 7 do
            Builder[i].benable:visibility(false)
            Builder[i].pitch:visibility(false)
            Builder[i].yaw:visibility(false)
            Builder[i].yawleft:visibility(false)
            Builder[i].yawright:visibility(false)
            Builder[i].yawjitter:visibility(false)
            Builder[i].yawjitterslider:visibility(false)
            Builder[i].bodyoptions:visibility(false)
        end
    end
end)

local function system_export()
	local export = {}
	for key, value in pairs(state_vars.short_player_states) do
		export[tostring(value)] = {}
		for k, v in pairs(Builder[key]) do
			export[value][k] = v:get()
		end
	end
	local exported = json.stringify(export)
	clipboard.set(exported)
    print("Config Exported.")
end

local function system_import()
	local imported = json.parse(clipboard.get())
	for key, value in pairs(state_vars.short_player_states) do
		for k, v in pairs(Builder[key]) do
			local current = imported[value][k]
			if (current ~= nil) then
				v:set(current)
			end
		end
	end
    print("Config Imported.")
end

local button_import = antiaim:button("import", system_import)
local button_export = antiaim:button("export", system_export)