#!/usr/bin/gnuplot
load "../style.gnu"

set grid
set output "vertical.eps"
set datafile separator ","

set key at graph 1.08,0.95
set key samplen 2
set key reverse
set key Left
set key font "Helvetica,24"
set size 0.8,0.7

set xrange [0:40]
set xtics 10
set yrange [-0.02:0.4]
set ytics 0.1

set xlabel "Time(sec)" offset 0,0.2
set ylabel "R Change Ratio" offset 1,0

plot "test_day_vertical_strain_right_per.csv" using 1:2 title "Strain Sensor" w l ls 24

   