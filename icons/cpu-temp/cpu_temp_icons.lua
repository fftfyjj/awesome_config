cpu_temp_icons_full = fftf_home .. "/.config/awesome/icons/cpu-temp/thermal_full_r.png"
cpu_temp_icons_low = fftf_home .. "/.config/awesome/icons/cpu-temp/thermal_low_r.png"
cpu_temp_icons_medium = fftf_home .. "/.config/awesome/icons/cpu-temp/thermal_medium_r.png"
cpu_temp_icons_danger = fftf_home .. "/.config/awesome/icons/cpu-temp/thermal_weixian_r.png"
cpu_temp_icons_cool = fftf_home .. "/.config/awesome/icons/cpu-temp/thermal_zero_r.png"
cpu_temp_icons_death = fftf_home .. "/.config/awesome/icons/cpu-temp/emblem-important.svg"



cpu_temp_icons_status_table = {
   {15, cpu_temp_icons_cool},
   -- {35, cpu_temp_icons_low},
   {35, cpu_temp_icons_cool},
   -- {50, cpu_temp_icons_medium},
   {55, cpu_temp_icons_low},
   {75, cpu_temp_icons_full},
   {90, cpu_temp_icons_danger},
   {120, cpu_temp_icons_death}
}
