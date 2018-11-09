#!/usr/bin/gnuplot
load "../style.gnu"

set grid
set output "kinect.eps"
set datafile separator ","

set key at graph 1.05,0.98
set key samplen 2
set key reverse
set key Left
set key font "Helvetica,24"
set size 0.8,0.7

set xrange [3:40]
set xtics 10
set yrange [-5:150]
set ytics 30

set xlabel "Time(sec)" offset 0,0.2
set ylabel "Angle(degree)" offset 1,0

plot "output_hor_strain_mid_1.csv" using 1:2 title "Strain Sensor" w l ls 24

   