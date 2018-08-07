#!/usr/bin/gnuplot
load "../style.gnu"

set grid
set output "pre_2_layer.eps"
set datafile separator ","
set key spacing 1.2
set key at graph 0.9,0.25
set key samplen 2

set key reverse
set key Left
set key font "Helvetica,22"
set size 0.8,0.7

set xrange [0:30]
set xtics 10
set yrange [-1.0:0.1]
set ytics 0.2

set xlabel "Time(sec)" offset 0,0.2
set ylabel "R Change Ratio" offset 1,0

plot "pre_2_layer_sg.csv" using 1:2 title "Sensor with 2 layers" w l ls 24

   