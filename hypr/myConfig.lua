require("stylix")

----------------------------------------------------------------
-- VARIABLES  (qtile's mod/terminal locals)
----------------------------------------------------------------
local mainMod  = "SUPER"
local terminal = "alacritty"
local menu     = "rofi -show drun -show-icons"

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
-- WINDOW FOCUS / MOVEMENT  (qtile's layout.left/right/down/up, shuffle_*, grow_*)
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

hl.bind(mainMod .. " + CTRL + Left",  hl.dsp.window.resize({ x = -20, y = 0,  relative = true }))
hl.bind(mainMod .. " + CTRL + Right", hl.dsp.window.resize({ x = 20,  y = 0,  relative = true }))
hl.bind(mainMod .. " + CTRL + Up",    hl.dsp.window.resize({ x = 0,   y = -20, relative = true }))
hl.bind(mainMod .. " + CTRL + Down",  hl.dsp.window.resize({ x = 0,   y = 20,  relative = true }))

----------------------------------------------------------------
-- CORE BINDS
----------------------------------------------------------------
hl.bind(mainMod .. " + Return",    hl.dsp.exec_cmd("uwsm app -- " .. terminal))
hl.bind(mainMod .. " + Q",         hl.dsp.window.close())
hl.bind(mainMod .. " + F",         hl.dsp.window.fullscreen({ action = "toggle" }))
hl.bind(mainMod .. " + T",         hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + CTRL + R",  hl.dsp.exec_cmd("hyprctl reload"))

hl.bind(mainMod .. " + CTRL + Q",  hl.dsp.exec_cmd("playerctl pause; hyprshutdown"))

hl.bind(mainMod .. " + D",         hl.dsp.exec_cmd(menu))
hl.bind(mainMod .. " + CTRL + S",  hl.dsp.exec_cmd('geometry=$(slurp) || exit; screenshotPath=$(realpath ~/screenshots/screenshot_$(date + \'%Y-%m-%d_%H-%M-%S\').png); grim -g "$geometry" - | tee ${screenshotPath} | wl-copy; notify-send "Screenshot Taken!" -a "Hyprland" -i ${screenshotPath}'))
hl.bind(mainMod .. " + L",         hl.dsp.exec_cmd("loginctl lock-session"))

hl.bind(mainMod .. " + V", hl.dsp.exec_cmd("rofi -modi clipboard:cliphist-rofi-img -show clipboard -show-icons"))

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
hl.bind("XF86AudioMute",         hl.dsp.exec_cmd("ashell msg volume-toggle-mute"),     { locked = true })
hl.bind("XF86AudioLowerVolume",  hl.dsp.exec_cmd("ashell msg volume-down"),            { locked = true, repeating = true })
hl.bind("XF86AudioRaiseVolume",  hl.dsp.exec_cmd("ashell msg volume-up"),              { locked = true, repeating = true })
hl.bind("XF86AudioMicMute",      hl.dsp.exec_cmd("ashell msg microphone-toggle-mute"), { locked = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("ashell msg brightness-down"),        { locked = true })
hl.bind("XF86MonBrightnessUp",   hl.dsp.exec_cmd("ashell msg brightness-up"),          { locked = true })
hl.bind("XF86Display",           hl.dsp.exec_cmd("kanshictl reload"),                  { locked = true })

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
    match          = { class = "^(polkit-gnome-authentication-agent-1|polkit-kde-authentication-agent-1|hyprpolkitagent)$" },
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
    class = "^(steam)$",
    title = "^(?!Steam$).*$",
  },
  float = true,
})
