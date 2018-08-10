#!/usr/bin/gnuplot
load "../style.gnu"

set grid
set output "solo_strain_hor.eps"
set datafile separator ","

set key at graph 1.05,0.98
set key samplen 2
set key reverse
set key Left
set key font "Helvetica,24"
set size 0.8,0.7

set xrange [0:36]
set xtics 10
set yrange [-0.01:0.18]
set ytics 0.05

set y2range [0:180]
set y2tics 30


set xlabel "Time(sec)" offset 0,0.2
set ylabel "R Change Ratio" offset 1,0

plot "test_day_hor_strain_mid_per.csv" using 1:2 title "Strain Sensor" w l ls 10, \
"output_hor_strain_mid_1.csv" using 1:2 axis x1y2 title "Kinect" w l ls 19, \


   