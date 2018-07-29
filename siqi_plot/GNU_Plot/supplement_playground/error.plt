load "style.gnu"

set grid
set output "statdata.eps"

unset key 
set auto fix 
set offsets 2,2,2,2 
set errorbars lw 3 lt 1 lc rgbcolor("orchid4") 2 
plot "statdata" with xyerrorlines, "" ps 3 pt 7