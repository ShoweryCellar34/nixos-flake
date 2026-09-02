----------------------------------------------------------------
-- VARIABLES
----------------------------------------------------------------
local mainMod  = "SUPER"
local terminal = "alacritty"

----------------------------------------------------------------
-- AUTOSTART
----------------------------------------------------------------
hl.on("hyprland.start", function()
    hl.exec_cmd("uwsm app -- noctalia")
end)

----------------------------------------------------------------
-- MONITORS
----------------------------------------------------------------
hl.monitor({ output = "", mode = "preferred", position = "auto", scale = "auto" })

----------------------------------------------------------------
-- LOOK & FEEL
----------------------------------------------------------------
hl.config({
    general = {
        gaps_in          = 0,
        gaps_out         = 0,
        border_size      = 0,
        resize_on_border = true
    },
    decoration = {
        rounding    = 0,
        dim_special = 0.0,

        shadow = {
            enabled = false
        }
    },
    input = {
        touchpad = {
            natural_scroll       = true,
            disable_while_typing = false
        },
        follow_mouse   = 1
    },
    animations = {
        enabled = false
    },
    xwayland = {
        force_zero_scaling = true
    }
})

----------------------------------------------------------------
-- WINDOW FOCUS / MOVEMENT
----------------------------------------------------------------
hl.bind(mainMod .. " + Left",  hl.dsp.focus({ direction = "l" }))
hl.bind(mainMod .. " + Right", hl.dsp.focus({ direction = "r" }))
hl.bind(mainMod .. " + Down",  hl.dsp.focus({ direction = "d" }))
hl.bind(mainMod .. " + Up",    hl.dsp.focus({ direction = "u" }))
hl.bind(mainMod .. " + Space", hl.dsp.window.cycle_next())

hl.bind(mainMod .. " + SHIFT + Left",  hl.dsp.window.move({ direction = "l" }))
hl.bind(mainMod .. " + SHIFT + Right", hl.dsp.window.move({ direction = "r" }))
hl.bind(mainMod .. " + SHIFT + Down",  hl.dsp.window.move({ direction = "d" }))
hl.bind(mainMod .. " + SHIFT + Up",    hl.dsp.window.move({ direction = "u" }))

hl.bind(mainMod .. " + CTRL + Left",  hl.dsp.window.resize({ x = -20, y = 0,   relative = true }))
hl.bind(mainMod .. " + CTRL + Right", hl.dsp.window.resize({ x = 20,  y = 0,   relative = true }))
hl.bind(mainMod .. " + CTRL + Up",    hl.dsp.window.resize({ x = 0,   y = -20, relative = true }))
hl.bind(mainMod .. " + CTRL + Down",  hl.dsp.window.resize({ x = 0,   y = 20,  relative = true }))

hl.bind("ALT + TAB", hl.dsp.exec_cmd("noctalia msg window-switcher"))

----------------------------------------------------------------
-- CORE BINDS
----------------------------------------------------------------
hl.bind(mainMod .. " + Return",   hl.dsp.exec_cmd("uwsm app -- " .. terminal))
hl.bind(mainMod .. " + Q",        hl.dsp.window.close())
hl.bind(mainMod .. " + F",        hl.dsp.window.fullscreen({ action = "toggle" }))
hl.bind(mainMod .. " + T",        hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + CTRL + R", hl.dsp.exec_cmd("hyprctl reload; noctalia msg config-reload"))

hl.bind(mainMod .. " + CTRL + Q", hl.dsp.exec_cmd("noctalia msg session logout"))

hl.bind(mainMod .. " + D",        hl.dsp.exec_cmd("noctalia msg panel-toggle launcher"))
hl.bind(mainMod .. " + CTRL + S", hl.dsp.exec_cmd("noctalia msg screenshot-region"))
hl.bind(mainMod .. " + L",        hl.dsp.exec_cmd("noctalia msg session lock"))

hl.bind(mainMod .. " + V", hl.dsp.exec_cmd("noctalia msg panel-toggle clipboard"))

----------------------------------------------------------------
-- WORKSPACES / GROUPS
----------------------------------------------------------------
for i = 1, 9 do
    hl.bind(mainMod .. " + " .. i,         hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + SHIFT + " .. i, hl.dsp.window.move({ workspace = i }))
end

hl.bind(mainMod .. " + S",         hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))

----------------------------------------------------------------
-- MEDIA / FUNCTION KEYS
----------------------------------------------------------------
hl.bind("XF86AudioMute",        hl.dsp.exec_cmd("noctalia msg volume-mute"), { locked = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("noctalia msg volume-down"), { locked = true, repeating = true })
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("noctalia msg volume-up"),   { locked = true, repeating = true })
hl.bind("XF86AudioMicMute",     hl.dsp.exec_cmd("noctalia msg mic-mute"),    { locked = true })

hl.bind("XF86AudioStop",    hl.dsp.exec_cmd("playerctl stop"),             { locked = true })
hl.bind("XF86AudioPlay",    hl.dsp.exec_cmd("noctalia msg media toggle"),  { locked = true })
hl.bind("XF86AudioPause",   hl.dsp.exec_cmd("noctalia msg media toggle"),  { locked = true })
hl.bind("XF86AudioNext",    hl.dsp.exec_cmd("noctalia msg media next"),    { locked = true })
hl.bind("XF86AudioPrev",    hl.dsp.exec_cmd("noctalia msg media prevous"), { locked = true })
hl.bind("XF86AudioForward", hl.dsp.exec_cmd("playerctl position 10+"),     { locked = true })
hl.bind("XF86AudioRewind",  hl.dsp.exec_cmd("playerctl position 10-"),     { locked = true })

hl.bind("XF86Sleep",    hl.dsp.exec_cmd("noctalia msg session lock && systemctl sleep"), { locked = true })
hl.bind("XF86Suspend",  hl.dsp.exec_cmd("noctalia msg session lock-and-suspend"),        { locked = true })
hl.bind("XF86PowerOff", hl.dsp.exec_cmd("noctalia msg session shutdown"),                { locked = true })

hl.bind("XF86WLAN",              hl.dsp.exec_cmd("noctalia msg wifi-toggle"),      { locked = true })
hl.bind("XF86Bluetooth",         hl.dsp.exec_cmd("noctalia msg bluetooth-toggle"), { locked = true })
hl.bind("XF86ScreenSaver",       hl.dsp.exec_cmd("noctalia msg screen-lock"),      { locked = true })
hl.bind("XF86Eject",             hl.dsp.exec_cmd("eject"),                         { locked = true })
hl.bind("XF86RFKill",            hl.dsp.exec_cmd("rfkill toggle all"),             { locked = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("noctalia msg brightness-down"),  { locked = true })
hl.bind("XF86MonBrightnessUp",   hl.dsp.exec_cmd("noctalia msg brightness-up"),    { locked = true })
hl.bind("XF86Display",           hl.dsp.exec_cmd("kanshictl reload"),              { locked = true })

----------------------------------------------------------------
-- MOUSE
----------------------------------------------------------------
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })
hl.bind(mainMod .. " + mouse:274", hl.dsp.window.bring_to_top())

----------------------------------------------------------------
-- RULES
----------------------------------------------------------------
hl.window_rule({
    match          = { class = "^(ssh-askpass)$" },
    float          = true,
    stay_focused   = true,
    rounding       = 5,
    rounding_power = 2.0
})

hl.window_rule({
    match          = { class = "^(pinentry.*)$" },
    float          = true,
    stay_focused   = true,
    rounding       = 5,
    rounding_power = 2.0
})

hl.window_rule({
    match          = { class = "^(xdg-desktop-portal-gtk)$" },
    float          = true,
    rounding       = 5,
    rounding_power = 2.0
})

hl.window_rule({
    match             = { title = "^([Pp]icture-in-[Pp]icture)$" },
    float             = true,
    pin               = true,
    keep_aspect_ratio = true,
    border_size       = 3
})

hl.window_rule({
    match = {
      class = "^(org.keepassxc.KeePassXC)$",
      title = "^(Unlock Database - KeePassXC)$|^(KeePassXC - Browser Access Request)$"
    },
    float          = true,
    stay_focused   = true,
    rounding       = 5,
    rounding_power = 2.0
})

hl.window_rule({
  match = {
    class = "^(steam)$",
    title = "^(?!Steam$).*$",
  },
  float = true,
})

hl.window_rule({
  match = {
    class = "^(Thunar)$",
    title = [[.*Rename +"[^"]*".*]],
  },
  float = true,
})
