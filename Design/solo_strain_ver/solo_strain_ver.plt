#!/usr/bin/gnuplot
load "../style.gnu"

set grid
set output "solo_strain_ver.eps"
set datafile separator ","

set key at graph 0.92,0.98

set key samplen 2
set key reverse
set key Left
set key font "Helvetica,24"
set size 0.8,0.7

set xrange [0:40]
set xtics 10
set yrange [-0.02:0.4]
set ytics 0.1

set y2range [-9:180]
set y2tics 60

set xlabel "Time(sec)" offset 0,0.2
set ylabel "R Change Ratio" offset 1,0
set y2label "Angle (degree)" offset -1,0

plot "test_day_vertical_strain_right_per.csv" using 1:2 title "Strain Sensor" w l ls 10, \
"output_ver_strain_right.csv" using 1:2 axis x1y2 title "Kinect" w l ls 19, \

   