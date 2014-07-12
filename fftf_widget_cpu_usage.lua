---------------------------------------------------
-- Licensed under the GNU General Public License v2
--  * (c) 2011, Adrian C. <anrxc@sysphere.org>
--  * (c) 2009, Lucas de Vries <lucas@glacicle.com>fftf_widget_cpu_usage_show_detail
--  * (c) 2011, Jörg Thalheim <jthalheim@gmail.com>
---------------------------------------------------
local wibox = require("wibox")
local awful = require("awful")
local naughty =  require("naughty")

local fftf_uitls = require("fftf_utils")
require("cpu_usage_icons")

-- {{{ Grab environment
local ipairs = ipairs
local io = { lines = io.lines }
local setmetatable = setmetatable
local math = { floor = math.floor }
local table = { insert = table.insert }
local string = {
    sub = string.sub,
    gmatch = string.gmatch
}
-- }}}


-- Cpu: provides CPU usage for all available CPUs/cores
-- module("vicious.widgets.cpu")


-- Initialize function tables
local cpu_usage  = {}
local cpu_total  = {}
local cpu_active = {}

-- {{{ CPU widget type
local function worker()
    local cpu_lines = {}

    -- Get CPU stats
    for line in io.lines("/proc/stat") do
        if string.sub(line, 1, 3) ~= "cpu" then break end

        cpu_lines[#cpu_lines+1] = {}

        for i in string.gmatch(line, "[%s]+([^%s]+)") do
            table.insert(cpu_lines[#cpu_lines], i)
        end
    end

    -- Ensure tables are initialized correctly
    for i = #cpu_total + 1, #cpu_lines do
        cpu_total[i]  = 0
        cpu_usage[i]  = 0
        cpu_active[i] = 0
    end


    for i, v in ipairs(cpu_lines) do
        -- Calculate totals
        local total_new = 0
        for j = 1, #v do
            total_new = total_new + v[j]
        end
        local active_new = total_new - (v[4] + v[5])

        -- Calculate percentage
        local diff_total  = total_new - cpu_total[i]
        local diff_active = active_new - cpu_active[i]

        if diff_total == 0 then diff_total = 1E-6 end
        cpu_usage[i]      = math.floor((diff_active / diff_total) * 100)

        -- Store totals
        cpu_total[i]   = total_new
        cpu_active[i]  = active_new
	-- fftf_nprint("cpu_totol".. i..":", cpu_total[i])
	-- fftf_nprint("cpu_usage".. i..":", cpu_usage[i])
	-- fftf_nprint("cpu_active".. i..":", cpu_active[i])

    end

    return cpu_usage
end
-- }}}

fftf_widget_cpu_usage = {}
fftf_widget_cpu_usage.icon = wibox.widget.imagebox()
fftf_widget_cpu_usage.icon:buttons(awful.util.table.join(
				      awful.button({ }, 1, function () fftf_widget_cpu_usage_show_detail() end)
))
fftf_widget_cpu_usage.text = wibox.widget.textbox()

function fftf_widget_cpu_usage_update()
   
   local total = ""
   worker()
   total = " " .. cpu_usage[1] .."% "
   ic = fftf_get_status(cpu_usage_icons_status_table, cpu_usage[1])
   fftf_widget_cpu_usage.icon:set_image(ic)
   
   -- fftf_widget_cpu_usage.icon:set_image()
   fftf_widget_cpu_usage.text:set_text(total)
end

function fftf_widget_cpu_usage_show_detail()
   local subs = ""
   for i = 2, #cpu_usage do
      subs = subs .."\nCPU core " .. i-1 ..": ".. cpu_usage[i] .. "%"
   end   
   naughty.notify({ preset = naughty.config.presets.normal,
		    title = "多核CPU使用详情:",
		    text = subs,
		    timeout = 2})
end
-- 以下是动态图的实验
local v = 0
function fftf_widget_cpu_usage_icons_animate()
   if v <= 100 then
      ic = fftf_get_status(cpu_icons_status_table, v)
      fftf_widget_cpu_usage.icon:set_image(ic)
      v=v + 5
   elseif v <=200 then
      ic = fftf_get_status(cpu_icons_status_table_reverse, v-100)
      fftf_widget_cpu_usage.icon:set_image(ic)
      v=v + 5
   end
   if v > 200 then
      v = 0
   end
end

-- cpu_usage_icons_timer = timer({timeout = 0.5})
-- cpu_usage_icons_timer:connect_signal("timeout", function() fftf_widget_cpu_usage_icons_animate() end)
-- cpu_usage_icons_timer:start()

cpu_usage_timer = timer({timeout = 1})
cpu_usage_timer:connect_signal("timeout", function() fftf_widget_cpu_usage_update() end)
cpu_usage_timer:start()


