#!/usr/bin/gnuplot
load "../style.gnu"

set grid
set output "kinect.eps"
set datafile separator ","

set key at graph 0.99,0.98
set key box
set key samplen 2
set key reverse
set key Left
set key font "Helvetica,24"
set size 0.8,0.7

set xrange [3:40]
set xtics 10
set yrange [-5:180]
set ytics 60

set xlabel "Time(sec)" offset 0,0.2
set ylabel "Angle(degree)" offset 1,0

plot "output_mid_pressure_1.csv" using 1:2 title "Middle" w l ls 10, \
"output_left_pressure_1.csv" using 1:2 title "Left" w l ls 11, \
"output_right_pressure_1.csv" using 1:2 title "Right" w l ls 12, \

   