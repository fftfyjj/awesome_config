-- -- 工具库， 想法来源于 http://dotshare.it/dots/310/
-- 竟然把这个module语法写错了，这么久出问题, fucking...............................
-- module ("fftf_utils")
local naughty =  require("naughty")
local awful = require("awful")

fftf_home = os.getenv("HOME")
fftf_timer = {}
fftf_timer.timer1 = timer({timeout = 1})
fftf_timer.timer10 = timer({timeout = 10})
fftf_timer.timer60 = timer({timeout = 60})

function fftf_connect_timer(type, func)
   type:connect_signal("timeout", func)
   if not type.started then
      type:start()
   end
end

function fftf_toggle_img(...)
   local i = 1
   local v = {...}
   -- for e, s in ipairs(...) do
   --    v[#v+1] = s
   -- end
   return function() 
      local tmp = v[i]
      i = i + 1
      if i > #v then
	 i = 1
      end
      return tmp
   end
end

-- 用于从状态表中获取想要的状态
-- 状态表的数据结构约定如下
-- local status_table = {
--    {0, "result1"},
--    {10, "result2"}
--    ....
--    {100, "result"}
-- }
function fftf_get_status(pair_data, value)
   for s = 1, #pair_data do
      tmp = pair_data[s]
      if value <= tmp[1] then
	 return tmp[2]
      end
   end
   return ""
end

-- -- 程序最多只会被运行不超过n次, times参数可选，默认为1
function fftf_run_once(program, times)
   if not program then
      do return nil end
   end
   times = times or 1
   count_prog = 
      tonumber(awful.util.pread('ps aux | grep "' .. program .. '" | grep -v grep | wc -l'))
   if times > count_prog then
      for l = count_prog, times-1 do
         awful.util.spawn_with_shell(program)
      end
   end
end



-- function run_once(cmd)
--    findme = cmd
--    firstspace = cmd:find(" ")
--    if firstspace then
--       findme = cmd:sub(0, firstspace-1)
--    end
--    awful.util.spawn_with_shell("pgrep -u $USER -x " .. findme .. " > /dev/null || (g" .. cmd .. ")")
-- end


-- *** 利用notify显示工具，主要用于debug *** ---
function fftf_nprint(titlestr, textstr)
   naughty.notify({ preset = naughty.config.presets.critical,
		    title = tostring(titlestr),
		    text = tostring(textstr),
		    timeout = 5})
end

-- *** 专用与debug*** --
function fftf_dprint(s)
   fftf_nprint("Debug print...", s)
end
