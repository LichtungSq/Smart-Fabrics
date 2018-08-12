#!/usr/bin/gnuplot
load "../style.gnu"

set grid
set output "solo_pressure.eps"
set datafile separator ","

set key top outside horizontal center
set key box
set key samplen 2
set key reverse
set key Left
set key font "Helvetica,24"
set size 0.8,0.7

set xrange [0:37]
set xtics 10
set yrange [-0.3:0.4]
set ytics 0.2

set xlabel "Time(sec)" offset 0,0.2
set ylabel "R Change Ratio" offset 1,0
set y2label "Angle (degree)" offset -1,0

set y2range [0:140]
set y2tics 40

plot "test_day_pressure_mid_per.csv" using 1:2 title "Middle" w l ls 10, \
 "test_day_pressure_left_per.csv" using 1:2 title "Left" w l ls 11, \
"test_day_pressure_right_per.csv" using 1:2 title "Right" w l ls 12, \
"output_mid_pressure_1.csv" using 1:2 axis x1y2 title "Kinect-Middle" w l ls 16, \
"output_left_pressure_1.csv" using 1:2 axis x1y2 title "Kinect-Left" w l ls 17, \
"output_right_pressure_1.csv" using 1:2 axis x1y2 title "Kinect-Right" w l ls 18, \

   