#!/usr/bin/gnuplot
load "../style.gnu"

set grid
set output "pressure.eps"
set datafile separator ","

set key at graph 0.98,0.97
set key samplen 2
set key spacing 1
set key reverse
set key Left
set key font "Helvetica,24"
set size 0.8,0.7

set xrange [0:2]
set xtics 0.5
set yrange [-1.0:0.2]
set ytics 0.2

set xlabel "Pressing Distance(mm)" offset 0,0.2
set ylabel "R Change Ratio" offset 1,0

plot "pre_1_layer_sg.csv" using 1:2 title "Sample 1" w l ls 10,\
"pre_2_layer_sg.csv" using 1:2 title "Sample 2" w l ls 11,\
"silver_pre_2_layer_sg.csv" using 1:2 title "Sample 3" w l ls 12,\
"thick_pre_2_layer_sg.csv" using 1:2 title "Sample 4" w l ls 13


   