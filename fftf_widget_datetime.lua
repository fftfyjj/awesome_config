local awful = require("awful")
local wibox = require("wibox")
local naughty =  require("naughty")

require("calendar_icons")
local fftf_utils = require("fftf_utils")

fftf_widget_datetime = {}
fftf_widget_datetime.time = awful.widget.textclock(" %a %H:%M ")
fftf_widget_datetime.date = wibox.widget.imagebox()
fftf_widget_datetime.date:buttons(awful.util.table.join(
				     awful.button({ }, 1, function () fftf_widget_datetime_show_detail() end)
))

fftf_widget_datetime_group = wibox.layout.fixed.horizontal()
fftf_widget_datetime_group:add(fftf_widget_datetime.date)
fftf_widget_datetime_group:add(fftf_widget_datetime.time)


function fftf_widget_datetime_show_detail()
   local tx = io.popen("cal -h"):read("*all")
   naughty.notify({ preset = naughty.config.presets.normal,
		    title = "日历",
		    text = tx,
		    timeout = 2})
end


function fftf_widget_datetime_update_date()
   local d = os.date("*t")
   local day = tonumber(d.day)
   local ic = fftf_get_status(calendar_icons_status_table, day)
   fftf_widget_datetime.date:set_image(ic)
end
   
fftf_widget_datetime_update_date()

datetime_timer = timer({timeout = 60})
datetime_timer:connect_signal("timeout", function() fftf_widget_datetime_update_date() end)
datetime_timer:start()


