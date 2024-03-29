local wibox = require("wibox")
require("lockkeys_icon")
local fftf_widget_lockkeys = {}
fftf_widget_lockkeys.capslock = {}
fftf_widget_lockkeys.capslock.widget = wibox.widget.imagebox()
fftf_widget_lockkeys.capslock.type = "Caps Lock"
fftf_widget_lockkeys.capslock.img_toggle = fftf_toggle_img(lockkeys_icons_caps, lockkeys_icons_caps_r)
-- fftf_dprint(lockkeys_icons_caps)
fftf_widget_lockkeys.numlock = {}
fftf_widget_lockkeys.numlock.widget = wibox.widget.imagebox()
fftf_widget_lockkeys.numlock.type = "Num Lock"
fftf_widget_lockkeys.numlock.img_toggle = fftf_toggle_img(lockkeys_icons_num ,lockkeys_icons_num_r )

fftf_widget_lockkeys.scrolllock = {}
fftf_widget_lockkeys.scrolllock.widget = wibox.widget.imagebox()
fftf_widget_lockkeys.scrolllock.type = "Scroll Lock"
fftf_widget_lockkeys.scrolllock.img_toggle = fftf_toggle_img(lockkeys_icons_scroll ,lockkeys_icons_scroll_r )

fftf_widget_lockkeys.shiftlock = {}
fftf_widget_lockkeys.shiftlock.widget = wibox.widget.imagebox()
fftf_widget_lockkeys.shiftlock.type = "Shift Lock"
fftf_widget_lockkeys.shiftlock.img_toggle = fftf_toggle_img(lockkeys_icons_shift , lockkeys_icons_shift_r )

fftf_widget_lockkeys_group = wibox.layout.fixed.horizontal()
fftf_widget_lockkeys_group:add(fftf_widget_lockkeys.capslock.widget)
fftf_widget_lockkeys_group:add(fftf_widget_lockkeys.numlock.widget)
fftf_widget_lockkeys_group:add(fftf_widget_lockkeys.scrolllock.widget)
fftf_widget_lockkeys_group:add(fftf_widget_lockkeys.shiftlock.widget)


local function fftf_widget_lockkeys_get_status(lockkey)
   local status = io.popen("xset -q |grep \"[[:digit:]][[:digit:]]:\""):read("*all")
   status = string.match(status, lockkey .. ":%s+o%a+")
   status = string.match(status, "%a+$")
   return status
end

local function fftf_widget_lockkeys_set_widget(lock)
   local stat = fftf_widget_lockkeys_get_status(lock.type)
   if stat == "on" then
      lock.widget:set_image(lock.img_toggle())
   else
      lock.widget:set_image(nil)
   end
end

function fftf_widget_lockkeys_update()
   fftf_widget_lockkeys_set_widget(fftf_widget_lockkeys.capslock)
   fftf_widget_lockkeys_set_widget(fftf_widget_lockkeys.numlock)
   fftf_widget_lockkeys_set_widget(fftf_widget_lockkeys.scrolllock)
   fftf_widget_lockkeys_set_widget(fftf_widget_lockkeys.shiftlock)
end
   

fftf_connect_timer(fftf_timer.timer1, function()  fftf_widget_lockkeys_update() end)



