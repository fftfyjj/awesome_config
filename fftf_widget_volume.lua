--音量控制插件
-- 参考修改自http://awesome.naquadah.org/wiki/Farhavens_volume_widget
local awful = require("awful")
local wibox = require("wibox")
local volume_icons = require("volume_icons")

-- widget 界面
fftf_widget_volume = {}
fftf_widget_volume.icon = wibox.widget.imagebox()
fftf_widget_volume.text = wibox.widget.textbox()
-- fftf_widget_volume:set_image("/usr/share/icons/ubuntu-mono-dark/status/24/audio-volume-low-panel.svg")

local last_key = ""
local volume_bak = 0

local status_table = {
   {-1, volume_icons_muted},
   {0, volume_icons_zero},
   {34, volume_icons_low},
   {65, volume_icons_medium},
   {100, volume_icons_high}
}

local cardid  = 1
local channel = "Master"

-- 当前音量获取获取函数
function fftf_widget_volume_get_volume()
   local status = io.popen("amixer -c " .. cardid .. " -- sget " .. channel):read("*all")
   local volumedata = string.match(status, "(%d?%d?%d)%%")
   volumedata = tonumber(volumedata)
   return volumedata
end

function fftf_widget_volume_set_volume(value)
   awful.util.spawn("amixer -q -c " .. cardid .. " sset " .. channel .. " " .. value .."%")
end
function fftf_widget_volume_up_volume(value)
   awful.util.spawn("amixer -q -c " .. cardid .. " sset " .. channel .. " " .. value .."%+")
end
function fftf_widget_volume_down_volume(value)
   awful.util.spawn("amixer -q -c " .. cardid .. " sset " .. channel .. " " .. value .."%-")
end

function fftf_widget_volume_update(mode,value,t)
   local cur = 0
   local tx = ""
   local ic = ""
   if t == nil then		
      t = true
   end

   if mode == "umuted" then
      fftf_widget_volume_set_volume(value)
   elseif mode == "up" then
      fftf_widget_volume_up_volume(value)
   elseif mode == "down" then
      fftf_widget_volume_down_volume(value)
   end
   cur = fftf_widget_volume_get_volume()
   tx = " " .. cur .. "% "
   if mode == "muted" then
      fftf_widget_volume_set_volume(value)
      cur = -1
      tx = "Mut"
   end
   ic = fftf_get_status(status_table, cur)
   -- 更新wibox显示
   if t then
      fftf_widget_volume.icon:set_image(ic)
      fftf_widget_volume.text:set_text(tx)
   end
end

function fftf_widget_volume_mute()
   if last_key == "muted" then
      last_key = "umuted"
      fftf_widget_volume_update(last_key, volume_bak)
   else 
      last_key = "muted"
      volume_bak = fftf_widget_volume_get_volume()
      fftf_widget_volume_update(last_key, 0)
   end
end

function fftf_widget_volume_up()
   if last_key == "muted" then
      fftf_widget_volume_update("umuted", volume_bak, false)
   end
   last_key = "up"
   fftf_widget_volume_update(last_key, 5)
end
function fftf_widget_volume_down()
   if last_key == "muted" then
      fftf_widget_volume_update("umuted", volume_bak, false)
   end
   last_key = "down"
   fftf_widget_volume_update(last_key, 5)
end

function fftf_widget_volume_refresh()
   if last_key == "muted" then
      fftf_widget_volume_update(last_key, 0)
   else 
      fftf_widget_volume_update()
   end
end
   

-- 时间刷新hook
volume_timer = timer { timeout = 1 }
volume_timer:connect_signal("timeout", function() fftf_widget_volume_refresh() end)
volume_timer:start()		


-- 以下是老版本
-- 音量控制调节函数:
-- cardid  = 1
-- channel = "Master"
-- voicebak = "0"
-- isNotInit = false
-- function fftf_widget_volume_control_vol(mode, widget)
--    local status = io.popen("amixer -c " .. cardid .. " -- sget " .. channel):read("*all")
--    volumedata = string.match(status, "(%d?%d?%d)%%")
--    if mode == "update" then
--       local ic = ""

--       local v = tonumber(volumedata)
--       local tx =  " " .. v .. "% "
--       if v==0 then
-- 	 if state=="muted" then
-- 	    ic = volume_icons_muted
-- 	    tx = "Mut"-- fftf_widget_volume.text:set_text("Muted")
-- 	 else 
-- 	    ic = volume_icons_zero
-- 	 end
--       elseif v<=33 then
-- 	 ic = volume_icons_low	--
--       elseif v<=66 then
-- 	 ic = volume_icons_medium 
--       else
-- 	 ic = volume_icons_high
--       end
--       fftf_widget_volume.icon:set_image(ic)
--       fftf_widget_volume.text:set_text(tx)
--    elseif mode == "up" then
--       state = "up"
--       isNotInit = true
--       voicebak = volumedata
      
--       awful.util.spawn("amixer -q -c " .. cardid .. " sset " .. channel .. " 5%+")
--       fftf_widget_volume_control_vol("update", widget)
--    elseif mode == "down" then
--       state = "down"
--       voicebak = volumedata
      
--       isNotInit = true
--       awful.util.spawn("amixer -q -c " .. cardid .. " sset " .. channel .. " 5%-")
--       fftf_widget_volume_control_vol("update", widget)
--    elseif mode=="mute" and volumedata=="0" and isNotInit then
--       state = "umuted"
--       awful.util.spawn("amixer -q -c " .. cardid .. " sset " .. channel .. " " .. voicebak .. "%")
--       fftf_widget_volume_control_vol("update", widget)
--    else
--       isNotInit = true
--       voicebak = volumedata
--       state = "muted"
--       awful.util.spawn("amixer -q -c " .. cardid .. " sset " .. channel .. " 0%")
--       fftf_widget_volume_control_vol("update", widget)
--    end
-- end

-- fftf_widget_volume_control_vol("update", fftf_widget_volume)

