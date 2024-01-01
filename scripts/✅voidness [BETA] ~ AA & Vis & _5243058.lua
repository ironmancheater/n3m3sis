local base64 = require("neverlose/base64")
local clipboard = require("neverlose/clipboard")
local http = require("neverlose/http")

local lastupdate = "20.11.22"
local username = common.get_username()
local version = "beta"

--SideBar
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

local text = gradient_text(255,196,240,255,255,232,242,255, "void")
local text1 = gradient_text(255,232,242,255,255,196,240,255, "ness")

local penis = ui.sidebar(text.. "" .. text1, "star")

userek = gradient_text(255,196,240,255,255,232,242,255, "" .. username)
werska = gradient_text(255,196,240,255,255,232,242,255, "" .. version)
apdejt = gradient_text(255,196,240,255,255,232,242,255, "" .. lastupdate)
common.add_notify(text .. "" .. text1, "\aFFFFFFC9user: " .. userek .. " \aFFFFFFC9| ver: " .. werska .. " \aFFFFFFC9| upd: " .. apdejt)

--Referneces
local ref = {
    Pitch = ui.find("Aimbot", "Anti Aim", "Angles", "Pitch"),
    Yaw = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw"),
    YawBase = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Base"),
    YawOffset = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Offset"),
    YawMod = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw Modifier"),
    YawModOffset = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw Modifier", "Offset"),
    BodyYawEnable = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw"),
    Inverter = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Inverter"),
    FakeLimitLeft = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Left Limit"),
    FakeLimitRight = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Right Limit"),
    BodyYawOptions = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Options"),
    FreestandingBodyYaw = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Freestanding"),
    OnShot = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "On Shot"),
    LBYMode = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "LBY Mode"),
    FreestandingEnable = ui.find("Aimbot", "Anti Aim", "Angles", "Freestanding"),
    DisableYawMod = ui.find("Aimbot", "Anti Aim", "Angles", "Freestanding", "Disable Yaw Modifiers"),
    BodyFreestanding = ui.find("Aimbot", "Anti Aim", "Angles", "Freestanding", "Body Freestanding"),
    ExtendedAngles = ui.find("Aimbot", "Anti Aim", "Angles", "Extended Angles"),
    ExtendedPitch = ui.find("Aimbot", "Anti Aim", "Angles", "Extended Angles", "Extended Pitch"),
    ExtendedRoll = ui.find("Aimbot", "Anti Aim", "Angles", "Extended Angles", "Extended Roll"),
    FakeLag = ui.find("Aimbot", "Anti Aim", "Fake Lag", "Enabled"),
    FakeLagLimit = ui.find("Aimbot", "Anti Aim", "Fake Lag", "Limit"),
    FakeLagRandom = ui.find("Aimbot", "Anti Aim", "Fake Lag", "Variability"),
    FakeDuck = ui.find("Aimbot", "Anti Aim", "Misc", "Fake Duck"),
    SlowMotion = ui.find("Aimbot", "Anti Aim", "Misc", "Slow Walk"),
    LegMovement = ui.find("Aimbot", "Anti Aim", "Misc", "Leg Movement"),
    QuickPeek = ui.find("Aimbot", "Ragebot", "Main", "Peek Assist"),
    HideShot = ui.find("Aimbot", "Ragebot", "Main", "Hide Shots"),
    DoubleTap = ui.find("Aimbot", "Ragebot", "Main", "Double Tap"),
    ClanTag = ui.find("Miscellaneous", "Main", "In-Game", "Clan Tag")
}

--FFI HELP
local ffihelp = {
browseropen = function(link)
local stconnect = panorama.SteamOverlayAPI
local wwwopen = stconnect.OpenExternalBrowserURL
wwwopen(link)
end
}

--Menu Elements
local function infosklua()
	ffihelp.browseropen('https://discord.gg/Zy67pDdSAS')
end

local function ytlinkos()
	ffihelp.browseropen('https://www.youtube.com/channel/UCave2RIwg7E1fjvgSM1Ul0A')
end

local function betalinkos()
	ffihelp.browseropen('https://en.neverlose.cc/market/item?id=xoUK9D')
end

--Weryfka
local encoded1 = base64.encode(username)
local encoded2 = base64.encode(version)
local encoded3 = base64.encode(lastupdate)

local function Discordli()
    print_dev("Check console!")
    common.add_notify(text .. "" .. text1, "Check Console!")
    print("Paste this on ticket chat: ".. encoded1 .."|".. encoded2 .."|".. encoded3)
end

--\afeffffFF BIALY
--\aFFFFFFC9 SZARY

VoidnessMainclr = gradient_text(255,196,240,255,255,232,242,255, "Main")
VoidnessAntiAimclr = gradient_text(255,196,240,255,255,232,242,255, "Anti-Aim")
VoidnessSettsclr = gradient_text(255,196,240,255,255,232,242,255, "Settings")
VoidnessMainoico = ui.get_icon("home")
VoidnessMainico = ui.get_icon("vihara")
VoidnessDiscordl = ui.get_icon("user-plus")
RoleDiscordico = ui.get_icon("paperclip")
VoidnessRecomsico = ui.get_icon("wifi")
VoidnessAntiAimico = ui.get_icon("shield-alt")
VoidnessAntiAimico1 = ui.get_icon("user-shield")
VoidnessAntiAimico2 = ui.get_icon("vector-square")
VoidnessAntiAimico3 = ui.get_icon("arrows-alt")
VoidnessSettsico = ui.get_icon("cogs")
VoidnessSetts1ico = ui.get_icon("paint-brush")
VoidnessSetts2ico = ui.get_icon("wrench")
VoidnessSetts3ico = ui.get_icon("tools")

local VoidnessIco = ui.create(VoidnessMainoico .. " General", "")
local VoidnessMain = ui.create(VoidnessMainoico .. " General", VoidnessMainico .. " Main")
local VoidnessRecoms = ui.create(VoidnessMainoico .. " General", VoidnessRecomsico .. " Recommendations")
local VoidnessAntiAim = ui.create(VoidnessAntiAimico .. " Anti-Aim",VoidnessAntiAimico1 .. " Anti-Aim")
local VoidnessAntiAimBd = ui.create(VoidnessAntiAimico .. " Anti-Aim",VoidnessAntiAimico2 .. " Builder")
local VoidnessAntiAimMa = ui.create(VoidnessAntiAimico .. " Anti-Aim",VoidnessAntiAimico3 .. " Manual")
local VoidnessSetts = ui.create(VoidnessSettsico .. " Settings",VoidnessSetts1ico .. " Visuals")
local VoidnessSettsMs = ui.create(VoidnessSettsico .. " Settings",VoidnessSetts2ico .. " Miscellaneous")
local VoidnessSettsRb = ui.create(VoidnessSettsico .. " Settings",VoidnessSetts3ico .. " Ragebot")

MainNameclr = gradient_text(255,196,240,255,255,232,242,255, username .."")
Welcomingclr = gradient_text(255,196,240,255,255,232,242,255, "20.11.22")
Authorclr = gradient_text(255,196,240,255,255,232,242,255, "Zy67pDdSAS")
ManualLeftclr = gradient_text(255,196,240,255,255,232,242,255, "[Left]")
ManualRightclr = gradient_text(255,196,240,255,255,232,242,255, "[Right]")
ManualBackclr = gradient_text(255,196,240,255,255,232,242,255, "[Back]")
presetsclr = gradient_text(255,196,240,255,255,232,242,255, "presets")
ClanTagclr = gradient_text(255,196,240,255,255,232,242,255, "spammer")
RoleDiscord1clr = gradient_text(255,196,240,255,255,232,242,255, "Discord Role GUIDE")

local menu = {
    ["Main"] = {
        Ico = VoidnessIco:texture(render.load_image(network.get("https://cdn.discordapp.com/attachments/943215203603066955/1034452306319659028/yuttyuyut.png"), vector(250, 250)), vector(250, 250), color(255, 255, 255, 255), 'f'),
        MainName = VoidnessMain:label("Welcome back, " .. MainNameclr),
        Lastupdate = VoidnessMain:label("Last update: " .. Welcomingclr ..""),
        Discordl = VoidnessMain:button(VoidnessDiscordl.. " Join our Discord Server", infosklua),
        RoleDiscord = VoidnessMain:button(RoleDiscordico.. " Get Role in Discord Server", Discordli),
        RoleDiscord1 = VoidnessMain:label("                      \aFFFFFFFF- " .. RoleDiscord1clr .. " \aFFFFFFFF-"),
        RoleDiscord2 = VoidnessMain:label("\aFFFFFFFF1. Join our discord server."),
        RoleDiscord3 = VoidnessMain:label("\aFFFFFFFF2. Get your token by pressing the second button."),
        RoleDiscord4 = VoidnessMain:label("\aFFFFFFFF3. Create a new ticket"),
        RoleDiscord5 = VoidnessMain:label("\aFFFFFFFF4. Paste ur token on chat and tag @weke"),
        Recommendations = VoidnessRecoms:button("YouTube Channel", ytlinkos),
        Recommendations1 = VoidnessRecoms:button("Beta Version", betalinkos)
    },
    ["AntiAim"] = {
        EnableAA = true,
        AntiAimSelector = VoidnessAntiAim:combo("/> Mode", {"Jitter", "Experimental", "Builder"}, 0),
        ManualBack = VoidnessAntiAimMa:switch("/> Manual Anti-Aimbot " .. ManualBackclr, false),
        ManualLeft = VoidnessAntiAimMa:switch("/> Manual Anti-Aimbot " .. ManualLeftclr, false),
        ManualRight = VoidnessAntiAimMa:switch("/> Manual Anti-Aimbot " .. ManualRightclr, false),
        PlayerState = VoidnessAntiAimBd:combo("States", {"None", "Crouching", "Standing", "Moving", "In-Air", "In-Air Crouch", "Slow Walking"}, 0),
        PlayerStateLb = VoidnessAntiAimBd:label("Choose Anti-Aim Builder to continue!")
    },
    ["Setts"] = {
        EnableSetts = true,
        ClanTag = VoidnessSettsMs:switch("/> Clan Tag", false),
        Indicators = VoidnessSetts:switch("/> Crosshair Indicators", false),
        IndicatorSelection = VoidnessSetts:combo("indicators style", {"My favourite", "Modern", "Old"}, 0),
        Watermark = VoidnessSetts:switch("/> Watermark", false),
        Smallpanel = VoidnessSetts:switch("/> Small Panel", false),
        SmallpanelShadow = VoidnessSetts:switch("/> Gradient?", false),
        LegBreaker = VoidnessSettsMs:switch("/> Leg Anim. Breaker", false)
    }
}

--PlayerState Function
local flags = {
    FL_ONGROUND = bit.lshift(1, 0);
    FL_DUCKING = bit.lshift(1, 1);
}

local getPlayerState = function()
    local localplayer = entity.get_local_player()

    if localplayer == nil then
        return
    end

    local getVelocity = localplayer.m_vecVelocity:length2d()
    local getFlags = localplayer["m_fFlags"]
    local isSlowMotion = ref.SlowMotion:get()

    if (bit.band(getFlags, flags.FL_ONGROUND) == 1) and isSlowMotion then
        return "slowwalk"
    elseif (bit.band(getFlags, flags.FL_DUCKING ) ~= 0 and bit.band(getFlags, flags.FL_ONGROUND) == 1) then
        return "crouching"
    elseif (bit.band(getFlags, flags.FL_ONGROUND) == 1 and getVelocity <= 2) then
        return "standing"
    elseif (bit.band(getFlags, flags.FL_ONGROUND) == 1 and getVelocity >= 2) then
        return "moving"
    elseif (bit.band(getFlags, flags.FL_ONGROUND) ~= 1) and common.is_button_down(0x11) then
        return "in-air [c]"
    elseif (bit.band(getFlags, flags.FL_ONGROUND) ~= 1) then
        return "in-air"
    end
end

--AA Builder
local Builder = {}
local States = {"Crouching", "Standing", "Moving", "In-Air", "In-Air Crouch", "Slow Walking"}
local ConvertStates = {["Crouching"] = 1, ["Standing"] = 2, ["Moving"] = 3, ["In-Air"] = 4, ["In-Air Crouch"] = 5, ["Slow Walking"] = 6}

local StatesBuilder = function()
    if getPlayerState() == "crouching" then
        ActiveStateFunction = 1
    elseif getPlayerState() == "standing" then
        ActiveStateFunction = 2
    elseif getPlayerState() == "moving" then
        ActiveStateFunction = 3
    elseif getPlayerState() == "in-air [c]" then
        ActiveStateFunction = 5
    elseif getPlayerState() == "in-air" then
        ActiveStateFunction = 4
    elseif getPlayerState() == "slowwalk" then
        ActiveStateFunction = 6
    end
end

for i=1, 6 do
    Builder[i] = {
        --Main
        Enable = VoidnessAntiAimBd:switch("Enable - " .. States[i] .. " State Override", false),
        YawLeft = VoidnessAntiAimBd:slider("Yaw Left\n - " .. States[i], -180, 180, 0, 1),
        YawRight = VoidnessAntiAimBd:slider("Yaw Right\n - " .. States[i], -180, 180, 0, 1),
        YawMod = VoidnessAntiAimBd:combo("Yaw Modifier\n - " .. States[i], {"Disabled", "Center", "Offset", "Random", "Spin"}, 0),
        YawModOffset = VoidnessAntiAimBd:slider("Modifier Degree\n - " .. States[i], -180, 180, 0, 1),
        --BodyYaw
        EnableBodyYaw = VoidnessAntiAimBd:switch("Enable Body Yaw\n - " .. States[i], false),
        FakeYawLimitLeft = VoidnessAntiAimBd:slider("Fake Yaw Limit Left\n - " .. States[i], 0, 60, 60, 1),
        FakeYawLimitRight = VoidnessAntiAimBd:slider("Fake Yaw Limit Right\n - " .. States[i], 0, 60, 60, 1),
        FakeOptions = VoidnessAntiAimBd:selectable("Fake Options\n - " .. States[i], {"Avoid Overlap", "Jitter", "Randomize Jitter", "Anti-Brute"}, 0),
        FreeStandingDesync = VoidnessAntiAimBd:combo("Freestanding\n - " .. States[i], {"Off", "Peek Fake", "Peek Real"}, 0),
        DesyncOnshot = VoidnessAntiAimBd:combo("On Shot\n - ".. States[i],  {"Disabled", "Opposite", "Freestanding", "Switch"}, 0),
        LBYMode = VoidnessAntiAimBd:combo("LBY Mode\n - " .. States[i], {"Disabled", "Opposite", "Sway"}, 0),
    }
end

--Values
local LegMovement = {
    [1] = "Default",
    [2] = "Sliding",
    [3] = "Walking"
}

local SideSpam = {
    [1] = 60,
    [2] = 0
}

local BodySpam = {
    [1] = false,
    [2] = true
}

--AA Presets
events.createmove:set(function(c)
    local localplayer = entity.get_local_player()

    if localplayer == nil then
        return
    end
    
    local bodyyaw = localplayer.m_flPoseParameter[11] * 120 - 60
	local side = bodyyaw > 0 and 1 or -1

    if menu["AntiAim"].EnableAA == true and menu["AntiAim"].AntiAimSelector:get() == "Jitter" then
        if getPlayerState() == "standing" then
            ref.Pitch:set("Down")
            ref.Yaw:set("Backward")
            ref.YawBase:set("At Target")
            ref.YawOffset:set(side == 1 and -3 or 5)
            ref.YawMod:set("Center")
            ref.YawModOffset:set(-51)
            ref.BodyYawEnable:set(true)
            ref.FakeLimitLeft:set(60)
            ref.FakeLimitRight:set(60)
            ref.BodyYawOptions:set("Jitter", "Anti Bruteforce")
            ref.OnShot:set("Default")
            ref.LBYMode:set("Opposite")
        elseif getPlayerState() == "moving" then
            ref.Pitch:set("Down")
            ref.Yaw:set("Backward")
            ref.YawBase:set("At Target")
            ref.YawOffset:set(side == 1 and -6 or 7)
            ref.YawMod:set("Center")
            ref.YawModOffset:set(-57)
            ref.BodyYawEnable:set(BodySpam[utils.random_int(1,2)])
            ref.FakeLimitLeft:set(60)
            ref.FakeLimitRight:set(60)
            ref.BodyYawOptions:set("Jitter", "Anti Bruteforce")
            ref.OnShot:set("Default")
            ref.LBYMode:set("Opposite")
        elseif getPlayerState() == "crouching" then
            ref.Pitch:set("Down")
            ref.Yaw:set("Backward")
            ref.YawBase:set("At Target")
            ref.YawOffset:set(side == 1 and -6 or 7)
            ref.YawMod:set("Center")
            ref.YawModOffset:set(-62)
            ref.BodyYawEnable:set(BodySpam[utils.random_int(1,2)])
            ref.FakeLimitLeft:set(60)
            ref.FakeLimitRight:set(60)
            ref.BodyYawOptions:set("Jitter")
            ref.OnShot:set("Default")
            ref.LBYMode:set("Opposite")
        elseif getPlayerState() == "in-air" then
            ref.Pitch:set("Down")
            ref.Yaw:set("Backward")
            ref.YawBase:set("At Target")
            ref.YawOffset:set(side == 1 and -1 or 6)
            ref.YawMod:set("Center")
            ref.YawModOffset:set(-37)
            ref.BodyYawEnable:set(BodySpam[utils.random_int(1,2)])
            ref.FakeLimitLeft:set(60)
            ref.FakeLimitRight:set(60)
            ref.BodyYawOptions:set("Jitter", "Anti Bruteforce")
            ref.OnShot:set("Default")
            ref.LBYMode:set("Opposite")
        elseif getPlayerState() == "in-air [c]" then
            ref.Pitch:set("Down")
            ref.Yaw:set("Backward")
            ref.YawBase:set("At Target")
            ref.YawOffset:set(side == 1 and -1 or 6)
            ref.YawMod:set("Center")
            ref.YawModOffset:set(-37)
            ref.BodyYawEnable:set(BodySpam[utils.random_int(1,2)])
            ref.FakeLimitLeft:set(60)
            ref.FakeLimitRight:set(60)
            ref.BodyYawOptions:set("Jitter", "Anti Bruteforce")
            ref.OnShot:set("Default")
            ref.LBYMode:set("Opposite")
        elseif getPlayerState() == "slowwalk" then
            ref.Pitch:set("Down")
            ref.Yaw:set("Backward")
            ref.YawBase:set("At Target")
            ref.YawOffset:set(side == 1 and -0 or 8)
            ref.YawMod:set("Center")
            ref.YawModOffset:set(-54)
            ref.BodyYawEnable:set(BodySpam[utils.random_int(1,2)])
            ref.FakeLimitLeft:set(60)
            ref.FakeLimitRight:set(60)
            ref.BodyYawOptions:set("Jitter", "Anti Bruteforce")
            ref.OnShot:set("Default")
            ref.LBYMode:set("Opposite")
        end
    elseif menu["AntiAim"].EnableAA == true and menu["AntiAim"].AntiAimSelector:get() == "Experimental" then
        ref.Pitch:set("Down")
        ref.Yaw:set("Backward")
        ref.YawBase:set("At Target")
        if getPlayerState() == "standing" or "moving" or "crouching" or "slowwalk" or "in-air" or "in-air [c]" then
            ref.YawOffset:set(0)
            ref.YawMod:set("Disabled")
            ref.YawModOffset:set(0)
            ref.BodyYawEnable:set(true)
            ref.FakeLimitLeft:set(SideSpam[utils.random_int(1,2)])
            ref.FakeLimitRight:set(SideSpam[utils.random_int(1,2)])
            ref.BodyYawOptions:set("Avoid Overlap", "Anti Bruteforce")
            ref.OnShot:set("Freestanding")
            ref.LBYMode:set("Opposite")
        end
    elseif menu["AntiAim"].EnableAA == true and menu["AntiAim"].AntiAimSelector:get() == "Builder" then
        ref.Pitch:set("Down")
        ref.Yaw:set("Backward")
        ref.YawBase:set("At Target")
        ActiveState = ConvertStates[menu["AntiAim"].PlayerState:get()]
        if Builder[ActiveStateFunction].Enable:get() then
            if c.chokedcommands ~= 0 then
            else
                ref.YawOffset:set(side == 1 and Builder[ActiveStateFunction].YawLeft:get() or Builder[ActiveStateFunction].YawRight:get())
            end
            ref.YawMod:set(Builder[ActiveStateFunction].YawMod:get())
            ref.YawModOffset:set(Builder[ActiveStateFunction].YawModOffset:get())
            ref.BodyYawEnable:set(Builder[ActiveStateFunction].EnableBodyYaw:get())
            ref.FakeLimitLeft:set(Builder[ActiveStateFunction].FakeYawLimitLeft:get())
            ref.FakeLimitRight:set(Builder[ActiveStateFunction].FakeYawLimitRight:get())
            ref.BodyYawOptions:set(Builder[ActiveStateFunction].FakeOptions:get())
            ref.FreestandingBodyYaw:set(Builder[ActiveStateFunction].FreeStandingDesync:get())
            ref.OnShot:set(Builder[ActiveStateFunction].DesyncOnshot:get())
            ref.LBYMode:set(Builder[ActiveStateFunction].LBYMode:get())
        elseif not Builder[ActiveStateFunction].Enable:get() then
            if getPlayerState() == "standing" or "moving" or "crouching" or "slowwalk" or "in-air" or "in-air [c]" then
            ref.Pitch:set("Down")
            ref.Yaw:set("Backward")
            ref.YawBase:set("At Target")
            ref.YawOffset:set(0)
            ref.YawMod:set("Disabled")
            ref.BodyYawEnable:set(false)
            end
        end
    end
    if menu["AntiAim"].EnableAA == true and menu["AntiAim"].ManualBack:get() then
        ref.YawOffset:set(0)
        ref.YawMod:set("Disabled")
        ref.YawModOffset:set(0)
        ref.BodyYawOptions:set("Anti Bruteforce")
        ref.LBYMode:set("Opposite")
        ref.FakeLimitLeft:set(60)
        ref.FakeLimitRight:set(60)
    end
    if menu["AntiAim"].EnableAA == true and menu["AntiAim"].ManualLeft:get() then
        ref.YawOffset:set(-90)
        ref.YawMod:set("Disabled")
        ref.YawModOffset:set(0)
        ref.BodyYawOptions:set("Anti Bruteforce")
        ref.LBYMode:set("Opposite")
        ref.FakeLimitLeft:set(60)
        ref.FakeLimitRight:set(60)
    end
    if menu["AntiAim"].EnableAA == true and menu["AntiAim"].ManualRight:get() then
        ref.YawOffset:set(90)
        ref.YawMod:set("Disabled")
        ref.YawModOffset:set(0)
        ref.BodyYawOptions:set("Anti Bruteforce")
        ref.LBYMode:set("Opposite")
        ref.FakeLimitLeft:set(60)
        ref.FakeLimitRight:set(60)
    end
    if menu["Setts"].LegBreaker:get() then
        ref.LegMovement:set(LegMovement[utils.random_int(2,3)])
    end
end)

--ClanTag
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

local clantag_prev
events.net_update_end:set(function()
    if ref.ClanTag:get() then 
        return 
    end

    local cur = math.floor(globals.tickcount / duration) % #clantags
    local clantag = clantags[cur+1]

    if menu["Setts"].ClanTag:get() then
        if clantag ~= clantag_prev then
            clantag_prev = clantag
            common.set_clan_tag(clantag)
        end
    end
end)

menu["Setts"].ClanTag:set_callback(function()
    common.set_clan_tag("\0")
end)

--Rendering Indicators
events.render:set(function()
    --Local PLayer Check
    local localplayer = entity.get_local_player()
    if localplayer == nil or not localplayer:is_alive() then return end
    --ScreenSize
    local screen_center = render.screen_size() / 2

    --Alpha Fade
    local realtime = globals.realtime % 3
    local alpha = math.floor(math.sin(realtime * 2) * (180 / 2 - 0) + 180 / 2) or 180
    
    --Body Yaw
    local bodyyaw = localplayer.m_flPoseParameter[11] * 120 - 60
    local side = bodyyaw > 0 and 1 or -1

    --Check Stuff
    local isDT = ref.DoubleTap:get()
    local isOS = ref.HideShot:get()
    local isQPA = ref.QuickPeek:get()
    local isFS = ref.FreestandingEnable:get()
    rendertextclr = gradient_text(255,196,240,255,255,232,242,255, "VOIDNESS")
    playerstateclr = gradient_text(255,196,240,255,255,232,242,255, " ")
    logoclr = gradient_text(255,196,240,255,255,232,242,255, "VN")
    tyldaclr = gradient_text(255,196,240,255,255,232,242,255, "~")
    logosclr = gradient_text(255,196,240,255,255,232,242,255, "VOID")
    logos1clr = gradient_text(255,232,242,255,255,196,240,255, "NESS")
    
    --Start
    if menu["Setts"].Indicators:get() and menu["Setts"].EnableSetts == true then
        if menu["Setts"].IndicatorSelection:get() == "Old" then
            render.text(2, vector(screen_center.x - 12, screen_center.y + 50), color(219, 181, 231, 255), "cd", "" .. rendertextclr)
            render.text(2, vector(screen_center.x + 16, screen_center.y + 50), color(255, 255, 255, alpha), "cd", "" .. version:upper())
            render.line(vector(screen_center.x - 33, screen_center.y + 57), vector(screen_center.x + 26, screen_center.y + 57), color(255,204,241,150))
            render.text(1, vector(screen_center.x, screen_center.y + 54), color(), "cd", ".")
            render.text(2, vector(screen_center.x - 2, screen_center.y + 65), color(255,255,255,255), "cd",playerstateclr .. getPlayerState():upper())
            
            if bodyyaw > 0 then
                render.line(vector(screen_center.x - 33, screen_center.y + 57), vector(screen_center.x, screen_center.y + 57), color(255,255,255,190))
            else
                render.line(vector(screen_center.x, screen_center.y + 57), vector(screen_center.x + 26, screen_center.y + 57), color(255,255,255,150))
            end
            if isDT then
                render.text(2, vector(screen_center.x - 16, screen_center.y + 75), color(255,255,255,255), "cd", "DT")
            else
                render.text(2, vector(screen_center.x - 16, screen_center.y + 75), color(255,255,255,100), "cd", "DT")
            end
            if isOS then
                render.text(2, vector(screen_center.x - 5, screen_center.y + 75), color(255,255,255,255), "cd", "OS")
            else
                render.text(2, vector(screen_center.x - 5, screen_center.y + 75), color(255,255,255,100), "cd", "OS")
            end
            if isQPA then
                render.text(2, vector(screen_center.x + 9, screen_center.y + 75), color(255,255,255,255), "cd", "QPA")
            else
                render.text(2, vector(screen_center.x + 9, screen_center.y + 75), color(255,255,255,100), "cd", "QPA")
            end
        end
        --TEST
        if menu["Setts"].IndicatorSelection:get() == "My favourite" then
            dtekclr = gradient_text(255,232,242,255,255,196,240,255, "DT")
            oshoclr = gradient_text(255,232,242,255,255,196,240,255, "OS")
            qpaclr = gradient_text(255,232,242,255,255,196,240,255, "FS")
            local os_y = 0
            local dt_y = 0
            local fs_y = 0
            if isOS then
                os_y = 10
            end
            if isDT then
                dt_y = 10
            end
            if isFS then
                fs_y = 10
            end
            render.shadow(vector(screen_center.x - 9, screen_center.y + 18), vector(screen_center.x + 11, screen_center.y + 18), color(255, 196, 240, 165), 45, 1, 1)
            render.text(2, vector(screen_center.x + 2, screen_center.y + 18), color(219, 181, 231, 55), "cd", "VOIDNESS")
            if bodyyaw > 0 then
                render.text(2, vector(screen_center.x + 2, screen_center.y + 18), color(255, 255, 255, 205), "cd", "VOIDNESS")
            else
                render.text(2, vector(screen_center.x + 2, screen_center.y + 18), color(219, 181, 231, 255), "cd", "\aDBB5E7FFV\aFFFFFFFFOI\aDBB5E7FFDN\aFFFFFFFFES\aDBB5E7FFS")
            end
            if isDT then
                render.shadow(vector(screen_center.x - 9, screen_center.y + 28), vector(screen_center.x + 11, screen_center.y + 28), color(255, 196, 240, 100), 45, 1, 1)
                render.text(2, vector(screen_center.x + 2, screen_center.y + 28), color(255,255,255,255), "cd", "" .. dtekclr)
            end
            if isOS then
                render.shadow(vector(screen_center.x - 9, screen_center.y + 28 + dt_y), vector(screen_center.x + 11, screen_center.y + 28 + dt_y), color(255, 196, 240, 100), 45, 1, 1)
                render.text(2, vector(screen_center.x + 2, screen_center.y + 28 + dt_y), color(255,255,255,255), "cd", "" .. oshoclr)
            end
            if isFS then
                render.shadow(vector(screen_center.x - 9, screen_center.y + 28 + dt_y + os_y), vector(screen_center.x + 11, screen_center.y + 28 + dt_y + os_y), color(255, 196, 240, 100), 45, 1, 1)
                render.text(2, vector(screen_center.x + 2, screen_center.y + 28 + dt_y + os_y), color(255,255,255,255), "cd", "" .. qpaclr)
            end
        end
        --MODERN
        if menu["Setts"].IndicatorSelection:get() == "Modern" then
            render.text(2, vector(screen_center.x + 10, screen_center.y + 20), color(219, 181, 231, 255), "cd", "" .. logoclr)

            if isDT then
                render.text(2, vector(screen_center.x + 3, screen_center.y + 20), color(219, 181, 231, 255), "cd", "" .. tyldaclr)
                render.text(2, vector(screen_center.x - 3, screen_center.y + 20), color(255,255,255,255), "cd", "DT")
            end
            if isOS then
                render.text(2, vector(screen_center.x + 17, screen_center.y + 20), color(219, 181, 231, 255), "cd", "" .. tyldaclr)
                render.text(2, vector(screen_center.x + 24, screen_center.y + 20), color(255,255,255,255), "cd", "OS")
            end
        end  
    end
    --Watermark
    local localp = entity.get_local_player()
	local screensize = render.screen_size()
	local x = screensize.x / 2
	local y = screensize.y / 2
    tekst1 = gradient_text(255,196,240,255,255,232,242,255, "VoidNess")
    tekst2 = gradient_text(255,196,240,255,255,232,242,255, "" .. version)

if menu["Setts"].Watermark:get() and menu["Setts"].EnableSetts == true then
                local avatar = localp:get_steam_avatar()
                render.shadow(vector(screen_center.x + 800, screen_center.y - 490), vector(screen_center.x + 1000, screen_center.y - 490), color(255, 196, 240, 165), 800, 1, 1)
                render.texture(avatar, vector(x + 799, y - 518), vector(35, 35), color(), "", 19)
                render.circle_outline(vector(x + 817, y - 500), color(219, 181, 231, 255), 19, 5, 5, 2)
                render.text(1, vector(x + 845, y - 513), color(255,255,255,255), "", "" .. tekst1 .. "", string.upper("  -  " .. tekst2))
                render.text(2, vector(x + 845, y - 497), color(255,255,255,255), "", string.upper("-   "..common.get_username().."   -"))
    end
end)

--Small panel
local countryconnect = network.get("https://ipapi.co/country_code")
local countryfl = network.get("https://flaglog.com/codes/standardized-rectangle-120px/"..countryconnect..".png")
local countryfl1 = render.load_image(countryfl)
local textsize2 = render.measure_text(1,"с", textuwka2).x
local screen_center = render.screen_size() / 2
local textuwka1 = ("> voidness.\aDBB5E7FFtechnologies")
local textuwka2 = ("> user: "..username.. " [\aDBB5E7FF"..version.."\aFFFFFFFF]")

local function bebra()
    if menu["Setts"].Smallpanel:get() and menu["Setts"].EnableSetts == true then 
        if menu["Setts"].SmallpanelShadow:get() then
        render.shadow(vector(screen_center.x - 958, screen_center.y + 13), vector(screen_center.x - 780, screen_center.y + 13), color(255, 196, 240, 165), 200, 1, 1)
        else end
        render.texture(countryfl1,vector(screen_center.x - 958, screen_center.y + 0), vector(40,25))
        render.text(1, vector(screen_center.x - 914, screen_center.y - 0.8), color(255, 255, 255, 255), "с", textuwka1)
        render.text(1, vector(screen_center.x - 914, screen_center.y + 10.5), color(255, 255, 255, 255), "с", textuwka2)
        render.text(1, vector(1+textsize2+28, screen_center.y + 0), color(154,163,190), "с" ..textuwka1)
    end
end
events.render:set(bebra)

--Gui Removals
events.render:set(function()
    if menu["AntiAim"].EnableAA == true then
        menu["AntiAim"].AntiAimSelector:set_visible(true)
        menu["AntiAim"].ManualBack:set_visible(true)
        menu["AntiAim"].ManualLeft:set_visible(true)
        menu["AntiAim"].ManualRight:set_visible(true)
        menu["AntiAim"].PlayerState:set_visible(false)
    else
        menu["AntiAim"].AntiAimSelector:set_visible(false)
        menu["AntiAim"].ManualBack:set_visible(false)
        menu["AntiAim"].ManualLeft:set_visible(false)
        menu["AntiAim"].ManualRight:set_visible(false)
        menu["AntiAim"].PlayerState:set_visible(false)
    end
    if menu["AntiAim"].EnableAA == true and menu["AntiAim"].AntiAimSelector:get() == "Builder" then
        menu["AntiAim"].PlayerState:set_visible(true)
        menu["AntiAim"].PlayerStateLb:set_visible(false)
        for i=1, 6 do
            ActiveStateVisual = ConvertStates[menu["AntiAim"].PlayerState:get()]
            Builder[i].Enable:set_visible(ActiveStateVisual == i)
            if Builder[i].Enable:get() then
                Builder[i].YawLeft:set_visible(ActiveStateVisual == i)
                Builder[i].YawRight:set_visible(ActiveStateVisual == i)
                Builder[i].YawMod:set_visible(ActiveStateVisual == i)
                Builder[i].YawModOffset:set_visible(ActiveStateVisual == i and Builder[ActiveStateVisual].YawMod ~= "Disabled")
                Builder[i].EnableBodyYaw:set_visible(ActiveStateVisual == i)
                Builder[i].FakeYawLimitLeft:set_visible(ActiveStateVisual == i and Builder[ActiveStateVisual].EnableBodyYaw:get())
                Builder[i].FakeYawLimitRight:set_visible(ActiveStateVisual == i and Builder[ActiveStateVisual].EnableBodyYaw:get())
                Builder[i].FakeOptions:set_visible(ActiveStateVisual == i and Builder[ActiveStateVisual].EnableBodyYaw:get())
                Builder[i].LBYMode:set_visible(ActiveStateVisual == i and Builder[ActiveStateVisual].EnableBodyYaw:get())
                Builder[i].FreeStandingDesync:set_visible(ActiveStateVisual == i and Builder[ActiveStateVisual].EnableBodyYaw:get())
                Builder[i].DesyncOnshot:set_visible(ActiveStateVisual == i and Builder[ActiveStateVisual].EnableBodyYaw:get())
            else
                Builder[i].YawLeft:set_visible(false)
                Builder[i].YawRight:set_visible(false)
                Builder[i].YawMod:set_visible(false)
                Builder[i].YawModOffset:set_visible(false)
                Builder[i].EnableBodyYaw:set_visible(false)
                Builder[i].FakeYawLimitLeft:set_visible(false)
                Builder[i].FakeYawLimitRight:set_visible(false)
                Builder[i].FakeOptions:set_visible(false)
                Builder[i].LBYMode:set_visible(false)
                Builder[i].FreeStandingDesync:set_visible(false)
                Builder[i].DesyncOnshot:set_visible(false)
            end
        end
    else
        menu["AntiAim"].PlayerState:set_visible(false)
        menu["AntiAim"].PlayerStateLb:set_visible(true)
        for i=1, 6 do
            Builder[i].Enable:set_visible(false)
            Builder[i].YawLeft:set_visible(false)
            Builder[i].YawRight:set_visible(false)
            Builder[i].YawMod:set_visible(false)
            Builder[i].YawModOffset:set_visible(false)
            Builder[i].EnableBodyYaw:set_visible(false)
            Builder[i].FakeYawLimitLeft:set_visible(false)
            Builder[i].FakeYawLimitRight:set_visible(false)
            Builder[i].FakeOptions:set_visible(false)
            Builder[i].LBYMode:set_visible(false)
            Builder[i].FreeStandingDesync:set_visible(false)
            Builder[i].DesyncOnshot:set_visible(false)
        end
    end
end)

events.render:set(function()
    if menu["Setts"].EnableSetts == true then
        menu["Setts"].ClanTag:set_visible(true)
    else
        menu["Setts"].ClanTag:set_visible(false)
    end
end)

events.render:set(function()
    if menu["Setts"].Smallpanel:get() then
        menu["Setts"].SmallpanelShadow:set_visible(true)
    else
        menu["Setts"].SmallpanelShadow:set_visible(false)
    end
end)


events.render:set(function()
    if menu["Setts"].EnableSetts == true then
        menu["Setts"].Indicators:set_visible(true)
        menu["Setts"].IndicatorSelection:set_visible(true)
        menu["Setts"].LegBreaker:set_visible(true)
        menu["Setts"].Watermark:set_visible(true)
    else
        menu["Setts"].Indicators:set_visible(false)
        menu["Setts"].IndicatorSelection:set_visible(false)
        menu["Setts"].LegBreaker:set_visible(false)
        menu["Setts"].Watermark:set_visible(false)
    end
    if menu["Setts"].EnableSetts == true and menu["Setts"].Indicators:get() then
        menu["Setts"].IndicatorSelection:set_visible(true)
    else
        menu["Setts"].IndicatorSelection:set_visible(false)
    end
end)

--CallBacks
events.render:set(function()
    StatesBuilder()
end)