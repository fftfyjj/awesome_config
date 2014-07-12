local wibox = require("wibox")
local utils = require("fftf_utils")
require("cpu_temp_icons")

fftf_widget_cpu_temp = {}
fftf_widget_cpu_temp.icon = wibox.widget.imagebox()
fftf_widget_cpu_temp.text = wibox.widget.textbox()


function fftf_cpu_temp_get()
   local status = io.popen("cat /proc/acpi/ibm/thermal"):read("*all")
   local temp = string.match(status, "\t(%d?%d?%d?)")
   return tonumber(temp)
end

function fftf_cpu_temp_update()
   local temp = fftf_cpu_temp_get()
   local icon = fftf_get_status(cpu_temp_icons_status_table, temp)
   fftf_widget_cpu_temp.icon:set_image(icon)
   -- fftf_widget_cpu_temp.icon:set_fg(FF0000)
   fftf_widget_cpu_temp.text:set_text(" " .. temp .. "°C ")
end


cpu_temp_timer = timer({timeout = 1})
cpu_temp_timer:connect_signal("timeout", function() fftf_cpu_temp_update() end)
cpu_temp_timer:start()
