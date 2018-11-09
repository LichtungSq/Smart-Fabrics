#!/usr/bin/gnuplot
load "../style.gnu"

set grid
set output "horizontal.eps"
set datafile separator ","

set key at graph 1.08,0.96
set key samplen 2
set key reverse
set key Left
set key font "Helvetica,24"
set size 0.8,0.7

set xrange [0:36]
set xtics 10
set yrange [-0.01:0.16]
set ytics 0.05

set xlabel "Time(sec)" offset 0,0.2
set ylabel "R Change Ratio" offset 1,0

plot "test_day_hor_strain_mid_per.csv" using 1:2 title "Strain Sensor" w l ls 24

   