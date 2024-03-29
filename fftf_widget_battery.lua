--电池电量显示插件
-- 参考引用自 http://awesome.naquadah.org/wiki/Gigamo_Battery_Widget
local wibox = require("wibox")
require("battery_icons")
local utils = require("fftf_utils")

local status_table = {
   {8, battery_icons_000},
   {20, battery_icons_020},
   {40, battery_icons_040},
   {60, battery_icons_060},
   {80, battery_icons_080},
   {100, battery_icons_100}
}
local status_table_c = {
   {8, battery_icons_000_c},
   {20, battery_icons_020_c},
   {40, battery_icons_040_c},
   {60, battery_icons_060_c},
   {80, battery_icons_080_c},
   {100, battery_icons_100_c}
}


local fftf_widget_battery = {}
fftf_widget_battery.icon =  wibox.widget.imagebox()
fftf_widget_battery.text =  wibox.widget.textbox()

fftf_widget_battery_group = wibox.layout.fixed.horizontal()
fftf_widget_battery_group:add(fftf_widget_battery.icon)
fftf_widget_battery_group:add(fftf_widget_battery.text)



function fftf_widget_battery_get_battery_info(adapter)
   local fcur = io.open("/sys/class/power_supply/"..adapter.."/energy_now")    
   local fcap = io.open("/sys/class/power_supply/"..adapter.."/energy_full")
   local fsta = io.open("/sys/class/power_supply/"..adapter.."/status")
   if fcur and fcap and fsta then
      local cur = fcur:read()
      local cap = fcap:read()
      local sta = fsta:read()
      local battery = math.floor(cur * 100 / cap)
      if sta:match("Charging") then
	 dir = "up"
      elseif sta:match("Discharging") then
	 dir = "down"
      else
	 dir = "ok"
      end
      fcur:close()
      fcap:close()
      fsta:close()
      return {battery,dir}
   end
end

function fftf_widget_battery_check_battery(adapter)
    local batInfos = fftf_widget_battery_get_battery_info(adapter)
    if batInfos then
        local battery = batInfos[1]
        local dir = batInfos[2]
	local ic = ""
	if dir:match("down") then
	   -- 没有充电
	   ic = fftf_get_status(status_table, tonumber(battery))
	   if tonumber(battery) <10 then
	      naughty.notify({ preset = naughty.config.presets.critical,
			       title = "Batterie Low",
			       text = " ".. battery .. "% left",
			       timeout = 30,
			       font = "Liberation 11", })
	   end
	elseif dir:match("up") then
	   ic = fftf_get_status(status_table_c, tonumber(battery))
	else
 	   ic= battery_icons_c
	end
	fftf_widget_battery.icon:set_image(ic)
	fftf_widget_battery.text:set_text(" " .. battery .. "% ")
   else
	fftf_widget_battery.icon:set_image(batter_icons_p)
	fftf_widget_battery.text:set_text("A/C")
   end
end

function fftf_widget_battery_show_battery_info(adapter)
    local batInfos =  fftf_widget_battery_get_battery_info(adapter)
    if batInfos then
        local battery = batInfos[1]
        local dir = batInfos[2]
        infos = " " .. dir .. battery .. "% " 
    else
       infos = "absente"
    end
      naughty.notify({title = "Batterie",text = infos})
end

fftf_connect_timer(fftf_timer.timer1, function()  fftf_widget_battery_check_battery("BAT1") end)

-- battery_timer = timer({timeout = 1})
-- -- BAT1需要根据具体机器系统去配置
-- battery_timer:connect_signal("timeout", function()  fftf_widget_battery_check_battery("BAT1") end)
-- battery_timer:start()
